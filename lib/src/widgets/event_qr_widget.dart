import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String eventData;

  const QRCodeWidget({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: eventData,
        version: QrVersions.auto,
        size: 200.0,
        gapless: false,
        backgroundColor: Colors.white,
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size(80, 80),
        ),
      ),
    );
  }
}
