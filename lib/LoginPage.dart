import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'LoginDataModel.dart';
import 'listpage.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      String username = usernameController.text;
      String password = passwordController.text;

      // Create the request body
      Map<String, dynamic> requestBody = {
        'username': username,
        'password': password,
      };

      try {
        // Convert the request body to JSON
        String requestBodyJson = jsonEncode(requestBody);
        // Make the API call to validate login credentials
        final response = await http.post(
          Uri.parse('https://glexas.com/hostel_data/API/test/login.php'),
          headers: {'Content-Type': 'application/json'},
          body: requestBodyJson,
        );

        var x = json.decode(response.body);
        var loginResponse = LoginResponse.fromJson(x);

        if (loginResponse.status) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Failed'),
              content: Text(loginResponse.message),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } catch (error) {
        // Handle any error that occurred during the API call
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during login.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 50)), // Set the width and height here
                ),
                child: isLoading
                    ? SpinKitFadingCircle(
                        color: Colors.white,
                        size: 24.0,
                      )
                    : Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
