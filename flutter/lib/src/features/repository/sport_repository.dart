import 'package:injectable/injectable.dart';
import 'package:riada/src/features/datasource/remote/sport_datasource.dart';
import 'package:riada/src/features/entity/sport.dart';

@injectable
class SportRepository {
  // MARK: - Dependencies
  final SportDataSource _sportDataSource;

  // MARK: - LifeCycle
  SportRepository({
    required SportDataSource sportDataSource,
  })  : _sportDataSource = sportDataSource,
        super();

  // MARK: - Public
  Future<List<Sport>> getSports() {
    return _sportDataSource.getSports();
  }
}
