<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller; // Import class Controller
use App\Models\Gejala;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;

class GejalaController extends Controller
{
    /**
     * Display a listing of the gejala.
     *
     * @return View
     */
    public function index(): View
    {
        $gejalaList = Gejala::orderBy('kode')->paginate(10);
        return view('admin.gejala.index', compact('gejalaList'));
    }

    /**
     * Show the form for creating a new gejala.
     *
     * @return View
     */
    public function create(): View
    {
        return view('admin.gejala.form');
    }

    /**
     * Store a newly created gejala in storage.
     *
     * @param Request $request
     * @return RedirectResponse
     */
    public function store(Request $request): RedirectResponse
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'mb' => 'required|numeric|between:0,1',
            'md' => 'required|numeric|between:0,1',
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $last = Gejala::orderBy('kode', 'desc')->first();
        $num = $last ? ((int) substr($last->kode, 1)) + 1 : 1;
        $kode = 'G' . str_pad($num, 2, '0', STR_PAD_LEFT);

        Gejala::create([
            'kode' => $kode,
            'nama' => $request->nama,
            'mb' => $request->mb,
            'md' => $request->md,
            'aktif' => $request->has('aktif'),
        ]);

        return redirect()->route('admin.gejala.index')->with('success', 'Gejala berhasil ditambahkan');
    }

    /**
     * Show the form for editing the specified gejala.
     *
     * @param string $id
     * @return View
     */
    public function edit(string $id): View
    {
        $gejala = Gejala::findOrFail($id);
        return view('admin.gejala.form', compact('gejala'));
    }

    /**
     * Update the gejala.
     *
     * @param Request $request
     * @param string $id
     * @return RedirectResponse
     */
    public function update(Request $request, string $id): RedirectResponse
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'mb' => 'required|numeric|between:0,1',
            'md' => 'required|numeric|between:0,1',
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $gejala = Gejala::findOrFail($id);
        $gejala->update([
            'nama' => $request->nama,
            'mb' => $request->mb,
            'md' => $request->md,
            'aktif' => $request->has('aktif'),
        ]);

        return redirect()->route('admin.gejala.index')->with('success', 'Gejala diperbarui');
    }

    /**
     * Remove the gejala.
     *
     * @param string $id
     * @return RedirectResponse
     */
    public function destroy(string $id): RedirectResponse
    {
        $gejala = Gejala::findOrFail($id);
        $gejala->delete();
        return redirect()->route('admin.gejala.index')->with('success', 'Gejala dihapus');
    }

    /**
     * Toggle the status of gejala.
     * 
     * @param string $id
     * @return RedirectResponse
     */
    public function toggleStatus(string $id): RedirectResponse
    {
        $gejala = Gejala::findOrFail($id);
        $gejala->aktif = !$gejala->aktif;
        $gejala->save();
        return redirect()->route('admin.gejala.index')->with('success', 'Status gejala berhasil diubah');
    }
}