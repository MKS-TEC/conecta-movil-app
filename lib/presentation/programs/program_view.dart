import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/program/program_view_bloc.dart';
import 'package:conecta/application/program/program_view_event.dart';
import 'package:conecta/application/program/program_view_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ProgramView extends StatefulWidget {
  final String programId;

  ProgramView({required this.programId, Key? key}) : super(key: key);

  @override
  State<ProgramView> createState() => _ProgramViewViewState();
}

class _ProgramViewViewState extends State<ProgramView> {
  String? petId;
  Program? program;
  bool _loadingProgram = true;
  bool _getProgramError = false;
  List<ProgramActivity> _activitiesTips = List<ProgramActivity>.empty(growable: true);
  List<ProgramActivity> _activitiesAction = List<ProgramActivity>.empty(growable: true);
  List<CalendarEvent> _calendarEvents = List<CalendarEvent>.empty(growable: true);

  void _setActivitiesTipsType() {
    if (program!.activities!.length > 0) {
      List<ProgramActivity> activitiesTips = <ProgramActivity>[];

      program?.activities?.forEach((activity) {
          if (activity.type?.toLowerCase() == "tips") {
            activitiesTips.add(activity);
          }
      });

      setState(() {
        _activitiesTips = activitiesTips;
      });
    }
  }

  void _setActivitiesAction() {
    if (program!.activities!.length > 0) {
      List<ProgramActivity> activitiesAction = <ProgramActivity>[];

      program?.activities?.forEach((activity) {
          if (activity.type?.toLowerCase() == "action") {
            activitiesAction.add(activity);
          }
      });

      activitiesAction.sort((a, b) => a.toBeExecutedOn!.compareTo(b.toBeExecutedOn!));

      setState(() {
        _activitiesAction = activitiesAction;
      });
    }

    setState(() {
      _loadingProgram = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProgramViewBloc>()..add(GetPetDefault()),
      child: _programViewLayoutWidget(context)
    );
  }

  Widget _programViewLayoutWidget(BuildContext context) {
    return BlocConsumer<ProgramViewBloc, ProgramViewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF0E1326),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Color(0xFF0E1326),
              statusBarIconBrightness: Brightness.dark,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _programViewBodyWidget(context),
              ),
            ),

          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
          ),
        );
      },
      listener:  (context, state) {
        if (state is PetDefaultLoaded) {
          setState(() {
            petId = state.petId ?? "";
          });

          context.read<ProgramViewBloc>().add(GetProgram(state.petId ?? "", widget.programId));
        }

        if (state is ProgramLoaded) {
          setState(() {
            program = state.program;
            _getProgramError = false;
          });

          _setActivitiesTipsType();
          _setActivitiesAction();
        }

        if (state is ProgramNotLoaded) {
          setState(() {
            _loadingProgram = false;
            _getProgramError = true;
          });
        }

        if(state is CalendarsLoaded) {
          state.calendars.sort((a, b) => a.start!.compareTo(b.start!));
          setState(() {
            _calendarEvents = state.calendars;
          });
        }
      },
    );
  }

  Widget _petProfileCheckDataWidget(BuildContext context) {
    if (_loadingProgram) {
      return _petProfileLoadingWidget(context);
    } else if (_getProgramError) {
      return _petProfileErrorWidget(context);
    } else if (program == null) {
      return _petProfileEmptyWidget(context);
    } else {
      return Container();
    }
  }

  Widget _petProfileLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _petProfileErrorWidget(BuildContext context) {
    return BlocBuilder<ProgramViewBloc, ProgramViewState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramViewBloc>().add(GetProgram(petId ?? "", widget.programId));
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

  Widget _petProfileEmptyWidget(BuildContext context) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            'No se ha encontrado el programa.',
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

  Widget _programViewBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _programViewBackButtonWidget(context),
        _petProfileCheckDataWidget(context),
        Visibility(
          visible: _activitiesTips.length > 0 && !_loadingProgram && !_getProgramError,
          child: _programActivitiesTipsWidget(context),
        ),
        SizedBox(height: _activitiesTips.length > 0 ? 20 : 0),
        Visibility(
          visible: _activitiesAction.length > 0 && !_loadingProgram && !_getProgramError,
          child: _programViewTodayActivitiesActionWidget(context),
        ),
      ],
    );
  }

  Widget _programViewBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  program?.programCategory ?? "",
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

  Widget _programActivitiesTipsWidget(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 110,
        aspectRatio: 16/9,
        viewportFraction: 0.8,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 8),
      ),
      items: _activitiesTips.map((activity) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: _programViewActivityTipDetailWidget(context, activity),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _programViewActivityTipDetailWidget(BuildContext context, ProgramActivity activity) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.photo,
            size: 70,
            color: Color(0xFF6F7177),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      activity.title ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
                      activity.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Color(0xFF6F7177),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Nexa',
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

  Widget _programViewTodayActivitiesActionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: _programViewTodayActivitiesListWidget(context),
          ),
        ],
      ),
    ); 
  }

  Widget _programViewTodayActivitiesListWidget(BuildContext context) {
    DateTime currentDate = _calendarEvents.length > 0 ? _calendarEvents[0].start! : DateTime.now();
    DateTime firstCalendarEventDate = DateTime(currentDate.year, currentDate.month, currentDate.day, 0, 0, 0, 0, 0);
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: _calendarEvents.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            CalendarEvent currentCalendarEvent = _calendarEvents[index];
            DateTime calendarEventDate = 
              DateTime(currentCalendarEvent.start!.year, currentCalendarEvent.start!.month, currentCalendarEvent.start!.day, 0, 0, 0, 0, 0);
    
            if ((firstCalendarEventDate.compareTo(calendarEventDate) == 0) && index != 0) {
              return Container(
                height: 115,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _programViewTodayActivityWidget(context, _calendarEvents[index], index, false),
              );
            } else {
              firstCalendarEventDate = calendarEventDate;
              return Container(
                height: 132,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _programViewTodayActivityWidget(context, _calendarEvents[index], index, true),
              );
            }
            
          }, 
        ),
      ],
    );
  }

  Widget _programViewTodayActivityWidget(BuildContext context, CalendarEvent calendarEvent, int index, bool showDate) {
    return Column(
      children: [
        showDate ? Row(
          children: <Widget>[
            Expanded(
              child: Text(
                calendarEvent.start != null ? '${DateFormat.yMMMMd('es').format(calendarEvent.start!)}' : "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nexa',
                ),
              ),
            ),
          ],
        ) : Container(),
       // SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        calendarEvent.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFFE0E0E3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        calendarEvent.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xFF6F7177),
                          fontSize: 12,
                          fontFamily: 'Nexa',
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
    );
  }
}