import 'package:flutter/material.dart';
import 'package:xpenses/entities/tag_entity.dart';

class TagFormRouteParams {
  final Tag? tag;
  final VoidCallback onSaved;

  TagFormRouteParams({
    required this.tag,
    required this.onSaved,
  });
}
