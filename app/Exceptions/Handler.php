<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Throwable;

class Handler extends ExceptionHandler
{
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }

    public function render($request, Throwable $exception)
    {
        // ✅ Return JSON on validation failures for API routes
        if ($exception instanceof ValidationException && $request->is('api/*')) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $exception->errors(),
            ], 422);
        }
    
        $response = parent::render($request, $exception);
    
        // 👇 Force CORS headers for API responses even on error
        if ($request->is('api/*')) {
            $response->headers->set('Access-Control-Allow-Origin', '*'); 
            $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
            $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        }
    
        return $response;
    }
}
