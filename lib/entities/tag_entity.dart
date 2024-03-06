import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  int id = 0;

  String name;

  @Transient()
  Color color;
  int get colorCode => color.value;
  set colorCode(int code) => color = Color(code);

  Tag({required this.name, this.color = Colors.grey});
}
