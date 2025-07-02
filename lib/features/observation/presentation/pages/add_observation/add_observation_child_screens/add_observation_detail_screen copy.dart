import 'package:flutter/material.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';

class AddObservationDetailsScreen extends StatefulWidget {
  final String type;
  final String centerId;

  const AddObservationDetailsScreen({
    Key? key,
    required this.type,
    required this.centerId,
  }) : super(key: key);

  @override
  State<AddObservationDetailsScreen> createState() =>
      _AddObservationDetailsScreenState();
}

class _AddObservationDetailsScreenState extends State<AddObservationDetailsScreen> { 

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Add Observation Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
