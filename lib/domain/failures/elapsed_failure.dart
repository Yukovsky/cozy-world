abstract class ElapsedFailure {
  String get message;
}

class GetElapsedFailure implements ElapsedFailure {
  @override
  final String message;
  GetElapsedFailure(this.message);
}
