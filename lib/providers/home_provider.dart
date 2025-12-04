import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/services/home_service.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref.watch(homeServiceProvider));
});

class HomeState {
  final List<RecentActivityItem> recentActivity;
  final Map<String, int> stats;
  final bool isLoading;

  HomeState({
    this.recentActivity = const [],
    this.stats = const {'characterCount': 0, 'itemCount': 0},
    this.isLoading = false,
  });

  HomeState copyWith({
    List<RecentActivityItem>? recentActivity,
    Map<String, int>? stats,
    bool? isLoading,
  }) {
    return HomeState(
      recentActivity: recentActivity ?? this.recentActivity,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeService _homeService;

  HomeNotifier(this._homeService) : super(HomeState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final activity = await _homeService.getRecentActivity();
      final stats = await _homeService.getGlobalStats();
      state = state.copyWith(
        recentActivity: activity,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
