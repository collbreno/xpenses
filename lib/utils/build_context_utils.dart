import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextUtilsExt on BuildContext {
  void dismissDialog() => pop();
}
