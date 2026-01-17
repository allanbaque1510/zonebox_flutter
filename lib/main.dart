import 'package:app_zonebox/pages/index.dart';
import 'package:app_zonebox/pages/login_screen.dart';
import 'package:app_zonebox/services/navigation_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_zonebox/services/auth_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("📩 Notificación en segundo plano: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> _getToken() async {
    try {
      await AuthService().verificarToken();
      final data = await SecureStorageService.getToken();
      debugPrint("🔑 Token obtenido: $data");
      return data;
    } catch (e) {
      debugPrint("🔑 Token no obtenido: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? fcmToken = await _messaging.getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("💬 Notificación recibida en primer plano:");
      debugPrint("Título: ${message.notification?.title}");
      debugPrint("Cuerpo: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🚀 App abierta desde notificación: ${message.data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const Index();
          }

          return const Login();
        },
      ),
    );
  }
}
