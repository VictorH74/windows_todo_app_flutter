import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/home/bloc/home_bloc.dart';

class AddCollectionForm extends StatefulWidget {
  const AddCollectionForm({required this.handleSubmit, super.key});

  final void Function(String value) handleSubmit;

  @override
  State<StatefulWidget> createState() => _AddCollectionForm();
}

class _AddCollectionForm extends State<AddCollectionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String newCollectionTitle = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New list'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: newCollectionTitle,
                  onChanged: (String value) {
                    newCollectionTitle = value;
                  },
                  validator: (String? value) {
                    if (newCollectionTitle == '') {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Create list'),
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              debugPrint(newCollectionTitle);
              widget.handleSubmit(newCollectionTitle);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
