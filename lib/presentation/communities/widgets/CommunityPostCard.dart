import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/models/CommunityPost.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/communities/community_post.dart';

/// Tarjeta del preview de la publicación en el feed del usuario o en la comunidad
// ignore: non_constant_identifier_names

class CommunityPostCard extends StatefulWidget {
  final CommunityPostModel post;
  const CommunityPostCard(BuildContext context, {Key? key, required this.post}) : super(key: key);

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {

  final communityServices = CommunityFacade();
  bool likedPost = false;

  @override
  void initState() {
    communityServices.likedPost(widget.post).then((value)=>{
      setState((){
        likedPost = value;
      }),
      print(value)
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    double cardHeight = 300;

      
    return (
      GestureDetector(
        onTap: (){
          Navigator.push( context, MaterialPageRoute(builder: (context) => CommunityPostPage(post: widget.post) )); 
        },
        child: Container(
          width: width,
          height: cardHeight,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            // border: Border(
            //   bottom: BorderSide(width: 1.0, color: Colors.black26),
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(

                children: [

                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Comunidades').doc(widget.post.comunidadId).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){
                        return Text("...");
                      }else{
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                image: DecorationImage( 
                                  image: NetworkImage(
                                    "snapshot.data['urlImagen']"
                                  ), 
                                  fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(100.0)
                              ),
                              height: 45.0,
                              width: 45.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'snapshot.data["titulo"]',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
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
                              ]
                            )
                          ],
                        );
                      }  
                    }
                  )
                ],
              ),
              widget.post.urlImagen == "" ? SizedBox() : Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  image: DecorationImage( 
                    image: NetworkImage(
                      widget.post.urlImagen
                    ), 
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                height: 120.0,
                width: double.infinity,
              ),
              Text(
                widget.post.titulo,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
                ),
              ),
              Text(
                widget.post.descripcion,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: primaryColor.withOpacity(0.2)
                    ),
                    child: Text(
                      "Ver más",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 13
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.post.likes.toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        likedPost ? Icons.favorite : Icons.favorite_border,
                        size: 22,
                        color: primaryColor
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}