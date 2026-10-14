/// Stand-in for `push_channel.dart` on platforms without `dart:io`.
///
/// flutter_local_notifications imports `dart:io`, which keeps a web app from
/// compiling to WebAssembly. The channel only exists on Android, so the web
/// gets this no-op instead.
Future<void> createLotsePushChannel() async {}
