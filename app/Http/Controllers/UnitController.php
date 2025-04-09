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
    $unitGroups = DB::table('units')
    ->select(
        DB::raw('MIN(id) as id'),
        'unit_code',
        DB::raw('MAX(capacity) as max_capacity'),
        DB::raw('MIN(price) as min_price'),
        DB::raw('MAX(price) as max_price'),
        DB::raw('GROUP_CONCAT(DISTINCT stay_type) as stay_types'),
        DB::raw('GROUP_CONCAT(status) as statuses'),
        DB::raw("IF(SUM(status = 'available') > 0, 'available', 'unavailable') as overall_status")
    )
        ->groupBy('unit_code')
        ->get();

    // Map through each unit_code group to compute additional data
    $unitGroups = $unitGroups->map(function ($unit) {
        // Count only monthly tenants for this unit_code
        $monthly_users_count = DB::table('users')
            ->whereIn('unit_id', function ($query) use ($unit) {
                $query->select('id')
                    ->from('units')
                    ->where('unit_code', $unit->unit_code)
                    ->where('stay_type', 'monthly'); // Only monthly
            })->count();

        // Determine base price (price with matching capacity)
        $base_unit = DB::table('units')
            ->where('unit_code', $unit->unit_code)
            ->where('stay_type', 'monthly')
            ->where('capacity', '>=', $monthly_users_count)
            ->orderBy('capacity') // Get the closest match
            ->first();

        $unit->monthly_users_count = $monthly_users_count;
        $unit->base_price = $base_unit ? $base_unit->price : null;

        return $unit;
    });

    return response()->json($unitGroups);
}

public function getUnitsByCode($unit_code)
{
    $units = Unit::where('unit_code', $unit_code)->get();
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
