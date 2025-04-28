@extends('layouts.app')

@section('content')
<div class="main-content">
    <div class="topbar">
        <h1 class="page-title">Prediksi Diabetes</h1>
    </div>

    <div class="content">
        <div class="form-card">
            <form action="{{ url('predict') }}" method="POST" class="predict-form">
                @csrf

                <div class="form-group">
                    <label for="pregnancies">Jumlah Kehamilan:</label>
                    <input type="number" name="pregnancies" required>
                </div>

                <div class="form-group">
                    <label for="glucose">Glukosa:</label>
                    <input type="number" name="glucose" required>
                </div>

                <div class="form-group">
                    <label for="blood_pressure">Tekanan Darah:</label>
                    <input type="number" name="blood_pressure" required>
                </div>

                <div class="form-group">
                    <label for="bmi">BMI:</label>
                    <input type="number" step="0.1" name="bmi" required>
                </div>

                <div class="form-group">
                    <label for="age">Umur:</label>
                    <input type="number" name="age" required>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="btn-submit">Prediksi</button>
                </div>
            </form>

            @if (isset($result))
                <div class="result-card">
                    <h2>Hasil Prediksi: 
                        <span class="{{ $result == 1 ? 'positive' : 'negative' }}">
                            {{ $result == 1 ? 'Pasien terkena diabetes' : 'Pasien tidak terkena diabetes' }}
                        </span>
                    </h2>

                    <div class="result-actions">
                        <form action="{{ url('predict/save') }}" method="POST" style="display: inline;">
                            @csrf
                            <input type="hidden" name="pregnancies" value="{{ $input['pregnancies'] }}">
                            <input type="hidden" name="glucose" value="{{ $input['glucose'] }}">
                            <input type="hidden" name="blood_pressure" value="{{ $input['blood_pressure'] }}">
                            <input type="hidden" name="bmi" value="{{ $input['bmi'] }}">
                            <input type="hidden" name="age" value="{{ $input['age'] }}">
                            <input type="hidden" name="result" value="{{ $result }}">
                            <button type="submit" class="btn-save">Simpan</button>
                        </form>

                        <form action="{{ url('predict/clear') }}" method="GET" style="display: inline;">
                            <button type="submit" class="btn-cancel">Batal</button>
                        </form>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
@endsection
