<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('terminated_tenants', function (Blueprint $table) {
            $table->string('full_name')->nullable();
            $table->string('address')->nullable();
            $table->string('contact_number')->nullable();
            $table->date('check_in_date')->nullable();
            $table->integer('duration')->nullable();
            $table->string('occupation')->nullable();
            $table->string('unit_id')->nullable();
            $table->string('valid_id_url')->nullable();
            $table->timestamps();
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('terminated_tenants', function (Blueprint $table) {
            //
            $table->dropTimestamps();
        });
    }
};
