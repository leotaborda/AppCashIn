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
      setState(() {}); // Atualiza lista
    }
  }

  void _toggleDone(TaskModel task) {
    _taskService.toggleTask(task);
    setState(() {});
  }

  void _removeTask(String id) {
    _taskService.deleteTask(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de texto com borda e sombra leve
            TextField(
              controller: _controller,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nova tarefa',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: AppColors.primary),
                  onPressed: _addTask,
                  tooltip: 'Adicionar tarefa',
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream: _taskService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  final tasks = snapshot.data ?? [];

                  if (tasks.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma tarefa ainda.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.border,
                    ),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        leading: Checkbox(
                          activeColor: AppColors.primary,
                          value: task.completed,
                          onChanged: (_) => _toggleDone(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: task.completed
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.alert,
                          ),
                          onPressed: () => _removeTask(task.id),
                          tooltip: 'Remover tarefa',
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
