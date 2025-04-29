<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddIsPricingToUnitImagesTable extends Migration
{
    public function up()
    {
        Schema::table('unit_images', function (Blueprint $table) {
            $table->boolean('is_pricing')->default(false)->after('image_path');
        });
    }

    public function down()
    {
        Schema::table('unit_images', function (Blueprint $table) {
            $table->dropColumn('is_pricing');
        });
    }
}
