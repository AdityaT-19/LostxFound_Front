import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lostxfound_front/constants/url.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _isLogin = true;
  var _isLoading = false;
  var _uid = '';
  var _userEmail = '';
  var _userPassword = '';
  @override
  Widget build(BuildContext context) {
    void _trySubmit() async {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        try {
          if (_isLogin) {
            await _auth.signInWithEmailAndPassword(
              email: _userEmail,
              password: _userPassword,
            );
          } else {
            await _auth.createUserWithEmailAndPassword(
              email: _userEmail,
              password: _userPassword,
            );
          }
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', _uid);
          setState(() {
            _isLoading = false;
          });
          final uid = prefs.getString('uid')!;
          ref.watch(userProvider.notifier).fetchAndSetUser(uid);
        } catch (e) {
          Get.snackbar(
            'An error occurred!',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LostandFoundLogo.png',
                height: 150,
              ),
              Text(
                'Welcome to LostXFound!',
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            key: const ValueKey('USN'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'USN',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter your USN';
                              }
                              return null;
                            },
                            onSaved: (newValue) async {
                              final univid = 1;
                              final url = Uri.parse(
                                  '$URL/$univid/user/$newValue/email');
                              final response = await http.get(url);
                              final extractedData = response.body;
                              final decodedData = jsonDecode(extractedData)
                                  as Map<String, dynamic>;
                              final email = decodedData['email'];
                              _userEmail = email as String;
                              _uid = newValue!;
                              Get.snackbar('Email', _userEmail,
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                          ),
                          TextFormField(
                            key: const ValueKey('password'),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 7) {
                                return 'Password must be at least 7 characters long';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _userPassword = newValue!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isLoading) const CircularProgressIndicator(),
                          if (!_isLoading)
                            ElevatedButton(
                              onPressed: _trySubmit,
                              child: Text(
                                _isLogin ? 'Login' : 'Signup',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          if (!_isLoading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create new account'
                                    : 'I already have an account',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
