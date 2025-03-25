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

Route::get('/', function () {
    return view('welcome');
});

Route::get('/trigger-event', function () {
    event(new MyEvent('Hello, this is a test message!'));
    return 'Event has been triggered!';
});
Route::get('/test-db-connection', function () {
    try {
        DB::connection()->getPdo();
        return response()->json(['message' => 'Database connection is successful!'], 200);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Database connection failed!', 'error' => $e->getMessage()], 500);
    }
});