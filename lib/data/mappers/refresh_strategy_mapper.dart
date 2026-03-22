import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:ferry/ferry.dart';

/// Расширение преобразования [RefreshStrategy] в [FetchPolicy] Ferry.
extension RefreshStrategyMapper on RefreshStrategy {
  /// Политика Ferry, соответствующая текущей стратегии обновления.
  FetchPolicy toFerryPolicy() {
    return switch (this) {
      RefreshStrategy.refreshWithCache => FetchPolicy.CacheFirst,
      RefreshStrategy.forceRefresh => FetchPolicy.NetworkOnly,
      RefreshStrategy.refreshIfStale => FetchPolicy.CacheAndNetwork,
    };
  }
}
