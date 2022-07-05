import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conecta/presentation/club/club.dart';
import 'package:conecta/presentation/common/buttons/button_primary.dart';
import 'package:conecta/presentation/dashboard/dashboard.dart';
import 'package:conecta/presentation/market_place/market_place.dart';
import 'package:conecta/presentation/owner/owner_profile.dart';
class BottomNavBar extends StatelessWidget {
  
  final int currentIndex;
  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                "assets/svg/home.svg",
                width: 25,
                semanticsLabel: 'home icon',
              ),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                "assets/svg/pet.svg",
                width: 25,
                semanticsLabel: 'pet icon',
              ),
            ),
            label: 'Comunidad',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                "assets/svg/crown.svg",
                width: 25,
                semanticsLabel: 'crown icon',
              ),
            ),
            label: 'Club',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                "assets/svg/market.svg",
                width: 25,
                semanticsLabel: 'market icon',
              ),
            ),
            label: 'Marketplace',
          ),
        ],
        currentIndex: currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Color(0xFF0E1326),
        selectedItemColor: Color(0xFFE0E0E3),
        selectedLabelStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard()), 
                (Route<dynamic> route) => false
              );
              break;
            case 1:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _bottomNavigationScreenCloseWidget(context);
                }
              );
              break;
            case 2:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _bottomNavigationScreenCloseWidget(context);
                }
              );
              break;
            case 3:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _bottomNavigationScreenCloseWidget(context);
                }
              );
              break;
            default:
          }
        },
      ),
    );
  }

  Widget _bottomNavigationScreenCloseWidget(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 225),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Próximamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE0E0E3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Nos estamos preparando para ofrecerte esto en futuras versiones. Te tendrémos informado sobre nuestras próximas actualizaciones.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6F7177),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              ButtonPrimary(
                text: 'De acuerdo, gracias', 
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
}
