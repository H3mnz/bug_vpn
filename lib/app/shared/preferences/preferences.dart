import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/configs/data/models/config_model.dart';

class Preferences {
  Preferences._();

  static final Preferences instance = Preferences._();

  late SharedPreferences pref;

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  ConfigModel? getConfig() {
    final source = pref.getString('config');
    if (source == null) return null;

    return ConfigModel.fromJson(source);
  }

  Future<bool> saveConfig(ConfigModel config) async {
    return pref.setString('config', config.toJson());
  }
}
