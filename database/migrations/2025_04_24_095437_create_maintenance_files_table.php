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
        Schema::create('maintenance_files', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('maintenance_request_id');  // Explicit type
            $table->string('file_path');
            $table->string('cloudinary_public_id');
            $table->timestamps();
        
            $table->foreign('maintenance_request_id')
                  ->references('id')
                  ->on('maintenance_requests')
                  ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('maintenance_files');
    }
};
