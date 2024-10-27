import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

final v2RayStatusProvider = StateProvider<V2RayStatus>((ref) {
  return V2RayStatus();
});

final v2rayProvider = Provider<FlutterV2ray>((ref) {
  final v2ray = FlutterV2ray(
    onStatusChanged: (status) {
      ref.read(v2RayStatusProvider.notifier).update(
            (state) => V2RayStatus(
              download: status.download,
              downloadSpeed: status.downloadSpeed,
              duration: status.duration,
              state: status.state,
              upload: status.upload,
              uploadSpeed: status.uploadSpeed,
            ),
          );
    },
  );

  return v2ray..initializeV2Ray();
});

final configsPingProvider = StateProvider<Map<String, int>>((ref) {
  return {};
});

final selectedConfigPingProvider = StateProvider<int?>((ref) {
  return null;
});
