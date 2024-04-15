import 'package:flutter/material.dart';

class QRCodeWidget extends StatelessWidget {
  final String eventData;
  final String imageUrl;

  const QRCodeWidget({
    Key? key,
    required this.eventData,
    required this.imageUrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(imageUrl, width: 300, height: 300, fit: BoxFit.cover,)
    );
  }
}
