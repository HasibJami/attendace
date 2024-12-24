import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sorkhposhan/views/getStart.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:sorkhposhan/services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyBkACJn6GAk80wGyiDMlQDr7B1iqxmuXyM',
      appId: '1:390479380583:web:71e8ccbbafc58276ce14c2',
      messagingSenderId: '390479380583',
      projectId: 'sorkhposhan-attendance',
      authDomain: 'sorkhposhan-attendance.firebaseapp.com',
      storageBucket: 'sorkhposhan-attendance.appspot.com',
    ));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (context) => const GetStart(),
      },
    );
  }
}
