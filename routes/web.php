<?php

use Illuminate\Support\Facades\Route;
use App\Events\MyEvent;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Response;

Route::get('/uploads/{folder}/{filename}', function ($folder, $filename) {
    $path = "uploads/$folder/$filename";

    if (!Storage::disk('public')->exists($path)) {
        abort(404);
    }

    $file = Storage::disk('public')->get($path);
    $type = Storage::disk('public')->mimeType($path);

    return Response::make($file, 200)->header("Content-Type", $type);
});

Route::get('/view-file/{folder}/{filename}', function ($folder, $filename) {
    $safeFolders = ['valid_ids', 'gallery', 'photos', 'receipts'];
    if (!in_array($folder, $safeFolders)) abort(403);

    $path = storage_path("app/public/{$folder}/{$filename}");
    if (!file_exists($path)) abort(404);

    return response()->file($path);
});
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
Route::get('/sanctum/csrf-cookie', function () {
    return response()->json(['message' => 'CSRF cookie set']);
});
