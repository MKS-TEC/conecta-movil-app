import 'package:conecta/presentation/common/themeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/dashboard/medical_history/dashboard_medical_history_bloc.dart';
import 'package:conecta/application/dashboard/medical_history/dashboard_medical_history_event.dart';
import 'package:conecta/application/dashboard/medical_history/dashboard_medical_history_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/medical_history/deworming.dart';
import 'package:conecta/presentation/medical_history/medical_record.dart';
import 'package:conecta/presentation/medical_history/vaccines.dart';

class DashboardPolicies extends StatefulWidget {
  DashboardPolicies({Key? key}) : super(key: key);

  @override
  State<DashboardPolicies> createState() => _DashboardPoliciesState();
}

class _DashboardPoliciesState extends State<DashboardPolicies> {
  Pet? pet;
  String? petId;
  bool _loadingPet = true;
  bool _getPetError = false;
  Weight _weight = Weight();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
  
  @override
  Widget build(BuildContext context) {
    return _DashboardPoliciesPetCheckDataWidget(context);
  }

  Widget _DashboardPoliciesPetCheckDataWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          _DashboardPoliciesDetailsWidget(context),
          _DashboardPoliciesDetailsWidget(context)
        ],
      ),
    );
  }

  Widget _DashboardPoliciesDetailsWidget(BuildContext context) {

    return SizedBox(
      height: 250,
      child: InkWell(
        onTap: () {
        },
        child: Card(
          color: secondLevelColor,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://media.istockphoto.com/photos/shot-of-a-doctor-examining-a-patient-with-a-stethoscope-during-a-in-picture-id1369619516?b=1&k=20&m=1369619516&s=170667a&w=0&h=z-9AKH3yzuVaJ2mqwCBrx-lkTUombzYHypNnFwHrj-g=",
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://media.istockphoto.com/photos/shot-of-a-doctor-examining-a-patient-with-a-stethoscope-during-a-in-picture-id1369619516?b=1&k=20&m=1369619516&s=170667a&w=0&h=z-9AKH3yzuVaJ2mqwCBrx-lkTUombzYHypNnFwHrj-g=",
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://media.istockphoto.com/photos/shot-of-a-doctor-examining-a-patient-with-a-stethoscope-during-a-in-picture-id1369619516?b=1&k=20&m=1369619516&s=170667a&w=0&h=z-9AKH3yzuVaJ2mqwCBrx-lkTUombzYHypNnFwHrj-g=",
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child:  Text(
                                      "Póliza automóvil",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFFE0E0E3),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Próxima a vencer",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFFE0E0E3),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Toyota Land Cruiser Prado",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Placas AZT231",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Póliza: A10380",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Hasta: 30 de abril de 2022",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3 - 30,
                      // height: 70,
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Coberturas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        )
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3 - 30,
                      // height: 70,
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Carnet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        )
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3 - 30,
                      // height: 70,
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Dependientes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        )
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _DashboardPoliciesPetLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _DashboardPoliciesPetErrorWidget(BuildContext context) {
    return InkWell(
      onTap: () {
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

  Widget _DashboardPoliciesPetEmptyWidget(BuildContext context) {
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

}