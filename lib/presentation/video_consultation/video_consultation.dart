import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_bloc.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_event.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_state.dart';
import 'package:conecta/application/orders/orders_bloc.dart';
import 'package:conecta/application/orders/orders_event.dart';
import 'package:conecta/application/orders/orders_state.dart';
import 'package:conecta/application/owner/profile/owner_profile_bloc.dart';
import 'package:conecta/application/owner/profile/owner_profile_event.dart';
import 'package:conecta/application/owner/profile/owner_profile_state.dart';
import 'package:conecta/application/services/services_bloc.dart';
import 'package:conecta/application/services/services_event.dart';
import 'package:conecta/application/services/services_state.dart';
import 'package:conecta/domain/core/services/day_agenda/day_agenda.dart';
import 'package:conecta/domain/core/services/service.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';

class VideoConsultation extends StatefulWidget {
  VideoConsultation({Key? key}) : super(key: key);

  @override
  State<VideoConsultation> createState() => _VideoConsultationState();
}

class _VideoConsultationState extends State<VideoConsultation> {

  User? authenticatedUser;

  List<String> _veterinarians = <String>[
    'assets/img/9dr.png',
    'assets/img/5dr.png',
    'assets/img/4dr.png',
  ];


  DayInAgenda? _dateSelected;
  Service? service;

  List<DayInAgenda> _dates = [];
  List<dynamic> _hours = [];
  int _hourSelected = 0;

  int _points = 0;
  bool _loadingPetPoints = true;
  bool _getPetPointsError = false;

