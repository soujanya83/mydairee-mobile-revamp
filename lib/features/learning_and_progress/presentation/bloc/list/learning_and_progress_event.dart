abstract class LearningAndProgressEvent {}

class FetchChildrenEvent extends LearningAndProgressEvent {
  final String centerId;
  FetchChildrenEvent({required this.centerId});
}

class DeleteChildrenEvent extends LearningAndProgressEvent {
  final List<String> childIds;
  final String centerId;
  DeleteChildrenEvent(this.childIds, this.centerId);
}