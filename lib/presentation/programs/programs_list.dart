import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/program/programs_list_cubit.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/programs/program_view.dart';

class ProgramsList extends StatefulWidget {
  final String mainProgramCategory;

  ProgramsList(this.mainProgramCategory, {Key? key}) : super(key: key);

  @override
  State<ProgramsList> createState() => _ProgramsListState();
}

class _ProgramsListState extends State<ProgramsList> {
  List<ProgramCategory> _programCategories = List<ProgramCategory>.empty(growable: true);
  String _programCategorySelected = "";
  List<Program> _programs = List<Program>.empty(growable: true);
  List<Program> _programsPet = List<Program>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProgramsListCubit>()..loadProgramCategories(widget.mainProgramCategory),
      child: _programsListLayoutWidget(context),
    );
  }

  Widget _programsListLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _programsListBodyWidget(context),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _programsListBodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _programsListTitleWidget(context),
        _programListHandlerWidget(context),
      ],
    );
  }

  Widget _programListHandlerWidget(BuildContext context) {
    return BlocConsumer<ProgramsListCubit, ProgramsListState>(
      listener: (context, state) {
        state.mapOrNull(
          programCategoriesLoaded: (state) {
            _programCategories = state.programsCategories;
            _programCategorySelected = _programCategories.length > 0 ? _programCategories[0].name : "";
            context.read<ProgramsListCubit>().loadProgramsPet();
          },
          programsPetLoaded: (state) {
            _programs = state.programs;
            _mapProgramsPetByCategory(_programCategorySelected);
            context.read<ProgramsListCubit>().loadProgramsByCategory(_programCategories.length > 0 ? _programCategories[0].id : "");
          }
        );
      },
      builder: (context, state) {
        return state.mapOrNull<Widget>(
          initial: (state) {
            return _programsListLoadingWidget(context);
          },
          loadingProgramCategories: (state) {
            return _programsListLoadingWidget(context);
          },
          loadingProgramsByCategory: (state) {
            return _programsListLoadingWidget(context);
          },
          loadingProgramsPet: (state) {
            return _programsListLoadingWidget(context);
          },
          programsByCategoryLoaded: (state) {
            if (_programCategories.length > 0) {
              return _programsListContentWidget(context);
            } else {
              return _programsCategoriesListEmptyWidget(context);
            }
          }, 
          errorLoadingProgramCategories: (state) {
            return _programsListErrorWidget(context); 
          },
          errorLoadingProgramsByCategory: (state) {
            return _programsListErrorWidget(context); 
          },
          errorLoadingProgramsPet: (state) {
            return _programsListErrorWidget(context); 
          }
        ) ?? _programsListLoadingWidget(context);
      }
    );
  }

  Widget _programsListLoadingWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
        ),
      ),
    );
  }

  Widget _programsListErrorWidget(BuildContext context) {
    return BlocBuilder<ProgramsListCubit, ProgramsListState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramsListCubit>().loadProgramCategories(widget.mainProgramCategory);
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

  Widget _programsListContentWidget(BuildContext context) {
    return Column(
      children: [
        _programsListSubCategoriesWidget(context),
        _programsPet.length > 0 ? _programsListWidget(context) : _programsListEmptyWidget(context),
      ],
    );
  }

  Widget _programsCategoriesListEmptyWidget(BuildContext context) {
    return BlocBuilder<ProgramsListCubit, ProgramsListState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramsListCubit>().loadProgramCategories(widget.mainProgramCategory);
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'No se han encontrado subcategorias programas actualmente.',
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

  Widget _programsListEmptyWidget(BuildContext context) {
    return BlocBuilder<ProgramsListCubit, ProgramsListState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<ProgramsListCubit>().loadProgramCategories(widget.mainProgramCategory);
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'No se han encontrado programas actualmente.',
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
    ); 
  }

  Widget _programsListTitleWidget(BuildContext context) {
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
                  "Subcategorias",
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

  Widget _programsListSubCategoriesWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 140,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.horizontal,
        itemCount: _programCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return _programsListSubCategoryDetailWidget(context, _programCategories[index]);
        }
      ),
    );
  }

  Widget _programsListSubCategoryDetailWidget(BuildContext context, ProgramCategory programCategory) {
    return BlocBuilder<ProgramsListCubit, ProgramsListState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(right: 25),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<ProgramsListCubit>().loadProgramsByCategory(programCategory.id);

                  _mapProgramsPetByCategory(programCategory.name);

                  setState(() {
                    _programCategorySelected = programCategory.name;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: programCategory.name == _programCategorySelected ? Color(0xFF36C56C) : Color(0xFF36C56C).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Image.asset(
                    "assets/icons/${programCategory.icon}",
                    height: 40,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                programCategory.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }
    ); 
  }

  Widget _programsListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(20),
      itemCount: _programsPet.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () {
              
            },
            child: _programCardWidget(context, _programsPet[index]),
          ),
        );
      }
    );
  }

  bool _isPetAffiliateToProgram(Program program) {
    Program programIsAffiliate = _programsPet.firstWhere((programFind) => programFind.programCategoryId == program.programCategoryId, orElse: () => Program());

    if (programIsAffiliate.programCategoryId != null) return true;

    return false;
  }

  Widget _programCardWidget(BuildContext context, Program program) {
    bool _isAffiliate = _isPetAffiliateToProgram(program);
    String _icon = program.programCategory?.toLowerCase() == "cuidado y limpieza" ? "bath.png" : "vaccines.png";

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProgramView(programId: program.programId ?? ""))
        );
      },
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
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
                          child: Image.asset(
                            "assets/icons/$_icon",
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  program.programCategory ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                                  program.description ?? "",
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
            ],
          ),
        ],
      ),
    );
  }

  void _mapProgramsPetByCategory(String programCategory) {
    List<Program> _programsAdds = [];

    switch (programCategory.toLowerCase()) {
      case "baños y limpieza":
        _programs.forEach((program) {
          if (program.programCategory!.toLowerCase() == "cuidado y limpieza") {
            _programsAdds.add(program);
          }
        });
        break;
      case "vacunación":
        _programs.forEach((program) {
          if (program.programCategory!.toLowerCase() == "vacunación") {
            _programsAdds.add(program);
          }
        });
        break;
      case "desparasitación":
        _programs.forEach((program) {
          if (program.programCategory!.toLowerCase() == "desparasitación") {
            _programsAdds.add(program);
          }
        });
        break;
      default:
       _programs.forEach((program) {
          if (program.programCategory!.toLowerCase() == "cuidado y limpieza") {
            _programsAdds.add(program);
          }
        });
    }

    setState(() {
      _programsPet = _programsAdds;
    });
  }
}