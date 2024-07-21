# Linear Regression Model for College Prediction

This repository provides a comprehensive solution for predicting college admissions using a linear regression model. It includes a FastAPI server for making predictions, a Jupyter notebook for model training, and a Flutter app for user interaction.

## Public API

The public API for predictions is available at [https://college-predictor-y5es.onrender.com](https://college-predictor-y5es.onrender.com). The endpoint to make predictions is `/predict`.

## Repository Structure

- **API**: Contains the FastAPI server code.
  - `predictions.py`: FastAPI server script that handles prediction requests.
  
- **Linear_regression**: Contains the Jupyter notebook for model creation.
  - `admission.ipynb`: Jupyter notebook for training the linear regression model.

- **Flutter_app**: Contains the Flutter application code.
  - `college_flutter/`: Directory with Flutter app code and configuration.

## Getting Started

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```sh
git clone https://github.com/kennyg37/linear_regression_model.git
cd linear_regression_model
cd API
```
### 2. Set Up the FastAPI Server
Requirements
Ensure you have Python 3.7 or higher installed, and then install the required packages:

```bash
pip install fastapi uvicorn joblib numpy scikit-learn
```
***Running the Server***
```sh
cd API
uvicorn predictions:app --reload --host 0.0.0.0 --port 5000
```

### 3. Run the Jupyter Notebook
The Linear_regression directory contains the notebook where the model is created. To run it:
Install Jupyter if it's not already installed:

```bash
pip install jupyter
```
Navigate to the Linear_regression directory and start Jupyter:

```bash
cd Linear_regression
jupyter notebook
```

### 4.API USAGE

After running the app locally you can access the api via postman by sending a POST request and a body containing college details at
http://localhost:5000/predict or the deployed version at
https://college-predictor-y5es.onrender.com/predict

or 

you can use swagger documentation at
https://college-predictor-y5es.onrender.com/docs

the body(example)
```json
{
  "GRE_Score": 320,
  "TOEFL_Score": 110,
  "University_Rating": 4,
  "SOP": 4.5,
  "LOR": 4.0,
  "CGPA": 9.0,
  "Research": 1
}
```

The API will return a JSON object with the prediction result.

### License and usage
This is a free to use app
This project is licensed under the MIT License. 
For any questions or issues, please contact Ken.





