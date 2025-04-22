<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\Gallery;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use App\Events\GalleryImageUploaded;
class GalleryController extends Controller
{
    // Fetch all images
public function index()
{
    $images = Gallery::all()->map(function ($image) {
        return [
            'id' => $image->id,
            'title' => $image->title,
            'description' => $image->description,
            'category' => $image->category,
            'image_url' => $image->image_path, // ✅ Assuming this stores Cloudinary URL
        ];
    });

    return response()->json(['images' => $images], 200);
}

    // Upload a new image
    public function store(Request $request)
    {
        $validated = $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|string|max:255',
        ]);
    
        try {
            $uploadedFileUrl = Cloudinary::upload(
                $request->file('image')->getRealPath(),
                ['folder' => 'gallery']
            )->getSecurePath();
    
            $image = Gallery::create([
                'image_path' => $uploadedFileUrl,
                'title' => $validated['title'],
                'description' => $validated['description'],
                'category' => $validated['category'],
            ]);
    
            event(new GalleryImageUploaded($image));
    
            return response()->json([
                'message' => 'Image uploaded successfully!',
                'image' => $image
            ], 201);
        } catch (\Exception $e) {
            \Log::error('Cloudinary upload failed: ' . $e->getMessage());
            return response()->json(['message' => 'Image upload failed. ' . $e->getMessage()], 500);
        }
    }
    

    // Update image details
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|string|max:255',
        ]);

        $image = Gallery::find($id);

        if (!$image) {
            return response()->json(['message' => 'Image not found.'], 404);
        }

        $image->update($validated);

        return response()->json(['message' => 'Image updated successfully!', 'image' => $image], 200);
    }

    // Delete an image
    public function destroy($id)
    {
        $image = Gallery::find($id);

        if (!$image) {
            return response()->json(['message' => 'Image not found.'], 404);
        }

        // Delete the image from storage
        Storage::disk('public')->delete($image->image_path);

        $image->delete();

        return response()->json(['message' => 'Image deleted successfully!'], 200);
    }
}
