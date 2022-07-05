import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/medical_history/diagnosis.dart';
import 'package:conecta/presentation/medical_history/pathologies.dart';
import 'package:conecta/presentation/medical_history/temperatures.dart';
import 'package:conecta/presentation/medical_history/weights.dart';

class MedicalRecord extends StatefulWidget {
  MedicalRecord({Key? key}) : super(key: key);

  @override
  State<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecord> {
  @override
  Widget build(BuildContext context) {
    return _medicalRecordLayoutWidget(context);
  }

  Widget _medicalRecordLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _medicalRecordBodyWidget(context),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _medicalRecordBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _medicalRecordBackButtonWidget(context),
        _medicalRecordVeterinarianIndicatorWidget(context),
        SizedBox(height: 40),
        _medicalRecordOptionsWidget(context),
      ],
    );
  }

  Widget _medicalRecordBackButtonWidget(BuildContext context) {
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
                  'Registro médico',
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

  Widget _medicalRecordVeterinarianIndicatorWidget(BuildContext context) {
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

  Widget _medicalRecordOptionsWidget(BuildContext context) {
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
                      MaterialPageRoute(builder: (context) => Weights()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/medical-weight.svg',
                          width: 100,
                          semanticsLabel: 'medicine attention',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Peso',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nexa',
                          ),
                        ),
                      ],
                    ),
                  ),
                ), 
              ),
              SizedBox(width: 40),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Temperatures()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/medical-temperature.svg',
                          width: 60,
                          semanticsLabel: 'deworming medicine attention',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Temperatura',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Pathologies()),
                  );
                },
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/medical-phatology.svg',
                        width: 100,
                        semanticsLabel: 'medicine attention',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Patología',
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nexa',
                        ),
                      ),
                    ],
                  ),
                ),
              ), 
              /* SizedBox(width: 40),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Diagnosis()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/medical-diagnosis.svg',
                          width: 60,
                          semanticsLabel: 'deworming medicine attention',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Diagnóstico',
                          style: TextStyle(
                            color: Color(0xFFE0E0E3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nexa',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), */
            ],
          ),
        ],
      ),
    );
  }
}