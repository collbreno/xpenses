import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/route_params/tag_form_route_params.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class TagListPage extends StatelessWidget {
  const TagListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  void _loadList(BuildContext context) {
    context.read<EntityListCubit<Tag>>().load();
  }

  Widget _buildList(List<Tag> tags) {
    return Builder(builder: (context) {
      return RefreshIndicator(
        onRefresh: () async => _loadList(context),
        child: ListView.builder(
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            return ListTile(
              onTap: () {
                TagFormRoute(TagFormRouteParams(
                  onSaved: () => _loadList(context),
                  tag: tag,
                )).push(context);
              },
              title: TagChip.fromTag(tag),
            );
          },
        ),
      );
    });
  }
}
