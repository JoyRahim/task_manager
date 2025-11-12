import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/controllers/nav_bar_task_provider.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NavBarTaskProvider>(context, listen: false).getAllCancelledTasks();
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
              visible: navBarTaskProvider.getCancelledTaskInProgress == false,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: navBarTaskProvider.cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: navBarTaskProvider.cancelledTaskList[index],
                    refreshParent: () {
                      context.read<NavBarTaskProvider>().getAllCancelledTasks();
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
