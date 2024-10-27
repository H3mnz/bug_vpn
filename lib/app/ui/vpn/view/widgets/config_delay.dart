import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/utils.dart';
import '../providers/v2ray_provider.dart';

class ConfigDelay extends ConsumerWidget {
  const ConfigDelay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConfigPing = ref.watch(selectedConfigPingProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: selectedConfigPing == null
          ? const SizedBox.shrink()
          : Text(
              selectedConfigPing > -1 ? '$selectedConfigPing ms' : '',
              key: const ValueKey('ConfigPing'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppUtils.pingColor(selectedConfigPing),
                  ),
            ),
    );
  }
}
