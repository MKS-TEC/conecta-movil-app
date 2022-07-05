import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';

class MarketPlace extends StatefulWidget {
  MarketPlace({Key? key}) : super(key: key);

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  final GlobalKey<FormFieldState> _searchFormKey =
      GlobalKey<FormFieldState>();
  TextEditingController _searchController = TextEditingController();
  List<int> _products = <int>[1, 2, 3, 4];
  List<int> _services = <int>[1, 2, 3, 4];
  List<int> _veterinarians = <int>[1, 2, 3, 4];
  List<int> _promotions = <int>[1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return _marketPlaceLayoutWidget(context);
  }

  Widget _marketPlaceLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _marketPlaceBodyWidget(context),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _marketPlaceBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _marketPlaceBackButtonWidget(context),
        _marketPlaceSearchFieldWidget(context),
        _marketPlacePromotionWidget(context),
        _marketPlaceProductsWidget(context),
        _marketPlaceServicesWidget(context),
        _marketPlaceVeterinariansWidget(context),
        _marketPlacePromotionsWidget(context),
      ],
    );
  }

  Widget _marketPlaceBackButtonWidget(BuildContext context) {
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
                  'Marketplace',
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

  Widget _marketPlaceSearchFieldWidget(BuildContext context) {
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

  Widget _marketPlacePromotionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Promoción del mes',
                  style: TextStyle(
                    color: Color(0xFFE0E0E3),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                                'Producto o servicio',
                                style: TextStyle(
                                  color: Color(0xFFE0E0E3),
                                  fontSize: 16,
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

  Widget _marketPlaceProductsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Productos',
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
              itemCount: _products.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _marketPlaceProductDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketPlaceProductDetailWidget(BuildContext context) {
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

  Widget _marketPlaceServicesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Servicios',
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
              itemCount: _services.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _marketPlaceServiceDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketPlaceServiceDetailWidget(BuildContext context) {
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

  Widget _marketPlaceVeterinariansWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Veterinarios',
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
              itemCount: _veterinarians.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _marketPlaceVeterinarianDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketPlaceVeterinarianDetailWidget(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
    );
  }

  Widget _marketPlacePromotionsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Promociones',
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
              itemCount: _promotions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: _marketPlacePromotionDetailWidget(context),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketPlacePromotionDetailWidget(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFE2E3E5),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchFormKey.currentState?.validate();
    });
  }

  String? _searchValidator(String value) {
    return null;
  }
}