class ObservationLinksResponse {
  final bool status;
  final List<dynamic> observations;
  final List<int> linkedIds;

  ObservationLinksResponse({
    required this.status,
    required this.observations,
    required this.linkedIds,
  });

  factory ObservationLinksResponse.fromJson(Map<String, dynamic> json) {
    return ObservationLinksResponse(
      status: json['status'] ?? false,
      observations: json['observations'] ?? [],
      linkedIds: (json['linked_ids'] as List?)?.map((e) => e as int).toList() ?? [],
    );
  }
}