import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/auth/sign_up/sign_up_bloc.dart';
import 'package:conecta/application/auth/sign_up/sign_up_event.dart';
import 'package:conecta/application/auth/sign_up/sign_up_state.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/initial_configuration/initial_configuration.dart';
import 'package:conecta/presentation/share_code/redeem_code.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormFieldState> _emailFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nameFormKey =
      GlobalKey<FormFieldState>();   
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _recoveryUser = false;
  bool _showPassword = true;
  String? _emailError;
  bool _validForm = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<SignUpBloc>(),
      child: _signUpLayoutWidget(context)
    );
  }

  Widget _signUpLayoutWidget(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF0E1326),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Color(0xFF0E1326),
              statusBarIconBrightness: Brightness.light,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _signUpBodyWidget(context),
              ),
            ),
          ),
        );
      }, 
      listener: (context, state) {
        if (state is FailuredSignUpWithEmailAndPassword) {
          if (state.authFailure is EmailAlreadyInUse) {
            _emailError = "El correo electrónico se encuentra registrado";
            _emailFormKey.currentState?.validate();
          }
        } else if (state is SuccessfulSignUp){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RedeemCode()), 
            (Route<dynamic> route) => false
          );
        }
      }
    );
    
  }

  Widget _signUpBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _signUpLogoWidget(context),
        _signUpTitleWidget(context),
        SizedBox(height: 30),
        _signUpFormularyWidget(context),
      ],
    );
  }

  Widget _signUpLogoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SvgPicture.asset(
                    'assets/svg/sign-up-image.svg',
                    height: 200,
                    semanticsLabel: 'Signup image',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signUpTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Regístrate como nuevo usuario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signUpFormularyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpNameFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpEmailFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpPasswordFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpButtonWidget(context),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpLoginWidget(context),
              ),
            ],
          ),
          SizedBox(height: 45),
          Row(
            children: <Widget>[
              Expanded(
                child: _signUpPrivacyWidget(context),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _signUpEmailFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Correo electrónico',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                keyboardType: TextInputType.emailAddress,
                error: _emailError,
                inputKey: _emailFormKey,
                controller: _emailController,
                hintText: 'Ingresa tu correo electrónico', 
                onChanged: (value) => _onEmailChanged(value),
                validator: (value) => _emailValidator(value),
                icon: Icons.email,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signUpNameFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Nombre',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                keyboardType: TextInputType.text,
                inputKey: _nameFormKey,
                controller: _nameController,
                hintText: 'Ingresa tu nombre', 
                onChanged: (value) => _onNameChanged(value),
                validator: (value) => _nameValidator(value),
                icon: Icons.person,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signUpPasswordFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Contraseña',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _passwordFormKey,
                controller: _passwordController,
                hintText: 'Ingresa tu contraseña', 
                onChanged: (value) => _onPasswordChanged(value),
                validator: (value) => _passwordValidator(value),
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

  Widget _signUpButtonWidget(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonPrimary(
                    progressIndicator: state is Processing,
                    text: 'Crear cuenta', 
                    onPressed:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InitialConfiguration()),
                      );
                    }, 
                    // onPressed: _validForm ? () {
                    //   context.read<SignUpBloc>()
                    //     .add(SignUpWithEmailAndPassword(_emailController.text, _passwordController.text, _nameController.text));
                    // } : null, 
                    width: MediaQuery.of(context).size.width, 
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    ); 
  }

  Widget _signUpLoginWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signUpPrivacyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Tu privacidad es importante para nosotros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _onEmailChanged(String? value) {
    setState(() {
      _emailError = null;
      _emailFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _emailValidator(String? value) {
    if(_emailError != null)
      return _emailError;
    return _emailController.text.trimLeft().length == 0
        ? "Debe ingresar su email"
        : null;
  }

  void _onNameChanged(String? value) {
    setState(() {
      _nameFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _nameValidator(String? value) {
    return _nameController.text.trimLeft().length < 2 
        ? "Debes ingresar tu nombre"
        : null;
  }

  void _onPasswordChanged(String? value) {
    setState(() {
      _passwordFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _passwordValidator(String? value) {
    return _passwordController.text.trimLeft().length < 6 
        ? "La contraseña debe tener más de 6 caracteres"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_emailFormKey.currentState?.isValid ?? false) && 
      (_passwordFormKey.currentState?.isValid ?? false);
  }


}
