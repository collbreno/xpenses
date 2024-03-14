import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntityListCubit<Tag>>(
      create: (context) => EntityListCubit<Tag>(
        context.read<Box<Tag>>().getAllAsync,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tags')),
        body: BlocBuilder<EntityListCubit<Tag>, AsyncData<List<Tag>>>(
          builder: (context, state) {
            if (state.isLoading) {
              return _buildLoading();
            } else if (state.hasError) {
              return _buildError(state.error!);
            } else if (state.hasData) {
              if (state.data!.isEmpty) {
                return _buildEmptyList();
              } else {
                return _buildList(state.data!);
              }
            } else {
              throw ArgumentError(
                'The $AsyncData state of ${EntityListCubit<Tag>} is invalid.',
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyList() {
    return const Center(child: Text('Nenhum item'));
  }

  Widget _buildError(Object error) {
    return const Center(child: Text('Algo deu errado'));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<Tag> tags) {
    return Builder(builder: (context) {
      return RefreshIndicator(
        onRefresh: () => context.read<EntityListCubit<Tag>>().loadData(),
        child: ListView.builder(
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            return ListTile(
              title: TagChip(
                color: tag.color,
                text: tag.name,
                icon: tag.icon,
              ),
            );
          },
        ),
      );
    });
  }
}
