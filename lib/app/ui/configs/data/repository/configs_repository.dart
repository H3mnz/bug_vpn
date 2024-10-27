import 'package:flutter_v2ray/flutter_v2ray.dart';

import '../source/remote/remote_data_source.dart';

class ConfigsRepository {
  final RemoteDataSource source;

  ConfigsRepository(this.source);

  Future<Iterable<V2RayURL>> getConfigs() async {
    try {
      final data = await source.getConfigs();
      return data.map(FlutterV2ray.parseFromURL);
    } catch (e) {
      rethrow;
    }
  }
}
