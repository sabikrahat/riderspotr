import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showErrorMessage(String message) {
  toastification.show(
    type: ToastificationType.error,
    title: Text('Oh no!'),
    description: Text(message),
    autoCloseDuration: Duration(seconds: 5),
  );
}

void showSuccessMessage(String message, {String? title}) {
  toastification.show(
    type: ToastificationType.success,
    title: Text(
      title ?? 'Success!',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(message, style: TextStyle(fontWeight: FontWeight.normal)),
    autoCloseDuration: Duration(seconds: 5),
  );
}

void showAlertMessage(String message, {String? title}) {
  toastification.show(
    type: ToastificationType.info,
    icon: Icon(Icons.info),
    title: Text(title ?? 'Alert!'),
    description: Text(message),
    autoCloseDuration: Duration(seconds: 5),
  );
}

void showInfoMessage(String message, {String? title}) {
  toastification.show(
    type: ToastificationType.info,
    icon: Icon(Icons.info),
    title: Text(title ?? 'Info'),
    description: Text(message),
    autoCloseDuration: Duration(seconds: 5),
  );
}
