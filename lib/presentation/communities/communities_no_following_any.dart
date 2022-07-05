import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/presentation/common/themeColors.dart';
import 'package:conecta/presentation/communities/widgets/CommunityCard.dart';

class CommunitiesNoFollowing extends StatefulWidget {
  CommunitiesNoFollowing({Key? key}) : super(key: key);

  @override
  State<CommunitiesNoFollowing> createState() => _CommunitiesNoFollowingState();
}

class _CommunitiesNoFollowingState extends State<CommunitiesNoFollowing> {
  
  bool loading = false;
  bool followingGroups = false;
  List<CommunityModel> communitiesList = [];
  CommunityFacade communityFacade = CommunityFacade();
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    filterAllCommunities();
    super.initState();  
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Algunas comunidades para ti",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: primaryColor,
              // color: secondaryColor,
              // color: primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w800
            ),
          )
        ),
        loading ? Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Center(child: CircularProgressIndicator()),
        ) : Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(bottom: 20.0),
          // height: 135.0,
          child: ListView.builder(
            itemCount: communitiesList.length,
            shrinkWrap: true,
            // scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i){
              return Container(
                margin: EdgeInsets.only(bottom: 15.0), 
                child: CommunityCard(context, communitiesList[i], 135)
              );
            },
          )
        )
      ],
    );
  }

  Future filterAllCommunities() async{

    QuerySnapshot userPets = await FirebaseFirestore.instance.collection("Mascotas")
    .where("uid", isEqualTo: 
    // user.uid
    "xEffHfxqx7YlLRNpNzIpjoshowH3"
    ).get();
    
    setState(() {
        loading = true;  
    });

    if(userPets.docs.length > 0){
      
      userPets.docs.forEach((pet)async{
        

        Map<String,String> petData = {
          // "raza": "Cocker spaniel americano",
          "especie": pet["especie"], 
          // "sexo": "Macho"
        };
        
        List<CommunityModel> listC = await communityFacade.getCommunitiesFiltered(petData);
        print(listC);
        setState((){
          communitiesList = listC;
          loading = false;
        });

      });

    }else{

      communityFacade.getCommunitiesWithoutPet().then((value) => {
        setState((){
          Future.delayed(const Duration(milliseconds: 500), () {
            print(value);
            communitiesList = value;
          });
        }),
      });

      setState(() {
        loading = false;
      });

    }

  }

}