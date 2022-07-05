import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/temperatures/temperatures_bloc.dart';
import 'package:conecta/application/temperatures/temperatures_event.dart';
import 'package:conecta/application/temperatures/temperatures_state.dart';
import 'package:conecta/domain/core/entities/temperature.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';

class Temperatures extends StatefulWidget {
  Temperatures({Key? key}) : super(key: key);

  @override
  State<Temperatures> createState() => _TemperaturesState();
}

class _TemperaturesState extends State<Temperatures> {
  String? _petId;
  List<Temperature> _temperatures = List<Temperature>.empty(growable: true);
   final GlobalKey<FormFieldState> _temperatureFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _temperatureController = TextEditingController();
  DateTime? _temperatureDate;
  bool _loadingTemperatures = true;
  bool _getTemperatureError = false;
  bool _validForm = false;

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

  bool? _temparatureIsIncrement(Temperature temperature, int index) {
    if (index == _temperatures.length - 1) return null;

    if (_temperatures[index + 1].temperature == temperature.temperature) return null;

    if (_temperatures[index + 1].temperature! > temperature.temperature!) return false;

    return true;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TemperaturesBloc>()..add(GetPetDefault()),
      child: _temperaturesLayoutWidget(context)
    );
  }

  Widget _temperaturesLayoutWidget(BuildContext context) {
    return BlocConsumer<TemperaturesBloc, TemperaturesState>(
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
                child: _temperaturesBodyWidget(context),
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

          context.read<TemperaturesBloc>().add(GetTemperatures(state.petId ?? ""));
        }

        if (state is TemperaturesLoaded) {
          setState(() {
            _temperatures = state.temperatures;
            _loadingTemperatures = false;
          });
        }

        if (state is TemperaturesNotWereLoaded) {
          setState(() {
            _getTemperatureError = true;
            _loadingTemperatures = false;
          });
        }
      },
    );
  }

  Widget _temperaturesBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _temperaturesBackButtonWidget(context),
        _temperaturesVeterinarianIndicatorWidget(context),
        SizedBox(height: 20),
        _temperaturesCheckDataWidget(context),
        Visibility(
          visible: !_loadingTemperatures,
          child: _temperatureAddButtonWidget(context),
        ),
      ],
    );
  }

  Widget _temperaturesCheckDataWidget(BuildContext context) {
    if (_loadingTemperatures) {
      return _temperaturesLoadingWidget(context);
    } else if (_getTemperatureError) {
      return _temperaturesErrorWidget(context);
    } else if (_temperatures.length == 0) {
      return _temperaturesEmptyWidget(context);
    } else {
      return _temperaturesWidget(context);
    }
  }

  Widget _temperaturesLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _temperaturesErrorWidget(BuildContext context) {
    return BlocBuilder<TemperaturesBloc, TemperaturesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<TemperaturesBloc>().add(GetTemperatures(_petId!));
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

  Widget _temperaturesEmptyWidget(BuildContext context) {
    return BlocBuilder<TemperaturesBloc, TemperaturesState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no has agregado la primera temperatura de tu mascota.',
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

  Widget _temperaturesBackButtonWidget(BuildContext context) {
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
                  'Temperatura',
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

  Widget _temperaturesVeterinarianIndicatorWidget(BuildContext context) {
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

  Widget _temperaturesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _temperaturesListWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _temperaturesListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _temperatures.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _weightDetailWidget(context, _temperatures[index], index),
        );
      }, 
    );
  }

  Widget _weightDetailWidget(BuildContext context, Temperature temperature, int index) {
    var isIncrement = _temparatureIsIncrement(temperature, index);

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
                        temperature.date != null ? DateFormat.yMMMMd('es').format(temperature.date!) : "",
                        style: TextStyle(
                          color: Color(0xFF8C939B),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      Text(
                        temperature.temperature != null ? "${temperature.temperature} °C" : "",
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

  Widget _temperatureAddButtonWidget(BuildContext context) {
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
                        create: (context) => getIt<TemperaturesBloc>(),
                        child: BlocConsumer<TemperaturesBloc, TemperaturesState>(
                          builder: (context, state) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return _temperatureAddSheetMenuWidget(context, setState);
                              },
                            );
                          },
                          listener: (context, state) {
                            if (state is SuccessfulCreateTemperature) {
                              var temperatures = _temperatures;
                              temperatures.add(state.temperature);
                              temperatures.sort((a, b) => b.date!.compareTo(a.date!));

                              setState(() {
                                _temperatures = temperatures;
                                _temperatureDate = null;
                                _temperatureController.text = "";
                                _validForm = false;
                              });

                              showSnackbar("Se ha agregado la temperatura éxitosamente", false);

                              Navigator.of(context).pop();
                            }

                            if (state is FailuredCreateTemperature) {
                              showSnackbar("No se ha podido agregar la temperatura", true);
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

  Widget _temperatureAddSheetMenuWidget(BuildContext context, StateSetter setState) {
    return BlocBuilder<TemperaturesBloc, TemperaturesState>(
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
                        'Temperatura',
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
                        inputKey: _temperatureFormKey,
                        controller: _temperatureController,
                        hintText: "ºC", 
                        keyboardType: TextInputType.number,
                        onChanged: (String? value) => _onTemperatureChanged(value!),
                        validator: (String? value) => _temperatureValidator(value!),
                        formatter: FilteringTextInputFormatter.digitsOnly,
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
                                _temperatureDate = date;
                              });

                              _validateForm();
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
                                  _temperatureDate != null ? '${_temperatureDate?.day}/${_temperatureDate?.month}/${_temperatureDate?.year}' : 'Fecha',
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
                      progressIndicator: state is CreateTemperatureProcessing,
                      text: 'Agregar temperatura', 
                      onPressed: () {
                        if (_validForm) {
                          Temperature temperature = Temperature();
                          temperature.temperature = double.parse(_temperatureController.text);
                          temperature.date = _temperatureDate;

                          context.read<TemperaturesBloc>().add(CreateTemperature(_petId!, temperature));
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

  void _onTemperatureChanged(String value) {
    setState(() {
      _temperatureFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _temperatureValidator(String value) {
    return _temperatureController.text.trimLeft().length == 0
        ? "Debe ingresar la temperatura de su mascota"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_temperatureFormKey.currentState?.isValid ?? false) &&
      (_temperatureDate != null);
  }
}