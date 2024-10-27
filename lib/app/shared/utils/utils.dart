import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/colors.dart';

class AppUtils {
  AppUtils._();

  static const String appLabel = 'BUG VPN';

  static const String sublinksUrl = 'https://raw.githubusercontent.com/Kwinshadow/TelegramV2rayCollector/main/sublinks/mix.txt';

  static const List<String> subnets = [
    "0.0.0.0/5",
    "8.0.0.0/7",
    "11.0.0.0/8",
    "12.0.0.0/6",
    "16.0.0.0/4",
    "32.0.0.0/3",
    "64.0.0.0/2",
    "128.0.0.0/3",
    "160.0.0.0/5",
    "168.0.0.0/6",
    "172.0.0.0/12",
    "172.32.0.0/11",
    "172.64.0.0/10",
    "172.128.0.0/9",
    "173.0.0.0/8",
    "174.0.0.0/7",
    "176.0.0.0/4",
    "192.0.0.0/9",
    "192.128.0.0/11",
    "192.160.0.0/13",
    "192.169.0.0/16",
    "192.170.0.0/15",
    "192.172.0.0/14",
    "192.176.0.0/12",
    "192.192.0.0/10",
    "193.0.0.0/8",
    "194.0.0.0/7",
    "196.0.0.0/6",
    "200.0.0.0/5",
    "208.0.0.0/4",
    "240.0.0.0/4",
  ];

  static String parseConfigType(String url) {
    switch (url.split("://")[0].toLowerCase()) {
      case 'vmess':
        return 'Vmess';
      case 'vless':
        return 'Vless';
      case 'trojan':
        return 'Trojan';
      case 'ss':
        return 'ShadowSocks';
      case 'socks':
        return 'Socks';
      default:
        return 'Unknown';
    }
  }

  static Color pingColor(int ping) {
    if (ping <= 500) return AppColors.green;
    if (ping > 500 && ping < 1000) return AppColors.amber;
    return const Color.fromARGB(255, 134, 48, 48);
  }

  static configNotAvailableToast() {
    toastification.dismissAll();
    return toastification.show(
      title: const Text('Config not available\n Try another one'),
      style: ToastificationStyle.simple,
      backgroundColor: AppColors.red,
      foregroundColor: Colors.white,
      closeOnClick: false,
      dragToClose: false,
      showIcon: true,
      boxShadow: highModeShadow,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static ToastificationItem selectConfigToast() {
    toastification.dismissAll();
    return toastification.show(
      title: const Text('Please select config'),
      style: ToastificationStyle.simple,
      closeOnClick: false,
      dragToClose: false,
      boxShadow: highModeShadow,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static ToastificationItem unexpectedErrorToast() {
    toastification.dismissAll();
    return toastification.show(
      title: const Text('An unexpected error has occurred\n Try again'),
      style: ToastificationStyle.simple,
      backgroundColor: AppColors.red,
      foregroundColor: Colors.white,
      closeOnClick: false,
      dragToClose: false,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}
