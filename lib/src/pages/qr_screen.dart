import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String qrData = "/login";
  final qrKey = GlobalKey(debugLabel: 'QR');
  

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.5,
              maxHeight: screenSize.height * 0.05,
            
            ),
            child: Image.asset(
              'assets/images/logo_text.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                size: const Size(200, 200),
                painter: QrPainter(
                  data: qrData,
                  version: QrVersions.auto,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Material(
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Scan QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _onQRViewCreated(QRViewController controller) {
  controller.scannedDataStream.listen((scanData) async {
    int eventId = int.parse(scanData.code!);
    Get.find<EventController>().confirmAttendance(eventId);

    controller.pauseCamera();
  });
}

}
