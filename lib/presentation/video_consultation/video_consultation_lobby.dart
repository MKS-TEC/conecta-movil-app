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
import 'package:conecta/application/orders/orders_bloc.dart';
import 'package:conecta/application/orders/orders_event.dart';
import 'package:conecta/application/orders/orders_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/pet_calendar/pet_calendar.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoConsultationLobby extends StatefulWidget {
  final CalendarEvent pet_calendarItem;
  VideoConsultationLobby({Key? key, required this.pet_calendarItem}) : super(key: key);
  
  @override
  State<VideoConsultationLobby> createState() => _VideoConsultationLobbyState();
}

class _VideoConsultationLobbyState extends State<VideoConsultationLobby> {

  User? authenticatedUser;
  SharedPreferences? _sharedPreferences;
  final serverText = TextEditingController();
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");
  bool? isAudioOnly = true;
  bool? isAudioMuted = false;
  bool? isVideoMuted = false;
  
  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
      onConferenceWillJoin: _onConferenceWillJoin,
      onConferenceJoined: _onConferenceJoined,
      onConferenceTerminated: _onConferenceTerminated,
      onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
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
      ], 
      child: _videoConsultationLobbyLayoutWidget(context)
    );
  }

  Widget _videoConsultationLobbyLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              authenticatedUser = state.user;
            }
          },
        ),
        BlocListener<OrdersBloc, OrdersState>(
          listener: (context, state) {
             if (state is SuccessfulSetOrder){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard()), 
                (Route<dynamic> route) => route.isFirst
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
        backgroundColor: Color(0xFF0E1326),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Color(0xFF0E1326),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: _videoConsultationLobbyBodyWidget(context),
            ),
          ),
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoConsultationLobbyBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _videoConsultationLobbyBackButtonWidget(context),
        _videoConsultationLobbyTextWidget(context),        
        _videoConsultationLobbyOptionsWidget(context),
        _videoConsultationLobbyScheduleWidget(context),
      ],
    );
  }

  Widget _videoConsultationLobbyBackButtonWidget(BuildContext context) {
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
                  'Videoconsulta',
                  textAlign: TextAlign.center,
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

  Widget _videoConsultationLobbyTextWidget(BuildContext context) {
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
                    color: Color(0xFF6F7177),
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
  
  Widget _videoConsultationLobbyOptionsWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _videoConsultationLobbyOptionWidget(
            context,
            "Sólo Audio",
            "a",
            isAudioOnly,
            Icons.mic,
            Icons.mic_off
          ),
          _videoConsultationLobbyOptionWidget(
            context,
            "Sin Audio",
            "b",
            isAudioMuted,
            Icons.mic,
            Icons.mic_off
          ),
          _videoConsultationLobbyOptionWidget(
            context,
            "Sin Video",
            "c",
            isVideoMuted,
            Icons.videocam,
            Icons.videocam_off
          ),
        ],
      ),
    ); 
  }

  Widget _videoConsultationLobbyOptionWidget(BuildContext context, String title, String type, bool? value, IconData iconOn, IconData iconOff) {
    return GestureDetector(
      onTap:(){
        if(type == "a"){ _onAudioOnlyChanged(!value!); }
        if(type == "b"){ _onAudioMutedChanged(!value!); }
        if(type == "c"){ _onVideoMutedChanged(!value!); }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - 21,
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Icon(
              value! ? iconOn : iconOff,
              size: 30,
              color: value ? Colors.black : Colors.red
            ),
            SizedBox(height: 15.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: value ? Colors.black : Colors.red
              )
            ),
          ],
        )
      ),
    ); 
  }

  Widget _videoConsultationLobbyScheduleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: (){
                    _joinMeeting();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF00B6E6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Unirse',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
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

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: widget.pet_calendarItem.calendarEventId.toString())
      ..serverURL = serverUrl
      ..subject = "Videoconsulta"
      ..userDisplayName = "Dueño"
      ..userEmail = "user@mail.com"
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": "Videoconsulta",
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": "Dueño"}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
        onConferenceWillJoin: (message) => _onConferenceWillJoin(message),
        onConferenceJoined: (message) => _onConferenceJoined(message),
        onConferenceTerminated: (message) => _onConferenceTerminated(message),
        genericListeners: [
          JitsiGenericListener(
            eventName: 'readyToClose',
            callback: (dynamic message) {
              debugPrint("readyToClose callback");
            }
          ),
        ]
      ),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) async{

    await FirebaseFirestore.instance.collection("Mascotas").doc(widget.pet_calendarItem.petId).collection("Calendar").doc(widget.pet_calendarItem.calendarEventId).update({
      "done": true
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Dashboard()), 
      (Route<dynamic> route) => route.isFirst
    );
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

}