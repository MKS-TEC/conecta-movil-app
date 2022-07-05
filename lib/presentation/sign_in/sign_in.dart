import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/auth/sign_in/sign_in_bloc.dart';
import 'package:conecta/application/auth/sign_in/sign_in_event.dart';
import 'package:conecta/application/auth/sign_in/sign_in_state.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/initial_configuration/initial_configuration.dart';
import 'package:conecta/presentation/sign_up/sign_up.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormFieldState> _emailFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  SignInBloc? _signInBloc;
  bool _recoveryUser = false;
  bool _showPassword = true;
  String? _emailError;
  bool _validForm = false;
  bool _error = false;
  final Owner owner = Owner();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInBloc>(),
      child: _signInLayoutWidget(context)
    );
  }

  Widget _signInLayoutWidget(BuildContext context) {
    // _signInBloc = BlocProvider.of<SignInBloc>(context);
    return BlocConsumer<SignInBloc, SignInState>(
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
                child: _signInBodyWidget(context),
              ),
            ),
          ),
        );
      }, 
      listener: (context, state) {
        if (state is FailuredSignInWithEmailAndPassword) {
          if (state.authFailure is InvalidEmailAndPasswordCombination) {
            _emailError = "Correo no registrado o contraseña no válida";
            _emailFormKey.currentState?.validate();
          }

          if (state.authFailure is ServerError) {
            _error = true;
          }
        }  
        
        if (state is SuccessfulSignIn){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard()), 
            (Route<dynamic> route) => false
          );
        }

        if (state is SuccessfulSignInGoogle) {
          setState(() {
            owner.ownerId = state.user.uid;
            owner.email = state.user.email;
            owner.name = state.user.displayName;
          });

          context.read<SignInBloc>().add(GetOwner(state.user.uid));
        }

        if (state is OwnerNotWereLoaded) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return BlocProvider(
                create: (context) => getIt<SignInBloc>(),
                child: _signInSetOwnerGoogle(context)
              );
            }
          );
        }
        
        if (state is OwnerLoaded) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard()), 
            (Route<dynamic> route) => false
          );
        }
      }
    );
  }

  Widget _signInSetOwnerGoogle(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
         if (state is SuccessfulSetOwner) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => InitialConfiguration()), 
            (Route<dynamic> route) => false
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
            child: Container(
            constraints: BoxConstraints(maxHeight: 260),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Crea tu cuenta en Conecta con Google',
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Se creará tu cuenta con tus datos permitidos de Google en nuestra plataforma',
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40),
                  ButtonPrimary(
                    progressIndicator: state is SetOwnerProcessing,
                    text: 'Configurar cuenta', 
                    onPressed: () {
                      context.read<SignInBloc>()
                        .add(SetOwner(owner));
                       /*Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => InitialConfiguration()), 
                          (Route<dynamic> route) => false
                        );*/
                    },
                    width: MediaQuery.of(context).size.width, 
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    ); 
  }

  Widget _signInBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _signInLogoWidget(context),
        SizedBox(height: 10),
        _signInSocialMediaWidget(context),
        SizedBox(height: 10),
        _signInSeparatorWidget(context),
        SizedBox(height: 10),
        Visibility(
          visible: _error,
          child: _signInErrorWidget(context),
        ),
        _signInFormularyWidget(context),
      ],
    );
  }

  Widget _signInLogoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _signInSocialMediaWidget(BuildContext context) {

    double inkWellWidth = (MediaQuery.of(context).size.width / 3) - 30;

     return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _signInScreenCloseDialogWidget(context);
                              }
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF10172F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: inkWellWidth,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/svg/apple-icon.svg',
                                height: 35,
                                semanticsLabel: 'Apple icon',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            context.read<SignInBloc>().add(SignInWithGoogle());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF10172F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: inkWellWidth,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/svg/google-icon.svg',
                                height: 35,
                                semanticsLabel: 'Google icon',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _signInScreenCloseDialogWidget(context);
                              }
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF10172F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: inkWellWidth,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/svg/facebook-icon.svg',
                                height: 35,
                                semanticsLabel: 'Facebook icon',
                              ),
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
    ); 
  }

  Widget _signInSeparatorWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                 child: Divider(
                   color: Color(0xFF2C2F3B)
                 ),
                ),
              ),
              SizedBox(width: 35),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF6F7177),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 10,
                height: 10,
              ),
              SizedBox(width: 35),
              Expanded(
                child: Container(
                 child: Divider(
                   color: Color(0xFF2C2F3B)
                 ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signInErrorWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    'Algo ha salido mal. Comprueba tu conexión e intentalo nuevamente.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _signInFormularyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _signInEmailFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInPasswordFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInRecoveryUserWidget(context),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInButtonWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInRecoveryPasswordWidget(context),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInRegisterUserWidget(context),
              ),
            ],
          ),
          SizedBox(height: 45),
          Row(
            children: <Widget>[
              Expanded(
                child: _signInTermsAndConditionsWidget(context),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _signInEmailFieldWidget(BuildContext context) {
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
                  fontWeight: FontWeight.normal,
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
                inputKey: _emailFormKey,
                error: _emailError,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Ingresa tu correo electrónico', 
                onChanged: (value) => _onEmailChanged(value!),
                validator: (value) => _emailValidator(value!),
                icon: Icons.email,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signInPasswordFieldWidget(BuildContext context) {
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
                  fontWeight: FontWeight.normal,
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

  Widget _signInRecoveryUserWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CheckboxListTile(
                title: Text(
                  'Recordar usuario',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                value: _recoveryUser,
                onChanged: (value) {
                  setState(() {
                    _recoveryUser = value ?? false;
                  });
                },
                activeColor: Color(0xFF8C939B),
                contentPadding: EdgeInsets.all(0),
                controlAffinity: ListTileControlAffinity.leading,
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget _signInButtonWidget(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonPrimary(
                    progressIndicator: state is Processing,
                    text: 'Ingresar', 
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Dashboard()), 
                        (Route<dynamic> route) => false
                      );
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
    ); 
  }

  Widget _signInRecoveryPasswordWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Olvidé mi contraseña',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _signInScreenCloseDialogWidget(context);
                  }
                );
              },
              child: Text(
                'Recuperar',
                style: TextStyle(
                  color: Color(0xFF00B6E6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signInRegisterUserWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUp()), 
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Crear nuevo usuario',
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

  Widget _signInTermsAndConditionsWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Términos y condiciones',
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

  Widget _signInScreenCloseDialogWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 225),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Próximamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Nos estamos preparando para ofrecerte esto en futuras versiones. Te tendrémos informado sobre nuestras próximas actualizaciones.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              ButtonPrimary(
                text: 'De acuerdo, gracias', 
                onPressed: () {
                  Navigator.of(context).pop();
                },
                width: MediaQuery.of(context).size.width, 
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _onEmailChanged(String value) {
    setState(() {
      _emailError = null;
      _emailFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _emailValidator(String value) {
    if(_emailError != null)
      return _emailError;
    return _emailController.text.trimLeft().length == 0
        ? "Debe ingresar su email"
        : null;
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _passwordValidator(String value) {
    return _passwordController.text.trimLeft().length == 0
        ? "Debe ingresar su contraseña"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_emailFormKey.currentState?.isValid ?? false) && 
      (_passwordFormKey.currentState?.isValid ?? false);
  }
}
