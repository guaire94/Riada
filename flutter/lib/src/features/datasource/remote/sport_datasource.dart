import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:riada/src/features/datasource/base_datasource.dart';
import 'package:riada/src/features/datasource/exceptions/no_data_available_exception.dart';
import 'package:riada/src/features/entity/sport.dart';

@injectable
class SportDataSource extends BaseDataSource {
  // MARK: - Public
  Future<List<Sport>> getSports() async {
    Query query = await sportCollection();
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((sport) {
      final data = sport.data() as Map<String, dynamic>?;
      if (data == null) {
        throw NoDataAvailableException();
      }
      return Sport.fromJson(data);
    }).toList();
  }
}
