import 'package:cozy_world/domain/constants/dirty_key_constants.dart';
import 'package:cozy_world/domain/entities/dirty_key.dart';

/// Утилита для генерации стабильного тега страницы категории.
abstract class PageId {
  /// Тег контроллера категории по [category] и строковому флагу [read].
  static String getPageId(String category, String read) {
    final bool? readBool = read.toLowerCase() == DirtyKeyConstants.trueLiteral
        ? true
        : (read.toLowerCase() == DirtyKeyConstants.falseLiteral ? false : null);
    return DirtyKey(category, readBool).toTag();
  }
}
