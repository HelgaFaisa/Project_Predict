<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Gejala;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class GejalaApiController extends Controller
{
    /**
     * Get all gejala.
     *
     * @return JsonResponse
     */
    public function index(): JsonResponse
    {
        try {
            $gejala = Gejala::where('aktif', true)
                     ->select('_id', 'kode', 'nama', 'mb', 'md', 'aktif')
                     ->orderBy('kode')
                     ->get();
            
            return response()->json($gejala, 200);
        } catch (\Exception $e) {
            \Log::error('Error retrieving gejala: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to retrieve gejala data',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get gejala by ID.
     *
     * @param string $id
     * @return JsonResponse
     */
    public function show(string $id): JsonResponse
    {
        try {
            $gejala = Gejala::findOrFail($id);
            return response()->json($gejala, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gejala not found'], 404);
        }
    }
    
    /**
     * Get active gejala only.
     *
     * @return JsonResponse
     */
    public function aktif(): JsonResponse
    {
        try {
            $gejala = Gejala::where('aktif', true)
                     ->select('_id', 'kode', 'nama', 'mb', 'md')
                     ->orderBy('kode')
                     ->get();
            
            return response()->json($gejala, 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve active gejala',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Search gejala by keyword
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function search(Request $request): JsonResponse
    {
        try {
            $keyword = $request->get('keyword', '');
            
            $gejala = Gejala::where('nama', 'like', "%$keyword%")
                     ->orWhere('kode', 'like', "%$keyword%")
                     ->select('_id', 'kode', 'nama', 'mb', 'md', 'aktif')
                     ->orderBy('kode')
                     ->get();
            
            return response()->json($gejala, 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to search gejala',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}