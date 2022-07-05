import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/presentation/onboarding/onboarding_best_products.dart';

class OnBoardingClinicHistory extends StatefulWidget {
  OnBoardingClinicHistory({Key? key}) : super(key: key);

  @override
  State<OnBoardingClinicHistory> createState() => _OnBoardingClinicHistoryState();
}

class _OnBoardingClinicHistoryState extends State<OnBoardingClinicHistory> {
  @override
  Widget build(BuildContext context) {
    return _onBoardingClinicHistoryLayoutWidget(context);
  }

  Widget _onBoardingClinicHistoryLayoutWidget(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFFFFFFFF),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _onBoardingClinicHistoryBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _onBoardingClinicHistoryBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _onBoardingClinicHistoryTextWidget(context),
        _onBoardingClinicHistoryImageWidget(context),
        _onBoardingClinicHistoryIndicatorsWidget(context),
      ],
    );
  }

  Widget _onBoardingClinicHistoryTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 60),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cuidar de su salud nunca fue tan fácil',
                          style: TextStyle(
                            color: Color(0xFF00B6E6),
                            fontSize: 20,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Su historia clínica ahora será digital, recibirás un programa de cuidado personalizado a nivel nutricional, físico y conductual. Y por primera vez en el país, videoconsultas veterinarias desde tu celular.',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _onBoardingClinicHistoryImageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/img/onboarding-vet.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _onBoardingClinicHistoryIndicatorsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF10172F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.chevron_left,
                          color: Color(0xFF00B6E6),
                          size: 34,
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF6F7177),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF00B6E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF6F7177),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF6F7177),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 25),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OnBoardingBestProducts()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF10172F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(0xFF00B6E6),
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}