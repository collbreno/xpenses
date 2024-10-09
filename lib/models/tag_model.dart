import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:xpenses/database/database.dart';

class Tag extends Equatable {
  final int id;
  final String name;
  final Color color;
  final String iconName;

  IconData? get icon => iconName.isEmpty ? null : iconMap[iconName];

  const Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.iconName,
  });

  Tag copy({
    String? name,
    Color? color,
    String? iconName,
  }) =>
      Tag(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        iconName: iconName ?? this.iconName,
      );

  @visibleForTesting
  Tag copyWithId(int id) => Tag(
        id: id,
        color: color,
        iconName: iconName,
        name: name,
      );

  Tag.fromTable(TagEntry entry)
      : id = entry.id,
        name = entry.name,
        color = Color(entry.colorCode),
        iconName = entry.iconName;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        iconName,
      ];
}
