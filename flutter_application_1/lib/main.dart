import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'router.dart'; // Memindahkan konfigurasi router ke file terpisah

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Coffee Shop App',
      theme: ThemeData(primarySwatch: Colors.orange),
      routerConfig: router,
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan "DEBUG"
    );
  }
}
