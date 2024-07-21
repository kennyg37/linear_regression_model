#!/usr/bin/env python3
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

model = joblib.load('multivariate_model.joblib')
scaler = joblib.load('multivariate_scaler.joblib')

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],  
)

class Features(BaseModel):
    GRE_Score: int
    TOEFL_Score: int
    University_Rating: int
    essay_rating: float
    recommendation_rating: float
    CGPA: float
    Research: int

feature_mapping = {
    'GRE_Score': 'GRE Score',
    'TOEFL_Score': 'TOEFL Score',
    'University_Rating': 'University Rating',
    'essay_rating': 'Essay rating',
    'recommendation_rating': 'Recommendation',
    'CGPA': 'CGPA',
    'Research': 'Research'
}

@app.get('/')
def read_root():
    return {"Hello welcome to the college admission prediction API by Ken Ganza, please use the /predict endpoint to make a prediction. or visit the documentation at /docs"}

@app.post('/predict')
def predict(data: Features):
    try:
        features = np.array([[
            getattr(data, attr) for attr in feature_mapping.keys()
        ]])
        
        features_scaled = scaler.transform(features)
        prediction = model.predict(features_scaled)
        prediction_value = prediction[0]
        prediction_percentage = round(prediction_value * 100, 2)
        return {"prediction": prediction_value,
                "predictiion percentage": prediction_percentage}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=5000)
