import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/gamification/challenges/gamification_challenges_bloc.dart';
import 'package:conecta/application/gamification/challenges/gamification_challenges_event.dart';
import 'package:conecta/application/gamification/challenges/gamification_challenges_state.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_outline_primary.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/gamification/gamification_pet_points.dart';

class GamificationChallenges extends StatefulWidget {
  GamificationChallenges({Key? key}) : super(key: key);

  @override
  State<GamificationChallenges> createState() => _GamificationChallengesState();
}

class _GamificationChallengesState extends State<GamificationChallenges> {
  String? ownerId;
  List<Challenge> challenges = List<Challenge>.empty();
  List<Challenge> ownerChallenges = List<Challenge>.empty();
  List<AppEvent> appEvents = List<AppEvent>.empty();
  Challenge challengeUpdate = Challenge();
  bool _loading = true;
  bool _getError = false;

  void _getAppEventsForChallenges(BuildContext context, Challenge challenge) {
    List<AppEvent> _appEvents = <AppEvent>[];

    challenge.challengeActivities?.forEach((activity) {
      AppEvent _appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == activity.associatedAppEvent?.toLowerCase(), orElse: () => AppEvent());

      if (_appEvent.appEventId != null) {
        _appEvents.add(_appEvent);
      }
    });

    if (_appEvents.length == challenge.challengeActivities!.length) {
      Challenge _challengeCreate = challenge;

      _challengeCreate.challengeActivities?.forEach((challengeActivitiy) {
        challengeActivitiy.status = "done";
      });

      _challengeCreate.status = "done";

      context.read<GamificationChallengesBloc>().add(CreateChallenge(ownerId ?? "", challenge));
      context.read<GamificationChallengesBloc>().add(UpdatePetPoints(ownerId ?? "", challenge.marketPoints!));

      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _challengeCompleteWidget(context, challenge);
        }
      );
    } else {
      context.read<GamificationChallengesBloc>().add(CreateChallenge(ownerId ?? "", challenge));
    }
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<GamificationChallengesBloc>(
          create: (BuildContext context) => getIt<GamificationChallengesBloc>(),
        ),
      ], 
      child: _gamificationChallengesLayoutWidget(context)
    );
  }

  Widget _gamificationChallengesLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                ownerId = state.user?.uid;
              });

              context.read<GamificationChallengesBloc>().add(GetChallenges());
            }
          },
        ),
        BlocListener<GamificationChallengesBloc, GamificationChallengesState>(
          listener: (context, state) {
            if (state is ChallengesLoaded) {
              setState(() {
                challenges = state.challenges;
              });

              context.read<GamificationChallengesBloc>().add(GetOwnerChallenges(ownerId ?? ""));
            }

            if (state is ChallengesOwnerLoaded) {
              setState(() {
                ownerChallenges = state.challenges;
              });

              context.read<GamificationChallengesBloc>().add(GetAppEvents(ownerId ?? ""));
            }

            if (state is ChallengesOwnerNotWereLoaded) {
              setState(() {
                _getError = true;
                _loading = false;
              });
            }

            if (state is GetChallengesOwnerProcessing) {
              setState(() {
                _getError = false;
                _loading = true;
              });
            }


            if (state is ChallengesNotWereLoaded) {
              setState(() {
                _getError = true;
                _loading = false;
              });
            }

            if (state is AppEventsLoaded) {
              setState(() {
                appEvents = state.appEvents;
                _getError = false;
                _loading = false;
              });
            }

            if (state is AppEventsNotWereLoaded) {
              setState(() {
                _getError = true;
                _loading = false;
              });
            }

            if (state is GetChallengesProcessing) {
              setState(() {
                _getError = false;
                _loading = true;
              });
            }

            if (state is SuccessfulUpdateChallengeActivities) {
              context.read<GamificationChallengesBloc>().add(UpdateChallenge(ownerId ?? "", state.challengeId));
            }

            if (state is SuccessfulUpdateChallenge) {
              context.read<GamificationChallengesBloc>().add(UpdatePetPoints(ownerId ?? "", challengeUpdate.marketPoints!));
            }

            if (state is SuccessfulUpdatePetPoints) {
              context.read<AuthBloc>().add(GetAuthenticatedSubject());

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _challengeCompleteWidget(context, challengeUpdate);
                }
              );
            }

            if (state is FailuredCreateChallenge) {
              showSnackbar("No se ha podido aceptar el desafio. Intentalo de nuevo", true);
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
              child: _gamificationChallengesBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _gamificationChallengesBodyWidget(BuildContext context) {
    return Column(
      children:[
        _gamificationChallengesBackButtonWidget(context),
        _gamificationChallengesTabsWidget(context),
        _gamificationChallengesTitleWidget(context),
        // _gamificationChallengesMedailsWidget(context),
        _gamificationChallengesNextLevelProgressWidget(context),
        _gamificationChallengeCheckDataWidget(context),
      ]
    );
  }

  Widget _gamificationChallengeCheckDataWidget(BuildContext context) {
    if (_loading) {
      return _gamificationChallengeLoadingWidget(context);
    } else if (_getError) {
      return _gamificationChallengeErrorWidget(context);
    } else if (challenges.length == 0) {
      return _gamificationChallengeEmptyWidget(context);
    } else {
      return _gamificationChallengesForYouWidget(context);
    }
  }

   Widget _gamificationChallengeLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _gamificationChallengeErrorWidget(BuildContext context) {
    return BlocBuilder<GamificationChallengesBloc, GamificationChallengesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<GamificationChallengesBloc>().add(GetChallenges());
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

   Widget _gamificationChallengeEmptyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'No hemos encontrado desafios para ti en este momento.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE0E0E3),
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _gamificationChallengesBackButtonWidget(BuildContext context) {
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

   Widget _gamificationChallengesTabsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
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
                      'Desafíos',
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GamificationPetPoints()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Pet Points',
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

  Widget _gamificationChallengesTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Completa desafíos y obtén recompensas y beneficios para tu mascota',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
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

  Widget _gamificationChallengesMedailsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _gamificationChallengeMedailDetailWidget(
                  context, 
                  "assets/img/medails-3.png",
                  70,
                  () {},
                ),
              ),
              Expanded(
                child: _gamificationChallengeMedailDetailWidget(
                  context, 
                  "assets/img/medails-4.png",
                  70,
                  () {},
                ),
              ),
              Expanded(
                child: _gamificationChallengeMedailDetailWidget(
                  context, 
                  "assets/img/medails-1.png",
                  70,
                  () {},
                ),
              ),
              Expanded(
                child: _gamificationChallengeMedailDetailWidget(
                  context, 
                  "assets/img/medails-2.png",
                  70,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gamificationChallengeMedailDetailWidget(BuildContext context, String path, double size, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Image.asset(
            path,
            fit: BoxFit.cover,
            width: size,
          ),
        ],
      ),
    );
  }

  Widget _gamificationChallengesNextLevelProgressWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Tu progreso para subir de nivel',
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
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF10172F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 45,
                          height: 45,
                          child: SvgPicture.asset(
                            "assets/svg/challenge-cup.svg",
                            width: 30,
                            semanticsLabel: 'challenge cup icon',
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  value: 0.7,
                                  minHeight: 15,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
                                  backgroundColor: Color(0xFF8C939B),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "XP",
                                        style: TextStyle(
                                          color: Color(0xFFE0E0E3),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '7',
                                              style: TextStyle(
                                                color: Color(0xFFE0E0E3),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '/10',
                                              style: TextStyle(
                                                color: Color(0xFF8C939B),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '3 XP',
                                              style: TextStyle(
                                                color: Color(0xFFE0E0E3),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' y subes de nivel',
                                              style: TextStyle(
                                                color: Color(0xFF8C939B),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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

  Widget _gamificationChallengesForYouWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Desafíos para ti',
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: challenges.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 125,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: _gamificationChallengeForYouDetailWidget(context, challenges[index]),
                    );
                  }, 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _getChallengeDone(Challenge challenge) {
    if (ownerChallenges.length > 0) {
      Challenge _ownerChallenge = ownerChallenges.firstWhere((ownerChallengeFind) => ownerChallengeFind.challengeId == challenge.challengeId, orElse: () => Challenge());

      if (_ownerChallenge.status?.toLowerCase() == "done") return true;
    }

    return false;
  }

  Widget _gamificationChallengeForYouDetailWidget(BuildContext context, Challenge challenge) {
    bool _isChallengeDone = _getChallengeDone(challenge);
    Challenge _ownerChallenge = ownerChallenges.firstWhere((ownerChallengeFind) => ownerChallengeFind.challengeId == challenge.challengeId, orElse: () => Challenge());

    return InkWell(
      onTap: !_isChallengeDone && _ownerChallenge.challengeId == null ? () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return BlocProvider(
              create: (context) => getIt<GamificationChallengesBloc>(),
              child: BlocConsumer<GamificationChallengesBloc, GamificationChallengesState>(
                builder: (context, state) {
                  return _gamificationChallengeDetailDialogWidget(context, challenge);
                }, 
                listener: (context, state) {
                  if (state is SuccessfulCreateChallenge) {
                    Navigator.of(context).pop();

                    showSnackbar("Has aceptado el desafio con éxito, ¡que tengas mucha suerte!", false);

                    setState(() {
                      ownerChallenges.add(state.challenge);
                    });

                    if (state.challenge.status?.toLowerCase() == "done") {
                      context.read<GamificationChallengesBloc>().add(UpdatePetPoints(ownerId ?? "", challengeUpdate.marketPoints!));
                    }
                  }
                }
              ),
            );
          }
        );
      } : null,
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 13,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFF0E1326),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Visibility(
                            visible: challenge.imageUrl != null && challenge.imageUrl!.isNotEmpty,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF86A3A3),
                              radius: 28,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  challenge.imageUrl ?? "",
                                  width: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    challenge.title ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color(0xFFE0E0E3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  challenge.description ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Color(0xFFE0E0E3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 20,
                      height: 25,
                      decoration: BoxDecoration(
                        color: _isChallengeDone ? Color(0xFFEB9448) : _ownerChallenge.challengeId == null ? Colors.transparent : Color(0xFF8C939B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _isChallengeDone ? Color(0xFFEB9448) : _ownerChallenge.challengeId == null ? Colors.transparent : Color(0xFF00B6E6)),
                      ),
                      child: Icon(
                        Icons.check,
                        color: _isChallengeDone ? Colors.white : Colors.transparent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gamificationChallengeDetailDialogWidget(BuildContext context, Challenge challenge) {
    return BlocBuilder<GamificationChallengesBloc, GamificationChallengesState>(
      builder: (context, state) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
            content: Container(
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFF00B6E6),
                  ),
                  child: Visibility(
                    visible: challenge.imageUrl != null && challenge.imageUrl!.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.network(
                        challenge.imageUrl ?? "",
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    challenge.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00B6E6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    challenge.description ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                    style: TextStyle(
                      color: Color(0xFF6F7177),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ButtonOutlinePrimary(
                          text: 'Cancelar', 
                          onPressed: state is CreateChallengeProcessing ? null : () {
                            Navigator.of(context).pop();
                          },
                          width: MediaQuery.of(context).size.width, 
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ButtonPrimary(
                          progressIndicator: state is CreateChallengeProcessing,
                          text: 'Aceptar desafío', 
                          onPressed: () {
                            if (appEvents.length > 0 && challenge.challengeActivities!.length > 0) {
                              _getAppEventsForChallenges(context, challenge);
                            } else {
                              context.read<GamificationChallengesBloc>().add(CreateChallenge(ownerId ?? "", challenge));
                            }
                          },
                          width: MediaQuery.of(context).size.width, 
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    ); 
  }

  Widget _challengeCompleteWidget(BuildContext context, Challenge challenge) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        content: Container(
        constraints: BoxConstraints(maxHeight: 450),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF00B6E6),
              ),
              child: Visibility(
                visible: challenge.imageUrl != null && challenge.imageUrl!.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.network(
                    challenge.imageUrl ?? "",
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "¡Felicidades! Has completado un desafio",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00B6E6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ya habias completado el desafio ${challenge.title} anteriormente. Por haber completado este desafio te premiamos con una sumatoria de ${challenge.marketPoints} Pet Points en tu cuenta para que puedas utilizarlos.',
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      text: '¡Gracias!', 
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      width: MediaQuery.of(context).size.width, 
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}