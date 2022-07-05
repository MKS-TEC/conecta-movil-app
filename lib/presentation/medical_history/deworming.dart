import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/deworming/deworming_bloc.dart';
import 'package:conecta/application/deworming/deworming_event.dart';
import 'package:conecta/application/deworming/deworming_state.dart';
import 'package:conecta/domain/core/entities/deworming.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';

class Dewormings extends StatefulWidget {
  Dewormings({Key? key}) : super(key: key);

  @override
  State<Dewormings> createState() => _DewormingsState();
}

class _DewormingsState extends State<Dewormings> {
  String? _petId;
  List<Deworming> _dewormings = List<Deworming>.empty(growable: true);
  DateTime? _dewormingDate;
  bool _loadingDewormings = true;
  bool _getDewormingsError = false;

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
      create: (context) => getIt<DewormingBloc>()..add(GetPetDefault()),
      child: _dewormingLayoutWidget(context)
    );
  }

  Widget _dewormingLayoutWidget(BuildContext context) {
    return BlocConsumer<DewormingBloc, DewormingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF0E1326),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Color(0xFF0E1326),
              statusBarIconBrightness: Brightness.dark,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _dewormingBodyWidget(context),
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

          context.read<DewormingBloc>().add(GetDeworming(state.petId ?? ""));
        }

        if (state is DewormingLoaded) {
          setState(() {
            _dewormings = state.dewormings;
            _loadingDewormings = false;
          });
        }

        if (state is DewormingNotWereLoaded) {
          setState(() {
            _getDewormingsError = true;
            _loadingDewormings = false;
          });
        }
      },
    );
  }

  Widget _dewormingBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _dewormingBackButtonWidget(context),
        _dewormingsCheckDataWidget(context),
         Visibility(
          visible: !_loadingDewormings,
          child: _dewormingAddButtonWidget(context),
        ),
      ],
    );
  }

  Widget _dewormingsCheckDataWidget(BuildContext context) {
    if (_loadingDewormings) {
      return _dewormingLoadingWidget(context);
    } else if (_getDewormingsError) {
      return _dewormingErrorWidget(context);
    } else if (_dewormings.length == 0) {
      return _dewormingEmptyWidget(context);
    } else {
      return _dewormingsWidget(context);
    }
  }

  Widget _dewormingLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _dewormingErrorWidget(BuildContext context) {
    return BlocBuilder<DewormingBloc, DewormingState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<DewormingBloc>().add(GetDeworming(_petId!));
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

  Widget _dewormingEmptyWidget(BuildContext context) {
    return BlocBuilder<DewormingBloc, DewormingState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no has agregado la primera desparasitación para tu mascota.',
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

  Widget _dewormingBackButtonWidget(BuildContext context) {
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
                  'Desparasitación',
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

  Widget _dewormingsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Desparasitación',
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Fecha',
                            style: TextStyle(
                              color: Color(0xFFE0E0E3),
                              fontSize: 16,
                              fontFamily: 'Nexa',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            _dewormingListWidget(context),
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

  Widget _dewormingListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: _dewormings.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: _dewormingDetailWidget(context, _dewormings[index]),
        );
      }, 
    );
  }

  Widget _dewormingDetailWidget(BuildContext context, Deworming deworming) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            deworming.date != null ? DateFormat.yMMMMd('es').format(deworming.date!) : "",
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

  Widget _dewormingAddButtonWidget(BuildContext context) {
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
                        create: (context) => getIt<DewormingBloc>(),
                        child: BlocConsumer<DewormingBloc, DewormingState>(
                          builder: (context, state) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return _dewormingAddSheetMenuWidget(context, setState);
                              },
                            );
                          },
                          listener: (context, state) {
                            if (state is SuccessfulCreateDeworming) {
                              var dewormings = _dewormings;
                              dewormings.add(state.deworming);
                              dewormings.sort((a, b) => b.date!.compareTo(a.date!));

                              setState(() {
                                _dewormings = dewormings;
                                _dewormingDate = null;
                              });

                              showSnackbar("Se ha agregado la desparasitación éxitosamente", false);

                              Navigator.of(context).pop();
                            }

                            if (state is FailuredCreateDeworming) {
                              showSnackbar("No se ha podido agregar la desparasitación", true);
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

  Widget _dewormingAddSheetMenuWidget(BuildContext context, StateSetter setState) {
    return BlocBuilder<DewormingBloc, DewormingState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Fecha de desparasitación',
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
                      child: InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2000, 3, 5),
                            maxTime: DateTime.now(),  
                            onConfirm: (date) {
                              setState(() {
                                _dewormingDate = date;
                              });
                            }, 
                            currentTime: DateTime.now(), locale: LocaleType.es,
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
                                  _dewormingDate != null ? '${_dewormingDate?.day}/${_dewormingDate?.month}/${_dewormingDate?.year}' : 'Fecha',
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
                    progressIndicator: state is CreateDewormingProcessing,
                    text: 'Agregar desparasitación', 
                    onPressed: () {
                      if (_dewormingDate != null) {
                        Deworming deworming = Deworming();
                        deworming.date = _dewormingDate;

                        context.read<DewormingBloc>().add(CreateDeworming(_petId!, deworming));
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
        );
      },
    );
  }
}