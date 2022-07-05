import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:conecta/application/pet/create_pet/create_pet_bloc.dart';
import 'package:conecta/application/pet/create_pet/create_pet_event.dart';
import 'package:conecta/application/pet/create_pet/create_pet_state.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/injection.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/common/text_field/text_field_secondary.dart';
import 'package:conecta/presentation/pet/create_pet/care_program.dart';

class PetInformation extends StatefulWidget {
  final Pet pet;
  PetInformation(this.pet, {Key? key}) : super(key: key);

  @override
  State<PetInformation> createState() => _PetInformationState();
}

class _PetInformationState extends State<PetInformation> {
  final GlobalKey<FormFieldState> _petNameFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _petNameController = TextEditingController();
  final GlobalKey<FormFieldState> _searchBreedFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _searchBreedController = TextEditingController();
  List<Breed> breeds = List<Breed>.empty(growable: true);
  List<Breed> breedsFound = <Breed>[];
  bool _validForm = false;
  bool _loadingBreeds = false;
  String? _petSex = 'Masculino';
  DateTime? _petBirthdate;

  void _onSearchBreeds(String value) {
    if (value.length > 0) {
      List<Breed> _breedsFound = <Breed>[];

      breeds.forEach((Breed breed) { 
        if (breed.name!.toLowerCase().startsWith(value.toLowerCase())) {
          _breedsFound.add(breed);
        }
      });

      setState(() {
        breedsFound = _breedsFound;
      });

      return;
    }

    setState(() {
      breedsFound = [];
    });
  }

