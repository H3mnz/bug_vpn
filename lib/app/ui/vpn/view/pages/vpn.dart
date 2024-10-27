import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/extensions.dart';
import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/utils/utils.dart';
import '../../../configs/view/providers/configs_provider.dart';
import '../../../home/view/pages/about.dart';
import '../providers/v2ray_provider.dart';
import '../widgets/connecting_time.dart';
import '../widgets/connection_button.dart';
import '../widgets/connection_status.dart';
import '../widgets/selected_config_card.dart';
import '../widgets/usage_status_card.dart';

class VpnPage extends ConsumerWidget {
  const VpnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(v2RayStatusProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(AppUtils.appLabel),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AboutPage(),
            ),
            icon: Icon(UIcons.solidRounded.question),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.5,
              child: Transform.rotate(
                angle: 360 / 5,
                alignment: Alignment.center,
                child: const GridPaper(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  stops: const [0.1, 0.4],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: kToolbarHeight + MediaQuery.paddingOf(context).top,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Spacer(),
                        ConnectingTime(value: status.duration),
                        const Spacer(),
                        ConnectionStatus(connected: status.isConnected),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: ConnectionButton(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(flex: 2),
                        Row(
                          children: [
                            Expanded(
                              child: UsageStatusCard(
                                iconColor: AppColors.blue,
                                icon: UIcons.regularRounded.chevron_double_down,
                                label: 'Download',
                                value: status.download.formatAsBytes(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: UsageStatusCard(
                                iconColor: AppColors.red,
                                icon: UIcons.regularRounded.chevron_double_up,
                                label: 'Upload',
                                value: status.upload.formatAsBytes(),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),
                        SelectedConfigCard(selectedConfig: selectedConfig),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
