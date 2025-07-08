import 'package:flutter/material.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart'; 

abstract class HeadChecksState {}

class HeadChecksInitial extends HeadChecksState {}

class HeadChecksLoading extends HeadChecksState {}

class HeadChecksLoaded extends HeadChecksState { 
  final int currentCenterIndex; 
  final int currentRoomIndex;
  final DateTime date;
  final List<HeadCheckData> headChecks;
  final String userId;

  HeadChecksLoaded({ 
    required this.currentCenterIndex, 
    required this.currentRoomIndex,
    required this.date,
    required this.headChecks,
    this.userId = '',
  });

  HeadChecksLoaded copyWith({ 
    int? currentCenterIndex, 
    int? currentRoomIndex,
    DateTime? date,
    List<HeadCheckData>? headChecks,
    String? userId,
  }) {
    return HeadChecksLoaded( 
      currentCenterIndex: currentCenterIndex ?? this.currentCenterIndex, 
      currentRoomIndex: currentRoomIndex ?? this.currentRoomIndex,
      date: date ?? this.date,
      headChecks: headChecks ?? this.headChecks,
      userId: userId ?? this.userId,
    );
  }
}

class HeadChecksError extends HeadChecksState {
  final String message;

    HeadChecksError( {required this.message});
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