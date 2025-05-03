<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
*/

// For generic Laravel auth model broadcasts
Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

// ✅ Private tenant-specific notifications
Broadcast::channel('tenant.notifications.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id && $user->role === 'tenant';
});

// ✅ Private admin notifications (should also be private, not public)
Broadcast::channel('admin.notifications', function ($user) {
    return $user->role === 'admin';
});

// ✅ Register broadcast auth route once — no need to call it twice
Broadcast::routes(['middleware' => ['auth:api']]);

// ✅ Explicit fallback for auth endpoint (optional, but safe)
Route::post('/broadcasting/auth', function (Request $request) {
    return Broadcast::auth($request);
})->middleware('auth:api');
