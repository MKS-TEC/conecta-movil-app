import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:conecta/models/Community.dart';
import 'package:conecta/models/CommunityPost.dart';
import 'package:conecta/models/CommunityComment.dart';
import 'dart:convert';
import 'dart:async';

String user = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : "";

/// Todos los servicios requeridos para la interacción y funciones de la comnunidad
class CommunityFacade{
  
  final userData = {
    "tipoUsuario": "Dueño",
    "uid": user
  };
  
  /// Obtiene todas las comunidades
  Stream<QuerySnapshot> getCommunities() async*{
    try{
      yield* FirebaseFirestore.instance.collection('Comunidades').snapshots();
    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }

  /// Obtener las comunidades filtradas
  Future<List<CommunityModel>> getCommunitiesWithoutPet() async{
    List<CommunityModel> list = [];
    try{


      Query communitys = FirebaseFirestore.instance.collection('Comunidades');
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Dueños").doc(
        //user!.uid
        "xEffHfxqx7YlLRNpNzIpjoshowH3"
      ).get();

      Stream<QuerySnapshot> result = communitys.snapshots();

      result.forEach((element)=>{
        element.docs.forEach((doc){
          CommunityModel community = CommunityModel.fromJson(doc.data());
          userDoc["siguiendo"].contains(community.comunidadId) ? print("Already following ${community.titulo}") : list.add(community);
        })
      });


    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
    return list;
  }

  /// Obtener las comunidades filtradas
  Future<List<CommunityModel>> getCommunitiesFiltered(Map<String,String> value) async{
    
    List<CommunityModel> list = [];
    
    Query communitys = FirebaseFirestore.instance.collection('Comunidades');
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Dueños").doc(
      //user!.uid
      "xEffHfxqx7YlLRNpNzIpjoshowH3"
    ).get();

    value.forEach((key, value){ 
      communitys = communitys.where("features.$key", isEqualTo: value);
    });
    
    Stream<QuerySnapshot> result = communitys.snapshots();
    
    result.forEach((element)=>{
      element.docs.forEach((doc){
    
        CommunityModel community = CommunityModel.fromJson(doc.data());

        if(userDoc.data()!.containsKey("siguiendo")){
          userDoc["siguiendo"].contains(community.comunidadId) ? print("Already following ${community.titulo}") : list.add(community);
          print("Following groups");
        }else{
          list.add(community);
          print("No following groups");
        }
    
      }),
    });
    
    await Future.delayed(new Duration(seconds: 1));

    return list;

  }



