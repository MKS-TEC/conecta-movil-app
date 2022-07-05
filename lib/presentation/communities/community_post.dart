import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/models/CommunityPost.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/communities/widgets/CommunityComentsSection.dart';
import 'package:conecta/presentation/communities/widgets/CommunityPostCard.dart';

class CommunityPostPage extends StatefulWidget {

  final CommunityPostModel post;
  CommunityPostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<CommunityPostPage> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPostPage> {

  int numberLikes = 0;
  bool likedPost = false;

  final communityServices = CommunityFacade();
  
  Widget _communitiesBackButtonWidget(BuildContext context) {
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
                  widget.post.titulo,
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
  
  @override
  void initState() {
    communityServices.getNumberLikes(widget.post).then((value) => {
      setState(() {
        numberLikes = value;
      })
    });
    communityServices.likedPost(widget.post).then((value)=>{
      setState((){
        likedPost = value;
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    print(height);

    return Scaffold(
      backgroundColor: Color(0xFF0E1326),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFFF7F7F7),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Column(
            children:[
              _communitiesBackButtonWidget(context),
              Container(
                height: height - 170,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      width: width,
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.post.urlImagen),
                          fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hace un momento",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("Comunidades").doc(widget.post.comunidadId)
                                  .collection("Publicaciones").doc(widget.post.postId).snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData){
                                      return Text("0");
                                    }else{
                                      return Text(
                                        "0",
                                        // snapshot.data["likes"].toString(),
                                        style: TextStyle(
                                          color: Colors.red[400],
                                          fontSize: 20
                                        ),
                                      );
                                    }  
                                  }
                                ),
                                GestureDetector(
                                  onTap: (){
                                    controllLikedPost(
                                      "dueñoid",
                                      "Joseph Huizi",
                                      "avatar",
                                      // snapshot.data["aliadoId"], 
                                      // snapshot.data["nombre"],
                                      // snapshot.data["avatar"] 
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      likedPost ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.red[400],
                                      size: 26
                                    )
                                  ),
                                )
                              ],
                            )
                          )
                        ]
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        widget.post.titulo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 23,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        widget.post.descripcion,
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black87
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Comentarios",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black38,
                          // color: secondaryColor,
                          // color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w200
                        ),
                      )
                    ),
                    CommunityComentsSection(
                      post: widget.post, 
                      avatar: 'snapshot.data["avatar"]', 
                      aliadoId: 'snapshot.data["aliadoId"]', 
                      nombre: 'snapshot.data["nombre"]'
                    )
                  ],
                )
              ),
            ]
          )
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
      ),
    );

  }

  Future controllLikedPost(creatorId, username, userPhoto) async{
    List<dynamic> listOfIds = [];
    final QuerySnapshot result = await communityServices.checkIfLikedPost(widget.post);
    listOfIds = result.docs.map((e) => e.id).toList();
    communityServices.likePostInCommunity(
      widget.post, 
      listOfIds.contains(creatorId) ? true : false, 
      creatorId, 
      username, 
      userPhoto
    );
    communityServices.likedPost(widget.post).then((value)=>{
      setState((){
        likedPost = value;
      })
    });

  }
    
}