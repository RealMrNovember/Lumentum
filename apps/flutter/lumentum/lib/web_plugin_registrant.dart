import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Web'de file_picker platform implementasyonunu kaydeder.
void registerPlugins([Registrar? pluginRegistrar]) {
  final registrar = pluginRegistrar ?? webPluginRegistrar;
  FilePickerWeb.registerWith(registrar);
}
