import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/controllers/nav_bar_task_provider.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NavBarTaskProvider>(context, listen: false).getAllCompletedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<NavBarTaskProvider>(
            builder: (context, navBarTaskProvider, _) {
            return Visibility(
              visible: navBarTaskProvider.getCompletedTaskInProgress == false,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: navBarTaskProvider.completedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: navBarTaskProvider.completedTaskList[index],
                    refreshParent: () {
                      context.read<NavBarTaskProvider>().getAllCompletedTasks();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
              ),
            );
          }
        ),
      ),
    );
  }
}
