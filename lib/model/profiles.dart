
import 'package:cloud_firestore/cloud_firestore.dart';

class Profiles{
  Profiles({
    this.title
});
  String? title;
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Future userData(String title) async{
    try{
      await users.doc(title).set({
        'name': title,
      });
    }
    catch(e){
      print(e);
    }
  }
}