import 'package:flutter/material.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';

class AssessmentsScreen extends StatelessWidget {
  const AssessmentsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Center(
        child: Text(
          'Assessments Tab (Placeholder)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
