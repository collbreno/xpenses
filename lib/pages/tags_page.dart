import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  late List<Tag> _tags;

  @override
  void initState() {
    super.initState();
    _tags = context.read<Box<Tag>>().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: _tags.isEmpty
          ? const Center(
              child: Text('Nenhuma tag'),
            )
          : ListView.builder(
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                final tag = _tags[index];
                return ListTile(
                  title: TagChip(
                    color: tag.color,
                    text: tag.name,
                  ),
                );
              },
            ),
    );
  }
}
