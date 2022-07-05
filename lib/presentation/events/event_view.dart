import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/events/event_view/event_view_bloc.dart';
import 'package:conecta/application/events/event_view/event_view_event.dart';
import 'package:conecta/application/events/event_view/event_view_state.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';

class EventView extends StatefulWidget {
  final String eventId;

  EventView({required this.eventId, Key? key}) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Event? event;
  bool _loadingEvent = false;
  bool _getEventError = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventViewBloc>()..add(GetEvent(widget.eventId)),
      child: _eventViewLayoutWidget(context)
    );
  }

  Widget _eventViewLayoutWidget(BuildContext context) {
    return BlocConsumer<EventViewBloc, EventViewState>(
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
                child: _eventViewBodyWidget(context),
              ),
            ),

          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
          ),
        );
      },
      listener:  (context, state) {
        if (state is EventLoaded) {
          setState(() {
            event = state.event;
            _loadingEvent = false;
            _getEventError = false;
          });
        }

        if (state is EventNotWereLoaded) {
          setState(() {
            _loadingEvent = false;
            _getEventError = true;
          });
        }

        if (state is GetEventProcessing) {
          setState(() {
            _loadingEvent = true;
            _getEventError = false;
          });
        }
      },
    );
  }

  Widget _eventCheckDataWidget(BuildContext context) {
    if (_loadingEvent) {
      return _eventLoadingWidget(context);
    } else if (_getEventError) {
      return _eventErrorWidget(context);
    } else if (event == null) {
      return _eventEmptyWidget(context);
    } else {
      return Column(
        children: [
          _eventViewHeaderWidget(context),
          _eventViewDescriptionWidget(context),
          _eventViewAddressWidget(context),
        ],
      );
    }
  }

  Widget _eventLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _eventErrorWidget(BuildContext context) {
    return BlocBuilder<EventViewBloc, EventViewState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<EventViewBloc>().add(GetEvent(widget.eventId));
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

  Widget _eventEmptyWidget(BuildContext context) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            'No se ha encontrado el evento.',
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

  Widget _eventViewBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _eventViewBackButtonWidget(context),
        _eventCheckDataWidget(context),
      ],
    );
  }

  Widget _eventViewBackButtonWidget(BuildContext context) {
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
                  "Evento",
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

  Widget _eventViewHeaderWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Image.network(
                  event?.imageUrl ?? "",
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  event?.title ?? "",
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

  Widget _eventViewDescriptionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  event?.description ?? "",
                  style: TextStyle(
                    color: Color(0xFF58595F),
                    fontSize: 16,
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _eventViewAddressWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  event?.location ?? "",
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
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Hoy - A partir de las 8:00 am',
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
}