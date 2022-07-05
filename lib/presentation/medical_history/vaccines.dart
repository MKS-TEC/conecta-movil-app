import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/vaccines/vaccines_bloc.dart';
import 'package:conecta/application/vaccines/vaccines_event.dart';
import 'package:conecta/application/vaccines/vaccines_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/vaccine.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';

class Vaccines extends StatefulWidget {
  Vaccines({Key? key}) : super(key: key);

  @override
  State<Vaccines> createState() => _VaccinesState();
}

class _VaccinesState extends State<Vaccines> {
  String? _petId;
  final GlobalKey<FormFieldState> _vaccineFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _vaccineController = TextEditingController();
  List<Vaccine> _vaccines = List<Vaccine>.empty(growable: true);
  List<Program> _programs = List<Program>.empty(growable: true);
  List<CalendarEvent> _calendarEventsVaccine = List<CalendarEvent>.empty(growable: true);
  DateTime? _vaccineDate;
  bool _loadingVaccines = true;
  bool _getVaccinesError = false;
  bool _loadingCalendars = true;
  bool _getCalendarsError = false;
  bool _validForm = false;
  bool _nextVaccines = false;

  void _setCalendarEventVaccines(List<CalendarEvent> calendarsToMap) {
    if (calendarsToMap.length > 0 && _programs.length > 0) {
      Program _program = _programs.firstWhere((programFind) => programFind.programCategory?.toLowerCase() == "vacunación");

      List<CalendarEvent> _calendarEvents = calendarsToMap.where((calendarEvent) => calendarEvent.sourceId == _program.programId).toList();

      _calendarEvents.sort((a, b) => a.start!.compareTo(b.start!));

      setState(() {
        _calendarEventsVaccine = _calendarEvents;
      });
    }

    setState(() {
      _loadingCalendars = false;
      _getCalendarsError = false;
    });
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
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VaccinesBloc>()..add(GetPetDefault()),
      child: _vaccinesLayoutWidget(context)
    );
  }

  Widget _vaccinesLayoutWidget(BuildContext context) {
    return BlocConsumer<VaccinesBloc, VaccinesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF0E1326),
          resizeToAvoidBottomInset: true,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Color(0xFF0E1326),
              statusBarIconBrightness: Brightness.dark,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _vaccinesBodyWidget(context),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
          ),
        );
      },
      listener: (context, state) {
        if (state is PetDefaultLoaded) {
          setState(() {
            _petId = state.petId;
          });

          context.read<VaccinesBloc>().add(GetVaccines(state.petId ?? ""));
          context.read<VaccinesBloc>().add(GetPrograms(state.petId ?? ""));
        }

        if (state is VaccinesLoaded) {
          setState(() {
            _vaccines = state.vaccines;
            _loadingVaccines = false;
          });
        }

        if (state is VaccinesNotWereLoaded) {
          setState(() {
            _getVaccinesError = true;
            _loadingVaccines = false;
          });
        }

        if (state is CalendarsLoaded) {
          _setCalendarEventVaccines(state.calendars);
        }

        if (state is CalendarsNotWereLoaded) {
          setState(() {
            _getCalendarsError = true;
            _loadingCalendars = false;
          });
        }

        if (state is ProgramsLoaded) {
          setState(() {
            _programs = state.programs;
          });
          
          context.read<VaccinesBloc>().add(GetCalendars(_petId ?? ""));
        }

        if (state is ProgramsNotWereLoaded) {
          setState(() {
            _getCalendarsError = true;
            _loadingCalendars = false;
          });
        }

        if (state is GetProgramsProcessing || state is GetCalendarsProcessing) {
          setState(() {
            _getCalendarsError = false;
            _loadingCalendars = true;
          });
        }
      },
    );
  }

  Widget _vaccinesBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _vaccinesBackButtonWidget(context),
        _vaccinesTabsWidget(context),
        Visibility(
          visible: !_nextVaccines,
          child: _vaccinesTextWidget(context),
        ),
        Visibility(
          visible: !_nextVaccines,
          child: _vaccinesCheckDataWidget(context),
        ),
        Visibility(
          visible: !_loadingVaccines && !_nextVaccines,
          child: _vaccinesAddButtonWidget(context),
        ),
        Visibility(
          visible: _nextVaccines,
          child: _vaccinesNextCheckDataWidget(context),
        ),
      ],
    );
  }

  Widget _vaccinesCheckDataWidget(BuildContext context) {
    if (_loadingVaccines) {
      return _vaccinesLoadingWidget(context);
    } else if (_getVaccinesError) {
      return _vaccinesErrorWidget(context);
    } else if (_vaccines.length == 0) {
      return _vaccinesEmptyWidget(context);
    } else {
      return _vaccinesWidget(context);
    }
  }

  Widget _vaccinesLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _vaccinesErrorWidget(BuildContext context) {
    return BlocBuilder<VaccinesBloc, VaccinesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<VaccinesBloc>().add(GetVaccines(_petId!));
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

  Widget _vaccinesEmptyWidget(BuildContext context) {
    return BlocBuilder<VaccinesBloc, VaccinesState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no has agregado la primer vacuna para tu mascota.',
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

  Widget _vaccinesNextCheckDataWidget(BuildContext context) {
    if (_loadingCalendars) {
      return _vaccinesNextLoadingWidget(context);
    } else if (_getCalendarsError) {
      return _vaccinesNextErrorWidget(context);
    } else if (_calendarEventsVaccine.length == 0) {
      return _vaccinesNextEmptyWidget(context);
    } else {
      return _vaccinesNextWidget(context);
    }
  }

  Widget _vaccinesNextLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _vaccinesNextErrorWidget(BuildContext context) {
    return BlocBuilder<VaccinesBloc, VaccinesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<VaccinesBloc>().add(GetPrograms(_petId!));
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

  Widget _vaccinesNextEmptyWidget(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            'No se han encontrado próximas vacunas para tu mascota.',
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

  Widget _vaccinesBackButtonWidget(BuildContext context) {
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
                  'Vacunas',
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

  Widget _vaccinesTabsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _nextVaccines = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_nextVaccines ? Color(0xFF00B6E6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Actuales',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_nextVaccines ? Colors.white : Color(0xFF8C939B),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _nextVaccines = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _nextVaccines ? Color(0xFF00B6E6) : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Próximas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _nextVaccines ? Colors.white : Color(0xFF8C939B),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _vaccinesTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Deberás mantener al día las vacunas colocadas y pendiente de tu mascota',
                  style: TextStyle(
                    color: Color(0xFF6F7177),
                    fontSize: 16,
                    fontFamily: 'Nexa',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _vaccinesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Vacunas',
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
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tipo de vacuna',
                              style: TextStyle(
                                color: Color(0xFFE0E0E3),
                                fontSize: 16,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Fecha',
                              style: TextStyle(
                                color: Color(0xFFE0E0E3),
                                fontSize: 16,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            _vaccinesListWidget(context),
                          ],
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

  Widget _vaccinesListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: _vaccines.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: _vaccinesDetailWidget(context, _vaccines[index]),
        );
      }, 
    );
  }

  Widget _vaccinesDetailWidget(BuildContext context, Vaccine vaccine) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            vaccine.type ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFFE0E0E3),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: 'Nexa',
            ),
          ),
        ),
        Expanded(
          child: Text(
            vaccine.date != null ? DateFormat.yMMMMd('es').format(vaccine.date!) : "",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Color(0xFFE0E0E3),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: 'Nexa',
            ),
          ),
        ),
      ],
    );
  }

  Widget _vaccinesAddButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                        create: (context) => getIt<VaccinesBloc>(),
                        child: BlocConsumer<VaccinesBloc, VaccinesState>(
                          builder: (context, state) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return _vaccinesAddSheetMenuWidget(context, setState);
                              },
                            );
                          },
                          listener: (context, state) {
                            if (state is SuccessfulCreateVaccine) {
                              var vaccines = _vaccines;
                              vaccines.add(state.vaccine);
                              vaccines.sort((a, b) => b.date!.compareTo(a.date!));

                              setState(() {
                                _vaccines = vaccines;
                                _vaccineDate = null;
                                _vaccineController.text = "";
                                _validForm = false;
                              });

                              showSnackbar("Se ha agregado la vacuna éxitosamente", false);

                              Navigator.of(context).pop();
                            }

                            if (state is FailuredCreateVaccine) {
                              showSnackbar("No se ha podido agregar la vacuna", true);
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

  Widget _vaccinesAddSheetMenuWidget(BuildContext context, StateSetter setState) {
    return BlocBuilder<VaccinesBloc, VaccinesState>(
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
                        'Vacuna nueva',
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom
                        ),
                        child: TextFieldDark(
                          inputKey: _vaccineFormKey,
                          controller: _vaccineController,
                          hintText: 'Escribe la vacuna', 
                          keyboardType: TextInputType.text,
                          onChanged: (String? value) => _onVaccineChanged(value!),
                          validator: (String? value) => _vaccineValidator(value!),
                          fillColor: Color(0xFF10172F),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom
                        ),
                        child: InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 3, 5),
                              maxTime: DateTime.now(),  
                              onConfirm: (DateTime date) {
                                setState(() {
                                  _vaccineDate = date;
                                });

                                _validateForm();
                              }, 
                              currentTime: DateTime.now(), 
                              locale: LocaleType.es,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
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
                                    _vaccineDate != null ? '${_vaccineDate?.day}/${_vaccineDate?.month}/${_vaccineDate?.year}' : 'Fecha',
                                    style: TextStyle(
                                      color: Color(0xFF6F7177),
                                      fontSize: 14,
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      progressIndicator: state is CreateVaccineProcessing,
                      text: 'Agregar vacuna', 
                      onPressed: () {
                        if (_validForm) {
                          Vaccine vaccine = Vaccine();
                          vaccine.type = _vaccineController.text;
                          vaccine.date = _vaccineDate;

                          context.read<VaccinesBloc>().add(CreateVaccine(_petId!, vaccine));
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

  Widget _vaccinesNextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Próximas vacunas',
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
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tipo de vacuna',
                              style: TextStyle(
                                color: Color(0xFFE0E0E3),
                                fontSize: 16,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Fecha',
                              style: TextStyle(
                                color: Color(0xFFE0E0E3),
                                fontSize: 16,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            _vaccinesNextListWidget(context),
                          ],
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

  Widget _vaccinesNextListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: _calendarEventsVaccine.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _vaccinesNextDetailWidget(context, _calendarEventsVaccine[index]),
        );
      }, 
    );
  }

  Widget _vaccinesNextDetailWidget(BuildContext context, CalendarEvent calendarEvent) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Text(
            calendarEvent.title ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFFE0E0E3),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: 'Nexa',
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            calendarEvent.start != null ? DateFormat.yMd('es').format(calendarEvent.start!) : "",
            maxLines: 1,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFFE0E0E3),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: 'Nexa',
            ),
          ),
        ),
      ],
    );
  }

  void _onVaccineChanged(String value) {
    setState(() {
      _vaccineFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _vaccineValidator(String value) {
    return _vaccineController.text.trimLeft().length == 0
        ? "Debe ingresar la vacuna"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_vaccineFormKey.currentState?.isValid ?? false) &&
      (_vaccineDate != null);
  }
}