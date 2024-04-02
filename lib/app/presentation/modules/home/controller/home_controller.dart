import '../../../../domain/enums.dart';
import '../../../../domain/repositories/trending_repository.dart';
import '../../../global/state_notifier.dart';
import 'state/home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(super.state, {required this.trendingRepository});
  final TrendingRepository trendingRepository;

  Future<void> init() async {
    final result =
        await trendingRepository.getMoviesAndSeries(state.timeWindow);

    final performersResult =
        await trendingRepository.getPerformers(state.timeWindow);

    result.when(
      left: (_) {
        state = HomeState.failed(state.timeWindow);
      },
      right: (list) {
        performersResult.when(
          left: (_) {
            state = HomeState.failed(state.timeWindow);
          },
          right: (performers) {
            state = HomeState.loaded(
              timeWindow: state.timeWindow,
              moviesAndSeries: list,
              performers: performers,
            );
          },
        );
      },
    );
  }

  void changeTimeWindow(TimeWindow newTimeWindow) {
    state = state.copyWith(timeWindow: newTimeWindow);
    //notifyListeners();
  }
}
