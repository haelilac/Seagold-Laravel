<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;
use Illuminate\Support\Facades\File;

class AppServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(Auth::class, function () {
            $json = env('FIREBASE_CREDENTIALS_JSON');
            $tmpJsonPath = storage_path('app/firebase_tmp.json');
            file_put_contents($tmpJsonPath, $json);
    
            return (new Factory)
                ->withServiceAccount($tmpJsonPath)
                ->createAuth();
        });
    }

    public function boot() {}
}