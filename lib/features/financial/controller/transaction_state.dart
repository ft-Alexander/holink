// transaction_state.dart
import 'package:flutter/material.dart';
import 'package:holink/features/financial/controller/transaction.dart';

class TransactionState with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
