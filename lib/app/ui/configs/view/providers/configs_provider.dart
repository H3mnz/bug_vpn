import '../../data/models/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

import '../../data/repository/configs_repository.dart';
import '../../data/source/remote/remote_data_source.dart';

final configsProvider = FutureProvider<Iterable<V2RayURL>>((ref) async {
  return ConfigsRepository(RemoteDataSource()).getConfigs();
});

final selectedConfigProvider = StateProvider<ConfigModel?>((ref) {
  return null;
});
