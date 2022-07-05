import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';

class ProgramNutritional extends StatefulWidget {
  ProgramNutritional({Key? key}) : super(key: key);

  @override
  State<ProgramNutritional> createState() => _ProgramNutritionalState();
}

class _ProgramNutritionalState extends State<ProgramNutritional> {
   List<Map<String, dynamic>> _todayActivities = 
    [
      {
        'hour': 'Mañana',
        'description': 'Contenido equilibrado de proteína (de origen animal)',
      },
      {
        'hour': 'Noche',
        'description': 'Contenido equilibrado de proteína (de origen animal)',
      },
    ];

  @override
  Widget build(BuildContext context) {
    return _programNutritionalLayoutWidget(context);
  }

  Widget _programNutritionalLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _programNutritionalBodyWidget(context),
          ),
        ),

      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _programNutritionalBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _programNutritionalBackButtonWidget(context),
        _programNutritionalFoodAdviceWidget(context),
        _programNutritionalViewAllWidget(context),
        _programNutritionalTodayActivitiesWidget(context),
      ],
    );
  }

  Widget _programNutritionalBackButtonWidget(BuildContext context) {
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
                  'Programa nutricional',
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

  Widget _programNutritionalFoodAdviceWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E3E5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.photo,
                        size: 60,
                        color: Color(0xFF6F7177),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Consejo alimenticio',
                                style: TextStyle(
                                  color: Color(0xFFE0E0E3),
                                  fontSize: 16,
                                  fontFamily: 'Nexa',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Durante los primeros días, dale tu cachorro el mismo alimento. Esto le ayudará a acostumbrarse.',
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Nexa',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _programNutritionalViewAllWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonPrimary(
                  text: 'Ver todo el programa', 
                  onPressed: () {
                    
                  }, 
                  width: MediaQuery.of(context).size.width, 
                  verticalPadding: 25,
                  borderRadius: 16,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _programNutritionalTodayActivitiesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Actividades para hoy',
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: _programNutritionalTodayActivitiesListWidget(context),
          ),
        ],
      ),
    ); 
  }

  Widget _programNutritionalTodayActivitiesListWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: _todayActivities.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _programNutritionalTodayActivityWidget(context, _todayActivities[index], index),
            );
          }, 
        ),
      ],
    );
  }

  Widget _programNutritionalTodayActivityWidget(BuildContext context, Map<String, dynamic> activity, int index) {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: index == 0 ? Color(0xFFEB9448) : Color(0xFF00B6E6),
            borderRadius: BorderRadius.circular(4),
          ),
          width: 10,
          height: 100,
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                activity["hour"],
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nexa',
                ),
              ),
              SizedBox(height: 15),
              Text(
                activity["description"],
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 14,
                  fontFamily: 'Nexa',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}