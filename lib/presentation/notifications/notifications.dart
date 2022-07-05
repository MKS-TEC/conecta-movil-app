import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/notifications/notifications_bloc.dart';
import 'package:conecta/application/notifications/notifications_event.dart';
import 'package:conecta/application/notifications/notifications_state.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/themeColors.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  
  List<NotificationModel> notifications = List<NotificationModel>.empty();
  bool _loadingNotifications = true;
  bool _getNotificationsError = false;
  User? authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return _notificationsLayoutWidget(context);
  }

  Widget _notificationsLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _notificationsBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _notificationsBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _notificationsBackButtonWidget(context),
        _getNotificationsView(context),
      ],
    );
  }

  Widget _getNotificationsView(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<NotificationsBloc>(
          create: (context) => getIt<NotificationsBloc>(),
        )
      ],
      child: _notificationsDeciderWidget(context)
    ); 
  }

  Widget _notificationsDeciderWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                authenticatedUser = state.user;                
              });

              context.read<NotificationsBloc>().add(GetNotifications(state.user!.uid));
            }
          },
        ),
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsLoaded) {
              setState(() {
                notifications = state.notifications;
                _loadingNotifications = false;
              });
            }
            if (state is NotificationsNotWereLoaded) {
              setState(() {
                _getNotificationsError = true;
                _loadingNotifications = false;
              });
            }
          },
        )
      ], 
      child: _notificationsCheckDataWidget(context)
    );
  }

  Widget _notificationsCheckDataWidget(BuildContext context) {
    if (_loadingNotifications) {
      return _notificationsLoadingWidget(context);
    } else if (_getNotificationsError) {
      return _notificationsErrorWidget(context);
    } else if (notifications.length == 0) {
      return _notificationsEmptyWidget(context);
    } else {
      return _notificationsListWidget(context);
    }
  }

  
  Widget _notificationsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  
  Widget _notificationsErrorWidget(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<NotificationsBloc>().add(GetNotifications(authenticatedUser!.uid));
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

  Widget _notificationsEmptyWidget(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<NotificationsBloc>().add(GetNotifications(authenticatedUser!.uid));
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.notifications,
                    color: primaryColor,
                    size: 80,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Aún no tienes notificaciones',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8C939B),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // SizedBox(height: 20),
                // Container(
                //   width: 100,
                //   height: 100.0,
                //   decoration: BoxDecoration(
                //     color: Colors.white
                //   ),
                //   child: Row(
                //     children:[
                //       Container(
                //         width: 50,
                //         child: Image.asset(
                //           'assets/icons/community-icon-notification.png',
                //           fit: BoxFit.cover,
                //           width: 20.0,
                //           height: 20.0,
                //         ),
                //       ),
                //       Column(
                //         children: [

                //         ],
                //       ),
                //     ]
                //   )
                // )
              ],
            ),
          ),
        );
      }
    ); 
  }

  Widget _notificationsListWidget(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _notificationDetailWidget(context, notifications[i]),
            );
          }
        ),
      ],
    );
  }

  Widget _notificationDetailWidget(BuildContext context, NotificationModel notification) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: <Widget>[
           Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryLightColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(100.0)
            ),
            child: Center(
              child: Icon(
                Icons.videocam_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      notification.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFFE0E0E3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Hace un momento",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF6F7177),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    notification.description?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: Color(0xFF6F7177),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationsBackButtonWidget(BuildContext context) {
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
                  'Notificaciones',
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

}