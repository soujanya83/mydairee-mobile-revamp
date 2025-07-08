import 'package:flutter/material.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/heachckecks_list_state.dart';

abstract class HeadChecksEvent {}

class LoadHeadChecksInitial extends HeadChecksEvent {
  final String userId;

  LoadHeadChecksInitial({this.userId = ''});
}

class ChangeDateEvent extends HeadChecksEvent {
  final DateTime date;

  ChangeDateEvent({required this.date});
}

class AddHeadCheckEvent extends HeadChecksEvent {}

class RemoveHeadCheckEvent extends HeadChecksEvent {
  final int index;

  RemoveHeadCheckEvent(this.index);
}

class UpdateHeadCheckEvent extends HeadChecksEvent {
  final int index;
  final String hour;
  final String minute;

  UpdateHeadCheckEvent({required this.index, required this.hour, required this.minute});
}

class SaveHeadChecksEvent extends HeadChecksEvent {
  final String userId;
  final String roomId;
  final DateTime date;
  final List<HeadCheckData> headChecks;

  SaveHeadChecksEvent({
    required this.userId,
    required this.roomId,
    required this.date,
    required this.headChecks,
  });
}