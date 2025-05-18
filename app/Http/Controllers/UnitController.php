<?php

namespace App\Http\Controllers;

use App\Models\Unit;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use App\Models\UnitImage;
use App\Models\Application;

class UnitController extends Controller
{
    // ✅ Upload Room Image
    public function uploadRoomImage(Request $request)
    {
        $validated = $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'unit_code' => 'required|string',
        ]);

        $uploadedUrl = Cloudinary::upload($request->file('image')->getRealPath(), [
            'folder' => 'room_images'
        ])->getSecurePath();

        DB::table('unit_images')->insert([
            'unit_code' => $validated['unit_code'],
            'image_path' => $uploadedUrl,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Room image uploaded!', 'image_url' => $uploadedUrl]);
    }

    // ✅ Get Images for Unit
    public function getUnitImages($unit_code)
    {
        $images = DB::table('unit_images')->where('unit_code', $unit_code)->get();
        return response()->json($images);
    }

    // ✅ Delete Room Image
    public function deleteRoomImage($id)
    {
        $image = DB::table('unit_images')->find($id);

        if (!$image) {
            return response()->json(['message' => 'Image not found'], 404);
        }

        DB::table('unit_images')->where('id', $id)->delete();
        return response()->json(['message' => 'Image deleted successfully']);
    }

    // ✅ Assign Tenant to Unit
    public function assignUnit(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'unit_id' => 'required|exists:units,id',
        ]);

        User::where('id', $validated['user_id'])->update(['unit_id' => null]);

        $user = User::find($validated['user_id']);
        $user->unit_id = $validated['unit_id'];
        $user->save();

        return response()->json([
            'message' => 'Unit assigned to tenant successfully!',
            'user' => $user,
        ]);
    }

    // ✅ List Available Units
    public function availableUnits()
    {
        $units = Unit::where('status', 'available')->get();
        return response()->json($units);
    }
    public function getRoomPricing(Request $request)
    {
        $unitCode = $request->query('unit_code');
        $stayType = $request->query('stay_type');
    
        if (!$unitCode || !$stayType) {
            return response()->json(['message' => 'Missing parameters'], 400);
        }
    
        $unit = Unit::where('unit_code', $unitCode)
                    ->where('stay_type', $stayType)
                    ->first();
    
        if (!$unit) {
            return response()->json(['message' => 'No pricing data found'], 404);
        }
    
        return response()->json([[
            'unit_code' => $unit->unit_code,
            'stay_type' => $unit->stay_type,
            'price'     => $unit->price,
            'capacity'  => $unit->capacity,
        ]]);
    }
    
    // ✅ Update Unit Status (available/unavailable)
    public function updateUnitStatus(Request $request, $id)
    {
        $validated = $request->validate([
            'status' => 'required|in:available,unavailable',
        ]);

        $unit = Unit::findOrFail($id);
        $unitCode = $unit->unit_code;

        Unit::where('unit_code', $unitCode)->update(['status' => $validated['status']]);

        return response()->json([
            'message' => "Status updated for all units with code {$unitCode}.",
        ]);
    }

    // ✅ Shortcut: same as updateUnitStatus
    public function updateStatus(Request $request, $id)
    {
        return $this->updateUnitStatus($request, $id);
    }

    // ✅ ADMIN: Grouped Units for Admin Panel
    public function index()
    {
        $unitGroups = DB::table('units')
            ->select(
                DB::raw('MIN(id) as id'),
                'unit_code',
                DB::raw('MAX(max_capacity) as max_capacity'),
                DB::raw('MIN(price) as min_price'),
                DB::raw('MAX(price) as max_price'),
                DB::raw('GROUP_CONCAT(DISTINCT stay_type) as stay_types'),
                DB::raw('GROUP_CONCAT(status) as statuses'),
                DB::raw("IF(SUM(status = 'available') > 0, 'available', 'unavailable') as overall_status"),
                DB::raw('MAX(is_force_occupied) as is_force_occupied')
            )
            ->groupBy('unit_code')
            ->get();

        $unitGroups = $unitGroups->map(function ($unit) {
            $monthly_users_count = DB::table('users')
                ->whereIn('unit_id', function ($query) use ($unit) {
                    $query->select('id')
                        ->from('units')
                        ->where('unit_code', $unit->unit_code)
                        ->where('stay_type', 'monthly');
                })->count();

            $base_unit = DB::table('units')
                ->where('unit_code', $unit->unit_code)
                ->where('stay_type', 'monthly')
                ->where('capacity', '>=', $monthly_users_count)
                ->orderBy('capacity')
                ->first();

            $unit->images = DB::table('unit_images')
                ->where('unit_code', $unit->unit_code)
                ->get();
            $unit->pricing_image = $unit->images->firstWhere('is_pricing', true);
            $unit->monthly_users_count = $monthly_users_count;
            $unit->base_price = $base_unit ? $base_unit->price : null;

            return $unit;
        });

        return response()->json($unitGroups);
    }

    // ✅ PUBLIC: Units for Public Website
    public function publicUnits()
    {
        $units = DB::table('units')
            ->select(
                DB::raw('MIN(id) as id'),
                'unit_code',
                DB::raw('MAX(max_capacity) as max_capacity'),
                DB::raw('MAX(is_force_occupied) as is_force_occupied') // 🔥 IMPORTANT!
            )
            ->groupBy('unit_code')
            ->get();

        foreach ($units as $unit) {
            $unit->images = DB::table('unit_images')
                ->where('unit_code', $unit->unit_code)
                ->get();
        }

        return response()->json($units);
    }

    // ✅ Force Occupy or Release Unit
    public function forceOccupy($id)
    {
        $unit = Unit::findOrFail($id);
        $unit->is_force_occupied = !$unit->is_force_occupied;
        $unit->save();

        return response()->json(['message' => 'Unit force occupancy updated!', 'unit' => $unit]);
    }

    // ✅ Get Units by Code
    public function getUnitsByCode($unit_code)
    {
        $units = Unit::where('unit_code', $unit_code)->get();
        return response()->json($units);
    }

    public function getTenantsByUnitCode($unit_code)
{
    $unitIds = Unit::where('unit_code', $unit_code)->pluck('id');

    $tenants = User::whereIn('unit_id', $unitIds)
        ->select('id', 'name', 'email', 'unit_id') // ✅ no more error
        ->get();

    return response()->json($tenants);
}

    // ✅ Store a New Unit
    public function store(Request $request)
    {
        $validated = $request->validate([
            'unit_code' => 'required|string|max:50|unique:units,unit_code',
            'capacity' => 'required|integer',
            'price' => 'required|numeric',
            'stay_type' => 'required|string|in:daily,weekly,half-month,monthly',
        ]);

        $unit = Unit::create($validated);

        return response()->json([
            'message' => 'Unit added successfully!',
            'unit' => $unit,
        ], 201);
    }

    // ✅ Show a Single Unit
    public function show($id)
    {
        $unit = Unit::findOrFail($id);
        return response()->json($unit);
    }

    // ✅ Update a Unit Info
    public function update(Request $request, $id)
    {
        $unit = Unit::findOrFail($id);

        $validated = $request->validate([
            'capacity' => 'required|integer',
            'max_capacity' => 'required|integer',
            'occupancy' => 'required|integer',
            'price' => 'required|numeric',
        ]);

        $unit->update($validated);

        event(new \App\Events\UnitUpdated($unit));

        return response()->json([
            'message' => 'Unit updated successfully!',
            'unit' => $unit,
        ]);
    }

    // ✅ Delete a Unit
    public function destroy($id)
    {
        $unit = Unit::findOrFail($id);

        User::where('unit_id', $id)->update(['unit_id' => null]);

        $unit->delete();

        return response()->json(['message' => 'Unit deleted successfully!']);
    }

    public function uploadPricingImage(Request $request)
{
    $validated = $request->validate([
        'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
        'unit_code' => 'required|string',
    ]);

    $uploadedUrl = Cloudinary::upload($request->file('image')->getRealPath(), [
        'folder' => 'pricing_images'
    ])->getSecurePath();

    DB::table('unit_images')->insert([
        'unit_code' => $validated['unit_code'],
        'image_path' => $uploadedUrl,
        'is_pricing' => true,
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json(['message' => 'Pricing image uploaded!', 'image_url' => $uploadedUrl]);
}


    // ✅ Tenant Room Info API
    public function tenantRoomInfo(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    
        $unit = Unit::find($user->unit_id);
    
        if (!$unit) {
            return response()->json(['error' => 'No assigned unit found'], 404);
        }
    
        $unitGroup = Unit::where('unit_code', $unit->unit_code)->get();
        $images = DB::table('unit_images')->where('unit_code', $unit->unit_code)->get();
    
        // ✅ Get the approved application for set_price
        $application = Application::where('email', $user->email)
            ->where('status', 'approved')
            ->latest()
            ->first();
    
        $setPrice = $application ? $application->set_price : null;
    
        return response()->json([
            'unit_code'    => $unit->unit_code,
            'stay_types'   => $unitGroup->pluck('stay_type')->unique()->values(),
            'capacity'     => $unitGroup->max('capacity'),
            'max_capacity' => $unitGroup->max('max_capacity'),
            'status'       => $unit->status,                     // ✅ already present
            'base_price'   => $unitGroup->where('stay_type', 'monthly')->min('price'),
            'set_price'    => $setPrice,                         // ✅ add to response
            'images'       => $images,
            'amenities'    => ['Air Conditioning', 'Private Bathroom', 'Wi-Fi', 'Study Table', 'Wardrobe']
        ]);
    }
}
