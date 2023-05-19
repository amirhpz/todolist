import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/screens/edit/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().onSavedChangesClicked();
            Navigator.of(context).pop();
          },
          label: Row(
            children: const [
              Text('Save Changes'),
              SizedBox(width: 4),
              Icon(CupertinoIcons.check_mark_circled_solid),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        label: 'High',
                        color: highPriority,
                        isSelected: priority == Priority.high,
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.high);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        label: 'Normal',
                        color: normalPriority,
                        isSelected: priority == Priority.normal,
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.normal);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                          label: 'Low',
                          color: lowPriority,
                          isSelected: priority == Priority.low,
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Priority.low);
                          }),
                    ),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) =>
                  context.read<EditTaskCubit>().onTextChanged(value),
              decoration: InputDecoration(
                label: const Text('Add a task for today ...'),
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .apply(fontSizeFactor: 1.2),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 10,
              bottom: 10,
              top: 10,
              child: _CheckBoxShape(
                value: isSelected,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const _CheckBoxShape({super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary, size: 14)
          : null,
    );
  }
}
