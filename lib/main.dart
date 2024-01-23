import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as path_provider;

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');
const applicationPackageName = 'com.example.startup_bounty';

AppConfig? configFile;

const useFlutterDriverKey = 'use_flutter_driver';

Future<void> main() async {
  configFile = await AppConfig.getConfig(applicationPackageName);
  // TASK: Read this value from a local storage
  final useFlutterDriver =
      configFile?.getValue<bool>(useFlutterDriverKey) == true;

  // Observe value from config file here
  print({'useFlutterDriver': useFlutterDriver});

  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  // press the + increment button in UI to update this value to true.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    // TASK: Change the value here and save
    setState(() {
      _counter++;
    });
    // update value in the same config file
    await configFile!.setValue('use_flutter_driver', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListTile(
              title: Text(
                  configFile?.getValue<bool>(useFlutterDriverKey)?.toString() ??
                      '-'),
              subtitle: const Text('use_flutter_driver'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Future<Directory> getPlatformDocumentsDirectoryPathFromPlugin() {
//   WidgetsFlutterBinding.ensureInitialized();
//   return path_provider.getApplicationDocumentsDirectory();
// }

/// Returns Application documents directory for a platform before `WidgetsFlutterBinding.ensureInitialized` or `runApp`
/// is used.
Future<Directory> getPlatformDocumentsDirectoryPath(
  String applicationPackageName,
) async {
  if (Platform.isAndroid) {
    return Directory('/data/user/0/$applicationPackageName');
  } else if (Platform.isMacOS) {
    final applicationHomeDir = Platform.environment['HOME'];
    return Directory('$applicationHomeDir/Documents');
  } else if (Platform.isIOS) {
    final bundleContainerDir = File(Platform.executable).parent;
    // This isn't documents directory but the bundle container directory of this application.
    // Only works on iOS simulator and will not work on a real iPhone
    return bundleContainerDir.parent;
  }
  throw UnimplementedError(
      'Default documents directory path was not setup for other platforms');
}

class AppConfig {
  final File _configJsonFile;
  final Map<String, Object?> _cachedConfig;

  AppConfig._(this._configJsonFile, this._cachedConfig);

  static Future<AppConfig?> getConfig(String applicationPackageName) async {
    final file = await getApplicationConfigFile(applicationPackageName);
    print({
      "config file path": file.absolute.path,
    });
    final content = await file.readAsString();
    final Map<String, Object?> contentJson =
        content.isEmpty ? {} : json.decode(content);
    return AppConfig._(file, contentJson);
  }

  T? getValue<T extends Object>(String key) {
    return _cachedConfig[key] as dynamic;
  }

  Future<void> setValue(String key, Object? value) async {
    _cachedConfig[key] = value;
    await _update();
  }

  Future<void> _update() async {
    await _configJsonFile.writeAsString(json.encode(_cachedConfig));
  }
}

class AppConfigSetupFailure extends Error {
  final String message;
  AppConfigSetupFailure(this.message);

  @override
  String toString() {
    return 'AppConfigSetupFailure: $message';
  }
}

/// Returns path of config file that is inside application's official document directory
Future<File> getApplicationConfigFile(String applicationPackageName) async {
  try {
    final documentsDirectory =
        await getPlatformDocumentsDirectoryPath(applicationPackageName);
    print({
      'application documents dir': documentsDirectory.absolute.path,
    });
    await documentsDirectory.create(recursive: true);
    final configJsonFile = File(
      path.join(documentsDirectory.path, 'app_config.json'),
    );
    if (!await configJsonFile.exists()) {
      await configJsonFile.create();
    }
    return configJsonFile;
  } catch (e, s) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: s);
  }
  throw AppConfigSetupFailure('Could not find app config file directory');
}
