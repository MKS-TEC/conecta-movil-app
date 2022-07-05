import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/events/events_bloc.dart';
import 'package:conecta/application/events/events_event.dart';
import 'package:conecta/application/events/events_state.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';

class Events extends StatefulWidget {
  Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Pet? pet;
  String? petId;
  List<Event> events = List<Event>.empty();
  List<Event> eventsFeatures = List<Event>.empty();
  List<String> eventsCategories = <String>[];
  bool _loadingPet = true;
  bool _getPetError = false;
  bool _loadingEvents = true;
  bool _getEventsError = false;

  void _setEvents(List<Event> eventsToMap) {
    if (eventsToMap.length > 0) {
      List<Event> _events = <Event>[];
      List<Event> _eventsFeatures = <Event>[];
      List<String> _eventsCategories = <String>[];

      eventsToMap.forEach((event) {
          if (event.features?.breed?.toLowerCase() == pet?.breed?.toLowerCase()) {
            _eventsFeatures.add(event);
          } else if (event.features?.species?.toLowerCase() == pet?.species?.toLowerCase() || event.features?.species?.toLowerCase() == "all") {
            _events.add(event);
          }

          String _eventCategory = _eventsCategories.firstWhere((eventCategory) => eventCategory.toLowerCase() == event.features?.eventCategory?.toLowerCase(), orElse: () => "");

          if (_eventCategory.length == 0) _eventsCategories.add(event.features!.eventCategory!);
      });

      setState(() {
        events = _events;
        eventsFeatures = _eventsFeatures;
        eventsCategories = _eventsCategories;
      });
    }

    setState(() {
      _loadingEvents = false;
      _getEventsError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventsBloc>()..add(GetPetDefault()),
      child: _eventsLayoutWidget(context)
    );
  }

  Widget _eventsLayoutWidget(BuildContext context) {
    return BlocConsumer<EventsBloc, EventsState>(
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
                child: _eventsBodyWidget(context),
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

          context.read<EventsBloc>().add(GetPet(state.petId ?? ""));
        }

        if (state is PetLoaded) {
          setState(() {
            pet = state.pet;
            _loadingPet = false;
            _getPetError = false;
          });

          context.read<EventsBloc>().add(GetEvents());
        }

        if (state is EventsLoaded) {
          _setEvents(state.events);
        }

        if (state is EventsNotWereLoaded) {
          setState(() {
            _getEventsError = true;
            _loadingEvents = false;
          });
        }

        if (state is PetNotLoaded) {
          setState(() {
            _loadingPet = false;
            _getPetError = true;
          });
        }

        if (state is GetEventsProcessing) {
          setState(() {
            _getEventsError = false;
            _loadingEvents = true;
          });
        }
      },
    );
  }

  Widget _eventsCheckDataWidget(BuildContext context) {
    if (_loadingPet || _loadingEvents) {
      return _eventsLoadingWidget(context);
    } else if (_getPetError || _getEventsError) {
      return _eventsErrorWidget(context);
    } else if (events.length == 0 && eventsFeatures.length == 0) {
      return _eventsEmptyWidget(context);
    } else {
      return Container();
    }
  }

   Widget _eventsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _eventsErrorWidget(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (_getEventsError) {
              context.read<EventsBloc>().add(GetEvents());
            } else {
              context.read<EventsBloc>().add(GetPetDefault());
            }
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

   Widget _eventsEmptyWidget(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<EventsBloc>().add(GetEvents());
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'No hemos encontrado eventos para ti en este momento.',
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

  Widget _eventsBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _eventsBackButtonWidget(context),
        _eventsCheckDataWidget(context),
        Visibility(
          visible: eventsFeatures.length > 0,
          child: _eventsFeaturesWidget(context),
        ),
        SizedBox(height: eventsFeatures.length > 0 ? 20 : 0),
        Visibility(
          visible: events.length > 0 && eventsCategories.length > 0,
          child: _eventsListWidget(context),
        ),
      ],
    );
  }

  Widget _eventsBackButtonWidget(BuildContext context) {
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
                  "Eventos",
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

  Widget _eventsFeaturesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Eventos recomendados',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 110,
                    aspectRatio: 16/9,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 8),
                  ),
                  items: eventsFeatures.map((activity) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: _eventsFeaturedDetailWidget(context, activity),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventsFeaturedDetailWidget(BuildContext context, Event event) {
    return SizedBox(
      height: 500,
      child: Card(
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
                child: Visibility(
                  visible: event.imageUrl != null && event.imageUrl!.isNotEmpty,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF86A3A3),
                    radius: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        event.imageUrl ?? "",
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                              event.title ?? "",
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        event.description ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
    );
  }

  Widget _eventsListWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: eventsCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _eventCategoryDetailWidget(context, eventsCategories[index]),
              );
            }, 
          ),
        ],
      ),
    ); 
  }

  List<Event> _getEventsForCategory(String category) {
    List<Event> _events = <Event>[];

    events.forEach((event) {
      if (event.features?.eventCategory?.toLowerCase() == category.toLowerCase()) {
        _events.add(event);
      }
    });

    return _events;
  }

  Widget _eventCategoryDetailWidget(BuildContext context, String category) {
    List<Event> _events = _getEventsForCategory(category);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Eventos de $category',
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 130,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                ),
                items: _events.map((event) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: _eventDetailWidget(context, event),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _eventDetailWidget(BuildContext context, Event event) {
    return Card(
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
              child: Visibility(
                visible: event.imageUrl != null && event.imageUrl!.isNotEmpty,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF86A3A3),
                  radius: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      event.imageUrl ?? "",
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                            event.title ?? "",
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
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      event.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
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
    );
  }
}