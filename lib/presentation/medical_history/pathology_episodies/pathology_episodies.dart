import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:conecta/application/episodies/pathology_episodes_event.dart';
import 'package:conecta/application/episodies/pathology_episodies_bloc.dart';
import 'package:conecta/application/episodies/pathology_episodies_state.dart';
import 'package:conecta/domain/core/entities/episode.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';

class PathologyEpisodies extends StatefulWidget {
  final String petId;
  final String pathologyName;

  PathologyEpisodies({required this.petId, required this.pathologyName, Key? key}) : super(key: key);

  @override
  State<PathologyEpisodies> createState() => _PathologyEpisodiesState();
}

class _PathologyEpisodiesState extends State<PathologyEpisodies> {
  List<Episode> _episodies = List<Episode>.empty(growable: true);
  bool _loadingEpisodies = true;
  bool _getEpisodiesError = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PathologyEpisodiesBloc>()..add(GetEpisodies(widget.petId, widget.pathologyName)),
      child: _pathologyEpisodiesLayoutWidget(context)
    );
  }

  Widget _pathologyEpisodiesLayoutWidget(BuildContext context) {
    return BlocConsumer<PathologyEpisodiesBloc, PathologyEpisodiesState>(
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
                child: _pathologyEpisodiesBodyWidget(context),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
          ),
        );
      },
      listener: (context, state) {
        if (state is EpisodiesLoaded) {
          setState(() {
            _episodies = state.episodes;
            _loadingEpisodies = false;
          });
        }

        if (state is EpisodiesNotWereLoaded) {
          setState(() {
            _getEpisodiesError = true;
            _loadingEpisodies = false;
          });
        }

        if (state is GetEpisodiesProcessing) {
          setState(() {
            _getEpisodiesError = false;
            _loadingEpisodies = true;
          });
        }
      },
    );
  }

  Widget _pathologyEpisodiesCheckDataWidget(BuildContext context) {
    if (_loadingEpisodies) {
      return _pathologyEpisodiesLoadingWidget(context);
    } else if (_getEpisodiesError) {
      return _pathologyEpisodiesErrorWidget(context);
    } else if (_episodies.length == 0) {
      return _pathologyEpisodiesEmptyWidget(context);
    } else {
      return _pathologyEpisodiesListWidget(context);
    }
  }

  Widget _pathologyEpisodiesLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _pathologyEpisodiesErrorWidget(BuildContext context) {
    return BlocBuilder<PathologyEpisodiesBloc, PathologyEpisodiesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<PathologyEpisodiesBloc>().add(GetEpisodies(widget.petId, widget.pathologyName));
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

  Widget _pathologyEpisodiesEmptyWidget(BuildContext context) {
    return BlocBuilder<PathologyEpisodiesBloc, PathologyEpisodiesState>(
      builder: (context, state) {
        return Container(
          height: 75,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Aún no hay diagnosticos sobre esta patología.',
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
    ); 
  }

  Widget _pathologyEpisodiesBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _pathologyEpisodiesBackButtonWidget(context),
        _pathologyEpisodiesCheckDataWidget(context),
      ],
    );
  }

  Widget _pathologyEpisodiesBackButtonWidget(BuildContext context) {
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
                  widget.pathologyName,
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

  Widget _pathologyEpisodiesListWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _episodies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: _pathologyEpisodeDetailWidget(context, _episodies[index]),
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

  Widget _pathologyEpisodeDetailWidget(BuildContext context, Episode episode) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    episode.diagnose ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nexa',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    episode.comment ?? "",
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFE0E0E3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nexa',
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    episode.date != null ? DateFormat.yMMMMd('es').format(episode.date!) : "",
                    style: TextStyle(
                      color: Color(0xFF8C939B),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Nexa',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}