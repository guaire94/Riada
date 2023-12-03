import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:riada/src/features/entity/sport.dart';
import 'package:riada/src/features/presentation/onboarding/item/sport_item.dart';
import 'package:riada/src/features/repository/auth_repository.dart';
import 'package:riada/src/features/repository/sport_repository.dart';
import 'package:riada/src/features/repository/user_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  // MARK: - Dependencies
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SportRepository _sportRepository;

  // MARK: - Properties
  List<SportItem> _items = [];
  List<Sport> _favorites = [];

  // MARK: - LifeCycle
  OnBoardingBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required SportRepository sportRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _sportRepository = sportRepository,
        super(LoadingState()) {
    on<LoadEvent>((event, emit) async {
      try {
        await _authRepository.signInAnonymously();
        final sports = await _sportRepository.getSports();
        final user = await _userRepository.getCurrentUser();
        _items = sports
            .map(
              (sport) => SportItem(
                sport: sport,
                isFavorite: user.favoriteSports.contains(sport.id),
              ),
            )
            .toList();
        emit(IdleState(
          sportItems: _items,
        ));
      } catch (_) {
        emit(ErrorState());
      }
    });

    on<UpdateFavoriteEvent>((event, emit) async {
      if (event.item.isFavorite) {
        _favorites.remove(event.item.sport);
        _items = _items.map((item) {
          if (event.item.sport == item.sport) {
            return SportItem(sport: item.sport, isFavorite: false);
          }
          return item;
        }).toList();
      } else {
        _favorites.add(event.item.sport);
        _items = _items.map((item) {
          if (event.item.sport == item.sport) {
            return SportItem(sport: item.sport, isFavorite: true);
          }
          return item;
        }).toList();
      }
      emit(IdleState(sportItems: _items));
    });

    on<ConfirmEvent>((event, emit) async {
      emit(LoadingState());
      _userRepository.updateFavorites(_favorites);
      emit(SuccessState());
    });
  }
}
