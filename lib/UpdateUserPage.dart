import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;


class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _registration_main_idController = TextEditingController();
  final TextEditingController _userCodeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedCountryCode = '+4';

  Future<void> _updateDetails() async {
    String registration_main_id= _registration_main_idController.text;
    String userCode = _userCodeController.text;
    String firstName = _firstNameController.text;
    String middleName = _middleNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String CountryCode = _selectedCountryCode;


    // Perform saving logic with the captured data
    Map<String, dynamic> requestData = {
      'registration_main_id': registration_main_id,
      'user_code': userCode,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone_number': '1234567890',
      'phone_country_code': CountryCode,
      'email': email,
    };

    // Make the API request to save the details
    final response = await http.post( Uri.parse(
        'https://glexas.com/hostel_data/API/test/new_admission_update.php'),
      body: requestData,
    );

    // Check if the API request was successful
    if (response.statusCode == 200) {
      Navigator.pop(context, firstName);
    }

    // Clear text fields after saving
    _registration_main_idController.clear();
    _userCodeController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _emailController.clear();

    // Show success message or navigate back to previous page
    // ...
  }

  void updateUser() async {
    if (_formKey.currentState!.validate()) {
      final http.Response insertResponse = await http.post(
          Uri.parse(
              'https://glexas.com/hostel_data/API/test/new_admission_update.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (insertResponse.statusCode == 200) {
        _updateDetails();
      } else {
        throw Exception('Failed to Update album.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Details'),
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
                  controller: _registration_main_idController,
                  decoration: InputDecoration(
                    labelText: 'Registration_main_id',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Registration_main_id is required';
                    }
                    return null;
                  },
                  textInputAction:
                  TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 16.0),
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
                      return 'Registration Main ID is required';
                    }
                    return null;
                  },
                  textInputAction:
                  TextInputAction.next, // Change return key to "Next"
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  child: Text('Update'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Update Student Details '),
                            content: Text('Are you sure, You want to Update?'),
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
                                  updateUser();
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
// "user_code": "Counsellor1",
// "first_name": "ashish4",
// "middle_name": "Mideea",
// "last_name": "Las",
// "phone_number": "1234567890",
// "phone_country_code": "+91",
// "email": "xyzw@gmail.com",