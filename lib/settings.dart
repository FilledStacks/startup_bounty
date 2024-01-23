import 'package:hive_flutter/hive_flutter.dart';

class SettingsData {
  bool useFlutterDriver;
  bool isInitialized;
  SettingsData({
    required this.useFlutterDriver,
    this.isInitialized = false,
  });
}

class SettingsKeys {
  static const String driverSettings = 'driverSettings';
}

class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final typeId = 0;

  @override
  SettingsData read(BinaryReader reader) {
    final useFlutterDriver = reader.readBool();
    return SettingsData(useFlutterDriver: useFlutterDriver);
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer.writeBool(obj.useFlutterDriver);
    writer.writeBool(obj.isInitialized);
  }
}
