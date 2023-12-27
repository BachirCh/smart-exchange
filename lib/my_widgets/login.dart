import 'package:flutter/material.dart';
import './homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: null,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
            ),
            SizedBox(
              height: 80,),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your email';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password"),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your password';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill input')),
                              );
                            }
                          },
                          child: const Text('Se connecter'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
