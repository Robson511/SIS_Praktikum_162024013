/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Latar gelap espresso dengan "gelembung" karamel yang bergerak pelan.
// Dipakai bersama oleh splash, login, dan register agar terasa satu kesatuan.
class AuthBackground extends StatefulWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.darkGradient),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value * 2 * math.pi;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + 40 * math.sin(t),
                    right: -60 + 30 * math.cos(t),
                    child: _blob(
                      280,
                      AppColors.caramel.withValues(alpha: 0.35),
                    ),
                  ),
                  Positioned(
                    bottom: -100 + 40 * math.cos(t),
                    left: -80 + 40 * math.sin(t),
                    child: _blob(320, AppColors.latte.withValues(alpha: 0.18)),
                  ),
                  Positioned(
                    top: 260 + 30 * math.sin(t + 1.5),
                    left: -40 + 20 * math.cos(t),
                    child: _blob(
                      160,
                      AppColors.caramel.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}
