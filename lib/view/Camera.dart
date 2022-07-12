import 'dart:developer';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_1/main.dart';
import 'package:project_1/view/ImgDisplay.dart';

class CameraFace extends StatefulWidget {
  const CameraFace({Key? key}) : super(key: key);

  @override
  State<CameraFace> createState() => _CameraFaceState();
}

class _CameraFaceState extends State<CameraFace> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  @override
  initState()  {
    // TODO: implement initState
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(controller);
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () async{
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              final image = await controller.takePicture();
              if (!mounted) return;
              log(image.path);
              Navigator.pop(context);
              Get.to(()=>ImageDisplay(imgPath: image.path));

            } catch (e) {

              print(e);
            }
        },
          child: const Icon(Icons.camera_alt,size: 50,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
