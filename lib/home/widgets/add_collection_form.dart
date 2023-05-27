import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddCollectionForm extends StatefulWidget {
  const AddCollectionForm({required this.handleSubmit, super.key});

  final void Function(String value) handleSubmit;

  @override
  State<StatefulWidget> createState() => _AddCollectionForm();
}

class _AddCollectionForm extends State<AddCollectionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String newCollectionTitle = '';

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New collection'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  focusNode: _focusNode,
                  initialValue: newCollectionTitle,
                  onChanged: (String value) {
                    newCollectionTitle = value;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
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
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'CREATE COLLECTION',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              debugPrint(newCollectionTitle);
              widget.handleSubmit(newCollectionTitle);
              Navigator.pop(context);
            }
          },
        ),
      ],
    ).animate().scale(duration: const Duration(milliseconds: 200));
  }
}
