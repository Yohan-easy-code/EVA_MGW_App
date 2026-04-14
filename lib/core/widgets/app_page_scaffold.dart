import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';

class AppPageBackground extends StatelessWidget {
  const AppPageBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? UiTokens.pageGradient
              : <Color>[
                  colorScheme.surface,
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest.withAlpha(110),
                ],
        ),
      ),
      child: child,
    );
  }
}

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: UiTokens.headerGap),
              Text(
                subtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[const SizedBox(width: 16), trailing!],
      ],
    );
  }
}

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: padding, child: child),
    );
  }
}

class AppFadeSlideIn extends StatefulWidget {
  const AppFadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.035),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset beginOffset;

  @override
  State<AppFadeSlideIn> createState() => _AppFadeSlideInState();
}

class _AppFadeSlideInState extends State<AppFadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: UiTokens.medium);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _startTimer = Timer(widget.delay, () {
      if (!mounted) {
        return;
      }
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
