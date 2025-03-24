<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Location;

class LocationController extends Controller
{
    public function getProvinces()
    {
        return response()->json(Location::where('type', 'Province')->get());
    }

    public function getCities($provinceCode)
    {
        return response()->json(Location::where('type', 'Municipality')->where('parent_code', $provinceCode)->get());
    }

    public function getBarangays($cityMunCode)
    {
        return response()->json(Location::where('type', 'Barangay')->where('parent_code', $cityMunCode)->get());
    }
}

