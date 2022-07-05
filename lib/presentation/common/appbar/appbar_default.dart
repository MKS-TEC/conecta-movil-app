import 'package:flutter/material.dart';

class AppBarDefault extends StatelessWidget {
  const AppBarDefault({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF0E1326),
      elevation: 0,
      toolbarHeight: 130,
      centerTitle: false,
      title: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Hola',
              style: TextStyle(
                color: Color(0xFFE0E0E3),
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 3),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Joseph Huizi',
              style: TextStyle(
                color: Color(0xFFE0E0E3),
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 3),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Ten un bonito día',
              style: TextStyle(
                color: Color(0xFF6F7177),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Color(0xFF00B6E6),
          ),
          tooltip: 'Notificaciones',
          onPressed: () {
          
          },
        ),
      ],
    );
  }
}