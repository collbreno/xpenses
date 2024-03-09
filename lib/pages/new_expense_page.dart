import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/widgets/calculator.dart';
import 'package:xpenses/widgets/form_fields/date_form_field.dart';
import 'package:xpenses/widgets/form_fields/entity_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/form_fields/value_form_field.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntityListCubit<Tag>>(
      create: (context) => EntityListCubit(
        context.read<Box<Tag>>().getAllAsync,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Novo gasto'),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ValueFormField(),
                      DateFormField(),
                      StringFormField(maxLines: 3),
                      EntityFormField<Tag>(
                        checkPosition: Alignment.centerRight,
                        itemBuilder: (tag) => ListTile(
                          dense: true,
                          title: TagChip(
                            text: tag.name,
                            color: tag.color,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    child: Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
