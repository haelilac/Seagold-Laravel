<?php

use Illuminate\Support\Facades\Route;
use App\Events\MyEvent;
use Illuminate\Support\Facades\DB;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/
Route::get('/test-db-connection', function () {
    try {
        $databaseName = DB::connection()->getDatabaseName();
        if ($databaseName) {
            return response()->json(['message' => "Successfully connected to the database: {$databaseName}"]);
        } else {
            return response()->json(['error' => 'Could not find the database.']);
        }
    } catch (\Exception $e) {
        return response()->json(['error' => 'Database connection failed: ' . $e->getMessage()]);
    }
});