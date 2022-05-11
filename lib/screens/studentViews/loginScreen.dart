import 'package:flutter/material.dart';
import 'package:elibrary_app/screens/components/textInput.dart';
import 'package:elibrary_app/screens/components/submitButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loginScreen extends StatefulWidget {
  loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Input Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 24.0),
                child: Image(
                  image: AssetImage('assets/images/logo_main.png'),
                ),
              ),
            ),
            
            TextInput(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            
            TextInput(
              label: 'Password',
              controller: _passwordController,
              keyboardType: TextInputType.text,
              password: true,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            
            const SizedBox(
              height: 15,
            ),
            if (isLoading) ...[
              const SizedBox(
                height: 10,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ] else ...[
              SubmitButton(
                formKey: _formKey,
                process: _loginUser,
              )
            ],
          ],
        ),
      ),
    );
  }

  Future _loginUser() async {
    setState(() {
      isLoading = true;
    });
   // process
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'Email is already in use';
        break;
      case 'invalid-email':
        messageToDisplay = 'Email is invalid';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'This operation is not allowed';
        break;
      
      default: // Default to general error message
        messageToDisplay = 'An unknown error occured';
        break;
    }

    showDialog( 
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(messageToDisplay),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}