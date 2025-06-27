// Event
import 'package:equatable/equatable.dart';

abstract class ServiceDetailEvent extends Equatable {
  const ServiceDetailEvent();

  @override
  List<Object?> get props => [];
}

class SubmitServiceDetailEvent extends ServiceDetailEvent {
  final Map<String, dynamic> serviceData;
  const SubmitServiceDetailEvent({required this.serviceData});

  @override
  List<Object?> get props => [serviceData];
}
