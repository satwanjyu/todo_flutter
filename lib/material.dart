import 'package:flutter/material.dart';

class PreferredSizeLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  const PreferredSizeLinearProgressIndicator({
    super.key,
    double? value,
    Color? backgroundColor,
    Animation<Color?>? valueColor,
    String? semanticsLabel,
    String? semanticsValue,
  }) : super(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  @override
  Size get preferredSize => const Size.fromHeight(4);
}
