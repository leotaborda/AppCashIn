import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class TaskService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('tasks');

  Stream<List<TaskModel>> getTasks() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> addTask(String title) async {
    await _collection.add({
      'title': title,
      'completed': false,
    });
  }

  Future<void> toggleTask(TaskModel task) async {
    await _collection.doc(task.id).update({
      'completed': !task.completed,
    });
  }

  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete();
  }
}
