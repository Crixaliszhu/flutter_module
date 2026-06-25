// ignore: depend_on_referenced_packages
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeon/generated/demo_bridge.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        '../android_host/flutter_engine/src/main/java/com/example/flutterengine/pigeon/DemoBridge.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.example.flutterengine.pigeon',
      includeErrorClass: true,
    ),
  ),
)
class DeviceInfo {
  String? brand;
  String? model;
  int? sdkInt;
}

class NativeEvent {
  String? name;
  Map<String?, Object?>? arguments;
}

@HostApi()
abstract class ToastHostApi {
  void show(String message);
}

@HostApi()
abstract class DeviceInfoHostApi {
  @async
  DeviceInfo getInfo();
}

@HostApi()
abstract class RouteHostApi {
  void popRoute(Map<String?, Object?>? arguments);

  void removeFlutterContainer(String instanceId);

  void pushNativeRoute(String path, Map<String?, Object?>? arguments);

  void pushFlutterRoute(String path, Map<String?, Object?>? arguments);
}

@FlutterApi()
abstract class EventFlutterApi {
  void onReceiveEvent(NativeEvent event);
}
