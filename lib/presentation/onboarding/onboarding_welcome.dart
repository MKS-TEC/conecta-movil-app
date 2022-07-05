import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/onboarding/onboarding_finish.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingWelcome extends StatefulWidget {
  OnBoardingWelcome({Key? key}) : super(key: key);

  @override
  State<OnBoardingWelcome> createState() => _OnBoardingWelcomeState();
}

class _OnBoardingWelcomeState extends State<OnBoardingWelcome> {
  @override
  Widget build(BuildContext context) {
    return _onBoardingWelcomeLayoutWidget(context);
  }

  Widget _onBoardingWelcomeLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04091D),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color(0xFF04091D),
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _onBoardingWelcomeBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _onBoardingWelcomeBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _onBoardingWelcomeLogoWidget(context),
        SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.height - 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _onBoardingWelcomeTextWidget(context),
              _onBoardingWelcomeImageWidget(context),
              _onBoardingWelcomeIndicatorsWidget(context),
            ]
          ),
        )
      ],
    );
  }

  Widget _onBoardingWelcomeLogoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/img/priority-pet-logo.png',
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _onBoardingWelcomeTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                          text: 'La comunidad que te conecta con tu corredor de seguros, aseguradoras y la red de proveedores.',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
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

  Widget _onBoardingWelcomeImageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SvgPicture.asset(
                    'assets/svg/onboarding-bg.svg',
                    width: MediaQuery.of(context).size.width,
                    semanticsLabel: 'Onboarding image',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _onBoardingWelcomeIndicatorsWidget(BuildContext context) {
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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OnBoardingFinish()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(0xFFFFFFFF),
                          size: 38,
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