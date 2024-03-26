// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'entities/expense_entity.dart';
import 'entities/tag_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 5385091276152244694),
      name: 'Tag',
      lastPropertyId: const obx_int.IdUid(4, 7767785884469948146),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1808312684272764500),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5111682822967867776),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2957705462550479313),
            name: 'colorCode',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7767785884469948146),
            name: 'iconName',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 7081710124624419521),
      name: 'Expense',
      lastPropertyId: const obx_int.IdUid(4, 4919072298255371102),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7897364243912476803),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8694477417806647715),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4195130867879873794),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4919072298255371102),
            name: 'cents',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[
        obx_int.ModelRelation(
            id: const obx_int.IdUid(1, 8224907355454183699),
            name: 'tags',
            targetId: const obx_int.IdUid(1, 5385091276152244694))
      ],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(2, 7081710124624419521),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(1, 8224907355454183699),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Tag: obx_int.EntityDefinition<Tag>(
        model: _entities[0],
        toOneRelations: (Tag object) => [],
        toManyRelations: (Tag object) => {},
        getId: (Tag object) => object.id,
        setId: (Tag object, int id) {
          object.id = id;
        },
        objectToFB: (Tag object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final iconNameOffset = object.iconName == null
              ? null
              : fbb.writeString(object.iconName!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.colorCode);
          fbb.addOffset(3, iconNameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final iconNameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 10);
          final object = Tag(name: nameParam, iconName: iconNameParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..colorCode =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);

          return object;
        }),
    Expense: obx_int.EntityDefinition<Expense>(
        model: _entities[1],
        toOneRelations: (Expense object) => [],
        toManyRelations: (Expense object) =>
            {obx_int.RelInfo<Expense>.toMany(1, object.id): object.tags},
        getId: (Expense object) => object.id,
        setId: (Expense object, int id) {
          object.id = id;
        },
        objectToFB: (Expense object, fb.Builder fbb) {
          final descriptionOffset = fbb.writeString(object.description);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, descriptionOffset);
          fbb.addInt64(2, object.date.millisecondsSinceEpoch);
          fbb.addInt64(3, object.cents);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, '');
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = Expense(description: descriptionParam, date: dateParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..cents =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          obx_int.InternalToManyAccess.setRelInfo<Expense>(object.tags, store,
              obx_int.RelInfo<Expense>.toMany(1, object.id));
          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Tag] entity fields to define ObjectBox queries.
class Tag_ {
  /// see [Tag.id]
  static final id = obx.QueryIntegerProperty<Tag>(_entities[0].properties[0]);

  /// see [Tag.name]
  static final name = obx.QueryStringProperty<Tag>(_entities[0].properties[1]);

  /// see [Tag.colorCode]
  static final colorCode =
      obx.QueryIntegerProperty<Tag>(_entities[0].properties[2]);

  /// see [Tag.iconName]
  static final iconName =
      obx.QueryStringProperty<Tag>(_entities[0].properties[3]);
}

/// [Expense] entity fields to define ObjectBox queries.
class Expense_ {
  /// see [Expense.id]
  static final id =
      obx.QueryIntegerProperty<Expense>(_entities[1].properties[0]);

  /// see [Expense.description]
  static final description =
      obx.QueryStringProperty<Expense>(_entities[1].properties[1]);

  /// see [Expense.date]
  static final date =
      obx.QueryDateProperty<Expense>(_entities[1].properties[2]);

  /// see [Expense.cents]
  static final cents =
      obx.QueryIntegerProperty<Expense>(_entities[1].properties[3]);

  /// see [Expense.tags]
  static final tags =
      obx.QueryRelationToMany<Expense, Tag>(_entities[1].relations[0]);
}
