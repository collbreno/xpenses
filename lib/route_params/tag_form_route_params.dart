import 'package:flutter/material.dart';
import 'package:xpenses/models/tag_model.dart';

class TagFormRouteParams {
  final Tag? tag;
  final VoidCallback onSaved;

  TagFormRouteParams({
    required this.tag,
    required this.onSaved,
  });
}
