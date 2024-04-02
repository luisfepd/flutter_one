import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/enums.dart';
import '../../../../../domain/models/media/media.dart';
import '../../../../../domain/models/performer/performer.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState.loading(TimeWindow timeWindow) = HomeStateLoading;
  factory HomeState.failed(TimeWindow timeWindow) = HomeStateFailed;
  factory HomeState.loaded({
    required TimeWindow timeWindow,
    required List<Media> moviesAndSeries,
    required List<Performer> performers,
  }) = HomeStateLoaded;
}
