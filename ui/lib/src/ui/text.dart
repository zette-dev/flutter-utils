import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../zette_ui.dart';

class TextDisplayLarge extends TextWidget {
  TextDisplayLarge(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.displayLarge;
}

class TextDisplayMedium extends TextWidget {
  TextDisplayMedium(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.displayMedium;
}

class TextDisplaySmall extends TextWidget {
  TextDisplaySmall(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.displaySmall;
}

class TextHeadlineMedium extends TextWidget {
  TextHeadlineMedium(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.headlineMedium;
}

class TextHeadlineSmall extends TextWidget {
  TextHeadlineSmall(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.headlineSmall;
}

class TextTitleLarge extends TextWidget {
  TextTitleLarge(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.titleLarge;
}

class TextTitleMedium extends TextWidget {
  TextTitleMedium(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.titleMedium;
}

class TextTitleSmall extends TextWidget {
  TextTitleSmall(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.titleSmall;
}

class TextBodyLarge extends TextWidget {
  TextBodyLarge(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.bodyLarge;
}

class TextBodyMedium extends TextWidget {
  TextBodyMedium(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.bodyMedium;
}

class TextBodySmall extends TextWidget {
  TextBodySmall(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.bodySmall;
}

class TextLabelSmall extends TextWidget {
  TextLabelSmall(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.labelSmall;
}

class TextLabelLarge extends TextWidget {
  TextLabelLarge(
    String text, {
    Key? key,
    List<String>? args,
    bool? shouldTranslate,
    bool? shouldBeCopyable,
    String? copyConfirmationText,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? maxFontSize,
    double? minFontSize,
    bool? shouldAutoResize,
    bool? shouldUpperCase,
    double? fontSizeMultiplier,
    TextStyle? styles,
    AutoSizeGroup? resizeGroup,
  }) : super(
          text,
          key: key,
          shouldTranslate: shouldTranslate,
          shouldBeCopyable: shouldBeCopyable,
          copyConfirmationText: copyConfirmationText,
          styles: styles,
          args: args,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          shouldAutoResize: shouldAutoResize,
          fontSizeMultiplier: fontSizeMultiplier,
          shouldUpperCase: shouldUpperCase,
          resizeGroup: resizeGroup,
        );

  @override
  TextStyle? style(BuildContext context) => Theme.of(context).textTheme.labelLarge;
}

abstract class TextWidget extends StatelessWidget {
  final String text;
  final List<String>? args;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? maxFontSize, minFontSize;
  final bool? shouldUpperCase, shouldAutoResize, shouldTranslate, shouldBeCopyable;
  final String? copyConfirmationText;
  final AutoSizeGroup? resizeGroup;
  final TextStyle? styles;
  final double? fontSizeMultiplier;

  TextStyle? style(BuildContext context);

  TextWidget(
    this.text, {
    this.shouldTranslate,
    this.shouldAutoResize,
    this.shouldBeCopyable,
    this.resizeGroup,
    this.fontSizeMultiplier,
    this.copyConfirmationText,
    this.minFontSize,
    this.maxFontSize,
    this.styles,
    this.overflow,
    this.maxLines,
    this.args,
    this.textAlign = TextAlign.start,
    this.shouldUpperCase,
    Key? key,
  }) : super(key: key);

  bool get _shouldTranslate => shouldTranslate ?? false;

  bool get _shouldUpperCase => shouldUpperCase ?? false;

  bool get _shouldAutoResize => shouldAutoResize ?? false;

  bool get _shouldBeCopyable => shouldBeCopyable ?? false;

  @override
  Widget build(BuildContext context) {
    final _translations = Translations.of(context);
    var translatedText =
        _shouldTranslate && _translations != null ? _translations.textWithArgs(text, args ?? []) : text;
    var formattedText = _shouldUpperCase ? translatedText.toUpperCase() : translatedText;
    // var _overflow =
    // overflow != null ? overflow : DefaultTextStyle.of(context).overflow;
    var _styles = styles == null ? style(context) : style(context)?.merge(styles);

    late Widget _text;
    // This will auto
    if (_shouldAutoResize) {
      _text = AutoSizeText(
        formattedText,
        overflow: overflow,
        style: _styles,
        textAlign: textAlign,
        maxLines: maxLines,
        group: resizeGroup,
        maxFontSize: maxFontSize ?? _styles!.fontSize!,
        minFontSize: minFontSize ?? 10,
      );
    } else {
      _text = Text(
        formattedText,
        overflow: overflow,
        style: _styles,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    if (_shouldBeCopyable) {
      return GestureDetector(
        child: _text,
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: formattedText));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(copyConfirmationText ?? 'Text Copied!')));
        },
      );
    }

    return _text;
  }
}
