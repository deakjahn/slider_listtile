// ignore_for_file: unused_element

import 'package:flutter/material.dart';

enum _SliderListTileType { material, adaptive }

class SliderListTile extends StatelessWidget {
  final double value;
  final double? secondaryTrackValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final Color? thumbColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final SliderInteraction? allowedInteraction;
  final _SliderListTileType _sliderListTileType;
  final Color? tileColor;
  final Widget? title;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final bool? applyCupertinoTheme;
  final String Function(double)? formatLabel;

  const SliderListTile({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.allowedInteraction = SliderInteraction.tapAndSlide,
    this.tileColor,
    this.title,
    this.dense,
    this.contentPadding,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.formatLabel,
  })  : _sliderListTileType = _SliderListTileType.material,
        applyCupertinoTheme = false,
        assert(min <= max),
        assert(value >= min && value <= max, 'Value $value is not between minimum $min and maximum $max'),
        assert(secondaryTrackValue == null || (secondaryTrackValue >= min && secondaryTrackValue <= max), 'SecondaryValue $secondaryTrackValue is not between $min and $max'),
        assert(divisions == null || divisions > 0);

  const SliderListTile.adaptive({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.allowedInteraction = SliderInteraction.tapAndSlide,
    this.applyCupertinoTheme,
    this.tileColor,
    this.title,
    this.dense,
    this.contentPadding,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.formatLabel,
  })  : _sliderListTileType = _SliderListTileType.adaptive,
        assert(min <= max),
        assert(value >= min && value <= max, 'Value $value is not between minimum $min and maximum $max'),
        assert(secondaryTrackValue == null || (secondaryTrackValue >= min && secondaryTrackValue <= max), 'SecondaryValue $secondaryTrackValue is not between $min and $max'),
        assert(divisions == null || divisions > 0);

  @override
  Widget build(BuildContext context) {
    final Widget control;
    final Widget secondary;
    switch (_sliderListTileType) {
      case _SliderListTileType.adaptive:
        control = Expanded(
          child: ExcludeFocus(
            child: Slider.adaptive(
              value: value,
              secondaryTrackValue: secondaryTrackValue,
              onChanged: onChanged,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              secondaryActiveColor: secondaryActiveColor,
              thumbColor: thumbColor,
              overlayColor: overlayColor,
              mouseCursor: mouseCursor,
              semanticFormatterCallback: semanticFormatterCallback,
              autofocus: autofocus,
              allowedInteraction: allowedInteraction,
            ),
          ),
        );

      case _SliderListTileType.material:
        control = Expanded(
          child: ExcludeFocus(
            child: Slider(
              value: value,
              secondaryTrackValue: secondaryTrackValue,
              onChanged: onChanged,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              secondaryActiveColor: secondaryActiveColor,
              thumbColor: thumbColor,
              overlayColor: overlayColor,
              mouseCursor: mouseCursor,
              semanticFormatterCallback: semanticFormatterCallback,
              autofocus: autofocus,
              allowedInteraction: allowedInteraction,
            ),
          ),
        );
    }

    final ThemeData theme = Theme.of(context);
    secondary = Text(
      formatLabel?.call(value) ?? value.toString(),
      style: TextStyle(color: (onChanged != null) ? theme.textTheme.bodyMedium!.color : theme.disabledColor),
    );

    final modifiedControl = SliderTheme(
      data: const SliderThemeData(
        trackShape: _CustomSliderTrackShape(),
        thumbShape: _CustomSliderThumbShape(),
        overlayShape: _CustomSliderOverlayShape(),
      ),
      child: control,
    );

    Widget? leading, trailing;
    (leading, trailing) = switch (controlAffinity) {
      ListTileControlAffinity.leading || ListTileControlAffinity.platform => (secondary, modifiedControl),
      ListTileControlAffinity.trailing => (modifiedControl, secondary),
    };

    Widget? titleText = title;
    if (title != null) {
      final style = theme.inputDecorationTheme.labelStyle ?? theme.textTheme.labelLarge;
      if (style != null) {
        final titleStyle = style.copyWith(
          color: (onChanged == null) ? theme.disabledColor : null,
          fontWeight: FontWeight.normal,
          fontSize: (dense == true) ? 13.0 : null,
        );
        titleText = DefaultTextStyle(
          style: titleStyle,
          child: title ?? const SizedBox(),
        );
      }
    }

    return MergeSemantics(
      child: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleText != null) titleText,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading,
                const SizedBox(width: 12),
                trailing,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// https://medium.com/@tokudu/flutter-removing-default-padding-from-sliders-3f614c12c205

class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CustomSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _CustomSliderThumbShape extends RoundSliderThumbShape {
  const _CustomSliderThumbShape({super.enabledThumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      center.translate(-(value - 0.5) / 0.5 * enabledThumbRadius, 0.0),
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
  }
}

class _CustomSliderOverlayShape extends RoundSliderOverlayShape {
  final double thumbRadius;

  const _CustomSliderOverlayShape({this.thumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      center.translate(-(value - 0.5) / 0.5 * thumbRadius, 0.0),
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
  }
}