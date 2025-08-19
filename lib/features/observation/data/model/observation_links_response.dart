class ObservationLinksResponse {
  final bool status;
  final List<dynamic> observations;
  final List<int> linkedIds;
  final List<dynamic> linkedObjects;

  ObservationLinksResponse({
    required this.status,
    required this.observations,
    required this.linkedIds,
    required this.linkedObjects,
  });

  factory ObservationLinksResponse.fromJson(Map<String, dynamic> json) {
    final linkedObjs = json['linked_ids'] as List? ?? [];
    final linkedIds = linkedObjs
        .map((e) => e['linkid'])
        .where((id) => id != null)
        .map((id) => id is int ? id : int.tryParse(id.toString()) ?? 0)
        .where((id) => id != 0)
        .toList();

    return ObservationLinksResponse(
      status: json['status'] ?? false,
      observations: json['observations'] ?? [],
      linkedIds: linkedIds,
      linkedObjects: linkedObjs,
    );
  }
}