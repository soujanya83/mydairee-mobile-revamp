import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_list_model.dart';

enum DeletionStatus { initial, inProgress, success, failure }

class AnnounceListState extends Equatable {
  const AnnounceListState();

  @override
  List<Object> get props => [];
}

class AnnounceListInitial extends AnnounceListState {}

class AnnounceListLoading extends AnnounceListState {}

class AnnounceListError extends AnnounceListState {
  final String message;

  const AnnounceListError({required this.message});

  @override
  List<Object> get props => [message];
}

class AnnounceListLoaded extends AnnounceListState {
  final AnnouncementsListModel announcementData;

  const AnnounceListLoaded({
    required this.announcementData,
  });

  @override
  List<Object> get props => [announcementData];
}

class AnnouncementDeletedState extends AnnounceListState {
  final String message;
  
  const AnnouncementDeletedState({required this.message});
  
  @override
  List<Object> get props => [message];
}