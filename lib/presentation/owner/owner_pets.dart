import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conecta/application/auth/auth_bloc.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/application/owner/pets/owner_pets_bloc.dart';
import 'package:conecta/application/owner/pets/owner_pets_event.dart';
import 'package:conecta/application/owner/pets/owner_pets_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/pet/create_pet/selected_pet_type.dart';
import 'package:conecta/presentation/pet/pet_profile/pet_profile.dart';

class OwnerPets extends StatefulWidget {
  OwnerPets({Key? key}) : super(key: key);

  @override
  State<OwnerPets> createState() => _OwnerPetsState();
}

class _OwnerPetsState extends State<OwnerPets> {
  List<Pet> pets = List<Pet>.empty();
  String? _userId;
  bool _loadingPets = true;
  bool _getPetsError = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>()..add(GetAuthenticatedSubject()),
        ),
        BlocProvider<OwnerPetsBloc>(
         create: (BuildContext context) => getIt<OwnerPetsBloc>(),
        ),
      ], 
      child: _ownerPetsLayoutWidget(context)
    );
  }

  Widget _ownerPetsLayoutWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedSubjectLoaded) {
              setState(() {
                _userId = state.user?.uid;
              });

              context.read<OwnerPetsBloc>().add(GetSubjectPets(state.user!.uid));
            }
          },
        ),
        BlocListener<OwnerPetsBloc, OwnerPetsState>(
          listener: (context, state) {
            if (state is SubjectPetsLoaded) {
              setState(() {
                pets = state.pets;
                _loadingPets = false;
              });
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
              child: _ownerPetsBodyWidget(context),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            "Agregar nueva mascota", 
            style: TextStyle(
              color: Colors.white, 
            ),
          ),
          backgroundColor: Color(0xFF00B6E6),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectedPetType()),
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _ownerPetsBodyWidget(BuildContext context) {
    return Column(
      children: [
        _ownerPetsBackButtonWidget(context),
        _ownerPetsCheckDataWidget(context),
      ],
    );
  }

  Widget _ownerPetsCheckDataWidget(BuildContext context) {
    if (_loadingPets) {
      return _ownerPetsLoadingWidget(context);
    } else if (_getPetsError) {
      return _ownerPetsErrorWidget(context);
    } else if (pets.length == 0) {
      return _ownerPetsEmptyWidget(context);
    } else {
      return _ownerPetsListWidget(context);
    }
  }

  Widget _ownerPetsLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
      ),
    );
  }

  Widget _ownerPetsErrorWidget(BuildContext context) {
    return BlocBuilder<OwnerPetsBloc, OwnerPetsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<OwnerPetsBloc>().add(GetSubjectPets(_userId!));
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

  Widget _ownerPetsEmptyWidget(BuildContext context) {
    return BlocBuilder<OwnerPetsBloc, OwnerPetsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<OwnerPetsBloc>().add(GetSubjectPets(_userId!));
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'Aún no posees mascotas, ¿tienes una? agregala',
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

  Widget _ownerPetsBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
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
                  'Tus mascotas',
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

  Widget _ownerPetsListWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: pets.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _ownerPetsDetailWidget(context, pets[index])
        );
      }
    );
  }

  Widget _ownerPetsDetailWidget(BuildContext context, Pet pet) {
    return BlocBuilder<OwnerPetsBloc, OwnerPetsState>(
       builder: (context, state) {
         return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PetProfile(petId: pet.petId!)),
                      ).then((value) {
                        setState(() {
                          _loadingPets = true;
                        });

                        context.read<OwnerPetsBloc>().add(GetSubjectPets(_userId!));
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFF0E1326),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Visibility(
                                visible: pet.picture != null && pet.picture!.isNotEmpty,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF86A3A3),
                                  radius: 28,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      pet.picture ?? "",
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
                                    child: Text(
                                      pet.name ?? '',
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
                                      pet.about ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFFE0E0E3),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
       }
    );
  }
}