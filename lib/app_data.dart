import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String _clientName = '';
  String _clientCity = '';
  List<String> _scannedQrCodes = [];

  String get clientName => _clientName;
  String get clientCity => _clientCity;
  List<String> get scannedQrCodes => _scannedQrCodes;

  void setClientName(String name) {
    _clientName = name;
    notifyListeners();
  }

  void setClientCity(String city) {
    _clientCity = city;
    notifyListeners();
  }

  void addScannedQrCode(String qrCode) {
    _scannedQrCodes.add(qrCode);
    notifyListeners();
  }



  removeScannedQrCode(String scannedQrCod) {}ode(String qrCode) {
    _scannedQrCodes.remove(qrCode);
    notifyListeners();
  }
}