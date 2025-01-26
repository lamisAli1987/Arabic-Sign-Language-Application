import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
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

  // إعداد الكاميرا
  Future<void> _initializeCamera() async {
    setState(() {
      _selectedImage = null; // إخفاء الصورة المختارة إذا وجدت
      _isCameraInitialized = false;
    });

    final cameras = await availableCameras();
    final camera = cameras[_selectedCameraIndex]; // اختيار الكاميرا بناءً على الاختيار

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  // اختيار صورة من المعرض
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isCameraInitialized = false; // إيقاف الكاميرا عند اختيار صورة
        _cameraController?.dispose();
      });
    }
  }

  // تبديل الكاميرا
  void _toggleCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0; // التبديل بين الكاميرا الأمامية والخلفية
      _isCameraInitialized = false; // إعادة تهيئة الكاميرا
    });
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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
                color: const Color(0xFFFFF9C4), // لون أصفر فاتح
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
                      const SizedBox(height: 0), // تقليل المسافة بين الأيقونة والنص
                      const Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 16, // تقليل حجم النص
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
                      const SizedBox(height: 0), // تقليل المسافة بين الأيقونة والنص
                      const Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 16, // تقليل حجم النص
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // عرض الكاميرا أو الصورة المختارة مع أيقونة التبديل
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200], // خلفية رمادية
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
                        textAlign: TextAlign.center, // لضمان التوسيط الأفقي للنص
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
            const Text(
              "Accuracy is 99.99%",
              style: TextStyle(
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
