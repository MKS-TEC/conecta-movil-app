import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/text_field/text_field_dark.dart';
import 'package:conecta/presentation/communities/communities_following.dart';
import 'package:conecta/presentation/communities/communities_no_following_any.dart';

class Communities extends StatefulWidget {
  Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  
  bool loading = false;
  bool followingGroups = false;
  List<CommunityModel> communitiesList = [];
  CommunityFacade? communityFacade;
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    
    checkIfFollows();
    super.initState();  
  }

  @override
  Widget build(BuildContext context) {
    
    return _communitiesLayoutWidget(context);

  }

  Future checkIfFollows() async{
  
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Dueños").doc(
      // user!.uid
      "xEffHfxqx7YlLRNpNzIpjoshowH3"
    ).get();
    List<dynamic> list = userDoc.data()!.containsKey("siguiendo") ? userDoc["siguiendo"].toList() : [];
    setState((){ 
      followingGroups = list.length > 0 ? true : false;
    });

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
                  'Comunidades',
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

  Widget _communitiesLayoutWidget(BuildContext context) {
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
              followingGroups ? CommunitiesFollowing() : CommunitiesNoFollowing()
            ]
          )
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
      ),
    );
  }

}