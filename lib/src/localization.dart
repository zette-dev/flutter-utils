import 'dart:convert' show json;

import 'package:flutter/material.dart';

class Translations {
  Translations(this.locale);

  final Locale locale;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static Map<String, dynamic> _localizedValues = <String, dynamic>{};

  /// Used to translate a [key] in the current dictionary.
  String text(String key) {
    return _localizedValues[key] ?? '_$key';
  }

  /// Returns the text in the correct grammatical number.
  /// This method uses textWithArgs so remember to add arguments in the [singular] and [plural] params.
  String textWithCardinality(int length, String singular, String plural) {
    return textWithArgs(
      length == 1 ? singular : plural,
      [length.toString()],
    );
  }

  /// Used to translate a [key] but also to interpolate some arguments in the translation.
  ///
  /// Translation will have a set of markets identified by '$$s' which will then be replaced by the arguments.
  /// i.e.
  /// 'Welcome $$s, I see you are feeling $$s' with [textWithArgs('welcome', ['David', 'sad')]
  /// would return 'Welcome David, I see you are feeling sad'
  ///
  /// Please note that the arguments will NOT be localized and will replace the markers as they are passed.
  String textWithArgs(String key, List<String> args) {
    String text = _localizedValues[key];
    if (text == null) {
      return '_$key';
    }
    var marker = '\$\$s';
    int markerIndex = 0;
    for (var arg in args) {
      markerIndex = text.indexOf(marker);
      if (markerIndex != -1) {
        text = text.replaceFirst(marker, arg ?? '', markerIndex);
      }
    }
    return text;
  }

  static Future<Translations> load(
    Locale locale,
    TranslationsBundleLoader loader,
  ) async {
    Translations translations = Translations(locale);
    _localizedValues = await loader.loadTranslationsDictionary(locale);
    return translations;
  }

  String get currentLanguage => locale.languageCode;
}

/// Consider creating an abstract class TranslationsLoader for each implementation.
///
/// This loader gets the translations from the app bundle, but we could use firebase or any other.
abstract class TranslationsBundleLoader {
  TranslationsBundleLoader();
  Future<Map<String, dynamic>> loadTranslationsDictionary(Locale locale);
}

class FileTranslationsBundleLoader extends TranslationsBundleLoader {
  final BuildContext context;
  final String path;
  FileTranslationsBundleLoader(this.context, this.path) : super();

  @override
  Future<Map<String, dynamic>> loadTranslationsDictionary(Locale locale) async {
    var bundle = DefaultAssetBundle.of(context);
    String jsonContent = await bundle.loadString(
        '$path/i18n_${locale.languageCode}_${locale.countryCode}.json');
    return json.decode(jsonContent);
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  final BuildContext context;
  final TranslationsBundleLoader bundleLoader;
  final List<Locale> supportedLanguages;
  const TranslationsDelegate(this.context, this.bundleLoader,
      {this.supportedLanguages});

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages?.contains(locale) ?? false;

  @override
  Future<Translations> load(Locale locale) =>
      Translations.load(locale, bundleLoader);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
