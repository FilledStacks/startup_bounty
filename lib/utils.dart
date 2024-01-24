import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveValue(bool value) async {
  final file = await _getLocalFile();
  await file.writeAsString('$value');
}

Future<bool> readValue() async {
  try {
    final file = await _getLocalFile();
    String contents = await file.readAsString();
    return contents.toLowerCase() == 'true';
  } catch (e) {
    // Handle exceptions or return a default value
    debugPrint('Error reading value: $e');
    return false;
  }
}

Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/value.txt');
}
