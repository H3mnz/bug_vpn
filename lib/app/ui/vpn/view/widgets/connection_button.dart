import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/utils/utils.dart';
import '../../../configs/data/models/config_model.dart';
import '../../../configs/view/providers/configs_provider.dart';
import '../providers/v2ray_provider.dart';

class ConnectionButton extends ConsumerStatefulWidget {
  const ConnectionButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends ConsumerState<ConnectionButton> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    animationController.reverse();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(v2RayStatusProvider);
    final v2ray = ref.read(v2rayProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        return Center(
          child: SizedBox.square(
            dimension: h,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: status.isConnected ? 1 : 0),
              duration: const Duration(milliseconds: 300),
              builder: (context, t, child) {
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(0),
                  color: Color.lerp(AppColors.amber, AppColors.green, t)?.withOpacity(0.3),
                  // color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    onTap: () async {
                      if (animationController.isAnimating) return;

                      // animationController.repeat();

                      // await Future.delayed(const Duration(seconds: 1));
                      // animationController.reverse();

                      _handleOnTap(status, v2ray, selectedConfig);
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          //
                          Positioned.fill(
                            child: Card(
                              elevation: 0,
                              shape: const StadiumBorder(),
                              margin: const EdgeInsets.all(24),
                              color: Color.lerp(AppColors.amber, AppColors.green, t),
                              child: SizedBox.expand(
                                child: Icon(
                                  UIcons.solidRounded.bug,
                                  size: h * 0.35,
                                  color: Colors.white,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Animate(
                                controller: animationController,
                                autoPlay: false,
                                effects: const [
                                  RotateEffect(begin: 0, end: 1, curve: Curves.linear),
                                ],
                                child: CustomPaint(
                                  painter: _ArcPainter(
                                    color: Color.lerp(AppColors.amber, AppColors.green, t)!,
                                    arcCount: 3,
                                    strokeWidth: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Animate(
                                // controller: animationController,
                                autoPlay: false,
                                effects: const [
                                  RotateEffect(begin: 0, end: 1, curve: Curves.linear),
                                ],
                                child: CustomPaint(
                                  painter: _ArcPainter(
                                    color: Color.lerp(AppColors.amber, AppColors.green, t)!.withOpacity(0.5),
                                    arcCount: 9,
                                    reverse: true,
                                    strokeWidth: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleOnTap(V2RayStatus status, FlutterV2ray v2ray, ConfigModel? selectedConfig) async {
    if (status.isConnected) {
      animationController.repeat();
      // animationController2.repeat(reverse: true);
      await Future.delayed(const Duration(seconds: 1));
      await v2ray.stopV2Ray();
      ref.read(selectedConfigPingProvider.notifier).update((state) => null);
      animationController.reverse();
    } else {
      if (selectedConfig is ConfigModel) {
        if (await v2ray.requestPermission()) {
          try {
            animationController.repeat();

            final ping = await v2ray.getDelayWithTimeout(selectedConfig.v2rayURL.getFullConfiguration());
            await Future.delayed(const Duration(seconds: 1));
            if (ping > 0) {
              await v2ray.startV2Ray(
                remark: '${AppUtils.appLabel} is Running...',
                bypassSubnets: AppUtils.subnets,
                config: selectedConfig.v2rayURL.getFullConfiguration(),
              );
              ref.read(selectedConfigPingProvider.notifier).update((state) => ping);
            } else {
              AppUtils.configNotAvailableToast();
            }
          } catch (e) {
            log(e.toString());
            AppUtils.unexpectedErrorToast();
          }
          animationController.reverse();
        }
      } else {
        AppUtils.selectConfigToast();
      }
    }
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  final int arcCount;
  final bool reverse;
  final double strokeWidth;
  _ArcPainter({
    required this.color,
    required this.arcCount,
    this.reverse = false,
    this.strokeWidth = 2,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final h = size.height;
    final w = size.width;

    double sweepAngle = reverse ? -math.pi / arcCount : math.pi / arcCount;
    double startAngle = 0;
    final arcsRect = Rect.fromLTWH(0, 0, w, h);

    for (int i = 0; i < arcCount; i++) {
      canvas.drawArc(arcsRect, startAngle, sweepAngle, false, p);
      startAngle = startAngle + sweepAngle * 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
