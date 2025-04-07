import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static const String camera = 'camera';
  static const String location = 'location';
  static const String microphone = 'microphone';
  static const String storage = 'storage';
  static const String contacts = 'contacts';
  static const String calendar = 'calendar';
  static const String sms = 'sms';
  static const String phone = 'phone';
  static const String notifications = 'notifications';
  static const String bluetooth = 'bluetooth';
  static const String sensors = 'sensors';                
  static init()async{
    try {
       await [
    Permission.microphone,
    Permission.storage,
    Permission.audio,
  ].request();
    } catch (e) {
      print('Error requesting permissions: $e');
      openAppSettings();
    }
  }
}