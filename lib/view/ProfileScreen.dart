import 'package:flutter/material.dart';
import 'package:project_1/model/profiles.dart';
import 'package:project_1/view-model/controllers/ProfileController.dart';
import 'package:get/get.dart';
import 'package:project_1/view/PostScreen.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController(),permanent: false);
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TESTFLIX",style: TextStyle(color: Colors.red),),
      ),
      body: Obx(()=>(controller.progress!.value)?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(()=>GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            mainAxisSpacing: 10.0
          ),
              itemCount: controller.profiles.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context,int index){
            return Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    color: Colors.blue,
                    child: InkWell(
                      onTap: (){
                        Get.to(()=>PostScreen(userIn: controller.profiles[index].title,));
                      },
                      child: Center(
                        child: Text(controller.profiles[index].title![0]+((controller.profiles[index].title!.contains(" "))?controller.profiles[index].title!.split(" ").last:""),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
                Text(controller.profiles[index].title,style: TextStyle(color: Colors.white),)
              ],
            );
          }),
            ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)),border: Border.all(color: Colors.white)),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_box_outlined,color: Colors.white,),
                  SizedBox(width: 5,),
                  Text("Add Profile",style: TextStyle(color: Colors.white),),
                ],
              ),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context){
                  return Dialog(
                    child: Wrap(
                      children:  [
                        const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child:  Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Enter Profile Name",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                         Padding(
                          padding:  const EdgeInsets.all(8.0),
                          child:  TextField(
                            controller: name,),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)),border: Border.all(color: Colors.white)),
                              child: TextButton(
                                onPressed: () async {
                                  setState(() {
                                    controller.newProf.value = name.text;
                                    controller.profiles.add(Profiles(title: controller.newProf.value));
                                  });
                                  await Profiles(title: controller.newProf.value).userData(controller.newProf.value).whenComplete((){
                                    Get.back();
                                  });

                                }, child: const Center(child: Text("SUBMIT",style: TextStyle(color: Colors.white),),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              },),
          )
        ],
      ):Center(child: CircularProgressIndicator(),),
      )
    );
  }
}
