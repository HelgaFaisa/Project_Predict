@extends('layouts.app')

@section('content')
    <div class="welcome-card">
        <h1><b>Selamat Datang</b> di Platform Edukasi & Prediksi Diabetes</h1>
        <p>Diabetes adalah penyakit kronis akibat kadar gula darah yg terlalu tinggi karena kekurangan atau ketidakefektifan insulin.</p>
    </div>

    <div class="chart-card">
        <canvas id="myChart"></canvas>
    </div>
@endsection
