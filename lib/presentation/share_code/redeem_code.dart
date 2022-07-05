import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/owner/profile/owner_profile_bloc.dart';
import 'package:conecta/application/owner/profile/owner_profile_event.dart';
import 'package:conecta/application/owner/profile/owner_profile_state.dart';
import 'package:conecta/application/share_code/share_code_bloc.dart';
import 'package:conecta/application/share_code/share_code_event.dart';
import 'package:conecta/application/share_code/share_code_state.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/initial_configuration/initial_configuration.dart';

class RedeemCode extends StatefulWidget {
  RedeemCode({Key? key}) : super(key: key);

  @override
  State<RedeemCode> createState() => _ShareCodeState();
}

class _ShareCodeState extends State<RedeemCode> {

  bool _redeemCodeSuccessful = false;
  bool _redeemCodeLoading = false;
  bool _redeemCodeError = false;
  TextEditingController _userCodeController = TextEditingController();
  final GlobalKey<FormFieldState> _userCodeFormKey = GlobalKey<FormFieldState>();   

  void showSnackbar(String text, bool isError) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Row(
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 40,
              color: isError ? Colors.redAccent : Colors.greenAccent,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 10,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFFE0E0E3)
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
      duration: Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShareCodeBloc>(
          create: (BuildContext context) => getIt<ShareCodeBloc>(),
        ),
      ], 
      child: _redeemCodeLayoutWidget(context)
    );
  }

  Widget _redeemCodeLayoutWidget(BuildContext context) {
     return MultiBlocListener(
      listeners: [
        
        BlocListener<ShareCodeBloc, ShareCodeState>(
          listener: (context, state) {
            if (state is RedeemingUserCode) {
              setState(() {
                _redeemCodeLoading = true;
              });
            }
            if (state is UserCodeRedeemed) {
              setState(() {
                _redeemCodeLoading = false;
                _redeemCodeSuccessful = true;
              });

              showSnackbar("Código canjeado éxitosamente", false);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => InitialConfiguration()), 
                (Route<dynamic> route) => false
              );
            }
            if (state is UserCodeNotRedeemed) {
              setState(() {
                _redeemCodeLoading = false;
                _redeemCodeError = true;
              });
            }
          },
        ),

      ],
      child: Scaffold(
        backgroundColor: Color(0xFF0E1326),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Color(0xFF0E1326),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: _redeemCodeBodyWidget(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _redeemCodeBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _redeemCodeInfoWidget(context)
      ],
    );
  }
  
  Widget _redeemCodeInfoWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Container(
            height: MediaQuery.of(context).size.height - 320.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/img/gift-code.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width / 2 - 70,
                ),
                SizedBox( height: 30.0 ),
                Text(
                  "Tengo un código de referido",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  )
                ),
                SizedBox( height: 30.0 ),
                Text(
                  "Si un amigo o familiar te compartió el código de la aplicación de Conecta, pégalo a continuación",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                  )
                ),
                SizedBox( height: 15.0 ),
                _redeemCodeFieldWidget(context),
                SizedBox( height: 30.0 ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => InitialConfiguration()), 
                      (Route<dynamic> route) => false
                    );
                  },
                  child: Text(
                    "Omitir"
                  )
                ),
                SizedBox( height: 30.0 ),
              ]
            ),
          ),
          BlocBuilder<ShareCodeBloc, ShareCodeState>(
            builder: (context, state){
              return ButtonPrimary(
                text: 'Siguiente', 
                onPressed: (){
                  context.read<ShareCodeBloc>().add(RedeemUserCode(_userCodeController.text));
                },
                width: MediaQuery.of(context).size.width, 
                fontSize: 18,
              );
            }
          ),
        ]
      ),
    );
  }

  Widget _redeemCodeFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                keyboardType: TextInputType.text,
                inputKey: _userCodeFormKey,
                controller: _userCodeController,
                hintText: 'Ingresa el código', 
                onChanged: (value) => _onUserCodeChanged(value),
                validator: (value){},
                icon: Icons.mail,
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  void _onUserCodeChanged(String? value) {
    setState(() {
      _userCodeFormKey.currentState?.validate();
    });
  }

}