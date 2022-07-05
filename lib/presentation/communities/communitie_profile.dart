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
import 'package:conecta/presentation/communities/widgets/CommunityPostCard.dart';

class CommunityPage extends StatefulWidget {

  final CommunityModel community;
  CommunityPage({Key? key, required this.community}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityState();
}

class _CommunityState extends State<CommunityPage> {

  final communityServices = CommunityFacade();
  bool joinedCommunity = false;
  
  // ignore: non_constant_identifier_names
  Widget CoverOverlayButton(context, IconData customIcon) {
    return(
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: primaryColor.withOpacity(0.6)
          ),
          child: Icon(
            customIcon,
            color: Colors.white
          )
        ),
      )
    );
  }

  
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
                  widget.community.titulo,
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
    setState(() {
      communityServices.existInCommunity(widget.community).then((value) => {
        joinedCommunity = value
      });
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
          statusBarColor: Color(0xFF0E1326),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Column(
            children:[
              _communitiesBackButtonWidget(context),
              Container(
                height: height - 170,
                child: ListView(
                  children: [
                    Container(
                      width: width,
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.community.urlImagen),
                          fit: BoxFit.cover
                        ),
                        color: Colors.white
                      ),
                      child: Stack(
                        children: [
                        
                          Positioned(
                            left: 0,
                            top: 0,
                            width: width,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15.0),
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    primaryColor.withOpacity(0.45),
                                    primaryColor.withOpacity(0.0)
                                  ],
                                )
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // CoverOverlayButton(context, Icons.arrow_back),
                                  // CoverOverlayButton(context, Icons.search),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        widget.community.titulo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Comunidades").doc(widget.community.comunidadId).snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData){
                                return Text("0");
                              }else{
                                return Text(
                                  // snapshot.data["miembros"].length.toString(),
                                  "0",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                  ),
                                );
                              }  
                            }
                          ),
                          SizedBox(
                            width: 10
                          ),
                          Text(
                            "Miembros",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 17,
                            ),
                          )
                        ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPressed: () {
                          checkingCommunity();
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        height: 55.0,
                        color: Color(0xFF00B6E6),
                        child: Text(
                          joinedCommunity ? "Salir de la comunidad" : "Unirse a la comunidad",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Product Sans',
                            fontSize: 18.0
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        widget.community.descripcion,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black87
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Publicaciones",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 17,
                          fontWeight: FontWeight.w400
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder(
                        stream: communityServices.getCommunityPosts(widget.community),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData || snapshot.data!.docs.length == 0){
                            return Center(
                              child: Text(
                                'Aún no hay publicaciones de este grupo',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17.0
                                )
                              )
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i){
                              CommunityPostModel post = CommunityPostModel.fromJson(snapshot.data!.docs[i].data());
                              return CommunityPostCard(context, post: post);
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
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

  Future checkingCommunity() async{
    setState(() {
      joinedCommunity = !joinedCommunity;
    });
    Future.delayed(const Duration(milliseconds: 500), () async{
      if(joinedCommunity){
        // dialogWidget(context, "Te has unido a ${widget.community.titulo}", Icons.check_circle_outline_outlined, Colors.green);
        await communityServices.joinCommunity(widget.community);
      }else{
        // dialogWidget(context, "Ya no formas parte de ${widget.community.titulo}", Icons.cancel_outlined, Colors.red);
        await communityServices.removeFromCommunity(widget.community);
      }
    });
    
  }
    
}