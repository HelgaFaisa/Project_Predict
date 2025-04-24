from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load model dan scaler
model = joblib.load('random_forest_model.pkl')
scaler = joblib.load('scaler.pkl')  # scaler hasil fit dari training

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()

        # Validasi input
        required_fields = ['pregnancies', 'glucose', 'blood_pressure', 'bmi', 'age']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing one or more required fields.'}), 400

        # Ambil nilai input dan ubah ke float
        features = [
            float(data['pregnancies']),
            float(data['glucose']),
            float(data['blood_pressure']),
            float(data['bmi']),
            float(data['age'])
        ]

        # Ubah menjadi array dan standarize
        features_scaled = scaler.transform([features])

        # Prediksi
        prediction = model.predict(features_scaled)[0]

        return jsonify({'result': int(prediction)})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(port=5000, debug=True)
