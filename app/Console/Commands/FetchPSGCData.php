<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use App\Models\Location;

class FetchPSGCData extends Command
{
    protected $signature = 'psgc:fetch';
    protected $description = 'Fetch locations from the PSGC API';

    public function handle()
    {
        $this->fetchAndStore('https://psgc.gitlab.io/api/provinces/', 'Province');
        $this->fetchAndStore('https://psgc.gitlab.io/api/cities-municipalities/', 'Municipality');
        $this->fetchAndStore('https://psgc.gitlab.io/api/barangays/', 'Barangay');

        $this->info('PSGC Data has been fetched and stored.');
    }

    private function fetchAndStore($url, $type)
    {
        $response = Http::get($url);
        if ($response->successful()) {
            foreach ($response->json() as $item) {
                Location::updateOrCreate(
                    ['code' => $item['code']],
                    [
                        'name' => $item['name'],
                        'type' => $type,
                        'parent_code' => $item['provinceCode'] ?? $item['cityMunCode'] ?? null,
                    ]
                );
            }
        }
    }
}
