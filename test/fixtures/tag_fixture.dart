import 'package:flutter/material.dart';
import 'package:xpenses/models/tag_model.dart';

class TagFixture {
  final tag1 = Tag(
    id: 0,
    name: 'Tag 1',
    color: Color(Colors.green.value),
    iconName: 'abTesting',
  );

  final tag2 = Tag(
    id: 0,
    name: 'Tag 2',
    color: Color(Colors.blue.value),
    iconName: 'car',
  );
}
