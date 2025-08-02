abstract class HeadChecksEvent {}

class LoadHeadChecksInitial extends HeadChecksEvent {
  final String userId;
  final String centerId;
  final String? roomId;
  final DateTime date;

  LoadHeadChecksInitial({
    required this.userId,
    required this.centerId,
    this.roomId,
    required this.date,
  });
}