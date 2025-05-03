<?php

namespace App\Http\Controllers;

use App\Events\NewTenantNotificationEvent;
use Illuminate\Http\Request;
use App\Models\MaintenanceRequest;
use App\Models\Notification;
use App\Models\User;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use Illuminate\Support\Facades\Log;
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
            'files'      => 'nullable|array',
            'files.*'    => 'file|mimes:jpg,jpeg,png,mp4|max:20480',
            'schedule'   => 'nullable|date_format:Y-m-d H:i:s',
        ]);
    
        $maintenanceRequest = MaintenanceRequest::create([
            'user_id'    => $validated['user_id'],
            'category'   => $validated['category'],
            'description'=> $validated['description'],
            'status'     => $validated['status'] ?? 'pending',
            'schedule'   => $validated['schedule'] ?? null,
        ]);
    
        if ($request->hasFile('files')) {
            foreach ($request->file('files') as $file) {
                $upload = Cloudinary::upload($file->getRealPath(), [
                    'folder' => 'maintenance_reports',
                    'resource_type' => 'auto'
                ]);
                \App\Models\MaintenanceFile::create([
                    'maintenance_request_id' => $maintenanceRequest->id,
                    'file_path' => $upload->getSecurePath(),
                    'cloudinary_public_id' => $upload->getPublicId(),
                ]);
            }
        }
    
        $tenant = User::with('unit')->find($validated['user_id']);
        $unitCode = optional($tenant->unit)->unit_code;
        $message = "🛠️ Maintenance request from {$tenant->name} (Unit: {$unitCode})";
    
        $this->notifyAdmins('New Maintenance Request', $message, 'maintenance_request');
        Notification::create([
            'user_id' => $tenant->id,
            'title'   => 'Maintenance Request Submitted',
            'message' => 'Your maintenance request has been submitted successfully.',
            'type'    => 'maintenance',
            'is_read' => false,
        ]);
        
        broadcast(new NewTenantNotificationEvent(
            $tenant->id,
            'Maintenance Request Submitted',
            'Your maintenance request has been submitted successfully.',
            now()->format('M d, Y - h:i A'),
            'maintenance'
        ));
        
        return response()->json(['maintenance_request' => $maintenanceRequest], 201);
    }

    // Fetch notifications for the tenant
    public function getNotifications(Request $request)
    {
        $notifications = Notification::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($notifications);
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
        Notification::create([
            'user_id' => $maintenanceRequest->user_id,
            'title'   => 'Follow-Up Sent',
            'message' => 'Your maintenance follow-up was sent to the admins.',
            'type'    => 'maintenance',
            'is_read' => false,
        ]);
        
        broadcast(new NewTenantNotificationEvent(
            $maintenanceRequest->user_id,
            'Follow-Up Sent',
            'Your maintenance follow-up was sent to the admins.',
            now()->format('M d, Y - h:i A'),
            'maintenance'
        ));
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
            ->get();
    
        Log::info('Fetched Maintenance Requests:', ['requests' => $maintenanceRequests]);
    
        $maintenanceRequests = $maintenanceRequests->map(function ($request) {
            $request->unit_code = optional($request->user->unit)->unit_code;
            return $request;
        });
    
        return response()->json($maintenanceRequests);
    }
    

    public function updateStatus(Request $request, $id)
    {
        $validated = $request->validate([
            'status' => 'required|string|in:pending,in_progress,completed,cancelled,rejected'
        ]);
    
        $maintenanceRequest = MaintenanceRequest::findOrFail($id);
        $maintenanceRequest->update(['status' => $validated['status']]);
    
        if (in_array($validated['status'], ['rejected', 'cancelled'])) {
            $tenant = User::find($maintenanceRequest->user_id);
    
            $title = $validated['status'] === 'cancelled'
                ? 'Maintenance Request Cancelled'
                : 'Maintenance Request Rejected';
    
            $message = $validated['status'] === 'cancelled'
                ? 'Your maintenance request was cancelled by the admin.'
                : 'Your maintenance request was rejected by the admin.';
    
            Notification::create([
                'user_id' => $tenant->id,
                'title'   => $title,
                'message' => $message,
                'is_read' => false,
            ]);
    
            broadcast(new NewTenantNotificationEvent(
                $tenant->id,
                $title,
                $message,
                now()->format('M d, Y - h:i A'),
                'maintenance' 
            ));
        }
    
        return response()->json(['message' => 'Status updated successfully.']);
    }
    
    
    public function schedule(Request $request, $id)
    {
        $validated = $request->validate([
            'schedule' => 'required|date_format:Y-m-d\TH:i',
        ]);
    
        $maintenanceRequest = MaintenanceRequest::findOrFail($id);
        $maintenanceRequest->update([
            'schedule' => $validated['schedule'],
            'status'   => 'scheduled',
        ]);
    
        $tenant = User::find($maintenanceRequest->user_id);
    
        Notification::create([
            'user_id' => $tenant->id,
            'title'   => 'Maintenance Scheduled',
            'message' => "Your maintenance request is scheduled for {$validated['schedule']}.",
            'type'    => 'maintenance',
            'is_read' => false,
        ]);
        
        broadcast(new NewTenantNotificationEvent(
            $tenant->id,
            'Maintenance Scheduled',
            "Your maintenance request is scheduled for {$validated['schedule']}.",
            now()->format('M d, Y - h:i A'),
            'maintenance'
        ));
    
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
    
        $maintenanceRequest->update(['status' => 'cancelled']);
    
        $tenant = User::findOrFail($maintenanceRequest->user_id);
    
        Notification::create([
            'user_id' => $tenant->id,
            'title' => 'Maintenance Request Cancelled',
            'message' => 'Your maintenance request has been cancelled.',
            'type'    => 'maintenance',
            'is_read' => false,
        ]);
    
        broadcast(new NewTenantNotificationEvent(
            $tenant->id,
            'Request Cancelled',
            'Your maintenance request has been cancelled.',
            now()->format('M d, Y - h:i A'),
            'maintenance' 
        ));
    
        return response()->json(['message' => 'Request cancelled successfully.']);
    }
    

    public function destroy($id)
    {
        $maintenanceRequest = MaintenanceRequest::find($id);
    
        if (!$maintenanceRequest) {
            return response()->json(['message' => 'Maintenance request not found.'], 404);
        }
    
        try {
            // 🔍 Delete associated Cloudinary files
            $files = \App\Models\MaintenanceFile::where('maintenance_request_id', $id)->get();
    
            foreach ($files as $file) {
                try {
                    Cloudinary::destroy($file->cloudinary_public_id);
                } catch (\Exception $e) {
                    Log::warning("Cloudinary delete failed (File ID: {$file->id}): " . $e->getMessage());
                }
            }
    
            // 🧹 Clean up local DB records
            \App\Models\MaintenanceFile::where('maintenance_request_id', $id)->delete();
    
            // ❌ Finally delete the request itself
            $maintenanceRequest->delete();
    
            return response()->json(['message' => 'Maintenance request and files deleted successfully.']);
    
        } catch (\Throwable $e) {
            Log::error("Error deleting maintenance request ID {$id}: " . $e->getMessage());
            return response()->json(['message' => 'Server error during deletion.'], 500);
        }
    }
}    