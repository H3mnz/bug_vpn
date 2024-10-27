// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/extensions.dart';
import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../../shared/preferences/preferences.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/utils/utils.dart';
import '../../../vpn/view/providers/v2ray_provider.dart';
import '../../data/models/config_model.dart';
import '../providers/configs_provider.dart';
import '../widgets/config_error_widget.dart';

class ConfigsPage extends ConsumerWidget {
  const ConfigsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v2ray = ref.watch(v2rayProvider);
    final provider = ref.watch(configsProvider);
    final configsPing = ref.watch(configsPingProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('All Configs'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(configsProvider),
            icon: Icon(UIcons.regularRounded.refresh),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: provider.when(
        skipError: false,
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
        data: (configs) {
          final collections = configs.groupBy((config) => AppUtils.parseConfigType(config.url));
          final types = collections.keys.toList()..sort();
          return DefaultTabController(
            length: types.length,
            child: Column(
              children: [
                Animate(
                  effects: const [
                    FadeEffect(),
                    SlideEffect(
                      begin: Offset(0, -0.1),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBarCard(types: types),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Animate(
                    effects: const [
                      FadeEffect(),
                      SlideEffect(
                        begin: Offset(0, 0.1),
                      ),
                    ],
                    child: TabBarView(
                      children: [
                        ...types.map(
                          (type) => ListView.separated(
                            itemCount: collections[type]!.length,
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final config = collections[type]!.elementAt(index);
                              final isSelected = selectedConfig?.v2rayURL.url == config.url;
                              return ConfigCard(
                                config: config,
                                isSelected: isSelected,
                                index: index,
                                type: type,
                                configsPing: configsPing,
                                onPing: () => _getPing(context, v2ray, config, ref),
                                onTap: () async {
                                  await v2ray.stopV2Ray();
                                  if (!context.mounted) return;
                                  await _getPing(context, v2ray, config, ref);
                                  ref.read(selectedConfigPingProvider.notifier).update(
                                        (state) => configsPing[config.url],
                                      );
                                  ref.read(selectedConfigProvider.notifier).update(
                                        (state) => ConfigModel(
                                          ping: configsPing[config.url],
                                          name: '${type.toUpperCase()} ${index + 1}',
                                          type: type,
                                          v2rayURL: config,
                                        ),
                                      );
                                  Preferences.instance.saveConfig(
                                    ConfigModel(
                                      ping: configsPing[config.url],
                                      name: '${type.toUpperCase()} ${index + 1}',
                                      type: type,
                                      v2rayURL: config,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => ConfigErrorWidget(onError: () => ref.invalidate(configsProvider)),
        loading: () => const LoadingWidget(),
      ),
    );
  }

  Future<void> _getPing(BuildContext context, FlutterV2ray v2ray, V2RayURL config, WidgetRef ref) async {
    context.loaderOverlay.show();
    try {
      final ping = await v2ray.getDelayWithTimeout(config.getFullConfiguration());

      ref.read(configsPingProvider.notifier).update(
        (state) {
          return {
            ...state,
            ...{config.url: ping},
          };
        },
      );
    } catch (e) {
      log(e.toString());
      AppUtils.configNotAvailableToast();
    }
    if (context.mounted) context.loaderOverlay.hide();
  }
}

class ConfigCard extends StatelessWidget {
  final V2RayURL config;
  final bool isSelected;
  final int index;
  final String type;
  final Map<String, int> configsPing;
  final VoidCallback onPing;
  final VoidCallback onTap;
  const ConfigCard({
    super.key,
    required this.config,
    required this.isSelected,
    required this.index,
    required this.type,
    required this.configsPing,
    required this.onPing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 2,
          color: isSelected ? AppColors.green : Colors.grey.shade300,
        ),
      ),
      margin: const EdgeInsets.all(0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? Theme.of(context).primaryColor : AppColors.red,
          child: Text('${index + 1}'),
        ),
        title: Text('${type.toUpperCase()} ${index + 1}', maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('Network : ${config.network.toUpperCase()}'),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        selected: isSelected,
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (configsPing.containsKey(config.url) && configsPing[config.url]! > 0)
              Text(
                '${configsPing[config.url]} ms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppUtils.pingColor(configsPing[config.url]!),
                    ),
              ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Get config ping',
              onPressed: onPing,
              icon: Icon(UIcons.regularRounded.tachometer_fastest),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(),
        ScaleEffect(),
      ],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          backgroundColor: Colors.black12,
          strokeAlign: BorderSide.strokeAlignOutside,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}

class TabBarCard extends StatelessWidget {
  const TabBarCard({
    super.key,
    required this.types,
  });

  final List<String> types;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 2,
          color: Colors.grey.shade300,
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: TabBar(
        tabs: [
          ...types.map((type) => Tab(text: type)),
        ],
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerHeight: 0,
        padding: const EdgeInsets.all(8),
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        splashBorderRadius: BorderRadius.circular(12),
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
