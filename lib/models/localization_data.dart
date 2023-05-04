import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocalizationData extends Equatable {
  final List<Locale> supportedLocales;

  final Map<String, Map<String, dynamic>> _localizationData;

  Map<String, Map<String, dynamic>> get localizedData {
    return _localizationData;
  }

  const LocalizationData(this.supportedLocales, this._localizationData);

  @override
  List<Object?> get props => [...supportedLocales, ...localizedData.keys];
}
