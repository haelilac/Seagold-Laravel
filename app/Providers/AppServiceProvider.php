<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;

class AppServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(\Kreait\Firebase\Auth::class, function ($app) {
            return (new Factory)
                ->withServiceAccount(storage_path('app/firebase-service-account.json'))
                ->createAuth();
        });
    }

    public function boot()
    {
        //
    }
}
