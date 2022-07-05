import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';

class Club extends StatefulWidget {
  Club({Key? key}) : super(key: key);

  @override
  State<Club> createState() => _ClubState();
}

class _ClubState extends State<Club> {
  final GlobalKey<FormFieldState> _searchFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _searchController = TextEditingController();
  List<int> _petFriendly = <int>[1, 2, 3, 4];
  List<int> _nextEvents = <int>[1, 2, 3, 4];
  List<int> _adoptions = <int>[1, 2, 3, 4];
  List<int> _petsLost = <int>[1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return _clubLayoutWidget(context);
  }

  Widget _clubLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _clubBodyWidget(context),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _clubBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _clubBackButtonWidget(context),
        _clubSearchFieldWidget(context),
        _clubWhatsTodayWidget(context),
        _clubPetFriendlyWidget(context),
        _clubNextEventsWidget(context),
        _clubAdoptionWidget(context),
        _clubPetsLostWidget(context),
      ],
    );
  }

  Widget _clubBackButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    Icons.chevron_left,
                    color: Color(0xFF00B6E6),
                    size: 45,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Club de beneficios',
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
        ],
      ),
    ); 
  }

  Widget _clubSearchFieldWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFieldDark(
                  inputKey: _searchFormKey,
                  controller: _searchController,
                  hintText: '¿Qué necesita tu mascota?', 
                  onChanged: (value) => _onSearchChanged(value!),
                  validator: (value) => _searchValidator(value!),
                  icon: Icons.search,
                  isSuffixIcon: false,
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF00B6E6),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.tune,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _clubWhatsTodayWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Qué hay hoy',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
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
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E3E5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.photo,
                        size: 80,
                        color: Color(0xFF6F7177),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Vacunación',
                                style: TextStyle(
                                  color: Color(0xFFE0E0E3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Descripción del programa',
                                style: TextStyle(
                                  color: Color(0xFF6F7177),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _clubPetFriendlyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Pet friendly',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 136,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _petFriendly.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _clubPetFriendlyDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _clubPetFriendlyDetailWidget(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    );
  }

  Widget _clubNextEventsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Próximos eventos',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 136,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _nextEvents.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _clubNextEventDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _clubNextEventDetailWidget(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    );
  }

  Widget _clubAdoptionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Adopción y padrinaje',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 90,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _adoptions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _clubAdoptionDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _clubAdoptionDetailWidget(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }

  Widget _clubPetsLostWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Mascotas extraviadas',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 90,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _petsLost.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _clubPetLostDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _clubPetLostDetailWidget(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }

  void _onSearchChanged(String? value) {
    setState(() {
      _searchFormKey.currentState?.validate();
    });
  }

  String? _searchValidator(String value) {
    return null;
  }
}