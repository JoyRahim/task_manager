import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/controllers/nav_bar_task_provider.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NavBarTaskProvider>(context, listen: false).getAllProgressTasks();
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
              visible: navBarTaskProvider.getProgressTaskInProgress == false,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: navBarTaskProvider.progressTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: navBarTaskProvider.progressTaskList[index],
                    refreshParent: () {
                      context.read<NavBarTaskProvider>().getAllProgressTasks();
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
