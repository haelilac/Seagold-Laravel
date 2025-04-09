<?php

namespace App\Http\Controllers;
use App\Models\Unit; // <-- Import the Unit model
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class UnitController extends Controller
{
    /**
     * Display a listing of the units.
     *
     * @return \Illuminate\Http\JsonResponse
     */

     public function assignUnit(Request $request)
     {
         $validated = $request->validate([
             'user_id' => 'required|exists:users,id',
             'unit_id' => 'required|exists:units,id',
         ]);
     
         // Unassign the tenant from any current unit before assigning a new one
         User::where('id', $validated['user_id'])->update(['unit_id' => null]);
     
         // Assign the tenant to the new unit
         $user = User::find($validated['user_id']);
         $user->unit_id = $validated['unit_id'];
         $user->save();
     
         return response()->json([
             'message' => 'Unit assigned to tenant successfully!',
             'user' => $user,
         ]);
     }
     
     public function getRoomPricingByUnit($unitCode)
{
    $pricing = DB::table('room_pricings')
        ->where('unit_code', $unitCode)
        ->get();

    return response()->json($pricing);
}

    public function getRoomPricing(Request $request)
    {
        $unitCode = $request->query('unit_code');
        $stayType = $request->query('stay_type');

        $pricing = DB::table('room_pricings')
            ->where('unit_code', $unitCode)
            ->where('stay_type', $stayType)
            ->get();

        return response()->json($pricing);
    }
     public function availableUnits()
{
    $units = Unit::where('status', 'available')->get();
    return response()->json($units);
}

public function updateUnitStatus(Request $request, $id)
{
    $unit = Unit::findOrFail($id);

    $validated = $request->validate([
        'status' => 'required|in:available,unavailable',
    ]);

    $unit->status = $validated['status'];
    $unit->save();

    return response()->json(['message' => 'Unit status updated successfully.', 'unit' => $unit]);
}

public function updateStatus(Request $request, $id)
{
    $unit = Unit::findOrFail($id);
    $validated = $request->validate([
        'status' => 'required|in:available,unavailable',
    ]);

    $unit->status = $validated['status'];
    $unit->save();

    return response()->json(['message' => 'Unit status updated successfully.', 'unit' => $unit]);
}

public function index()
{
    $roomPricings = \DB::table('room_pricings')
        ->select('unit_code', \DB::raw('MAX(capacity) as capacity'), \DB::raw('MAX(price) as price'))
        ->groupBy('unit_code')
        ->get();

    $units = [];

    foreach ($roomPricings as $item) {
        $unit = \App\Models\Unit::where('unit_code', $item->unit_code)->first();

        // Skip if no matching unit record (avoid null errors)
        if (!$unit) continue;

        $units[] = [
            'id' => $unit->id,
            'unit_code' => $item->unit_code,
            'name' => $unit->name,
            'capacity' => $item->capacity,
            'price' => $item->price,
            'users_count' => $unit->users()->count(),
            'status' => $unit->status,
        ];
    }

    return response()->json($units);
}


public function users()
{
    return $this->hasMany(User::class, 'unit_id');
}

    /**
     * Store a newly created unit in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        // Validate input
        $validated = $request->validate([
            'unit_code' => 'required|string|max:50|unique:units,unit_code',
            'name' => 'required|string|max:255',
            'capacity' => 'required|integer',
            'price' => 'required|numeric',
            'stay_type' => 'required|string|in:daily,weekly,half-month,monthly',
        ]);
    
        // Insert into database
        $unit = Unit::create($validated);
    
        return response()->json([
            'message' => 'Unit added successfully!',
            'unit' => $unit,
        ], 201);
    }
    
    /**
     * Display the specified unit.
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        // Fetch a specific unit by ID
        $unit = Unit::findOrFail($id);

        return response()->json($unit);
    }

    /**
     * Update the specified unit in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        // Fetch the unit by ID
        $unit = Unit::findOrFail($id);

        // Validate incoming request
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'capacity' => 'required|integer',
            'price' => 'required|numeric',
        ]);

        // Update the unit
        $unit->update($validated);

        return response()->json([
            'message' => 'Unit updated successfully!',
            'unit' => $unit,
        ]);
    }

    /**
     * Remove the specified unit from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        $unit = Unit::findOrFail($id);
    
        // Clear related assignments
        User::where('unit_id', $id)->update(['unit_id' => null]);
    
        // Delete the unit
        $unit->delete();
    
        return response()->json(['message' => 'Unit deleted successfully!']);
    }
    
}
