import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../configs/data/models/config_model.dart';
import '../../../home/view/providers/bottom_nav_index_provider.dart';
import '../providers/v2ray_provider.dart';
import 'config_delay.dart';

class SelectedConfigCard extends ConsumerWidget {
  const SelectedConfigCard({
    super.key,
    required this.selectedConfig,
  });

  final ConfigModel? selectedConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v2ray = ref.read(v2rayProvider);
    final status = ref.read(v2RayStatusProvider);
    Widget? child;
    if (selectedConfig == null) {
      child = OutlinedButton.icon(
        onPressed: () => ref.read(bottomNavIndexProvider.notifier).update(
              (state) => 1,
            ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
          padding: const EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        iconAlignment: IconAlignment.end,
        label: const Text('Begin by Selecting a config'),
        icon: Icon(UIcons.regularRounded.angle_small_right),
      );
    } else {
      child = Card(
        key: const ValueKey('SelectedConfigCard'),
        child: ListTile(
          onTap: () => ref.read(bottomNavIndexProvider.notifier).update(
                (state) => 1,
              ),
          leading: CircleAvatar(
            child: Icon(
              UIcons.solidRounded.shield_interrogation,
            ),
          ),
          title: Text(
            selectedConfig!.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          subtitle: Text(
            'Network : ${selectedConfig!.v2rayURL.network.toUpperCase()}',
          ),
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ConfigDelay(),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Get config ping',
                onPressed: () async {
                  if (status.isConnected) return;
                  context.loaderOverlay.show();
                  try {
                    final delay = await v2ray.getDelayWithTimeout(selectedConfig!.v2rayURL.getFullConfiguration());
                    ref.read(selectedConfigPingProvider.notifier).update(
                          (state) => delay,
                        );
                  } catch (e) {
                    log(e.toString());
                  }
                  if (context.mounted) context.loaderOverlay.hide();
                },
                icon: Icon(UIcons.regularRounded.tachometer_alt_fastest),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 300,
      ),
      child: child,
    );
  }
}
