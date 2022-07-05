import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/owner/profile/owner_profile_bloc.dart';
import 'package:conecta/application/owner/profile/owner_profile_event.dart';
import 'package:conecta/application/owner/profile/owner_profile_state.dart';
import 'package:conecta/application/share_code/share_code_bloc.dart';
import 'package:conecta/application/share_code/share_code_event.dart';
import 'package:conecta/application/share_code/share_code_state.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'dart:io';

enum Share {
  twitter,
  whatsapp,
  whatsapp_business,
  share_system
}

class ShareCode extends StatefulWidget {
  ShareCode({Key? key}) : super(key: key);

  @override
  State<ShareCode> createState() => _ShareCodeState();
}

class _ShareCodeState extends State<ShareCode> {
  User? user;
  Owner? owner;
  bool _loadingOwner = true;
  bool _getOwnerError = false;

  bool _sharedCodeSuccessful = false;
  bool _sharingCodeLoading = false;
  bool _shareCodeError = false;

  List<Challenge> ownerChallenges = List<Challenge>.empty();
  List<AppEvent> appEvents = List<AppEvent>.empty();
  Challenge challengeUpdate = Challenge();
  bool _loadingChallenges = true;
  bool _getChallengesError = false;

  void _createAppEvent(BuildContext context) {
    AppEvent appEvent = appEvents.firstWhere((appEventFind) => appEventFind.name?.toLowerCase() == "usersinvitedtoappcompleted", orElse: () => AppEvent());

    if (appEvent.appEventId == null) {
      appEvent.name = "UsersInvitedToAppCompleted";

      context.read<ShareCodeBloc>().add(CreateAppEvent(user!.uid, appEvent));
    } else if (ownerChallenges.length > 0) {
      _updateChallengeActivity(context);
    } else {
      showSnackbar("Has invitado un dueño de mascota con éxito", false);
    }
  }

  void _updateChallengeActivity(BuildContext context) {
    for (var i = 0; i < ownerChallenges.length; i++) {
      for (var a = 0; a < ownerChallenges[i].challengeActivities!.length; a++) {
        if (ownerChallenges[i].challengeActivities?[a].associatedAppEvent?.toLowerCase() == "usersinvitedtoappcompleted" && ownerChallenges[i].challengeActivities?[a].status?.toLowerCase() == "pending") {
          context.read<ShareCodeBloc>().add(UpdateChallengeActivity(user!.uid, ownerChallenges[i].challengeActivities?[a].challengeId ?? "", ownerChallenges[i].challengeActivities![a]));
          break;
        }

        if (i == ownerChallenges.length - 1) {
          showSnackbar("Has invitado un dueño de mascota con éxito", false);
        }
      }
    }
  }

