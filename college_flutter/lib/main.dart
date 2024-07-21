import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CollegePredictorForm(),
    );
  }
}

class CollegePredictorForm extends StatefulWidget {
  @override
  _CollegePredictorFormState createState() => _CollegePredictorFormState();
}

class _CollegePredictorFormState extends State<CollegePredictorForm> {
  final _formKey = GlobalKey<FormState>();
  final _greScoreController = TextEditingController();
  final _toeflScoreController = TextEditingController();
  final _universityRatingController = TextEditingController();
  final _essayRatingController = TextEditingController();
  final _recommendationRatingController = TextEditingController();
  final _cgpaController = TextEditingController();
  String? _research;

  double? _predictionPercentage;

  Future<void> _predictChances() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://college-predictor-y5es.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'GRE_Score': int.parse(_greScoreController.text),
          'TOEFL_Score': int.parse(_toeflScoreController.text),
          'University_Rating': int.parse(_universityRatingController.text),
          'essay_rating': int.parse(_essayRatingController.text),
          'recommendation_rating': int.parse(_recommendationRatingController.text),
          'CGPA': double.parse(_cgpaController.text),
          'Research': _research == 'Yes' ? 1 : 0,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('API Response: $responseData');  // Print the API response to the console
        setState(() {
          _predictionPercentage = responseData['predictiion percentage'];
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');  // Print the error response to the console
        setState(() {
          _predictionPercentage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Predictor'),
      ),
      body: _predictionPercentage == null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Enter your details to predict your chances:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          _buildTextFormField(_greScoreController, 'GRE Score(0-340)'),
                          SizedBox(height: 10),
                          _buildTextFormField(_toeflScoreController, 'TOEFL Score(0-120)'),
                          SizedBox(height: 10),
                          _buildTextFormField(_universityRatingController, 'University Rating(0-5)'),
                          SizedBox(height: 10),
                          _buildTextFormField(_essayRatingController, 'Essay Rating(0-5)'),
                          SizedBox(height: 10),
                          _buildTextFormField(_recommendationRatingController, 'Recommendation Rating(0-5)'),
                          SizedBox(height: 10),
                          _buildTextFormField(_cgpaController, 'CGPA(0-10)'),
                          SizedBox(height: 10),
                          _buildDropdownField('Research', ['Yes', 'No']),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _predictChances,
                            child: Text('Predict Chances'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                              textStyle: TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                'Your chances of admission: ${_predictionPercentage!.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: _research,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _research = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }
}
