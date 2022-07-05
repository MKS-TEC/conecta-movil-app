import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/pet/create_pet/create_pet_bloc.dart';
import 'package:conecta/application/pet/create_pet/create_pet_event.dart';
import 'package:conecta/application/pet/create_pet/create_pet_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/buttons/button_secondary.dart';
import 'package:conecta/presentation/owner/owner_pets.dart';

class CareProgram extends StatefulWidget {
  final Pet pet;
  CareProgram(this.pet, {Key? key}) : super(key: key);

  @override
  State<CareProgram> createState() => _CareProgramState();
}

class _CareProgramState extends State<CareProgram> {
  String? petId;
  List<Program> programs = List<Program>.empty();
  List<Program> programsPet = List<Program>.empty();
  List<CalendarEvent> calendarEvents = List<CalendarEvent>.empty();
  bool _isLoading = true;
  bool _getProgramsError = false;

  int _getTimeInSeconds(DateTime date) {
    var ms = date.millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  int _getLastDayOfMonth(month) {
    if (month == 1) return 28;

    if (
      month == 0 ||
      month == 2 ||
      month == 4 ||
      month == 6 ||
      month == 7 ||
      month == 9 ||
      month == 11
    )
      return 31;

    return 30;
  }

  DateTime _getToBeExecutedOnForDays(DateTime fromDate, int days) {
    DateTime _toBeExecutedOn = fromDate.add(Duration(days: days));
    
    return _toBeExecutedOn;
  } 

  DateTime _getToBeExecutedOnForWeeks(DateTime fromDate, int weeks) {
    DateTime _toBeExecutedOn = fromDate;

    for (var i = 0; i < weeks; i++) {
      _toBeExecutedOn = _toBeExecutedOn.add(Duration(days: 7));
    }
    
    return _toBeExecutedOn;
  } 

  DateTime _getToBeExecutedOnForMonths(DateTime fromDate, int months) {
    DateTime _toBeExecutedOn = fromDate;
    int _month = 0;

    for (var i = 0; i < months; i++) {
      int _days = _getLastDayOfMonth(_month);
      _toBeExecutedOn = _toBeExecutedOn.add(Duration(days: _days));

      if (_month == 11) {
        _month = 0;
      } else {
        _month++;
      }
    }
    
    return _toBeExecutedOn;
  } 

  DateTime _getToBeExecutedOnForYears(DateTime fromDate, int months) {
    DateTime _toBeExecutedOn = fromDate;

    for (var i = 0; i < months; i++) {
      _toBeExecutedOn = _toBeExecutedOn.add(Duration(days: 365));
    }
    
    return _toBeExecutedOn;
  } 

  void _setCalendar(List<Program> programsToMap) {
    if (programsToMap.length > 0) {
      List<CalendarEvent> _calendarEvents = <CalendarEvent>[];
      
      programsToMap.forEach((program) {
        if (program.activities!.length > 0) {
          print("Actividades: " + program.activities.toString());
          program.activities?.forEach((activity) {
            if (activity.toBeExecutedOn != null) {
              int _toBeExecutedOnSeconds = _getTimeInSeconds(activity.toBeExecutedOn!);
              int _currentTimeSeconds = _getTimeInSeconds(DateTime.now());

              if (_toBeExecutedOnSeconds >= _currentTimeSeconds) {
                CalendarEvent _calendarEvent = CalendarEvent();
          
                _calendarEvent.details = activity.title;
                _calendarEvent.start = activity.toBeExecutedOn;
                _calendarEvent.end = activity.toBeExecutedOn;
                _calendarEvent.isAllDay = true;
                _calendarEvent.title = activity.title;
                _calendarEvent.source = "Actividad";
                _calendarEvent.sourceId = activity.programId;

                _calendarEvents.add(_calendarEvent);
              }
            }
          });
        }
      });

      setState(() {
        calendarEvents = _calendarEvents;
        programsPet = programsToMap;
      });
    }
  }

  /*List<ProgramActivity>? _getProgramActivityFrequentActivity(ProgramActivity activity) {
    List<ProgramActivity> _activities = <ProgramActivity>[];

    switch (activity.triggerMeasure?.toLowerCase()) {
      case "days":
        if (activity.triggerValue != null) {
          DateTime _lastDate = widget.pet.birthdate!;

          for (var i = 0; i < activity.triggerValue!; i++) {
            activity.toBeExecutedOn = _getToBeExecutedOnForDays(_lastDate, activity.triggerValue!);

            if (activity.toBeExecutedOn!.year == DateTime.now().year) {
              _lastDate = activity.toBeExecutedOn!;
              _activities.add(activity);
              break;
            }
          }
        }
        break;
      case "weeks":
        if (activity.triggerValue != null) {
          DateTime _lastDate = widget.pet.birthdate!;

          for (var i = 0; i < activity.triggerValue!; i++) {
            activity.toBeExecutedOn = _getToBeExecutedOnForWeeks(_lastDate, activity.triggerValue!);

            if (activity.toBeExecutedOn!.year == DateTime.now().year) {
              _lastDate = activity.toBeExecutedOn!;
              _activities.add(activity);
              break;
            }
          }
        }
        break;
      case "months":
        if (activity.triggerValue != null) {
          DateTime _lastDate = widget.pet.birthdate!;

          for (var i = 0; i < activity.triggerValue!; i++) {
            activity.toBeExecutedOn = _getToBeExecutedOnForMonths(_lastDate, activity.triggerValue!);

            if (activity.toBeExecutedOn!.year == DateTime.now().year) {
              _lastDate = activity.toBeExecutedOn!;
              _activities.add(activity);
              break;
            }
          }
        }
        break;
      case "years":
        if (activity.triggerValue != null) {
          DateTime _lastDate = widget.pet.birthdate!;

          for (var i = 0; i < activity.triggerValue!; i++) {
            activity.toBeExecutedOn = _getToBeExecutedOnForYears(_lastDate, activity.triggerValue!);

            if (activity.toBeExecutedOn!.year == DateTime.now().year) {
              _lastDate = activity.toBeExecutedOn!;
              _activities.add(activity);
              break;
            }
          }
        }
        break;
      default:
        if (activity.triggerValue != null) {
          DateTime _lastDate = widget.pet.birthdate!;

          for (var i = 0; i < activity.triggerValue!; i++) {
            activity.toBeExecutedOn = _getToBeExecutedOnForDays(_lastDate, activity.triggerValue!);

            if (activity.toBeExecutedOn!.year == DateTime.now().year) {
              _lastDate = activity.toBeExecutedOn!;
              _activities.add(activity);
              break;
            }
          }
        }
    }

    return _activities;
  }*/

  DateTime _getCurrentDateFrequentActivity(ProgramActivity activity) {
    if (activity.startTrigger != "") {
      ProgramActivity? _programActivity = _getProgramActivitySubjectAge(activity);

      if (_programActivity?.toBeExecutedOn != null) return _programActivity!.toBeExecutedOn ?? DateTime.now();
    }

    return DateTime.now();
  }

  List<ProgramActivity>? _getProgramActivityFrequentActivity(ProgramActivity activity) {
    List<ProgramActivity> _activities = <ProgramActivity>[];
    DateTime _currentDate = _getCurrentDateFrequentActivity(activity);

    switch (activity.triggerMeasure?.toLowerCase()) {
      case "days":
        if (activity.triggerValue != null) {
          
          DateTime _nextActivityDate = _currentDate.add(Duration(days: activity.triggerValue!));

          while (_nextActivityDate.year == _currentDate.year) {
            ProgramActivity _currentProgramActivity = activity.copyWith();
            _currentProgramActivity.toBeExecutedOn = _nextActivityDate;
            _activities.add(_currentProgramActivity);
            _nextActivityDate = _nextActivityDate.add(Duration(days: activity.triggerValue!));
          }
        }
        break;
      case "weeks":
        if (activity.triggerValue != null) {
          int _days = activity.triggerValue! * 7;
          DateTime _nextActivityDate = _currentDate.add(Duration(days: _days));

          while (_nextActivityDate.year == _currentDate.year) {
            ProgramActivity _currentProgramActivity = activity.copyWith();
            _currentProgramActivity.toBeExecutedOn = _nextActivityDate;
            _activities.add(_currentProgramActivity);
            _nextActivityDate = _nextActivityDate.add(Duration(days: _days));
          }
        }
        break;
      case "months":
        if (activity.triggerValue != null) {
          DateTime _nextActivityDate = new DateTime(_currentDate.year, _currentDate.month +  activity.triggerValue!, _currentDate.day);

          while (_nextActivityDate.year == _currentDate.year) {
            ProgramActivity _currentProgramActivity = activity.copyWith();
            _currentProgramActivity.toBeExecutedOn = _nextActivityDate;
            _activities.add(_currentProgramActivity);
            _nextActivityDate = new DateTime(_nextActivityDate.year, _nextActivityDate.month +  activity.triggerValue!, _nextActivityDate.day);
          }
        }
        break;
      case "years":
        if (activity.triggerValue != null) {
          DateTime _nextActivityDate = new DateTime(_currentDate.year +  activity.triggerValue!, _currentDate.month, _currentDate.day);

          while (_nextActivityDate.year == _currentDate.year) {
            ProgramActivity _currentProgramActivity = activity.copyWith();
            _currentProgramActivity.toBeExecutedOn = _nextActivityDate;
            _activities.add(_currentProgramActivity);
            _nextActivityDate = new DateTime(_nextActivityDate.year +  activity.triggerValue!, _nextActivityDate.month, _nextActivityDate.day);
          }
        }
        break;
    }

    return _activities;
  }

  ProgramActivity? _getProgramActivitySubjectAge(ProgramActivity activity) {
    switch (activity.triggerMeasure?.toLowerCase()) {
      case "days":
        if (activity.triggerValue != null) {
          activity.toBeExecutedOn = _getToBeExecutedOnForDays(widget.pet.birthdate!, activity.triggerValue!);

          return activity;
        }
        break;
      case "weeks":
        if (activity.triggerValue != null) {
          activity.toBeExecutedOn = _getToBeExecutedOnForWeeks(widget.pet.birthdate!, activity.triggerValue!);

          return activity;
        }
        break;
      case "months":
        if (activity.triggerValue != null) {
          activity.toBeExecutedOn = _getToBeExecutedOnForMonths(widget.pet.birthdate!, activity.triggerValue!);

          return activity;
        }
        break;
      case "years":
        if (activity.triggerValue != null) {
          activity.toBeExecutedOn = _getToBeExecutedOnForYears(widget.pet.birthdate!, activity.triggerValue!);

          return activity;
        }
        break;
      default:
        if (activity.triggerValue != null) {
          activity.toBeExecutedOn = _getToBeExecutedOnForDays(widget.pet.birthdate!, activity.triggerValue!);

          return activity;
        }
    }
  }

  void _setProgramActivitiesToPet(List<Program> programsToPet) {
    programsToPet.forEach((program) {
      List<ProgramActivity> _activities = <ProgramActivity>[];

      if (program.activities!.length > 0) {
        program.activities?.forEach((activity) {
          switch (activity.trigger?.toLowerCase()) {
            case "subjectage":
              ProgramActivity? _newActivity = _getProgramActivitySubjectAge(activity);

              if (_newActivity?.programActivityId != null) {
                _activities.add(_newActivity!);
              }
              break;
            case "frequentactivity":
              List<ProgramActivity>? _newActivities = _getProgramActivityFrequentActivity(activity);

              if (_newActivities != null && _newActivities.length > 0) {
                _activities.addAll(_newActivities);
              }
              break;
            default:
              ProgramActivity? _newActivity = _getProgramActivitySubjectAge(activity);

              if (_newActivity?.programActivityId != null) {
                _activities.add(_newActivity!);
              }
          }
        });

        program.activities = _activities;
      }
    });

    _setCalendar(programsToPet);
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<CreatePetBloc>(
          create: (BuildContext context) => getIt<CreatePetBloc>(),
        ),
      ], 
      child: _careProgramLayoutWidget(context)
    );
  }

  Widget _careProgramLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              widget.pet.userId = state.user?.uid;

              context.read<CreatePetBloc>().add(GetPrograms(widget.pet));
            }
          },
        ),
        BlocListener<CreatePetBloc, CreatePetState>(
          listener: (context, state) {
            if (state is ProgramsLoaded) {
              setState(() {
                programs = state.programs;
                _isLoading = false;
              });

              _setProgramActivitiesToPet(state.programs);
            }

            if (state is ProgramsNotWereLoaded) {
              setState(() {
                _getProgramsError = true;
                _isLoading = false;
              });
            }

            if (state is GetProgramsProcessing) {
              setState(() {
                _getProgramsError = false;
                _isLoading = true;
              });
            }

            if (state is SuccessfulSetPet) {
              setState(() {
                petId = state.pet.petId;
              });

              context.read<CreatePetBloc>().add(CreatePrograms(state.pet.petId!, programsPet));
            }

            if (state is FailuredSetPet) {
              Navigator.of(context).pop();

              showSnackbar("Algo ha salido mal. Vuelve a intentarlo", true);
            }

            if (state is SuccessfulCreatePrograms) {
              context.read<CreatePetBloc>().add(CreateCalendar(petId!, calendarEvents));
            }

            if (state is SuccessfulCreateCalendar) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => OwnerPets()), 
                (Route<dynamic> route) => route.isFirst
              );
            }

            if (state is SetPetProcessing) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return _petInformationSetPetProcessingWidget(context);
                }
              );
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
                child: _careProgramBodyWidget(context,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _careProgramBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _careProgramProgressWidget(context),
        _careProgramTextWidget(context),
        SizedBox(height: 35),
        Visibility(
          visible: _isLoading,
          child: _careProgramLoadingWidget(context),
        ),
        Visibility(
          visible: !_isLoading && !_getProgramsError,
          child: _careProgramTypesSelectWidget(context),
        ),
        Visibility(
          visible: !_isLoading && _getProgramsError,
          child: _careProgramsErrorWidget(context),
        ),
      ],
    );
  }

  Widget _careProgramsErrorWidget(BuildContext context) {
    return BlocBuilder<CreatePetBloc, CreatePetState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<CreatePetBloc>().add(GetPrograms(widget.pet));
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

  Widget _careProgramLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _careProgramProgressWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
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
                  width: 45,
                  height: 45,
                  child: Icon(
                    Icons.close,
                    color: Color(0xFF6F7177),
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: 0.80,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFEB9448),
                    ),
                    backgroundColor: Colors.white,
                    semanticsLabel: 'Linear progress indicator',
                    minHeight: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _careProgramTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                          text: 'Para crear un programa de cuidado personalizado para ',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: widget.pet.name! + ' ',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: 'necesitamos que ingreses los datos de su tarjeta de vacunación y control vigente',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
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

  Widget _careProgramTypesSelectWidget(BuildContext context) {
    return BlocBuilder<CreatePetBloc, CreatePetState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ButtonSecondary(
                      text: 'Historial médico', 
                      onPressed: () {
                        context.read<CreatePetBloc>()
                            .add(SetPet(widget.pet));
                      }, 
                      verticalPadding: 25,
                      width: MediaQuery.of(context).size.width, 
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      text: 'Completar después', 
                      onPressed: () {
                        context.read<CreatePetBloc>()
                            .add(SetPet(widget.pet));
                      }, 
                      verticalPadding: 25,
                      width: MediaQuery.of(context).size.width, 
                      fontSize: 16,
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

  Widget _petInformationSetPetProcessingWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 120),
        child: Column(
          children: <Widget>[
             Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}