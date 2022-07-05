import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/weights/weights_bloc.dart';
import 'package:conecta/application/weights/weights_event.dart';
import 'package:conecta/application/weights/weights_state.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';

class Weights extends StatefulWidget {
  Weights({Key? key}) : super(key: key);

  @override
  State<Weights> createState() => _WeightsState();
}

class _WeightsState extends State<Weights> {
  User? user;
  String? _petId;
  List<Weight> _weights = List<Weight>.empty(growable: true);
  List<AppEvent> appEvents = List<AppEvent>.empty();
   final GlobalKey<FormFieldState> _weightFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _weightController = TextEditingController();
  DateTime? _weightDate;
  List<Challenge> ownerChallenges = List<Challenge>.empty();
  Challenge challengeUpdate = Challenge();
  bool _loadingChallenges = true;
  bool _getChallengesError = false;
  bool _loadingWeights = true;
  bool _getWeightsError = false;
  bool _validForm = false;

  void _createAppEvent(BuildContext context) {
    AppEvent appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == "petweightcompleted", orElse: () => AppEvent());

    if (appEvent.appEventId == null) {
      appEvent.name = "PetWeightCompleted";

      context.read<WeightsBloc>().add(CreateAppEvent(user!.uid, appEvent));
    } else if (ownerChallenges.length > 0) {
      _updateChallengeActivity(context);
    }
  }

  void _updateChallengeActivity(BuildContext context) {
    for (var i = 0; i < ownerChallenges.length; i++) {
      for (var a = 0; a < ownerChallenges[i].challengeActivities!.length; a++) {
        if (ownerChallenges[i].challengeActivities?[a].associatedAppEvent?.toLowerCase() == "petweightcompleted" && ownerChallenges[i].challengeActivities?[a].status?.toLowerCase() == "pending") {
          context.read<WeightsBloc>().add(UpdateChallengeActivity(user!.uid, ownerChallenges[i].challengeActivities?[a].challengeId ?? "", ownerChallenges[i].challengeActivities![a]));
          break;
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

      context.read<WeightsBloc>().add(UpdateChallenge(user!.uid, challengeId));
    } else {
      showSnackbar("Se ha agregado el peso con éxito", false);
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

  bool? _weightIsIncrement(Weight weight, int index) {
   if (index == _weights.length - 1) return null;

    if (_weights.length == 1) return null;

    if (_weights[index + 1].weight == weight.weight) return null;

    if (_weights[index + 1].weight! > weight.weight!) return false;

    return true;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<WeightsBloc>(
          create: (BuildContext context) => getIt<WeightsBloc>(),
        ),
      ], 
      child: _weightsLayoutWidget(context)
    );
  }

  Widget _weightsLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                user = state.user;
              });

              context.read<WeightsBloc>().add(GetPetDefault());
            }

            if (state is UnauthenticatedSubject) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()), 
                (Route<dynamic> route) => false
              );
            }
          },
        ),
        BlocListener<WeightsBloc, WeightsState>(
          listener: (context, state) {
            if (state is PetDefaultLoaded) {
              setState(() {
                _petId = state.petId;
              });

              context.read<WeightsBloc>().add(GetWeights(state.petId ?? ""));
              context.read<WeightsBloc>().add(GetOwnerChallenges(user!.uid));
            }

            if (state is ChallengesOwnerLoaded) {
              setState(() {
                ownerChallenges = state.challenges;
              });

              context.read<WeightsBloc>().add(GetAppEvents(user!.uid));
            }

            if (state is ChallengesOwnerNotWereLoaded) {
              setState(() {
                _getChallengesError = true;
                _loadingChallenges = false;
              });
            }

            if (state is AppEventsLoaded) {
              setState(() {
                appEvents = state.appEvents;
                _getChallengesError = false;
                _loadingChallenges = false;
              });

              if (_weights.length > 0) {
                _createAppEvent(context);
              }
            }

            if (state is AppEventsNotWereLoaded) {
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

            if (state is SuccessfulCreateAppEvent) {
              setState(() {
                appEvents.add(state.appEvent);
              });

              if (ownerChallenges.length > 0) {
                _updateChallengeActivity(context);
              } else {
                showSnackbar("Se ha agregado el peso éxitosamente", false);
              }
            }

            if (state is SuccessfulUpdateChallengeActivity) {
              _updateChallenge(context, state.challenge.challengeId ?? "");
            }

            if (state is SuccessfulUpdateChallenge) {
              context.read<WeightsBloc>().add(UpdatePetPoints(user!.uid, challengeUpdate.marketPoints!));
            }

            if (state is SuccessfulUpdatePetPoints) {
              showSnackbar("Se ha agregado el peso éxitosamente", false);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _challengeCompleteWidget(context, challengeUpdate);
                }
              );
            
              context.read<AuthBloc>().add(GetAuthenticatedSubject());
            }

            if (state is WeightsLoaded) {
              setState(() {
                _weights = state.weights;
                _loadingWeights = false;
              });
            }

            if (state is WeightsNotWereLoaded) {
              setState(() {
                _getWeightsError = true;
                _loadingWeights = false;
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
              child: _weightsBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _weightsBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _weightsBackButtonWidget(context),
        _weightsVeterinarianIndicatorWidget(context),
        SizedBox(height: 20),
        _weightsCheckDataWidget(context),
        Visibility(
          visible: !_loadingWeights,
          child: _weightAddButtonWidget(context),
        ),
      ],
    );
  }

  Widget _weightsCheckDataWidget(BuildContext context) {
    if (_loadingWeights || _loadingChallenges) {
      return _weightsLoadingWidget(context);
    } else if (_getWeightsError || _getChallengesError) {
      return _weightsErrorWidget(context);
    } else if (_weights.length == 0) {
      return _weightsEmptyWidget(context);
    } else {
      return _weightsWidget(context);
    }
  }

  Widget _weightsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _weightsErrorWidget(BuildContext context) {
    return BlocBuilder<WeightsBloc, WeightsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<WeightsBloc>().add(GetWeights(_petId!));
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

  Widget _weightsEmptyWidget(BuildContext context) {
    return BlocBuilder<WeightsBloc, WeightsState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no has agregado el primer peso de tu mascota.',
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

  Widget _weightsBackButtonWidget(BuildContext context) {
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
                      size: 35,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Peso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontFamily: 'Nexa',
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

  Widget _weightsVeterinarianIndicatorWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.new_releases,
                  size: 30,
                  color: Color(0xFF00B6E6),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Información que completa tu veterinario en la consulta.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE0E0E3),
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

  Widget _weightsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _weightsListWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weightsListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _weights.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: _weightDetailWidget(context, _weights[index], index),
        );
      }, 
    );
  }

  Widget _weightDetailWidget(BuildContext context, Weight weight, int index) {
    var isIncrement = _weightIsIncrement(weight, index);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text(
                        weight.date != null ? DateFormat.yMMMMd('es').format(weight.date!) : "",
                        style: TextStyle(
                          color: Color(0xFF8C939B),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      Text(
                        weight.weight != null ? "${weight.weight} Kilos" : "",
                        style: TextStyle(
                          color: Color(0xFF8C939B),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      Container(
                        child: isIncrement == null
                        ? Icon(
                          Icons.remove,
                          size: 30,
                          color: Color(0xFF77C69D),
                        )
                        : Icon(
                          isIncrement ? Icons.expand_less : Icons.expand_more,
                          size: 30,
                          color: isIncrement ? Color(0xFF77C69D) : Color(0xFFEB9448),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _weightAddButtonWidget(BuildContext context) {
    return BlocBuilder<WeightsBloc, WeightsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonPrimary(
                    text: 'Agregar', 
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        builder: (context) {
                          return BlocProvider(
                            create: (context) => getIt<WeightsBloc>(),
                            child: BlocConsumer<WeightsBloc, WeightsState>(
                              builder: (context, state) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return _weightAddSheetMenuWidget(context, setState);
                                  },
                                );
                              },
                              listener: (context, state) {
                                if (state is SuccessfulCreateWeight) {
                                  var weights = _weights;
                                  weights.add(state.weight);
                                  weights.sort((a, b) => b.date!.compareTo(a.date!));

                                  setState(() {
                                    _weights = weights;
                                    _weightDate = null;
                                    _weightController.text = "";
                                    _validForm = false;
                                  });

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => super.widget), 
                                  );
                                }

                                if (state is FailuredCreateWeight) {
                                  showSnackbar("No se ha podido agregar el peso", true);
                                }
                              },
                            ),
                          );
                        },
                      );
                    }, 
                    width: 175, 
                    fontSize: 16,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _weightAddSheetMenuWidget(BuildContext context, StateSetter setState) {
    return BlocBuilder<WeightsBloc, WeightsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Peso',
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nexa',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFieldDark(
                        inputKey: _weightFormKey,
                        controller: _weightController,
                        hintText: 'Peso en kg', 
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (String? value) => _onWeightChanged(value!),
                        validator: (String? value) => _weightValidator(value!),
                        fillColor: Color(0xFF10172F),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2000, 3, 5),
                            maxTime: DateTime.now(),  
                            onConfirm: (date) {
                              setState(() {
                                _weightDate = date;
                              });

                              _validateForm();
                            }, 
                            currentTime: DateTime.now(), locale: LocaleType.es,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Color(0xFF10172F),
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
                                  _weightDate != null ? '${_weightDate?.day}/${_weightDate?.month}/${_weightDate?.year}' : 'Fecha',
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      progressIndicator: state is CreateWeightProcessing,
                      text: 'Agregar peso', 
                      onPressed: () {
                        if (_validForm) {
                          Weight weight = Weight();
                          weight.weight = double.parse(_weightController.text.replaceAll(",", "."));
                          weight.date = _weightDate;

                          context.read<WeightsBloc>().add(CreateWeight(_petId!, weight));
                        }
                      }, 
                      width: MediaQuery.of(context).size.width, 
                      borderRadius: 0,
                      fontSize: 18,
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

   void _onWeightChanged(String value) {
    setState(() {
      _weightFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _weightValidator(String value) {
    return _weightController.text.trimLeft().length == 0
        ? "Debe ingresar el peso de su mascota"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_weightFormKey.currentState?.isValid ?? false) &&
      (_weightDate != null);
  }
}