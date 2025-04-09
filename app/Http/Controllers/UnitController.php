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
     
     public function availableUnits()
{
    $units = Unit::where('status', 'available')->get();
    return response()->json($units);
}

public function updateUnitStatus(Request $request, $id)
{
    $validated = $request->validate([
        'status' => 'required|in:available,unavailable',
    ]);

    $unit = Unit::findOrFail($id);
    $unitCode = $unit->unit_code;

    // Update all units with the same unit_code
    Unit::where('unit_code', $unitCode)->update(['status' => $validated['status']]);

    return response()->json([
        'message' => "Status updated for all units with code {$unitCode}.",
    ]);
}

public function updateStatus(Request $request, $id)
{
    return $this->updateUnitStatus($request, $id); // reuse the same logic
}


public function index()
{
    return response()->json([
        [
            'unit_code' => 'Room 1',
            'name' => 'Room 1',
            'max_capacity' => 3,
            'total_users_count' => 1,
            'status' => 'available'
        ],
        [
            'unit_code' => 'Room 2',
            'name' => 'Room 2',
            'max_capacity' => 2,
            'total_users_count' => 0,
            'status' => 'available'
        ],
    ]);
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
