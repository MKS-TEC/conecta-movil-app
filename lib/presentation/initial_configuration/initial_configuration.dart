import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/initial_configuration/selected_pet_type.dart';

class InitialConfiguration extends StatefulWidget {
  InitialConfiguration({Key? key}) : super(key: key);

  @override
  State<InitialConfiguration> createState() => _InitialConfigurationState();
}

class _InitialConfigurationState extends State<InitialConfiguration> {

  final List<String> _words = ["Salud", "Bienestar", "Nutrición", "Automóviles", "Actualidad", "Mascotas"];

  @override
  Widget build(BuildContext context) {
    return _initialConfigurationLayoutWidget(context);
  }

  Widget _initialConfigurationLayoutWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04091D),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color(0xFF04091D),
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _initialConfigurationBodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _initialConfigurationBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _initialConfigurationLogoWidget(context),
        _initialConfigurationTitleWidget(context),
        _initialConfigurationOptionsWidget(context),
        _initialConfigurationButtonWidget(context),
      ],
    );
  }

  Widget _initialConfigurationLogoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/img/priority-pet-logo.png',
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _initialConfigurationTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(
        'Indica una o más categorías que te interesen',
        style: TextStyle(
          color: Color(0xFFE0E0E3),
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _initialConfigurationOptionsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: MediaQuery.of(context).size.height - 350,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 2
        ),
        itemCount: _words.length,
        itemBuilder: (BuildContext context, int index) {
          return _initialConfigurationWordWidget(context, _words[index], index);
        }, 
      ),
    );
  }

  Widget _initialConfigurationWordWidget(BuildContext context, word, index){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // color: Color(0xFFFFFFFF),
        color: Color(0xFF0E1326),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Text(
            word,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFFFF)
            )
          ),
          GestureDetector(
            onTap: (){},
            child: Icon(
              Icons.close,
              color: Color(0xFFFFFFFF)
            )
          )
        ]
      ),
    );
  }

  Widget _initialConfigurationButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: ButtonPrimary(
        text: 'Todo listo para comenzar', 
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Dashboard())
          );
        },
        width: MediaQuery.of(context).size.width, 
        fontSize: 18,
      ),
    );
  }

}