import 'package:dates_api/dates_api.dart';
import 'package:cozy_world/data/exceptions/data_exception.dart';
import 'package:strings_api/data_strings_repository.dart';
import 'package:cozy_world/domain/constants/relationship_ids.dart';
import 'package:cozy_world/domain/repositories/i_relationship_dates_repository.dart';

/// Реализация [IRelationshipDatesRepository] поверх статического источника дат.
class RelationshipDateRepositoryImpl implements IRelationshipDatesRepository {
  final IDatesDatasource _dateSource;
  final DataStringsRepository _strings;

  RelationshipDateRepositoryImpl(this._dateSource, this._strings);

  @override
  /// Дата по доменному идентификатору [id].
  Future<DateTime> getDateById(String id) async {
    final dates = await _dateSource.fetchDates();
    if (id == RelationshipIds.relationship) {
      return dates[RelationshipIds.relationship]!;
    } else if (id == RelationshipIds.acquaintance) {
      return dates[RelationshipIds.acquaintance]!;
    } else {
      throw UnknownIdException(_strings.idNotFound(id));
    }
  }

  @override
  /// Все стартовые даты отношений из источника данных.
  Future<Map<String, DateTime>> getStartDates() async {
    return _dateSource.fetchDates();
  }
}
