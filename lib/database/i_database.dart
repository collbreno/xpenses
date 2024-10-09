import 'package:xpenses/models/tag_model.dart';

abstract class IAppDatabase {
  Future<List<Tag>> getAllTags();
  Future<int> addTag(Tag model);
}
