import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/pet/pet_profile/pet_profile_bloc.dart';
import 'package:conecta/application/pet/pet_profile/pet_profile_event.dart';
import 'package:conecta/application/pet/pet_profile/pet_profile_state.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/common/text_field/text_field_secondary.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

class PetProfile extends StatefulWidget {
  final String petId;

  PetProfile({required this.petId, Key? key}) : super(key: key);

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  User? user;
  Pet? pet;
  List<Challenge> ownerChallenges = List<Challenge>.empty();
  List<AppEvent> appEvents = List<AppEvent>.empty();
  Challenge challengeUpdate = Challenge();
  bool _loadingChallenges = true;
  bool _getChallengesError = false;
  bool _loadingPet = true;
  bool _getPetError = false;

  final TextEditingController _petNameTextEditingController = TextEditingController();
  final GlobalKey<FormFieldState> _petNameFormKey = GlobalKey<FormFieldState>();
  
  final TextEditingController _petAboutTextEditingController = TextEditingController();
  final GlobalKey<FormFieldState> _petAboutFormKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _searchBreedFormKey = GlobalKey<FormFieldState>();
  TextEditingController _searchBreedController = TextEditingController();

  String? _petSex;
  String? _petSpecie;
  DateTime? _petBirthdate;
  bool _deletePicture = false;

  List<Breed> breeds = List<Breed>.empty(growable: true);
  List<Breed> breedsFound = <Breed>[];

  bool _loadingBreeds = false;

  bool _validForm = true;

  File? file;
  final ImagePicker _picker = ImagePicker();

  void _updateChallengeActivityPetPicture(BuildContext context) {
    for (var i = 0; i < ownerChallenges.length; i++) {
      for (var a = 0; a < ownerChallenges[i].challengeActivities!.length; a++) {
        if (ownerChallenges[i].challengeActivities?[a].associatedAppEvent?.toLowerCase() == "petprofilepictureupdated" && ownerChallenges[i].challengeActivities?[a].status?.toLowerCase() == "pending") {
          context.read<PetProfileBloc>().add(UpdateChallengeActivity(user!.uid, ownerChallenges[i].challengeActivities?[a].challengeId ?? "", ownerChallenges[i].challengeActivities![a]));
          break;
        }
      }
    }
  }

  void _createAppEventPetPicture(BuildContext context) {
    AppEvent appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == "petprofilepictureupdated", orElse: () => AppEvent());