  /// Obtiene todas las publicaciones de las comunidades seguidas por el usuario usando
  /// la lista de seguidos como parametro
  Stream<QuerySnapshot> getUserFeed(List<dynamic> listOfCommunities) async*{
    Stream<QuerySnapshot> snap = [] as Stream<QuerySnapshot>;
    try{
      listOfCommunities.forEach((element) {
        snap = FirebaseFirestore.instance.collection("Comunidades").doc(element)
        .collection("Publicaciones").snapshots();
      });
    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
    yield* snap;
  }

  /// Verifica si el usuario ya es parte o no de la comunidad
  Future existInCommunity( CommunityModel community ) async{
    var res = false;
    var a;
    try{
      await FirebaseFirestore.instance.collection("Comunidades").doc(community.comunidadId).get()
      .then((DocumentSnapshot doc)=>{
        a = doc["miembros"].where((element)=>element == userData),
        if( a.isEmpty ){
          res = true
        }else{
          res = false
        }
      });

      return res;

    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }

  /// Hace que el usuario se una a la comunidad
  /// Afecta al documento del aliado en la colección de aliados
  Future joinCommunity( CommunityModel community ) async{
    List<dynamic> a = [];
    try{

      await FirebaseFirestore.instance.collection("Comunidades").doc(community.comunidadId).update({
        "miembros": FieldValue.arrayUnion([userData])
      });

      await FirebaseFirestore.instance.collection("Dueños").doc(
        //user!.uid
        "xEffHfxqx7YlLRNpNzIpjoshowH3"
      ).get()
      .then((DocumentSnapshot doc)=>{
        
        if(doc.data()!.containsKey("siguiendo")){
          a = doc["siguiendo"],
          a.add(community.comunidadId),
          FirebaseFirestore.instance.collection("Dueños").doc(
            //user!.uid
            "xEffHfxqx7YlLRNpNzIpjoshowH3"
          ).update({
            "siguiendo": a
          })
        }else{
          FirebaseFirestore.instance.collection("Dueños").doc(
            //user!.uid
            "xEffHfxqx7YlLRNpNzIpjoshowH3"
          ).update({
            "siguiendo": [community.comunidadId]
          })
        }

      });

    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }

  //Hace que el usuario se salga de a la comunidad
  //Afecta al documento del aliado en la colección de aliados
  Future removeFromCommunity( CommunityModel community ) async{
    List<dynamic> a = [];
    try{

      await FirebaseFirestore.instance.collection("Comunidades").doc(community.comunidadId).update({
        "miembros": FieldValue.arrayRemove([userData])
      });

      await FirebaseFirestore.instance.collection("Dueños").doc(
        //user!.uid
        "xEffHfxqx7YlLRNpNzIpjoshowH3"
      ).get()
      .then((DocumentSnapshot doc)=>{
        
        if(doc.data()!.containsKey("siguiendo")){
          a = doc["siguiendo"],
          a.remove(community.comunidadId),
          FirebaseFirestore.instance.collection("Dueños").doc(
            //user!.uid
            "xEffHfxqx7YlLRNpNzIpjoshowH3"
          ).update({
            "siguiendo": a
          })
        }

      });

    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }

  /// Obtiene todos las publicaciones de la comunidad
  Stream<QuerySnapshot> getCommunityPosts(CommunityModel community) async*{
    try{
      yield* FirebaseFirestore.instance.collection('Comunidades').doc(community.comunidadId).collection("Publicaciones").snapshots();
    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }
  
  /// Obtiene todos las publicaciones de la comunidad
  Stream<QuerySnapshot> getPostComments(CommunityPostModel post) async*{
    try{
      yield* FirebaseFirestore.instance.collection('Comunidades').doc(post.comunidadId)
      .collection("Publicaciones").doc(post.postId).collection("Comments").snapshots();
    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }
  
  /// Publicar un comentario en una publicación de la comunidad
  Future postCommentInCommunity(CommunityPostModel post, String comment, String creatorId, String username, String userPhoto) async{
    try{
      
      String id = FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
      .collection("Publicaciones").doc(post.postId).collection("Comments").doc().id;

      await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
      .collection("Publicaciones").doc(post.postId).collection("Comments").doc(id).set({
        "commentId": id,
        "communityId": post.comunidadId,
        "typeCreator": "Aliado",
        "creatorId": creatorId,
        "username": username,
        "userPhoto": userPhoto,
        "postId": post.postId,
        "comment": comment,
        "createdOn": FieldValue.serverTimestamp(),
      });

    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }
  
  /// Obtener me gustas de la publicación
  Future<dynamic> getNumberLikes(CommunityPostModel post) async{
    try{
      int number = 0;

      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
      .collection("Publicaciones").doc(post.postId).get();
      
      number = doc["likes"];
      
      return number;

    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }
  
  /// Obtener me gustas de la publicación
  Future<QuerySnapshot> checkIfLikedPost(CommunityPostModel post) async{
    Future<QuerySnapshot> docs = FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
    .collection("Publicaciones").doc(post.postId).collection("PostLikes").get();
    return docs;
  }

  /// Cambia el icono si ya indico que le gusta el post
  Future likedPost(CommunityPostModel post) async {
    var exist = false;
    await FirebaseFirestore.instance.collection('Comunidades').doc(post.comunidadId).collection("Publicaciones").doc(post.postId)
    .collection("PostLikes").doc(user).get().then((doc) {
        exist = doc.exists;
    });
    return exist;
  }

  /// Darle me gusta a una publicación de la comunidad
  Future likePostInCommunity(CommunityPostModel post, bool alreadyLiked, String creatorId, String username, String userPhoto) async{
    try{

      if(alreadyLiked){
        await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
        .collection("Publicaciones").doc(post.postId).collection("PostLikes").doc(creatorId).delete();
      
        await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
        .collection("Publicaciones").doc(post.postId).get().then((DocumentSnapshot doc)=>{
          
          FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
          .collection("Publicaciones").doc(post.postId).update({
            "likes": doc["likes"] - 1
          })

        });

      }else{
        
        await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
        .collection("Publicaciones").doc(post.postId).collection("PostLikes").doc(creatorId).set({
          "communityId": post.comunidadId,
          "typeCreator": "Aliado",
          "creatorId": creatorId,
          "username": username,
          "userPhoto": userPhoto,
          "postId": post.postId,
          "createdOn": FieldValue.serverTimestamp(),
        });
      
        await FirebaseFirestore.instance.collection("Comunidades").doc(post.comunidadId)
        .collection("Publicaciones").doc(post.postId).update({
          "likes": FieldValue.increment(1)
        });
      }


    }on FirebaseAuthException catch  (e) {
      print('Failed: ${e.code}');
      print(e.message);
    }
  }

}