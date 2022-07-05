import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/pathologies/pathologies_bloc.dart';
import 'package:conecta/application/pathologies/pathologies_event.dart';
import 'package:conecta/application/pathologies/pathologies_state.dart';
import 'package:conecta/domain/core/entities/pathology.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/medical_history/pathology_episodies/pathology_episodies.dart';

class Pathologies extends StatefulWidget {
  Pathologies({Key? key}) : super(key: key);

  @override
  State<Pathologies> createState() => _PathologiesState();
}

class _PathologiesState extends State<Pathologies> {
  String? _petId;
  List<Pathology> _pathologies = List<Pathology>.empty(growable: true);
  final GlobalKey<FormFieldState> _pathologyFormKey =
    GlobalKey<FormFieldState>();
  TextEditingController _pathologyController = TextEditingController();
  DateTime? _pathologyDate;
  bool _loadingPathologies = true;
  bool _getPathologiesError = false;
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PathologiesBloc>()..add(GetPetDefault()),
      child: _pathologiesLayoutWidget(context)
    );
  }

  Widget _pathologiesLayoutWidget(BuildContext context) {
    return BlocConsumer<PathologiesBloc, PathologiesState>(
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
                child: _pathologiesBodyWidget(context),
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

          context.read<PathologiesBloc>().add(GetPathologies(state.petId ?? ""));
        }

        if (state is PathologiesLoaded) {
          setState(() {
            _pathologies = state.pathologies;
            _loadingPathologies = false;
          });
        }

        if (state is PathologiesNotWereLoaded) {
          setState(() {
            _getPathologiesError = true;
            _loadingPathologies = false;
          });
        }
      },
    );
  }

  Widget _pathologiesBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _pathologiesBackButtonWidget(context),
        _pathologiesVeterinarianIndicatorWidget(context),
        SizedBox(height: 20),
        /* Visibility(
          visible: !_loadingPathologies,
          child: _pathologiesSortWidget(context),
        ), */
        _pathologiesCheckDataWidget(context),
        Visibility(
          visible: !_loadingPathologies,
          child: _pathologyAddButtonWidget(context),
        ),
      ],
    );
  }

  Widget _pathologiesCheckDataWidget(BuildContext context) {
    if (_loadingPathologies) {
      return _pathologiesLoadingWidget(context);
    } else if (_getPathologiesError) {
      return _pathologiesErrorWidget(context);
    } else if (_pathologies.length == 0) {
      return _pathologiesEmptyWidget(context);
    } else {
      return _pathologiesWidget(context);
    }
  }

  Widget _pathologiesLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _pathologiesErrorWidget(BuildContext context) {
    return BlocBuilder<PathologiesBloc, PathologiesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<PathologiesBloc>().add(GetPathologies(_petId!));
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

  Widget _pathologiesEmptyWidget(BuildContext context) {
    return BlocBuilder<PathologiesBloc, PathologiesState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no has agregado una patologia de tu mascota.',
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

  Widget _pathologiesBackButtonWidget(BuildContext context) {
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
                  'Patología',
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

  Widget _pathologiesVeterinarianIndicatorWidget(BuildContext context) {
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

  Widget _pathologiesSortWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Ordenar por",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE0E0E3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF00B6E6),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.tune,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pathologiesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _pathologiesListWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pathologiesListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _pathologies.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _pathologyDetailWidget(context, _pathologies[index]),
        );
      }, 
    );
  }

  Widget _pathologyDetailWidget(BuildContext context, Pathology pathology) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PathologyEpisodies(petId: _petId ?? "", pathologyName: pathology.pathology ?? "")),
        );
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(
                      pathology.pathology ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFE0E0E3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nexa',
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      pathology.date != null ? DateFormat.yMMMMd('es').format(pathology.date!) : "",
                      style: TextStyle(
                        color: Color(0xFF8C939B),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Nexa',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pathologyAddButtonWidget(BuildContext context) {
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
                        create: (context) => getIt<PathologiesBloc>(),
                        child: BlocConsumer<PathologiesBloc, PathologiesState>(
                          builder: (context, state) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return _pathologyAddSheetMenuWidget(context, setState);
                              },
                            );
                          },
                          listener: (context, state) {
                            if (state is SuccessfulCreatePathology) {
                              var pathologies = _pathologies;
                              pathologies.add(state.pathology);
                              pathologies.sort((a, b) => b.date!.compareTo(a.date!));

                              setState(() {
                                _pathologies = pathologies;
                                _pathologyDate = null;
                                _pathologyController.text = "";
                                _validForm = false;
                              });

                              showSnackbar("Se ha agregado la patologia éxitosamente", false);

                              Navigator.of(context).pop();
                            }

                            if (state is FailuredCreatePathology) {
                              showSnackbar("No se ha podido agregar la patologia", true);
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

  Widget _pathologyAddSheetMenuWidget(BuildContext context, StateSetter setState) {
    return BlocBuilder<PathologiesBloc, PathologiesState>(
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
                        'Patologia',
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
                        inputKey: _pathologyFormKey,
                        controller: _pathologyController,
                        hintText: 'Escribe la patologia', 
                        keyboardType: TextInputType.text,
                        onChanged: (String? value) => _onPathologyChanged(value!),
                        validator: (String? value) => _pathologyValidator(value!),
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
                                _pathologyDate = date;
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
                                  _pathologyDate != null ? '${_pathologyDate?.day}/${_pathologyDate?.month}/${_pathologyDate?.year}' : 'Fecha',
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
                      progressIndicator: state is CreatePathologyProcessing,
                      text: 'Agregar patalogia', 
                      onPressed: () {
                        if (_validForm) {
                          Pathology pathology = Pathology();
                          pathology.pathology = _pathologyController.text;
                          pathology.date = _pathologyDate;

                          context.read<PathologiesBloc>().add(CreatePathology(_petId!, pathology));
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

   void _onPathologyChanged(String value) {
    setState(() {
      _pathologyFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _pathologyValidator(String value) {
    return _pathologyController.text.trimLeft().length == 0
        ? "Debe ingresar la patologia de su mascota"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_pathologyFormKey.currentState?.isValid ?? false) &&
      (_pathologyDate != null);
  }
}