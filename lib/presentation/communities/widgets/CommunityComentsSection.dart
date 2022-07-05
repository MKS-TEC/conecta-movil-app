import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conecta/infrastructure/communitites/communitites_facade.dart';
import 'package:conecta/models/CommunityComment.dart';
import 'package:conecta/models/CommunityPost.dart';
import 'package:conecta/presentation/communities/widgets/CommunityCommentCard.dart';
import 'package:conecta/presentation/common/themeColors.dart';

/// Sección de comentarios en la vista de la publicación
class CommunityComentsSection extends StatefulWidget {
  final CommunityPostModel post;
  final String avatar;
  final String aliadoId;
  final String nombre;
  const CommunityComentsSection({Key? key, required this.post, required this.avatar, required this.aliadoId, required this.nombre}) : super(key: key);

  @override
  _CommunityComentsSectionState createState() => _CommunityComentsSectionState();
}

class _CommunityComentsSectionState extends State<CommunityComentsSection> {
  
  CommunityFacade communityServices = CommunityFacade();
  String commentValue = "";

  @override
  Widget build(BuildContext context) {
    

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage( 
                    image: NetworkImage(
                      widget.avatar
                    ), 
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(100.0)
                ),
                height: 45.0,
                width: 45.0,
              ),
              Container(
                width: 200,
                height: 70.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: textColor.withOpacity(0.2),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  maxLines: 4,
                  validator: (val) => val!.isEmpty
                    ? "Escribe un comentario"
                    : null,
                  onChanged: (val) => commentValue = val ,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    labelStyle: TextStyle(
                      color: textColor,
                    ),
                    hintText: 'Escribe un comentario',
                    hintStyle: TextStyle(
                      fontSize: 16.0, 
                      color: textColor.withOpacity(0.4)
                    ),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )
                  ),
                ),
              ),
              FlatButton(
                // shape: ShapeBorder.lerp(a, b, t),
                onPressed: () {
                  checkCommentUpload();
                },
                minWidth: 40.0,
                height: 50.0,
                color: commentValue != "" ? Color(0xFF00B6E6) : textColor.withOpacity(0.2),
                child: Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                  size: 15.0
                ),
              ),
            ],
          )
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: StreamBuilder(
            stream: communityServices.getPostComments(widget.post),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.length == 0){
                return Center(
                  child: Text(
                    'Aún no hay comentarios en esta publicación',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17.0
                    )
                  )
                );
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i){
                  CommunityCommentModel post = CommunityCommentModel.fromJson(snapshot.data!.docs[i].data());
                  return CommunityCommentCard(context, post);
                },
              );
            }
          ),
        ),
      ],
    );
  
  }

  Future checkCommentUpload() async{
    if(commentValue != ""){
      await communityServices.postCommentInCommunity(widget.post, commentValue, widget.aliadoId, widget.nombre, widget.avatar);
      setState(() {
        commentValue = "";
      });
    }
  }

}