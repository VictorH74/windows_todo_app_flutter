import 'package:flutter/material.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';

Widget changeThemeBottomSheet({
  required BuildContext context,
  required void Function(int themeColorIndex) onThemeSelect,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
          child: const Text('Select a theme'),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.generate(
              themeColors.length,
                  (index) => GestureDetector(
                onTap: () {
                  onThemeSelect(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    color: themeColors[index],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}