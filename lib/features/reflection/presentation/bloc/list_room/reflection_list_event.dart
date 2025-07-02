abstract class ReflectionListEvent {}

class FetchReflectionsEvent extends ReflectionListEvent {
  final String centerId;
  final String? search;
  final String? status;
  final String? added;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String>? authors;
  final List<String>? children;
  final int page;

  FetchReflectionsEvent({
    required this.centerId,
    this.search,
    this.status,
    this.added,
    this.fromDate,
    this.toDate,
    this.authors,
    this.children,
    this.page = 1,
  });
}

class DeleteSelectedReflectionsEvent extends ReflectionListEvent {
  final List<String> reflectionIds;
  final String centerId;

  DeleteSelectedReflectionsEvent(this.reflectionIds, this.centerId);
}