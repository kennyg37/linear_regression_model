from flask import Flask, jsonify, request
from flask_swagger_ui import get_swaggerui_blueprint
import joblib
import numpy as np
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

model = joblib.load('multivariate_model.joblib')
scaler = joblib.load('multivariate_scaler.joblib')

@app.route('/')
def home():
    return "Hello, welcome to the college admission prediction API by Ken Ganza."

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    features = np.array([[data[attr] for attr in data.keys()]])
    features_scaled = scaler.transform(features)
    prediction = model.predict(features_scaled)
    prediction_value = prediction[0]
    prediction_percentage = round(prediction_value * 100, 2)
    
    return jsonify({"prediction": prediction_value, "prediction_percentage": prediction_percentage})

# Swagger UI setup
SWAGGER_URL = '/swagger'
API_URL = '/static/swagger.json'

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': "College Admission Prediction API"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

if __name__ == '__main__':
    app.run(debug=True)
