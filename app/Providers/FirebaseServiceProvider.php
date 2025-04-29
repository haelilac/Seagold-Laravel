<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Services\FirebaseService;

class FirebaseServiceProvider extends ServiceProvider
{
    public function register()
    {
        // Register FirebaseService as a singleton
        $this->app->singleton(FirebaseService::class, function ($app) {
            return new FirebaseService();
        });
    }

    public function boot()
    {
        //
    }
}
