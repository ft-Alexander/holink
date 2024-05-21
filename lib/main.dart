import 'package:flutter/material.dart';
import 'package:holink/features/authentication/views/login.dart';
import 'package:provider/provider.dart';

import 'package:holink/features/financial/view/financial_transactions.dart';
import 'package:holink/features/financial/controller/transaction_state.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TransactionState(),
    child: const HolinkApp(),
  ));
  // const HolinkApp());
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
