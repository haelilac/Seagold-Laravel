<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\MaintenanceRequest;
use Illuminate\Support\Facades\Log;
use App\Models\Notification;
use App\Models\User;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use App\Events\NewAdminNotificationEvent;

class MaintenanceRequestController extends Controller
{
    // Store a new maintenance request
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id'    => 'required|integer|exists:users,id',
            'category'   => 'required|string|max:100',
            'description'=> 'required|string',
            'status'     => 'nullable|string|in:pending,in_progress,completed,rejected',
            'files'   => 'nullable|array',
            'files.*' => 'file|mimes:jpg,jpeg,png,mp4|max:20480',
            'schedule'   => 'nullable|date_format:Y-m-d H:i:s',
        ]);
    
        Log::info('Incoming Request Data:', [
            'user_id'    => $request->input('user_id'),
            'category'   => $request->input('category'),
            'description'=> $request->input('description'),
            'status'     => $request->input('status'),
            'schedule'   => $request->input('schedule'),
            'file_uploaded' => $request->hasFile('files') 
                ? implode(', ', array_map(function($file) { return $file->getClientOriginalName(); }, $request->file('files')))
                : 'No file'
        ]);
    
        $maintenanceRequest = MaintenanceRequest::create([
            'user_id'    => $validated['user_id'],
            'category'   => $validated['category'],
            'description'=> $validated['description'],
            'status'     => $validated['status'] ?? 'pending',
            'schedule'   => $validated['schedule'] ?? null,
        ]);

        if ($request->hasFile('files')) {
            $files = $request->file('files');
        
            // Ensure $files is always an array
            if (!is_array($files)) {
                $files = [$files];
            }
        
            Log::info('Files Detected:', ['count' => count($files)]);
        
            foreach ($files as $file) {
                $upload = Cloudinary::upload($file->getRealPath(), [
                    'folder' => 'maintenance_reports',
                    'resource_type' => 'auto'
                ]);
        
                \App\Models\MaintenanceFile::create([
                    'maintenance_request_id' => $maintenanceRequest->id,
                    'file_path'              => $upload->getSecurePath(),
                    'cloudinary_public_id'   => $upload->getPublicId(),
                ]);
            }
        }

        $tenant = User::with('unit')->find($validated['user_id']);
        $unitCode = optional($tenant->unit)->unit_code;
        $tenantName = $tenant->name;

        $this->notifyAdmins(
            'New Maintenance Request',
            "🛠️ Maintenance request from $tenantName (Unit: $unitCode)",
            'maintenance_request'
        );

        Log::info('✅ Maintenance notifications sent to admins.');

        return response()->json($maintenanceRequest->load('files'), 201);
    }

    private function notifyAdmins($title, $message, $type)
    {
        $admins = User::where('role', 'admin')->get();

        foreach ($admins as $admin) {
            $notif = Notification::create([
                'user_id' => $admin->id,
                'title'   => $title,
                'message' => $message,
                'type'    => $type,
                'is_read' => false,
            ]);

            broadcast(new NewAdminNotificationEvent(
                $notif->message,
                $notif->type,
                $notif->created_at->format('M d, Y - h:i A')
            ))->toOthers();
        }

        Log::info("✅ $type notification sent to admins.");
    }

    public function followUp($id)
    {
        $maintenanceRequest = MaintenanceRequest::with('user')->findOrFail($id);

        $tenantName = $maintenanceRequest->user->name;
        $unitCode = optional($maintenanceRequest->user->unit)->unit_code;

        $this->notifyAdmins(
            'Maintenance Follow-Up',
            "🔔 Follow-up: $tenantName (Unit: $unitCode) is requesting an update on Maintenance ID #$id",
            'maintenance_follow_up'
        );

        return response()->json(['message' => 'Follow-up notification sent to admin.']);
    }

    public function cancel($id)
    {
        $request = MaintenanceRequest::findOrFail($id);
        $request->update(['status' => 'cancelled']);

        return response()->json(['message' => 'Maintenance request has been cancelled successfully.']);
    }

    public function index()
    {
        $maintenanceRequests = MaintenanceRequest::with(['user:id,name,unit_id', 'user.unit:id,unit_code', 'files']) 
            ->select('id', 'user_id', 'category', 'description', 'status', 'schedule', 'created_at', 'updated_at')
            ->get()
            ->map(function ($request) {
                $request->unit_code = optional($request->user->unit)->unit_code;
                return $request;
            });
    
        return response()->json($maintenanceRequests);
    }

    public function updateStatus(Request $request, $id)
    {
        $validated = $request->validate(['status' => 'required|string|in:pending,in_progress,completed,cancelled']);

        $maintenanceRequest = MaintenanceRequest::findOrFail($id);
        $maintenanceRequest->update(['status' => $validated['status']]);

        if ($validated['status'] === 'completed') {
            $tenant = User::findOrFail($maintenanceRequest->user_id);
            Notification::create([
                'user_id' => $tenant->id,
                'title'   => 'Maintenance Completed',
                'message' => 'Your maintenance request has been completed.',
                'is_read' => false,
            ]);
        }

        return response()->json(['message' => 'Status updated successfully.']);
    }

    public function schedule(Request $request, $id)
    {
        $validated = $request->validate([
            'schedule' => 'required|date_format:Y-m-d\TH:i',
        ]);

        Log::info('Schedule Input:', ['schedule' => $validated['schedule']]);

        $maintenanceRequest = MaintenanceRequest::findOrFail($id);
        $maintenanceRequest->update([
            'schedule' => $validated['schedule'],
            'status'   => 'scheduled'
        ]);

        $tenant = User::findOrFail($maintenanceRequest->user_id);
        Notification::create([
            'user_id' => $tenant->id,
            'title'   => 'Maintenance Scheduled',
            'message' => "Your maintenance request has been scheduled for {$validated['schedule']}.",
            'is_read' => false,
        ]);

        return response()->json(['message' => 'Maintenance scheduled successfully.']);
    }

    public function tenantRequests(Request $request)
    {
        $userId = $request->user()->id;

        $requests = MaintenanceRequest::with('files')
            ->where('user_id', $userId)
            ->select('id', 'description', 'status', 'schedule', 'created_at')
            ->get();

        return response()->json($requests);
    }

    public function cancelRequest($id)
    {
        $maintenanceRequest = MaintenanceRequest::findOrFail($id);

        if ($maintenanceRequest->status === 'completed') {
            return response()->json(['message' => 'Cannot cancel a completed request.'], 400);
        }

        $maintenanceRequest->delete();

        $tenant = User::findOrFail($maintenanceRequest->user_id);
        Notification::create([
            'user_id' => $tenant->id,
            'title'   => 'Maintenance Request Cancelled',
            'message' => 'Your maintenance request has been cancelled or rejected by the admin.',
            'is_read' => false,
        ]);

        return response()->json(['message' => 'Request cancelled successfully.']);
    }

    public function destroy($id)
    {
        $maintenanceRequest = MaintenanceRequest::find($id);

        if (!$maintenanceRequest) {
            return response()->json(['message' => 'Maintenance request not found.'], 404);
        }

        if ($maintenanceRequest->cloudinary_public_id) {
            try {
                Cloudinary::destroy($maintenanceRequest->cloudinary_public_id);
            } catch (\Exception $e) {
                Log::error("Cloudinary delete error: " . $e->getMessage());
            }
        }

        $files = \App\Models\MaintenanceFile::where('maintenance_request_id', $maintenanceRequest->id)->get();

        foreach ($files as $file) {
            try {
                Cloudinary::destroy($file->cloudinary_public_id);
            } catch (\Exception $e) {
                Log::error("Cloudinary delete error (File ID {$file->id}): " . $e->getMessage());
            }
        }

        \App\Models\MaintenanceFile::where('maintenance_request_id', $maintenanceRequest->id)->delete();
        $maintenanceRequest->delete();

        return response()->json(['message' => 'Maintenance request deleted successfully.']);
    }
}
