import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return _splashScreenLayoutWidget(context);
  }

  Widget _splashScreenLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color(0xFF04091D),
          statusBarIconBrightness: Brightness.light,
        ),
        child: _splashScreenBodyWidget(context)
      ),
    );
  }

  Widget _splashScreenBodyWidget(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/priority-pet-logo.png',
          fit: BoxFit.cover,
          width: 300,
        ),
      ),
    );
  }
}