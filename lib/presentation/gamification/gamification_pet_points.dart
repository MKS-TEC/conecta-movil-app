import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_bloc.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_event.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_state.dart';
import 'package:conecta/domain/core/entities/pet_points.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/gamification/gamification_challenges.dart';
import 'package:conecta/presentation/sign_in/sign_in.dart';
import 'package:conecta/presentation/video_consultation/video_consultation.dart';

class GamificationPetPoints extends StatefulWidget {
  GamificationPetPoints({Key? key}) : super(key: key);

  @override
  State<GamificationPetPoints> createState() => _GamificationPetPointsState();
}

class _GamificationPetPointsState extends State<GamificationPetPoints> {
  User? user;
  PetPoint petPoint = PetPoint();
  bool _loadingPetPoints = true;
  bool _getPetPointsError = false;
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<GamificationPetPointsBloc>(
          create: (BuildContext context) => getIt<GamificationPetPointsBloc>(),
        ),
      ], 
      child: _gamificationPetPointsLayoutWidget(context)
    );
  }

  Widget _gamificationPetPointsLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                user = state.user;
              });

              context.read<GamificationPetPointsBloc>().add(GetPetPoints(state.user!.uid));
            }

            if (state is UnauthenticatedSubject) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()), 
                (Route<dynamic> route) => false
              );
            }
          },
        ),
        BlocListener<GamificationPetPointsBloc, GamificationPetPointsState>(
          listener: (context, state) {
            if (state is PetPointLoaded) {
              setState(() {
                petPoint = state.petPoints;
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
              child: _gamificationPetPointsBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _gamificationPetPointsBodyWidget(BuildContext context) {
    return Column(
      children:[
        _gamificationPetPointsBackButtonWidget(context),
        _gamificationPetPointsTabsWidget(context),
        _gamificationPetPointsCheckDataWidget(context),
        _gamificationPetPointsOptionsProgressWidget(context),
        _showHistory ? _gamificationPetPointsHistoryWidget(context) : _gamificationPetPointsExchangeWidget(context),
      ]
    );
  }

  Widget _gamificationPetPointsCheckDataWidget(BuildContext context) {
    if (_loadingPetPoints) {
      return _gamificationPetPointsLoadingWidget(context);
    } else if (_getPetPointsError) {
      return _gamificationPetPointsErrorWidget(context);
    } else {
      return _gamificationPetPointsAmountWidget(context);
    }
  }

  Widget _gamificationPetPointsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _gamificationPetPointsErrorWidget(BuildContext context) {
    return BlocBuilder<GamificationPetPointsBloc, GamificationPetPointsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<GamificationPetPointsBloc>().add(GetPetPoints(user?.uid ?? ""));
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

  Widget _gamificationPetPointsBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Dashboard()), 
                    (Route<dynamic> route) => false
                  );
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
                    size: 45,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Pet Champion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

   Widget _gamificationPetPointsTabsWidget(BuildContext context) {
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GamificationChallenges()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Desafíos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8C939B),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF00B6E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Pet Points',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _gamificationPetPointsAmountWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Pet Points acumulados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8C939B),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF10172F),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text(
                      petPoint.ppAccumulated != null ? "${petPoint.ppAccumulated}" : "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF00B6E6),
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
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

  Widget _gamificationPetPointsOptionsProgressWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                        _showHistory = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: !_showHistory ? Color(0xFFEB9448) : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Canjear',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8C939B),
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
                        _showHistory = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _showHistory ? Color(0xFFEB9448) : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Historial',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8C939B),
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

  Widget _gamificationPetPointsExchangeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VideoConsultation())
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.videocam,
                              size: 50,
                              color: Color(0xFF8C939B),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Videoconsulta',
                                  style: TextStyle(
                                    color: Color(0xFFE0E0E3),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '3000 Pet Points',
                                  style: TextStyle(
                                    color: Color(0xFF8C939B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 30,
                            child: Icon(
                              Icons.chevron_right,
                              size: 30,
                              color: Color(0xFF00B6E6),
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
        ],
      ),
    );
  }

  Widget _gamificationPetPointsHistoryWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _gamificationHistoryDetailDialogWidget(context);
                      }
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 50,
                              color: Color(0xFFEB9448),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Comprar curso de oratoria',
                                  style: TextStyle(
                                    color: Color(0xFFE0E0E3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '20/04/2022',
                                  style: TextStyle(
                                    color: Color(0xFF8C939B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '-2900',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFFE0E0E3),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gamificationHistoryDetailDialogWidget(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        content: Container(
        constraints: BoxConstraints(maxHeight: 425),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF00B6E6),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.menu_book,
                  size: 50,
                  color: Color(0xFFEB9448),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Curso de oratoria",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00B6E6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fecha",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "20/04/2022",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF58595F),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Descripción",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Aprender a expresar las ideas, y a lograr que la audiencia te interprete como deseas y que te entienda con este curso online.",
                  style: TextStyle(
                    color: Color(0xFF58595F),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "-2900 Pet Points",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}