// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_v2ray/flutter_v2ray.dart';

class ConfigModel {
  final String name;
  final String type;
  final int? ping;
  final V2RayURL v2rayURL;
  ConfigModel({
    required this.name,
    required this.type,
    required this.v2rayURL,
    this.ping,
  });

  @override
  bool operator ==(covariant ConfigModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.type == type && other.ping == ping && other.v2rayURL == v2rayURL;
  }

  @override
  int get hashCode {
    return name.hashCode ^ type.hashCode ^ ping.hashCode ^ v2rayURL.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'ping': ping,
      'v2rayURL': v2rayURL.url,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      name: map['name'] as String,
      type: map['type'] as String,
      ping: map['ping'] != null ? map['ping'] as int : null,
      v2rayURL: FlutterV2ray.parseFromURL(map['v2rayURL']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) => ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
