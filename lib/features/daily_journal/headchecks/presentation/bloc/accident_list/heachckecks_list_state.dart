import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart';

abstract class HeadChecksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HeadChecksInitial extends HeadChecksState {}

class HeadChecksLoading extends HeadChecksState {}

class HeadChecksLoaded extends HeadChecksState {
  final HeadCheckListModel headCheckList;
  HeadChecksLoaded(this.headCheckList);

  @override
  List<Object?> get props => [headCheckList];
}

class HeadChecksError extends HeadChecksState {
  final String message;
  HeadChecksError({required this.message});

  @override
  List<Object?> get props => [message];
}
class HeadCheckData {
  final String hour;
  final String minute;
  final TextEditingController headCountController;
  final TextEditingController signatureController;
  final TextEditingController commentsController;

  HeadCheckData({
    required this.hour,
    required this.minute,
    required this.headCountController,
    required this.signatureController,
    required this.commentsController,
  });

  factory HeadCheckData.fromModel(HeadCheckModel model) {
    final time = model.time.split(':');
    return HeadCheckData(
      hour: time[0],
      minute: time[1],
      headCountController: TextEditingController(text: model.headCount),
      signatureController: TextEditingController(text: model.signature),
      commentsController: TextEditingController(text: model.comments),
    );
  }

  HeadCheckData copyWith({
    String? hour,
    String? minute,
    TextEditingController? headCountController,
    TextEditingController? signatureController,
    TextEditingController? commentsController,
  }) {
    return HeadCheckData(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      headCountController: headCountController ?? this.headCountController,
      signatureController: signatureController ?? this.signatureController,
      commentsController: commentsController ?? this.commentsController,
    );
  }
}