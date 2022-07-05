import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/presentation/onboarding/onboarding_finish.dart';

class OnBoardingBestProducts extends StatefulWidget {
  OnBoardingBestProducts({Key? key}) : super(key: key);

  @override
  State<OnBoardingBestProducts> createState() => _OnBoardingBestProductsState();
}

class _OnBoardingBestProductsState extends State<OnBoardingBestProducts> {
  @override
  Widget build(BuildContext context) {
    return _onBoardingBestProductsLayoutWidget(context);
  }

  Widget _onBoardingBestProductsLayoutWidget(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFFFFFFFF),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _onBoardingBestProductsBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _onBoardingBestProductsBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _onBoardingBestProductsTextWidget(context),
        _onBoardingBestProductsImageWidget(context),
        _onBoardingBestProductsIndicatorsWidget(context),
      ],
    );
  }

  Widget _onBoardingBestProductsTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 40),
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
                          text: 'Porque ellos se lo merecen',
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
                          text: 'Encuentra los mejores productos del mercado, la celebración de cumpleaños soñada, lugares pet friendly más cercanos, actividades grupales con otros miembros de tu comunidad y mil nuevas formas de engreírlo.',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 18,
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

  Widget _onBoardingBestProductsImageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SvgPicture.asset(
                    'assets/svg/onboarding-best-products-image.svg',
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

  Widget _onBoardingBestProductsIndicatorsWidget(BuildContext context) {
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
                    SizedBox(width: 25),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OnBoardingFinish()),
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