import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conecta/models/CommunityComment.dart';

/// Tarjeta de comentario de la publicación en la comunidad
// ignore: non_constant_identifier_names
Widget CommunityCommentCard(context, CommunityCommentModel comment){

  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  User? user = FirebaseAuth.instance.currentUser;
  double cardHeight = 300;

  return (
    Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage( 
                image: NetworkImage(
                  comment.userPhoto
                ), 
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(100.0)
            ),
            height: 45.0,
            width: 45.0,
          ),
          SizedBox(
            width: 15.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                width: 240,
                child: Text(
                  comment.username,
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 240,
                child: Text(
                  comment.comment,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                  ),
                ),
              ),
              Text(
                "Hace un momento",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 13
                ),
              )
            ],
          )
        ],
      )
    )
  );
}