  bool? _loadingDates = true;
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:[
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<OrdersBloc>(
          create: (BuildContext context) => getIt<OrdersBloc>(),
        ),
        BlocProvider<OwnerProfileBloc>(
          create: (BuildContext context) => getIt<OwnerProfileBloc>(),
        ),
        BlocProvider<GamificationPetPointsBloc>(
          create: (BuildContext context) => getIt<GamificationPetPointsBloc>(),
        ),
        BlocProvider<ServicesBloc>(
          create: (BuildContext context) => getIt<ServicesBloc>()..add(GetVideoConsultingService()),
        ),
      ], 
      child: _videoConsultationLayoutWidget(context)
    );
  }

  Widget _videoConsultationLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              authenticatedUser = state.user;
              context.read<GamificationPetPointsBloc>().add(GetPetPoints(state.user!.uid));
            }
          },
        ),
        BlocListener<GamificationPetPointsBloc, GamificationPetPointsState>(
          listener: (context, state) {
            if (state is PetPointLoaded) {
              setState(() {
                _points = state.petPoints.ppAccumulated!;
                _loadingPetPoints = false;
                _getPetPointsError = false;
              });
            }

            if (state is PetPointsNotWereLoaded) {
              setState(() {
                _loadingPetPoints = false;
                _getPetPointsError = true;
              });
            }
          },
        ),
        BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            
            if (state is VideoConsultingServiceLoaded) {
              setState(() {
                service = state.service;
                _dates = state.service.days_agenda!;
                _dateSelected = state.service.days_agenda![0];
                _hours = _dateSelected!.horasDia!;
                _loadingDates = false;
              });
            }
            if (state is GetVideoConsultingServiceProcessing) {
              setState(() {
                _loadingDates = true;
              });
            }

          },
        ),
        BlocListener<OrdersBloc, OrdersState>(
          listener: (context, state) {
             if (state is SuccessfulSetOrder){
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return _successCreationVideoConsultingWidget(context);
                }
              );
            }

            if (state is SetCreationOrderProcessing) {
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
        backgroundColor: Color(0xFF04091D),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Color(0xFF04091D),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  _videoConsultationBodyWidget(context)
                ]
              )
            )
          ),
        ),
      ),
    );
  }

  Widget _successCreationVideoConsultingWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 300),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60.0
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Genial",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.green,
                  fontWeight: FontWeight.w700
                )
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "La videoconsulta se ha agendado correctamente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: (){
                  Navigator.push( context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF57419D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Regresar al inicio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
    );
  }

  Widget _incompletePointsWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 300),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60.0
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Uups!",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.red,
                  fontWeight: FontWeight.w700
                )
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "No tienes los pet points necesarios \n para agendar una videoconsulta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: (){
                  Navigator.push( context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF57419D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Regresar al inicio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF57419D)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoConsultationBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _videoConsultationBackButtonWidget(context),
        _videoConsultationTextWidget(context),
        // _videoConsultationVeterinariansWidget(context),
        _loadingDates! ?
          CircularProgressIndicator()
        : _videoConsultationDatesListWidget(context),

        _videoConsultationHoursWidget(context),
        _videoConsultationScheduleWidget(context),
      ],
    );
  }

  Widget _videoConsultationBackButtonWidget(BuildContext context) {
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
                      color: Color(0xFFEFEEF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 45,
                    height: 45,
                    child: Icon(
                      Icons.chevron_left,
                      color: Color(0xFF57419D),
                      size: 35,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Videoconsulta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF41424D),
                    fontSize: 16,
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

  Widget _videoConsultationTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Estamos aquí para cuidar a tu mascota desde la distancia',
                  style: TextStyle(
                    color: Color(0xFF494c52),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _videoConsultationVeterinariansWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: <Widget>[
         ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 100,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _veterinarians.length,
              itemBuilder: (BuildContext context, int index) {
                return _videoConsultationVeterinarianWidget(context, _veterinarians[index]);
              }
            ),
          ),
        ],
      ),
    ); 
  }

  Widget _videoConsultationVeterinarianWidget(BuildContext context, String imagePath) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: ClipOval(
        child: Container(
          height: 100,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _videoConsultationDatesListWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: <Widget>[
         ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 70,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (BuildContext context, int index) {
                return _videoConsultationDateWidget(context, _dates[index]);
              }
            ),
          ),
        ],
      ),
    ); 
  }

  Widget _videoConsultationDateWidget(BuildContext context, DayInAgenda date) {

    double _dateFontSize = 12;

    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: InkWell(
          onTap: () {
            setState(() {
              _dateSelected = date;
              _hours = date.horasDia!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _dateSelected == date ? Color(0xFFEB9448) : Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(100)
            ),
            padding: EdgeInsets.all(10),
            height: 70,
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  date.day ?? "",
                  style: TextStyle(
                    color: _dateSelected == date ? Color(0xFFFFFFFF) : Color(0xFF7F9D9D),
                    fontSize: _dateFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date.month ?? "",
                  style: TextStyle(
                    color: _dateSelected == date ? Color(0xFFFFFFFF) : Color(0xFF7F9D9D),
                    fontSize: _dateFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date.year ?? "",
                  style: TextStyle(
                    color: _dateSelected == date ? Color(0xFFFFFFFF) : Color(0xFF7F9D9D),
                    fontSize: _dateFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _videoConsultationHoursWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Horarios Disponibles',
                  style: TextStyle(
                    color: Color(0xFF494c52),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            child: _videoConsultationHoursListWidget(context),
          ),
        ],
      ),
    ); 
  }

  Widget _videoConsultationHoursListWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GridView.builder(          
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.5,
            crossAxisSpacing: 0,
            mainAxisSpacing: 15, 
            crossAxisCount: 3
          ),
          itemCount: _hours.length,
          itemBuilder: (BuildContext context, int index) {
            return _videoConsultationHourWidget(context, _hours[index], index);
          }, 
        ),
      ],
    );
  }

  Widget _videoConsultationHourWidget(BuildContext context, String hour, int index) {

    double _hourFontSize = 14;

    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            _hourSelected = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _hourSelected == index ? Color(0xFFEB9448) : Color(0xFFFFE2C8),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              hour,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hourSelected == index ? Color(0xFFFFFFFF) : Color(0xFFEB9448),
                fontSize: _hourFontSize,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoConsultationScheduleWidget(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(_points >= 3000){
                          context.read<OrdersBloc>().add(SetOrderConsultation(
                            authenticatedUser!.uid,
                            _dateSelected!,
                            _hours[_hourSelected],
                            service!,
                            _points
                          ));
                        }else{
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return _incompletePointsWidget(context);
                            }
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF57419D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera_roll_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'Agendar Videoconsulta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
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
    ); 
  }

}