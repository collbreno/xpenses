import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class StringValidators {
  static FormFieldValidator<String?> isDouble({double? min, double? max}) =>
      (value) => _isDouble(value, min: min, max: max);
  static FormFieldValidator<String?> isInt() => (value) => _isInt(value);

  static FormFieldValidator<String?> exactLength(int length) =>
      (value) => _isExactLength(value, length);

  static FormFieldValidator<String?> notEmpty([String? errorText]) =>
      (value) => _isNotEmpty(value, errorText: errorText);

  static FormFieldValidator<String?> onlyAlphaNumeric() =>
      (value) => _isOnlyAlphaNumeric(value);

  static FormFieldValidator<String?> range({int? min, int? max}) =>
      (value) => _isInRange(value, min: min, max: max);

  static String? _isOnlyAlphaNumeric(String? value) {
    if (value == null || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Somente alfanuméricos';
    }
    return null;
  }

  static String? _isNotEmpty(String? value, {String? errorText}) {
    if (value == null || value.isEmpty) {
      return errorText ?? 'Obrigatório';
    }
    return null;
  }

  static String? _isExactLength(String? value, int length) {
    if (value == null || value.length != length) {
      return 'Deve possuir $length caracteres';
    }
    return null;
  }

  static String? _isInRange(
    String? value, {
    required int? min,
    required int? max,
  }) {
    if (value == null) {
      return 'Não pode ser nulo';
    }
    if (min != null && value.length < min) {
      return 'Deve possuir no mínimo $min caracteres';
    }
    if (max != null && value.length > max) {
      return 'Deve possuir no máximo $max caracteres';
    }
    return null;
  }

  static String? _isDouble(String? value, {double? min, double? max}) {
    if (value == null) {
      return 'Número inválido';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Número inválido';
    }
    if (min != null && min > parsed) {
      return 'Deve ser no mínimo $min';
    }
    if (max != null && max < parsed) {
      return 'Deve ser no máximo $min';
    }

    return null;
  }

  static String? _isInt(String? value) {
    if (value == null || int.tryParse(value) == null) {
      return 'Número inválido';
    }
    return null;
  }
}

extension StringValidatorsExt on FormFieldValidator<String?> {
  FormFieldValidator<String?> orEmpty() {
    return (value) => (value != null && value.isEmpty) ? null : this(value);
  }

  FormFieldValidator<String?> onlyAlphaNumeric() {
    return (value) => this(value) ?? StringValidators.onlyAlphaNumeric()(value);
  }
}
