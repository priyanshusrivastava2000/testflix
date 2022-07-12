import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:project_1/model/adminFeed.dart';
import 'package:project_1/model/profiles.dart';

class PostController extends GetxController{
 final profileIn = "".obs;
 final uploaded = false.obs;
 final fetched = false.obs;
 RxList<dynamic>? profiles = [].obs;
 RxList<dynamic> posts = [].obs;
 Future<RxBool> uploadPic(user,imgPath,header)async{
  FirebaseStorage storage = FirebaseStorage.instance;
  final reference = storage.ref().child(user+'/'+'image$header');
  try{
   File file = File(imgPath);
   await reference.putFile(file);
   uploaded.value = true;
  }
  catch(e){
   print(e);
  }
  return uploaded;
 }
 RxInt? length = 0.obs;
 Future<dynamic> getPosts(user)async{
  final storageRef = FirebaseStorage.instance.ref().child(user+'/');
  final listResult = await storageRef.listAll();
  for (var item in listResult.items) {
   var url = await item.getDownloadURL();
   posts.add(AdminFeed(url: url,postedBy: user));
  }
  length!.value = posts.length;
 }

 Future<dynamic> adminFetch()async{
  posts.clear();
   await gettingProfiles();
   profiles!.forEach((element) {
     getPosts(element.title);
   });
 }

 Future<RxList?> gettingProfiles()async{
  try{
   final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").get();
   final List<DocumentSnapshot> documents = snapshot.docs;
   documents.forEach((element) {
    profiles!.add(Profiles(title: element["name"]));
   });

  }
  catch(e){
   print(e);
  }
  return profiles;
 }
}