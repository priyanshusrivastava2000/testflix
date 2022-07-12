import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_1/model/profiles.dart';

class ProfileController extends GetxController{
  final profiles = [].obs;
  RxBool? progress = false.obs;
  final newProf = "Name".obs;
  @override
  void onInit() {
    gettingProfiles().whenComplete((){
      progress!.value = true;
    });
    super.onInit();
  }

  Future<RxList> gettingProfiles()async{
    try{
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").get();
      final List<DocumentSnapshot> documents = snapshot.docs;
      documents.forEach((element) {
        profiles.add(Profiles(title: element["name"]));
      });

    }
    catch(e){
     print(e);
    }
    return profiles;
  }
}