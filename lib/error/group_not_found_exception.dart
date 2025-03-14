class GroupNotFoundException implements Exception {
  final String message;

  const GroupNotFoundException(this.message);

  @override
  String toString() => message;
}
