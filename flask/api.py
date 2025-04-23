# diabetes-api/api.py
from flask import Flask, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)
model = pickle.load(open('diabetes_model.pkl', 'rb'))

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json  # data dalam format JSON
    input_data = np.array([list(data.values())])
    prediction = model.predict(input_data)[0]
    return jsonify({'result': int(prediction)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
