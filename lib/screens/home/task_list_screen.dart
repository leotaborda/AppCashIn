import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  final TaskService _taskService = TaskService();

  void _addTask() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await _taskService.addTask(text);
      _controller.clear();
    }
  }

  void _toggleDone(TaskModel task) {
    _taskService.toggleTask(task);
  }

  void _removeTask(String id) {
    _taskService.deleteTask(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nova tarefa',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream: _taskService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data ?? [];

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma tarefa ainda.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (_) => _toggleDone(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTask(task.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
