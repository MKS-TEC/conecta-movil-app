import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo del comentario en una publicación de la comunidad
class CommunityCommentModel{
  late String commentId;
  late String creatorId;
  late String communityId;
  late String postId;
  late String comment;
  late String typeCreator;
  late String username;
  late String userPhoto;
  late Timestamp createdOn;
  

  CommunityCommentModel({
    required this.commentId,
    required this.creatorId,
    required this.communityId,
    required this.postId,
    required this.comment,
    required this.typeCreator,
    required this.username,
    required this.userPhoto,
    required this.createdOn,
    
  });

  CommunityCommentModel.fromJson(Map<String, dynamic> json){
    commentId = json['commentId'];
    creatorId = json['creatorId'];
    communityId = json['communityId'];
    postId = json['postId'];
    comment = json['comment'];
    typeCreator = json['typeCreator'];
    username = json['username'];
    userPhoto = json['userPhoto'];
    createdOn = json['createdOn'];
    
    
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['creatorId'] = this.creatorId;
    data['communityId'] = this.communityId;
    data['postId'] = this.postId;
    data['comment'] = this.comment;
    data['typeCreator'] = this.typeCreator;
    data['username'] = this.username;
    data['userPhoto'] = this.userPhoto;
    data['createdOn'] = this.createdOn;
    

    return data;
  }
}