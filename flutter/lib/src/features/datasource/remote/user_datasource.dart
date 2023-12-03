import 'package:injectable/injectable.dart';
import 'package:riada/src/features/datasource/base_datasource.dart';
import 'package:riada/src/features/datasource/exceptions/no_data_available_exception.dart';
import 'package:riada/src/features/entity/sport.dart';
import 'package:riada/src/features/entity/user.dart';

@injectable
class UserDataSource extends BaseDataSource {
  // MARK: - Public
  Future<void> createAnonymousUser(String userId) async {
    final User user = User.toDefault(id: userId);
    await userReference(userId).set(
      user.toJson(),
    );
  }

  Future<User> getUser(String userId) async {
    final document = await userCollection().doc(userId).get();
    final data = document.data() as Map<String, Object?>?;

    if (data == null) {
      throw NoDataAvailableException();
    }

    return User.fromJson(data);
  }

  Future<void> updateFavorites(List<Sport> sports) async {
    await userCollection().doc(user.id).set(user.toJson());
  }
}
