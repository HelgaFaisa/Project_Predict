<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prediksi Diabetes</title>
</head>
<body>
    <h1>Form Prediksi Diabetes</h1>

    <form action="/predict" method="POST">
        @csrf
        <label for="pregnancies">Jumlah Kehamilan:</label>
        <input type="number" name="pregnancies" required><br>

        <label for="glucose">Glucose:</label>
        <input type="number" name="glucose" required><br>

        <label for="blood_pressure">Tekanan Darah:</label>
        <input type="number" name="blood_pressure" required><br>

        <label for="bmi">BMI:</label>
        <input type="number" name="bmi" step="0.1" required><br>

        <label for="age">Umur:</label>
        <input type="number" name="age" required><br>

        <button type="submit">Prediksi</button>
    </form>

    @if (isset($result))
        <h2>Hasil Prediksi: {{ $result == 1 ? 'Pasien terkena diabetes' : 'Pasien tidak terkena diabetes' }}</h2>

        <form action="/predict/save" method="POST" style="display: inline;">
            @csrf
            <!-- Kirim data prediksi -->
            <input type="hidden" name="pregnancies" value="{{ $input['pregnancies'] }}">
            <input type="hidden" name="glucose" value="{{ $input['glucose'] }}">
            <input type="hidden" name="blood_pressure" value="{{ $input['blood_pressure'] }}">
            <input type="hidden" name="bmi" value="{{ $input['bmi'] }}">
            <input type="hidden" name="age" value="{{ $input['age'] }}">
            <input type="hidden" name="result" value="{{ $result }}">
            <button type="submit">Simpan</button>
        </form>

        <form action="/predict/clear" method="GET" style="display: inline;">
            <button type="submit">Batal</button>
        </form>
    @endif
</body>
</html>
