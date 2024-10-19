class EntityNotFoundException implements Exception {
  @override
  String toString() {
    return 'Entity not found';
  }
}
