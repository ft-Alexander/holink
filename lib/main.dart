import 'package:flutter/material.dart';
import 'package:holink/features/authentication/views/login.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';

void main() {
  runApp(const HolinkApp());
}

class HolinkApp extends StatelessWidget {
  const HolinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
