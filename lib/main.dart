import 'package:books_app/pages/first.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin().initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher')));


  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Books app',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const FirstPage(),
    );
  }
}
