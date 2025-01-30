import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'my_python_plugin_platform_interface.dart';

/// An implementation of [MyPythonPluginPlatform] that uses method channels.
class MethodChannelMyPythonPlugin extends MyPythonPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('my_python_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
