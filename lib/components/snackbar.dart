import 'package:flutter/material.dart';

snackbar(context, {String msg = ''}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(msg),
    ),
  );
}
