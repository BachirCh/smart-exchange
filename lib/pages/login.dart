import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'homepage.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [EmailAuthProvider()],
            sideBuilder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/favicon.svg',
                    height: 56,
                  ),
                  SizedBox(width: 12),
                  Text('Smart Exchange',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              );
            },
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/favicon.svg',
                        height: 32,
                      ),
                      SizedBox(width: 12),
                      Text('Smart Exchange',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Veuillez entrer vos identifiants!')
                    : const Text('Veuillez entrer vos identifiants.'),
              );
            },
            showAuthActionSwitch: false,
          );
        }

        return MyHomePage();
      },
    );
  }
}
