import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/onboarding/onboarding.dart';
import 'package:conecta/presentation/onboarding/onboarding_welcome.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

import 'application/auth/auth_bloc.dart';
import 'application/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureInjection();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  void pushFCMtoken() async {
    String? token = await messaging.getToken();
    print("Token: " + token!);
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInit = IOSInitializationSettings();

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    FlutterLocalNotificationsPlugin fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);

    var androidDetails = AndroidNotificationDetails("1", "channelName");
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification !=null && android !=null){
        fltNotification.show(notification.hashCode, notification.title, notification.body, generalNotificationDetails);
      }
    });
  }

  @override
  void initState() {
    pushFCMtoken();
    initMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nexa',
        brightness: Brightness.light
      ),
      home: BlocProvider(
        create: (BuildContext context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        child: _home(context),
      )
    );
  }

  Widget _home(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthenticatedSubject) {
          return Dashboard();
        } else if (state is UnauthenticatedSubject) {
          return SignIn();
        } else if(state is FirstTimeUsingApp) {
          return OnBoardingWelcome();
        }
        else {
          return SplashScreen();
        }
      }
    );  
  }
}
