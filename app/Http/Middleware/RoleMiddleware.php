<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RoleMiddleware
{
    public function handle($request, Closure $next, $role): mixed
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }
    
        if ($request->user()->role !== $role) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
    
        return $next($request);
    }
    
}
