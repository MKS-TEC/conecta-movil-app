import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/diagnosis/diagnosis_bloc.dart';
import 'package:conecta/application/diagnosis/diagnosis_event.dart';
import 'package:conecta/application/diagnosis/diagnosis_state.dart';
import 'package:conecta/domain/core/entities/diagnose.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';

class Diagnosis extends StatefulWidget {
  Diagnosis({Key? key}) : super(key: key);

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  String? _petId;
  List<Diagnose> _diagnosis = List<Diagnose>.empty(growable: true);
  bool _loadingDiagnosis = true;
  bool _getDiagnosisError = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DiagnosisBloc>()..add(GetPetDefault()),
      child: _diagnosesLayoutWidget(context)
    );
  }

  Widget _diagnosesLayoutWidget(BuildContext context) {
    return BlocConsumer<DiagnosisBloc, DiagnosisState>(
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
                child: _diagnosesBodyWidget(context),
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

          context.read<DiagnosisBloc>().add(GetDiagnosis(state.petId ?? ""));
        }

        if (state is DiagnosisLoaded) {
          setState(() {
            _diagnosis = state.diagnosis;
            _loadingDiagnosis = false;
          });
        }

        if (state is DiagnosisNotWereLoaded) {
          setState(() {
            _getDiagnosisError = true;
            _loadingDiagnosis = false;
          });
        }
      },
    );
  }

  Widget _diagnosesBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _diagnosesBackButtonWidget(context),
        _diagnosesVeterinarianIndicatorWidget(context),
        SizedBox(height: 20),
        Visibility(
          visible: !_loadingDiagnosis,
          child: _diagnosesSortWidget(context),
        ),
        _diagnosisCheckDataWidget(context),
      ],
    );
  }

  Widget _diagnosisCheckDataWidget(BuildContext context) {
    if (_loadingDiagnosis) {
      return _diagnosisLoadingWidget(context);
    } else if (_getDiagnosisError) {
      return _diagnosisErrorWidget(context);
    } else if (_diagnosis.length == 0) {
      return _diagnosisEmptyWidget(context);
    } else {
      return _diagnosisWidget(context);
    }
  }

  Widget _diagnosisLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _diagnosisErrorWidget(BuildContext context) {
    return BlocBuilder<DiagnosisBloc, DiagnosisState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<DiagnosisBloc>().add(GetDiagnosis(_petId!));
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

  Widget _diagnosisEmptyWidget(BuildContext context) {
    return BlocBuilder<DiagnosisBloc, DiagnosisState>(
      builder: (context, state) {
        return Container(
          height: 75,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'No posees diágnosticos en tu mascota.',
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

  Widget _diagnosesBackButtonWidget(BuildContext context) {
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
                  'Diagnóstico',
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

  Widget _diagnosesVeterinarianIndicatorWidget(BuildContext context) {
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

  Widget _diagnosesSortWidget(BuildContext context) {
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

  Widget _diagnosisWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _diagnosesListWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _diagnosesListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _diagnosis.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _diagnoseDetailWidget(context, _diagnosis[index]),
        );
      }, 
    );
  }

  Widget _diagnoseDetailWidget(BuildContext context, Diagnose diagnose) {
    return Row(
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
                    diagnose.diagnose ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nexa',
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    diagnose.date != null ? DateFormat.yMMMMd('es').format(diagnose.date!) : "",
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
    );
  }
}