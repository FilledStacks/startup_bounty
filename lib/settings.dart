import 'package:hive_flutter/hive_flutter.dart';

class SettingsData {
  final bool useFlutterDriver;
  const SettingsData({
    required this.useFlutterDriver,
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
  }
}
