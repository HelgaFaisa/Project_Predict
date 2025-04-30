<?php

namespace App\Http\Controllers;

use App\Models\Gejala;
use Illuminate\Http\Request;

class GejalaController extends Controller
{
    public function index()
    {
        $gejalaList = Gejala::all();
        return view('admin.gejala.index', compact('gejalaList'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'weight' => 'required|numeric',
        ]);
    
        Gejala::create([
            'name' => $request->name,
            'weight' => $request->weight,
            'active' => true,
        ]);
    
        return redirect()->route('admin.gejala.index')->with('success', 'Gejala berhasil ditambahkan');
    }
    
    public function update(Request $request, $id)
    {
        $gejala = Gejala::findOrFail($id);
        $gejala->update($request->only(['name', 'weight', 'active']));
    
        return redirect()->route('admin.gejala.index')->with('success', 'Gejala berhasil diperbarui');
    }
    
    public function destroy($id)
    {
        Gejala::destroy($id);
        return redirect()->route('admin.gejala.index')->with('success', 'Gejala berhasil dihapus');
    }
    

    public function aktif()
    {
        $gejalaAktif = Gejala::where('active', true)->get(['_id', 'name', 'weight']);
        return response()->json($gejalaAktif);
    }
}
