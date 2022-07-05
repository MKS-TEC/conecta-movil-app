import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/communities/communitie_profile.dart';

/// Tarjeta preview de la comunidad en el feed o recomendados del usuario
// ignore: non_constant_identifier_names
Widget CommunityCard(context, CommunityModel community, double cardHeight){

  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  User? user = FirebaseAuth.instance.currentUser;

  return (
    GestureDetector(
      onTap: (){
        Navigator.push( context, MaterialPageRoute(builder: (context) => CommunityPage(community: community) )); 
      },
      child: Container(
        width: width,
        height: cardHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(community.urlImagen),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white
        ),
        child: Stack(
          children: [
            
            Positioned(
              left: 0,
              top: 0,
              width: width - 40,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.0),
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor
                    ],
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 2),
                                  child: Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  community.miembros.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ]
                            ),
                          ),
                          Container(
                            child: Text(
                              "Ver más",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    Container(
                      child: Text(
                        community.titulo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),

                  ],
                ),
              ),
            )

          ],
        )
      ),
    )
  );
}