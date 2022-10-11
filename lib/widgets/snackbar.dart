
import 'package:flutter/material.dart';

showSuccessSnackBar ({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: const TextStyle(color: Colors.white),), backgroundColor: Colors.blueAccent,));
}