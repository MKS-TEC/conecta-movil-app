import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/onboarding/onboarding_bloc.dart';
import 'package:conecta/application/onboarding/onboarding_event.dart';
import 'package:conecta/application/onboarding/onboarding_state.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

class OnBoardingFinish extends StatefulWidget {
  OnBoardingFinish({Key? key}) : super(key: key);

  @override
  State<OnBoardingFinish> createState() => _OnBoardingFinishState();
}

class _OnBoardingFinishState extends State<OnBoardingFinish> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingBloc>(),
      child: _onBoardingFinishLayoutWidget(context)
    );
  }

  Widget _onBoardingFinishLayoutWidget(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is SuccessfulOnboarding) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignIn()), 
            (Route<dynamic> route) => false
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF04091D),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Color(0xFF04091D),
              statusBarIconBrightness: Brightness.light,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _onBoardingFinishBodyWidget(context),
              ),
            ),
          ),
        );
      }
    );
    
  }

  Widget _onBoardingFinishBodyWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _onBoardingFinishTextWidget(context),
          _onBoardingFinishImageWidget(context),
          _onBoardingFinishButtonWidget(context),
        ],
      ),
    );
  }

  Widget _onBoardingFinishTextWidget(BuildContext context) {
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
                          text: 'Somos la herramienta que te apoyará en todo momento para gestionar las pólizas y servicios relacionados con tu salud. bienestar, hogar, automóvil, entre otros.',
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

  Widget _onBoardingFinishImageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SvgPicture.asset(
                    'assets/svg/onboarding-finish-image.svg',
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

  Widget _onBoardingFinishButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonPrimary(
                  text: 'Continuar', 
                  onPressed: () {
                    context.read<OnboardingBloc>().add(FirstTimeUsingAppDone());
                  }, 
                  width: MediaQuery.of(context).size.width, 
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}