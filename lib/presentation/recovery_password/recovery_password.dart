import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';

class RecoveryPassword extends StatefulWidget {
  RecoveryPassword({Key? key}) : super(key: key);

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  final GlobalKey<FormFieldState> _passwordFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordConfirmFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return _recoveryPasswordLayoutWidget(context);
  }

  Widget _recoveryPasswordLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _recoveryPasswordBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _recoveryPasswordBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _recoveryPasswordBackButtonWidget(context),
        _recoveryPasswordTitleWidget(context),
        _recoveryPasswordFormularyWidget(context),
      ],
    );
  }

  Widget _recoveryPasswordBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF10172F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 45,
                    height: 45,
                    child: Icon(
                      Icons.chevron_left,
                      color: Color(0xFF00B6E6),
                      size: 45,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/img/priority-pet-logo.png',
                    fit: BoxFit.contain,
                    height: 65,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _recoveryPasswordTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Cambia la contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Código verificado, ahora puedes crear una nueva contraseña',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recoveryPasswordFormularyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _recoveryPasswordFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: _recoveryConfirmPasswordFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 45),
          Row(
            children: <Widget>[
              Expanded(
                child: _recoveryPasswordButtonWidget(context),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _recoveryPasswordFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _passwordFormKey,
                controller: _passwordController,
                hintText: 'Contraseña', 
                onChanged: (value) => _onPasswordChanged(value!),
                validator: (value) => _passwordValidator(value!),
                icon: _showPassword ? Icons.visibility : Icons.visibility_off,
                obscureText: _showPassword,
                onTapIcon: () {
                  _showPassword = !_showPassword;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recoveryConfirmPasswordFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _passwordConfirmFormKey,
                controller: _passwordConfirmController,
                hintText: 'Repite la contraseña', 
                onChanged: (value) => _onPasswordConfirmChanged(value!),
                validator: (value) => _passwordConfirmValidator(value!),
                icon: _showPassword ? Icons.visibility : Icons.visibility_off,
                obscureText: _showPassword,
                onTapIcon: () {
                  _showPassword = !_showPassword;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recoveryPasswordButtonWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ButtonPrimary(
                text: 'Cambiar la contraseña', 
                onPressed: () {
                  
                }, 
                width: MediaQuery.of(context).size.width, 
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordFormKey.currentState?.validate();
    });
  }

  String? _passwordValidator(String value) {
    return _passwordController.text.trimLeft().length == 0
        ? "Debe ingresar una contraseña"
        : null;
  }

  void _onPasswordConfirmChanged(String value) {
    setState(() {
      _passwordConfirmFormKey.currentState?.validate();
    });
  }

  String? _passwordConfirmValidator(String value) {
    return _passwordConfirmController.text.trimLeft().length == 0
        ? "Debe repetir la contraseña"
        : null;
  }
}