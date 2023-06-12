import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class InsertPage extends StatefulWidget {
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userCodeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedCountryCode = 'IN';

  Future<void> _saveDetails() async {
    String userCode = _userCodeController.text;
    String firstName = _firstNameController.text;
    String middleName = _middleNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String CountryCode = _selectedCountryCode;

    // Perform saving logic with the captured data
    Map<String, dynamic> requestData = {
      'user_code': userCode,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone_number': '1234567890',
      'phone_country_code': CountryCode,
      'email': email,
    };

    // Make the API request to save the details
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'https://glexas.com/hostel_data/API/test/new_admission_insert.php'),
        body: requestData,
      );

      // Check if the API request was successful
      if (response.statusCode == 200) {

        Navigator.pop(context, firstName);
        setState(() {

        });
      }

      // Clear text fields after saving
      _userCodeController.clear();
      _firstNameController.clear();
      _middleNameController.clear();
      _lastNameController.clear();
      _emailController.clear();

      // Show success message or navigate back to previous page
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Insert Student'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userCodeController,
                  decoration: InputDecoration(
                    labelText: 'User Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'User Code is required';
                    }
                    return null;
                  },
                  textInputAction:
                      TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                  textInputAction:
                      TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _middleNameController,
                  decoration: InputDecoration(
                    labelText: 'Middle Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Middle Name is required';
                    }
                    return null;
                  },
                  textInputAction:
                      TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                  textInputAction:
                      TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 16.0),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  initialCountryCode: _selectedCountryCode,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  onCountryChanged: (phone) {
                    setState(() {
                      _selectedCountryCode = phone.code;
                    });
                  },
                  validator: (phone) {
                    if (phone!.number!.length != 10) {
                      return 'Please enter a 10-digit phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an Email';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                  textInputAction:
                      TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Save Student'),
                            content: Text('Are you sure, You want to Save?'),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  _saveDetails();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
