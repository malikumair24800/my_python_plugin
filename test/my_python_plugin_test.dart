import 'package:flutter_test/flutter_test.dart';
import 'package:my_python_plugin/my_python_plugin.dart';
import 'package:my_python_plugin/my_python_plugin_platform_interface.dart';
import 'package:my_python_plugin/my_python_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMyPythonPluginPlatform
    with MockPlatformInterfaceMixin
    implements MyPythonPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MyPythonPluginPlatform initialPlatform = MyPythonPluginPlatform.instance;

  test('$MethodChannelMyPythonPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMyPythonPlugin>());
  });

  test('getPlatformVersion', () async {
    MyPythonPlugin myPythonPlugin = MyPythonPlugin();
    MockMyPythonPluginPlatform fakePlatform = MockMyPythonPluginPlatform();
    MyPythonPluginPlatform.instance = fakePlatform;

    expect(await myPythonPlugin.getPlatformVersion(), '42');
  });
}
