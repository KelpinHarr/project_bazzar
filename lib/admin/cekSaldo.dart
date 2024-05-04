import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class CekSaldo extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CekSaldo({Key? key, required this.cameras}) : super(key: key);

  @override
  _CekSaldoState createState() => _CekSaldoState();
}

class _CekSaldoState extends State<CekSaldo> {
  late CameraController _cameraController;
  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![1]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(
          body: SafeArea(
            child: _cameraController.value.isInitialized ?
              CameraPreview(_cameraController)
              :
              const Center(child:
                CircularProgressIndicator()
              )
          )
      ),
      activePage: 'Cek saldo',
    );
  }
}

