import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.editTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final isTicked = habitCompleted;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              // Settings option
              SlidableAction(
                  onPressed: editTapped,
                  backgroundColor: Colors.grey.shade800,
                  icon: Icons.edit,
                borderRadius: BorderRadius.circular(12),
              ),

              // Delete option
              SlidableAction(
                onPressed: deleteTapped,
                backgroundColor: Colors.red.shade400,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(12),
              )
            ],
          ),
          child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isTicked
                    ? Colors.green // Primary color when checked
                    : (isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                  children: [
                    // check box
                    Checkbox(
                      value: habitCompleted,
                      onChanged: onChanged,
                      activeColor: Colors.green,
                    ),

                    // habit name
                    Text(habitName),
                  ]

              )
          )
      ),
    );
  }

}