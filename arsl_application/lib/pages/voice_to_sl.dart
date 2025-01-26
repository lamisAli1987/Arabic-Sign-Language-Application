import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart'; // إضافة مكتبة بلوتوث
import '../shared/colors.dart';

class VoiceToSignLanguagePage extends StatefulWidget {
  @override
  _VoiceToSignLanguagePageState createState() =>
      _VoiceToSignLanguagePageState();
}

class _VoiceToSignLanguagePageState extends State<VoiceToSignLanguagePage> {
  // تحديد الخيار الافتراضي (صوت أو نص)
  String _inputMode = 'text'; // 'text' or 'voice'
  FlutterBlue flutterBlue = FlutterBlue.instance; // تعريف مثيل flutterBlue
  BluetoothDevice? connectedDevice;
  bool isConnected = false; // حالة الاتصال بالبلوتوث

  // وظيفة لتفعيل البلوتوث
  void _connectToBluetooth() async {
    // البحث عن الأجهزة
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // الاستماع للأجهزة المكتشفة
    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == "H05") {
          flutterBlue.stopScan(); // إيقاف البحث بعد إيجاد الجهاز
          _connectToDevice(result.device);
          break;
        }
      }
    });
  }

  // وظيفة لتوصيل الجهاز
  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
      isConnected = true; // تم التوصيل بنجاح
    });
    print("Connected to Bluetooth device!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice or Text to SL"),
        centerTitle: true,
        backgroundColor: appbarGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // إضافة زر لتوصيل البلوتوث
            ElevatedButton(
              onPressed: _connectToBluetooth,
              child: isConnected
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth_connected, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Bluetooth Connected",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Bluetooth Connection",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Color(0xFFBCDA7E), // خلفية صفراء
                side: BorderSide(
                  color: Colors.black, // الإطار الأسود
                  width: 2, // سماكة الإطار
                ),
              ),
            ),
            SizedBox(height: 20),

            // إضافة نص قبل خيارات النص والصوت
            Text(
              "Select your option",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // مستطيل للاختيار بين النص والصوت
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF6B8E23), // لون الإطار الزيتوني
                  width: 2, // زيادة سماكة الإطار
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  // خيار النص
                  RadioListTile<String>(
                    title: Text(
                      'Text',
                      style:
                      TextStyle(fontWeight: FontWeight.bold), // النص غامق
                    ),
                    value: 'text',
                    groupValue: _inputMode,
                    tileColor: Color(0xFFFFF9C4), // خلفية صفراء
                    activeColor: Color(0xFF6B8E23), // لون الدائرة الزيتوني
                    onChanged: (String? value) {
                      setState(() {
                        _inputMode = value!;
                      });
                    },
                  ),
                  // خيار الصوت
                  RadioListTile<String>(
                    title: Text(
                      'Voice',
                      style:
                      TextStyle(fontWeight: FontWeight.bold), // النص غامق
                    ),
                    value: 'voice',
                    groupValue: _inputMode,
                    tileColor: Color(0xFFFFF9C4), // خلفية صفراء
                    activeColor: Color(0xFF6B8E23), // لون الدائرة الزيتوني
                    onChanged: (String? value) {
                      setState(() {
                        _inputMode = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // حقل النص إذا تم اختيار النص
            if (_inputMode == 'text')
              TextField(
                decoration: InputDecoration(
                  labelText: "Enter a letter or number", // النص
                  labelStyle: TextStyle(color: Colors.black), // اللون الأسود
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23), width: 2), // الإطار الزيتوني
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23),
                        width: 2), // الإطار الزيتوني أثناء التفعيل
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23),
                        width: 2), // الإطار الزيتوني عند التركيز
                  ),
                  prefixIcon: Icon(
                    Icons.text_fields,
                    color: Color(0xFF6B8E23), // لون الأيقونة الزيتوني
                  ),
                ),
              ),

            // زر الإدخال الصوتي إذا تم اختيار الصوت
            if (_inputMode == 'voice')
              ElevatedButton.icon(
                onPressed: () {
                  // Handle voice input
                },
                icon: Icon(Icons.mic, color: Color(0xFF6B8E23)),
                label: Text(
                  "Input Voice",
                  style: TextStyle(color: Colors.black), // لون النص
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.white, // الخلفية البيضاء
                  side: BorderSide(
                      color: Color(0xFF6B8E23), width: 2), // الإطار الزيتوني
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}