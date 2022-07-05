import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/owner/profile/owner_profile_bloc.dart';
import 'package:conecta/application/owner/profile/owner_profile_event.dart';
import 'package:conecta/application/owner/profile/owner_profile_state.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/owner/owner_edit_profile.dart';
import 'package:conecta/presentation/owner/owner_pets.dart';
import 'package:conecta/presentation/share_code/share_code.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

class OwnerProfile extends StatefulWidget {
  OwnerProfile({Key? key}) : super(key: key);

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  User? user;
  Owner? owner;
  bool _loadingOwner = true;
  bool _getOwnerError = false;
  List<Pet> pets = List<Pet>.empty();
  List<Country> _countries = List<Country>.empty();
  bool _loadingPets = true;
  bool _getPetsError = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<OwnerProfileBloc>(
          create: (BuildContext context) => getIt<OwnerProfileBloc>(),
        ),
      ], 
      child: _ownerProfileLayoutWidget(context)
    );
  }

  Widget _ownerProfileLayoutWidget(BuildContext context) {
     return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                owner?.ownerId = state.user?.uid;
                user = state.user;
              });

              context.read<OwnerProfileBloc>().add(GetOwner(state.user!.uid));
              context.read<OwnerProfileBloc>().add(GetOwnerPets(state.user!.uid));
            }

            if (state is UnauthenticatedSubject) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()), 
                (Route<dynamic> route) => false
              );
            }
          },
        ),
        BlocListener<OwnerProfileBloc, OwnerProfileState>(
          listener: (context, state) {
            if (state is OwnerLoaded) {
              setState(() {
                owner = state.owner;
                _loadingOwner = false;
                _getOwnerError = false;
              });
            }
            
            if (state is OwnerPetsLoaded) {
              setState(() {
                pets = state.pets;
                _loadingOwner = false;
                _getOwnerError = false;
              });
            }

            if (state is OwnerNotLoaded) {
              setState(() {
                _loadingOwner = false;
                _getOwnerError = true;
              });
            }
            
            if (state is OwnerPetsNotLoaded) {
              setState(() {
                _loadingOwner = false;
                _getOwnerError = true;
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
              child: _ownerProfileBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _ownerProfileBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _ownerProfileHeaderWidget(context),
        Visibility(
          visible: !_loadingOwner && !_getOwnerError,
          child: _ownerProfileAvatarWidget(context),
        ),
        SizedBox(height: 50),
        _ownerProfileCheckDataWidget(context),
        SizedBox(height: 55),
        Visibility(
          visible: !_loadingOwner && !_getOwnerError,
          child: _ownerProfileOptionsWidget(context),
        ),
      ],
    );
  }

  Widget _ownerProfileCheckDataWidget(BuildContext context) {
    if (_loadingOwner) {
      return _ownerProfileLoadingWidget(context);
    } else if (_getOwnerError) {
      return _ownerProfileErrorWidget(context);
    } else if (owner == null) {
      return _ownerProfileEmptyWidget(context);
    } else {
      return _ownerProfileSummaryWidget(context);
    }
  }

  Widget _ownerProfileLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _ownerProfileErrorWidget(BuildContext context) {
    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<OwnerProfileBloc>().add(GetOwner(owner?.ownerId ?? ""));
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'Ocurrió un error inésperado. Comprueba tu conexión a Internet e intentalo nuevamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Toca para reintentar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    ); 
  }

  Widget _ownerProfileEmptyWidget(BuildContext context) {
    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, state) {
        return Container(
          height: 75,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'No se ha encontrado tu perfil.',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      }
    ); 
  }

  Widget _ownerProfileHeaderWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
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
                      size: 35,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Mi perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _screenCloseDialogWidget(context);
                      }
                    );
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    child: Icon(
                      Icons.settings,
                      color: Color(0xFF6F7177),
                      size: 30,
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

  Widget _ownerProfileAvatarWidget(BuildContext context) {
    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OwnerEditProfile()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    owner?.profilePictureUrl != null && owner!.profilePictureUrl!.length > 0 ? ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          owner!.profilePictureUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ) : Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFEB9448),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(20),
                      height: 75,
                      width: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            owner?.name != null && owner!.name!.length > 0 ? '${owner?.name![0]}' : user?.displayName != null && user!.displayName!.length > 0 ? '${user?.displayName![0]}' : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        owner?.name != null && owner?.lastName != null ? '${owner?.name} ${owner?.lastName}' : owner?.name ?? user?.displayName ?? "",
                        textAlign: TextAlign.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/img/medails-3.png",
                      fit: BoxFit.cover,
                      width: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    ); 
  }

  Widget _ownerProfileSummaryWidget(BuildContext context) {
    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => OwnerEditProfile()),
              //     ).then((value) {
              //       if (owner?.ownerId != null) {
              //         setState(() {
              //           _loadingOwner = true;
              //         });

              //         context.read<OwnerProfileBloc>().add(GetOwner(owner?.ownerId ?? ""));
              //       }
              //     });
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Expanded(
              //         child: Text(
              //           'Completar perfil',
              //           style: TextStyle(
              //             color: Color(0xFF6F7177),
              //             fontSize: 16,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       ),
              //       Text(
              //         '70%',
              //         style: TextStyle(
              //           color: Color(0xFF6F7177),
              //           fontSize: 16,
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _ownerProfileSummaryDetailWidget(
                      context, 
                      'assets/svg/dog.svg',
                      30,
                      'Mis mascotas', 
                      pets.length.toString(),
                    ),
                  ),
                  // Expanded(
                  //   child: _ownerProfileSummaryDetailWidget(
                  //     context, 
                  //     'assets/svg/followers.svg',
                  //     50,
                  //     'Seguidores', 
                  //     '0',
                  //   ),
                  // ),
                  // Expanded(
                  //   child: _ownerProfileSummaryDetailWidget(
                  //     context, 
                  //     'assets/svg/edit.svg',
                  //     30,
                  //     'Publicaciones', 
                  //     '0',
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ); 
      }
    );
  }

  Widget _ownerProfileSummaryDetailWidget(BuildContext context, String path, double size, String title, String quantity) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          path,
          width: size,
          semanticsLabel: 'summary detail icon',
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF6F7177),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20),
        Text(
          quantity,
          style: TextStyle(
            color: Color(0xFFE0E0E3),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _ownerProfileOptionsWidget(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OwnerPets()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Administrar mascotas',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _screenCloseDialogWidget(context);
                          }
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Notificaciones',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ShareCode()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Invita a pet lovers',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(SignedOut());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
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
    ); 
  }

  Widget _screenCloseDialogWidget(BuildContext context) {
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
}