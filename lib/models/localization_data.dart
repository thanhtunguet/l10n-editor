import 'package:l10n_manipulator/models/app_locale.dart';

class LocalizationData {
  List<AppLocale> _supportedLocales;

  List<AppLocale> get supportedLocales {
    return _supportedLocales;
  }

  Map<String, Map<String, dynamic>> _localizationData;

  Map<String, Map<String, dynamic>> get localizedData {
    return _localizationData;
  }

  LocalizationData(this._supportedLocales, this._localizationData);

  set supportedLocales(List<AppLocale> supportedLocales) {
    _supportedLocales = supportedLocales;
  }
}
