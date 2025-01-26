import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart'; 
import '../shared/colors.dart';

class VoiceToSignLanguagePage extends StatefulWidget {
  @override
  _VoiceToSignLanguagePageState createState() =>
      _VoiceToSignLanguagePageState();
}

class _VoiceToSignLanguagePageState extends State<VoiceToSignLanguagePage> {

  String _inputMode = 'text'; // 'text' or 'voice'
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  bool isConnected = false;

  void _connectToBluetooth() async {

    flutterBlue.startScan(timeout: Duration(seconds: 4));


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


  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
      isConnected = true;
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
                backgroundColor: Color(0xFFBCDA7E),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
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
                  color: Color(0xFF6B8E23),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [

                  RadioListTile<String>(
                    title: Text(
                      'Text',
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'text',
                    groupValue: _inputMode,
                    tileColor: Color(0xFFFFF9C4),
                    activeColor: Color(0xFF6B8E23),
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
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'voice',
                    groupValue: _inputMode,
                    tileColor: Color(0xFFFFF9C4),
                    activeColor: Color(0xFF6B8E23),
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


            if (_inputMode == 'text')
              TextField(
                decoration: InputDecoration(
                  labelText: "Enter a letter or number",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23),
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF6B8E23),
                        width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.text_fields,
                    color: Color(0xFF6B8E23),
                  ),
                ),
              ),


            if (_inputMode == 'voice')
              ElevatedButton.icon(
                onPressed: () {
                  // Handle voice input
                },
                icon: Icon(Icons.mic, color: Color(0xFF6B8E23)),
                label: Text(
                  "Input Voice",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Color(0xFF6B8E23), width: 2),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}