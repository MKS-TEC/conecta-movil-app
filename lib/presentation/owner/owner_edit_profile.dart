import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/owner/edit_profile/owner_edit_profile_bloc.dart';
import 'package:conecta/application/owner/edit_profile/owner_edit_profile_event.dart';
import 'package:conecta/application/owner/edit_profile/owner_edit_profile_state.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

class OwnerEditProfile extends StatefulWidget {
  OwnerEditProfile({Key? key}) : super(key: key);

  @override
  State<OwnerEditProfile> createState() => _OwnerEditProfileState();
}

class _OwnerEditProfileState extends State<OwnerEditProfile> {
  User? user;
  Owner? owner;
  List<Challenge> ownerChallenges = List<Challenge>.empty();
  List<AppEvent> appEvents = List<AppEvent>.empty();
  Challenge challengeUpdate = Challenge();
  bool _loadingChallenges = true;
  bool _getChallengesError = false;
  bool _loadingOwner = true;
  bool _getOwnerError = false;

  final TextEditingController _firstNameController = TextEditingController();
  final GlobalKey<FormFieldState> _firstNameFormKey = GlobalKey<FormFieldState>();

  final TextEditingController _lastNameController = TextEditingController();
  final GlobalKey<FormFieldState> _lastNameFormKey = GlobalKey<FormFieldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormFieldState> _phoneNumberFormKey = GlobalKey<FormFieldState>();

  final TextEditingController _documentNumberController = TextEditingController();
  final GlobalKey<FormFieldState> _documentNumberFormKey = GlobalKey<FormFieldState>();

  List<dynamic> _cities = ["Ciudad"];
  List<String> _personTypes = <String>["Natural", "Jurídica"];
  List<dynamic> _documentTypes = ["D"];
  List<Country> _countries = List<Country>.empty();

  File? file;
  final ImagePicker _picker = ImagePicker();
  bool _deletePicture = false;

  String? _phoneCountryCode = "+51";
  String? _country = "Perú";
  Country? _countryOwner;
  String? _city = "Ciudad";
  String? _documentType;
  String? _personType;
  bool _validForm = false;

  void _createAppEvent(BuildContext context) {
    AppEvent appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == "profilecompleted", orElse: () => AppEvent());

