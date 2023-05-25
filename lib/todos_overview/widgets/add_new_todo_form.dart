import 'package:flutter/material.dart';

class FormContainer extends StatefulWidget {
  const FormContainer({
    required this.handleSubmit,
    super.key,
  });

  final void Function(String value) handleSubmit;

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fieldValue = '';

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).colorScheme.background,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const CircleBorder(),
                value: false,
                onChanged: (bool? value) {},
              ),
            ),
            Expanded(
              child: TextFormField(
                focusNode: _focusNode,
                initialValue: fieldValue,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    fieldValue = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                if (fieldValue.isEmpty) return;
                widget.handleSubmit(fieldValue);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.add_box,
                color: fieldValue.isEmpty ? Colors.white30 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
