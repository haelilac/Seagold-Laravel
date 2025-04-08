<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\RoomPricing;

class RoomPricingController extends Controller
{
    public function getBrackets(Request $request)
    {
        $unitCode = $request->query('unit_code');
        $stayType = $request->query('stay_type');

        if (!$unitCode || !$stayType) {
            return response()->json(['error' => 'unit_code and stay_type are required'], 400);
        }

        $brackets = DB::table('room_pricings')
            ->where('unit_code', $unitCode)
            ->where('stay_type', $stayType)
            ->orderBy('min_capacity')
            ->get();

        return response()->json($brackets);
    }

        public function getRoomPricing($unitCode)
    {
        $pricings = RoomPricing::where('unit_code', $unitCode)->get();
        return response()->json($pricings);
    }
}
