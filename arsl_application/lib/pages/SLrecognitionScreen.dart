import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import '../shared/colors.dart';

class SLrecognitionScreen extends StatefulWidget {
  const SLrecognitionScreen({Key? key}) : super(key: key);

  @override
  State<SLrecognitionScreen> createState() => _SLrecognitionScreenState();
}

class _SLrecognitionScreenState extends State<SLrecognitionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  File? _selectedImage;
  int _selectedCameraIndex = 0; // 0 for back camera, 1 for front camera
  String _predictionResult = "";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // تحميل النموذج
  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/trained_model_v2.tflite",
      labels: "assets/labels-arabic.txt",
    );
  }


  Future<void> _initializeCamera() async {
    setState(() {
      _selectedImage = null;
      _isCameraInitialized = false;
    });

    final cameras = await availableCameras();
    final camera = cameras[_selectedCameraIndex];

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }


  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isCameraInitialized = false;
        _cameraController?.dispose();
      });
      _applyModelOnImage(_selectedImage!);
    }
  }


  Future<void> _applyModelOnImage(File image) async {
    var predictions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 3,
      threshold: 0.1,
    );

    setState(() {
      _predictionResult = "";
      if (predictions != null) {
        for (var prediction in predictions) {
          _predictionResult +=
          "${prediction['label']}: ${(prediction['confidence'] as double).toStringAsFixed(2)}\n";
        }
      }
    });
  }

  // تبديل الكاميرا
  void _toggleCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
      _isCameraInitialized = false;
    });
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real Time Recognition"),
        backgroundColor: appbarGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select your option",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, size: 50),
                        onPressed: _initializeCamera,
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo, size: 50),
                        onPressed: _pickImageFromGallery,
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200],
                    ),
                    child: _selectedImage != null
                        ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                        : _isCameraInitialized && _cameraController != null
                        ? CameraPreview(_cameraController!)
                        : const Center(
                      child: Text(
                        "No camera preview or image selected",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (_isCameraInitialized)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _toggleCamera,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.cameraswitch, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _predictionResult,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
