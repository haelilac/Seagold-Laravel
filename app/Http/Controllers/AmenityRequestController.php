<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AmenityRequest;
use App\Events\NewTenantNotificationEvent;
use App\Models\User;
class AmenityRequestController extends Controller
{
    /**
     * Tenant submits an amenity request
     */
    public function store(Request $request)
    {
        $request->validate([
            'amenity_type' => 'required|string|max:255',
        ]);

        AmenityRequest::create([
            'tenant_id' => auth()->id(),
            'amenity_type' => $request->amenity_type,
        ]);

        return response()->json(['message' => 'Amenity request submitted successfully.'], 201);
    }

    /**
     * List amenity requests
     * Admin sees all, tenant sees their own
     */
    public function index()
    {
        if (auth()->user()->role === 'admin') {
            $requests = AmenityRequest::with('tenant')->get();
        } else {
            $requests = AmenityRequest::where('tenant_id', auth()->id())->get();
        }

        return response()->json($requests);
    }

    /**
     * Admin approves a request
     */
    public function approve($id)
    {
        $request = AmenityRequest::findOrFail($id);
        $request->status = 'approved';
        $request->approved_at = now(); // optional if you store approval timestamp
        $request->save();
    
        $tenant = User::find($request->tenant_id);
    
        // ✅ Notify tenant
        broadcast(new NewTenantNotificationEvent(
            $tenant->id,
            'Amenity Request Approved',
            "Your request for '{$request->amenity_type}' has been approved.",
            now()->format('M d, Y - h:i A'),
            'amenity' // 🔑 include type for frontend routing
        ));
    
        return response()->json(['message' => 'Amenity request approved.']);
    }
    
    public function reject($id)
    {
        $request = AmenityRequest::findOrFail($id);
        $request->status = 'rejected';
        $request->save();
    
        $tenant = User::find($request->tenant_id);
    
        // ✅ Notify tenant
        broadcast(new NewTenantNotificationEvent(
            $tenant->id,
            'Amenity Request Rejected',
            "Your request for '{$request->amenity_type}' was rejected by the admin.",
            now()->format('M d, Y - h:i A'),
            'amenity'
        ));
    
        return response()->json(['message' => 'Amenity request rejected.']);
    }
}