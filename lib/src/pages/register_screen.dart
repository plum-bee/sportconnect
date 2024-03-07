import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportconnect/main.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  void _signUp(BuildContext context) async {
    final form = _formKey.currentState;

    if (form?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final name = form?.fields['name']?.value;
      final surname = form?.fields['surname']?.value;
      final email = form?.fields['email']?.value;
      final password = form?.fields['password']?.value;

      try {
        await supabase.auth.signUp(
            email: email,
            password: password,
            data: {'name': name, 'surname': surname});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } on AuthException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form properly')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_full.png',
                      width: screenSize.width * 0.3,
                      height: screenSize.height * 0.3,
                    ),
                    const SizedBox(height: 20.0),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: constraints.maxWidth * 0.6,
                            child: FormBuilderTextField(
                              name: 'name',
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth * 0.6,
                            child: FormBuilderTextField(
                              name: 'surname',
                              decoration: const InputDecoration(
                                labelText: 'Surname',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth * 0.6,
                            child: FormBuilderTextField(
                              name: 'email',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth * 0.6,
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () => _signUp(context),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('Sign Up'),
                          ),
                          const SizedBox(height: 16.0),
                          const Text('OR'),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: const Text('Log in'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
