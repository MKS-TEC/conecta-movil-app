import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/models/CommunityPost.dart';
import 'package:conecta/presentation/common/appbar/appbar_default.dart';
import 'package:conecta/presentation/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/communities/communities_no_following_any.dart';
import 'package:conecta/presentation/communities/widgets/CommunityCard.dart';
import 'package:conecta/presentation/communities/widgets/CommunityPostCard.dart';
import 'package:conecta/presentation/dashboard/dashboard_day_activity.dart';
import 'package:conecta/presentation/dashboard/dashboard_policies.dart';
import 'package:conecta/presentation/dashboard/dashboard_programs.dart';

class CommunitiesFollowing extends StatefulWidget {
  CommunitiesFollowing({Key? key}) : super(key: key);

  @override
  State<CommunitiesFollowing> createState() => _CommunitiesFollowingState();
}

class _CommunitiesFollowingState extends State<CommunitiesFollowing> {
  List<String> _views = <String>[
    'Siguiendo',
    'Para ti'
  ];
  List<dynamic> following = [];
  List<CommunityModel> communitiesList = [];
  CommunityFacade communityServices = CommunityFacade();
  bool loading = false;

  int _viewSelected = 0;

  @override
  void initState() {
    
    FirebaseFirestore.instance.collection("Dueños").doc(
      //user!.uid
      "xEffHfxqx7YlLRNpNzIpjoshowH3"
    ).get()
    .then((DocumentSnapshot doc)=>{
      print(doc["following"]),
      following = doc["following"]
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _dashboardBodyWidget(context);
  }

  Widget _getCommunities(BuildContext context) {
    switch (_viewSelected) {
      case 0:
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(bottom: 20.0),
              // height: 135.0,
              child: CarouselSlider.builder(
                itemCount: communitiesList.length,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  initialPage: 0,
                ),
                // shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i, int pageViewIndex){
                  return CommunityCard(context, communitiesList[i], 160);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Siguiendo",
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: communityServices.getUserFeed( 
                  following
                ),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.length == 0){
                    return Center(
                      child: Text(
                        'No sigues comunidades aún',
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
          ]
        );
      case 1:
        return CommunitiesNoFollowing();
      default:
        return Container();
    }
  }

  Widget _dashboardBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _communitiesViewsOptionsWidget(context),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: _getCommunities(context),
        ),
      ],
    );
  }

  Widget _communitiesViewsOptionsWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 65,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: _views.length,
        itemBuilder: (BuildContext context, int index) {
          return _communitiesViewDetail(context, _views[index], index);
        }
      ),
    );
  }

  Widget _communitiesViewDetail(BuildContext context, String view, int index) {
    return InkWell(
        onTap: () {
          setState(() {
            _viewSelected = index;
          });
        },
        child: Container(
        width: 150,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _viewSelected == index ? Color(0xFF00B6E6) : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          view,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _viewSelected == index ? Color(0xFF0E1326) : Color(0xFF8C939B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future filterAllCommunities() async{

    QuerySnapshot userPets = await FirebaseFirestore.instance.collection("Mascotas")
    .where("uid", isEqualTo: 
    // user.uid
    "xEffHfxqx7YlLRNpNzIpjoshowH3"
    ).get();
    
    if(userPets.docs.length > 0){
      
      userPets.docs.forEach((pet){

        Map<String,String> petData = {
          // "raza": "Cocker spaniel americano",
          "especie": pet["especie"], 
          // "sexo": "Macho"
        };

        communityServices.getCommunitiesFiltered(petData).then((value) => {
          value.forEach((com)=>{ 
            setState((){
              communitiesList.add(com);
            })
          })
        });
        
        setState(() {
          loading = false;
        });

      });

    }else{

      communityServices.getCommunitiesWithoutPet().then((value) => {
        setState((){
          communitiesList = value;
        })
      });

      setState(() {
        loading = false;
      });

    }

  }

}