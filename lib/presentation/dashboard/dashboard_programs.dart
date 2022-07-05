import 'package:conecta/presentation/common/themeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/dashboard/program_categories_list/program_category_list_cubit.dart';
import 'package:conecta/application/dashboard/program_list/program_list_bloc.dart';
import 'package:conecta/application/dashboard/program_list/program_list_event.dart';
import 'package:conecta/application/dashboard/program_list/program_list_state.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/programs/program_view.dart';
import 'package:conecta/presentation/programs/programs_list.dart';
import 'package:conecta/presentation/video_consultation/video_consultation.dart';

class DashboardPrograms extends StatefulWidget {
  DashboardPrograms({Key? key}) : super(key: key);

  @override
  State<DashboardPrograms> createState() => _DashboardProgramsState();
}

class _DashboardProgramsState extends State<DashboardPrograms> {
  String? petId;
  List<Program> programs = List<Program>.empty();
  List<Program> programsForCategories = List<Program>.empty();
  List<ProgramCategory> _programCategories = List<ProgramCategory>.empty();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _dashboardProgramsLayoutWidget(context)
      ],
    );
  }

  Widget _dashboardProgramsLayoutWidget(BuildContext context) {
    return _dashboardProgramsBodyWidget(context);
  }

  Widget _dashboardProgramsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _dashboardProgramsErrorWidget(BuildContext context) {
    return BlocBuilder<ProgramCategoryListCubit, ProgramCategoryListState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramCategoryListCubit>().loadMainProgramCategories();
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'Ocurrió un error inesperado. Comprueba tu conexión a Internet e intentalo nuevamente.',
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

  Widget _dashboardProgramsEmptyWidget(BuildContext context) {
    return BlocBuilder<ProgramCategoryListCubit, ProgramCategoryListState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramCategoryListCubit>().loadMainProgramCategories();
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'No se han encontrado categorías de programas actualmente.',
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

  Widget _dashboardProgramsBodyWidget(BuildContext context) {
    return Column(
      children: [
        //_dashboardVideoconsultingPendingWidget(context),
        _dashboardProgramsPendingWidget(context),
      ],
    );
  }

  /*Program _getProgram(CalendarEvent calendarEvent) {
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
  }*/

  /*Widget _dashboardVideoconsultingPendingWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: programsForCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProgramView(programId: programsForCategories[index].programId!)),
                    );
                  },
                  child: _dashboardProgramsPendingDetailsWidget(context, programsForCategories[index]),
                ),
              );
            }
          ),
        ],
      ),
    );
  }*/
  
  Widget _dashboardProgramsPendingWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Programas para ti',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0
          ),
          __mainProgramCategoryCardWidget1(context)
        ],
      ),
    );
  }

  Widget __mainProgramCategoryCardWidget1(BuildContext context) {
    return Card(
      color: secondLevelColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF36C56C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.medical_services,
                size: 30,
                color: Color(0xFF36C56C),
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Programa de bienestar familiar",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFFE0E0E3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Dirigido a toda familia para darles herramientas para su convivencia y bienestar.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF6F7177),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}