import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_1/view-model/controllers/PostController.dart';
import 'package:project_1/view/Camera.dart';
import 'package:project_1/view/ProfileScreen.dart';
class PostScreen extends StatefulWidget {
  const PostScreen({Key? key,required this.userIn}) : super(key: key);
  final String? userIn;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostController controller = Get.put(PostController(),permanent: false);
  @override
  void initState() {
    super.initState();
    setState(() {
      controller.profileIn.value = widget.userIn!;
      (widget.userIn == "Admin")?controller.adminFetch().whenComplete((){
        controller.fetched.value = true;
      }):controller.getPosts(widget.userIn).whenComplete((){
          controller.fetched.value = true;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TESTFLIX",style: TextStyle(color: Colors.red),),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=> const CameraFace());
          }, icon: Icon(Icons.add_circle_outline,size: 35,)),
          InkWell(
            onTap: (){
              controller.posts.clear();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const ProfilePage()), (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle
                ),
                child: Center(child: Text(widget.userIn![0],style: TextStyle(color: Colors.white),),),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: ()async{
          controller.posts.clear();
          return true;
        },
        child: Obx(()=>(controller.fetched.value)?SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.posts.length,
                  itemBuilder: (BuildContext context,int index){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: CachedNetworkImage(
                            imageUrl: controller.posts[index].url,
                            placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Text("POSTED BY: ${(widget.userIn == controller.posts[index].postedBy)?"ME":controller.posts[index].postedBy}")
                  ],
                );
              })
            ],
          ),
        ):Center(child:  CircularProgressIndicator(),),
        ),
      )
    );
  }
}
