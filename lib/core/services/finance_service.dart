import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/finance_model.dart';

class FinanceService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('finance');

  Stream<List<FinanceModel>> getAllMonths() {
    return _collection
        .orderBy('monthNumber') // <-- ordena corretamente
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          FinanceModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> saveMonth(FinanceModel model) async {
    await _collection.doc(model.id).set(model.toMap());
  }

  Future<void> createInitialMonthsIfNeeded() async {
    final existing = await _collection.get();
    if (existing.docs.isEmpty) {
      final months = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro',
      ];

      for (var i = 0; i < months.length; i++) {
        await _collection.add({
          'month': months[i],
          'monthNumber': i + 1,
          'invested': 0.0,
          'saved': 0.0,
          'personal': 0.0,
        });
      }
    }
  }

}
