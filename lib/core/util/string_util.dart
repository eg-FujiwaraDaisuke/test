import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sprintf/sprintf.dart';

String i18nTranslate(
    BuildContext context,
    String key, [
      final args,
    ]) {
  if (args == null) {
    return FlutterI18n.translate(context, key);
  } else {
    if (args is List && args.isEmpty) {
      return FlutterI18n.translate(context, key);
    }
    return sprintf(
      FlutterI18n.translate(context, key),
      args is List ? args : [args],
    );
  }
}
