import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xpenses/database/database.dart';

import '../fixtures/tag_fixture.dart';

void main() {
  late TagFixture tagFix;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tagFix = TagFixture();
  });

  tearDown(() async {
    await db.close();
  });

  group('Tags', () {
    test('writing tag', () async {
      var result = await db.select(db.tagTable).get();
      expect(result, isEmpty);

      final tag = tagFix.tag1;
      await db.addTag(tag);
      result = await db.select(db.tagTable).get();
      expect(result, hasLength(1));

      final fromDb = result.single;
      expect(fromDb.colorCode, tag.color.value);
      expect(fromDb.name, tag.name);
      expect(fromDb.iconName, tag.iconName);
      expect(fromDb.id, 1);
    });

    test('reading tags', () async {
      var result = await db.getAllTags();
      expect(result, isEmpty);

      final tag1 = tagFix.tag1;
      final tag2 = tagFix.tag2;
      await db.addTag(tag1);
      result = await db.getAllTags();

      expect(result, hasLength(1));
      expect(result, [tag1.copyWithId(1)]);

      await db.addTag(tag2);
      result = await db.getAllTags();

      expect(result, hasLength(2));
      expect(result, [tag1.copyWithId(1), tag2.copyWithId(2)]);
    });
  });
}
