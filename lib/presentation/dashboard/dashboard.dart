import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/dashboard/dashboard_bloc.dart';
import 'package:conecta/application/dashboard/dashboard_event.dart';
import 'package:conecta/application/dashboard/dashboard_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/dashboard/dashboard_day_activity.dart';
import 'package:conecta/presentation/dashboard/dashboard_policies.dart';
import 'package:conecta/presentation/dashboard/dashboard_programs.dart';
import 'package:conecta/presentation/gamification/gamification_challenges.dart';
import 'package:conecta/presentation/notifications/notifications.dart';
import 'package:conecta/presentation/pet/create_pet/selected_pet_type.dart';

class Dashboard extends StatefulWidget {
  final int viewInit;

  Dashboard({this.viewInit = 0, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> _views = <String>[
    'Actividades',
    'Pólizas',
    'Programas',
  ];
  User? authenticatedUser;
  String? _userName;
  bool _loading = true;
  int _viewSelected = 0;

  Widget _getDashboardView(BuildContext context) {
    switch (_viewSelected) {
      case 0:
        return DashboardDayActivity();
      case 1:
        return DashboardPolicies();
      case 2:
        return DashboardPrograms();
      default:
        return DashboardDayActivity();
    }
  }

  @override
  void initState() {
    super.initState();
    _viewSelected = widget.viewInit;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>(),
          // create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<DashboardBloc>(
          create: (BuildContext context) => getIt<DashboardBloc>(),
        ),
      ], 
      child: _dashboardLayoutWidget(context)
    );
  }

  Widget _dashboardLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _dashboardBodyWidget(context),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _dashboardBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _dashboardUserMenuWidget(context),
        SizedBox(
          height: 20
        ),
        _dashboardViewsOptionsWidget(context),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: _getDashboardView(context),
        ),
      ],
    );
  }

  Widget _dashboardUserMenuWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30
                      )
                    )
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hola',
                        style: TextStyle(
                          color: Color(0xFF6F7177),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        _userName ?? 'Nombre de usuario',
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ten un bonito día',
                        style: TextStyle(
                          color: Color(0xFF6F7177),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nexa',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Color(0xFF00B6E6),
                ),
                tooltip: 'Notificaciones',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Notifications())
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashboardViewsOptionsWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 65,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        itemCount: _views.length,
        itemBuilder: (BuildContext context, int index) {
          return _dashboardViewDetail(context, _views[index], index);
        }
      ),
    );
  }

  Widget _dashboardViewDetail(BuildContext context, String view, int index) {
    return InkWell(
        onTap: () {
          setState(() {
            _viewSelected = index;
          });
        },
        child: Container(
        width: 150,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _viewSelected == index ? Color(0xFF00B6E6) : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          view,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _viewSelected == index ? Color(0xFFFFFFFF) : Color(0xFF6F7177),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _screenCloseDialogWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 225),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Próximamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Nos estamos preparando para ofrecerte esto en futuras versiones. Te tendrémos informado sobre nuestras próximas actualizaciones.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              ButtonPrimary(
                text: 'De acuerdo, gracias', 
                onPressed: () {
                  Navigator.of(context).pop();
                },
                width: MediaQuery.of(context).size.width, 
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
