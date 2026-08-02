import 'package:flutter/services.dart';

/// Předá text systémovému výběru aplikací.
///
/// Odpovídající Kotlin kód: `android/app/src/main/kotlin/cz/kotva/SharePlugin.kt`.
/// Aplikace zprávu **nikdy neodesílá sama** — jen ji připraví a nechá uživatele
/// vybrat, komu a čím ji pošle (docs/spec.md §11).
class ShareChannel {
  const ShareChannel();

  static const _channel = MethodChannel('cz.kotva/share');

  Future<void> shareText(String text, {String? title}) async {
    try {
      await _channel.invokeMethod<void>('shareText', {
        'text': text,
        'title': title,
      });
    } on MissingPluginException {
      // Platforma bez implementace (zatím iOS, testy).
    } on PlatformException {
      // Uživatel nemá žádnou aplikaci pro sdílení textu — nic se neděje,
      // zprávu má pořád na obrazovce a může ji zkopírovat.
    }
  }

  /// Předá soubor systémovému výběru — použité pro export dat
  /// (docs/spec.md §9, akceptační kritérium §14).
  ///
  /// Na rozdíl od [shareText] se selhání **nepolyká**: export je akce, jejíž
  /// výsledek uživatel očekává v jiné aplikaci. Kdyby se sdílení nezdařilo
  /// potichu, myslel by si, že data má, a přitom by neměl nic.
  Future<void> shareFile(String path, {String? title}) {
    return _channel.invokeMethod<void>('shareFile', {
      'path': path,
      'title': title,
    });
  }
}
