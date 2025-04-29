<?php

namespace App\Providers;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Storage;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */

     public function register()
{
    $this->app->singleton(Auth::class, function ($app) {
        return (new Factory)
            ->withServiceAccount(config('app.firebase_credentials'))
            ->createAuth();
    });
}

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
