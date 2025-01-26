import 'package:arsl_application/pages/home.dart';
import 'package:arsl_application/shared/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  // عرض شاشة SplashScreen في البداية
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال إلى الصفحة الرئيسية بعد 6 ثوانٍ
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbarscreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // لضمان محاذاة العناصر في المنتصف
          children: [
            // عرض الشعار في أعلى الصفحة
            Image.asset(
              'assets/logo.png',
              height: 600, // تعديل الحجم حسب الرغبة
              fit: BoxFit.fitWidth, // الحفاظ على الأبعاد المناسبة
            ),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10), // مسافة بين النص والصورة الدائرية
            Text(
              'Asharatii Application Loading......',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10), // مسافة بين النص والصورة الدائرية
            CircularProgressIndicator(), // مؤشر التحميل
          ],
        ),
      ),
    );
  }
}
