abstract class LearningAndProgressEvent {}

class FetchChildrenEvent extends LearningAndProgressEvent {
  final String centerId;
  final String roomId;
  FetchChildrenEvent({required this.centerId, required this.roomId});
}

class DeleteChildrenEvent extends LearningAndProgressEvent {
  final List<String> childIds;
  final String centerId;
  final String roomId;
  DeleteChildrenEvent(this.childIds, this.centerId, this.roomId);
}