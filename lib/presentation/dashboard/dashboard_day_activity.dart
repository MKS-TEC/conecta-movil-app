import 'package:carousel_slider/carousel_slider.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/dashboard/daily_activities/dashboard_daily_activities_bloc.dart';
import 'package:conecta/application/dashboard/daily_activities/dashboard_daily_activities_event.dart';
import 'package:conecta/application/dashboard/daily_activities/dashboard_daily_activities_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_outline_primary.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/events/event_view.dart';
import 'package:conecta/presentation/events/events.dart';
import 'package:conecta/presentation/video_consultation/video_consultation_lobby.dart';

class DashboardDayActivity extends StatefulWidget {
  DashboardDayActivity({Key? key}) : super(key: key);

  @override
  State<DashboardDayActivity> createState() => _DashboardDayActivityState();
}

class _DashboardDayActivityState extends State<DashboardDayActivity> {
  Pet? pet;
  String? petId;
  List<Program> programs = List<Program>.empty();
  List<CalendarEvent> calendarEvents = List<CalendarEvent>.empty();
  List<Event> events = List<Event>.empty();
  bool _loading = true;
  bool _getError = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  int timeInSeconds(DateTime date) {
    var ms = date.millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  void _setCalendarEventsActivities(List<CalendarEvent> calendarEventsToMap) {
    if (calendarEventsToMap.length > 0) {
      List<CalendarEvent> _calendarEvents = <CalendarEvent>[];

      calendarEventsToMap.sort((a, b) => a.start!.compareTo(b.start!));

      calendarEventsToMap.forEach((calendarEvent) { 
        if (calendarEvent.source?.toLowerCase() == "actividad" && _calendarEvents.length < 10) {
          _calendarEvents.add(calendarEvent);
        }else if (calendarEvent.source?.toLowerCase() == "videoconsulta"){
            var _actualDay = DateTime.now().day.toString();
            var _actualMonth = DateTime.now().month.toString();
            var _actualYear = DateTime.now().year.toString();

            var _actualDate = _actualDay + _actualMonth + _actualYear;

            var _eventDay = calendarEvent.end!.day.toString();
            var _eventMonth = calendarEvent.end!.month.toString();
            var _eventYear = calendarEvent.end!.year.toString();

            var _eventDate = _eventDay + _eventMonth + _eventYear;

            if (_actualDate == _eventDate && calendarEvent.done == false) {
              _calendarEvents.add(calendarEvent);
            }
        }
      });

      setState(() {
        calendarEvents = _calendarEvents;
      });
    }
  }

  void _setEvents(List<Event> eventsToMap) {
    if (eventsToMap.length > 0) {
      List<Event> _events = <Event>[];

      eventsToMap.forEach((event) {
          if (event.features?.breed?.toLowerCase() == pet?.breed?.toLowerCase()) {
            _events.add(event);
          } else if (event.features?.species?.toLowerCase() == pet?.species?.toLowerCase() || event.features?.species?.toLowerCase() == "all") {
            _events.add(event);
          }
      });

      setState(() {
        events = _events;
      });
    }

    setState(() {
      _loading = false;
      _getError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _dashboardDayActivityLayoutWidget(context);
  }

  Widget _dashboardDayActivityLayoutWidget(BuildContext context) {
    return _dashboardDayActivityCheckDataWidget(context);
  }

  Widget _dashboardDayActivityCheckDataWidget(BuildContext context) {
    return _dashboardDayActivityBodyWidget(context);
  }

  Widget _dashboardDayActivityLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _dashboardDayActivityErrorWidget(BuildContext context) {
    return BlocBuilder<DashboardDailyActivitiesBloc, DashboardDailyActivitiesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<DashboardDailyActivitiesBloc>().add(GetPetDefault());
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

  Widget _dashboardDayActivityBodyWidget(BuildContext context) {
    return Column(
      children: [
        _dashboardDayActivityChallengeWidget(context),
        // events.length > 0 ? _dashboardDayActivityChallengeWidget(context) : _dashboardDayActivityChallengeEmptyWidget(context),
        _dashboardDayActivityPendingWidget(context),
        // calendarEvents.length > 0 ? _dashboardDayActivityPendingWidget(context) : _dashboardDayActivityEmptyWidget(context),
      ],
    );
  }

  Widget _dashboardDayActivityChallengeEmptyWidget(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: <Widget>[
            Text(
              'No hay eventos para ti en este momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE0E0E3),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardDayActivityEmptyWidget(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
        child: Column(
          children: <Widget>[
            Text(
              'Tu mascota no tiene actividades actualmente.',
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

  Widget _dashboardDayActivityChallengeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Eventos para ti',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Events()),
                  );
                },
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    color: Color(0xFF6F7177),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _dashboardDayActivityEventDetailWidget(context)
        ],
      ),
    );
  }

  Widget _dashboardDayActivityEventDetailWidget(BuildContext context) {
    return SizedBox(
      height: 130,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      "https://media.istockphoto.com/photos/shot-of-a-doctor-examining-a-patient-with-a-stethoscope-during-a-in-picture-id1369619516?b=1&k=20&m=1369619516&s=170667a&w=0&h=z-9AKH3yzuVaJ2mqwCBrx-lkTUombzYHypNnFwHrj-g=",
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                                "Jornada de la salud",
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
                          "Acompáñanos junto a tu familia y comparte consejos saludables para todos",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Hoy - a partir de las 8:00 am',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 12,
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
        ),
      ),
    );
  }

  Widget _dashboardDayActivityPendingWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Actividades pendientes',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _dashboardDayActivityPendingDetailsWidget(context),
          _dashboardDayActivityPendingDetailsWidget(context),
          _dashboardDayActivityPendingDetailsWidget(context)
        ],
      ),
    );
  }

  Program _getProgram(CalendarEvent calendarEvent) {
    Program _program = Program();

    for (var i = 0; i < programs.length; i++) {
      if (programs[i].activities!.length > 0) {
        ProgramActivity _programActivity = programs[i].activities!.firstWhere((programActivityFind) => programActivityFind.programActivityId == calendarEvent.sourceId, orElse: () => ProgramActivity());
      
        if (_programActivity.programActivityId != null) {
          _program = programs[i];
          break;
        }
      }
    }

    return _program;
  }

  String _getActivityIcon(Program program) {
    if (program.programId != null) {
      switch (program.programCategory?.toLowerCase()) {
        case "cuidado":
          return "assets/svg/activity-bath.svg";
        case "vacunación":
          return "assets/svg/activity-bath.svg";
        case "entrenamiento":
          return "assets/svg/activity-training.svg";
        default:
          return "assets/svg/activity-conduct.svg";
      }
    }

    return "assets/svg/activity-conduct.svg";
  }

  Widget _dashboardDayActivityPendingDetailsWidget(BuildContext context) {

    return SizedBox(
      height: 120,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      "https://media.istockphoto.com/photos/shot-of-a-doctor-examining-a-patient-with-a-stethoscope-during-a-in-picture-id1369619516?b=1&k=20&m=1369619516&s=170667a&w=0&h=z-9AKH3yzuVaJ2mqwCBrx-lkTUombzYHypNnFwHrj-g=",
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                                "Renovación de tu póliza",
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
                          "Debes renovar tu póliza de Mazda AZ3456",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "10 abril 2022",
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
        ),
      ),
    );
  }

  Widget _dashboardDayActivityDetailDialogWidget(BuildContext context, CalendarEvent calendarEvent, String icon) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        content: Container(
        constraints: BoxConstraints(maxHeight: 340),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00B6E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Padding(
                padding: EdgeInsets.all(20),
                child:  SvgPicture.asset(
                  icon,
                  width: 10,
                  semanticsLabel: 'activity icon',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              calendarEvent.title ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF00B6E6),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                calendarEvent.start! != null ? '${DateFormat.yMMMMd('es').format(calendarEvent.start!)}' : "",
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(
                    child: ButtonPrimary(
                      text: 'Regresar', 
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