    if (appEvent.appEventId == null) {
      appEvent.name = "ProfileCompleted";

      context.read<OwnerEditProfileBloc>().add(CreateAppEvent(user!.uid, appEvent));
    } else if (ownerChallenges.length > 0) {
      _updateChallengeActivity(context);
    } else {
      showSnackbar("Se ha modificado tu perfil con éxito", false);
      Navigator.of(context).pop();
    }
  }

  void _updateChallengeActivity(BuildContext context) {
    for (var i = 0; i < ownerChallenges.length; i++) {
      for (var a = 0; a < ownerChallenges[i].challengeActivities!.length; a++) {
        if (ownerChallenges[i].challengeActivities?[a].associatedAppEvent?.toLowerCase() == "profilecompleted" && ownerChallenges[i].challengeActivities?[a].status?.toLowerCase() == "pending") {
          context.read<OwnerEditProfileBloc>().add(UpdateChallengeActivity(user!.uid, ownerChallenges[i].challengeActivities?[a].challengeId ?? "", ownerChallenges[i].challengeActivities![a]));
          break;
        }

        if (i == ownerChallenges.length - 1) {
          showSnackbar("Se ha modificado tu perfil con éxito", false);
          Navigator.of(context).pop();
        }
      }
    }
  }

  void _updateChallenge(BuildContext context, String challengeId) {
    Challenge challenge = ownerChallenges.firstWhere((challengeFind) => challengeFind.challengeId == challengeId, orElse: () => Challenge());
    List<ChallengeActivity> _challengeActivityDone = <ChallengeActivity>[];

    ownerChallenges.forEach((challenge) => {
      challenge.challengeActivities?.forEach((challengeActivity) {
        if (challengeActivity.status?.toLowerCase() == "done" && challengeActivity.challengeId == challengeId) {
          _challengeActivityDone.add(challengeActivity);
        }
      })
    });

    if (challenge.challengeActivities!.length == _challengeActivityDone.length + 1) {
      setState(() {
        challengeUpdate = challenge;
      });

      context.read<OwnerEditProfileBloc>().add(UpdateChallenge(owner?.ownerId ?? user!.uid, challengeId));
    } else {
      showSnackbar("Se ha modificado tu perfil con éxito", false);
    }
  }

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

  void ownerSetDataFormulary(Owner pet) {
    setState(() {
      _firstNameController.text = owner?.name ?? "";
      _lastNameController.text = owner?.lastName ?? "";
      _phoneCountryCode = owner?.phoneCountryCode != null && owner!.phoneCountryCode!.length > 0 ? owner?.phoneCountryCode : "+51";
      _phoneNumberController.text = owner?.phoneNumber ?? "";
      _country = owner?.country != null && owner!.country!.length > 0 ? owner?.country : "Perú";
      _city = owner?.city != null && owner!.city!.length > 0 ? owner?.city : "Seleccionar";
      _personType = owner?.personType != null && owner!.personType!.length > 0 ? owner?.personType : "Natural";
      _documentType = owner?.documentType != null && owner!.documentType!.length > 0 ? owner?.documentType : "D";
      _documentNumberController.text = owner?.documentNumber ?? "";
    });

    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<OwnerEditProfileBloc>(
          create: (BuildContext context) => getIt<OwnerEditProfileBloc>(),
        ),
      ], 
      child: _ownerEditProfileLayoutWidget(context)
    );
  }

  Widget _ownerEditProfileLayoutWidget(BuildContext context) {
     return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                user = state.user;
              });

              context.read<OwnerEditProfileBloc>().add(GetOwner(state.user!.uid));
              context.read<OwnerEditProfileBloc>().add(GetOwnerChallenges(state.user!.uid));
            }

            if (state is UnauthenticatedSubject) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()), 
                (Route<dynamic> route) => false
              );
            }
          },
        ),
        BlocListener<OwnerEditProfileBloc, OwnerEditProfileState>(
          listener: (context, state) {
             if (state is OwnerLoaded) {
              setState(() {
                owner = state.owner;
                _loadingOwner = false;
                _getOwnerError = false;
              });
              
              context.read<OwnerEditProfileBloc>().add(GetCountries());

              ownerSetDataFormulary(state.owner);
            }

            if (state is OwnerNotLoaded) {
              setState(() {
                _loadingOwner = false;
                _getOwnerError = true;
              });
            }
            
            if (state is CountriesLoaded) {
              setState(() {
                _countries = state.countries;
                Country country = state.countries.firstWhere((c) => c.countryId == owner?.country);
                _cities = country.cities!;
                _countryOwner = country;

                _cities.add("Seleccionar");

                if(owner?.personType == "Natural" || owner?.personType == null){
                  _documentTypes = country.naturalIds ?? [];
                  _documentTypes.add("D");
                }else{
                  _documentTypes = country.juridicIds ?? [];
                  _documentTypes.add("D");
                }
              });
            }

            if (state is ChallengesOwnerLoaded) {
              setState(() {
                ownerChallenges = state.challenges;
              });

              context.read<OwnerEditProfileBloc>().add(GetAppEvents(user!.uid));
            }

            if (state is AppEventsLoaded) {
              setState(() {
                appEvents = state.appEvents;
                _getChallengesError = false;
                _loadingChallenges = false;
              });
            }

            if (state is AppEventsNotWereLoaded) {
              setState(() {
                _getChallengesError = true;
                _loadingChallenges = false;
              });
            }

            if (state is ChallengesOwnerNotWereLoaded) {
              setState(() {
                _getChallengesError = true;
                _loadingChallenges = false;
              });
            }

            if (state is GetChallengesOwnerProcessing) {
              setState(() {
                _getChallengesError = false;
                _loadingChallenges = true;
              });
            }

            if (state is SuccessfulUpdateOwner) {
              _createAppEvent(context);
            }

            if (state is SuccessfulCreateAppEvent) {
              setState(() {
                appEvents.add(state.appEvent);
              });

              if (ownerChallenges.length > 0) {
                _updateChallengeActivity(context);
              } else {
                showSnackbar("Se ha modificado tu perfil con éxito", false);
              }
            }

            if (state is FailuredUpdateOwner) {
              showSnackbar("No se ha podido modificar tu perfil", true);
            }

            if (state is SuccessfulUpdateChallengeActivity) {
              _updateChallenge(context, state.challenge.challengeId ?? "");
            }

            if (state is SuccessfulUpdateChallenge) {
              context.read<OwnerEditProfileBloc>().add(UpdatePetPoints(owner?.ownerId ?? user!.uid, challengeUpdate.marketPoints!));
            }

            if (state is SuccessfulUpdatePetPoints) {
              showSnackbar("Se ha modificado tu perfil con éxito", false);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _challengeCompleteWidget(context, challengeUpdate);
                }
              );
            
              context.read<AuthBloc>().add(GetAuthenticatedSubject());
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
              child: _ownerEditProfileBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _ownerEditProfileCheckDataWidget(BuildContext context) {
    if (_loadingOwner || _loadingChallenges) {
      return _ownerEditProfileLoadingWidget(context);
    } else if (_getOwnerError || _getChallengesError) {
      return _ownerEditProfileErrorWidget(context);
    } else if (owner == null) {
      return _ownerEditProfileEmptyWidget(context);
    } else {
      return _ownerEditProfileFormularyWidget(context);
    }
  }

  Widget _ownerEditProfileLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _ownerEditProfileErrorWidget(BuildContext context) {
    return BlocBuilder<OwnerEditProfileBloc, OwnerEditProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<OwnerEditProfileBloc>().add(GetOwner(owner?.ownerId ?? ""));
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

  Widget _ownerEditProfileEmptyWidget(BuildContext context) {
    return BlocBuilder<OwnerEditProfileBloc, OwnerEditProfileState>(
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

  Widget _ownerEditProfileBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _ownerEditProfileBackButtonWidget(context),
        _ownerEditProfileCheckDataWidget(context),
      ],
    );
  }

  Widget _ownerEditProfileBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
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
                    size: 45,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Editar perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _ownerEditProfileFormularyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfilePictureWidget(context),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileFirstnameFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileLastnameFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfilePhoneCountriesCodesFieldWidget(context),
              ),
              Expanded(
                flex: 2,
                child: _ownerEditProfilePhoneNumberFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileCountryFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileCitiesFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfilePersonTypesFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileDocumentTypesFieldWidget(context),
              ),
              Expanded(
                flex: 2,
                child: _ownerEditProfileDocumentNumberFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: <Widget>[
              Expanded(
                child: _ownerEditProfileSaveButtonWidget(context),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _ownerEditProfileFirstnameFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _firstNameFormKey,
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                hintText: 'Nombre', 
                onChanged: (value) => _onFirstNameChanged(value!),
                validator: (value) => _firstNameValidator(value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfilePictureWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: _selectAndPickImage,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF86A3A3),
                  radius: 48,
                  child: file != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      File(file!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ) : owner?.profilePictureUrl != null && owner!.profilePictureUrl!.length > 0 && !_deletePicture ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      owner?.profilePictureUrl ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ) : Container(
                    child: Text(
                      owner?.name != null ? owner!.name![0].toUpperCase() : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nexa',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Visibility(
                visible: file != null,
                child: ButtonPrimary(
                  text: 'Cancelar', 
                  onPressed: () {
                    setState(() {
                      file = null;
                    });
                  }, 
                  width: 150, 
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Visibility(
                visible: owner?.profilePictureUrl != null && owner!.profilePictureUrl!.length > 0 && file == null && !_deletePicture,
                child: ButtonPrimary(
                  text: 'Eliminar foto', 
                  onPressed: () {
                    setState(() {
                      _deletePicture = true;
                      file = null;
                    });

                    _validateForm();
                  }, 
                  width: 150, 
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileLastnameFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _lastNameFormKey,
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                hintText: 'Apellido', 
                onChanged: (value) => _onLastNameChanged(value!),
                validator: (value) => _lastNameValidator(value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfilePhoneCountriesCodesFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  value: _phoneCountryCode,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00B6E6),
                  ),
                  isExpanded: true,
                  elevation: 0,    
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    "+51",
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                    ),
                  ),
                  items: _countries.map((Country value) {
                    return DropdownMenuItem<String>(
                      value: value.phoneCountryCode,
                      child: Text(
                        value.phoneCountryCode.toString(),
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _phoneCountryCode = value;
                    });

                    _validateForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfilePhoneNumberFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextFieldDark(
                inputKey: _phoneNumberFormKey,
                controller: _phoneNumberController,
                keyboardType: TextInputType.text,
                hintText: 'Número de teléfono', 
                onChanged: (value) => _onPhoneNumberChanged(value!),
                validator: (value) => _phoneNumberValidator(value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileCountryFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  value: _country,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00B6E6),
                  ),
                  isExpanded: true,
                  elevation: 0,    
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    "Perú",
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                    ),
                  ),
                  items: _countries.map((Country value) {
                    return DropdownMenuItem<String>(
                      value: value.countryId,
                      child: Text(
                        value.countryId.toString(),
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      var c = _countries.firstWhere((c) => c.countryId == value);
                      _country = value;
                      _countryOwner = _countries.firstWhere((c) => c.countryId == value);
                      _cities = c.cities!;
                      _city = null;

                      if(_personType == "Natural"){
                        _documentTypes = c.naturalIds ?? [];
                        _documentTypes.add("D");
                      }else{
                        _documentTypes = c.juridicIds ?? [];
                        _documentTypes.add("D");
                      }
                    });

                    _validateForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileCitiesFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  value: _city,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00B6E6),
                  ),
                  isExpanded: true,
                  elevation: 0,    
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    "Lima",
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                    ),
                  ),
                  items: _cities.map((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _city = value;
                    });
                    _validateForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfilePersonTypesFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  value: _personType,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00B6E6),
                  ),
                  isExpanded: true,
                  elevation: 0,    
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    "Natural",
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                    ),
                  ),
                  items: _personTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _personType = value;
                      if(value == "Natural"){
                        _documentTypes = _countryOwner!.naturalIds ?? [];
                        _documentTypes.add("D");
                      }else{
                        _documentTypes = _countryOwner!.juridicIds ?? [];
                        _documentTypes.add("D");
                      }
                    });

                    _validateForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileDocumentTypesFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00B6E6),
                  ),
                  isExpanded: true,
                  elevation: 0,    
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    "D",
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                    ),
                  ),
                  items: _documentTypes.map((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _documentType = value;
                    });

                    _validateForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileDocumentNumberFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextFieldDark(
                inputKey: _documentNumberFormKey,
                controller: _documentNumberController,
                keyboardType: TextInputType.text,
                hintText: 'Número documento', 
                onChanged: (value) => _onDocumentNumberChanged(value!),
                validator: (value) => _documentNumberValidator(value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ownerEditProfileSaveButtonWidget(BuildContext context) {
    return BlocBuilder<OwnerEditProfileBloc, OwnerEditProfileState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonPrimary(
                    progressIndicator: state is UpdateOwnerProcessing || state is UpdateChallengeActivityProcessing || state is UpdateChallengeProcessing,
                    text: 'Guardar cambios', 
                    onPressed: _validForm ? () {
                      Owner _owner = Owner();
                      _owner.ownerId = owner?.ownerId ?? user?.uid;
                      _owner.name = _firstNameController.text;
                      _owner.lastName = _lastNameController.text;
                      _owner.country = _country;
                      _owner.city = _city;
                      _owner.phoneCountryCode = _phoneCountryCode;
                      _owner.phoneNumber = _phoneNumberController.text;
                      _owner.personType = _personType;
                      _owner.documentType = _documentType;
                      _owner.documentNumber = _documentNumberController.text;
                      _owner.profilePicture = file;
                      _owner.profilePictureUrl = _deletePicture ? null : owner?.profilePictureUrl ?? null;

                      context.read<OwnerEditProfileBloc>()
                        .add(UpdateOwner(_owner));
                    } : () {
                      _validateForm();
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

  Widget _challengeCompleteWidget(BuildContext context, Challenge challenge) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        content: Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF00B6E6),
              ),
              child: Visibility(
                visible: challenge.imageUrl != null && challenge.imageUrl!.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.network(
                    challenge.imageUrl ?? "",
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "¡Felicidades! Has completado un desafio",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00B6E6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Has completado el desafio ${challenge.title}. Por haber completado este desafio te premiamos con una sumatoria de ${challenge.marketPoints} Pet Points en tu cuenta para que puedas utilizarlos.',
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      text: '¡Gracias!', 
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      width: MediaQuery.of(context).size.width, 
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(pickedFile!.path);
    });

    _validateForm();
  }

  void _onFirstNameChanged(String value) {
    setState(() {
      _firstNameFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _firstNameValidator(String value) {
    return _firstNameController.text.trimLeft().length == 0
        ? "Debe ingresar su nombre"
        : null;
  }

  void _onLastNameChanged(String value) {
    setState(() {
      _lastNameFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _lastNameValidator(String value) {
    return _lastNameController.text.trimLeft().length == 0
        ? "Debe ingresar su apellido"
        : null;
  }

  void _onPhoneNumberChanged(String value) {
    setState(() {
      _phoneNumberFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _phoneNumberValidator(String value) {
    return _phoneNumberController.text.trimLeft().length == 0
        ? "Debe ingresar su número de teléfono"
        : null;
  }

  void _onDocumentNumberChanged(String value) {
    setState(() {
      _documentNumberFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _documentNumberValidator(String value) {
    return _documentNumberController.text.trimLeft().length == 0
        ? "Debe ingresar su número de documento"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_firstNameFormKey.currentState?.isValid ?? false) && 
      (_lastNameFormKey.currentState?.isValid ?? false) &&
      (_phoneNumberFormKey.currentState?.isValid ?? false) &&
      (_documentNumberFormKey.currentState?.isValid ?? false) &&
      (_phoneCountryCode != null) &&
      (_country != null) &&
      (_city != null) &&
      (_documentType != null) &&
      (_personType != null);
  }
}