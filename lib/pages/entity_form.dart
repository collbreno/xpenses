import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_form_cubit.dart';

class EntityForm<T> extends StatefulWidget {
  final List<FormField> formFields;
  final Widget? header;
  final AppBar appbar;
  const EntityForm({
    required this.formFields,
    required this.appbar,
    this.header,
    super.key,
  });

  @override
  State<EntityForm<T>> createState() => _EntityFormState<T>();
}

class _EntityFormState<T> extends State<EntityForm<T>> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntityFormCubit<T>, EntityFormState>(
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.loading,
          child: Scaffold(
            appBar: widget.appbar,
            body: GestureDetector(
              onTap: _unfocus,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: state.loading ? null : 0,
                  ),
                  if (widget.header != null) widget.header!,
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: widget.formFields,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: state.loading ? null : _save,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _save() {
    _unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<EntityFormCubit<T>>().save();
    }
  }
}
