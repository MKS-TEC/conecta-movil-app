import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/application/initial_configuration/initial_configuration_bloc.dart';
import 'package:conecta/application/initial_configuration/initial_configuration_event.dart';
import 'package:conecta/application/initial_configuration/initial_configuration_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/species.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_secondary.dart';
import 'package:conecta/presentation/initial_configuration/pet_information.dart';

class SelectedPetType extends StatefulWidget {
  SelectedPetType({Key? key}) : super(key: key);

  @override
  State<SelectedPetType> createState() => _SelectedPetTypeState();
}

class _SelectedPetTypeState extends State<SelectedPetType> {
  final Pet pet = Pet();
  final GlobalKey<FormFieldState> _searchPetFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _searchPetController = TextEditingController();
  List<Species> species = List<Species>.empty(growable: true);
  List<Species> speciesFound = <Species>[];
  bool _loadingSpecies = false;

  void _onSearchPets(String value) {
    if (value.length > 0) {
      List<Species> _speciesFound = <Species>[];

      species.forEach((Species specie) { 
        if (specie.name!.toLowerCase().contains(value.toLowerCase())) {
          _speciesFound.add(specie);
        }
      });

      setState(() {
        speciesFound = _speciesFound;
      });

      return;
    }

    setState(() {
      speciesFound = [];
    });
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InitialConfigurationBloc>()..add(GetSpecies()),
      child: _selectedPetTypeLayoutWidget(context)
    );
  }

  Widget _selectedPetTypeLayoutWidget(BuildContext context) {
     return BlocConsumer<InitialConfigurationBloc, InitialConfigurationState>(
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
                child: _selectedPetTypeBodyWidget(context),
              ),
            ),
          ),
        );
      }, 
      listener: (context, state) {
        if (state is SpeciesLoaded) {
          setState(() {
            species = state.species;
            _loadingSpecies = false;
          });

          if (_searchPetController.text.isNotEmpty) {
            _onSearchPets(_searchPetController.text);
          }
        }
        if (state is GetSpeciesProcessing) {
          setState(() {
            _loadingSpecies = true;
          });
        }
      },
    );
  }

  Widget _selectedPetTypeBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _selectedPetTypeProgressWidget(context),
        _selectedPetTypeTitleWidget(context),
        SizedBox(height: 40),
        _selectedPetTypesWidget(context),
        SizedBox(height: 45),
        //_selectedPedTypeFinishButtonWidget(context),
      ],
    );
  }

  Widget _selectedPetTypeProgressWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
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
                    Icons.close,
                    color: Color(0xFF6F7177),
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: 0.40,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFEB9448),
                    ),
                    backgroundColor: Colors.white,
                    semanticsLabel: 'Linear progress indicator',
                    minHeight: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectedPetTypeTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Tengo una mascota',
            style: TextStyle(
              color: Color(0xFFE0E0E3),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 35),
          Text(
            'Selecciona qué tipo de mascota tienes para una mejor interacción con Conecta',
            style: TextStyle(
              color: Color(0xFF6F7177),
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ); 
  }

  Widget _selectedPetTypesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    pet.species = "Perro";
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PetInformation(pet)),
                    );
                  },
                  child: _selectedPedTypeCardWidget(context, 'assets/svg/dog-purple.svg', 'Perro', 40),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child:  InkWell(
                  onTap: () {
                    pet.species = "Gato";
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PetInformation(pet)),
                    );
                  },
                  child: _selectedPedTypeCardWidget(context, 'assets/svg/cat-purple.svg', 'Gato', 45),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return _otherPetsSheetMenuWidget(context, setState);
                        },
                      );
                    }
                  );
                },
                child: Container(
                  width: 175,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFF10172F),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              'assets/img/parrot-icon.png',
                              fit: BoxFit.cover,
                              width: 50,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Otro',
                            style: TextStyle(
                              color: Color(0xFF00B6E6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _selectedPedTypeCardWidget(BuildContext context, String iconPath, String pedType, double size) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF10172F),
                borderRadius: BorderRadius.circular(50),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: size,
                semanticsLabel: 'ped type icon',
              ),
            ),
            SizedBox(height: 20),
            Text(
              pedType,
              style: TextStyle(
                color: Color(0xFF00B6E6),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherPetsSheetMenuWidget(BuildContext context, StateSetter setState) {
    return Column(
      children: <Widget>[
        _otherPetsSearchFieldWidget(context),
        _otherPetsListWidget(context, setState),
        SizedBox(height: 30),
        Visibility(
          visible: !_loadingSpecies,
          child: _otherPetsSelectFinishButtonWidget(context),
        ),
      ],
    );
  }

  Widget _otherPetsSearchFieldWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '¿Qué especie de mascota tienes?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFieldSecondary(
                  inputKey: _searchPetFormKey,
                  controller: _searchPetController,
                  hintText: 'Escribe el nombre', 
                  onChanged: (value) => _onSearchChanged(value!),
                  validator: (value) => _searchValidator(value!),
                  icon: Icons.search,
                  isSuffixIcon: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherPetsListWidget(BuildContext context, StateSetter setState) {
    if (_loadingSpecies) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B6E6)),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          itemCount: speciesFound.length > 0 ? speciesFound.length : species.length,
          itemBuilder: (BuildContext context, int index) {
            return _otherPetsDetailsWidget(context, speciesFound.length > 0 ? speciesFound[index] : species[index], setState);
          }
        ),
      );
    }
  }

  Widget _otherPetsDetailsWidget(BuildContext context, Species specie, StateSetter setState) {
    return InkWell(
        onTap: () {
          setState(() {
            pet.species = specie.name!;
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: pet.species == specie.name ? Color(0xFF00B6E6) : Color(0xFF0E1326),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              specie.name ?? '',
              style: TextStyle(
                color: pet.species == specie.name ? Color(0xFFFFFFFF) : Color(0xFF6F7177),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
      ),
    );
  }

  Widget _otherPetsSelectFinishButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonPrimary(
                  text: 'Siguiente', 
                  onPressed: pet.species != null && pet.species!.length > 0 ? () {
                    Navigator.of(context).pop();
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PetInformation(pet)),
                    );
                  } : null, 
                  width: MediaQuery.of(context).size.width, 
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchPetFormKey.currentState?.validate();
    });
    _onSearchPets(_searchPetController.text.trim());
  }

  String? _searchValidator(String value) {
    return null;
  }
}