import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportconnect/src/app.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://eozoiixwfkatcldgnwpw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvem9paXh3ZmthdGNsZGdud3B3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY1NDI1NDksImV4cCI6MjAyMjExODU0OX0.xCAiZC9uhWBXAtEjNoEIUOmjibiQI_d_zTU-bIZmU4w',
  );
  runApp(const SportConnectApp());
}

final supabase = Supabase.instance.client;