    if (appEvent.appEventId == null) {
      appEvent.name = "PetProfilePictureUpdated";

      context.read<PetProfileBloc>().add(CreateAppEvent(user!.uid, appEvent));
    } else if (ownerChallenges.length > 0) {
      _updateChallengeActivityPetPicture(context);
    }
  }

  void _createAppEvent(BuildContext context) {
    AppEvent appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == "petprofilecompleted", orElse: () => AppEvent());

    if (appEvent.appEventId == null) {
      appEvent.name = "PetProfileCompleted";

      context.read<PetProfileBloc>().add(CreateAppEvent(user!.uid, appEvent));
    } else if (ownerChallenges.length > 0) {
      _updateChallengeActivity(context);
    } else {
      showSnackbar("Se ha modificado tu mascota con éxito", false);
    }
  }

  void _updateChallengeActivity(BuildContext context) {
    for (var i = 0; i < ownerChallenges.length; i++) {
      for (var a = 0; a < ownerChallenges[i].challengeActivities!.length; a++) {
        if (ownerChallenges[i].challengeActivities?[a].associatedAppEvent?.toLowerCase() == "petprofilecompleted" && ownerChallenges[i].challengeActivities?[a].status?.toLowerCase() == "pending") {
          context.read<PetProfileBloc>().add(UpdateChallengeActivity(user!.uid, ownerChallenges[i].challengeActivities?[a].challengeId ?? "", ownerChallenges[i].challengeActivities![a]));
          break;
        }

        if (i == ownerChallenges.length - 1) {
          showSnackbar("Se ha modificado tu mascota con éxito", false);
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

      context.read<PetProfileBloc>().add(UpdateChallenge(user!.uid, challengeId));
    } else {
      showSnackbar("Se ha modificado tu mascota con éxito", false);
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

  void _onSearchBreeds(String value) {
    if (value.length > 0) {
      List<Breed> _breedsFound = <Breed>[];

      breeds.forEach((Breed breed) { 
        if (breed.name!.toLowerCase().startsWith(value.toLowerCase())) {
          _breedsFound.add(breed);
        }
      });

      setState(() {
        breedsFound = _breedsFound;
      });

      return;
    }

    setState(() {
      breedsFound = [];
    });
  }

  void petSetDataFormulary(Pet pet) {
    setState(() {
      _petNameTextEditingController.text = pet.name ?? "";
      _petAboutTextEditingController.text = pet.about ?? "";
      _petSpecie = pet.breed;
      _petSex = pet.sex ?? "Masculino";
      _petBirthdate = pet.birthdate;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<PetProfileBloc>(
          create: (BuildContext context) => getIt<PetProfileBloc>(),
        ),
      ], 
      child: _petProfileLayoutWidget(context)
    );
  }

  Widget _petProfileLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                user = state.user;
              });

              context.read<PetProfileBloc>().add(GetPet(widget.petId));
            }

            if (state is UnauthenticatedSubject) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()), 
                (Route<dynamic> route) => false
              );
            }
          },
        ),
        BlocListener<PetProfileBloc, PetProfileState>(
          listener: (context, state) {
            if (state is PetLoaded) {
              setState(() {
                pet = state.pet;
                _loadingPet = false;
                _getPetError = false;
              });

              petSetDataFormulary(state.pet);

              context.read<PetProfileBloc>().add(GetBreedsBySpecies(state.pet.species ?? ''));
              context.read<PetProfileBloc>().add(GetOwnerChallenges(user!.uid));
            }

            if (state is PetNotLoaded) {
              setState(() {
                _loadingPet = false;
                _getPetError = true;
              });
            }

            if (state is BreedsLoaded) {
              setState(() {
                breeds = state.breeds;
                _loadingBreeds = false;
              });

              if (_searchBreedController.text.isNotEmpty) {
                _onSearchBreeds(_searchBreedController.text);
              }
            }

            if (state is SuccessfulUpdatePet) {
              _createAppEvent(context);

              if (file != null) {
                _createAppEventPetPicture(context);
              }
            }

            if (state is SuccessfulCreateAppEvent) {
              setState(() {
                appEvents.add(state.appEvent);
              });

              if (state.appEvent.name?.toLowerCase() == "petprofilepictureupdated") {
                _updateChallengeActivityPetPicture(context);
              } else if (ownerChallenges.length > 0) {
                _updateChallengeActivity(context);
              } else {
                showSnackbar("Se ha modificado tu mascota con éxito", false);
              }
            }

            if (state is FailuredUpdatePet) {
              showSnackbar("No se ha podido modificar tu mascota", true);
            }

            if (state is ChallengesOwnerLoaded) {
              setState(() {
                ownerChallenges = state.challenges;
              });

              context.read<PetProfileBloc>().add(GetAppEvents(user!.uid));
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

            if (state is SuccessfulUpdateChallengeActivity) {
              _updateChallenge(context, state.challenge.challengeId ?? "");
            }

            if (state is SuccessfulUpdateChallenge) {
              context.read<PetProfileBloc>().add(UpdatePetPoints(user!.uid, challengeUpdate.marketPoints!));
            }

            if (state is SuccessfulUpdatePetPoints) {
              showSnackbar("Se ha modificado tu mascota con éxito", false);

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
              child: _petProfileBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _petProfileBackButtonWidget(BuildContext context) {
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
                  'Mascota',
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

  Widget _petProfileCheckDataWidget(BuildContext context) {
    if (_loadingPet || _loadingChallenges) {
      return _petProfileLoadingWidget(context);
    } else if (_getPetError || _getChallengesError) {
      return _petProfileErrorWidget(context);
    } else if (pet == null) {
      return _petProfileEmptyWidget(context);
    } else {
      return _petProfileFormularyWidget(context);
    }
  }

  Widget _petProfileLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _petProfileErrorWidget(BuildContext context) {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<PetProfileBloc>().add(GetPet(widget.petId));
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

  Widget _petProfileEmptyWidget(BuildContext context) {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
      builder: (context, state) {
        return Container(
          height: 75,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'No se ha encontrado tu mascota.',
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

  Widget _petProfileBodyWidget(BuildContext context) {
    return Column(
      children:[
        _petProfileBackButtonWidget(context),
        _petProfileCheckDataWidget(context),
      ]
    );
  }

  Widget _petProfileFormularyWidget(BuildContext context) {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              InkWell(
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
                  ) : pet?.picture != null && pet!.picture!.length > 0 && !_deletePicture ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      pet?.picture ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ) : Container(
                    child: Text(
                      pet?.name != null ? pet!.name![0].toUpperCase() : '',
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
              SizedBox(
                height: 20,
              ),
              Visibility(
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
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: pet?.picture != null && pet!.picture!.length > 0 && file == null && !_deletePicture,
                child: ButtonPrimary(
                  text: 'Eliminar foto', 
                  onPressed: () {
                    setState(() {
                      _deletePicture = true;
                      file = null;
                    });
                  }, 
                  width: 150, 
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _petInformationGenrerSelectWidget(context),
              SizedBox(
                height: 40,
              ),
              TextFieldDark(
                inputKey: _petNameFormKey, 
                controller: _petNameTextEditingController, 
                hintText: 'Mi nombre', 
                onChanged: (e) {
                  _validateForm();
                }, 
                validator:(value) => _textValidator(value!, "Debes ingresar un nombre")
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 3, 5),
                    maxTime: DateTime.now(), 
                    onConfirm: (DateTime date) {
                      setState(() {
                        _petBirthdate = date;
                      });

                      _validateForm();
                    }, 
                    currentTime: DateTime.now(), locale: LocaleType.es,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _petBirthdate != null ? '${_petBirthdate?.day}/${_petBirthdate?.month}/${_petBirthdate?.year}' : 'Fecha de nacimiento',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/img/calendar-icon.png',
                          fit: BoxFit.cover,
                          width: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    builder: (context) => _beedsSheetMenuWidget(context)
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _petSpecie ?? 'Raza',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Color(0xFF00B6E6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFieldDark(
                inputKey: _petAboutFormKey, 
                controller: _petAboutTextEditingController, 
                hintText: 'Acerca de mi', 
                onChanged: (e){
                  setState(() {
                    print(e);
                  });
                }, 
                validator:(value) => _textValidator(value!, "Debes ingresar una nombre")
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ButtonPrimary(
                  progressIndicator: state is UpdatePetProcessing,
                  text: 'Guardar cambios', 
                  onPressed: _validForm ? () {
                    Pet _pet = Pet();
                    _pet.petId = widget.petId;
                    _pet.name = _petNameTextEditingController.text;
                    _pet.birthdate = _petBirthdate;
                    _pet.breed = _petSpecie;
                    _pet.pictureFile = file;
                    _pet.picture = _deletePicture ? null : pet?.picture ?? null;
                    _pet.sex = _petSex;
                    _pet.about = _petAboutTextEditingController.text;

                    context.read<PetProfileBloc>()
                      .add(UpdatePet(_pet));
                  } : null, 
                  width: MediaQuery.of(context).size.width, 
                  fontSize: 18,
                ),
              ),
            ]
          )
        );
      }
    );
  }

  Widget _petInformationGenrerSelectWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _petSex = 'Masculino';
                  });

                  _validateForm();
                }, 
                child: Card(
                  color: _petSex == 'Masculino' ? Color(0xFF00B6E6) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            _petSex == 'Masculino' ? 'assets/img/male-icon-white.png' : 'assets/img/male-icon.png',
                            fit: BoxFit.cover,
                            width: 25,
                          ),
                        ),
                        Expanded(
                          child:  Text(
                            'Macho',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _petSex == 'Masculino' ? Colors.white : Color(0xFF00B6E6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ),
            SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _petSex = 'Femenino';
                  });

                  _validateForm();
                }, 
                child: Card(
                  color: _petSex == 'Femenino' ? Color(0xFF00B6E6) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            _petSex == 'Femenino' ? 'assets/img/female-icon-white.png' : 'assets/img/female-icon.png',
                            fit: BoxFit.cover,
                            width: 20,
                          ),
                        ),
                        Expanded(
                          child:  Text(
                            'Hembra',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _petSex == 'Femenino' ? Colors.white : Color(0xFF00B6E6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _beedsSheetMenuWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _breedsSearchFieldWidget(context),
        _otherPetsListWidget(context),
      ],
    );
  }

  Widget _breedsSearchFieldWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Selecciona la raza de tu mascota',
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
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFieldSecondary(
                  inputKey: _searchBreedFormKey,
                  controller: _searchBreedController,
                  hintText: 'Escribe la raza', 
                  onChanged: (String? value) => _onSearchChanged(value!),
                  validator: (String? value) => _searchValidator(value!),
                  icon: Icons.search,
                  isSuffixIcon: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherPetsListWidget(BuildContext context) {
    if (_loadingBreeds) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          itemCount: breedsFound.length > 0 ? breedsFound.length : breeds.length,
          itemBuilder: (BuildContext context, int index) {
            return _breedDetailsWidget(context, breedsFound.length > 0 ? breedsFound[index] : breeds[index]);
          }
        ),
      );
    }
  }

  Widget _breedDetailsWidget(BuildContext context, Breed breed) {
    return InkWell(
        onTap: () {
          setState(() {
            _petSpecie = breed.name!;
          });

          _validateForm();

          Navigator.of(context).pop();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _petSpecie == breed.name ? Color(0xFF00B6E6) : Color(0xFF0E1326),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              breed.name ?? '',
              style: TextStyle(
                color: _petSpecie == breed.name ? Color(0xFFFFFFFF) : Color(0xFF6F7177),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
      ),
    );
  }

  Widget _challengeCompleteWidget(BuildContext context, Challenge challenge) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        content: Container(
        constraints: BoxConstraints(maxHeight: 450),
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
  }
  
  String? _textValidator(String value, String message) {
    return _petNameTextEditingController.text.trimLeft().length == 0
      ? message
      : null;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchBreedFormKey.currentState?.validate();
    });
    _onSearchBreeds(_searchBreedController.text.trim());
  }

  String? _searchValidator(String value) {
    return null;
  }

  void _validateForm() {
    _validForm = 
      (_petNameFormKey.currentState?.isValid ?? false) && 
      (_petSpecie != null) &&
      (_petBirthdate != null) &&
      (_petSex != null);
  }
}
