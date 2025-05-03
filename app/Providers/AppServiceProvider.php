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
            $factory = (new Factory)
                ->withServiceAccount(config('firebase'))
                ->withProjectId(env('FIREBASE_PROJECT_ID'));
    
            return $factory->createAuth();
        });
    }

    public function boot()
    {
        //
    }
}
