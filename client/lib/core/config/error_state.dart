import 'package:flutter/material.dart';

class ErrorState with ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void showErrorDialog(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(_errorMessage),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearError();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
