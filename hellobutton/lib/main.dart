import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// 🔹 Background Notification Handler (TOP LEVEL)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message ID: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// 🔹 Register Background Handler
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    /// 🔹 Request Notification Permission (Android 13+)
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    ).then((settings) {
      debugPrint(
          "🔐 Permission status: ${settings.authorizationStatus}");
    });

    /// 🔹 Get FCM Token
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint("📱 FCM Token: $token");
    });

    /// 🔹 Foreground Notification Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground Notification");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Naitik"),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Today is Wednesday Feb 04"),
              ),
            );
          },
        ),
      ),
    );
  }
}
