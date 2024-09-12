import 'package:flutter/material.dart';

abstract class FocusUtils {
  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