  @override
  void initState() {
    super.initState();
    widget.pet.sex = 'Masculino';
    widget.pet.breed = null;
    widget.pet.birthdate = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreatePetBloc>()..add(GetBreedsBySpecies(widget.pet.species ?? '')),
      child: _petInformationLayoutWidget(context)
    );
  }

  Widget _petInformationLayoutWidget(BuildContext context) {
    return BlocConsumer<CreatePetBloc, CreatePetState>(
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
                child: _petInformationBodyWidget(context),
              ),
            ),
          ),
        );
      }, 
      listener: (context, state) {
        if (state is BreedsLoaded) {
          setState(() {
            breeds = state.breeds;
            _loadingBreeds = false;
          });

          if (_searchBreedController.text.isNotEmpty) {
            _onSearchBreeds(_searchBreedController.text);
          }
        }
        if (state is GetBreedsProcessing) {
          setState(() {
            _loadingBreeds = true;
          });
        }
      },
    );
  }

  Widget _petInformationBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _petInformationProgressWidget(context),
        _petInformationGenrerSelectWidget(context),
        SizedBox(height: 5),
        _petInformationFormularyWidget(context),
      ],
    );
  }

  Widget _petInformationProgressWidget(BuildContext context) {
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
                    value: 0.60,
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

  Widget _petInformationGenrerSelectWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '¿Cuál es el sexo de tu mascota?',
                  style: TextStyle(
                    color: Color(0xFF6F7177),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _petSex = 'Masculino';
                    });
                  }, 
                  child: Card(
                    color: _petSex == 'Masculino' ? Color(0xFF00B6E6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              _petSex == 'Masculino' ? 'assets/img/male-icon-white.png' : 'assets/img/male-icon.png',
                              fit: BoxFit.cover,
                              width: 25,
                            ),
                          ),
                          Expanded(
                            child:  Text(
                              'Macho',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _petSex == 'Masculino' ? Colors.white : Color(0xFF00B6E6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
              SizedBox(width: 20),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _petSex = 'Femenino';
                    });
                  }, 
                  child: Card(
                    color: _petSex == 'Femenino' ? Color(0xFF00B6E6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              _petSex == 'Femenino' ? 'assets/img/female-icon-white.png' : 'assets/img/female-icon.png',
                              fit: BoxFit.cover,
                              width: 20,
                            ),
                          ),
                          Expanded(
                            child:  Text(
                              'Hembra',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _petSex == 'Femenino' ? Colors.white : Color(0xFF00B6E6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

  Widget _petInformationFormularyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _petInformationNameFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: _petInformationRaceFieldWidget(context),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: _petInformationDatePickerWidget(context),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            children: <Widget>[
              Expanded(
                child: _petInformationButtonWidget(context),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _petInformationNameFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldDark(
                inputKey: _petNameFormKey,
                controller: _petNameController,
                hintText: '¿Cómo se llama tu mascota?', 
                onChanged: (String? value) => _onPetNameChanged(value!),
                validator: (String? value) => _petNameValidator(value!),
                fillColor: Color(0xFF10172F),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _petInformationRaceFieldWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    builder: (context) => _beedsSheetMenuWidget(context)
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF10172F),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.pet.breed ?? 'Raza',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Color(0xFF00B6E6),
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

  Widget _beedsSheetMenuWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _breedsSearchFieldWidget(context),
        _otherPetsListWidget(context),
      ],
    );
  }

  Widget _breedsSearchFieldWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Selecciona la raza de tu mascota',
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
                  inputKey: _searchBreedFormKey,
                  controller: _searchBreedController,
                  hintText: 'Escribe la raza', 
                  onChanged: (String? value) => _onSearchChanged(value!),
                  validator: (String? value) => _searchValidator(value!),
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

  Widget _otherPetsListWidget(BuildContext context) {
    if (_loadingBreeds) {
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
          itemCount: breedsFound.length > 0 ? breedsFound.length : breeds.length,
          itemBuilder: (BuildContext context, int index) {
            return _breedDetailsWidget(context, breedsFound.length > 0 ? breedsFound[index] : breeds[index]);
          }
        ),
      );
    }
  }

  Widget _breedDetailsWidget(BuildContext context, Breed breed) {
    return InkWell(
        onTap: () {
          setState(() {
            widget.pet.breed = breed.name!;
          });

          _validateForm();
          Navigator.of(context).pop();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.pet.breed == breed.name ? Color(0xFF00B6E6) : Color(0xFF0E1326),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              breed.name ?? '',
              style: TextStyle(
                color: widget.pet.breed == breed.name ? Color(0xFFFFFFFF) : Color(0xFF6F7177),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
      ),
    );
  }

  Widget _petInformationDatePickerWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 3, 5),
                    maxTime: DateTime.now(), 
                    onConfirm: (DateTime date) {
                      setState(() {
                        _petBirthdate = date;
                      });

                      _validateForm();
                    }, 
                    currentTime: DateTime.now(), locale: LocaleType.es,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF10172F),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _petBirthdate != null ? '${_petBirthdate?.day}/${_petBirthdate?.month}/${_petBirthdate?.year}' : 'Fecha de nacimiento',
                          style: TextStyle(
                            color: Color(0xFF6F7177),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/img/calendar-icon.png',
                          fit: BoxFit.cover,
                          width: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Si no la sabes, coloca una fecha estimada',
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _petInformationButtonWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ButtonPrimary(
                text: 'Siguiente', 
                onPressed: _validForm ? () {
                  widget.pet.name = _petNameController.text;
                  widget.pet.sex = _petSex;
                  widget.pet.birthdate = _petBirthdate;

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CareProgram(widget.pet)),
                  );
                } : () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _petInformationModalValidFormWidget(context);
                    }
                  );
                }, 
                width: MediaQuery.of(context).size.width, 
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _petInformationModalValidFormWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 280),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.redAccent,
              ),
              SizedBox(height: 20),
              Text(
                'Debes completar todos los campos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Es obligatorio que completes todos los campos para poder crear tu mascota',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              ButtonPrimary(
                text: 'Cerrar', 
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

  void _onPetNameChanged(String value) {
    setState(() {
      _petNameFormKey.currentState?.validate();
      _validateForm();
    });
  }

  String? _petNameValidator(String value) {
    return _petNameController.text.trimLeft().length == 0
        ? "Debe ingresar el nombre de la mascota"
        : null;
  }

  void _validateForm() {
    _validForm = 
      (_petNameFormKey.currentState?.isValid ?? false) &&
      (widget.pet.breed != null) &&
      (_petSex != null) &&
      (_petBirthdate != null);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchBreedFormKey.currentState?.validate();
    });
    _onSearchBreeds(_searchBreedController.text.trim());
  }

  String? _searchValidator(String value) {
    return null;
  }
}