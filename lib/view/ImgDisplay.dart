import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_1/view-model/controllers/PostController.dart';
import 'package:project_1/view/PostScreen.dart';
import 'package:project_1/view/loader.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({Key? key,required this.imgPath}) : super(key: key);
  final String? imgPath;
  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  final PostController controller = Get.put(PostController(),permanent: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(widget.imgPath!)),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "Submit",
            onPressed:(){
            showLoaderDialog(context);
            var header = controller.length!.value + 1;
            controller.uploadPic(controller.profileIn.value, widget.imgPath,header.toString()).whenComplete((){
              if(controller.uploaded.value){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    PostScreen(userIn: controller.profileIn.value)), (Route<dynamic> route) => false);
              }
            });

          },
            child: const Icon(Icons.done,size: 50,),
          ),
          FloatingActionButton(
            heroTag: "Cancel",
            onPressed:(){
            Get.back();
          },
            child: const Icon(Icons.clear,size: 50,),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
