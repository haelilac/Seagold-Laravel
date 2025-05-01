<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AmenityRequest;

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
        $request->save();

        // Optional: Link to room_amenities table here

        return response()->json(['message' => 'Amenity request approved.']);
    }

    /**
     * Admin rejects a request
     */
    public function reject($id)
    {
        $request = AmenityRequest::findOrFail($id);
        $request->status = 'rejected';
        $request->save();

        return response()->json(['message' => 'Amenity request rejected.']);
    }
}