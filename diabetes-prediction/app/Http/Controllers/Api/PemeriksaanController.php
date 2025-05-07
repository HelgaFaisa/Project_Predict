<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use MongoDB\Client as Mongo;

class PemeriksaanController extends Controller
{
    public function riwayat($id_pasien)
    {
        $client = new Mongo(); // ini akan konek ke MongoDB
        $collection = $client->prediksi_diabetes->prediksi_pasien; // sesuaikan nama DB dan collection
        $data = $collection->find(['id_pasien' => $id_pasien]);
        $riwayat = iterator_to_array($data);

        return response()->json($riwayat);
    }
}
