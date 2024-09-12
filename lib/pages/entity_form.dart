import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpenses/utils/focus_utils.dart';
import 'package:xpenses/utils/type_utils.dart';

class EntityForm extends StatefulWidget {
  final List<Widget> formFields;
  final Widget? header;
  final Widget appbarTitle;
  final FutureCallback onSave;
  final FutureCallback? onDelete;
  const EntityForm({
    required this.formFields,
    required this.appbarTitle,
    required this.onSave,
    this.onDelete,
    this.header,
    super.key,
  });

  @override
  State<EntityForm> createState() => _EntityFormState();
}

class _EntityFormState<T> extends State<EntityForm> {
  late final GlobalKey<FormState> _formKey;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: widget.appbarTitle,
          actions: [
            if (widget.onDelete != null)
              IconButton(
                onPressed: _delete,
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: FocusUtils.unfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: _isLoading ? null : 0,
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
                  onPressed: _isLoading ? null : _save,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _delete() async {
    FocusUtils.unfocus();
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.onDelete!();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      rethrow;
    }
  }

  void _save() async {
    FocusUtils.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await widget.onSave();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        rethrow;
      }
    }
  }
}
