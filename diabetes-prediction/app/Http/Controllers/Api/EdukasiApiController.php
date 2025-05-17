<?php  
namespace App\Http\Controllers\Api;  
use App\Http\Controllers\Controller; 
use Illuminate\Support\Facades\DB;
use App\Models\EducationArticle;
use Exception;

class EdukasiApiController extends Controller {     
    public function index()     
    {   
        try {
            // Menggunakan model Eloquent daripada DB facade langsung
            $data = EducationArticle::latest('published_at')
                    ->where('status', 'published')
                    ->get();
                    
            return response()->json([
                'success' => true,
                'data' => $data
            ]);
        } catch (Exception $e) {
            // Log error untuk debugging
            \Log::error('Error in EdukasiApiController@index: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data edukasi',
                'error' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $article = EducationArticle::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'data' => $article
            ]);
        } catch (Exception $e) {
            \Log::error('Error in EdukasiApiController@show: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data edukasi',
                'error' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }
}