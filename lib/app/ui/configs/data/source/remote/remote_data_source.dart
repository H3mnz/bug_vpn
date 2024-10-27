import 'package:http/http.dart' as http;

import '../../../../../shared/utils/utils.dart';

class RemoteDataSource {
  Future<Iterable<String>> getConfigs() async {
    try {
      final response = await http.get(Uri.parse(AppUtils.sublinksUrl));
      if (response.statusCode != 200) throw Exception('Invalid statusCode');
      final data = response.body
          .trim()
          .split('\n')
          .where(
            (line) => line.trim().isNotEmpty,
          )
          .toSet();
      return data;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
