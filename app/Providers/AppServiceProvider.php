<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;
use Kreait\Firebase\ServiceAccount;

class AppServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(\Kreait\Firebase\Auth::class, function ($app) {
            $credentials = config('firebase');
            
            $factory = (new Factory)
                ->withServiceAccount(ServiceAccount::fromValue($credentials))
                ->withProjectId($credentials['project_id']);

            return $factory->createAuth();
        });
    }

    public function boot()
    {
        //
    }
}
