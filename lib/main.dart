import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_exchange/pages/homepage.dart';

import 'pages/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAyKk75Ij_KN-aNesXoMXedclwR7pY7GlQ",
          authDomain: "smart-exchange-1.firebaseapp.com",
          projectId: "smart-exchange-1",
          storageBucket: "smart-exchange-1.appspot.com",
          messagingSenderId: "301625153249",
          appId: "1:301625153249:web:02b75a77aaeed777f209a0"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var locale = const Locale('fr');
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FirebaseUILocalizations.delegate,
        ],
        supportedLocales: <Locale>[
          Locale("en"),
          Locale('fr'),
        ],

        title: 'Smart Exchange',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo, width: 2.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black26, width: 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
         
        ),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/' : '/home',
        routes: {
          '/': (context) => Login(),
          '/home': (context) => MyHomePage(),
        },
        // home: Login(),

        locale: locale,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