  void _updateChallenge(BuildContext context, String challengeId) {
    Challenge challenge = ownerChallenges.firstWhere((challengeFind) => challengeFind.challengeId == challengeId, orElse: () => Challenge());
    List<ChallengeActivity> _challengeActivityDone = <ChallengeActivity>[];

    ownerChallenges.forEach((challenge) => {
      challenge.challengeActivities?.forEach((challengeActivity) {
        if (challengeActivity.status?.toLowerCase() == "done" && challengeActivity.challengeId == challengeId) {
          _challengeActivityDone.add(challengeActivity);
        }
      })
    });

    if (challenge.challengeActivities!.length == _challengeActivityDone.length + 1) {
      setState(() {
        challengeUpdate = challenge;
      });

      context.read<ShareCodeBloc>().add(UpdateChallenge(user!.uid, challengeId));
    } else {
      showSnackbar("Has invitado un dueño de mascota con éxito", false);
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
        BlocProvider<OwnerProfileBloc>(
          create: (BuildContext context) => getIt<OwnerProfileBloc>(),
        ),
        BlocProvider<ShareCodeBloc>(
          create: (BuildContext context) => getIt<ShareCodeBloc>(),
        ),
      ], 
      child: _shareCodeLayoutWidget(context)
    );
  }

  Widget _shareCodeLayoutWidget(BuildContext context) {
     return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                owner?.ownerId = state.user?.uid;
                user = state.user;
              });

              context.read<OwnerProfileBloc>().add(GetOwner(state.user!.uid));
            }
          },
        ),
        BlocListener<OwnerProfileBloc, OwnerProfileState>(
          listener: (context, state) {
            if (state is OwnerLoaded) {
              setState(() {
                owner = state.owner;
                _loadingOwner = false;
                _getOwnerError = false;
              });

              context.read<ShareCodeBloc>().add(GetOwnerChallenges(user!.uid));
            }

            if (state is OwnerNotLoaded) {
              setState(() {
                _loadingOwner = false;
                _getOwnerError = true;
              });
            }
          },
        ),
        BlocListener<ShareCodeBloc, ShareCodeState>(
          listener: (context, state) {
            if (state is SharingCode) {
              setState(() {
                _sharingCodeLoading = true;
              });
            }
            
            if (state is UserCodeShared) {
              setState(() {
                _sharingCodeLoading = false;
              });
              context.read<ShareCodeBloc>().add(GetNumberOfGuests(user!.uid));
            }

            if (state is UserCodeNotShared) {
              setState(() {
                _sharingCodeLoading = false;
                _shareCodeError = true;
              });
            }

            if(state is GuestsLoaded){
              if(state.numberOfGuests == 5 ){
                _createAppEvent(context);
              }
            }

            if (state is SuccessfulCreateAppEvent) {
              setState(() {
                appEvents.add(state.appEvent);
              });

              if (ownerChallenges.length > 0) {
                _updateChallengeActivity(context);
              } else {
                showSnackbar("Has invitado un dueño de mascota con éxito", false);
              }
            }

            if (state is ChallengesOwnerLoaded) {
              setState(() {
                ownerChallenges = state.challenges;
              });

              context.read<ShareCodeBloc>().add(GetAppEvents(user!.uid));
            }

            if (state is ChallengesOwnerNotWereLoaded) {
              setState(() {
                _getChallengesError = true;
                _loadingChallenges = false;
              });
            }

            if (state is GetChallengesOwnerProcessing) {
              setState(() {
                _getChallengesError = false;
                _loadingChallenges = true;
              });
            }

            if (state is AppEventsLoaded) {
              setState(() {
                appEvents = state.appEvents;
                _getChallengesError = false;
                _loadingChallenges = false;
              });
            }

            if (state is AppEventsNotWereLoaded) {
              setState(() {
                _getChallengesError = true;
                _loadingChallenges = false;
              });
            }

            if (state is SuccessfulUpdateChallengeActivity) {
              _updateChallenge(context, state.challenge.challengeId ?? "");
            }

            if (state is SuccessfulUpdateChallenge) {
              context.read<ShareCodeBloc>().add(UpdatePetPoints(user!.uid, challengeUpdate.gamificationPoints!));
            }

            if (state is SuccessfulUpdatePetPoints) {
              showSnackbar("Has invitado un dueño de mascota con éxito", false);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _challengeCompleteWidget(context, challengeUpdate);
                }
              );
            
              context.read<AuthBloc>().add(GetAuthenticatedSubject());
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
              child: _shareCodeBodyWidget(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _shareCodeBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _shareCodeHeaderWidget(context),
        _shareCodeCheckDataWidget(context)
      ],
    );
  }

    Widget _shareCodeCheckDataWidget(BuildContext context) {
    if (_loadingOwner) {
      return _shareCodeLoadingWidget(context);
    } else if (_sharingCodeLoading) {
      return _shareCodeInfoWidget(context);
    } else if (_getOwnerError) {
      return _shareCodeErrorWidget(context);
    } else if (_shareCodeError) {
      return _shareCodeErrorWidget(context);
    } else {
      return _shareCodeInfoWidget(context);
    }
  }

  Widget _shareCodeLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }
  
  Widget _shareCodeInfoWidget(BuildContext context) {
    return BlocBuilder<ShareCodeBloc, ShareCodeState>(
      builder: (context, state){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Image.asset(
                'assets/img/gift-code.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 2 - 70,
              ),
              SizedBox( height: 30.0 ),
              Text(
                "Comparte el link con un familiar o amigo y recibe una promoción gratis por descargar la APP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                )
              ),
              SizedBox( height: 30.0 ),
              Text(
                "100 Pet points",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800
                )
              ),
              Text(
                "Por cada dueño de mascota que descargue la aplicación",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                )
              ),
              SizedBox( height: 30.0 ),
              ButtonPrimary(
                text: 'Compartir', 
                onPressed: (){
                  context.read<ShareCodeBloc>().add(ShareUserCode(owner!));
                },
                width: MediaQuery.of(context).size.width, 
                fontSize: 18,
              ),
              SizedBox( height: 30.0 ),
              Text(
                "Tu código",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                )
              ),
              SizedBox( height: 15.0 ),
              Text(
                owner!.referredCode.toString() != "" ? owner!.referredCode.toString() : "USUARIO123",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800
                )
              ),  
              SizedBox( height: 30.0 ),
            ]
          ),
        );
      },
    );
  }

  Widget _shareCodeErrorWidget(BuildContext context) {
    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {},
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

  Widget _shareCodeHeaderWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
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
              )
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _challengeCompleteWidget(BuildContext context, Challenge challenge) {
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
                'Has completado el desafio ${challenge.title}. Por haber completado este desafio te premiamos con una sumatoria de ${challenge.marketPoints} Pet Points en tu cuenta para que puedas utilizarlos.',
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