import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'services/push_notifications/push_notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load environment variables
  await dotenv.load();

  var keyApplicationId = dotenv.env['PARSE_APPLICATION_ID'] ?? '';
  var keyClientKey = dotenv.env['PARSE_CLIENT_KEY'] ?? '';
  var keyParseServerUrl = dotenv.env['PARSE_SERVER_URL'] ?? '';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  // Initialize Push Notifications
  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Social App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
