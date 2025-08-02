import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/add_accident/add_accident_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/add_accident/add_accident_event.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/add_accident/add_accident_state.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/widget/add_accident_custom_widgets.dart';

class AddAccidentScreen extends StatefulWidget {
  final String centerid;
  final String roomid;
  final String accid;
  final String type;
  final Map<String, dynamic>? accident;

  const AddAccidentScreen({
    super.key,
    required this.centerid,
    required this.roomid,
    required this.accid,
    required this.type,
    this.accident,
  });

  @override
  _AddAccidentScreenState createState() => _AddAccidentScreenState();
}

class _AddAccidentScreenState extends State<AddAccidentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? name, positionRole;
  String? pHour, pMin;
  DateTime? recordDate;

  List<String>? hours;
  List<String>? minutes;

  Uint8List? person_signature;
  Uint8List? child_signature;
  String? addmark;

  bool abrasion = false,
      allergy = false,
      amputation = false,
      anaphylaxis = false,
      asthma = false,
      bite = false,
      broken = false,
      burn = false,
      choking = false,
      concussion = false,
      crush = false,
      cut = false,
      drowning = false,
      eye = false,
      electric = false,
      high = false,
      infectious = false,
      ingestion = false,
      internal = false,
      poisoning = false,
      rash = false,
      respiratory = false,
      seizure = false,
      sprain = false,
      stabbing = false,
      tooth = false,
      venomous = false,
      other = false;

  TextEditingController? cAge,
      witnessname,
      cactivity,
      ccause,
      ccsurrondings,
      ccunaccount,
      cclocked,
      cloc;
  DateTime? cDob;
  DateTime? cIncidentDate;
  DateTime? cIDate;
  String? cHour, cMin;
  String _gender = 'Male';

  TextEditingController? adetail, ayesdetails, afuture1, afuture2, afuture3;
  String _aEmergency = 'Yes';
  String _aAttention = 'Yes';

  TextEditingController? gName1, gContact1, gName2, gContact2;
  String? gHour1, gMin1;
  DateTime? gDate1;
  String? gHour2, gMin2;
  DateTime? gDate2;
  bool gContacted1 = false, gMsg1 = false;
  bool gContacted2 = false, gMsg2 = false;

  TextEditingController? nName,
      nSupervisorName,
      eAgency,
      eAuthority,
      paName,
      aNotes;
  String? nHour1,
      nMin1,
      nHour2,
      nMin2,
      eHour1,
      eMin1,
      eHour2,
      eMin2,
      paHour,
      paMin;
  DateTime? nDate1, nDate2, eDate1, eDate2, paDate;
  Uint8List? incharge_signature, supervisor_signature;
  bool childrensFetched = false;
  List<ChildIten> _allChildrens = [];
  String? selectedChildId;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    hours = List<String>.generate(24, (counter) => "${counter + 1}");
    minutes = List<String>.generate(60, (counter) => "$counter");

    pMin = minutes?[0];
    pHour = hours?[0];
    recordDate = DateTime.now();
    name = TextEditingController();
    positionRole = TextEditingController();

    witnessname = TextEditingController();
    cactivity = TextEditingController();
    cAge = TextEditingController();
    ccause = TextEditingController();
    ccsurrondings = TextEditingController();
    ccunaccount = TextEditingController();
    cclocked = TextEditingController();
    cloc = TextEditingController();

    cMin = minutes?[0];
    cHour = hours?[0];
    cDob = DateTime.now();
    cIncidentDate = DateTime.now();
    cIDate = DateTime.now();

    adetail = TextEditingController();
    ayesdetails = TextEditingController();
    afuture1 = TextEditingController();
    afuture2 = TextEditingController();
    afuture3 = TextEditingController();

    gName1 = TextEditingController();
    gName2 = TextEditingController();
    gContact1 = TextEditingController();
    gContact2 = TextEditingController();
    gMin1 = minutes?[0];
    gHour1 = hours?[0];
    gDate1 = DateTime.now();
    gMin2 = minutes?[0];
    gHour2 = hours?[0];
    gDate2 = DateTime.now();

    nName = TextEditingController();
    nSupervisorName = TextEditingController();
    nMin1 = minutes?[0];
    nHour1 = hours?[0];
    nMin2 = minutes?[0];
    nHour2 = hours?[0];
    nDate1 = DateTime.now();
    nDate2 = DateTime.now();

    eAgency = TextEditingController();
    eAuthority = TextEditingController();
    eMin1 = minutes?[0];
    eHour1 = hours?[0];
    eDate1 = DateTime.now();
    eMin2 = minutes?[0];
    eHour2 = hours?[0];
    eDate2 = DateTime.now();

    paName = TextEditingController();
    paMin = minutes?[0];
    paHour = hours?[0];
    paDate = DateTime.now();

    aNotes = TextEditingController();

    if (widget.type == 'edit' && widget.accident != null) {
      _initializeFields(widget.accident!);
    }
  }

  void _initializeFields(Map<String, dynamic> accident) {
    name?.text = accident['name'] ?? '';
    positionRole?.text = accident['positionRole'] ?? '';
    recordDate = accident['recordDate'] != null
        ? DateTime.parse(accident['recordDate'])
        : DateTime.now();
    pHour = accident['recordTimeHour'] ?? hours?[0];
    pMin = accident['recordTimeMinute'] ?? minutes?[0];
    person_signature = accident['personSignature'] != null
        ? base64Decode(accident['personSignature'])
        : null;

    selectedChildId = accident['childId'];
    cDob = accident['childDob'] != null
        ? DateTime.parse(accident['childDob'])
        : DateTime.now();
    cAge?.text = accident['childAge']?.toString() ?? '';
    _gender = accident['gender'] ?? 'Male';
    cIncidentDate = accident['incidentDate'] != null
        ? DateTime.parse(accident['incidentDate'])
        : DateTime.now();
    cHour = accident['incidentTimeHour'] ?? hours?[0];
    cMin = accident['incidentTimeMinute'] ?? minutes?[0];
    cloc?.text = accident['location'] ?? '';
    child_signature = accident['childSignature'] != null
        ? base64Decode(accident['childSignature'])
        : null;
    cIDate = accident['incidentDetailsDate'] != null
        ? DateTime.parse(accident['incidentDetailsDate'])
        : DateTime.now();
    witnessname?.text = accident['witnessName'] ?? '';
    cactivity?.text = accident['activity'] ?? '';
    ccause?.text = accident['cause'] ?? '';
    ccsurrondings?.text = accident['circumstances'] ?? '';
    ccunaccount?.text = accident['unaccountedDetails'] ?? '';
    cclocked?.text = accident['lockedDetails'] ?? '';

    final injuryTypes =
        (accident['injuryTypes'] as List<dynamic>?)?.cast<String>() ?? [];
    abrasion = injuryTypes.contains('Abrasion/Scrape');
    allergy = injuryTypes.contains('Allergic reaction');
    amputation = injuryTypes.contains('Amputation');
    anaphylaxis = injuryTypes.contains('Anaphylaxis');
    asthma = injuryTypes.contains('Asthma/Respiratory');
    bite = injuryTypes.contains('Bite Wound');
    broken = injuryTypes.contains('Broken Bone/Fracture/Dislocation');
    burn = injuryTypes.contains('Burn/Sunburn');
    choking = injuryTypes.contains('Choking');
    concussion = injuryTypes.contains('Concussion');
    crush = injuryTypes.contains('Crush/Jam');
    cut = injuryTypes.contains('Cut/Open Wound');
    drowning = injuryTypes.contains('Drowning (nonfatal)');
    eye = injuryTypes.contains('Eye Injury');
    electric = injuryTypes.contains('Electric Shock');
    high = injuryTypes.contains('High Temperature');
    infectious =
        injuryTypes.contains('Infectious Disease (inc gastrointestinal)');
    ingestion = injuryTypes.contains('Ingestion/Inhalation/Insertion');
    internal = injuryTypes.contains('Internal injury/Infection');
    poisoning = injuryTypes.contains('Poisoning');
    rash = injuryTypes.contains('Rash');
    respiratory = injuryTypes.contains('Respiratory');
    seizure = injuryTypes.contains('Seizure/unconscious/convulsion');
    sprain = injuryTypes.contains('Sprain/swelling');
    stabbing = injuryTypes.contains('Stabbing/piercing');
    tooth = injuryTypes.contains('Tooth');
    venomous = injuryTypes.contains('Venomous bite/sting');
    other = injuryTypes.contains('Other (please specify)');

    adetail?.text = accident['actionDetails'] ?? '';
    _aEmergency = accident['emergencyServices'] ?? 'Yes';
    ayesdetails?.text = accident['emergencyDetails'] ?? '';
    _aAttention = accident['medicalAttention'] ?? 'Yes';
    afuture1?.text = accident['medicalDetails1'] ?? '';
    afuture2?.text = accident['medicalDetails2'] ?? '';
    afuture3?.text = accident['medicalDetails3'] ?? '';

    gName1?.text = accident['guardian1Name'] ?? '';
    gContact1?.text = accident['guardian1Contact'] ?? '';
    gHour1 = accident['guardian1TimeHour'] ?? hours?[0];
    gMin1 = accident['guardian1TimeMinute'] ?? minutes?[0];
    gDate1 = accident['guardian1Date'] != null
        ? DateTime.parse(accident['guardian1Date'])
        : DateTime.now();
    gContacted1 = accident['guardian1Contacted'] ?? false;
    gMsg1 = accident['guardian1MessageLeft'] ?? false;

    gName2?.text = accident['guardian2Name'] ?? '';
    gContact2?.text = accident['guardian2Contact'] ?? '';
    gHour2 = accident['guardian2TimeHour'] ?? hours?[0];
    gMin2 = accident['guardian2TimeMinute'] ?? minutes?[0];
    gDate2 = accident['guardian2Date'] != null
        ? DateTime.parse(accident['guardian2Date'])
        : DateTime.now();
    gContacted2 = accident['guardian2Contacted'] ?? false;
    gMsg2 = accident['guardian2MessageLeft'] ?? false;

    nName?.text = accident['inChargeName'] ?? '';
    incharge_signature = accident['inChargeSignature'] != null
        ? base64Decode(accident['inChargeSignature'])
        : null;
    nHour1 = accident['inChargeTimeHour'] ?? hours?[0];
    nMin1 = accident['inChargeTimeMinute'] ?? minutes?[0];
    nDate1 = accident['inChargeDate'] != null
        ? DateTime.parse(accident['inChargeDate'])
        : DateTime.now();

    nSupervisorName?.text = accident['supervisorName'] ?? '';
    supervisor_signature = accident['supervisorSignature'] != null
        ? base64Decode(accident['supervisorSignature'])
        : null;
    nHour2 = accident['supervisorTimeHour'] ?? hours?[0];
    nMin2 = accident['supervisorTimeMinute'] ?? minutes?[0];
    nDate2 = accident['supervisorDate'] != null
        ? DateTime.parse(accident['supervisorDate'])
        : DateTime.now();

    eAgency?.text = accident['agency'] ?? '';
    eHour1 = accident['agencyTimeHour'] ?? hours?[0];
    eMin1 = accident['agencyTimeMinute'] ?? minutes?[0];
    eDate1 = accident['agencyDate'] != null
        ? DateTime.parse(accident['agencyDate'])
        : DateTime.now();

    aNotes?.text = accident['notes'] ?? '';
  }


///////
  ApiResponse<ChildModel?>? childrenData;
  final GlobalRepository repository = GlobalRepository();
  getChildren() async {
    // childrenData = await repository.getChildren(widget.centerid);
  }

  void _showChildDialog() async {
    final children = childrenData?.data?.data ?? [];

    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: children.map((child) => child.id).toList(),
        itemsName: children.map((child) => child.name).toList(),
        initiallySelectedIds: selectedChildId != null ? [selectedChildId!] : [],
        title: 'Select Child',
        onItemTap: (selectedIds) {
          setState(() {
            selectedChildId = selectedIds.isNotEmpty ? selectedIds[0] : null;

            final selectedChild = children.firstWhere(
              (child) => child.id == selectedChildId,
              orElse: () => ChildIten(id: '', name: ''),
            );

            currentIndex = children.indexOf(selectedChild);
            childrensFetched = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Add Accident"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Accident',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text('INCIDENT, INJURY, TRAUMA, & ILLNESS RECORD',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text('Details of person completing this record',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: name,
                  hintText: 'Name',
                  title: 'Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: positionRole,
                  hintText: 'Position Role',
                  title: 'Position Role',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Position Role' : null,
                ),
                const SizedBox(height: 16),
                CustomSignatureField(
                  title: 'Signature',
                  signature: person_signature,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignaturePage()),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          person_signature = value;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: recordDate,
                  onDateSelected: (date) => setState(() => recordDate = date),
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: pHour,
                  selectedMinute: pMin,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => pHour = val!),
                  onMinuteChanged: (val) => setState(() => pMin = val!),
                ),
                const SizedBox(height: 16),
                Text('Child Details',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showChildDialog,
                  child: Container(
                    width: 180,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Select Child',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedChildId != null)
                  Chip(
                    label: Text(
                      _allChildrens
                              .firstWhere(
                                (child) => child.id == selectedChildId,
                                orElse: () =>
                                    ChildIten(id: '', name: 'Unknown'),
                              )
                              .name ??
                          'Unknown',
                    ),
                    onDeleted: () {
                      setState(() {
                        selectedChildId = null;
                        childrensFetched = false;
                      });
                    },
                  ),
                const SizedBox(height: 12),
                CustomDatePicker(
                  title: 'Date of Birth',
                  selectedDate: cDob,
                  onDateSelected: (date) => setState(() => cDob = date),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: cAge,
                  hintText: 'Age',
                  title: 'Age',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter Age';
                    final n = int.tryParse(v);
                    if (n == null || n < 0) return 'Enter valid age';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('Gender', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                CustomDropdown(
                  height: 45,
                  value: _gender,
                  items: const ['Male', 'Female', 'Others'],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
                const SizedBox(height: 16),
                Text('Incident Details',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Incident Date',
                  selectedDate: cIncidentDate,
                  onDateSelected: (date) =>
                      setState(() => cIncidentDate = date),
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Incident Time',
                  selectedHour: cHour,
                  selectedMinute: cMin,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => cHour = val!),
                  onMinuteChanged: (val) => setState(() => cMin = val!),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: cloc,
                  hintText: 'Location',
                  title: 'Location',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Location' : null,
                ),
                const SizedBox(height: 12),
                CustomSignatureField(
                  title: 'Signature',
                  signature: child_signature,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignaturePage()),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          child_signature = value;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: cIDate,
                  onDateSelected: (date) => setState(() => cIDate = date),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: witnessname,
                  hintText: 'Witness Name',
                  title: 'Witness Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Witness Name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: cactivity,
                  hintText: 'Activity',
                  title:
                      'General activity at the time of incident/injury/trauma/illness',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Activity' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: ccause,
                  hintText: 'Cause',
                  title: 'Cause of injury/trauma',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Cause' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: ccsurrondings,
                  hintText: 'Circumstances',
                  title:
                      'Circumstances surrounding any illness, including apparent symptoms',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Circumstances' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: ccunaccount,
                  hintText: 'Details',
                  title:
                      'Circumstances if child appeared to be missing or otherwise unaccounted for',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Details' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: cclocked,
                  hintText: 'Details',
                  title:
                      'Circumstances if child was taken or locked in/out of service',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Details' : null,
                ),
                const SizedBox(height: 16),
                Text('Nature of Injury/Trauma/Illness',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccidentImage()),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          addmark = value;
                        });
                      }
                    });
                  },
                  child: Container(
                    height: addmark != null ? 100 : 45,
                    width: addmark != null ? 100 : double.infinity,
                    decoration: BoxDecoration(
                      // color: addmark != null
                      //     ? AppColors.primaryColor
                      //     : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: addmark != null
                              ? AppColors.primaryColor
                              : AppColors.primaryColor),
                    ),
                    child: addmark != null
                        ? Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(base64Decode(addmark!),
                                  height: 45, fit: BoxFit.contain),
                            ),
                          )
                        : const Center(child: Text('Tap to add/edit marks')),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: abrasion,
                      title: const Text('Abrasion/Scrape'),
                      onChanged: (val) => setState(() => abrasion = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: allergy,
                      title: const Text('Allergic reaction'),
                      onChanged: (val) => setState(() => allergy = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: amputation,
                      title: const Text('Amputation'),
                      onChanged: (val) => setState(() => amputation = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: anaphylaxis,
                      title: const Text('Anaphylaxis'),
                      onChanged: (val) => setState(() => anaphylaxis = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: asthma,
                      title: const Text('Asthma/Respiratory'),
                      onChanged: (val) => setState(() => asthma = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: bite,
                      title: const Text('Bite Wound'),
                      onChanged: (val) => setState(() => bite = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: broken,
                      title: const Text('Broken Bone/Fracture/Dislocation'),
                      onChanged: (val) => setState(() => broken = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: burn,
                      title: const Text('Burn/Sunburn'),
                      onChanged: (val) => setState(() => burn = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: choking,
                      title: const Text('Choking'),
                      onChanged: (val) => setState(() => choking = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: concussion,
                      title: const Text('Concussion'),
                      onChanged: (val) => setState(() => concussion = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: crush,
                      title: const Text('Crush/Jam'),
                      onChanged: (val) => setState(() => crush = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: cut,
                      title: const Text('Cut/Open Wound'),
                      onChanged: (val) => setState(() => cut = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: drowning,
                      title: const Text('Drowning (nonfatal)'),
                      onChanged: (val) => setState(() => drowning = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: eye,
                      title: const Text('Eye Injury'),
                      onChanged: (val) => setState(() => eye = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: electric,
                      title: const Text('Electric Shock'),
                      onChanged: (val) => setState(() => electric = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: high,
                      title: const Text('High Temperature'),
                      onChanged: (val) => setState(() => high = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: infectious,
                      title: const Text(
                          'Infectious Disease (inc gastrointestinal)'),
                      onChanged: (val) => setState(() => infectious = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: ingestion,
                      title: const Text('Ingestion/Inhalation/Insertion'),
                      onChanged: (val) => setState(() => ingestion = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: internal,
                      title: const Text('Internal injury/Infection'),
                      onChanged: (val) => setState(() => internal = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: poisoning,
                      title: const Text('Poisoning'),
                      onChanged: (val) => setState(() => poisoning = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: rash,
                      title: const Text('Rash'),
                      onChanged: (val) => setState(() => rash = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: respiratory,
                      title: const Text('Respiratory'),
                      onChanged: (val) => setState(() => respiratory = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: seizure,
                      title: const Text('Seizure/unconscious/convulsion'),
                      onChanged: (val) => setState(() => seizure = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: sprain,
                      title: const Text('Sprain/swelling'),
                      onChanged: (val) => setState(() => sprain = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: stabbing,
                      title: const Text('Stabbing/piercing'),
                      onChanged: (val) => setState(() => stabbing = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: tooth,
                      title: const Text('Tooth'),
                      onChanged: (val) => setState(() => tooth = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: venomous,
                      title: const Text('Venomous bite/sting'),
                      onChanged: (val) => setState(() => venomous = val!),
                    ),
                    CheckboxListTile(
                      fillColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      value: other,
                      title: const Text('Other (please specify)'),
                      onChanged: (val) => setState(() => other = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Action Taken',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: adetail,
                  hintText: 'Details',
                  title:
                      'Details of action taken (including first aid, administration of medication etc.)',
                  maxLines: 2,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Details' : null,
                ),
                const SizedBox(height: 12),
                Text('Did emergency services attend',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                CustomDropdown(
                  height: 45,
                  value: _aEmergency,
                  items: const ['Yes', 'No'],
                  onChanged: (val) => setState(() => _aEmergency = val!),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: ayesdetails,
                  hintText: 'Details',
                  title: 'If yes, provide details',
                  maxLines: 2,
                  validator: (v) =>
                      _aEmergency == 'Yes' && (v == null || v.isEmpty)
                          ? 'Enter Details'
                          : null,
                ),
                const SizedBox(height: 12),
                Text('Was medical attention sought',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                CustomDropdown(
                  height: 45,
                  value: _aAttention,
                  items: const ['Yes', 'No'],
                  onChanged: (val) => setState(() => _aAttention = val!),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: afuture1,
                  hintText: '1.',
                  title: 'Medical attention details 1',
                  validator: (v) =>
                      _aAttention == 'Yes' && (v == null || v.isEmpty)
                          ? 'Enter Details'
                          : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: afuture2,
                  hintText: '2.',
                  title: 'Medical attention details 2',
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: afuture3,
                  hintText: '3.',
                  title: 'Medical attention details 3',
                ),
                const SizedBox(height: 16),
                Text('Parent/Guardian Notifications',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: gName1,
                  hintText: 'Name',
                  title: '1. Parent/Guardian name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: gContact1,
                  hintText: 'Contact',
                  title: 'Method of Contact',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Contact' : null,
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: gHour1,
                  selectedMinute: gMin1,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => gHour1 = val!),
                  onMinuteChanged: (val) => setState(() => gMin1 = val!),
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: gDate1,
                  onDateSelected: (date) => setState(() => gDate1 = date),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                  value: gContacted1,
                  title: const Text('Contact Made'),
                  onChanged: (val) => setState(() => gContacted1 = val!),
                ),
                CheckboxListTile(
                  fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                  value: gMsg1,
                  title: const Text('Message left'),
                  onChanged: (val) => setState(() => gMsg1 = val!),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: gName2,
                  hintText: 'Name',
                  title: '2. Parent/Guardian name',
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: gContact2,
                  hintText: 'Contact',
                  title: 'Method of Contact',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: gHour2,
                  selectedMinute: gMin2,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => gHour2 = val!),
                  onMinuteChanged: (val) => setState(() => gMin2 = val!),
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: gDate2,
                  onDateSelected: (date) => setState(() => gDate2 = date),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                  value: gContacted2,
                  title: const Text('Contact Made'),
                  onChanged: (val) => setState(() => gContacted2 = val!),
                ),
                CheckboxListTile(
                  fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                  value: gMsg2,
                  title: const Text('Message left'),
                  onChanged: (val) => setState(() => gMsg2 = val!),
                ),
                const SizedBox(height: 16),
                Text('Internal Notifications',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: nName,
                  hintText: 'Name',
                  title: 'Responsible Person in Charge Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Name' : null,
                ),
                const SizedBox(height: 12),
                CustomSignatureField(
                  title: 'Responsible Person in Charge Signature',
                  signature: incharge_signature,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignaturePage()),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          incharge_signature = value;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: nHour1,
                  selectedMinute: nMin1,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => nHour1 = val!),
                  onMinuteChanged: (val) => setState(() => nMin1 = val!),
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: nDate1,
                  onDateSelected: (date) => setState(() => nDate1 = date),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: nSupervisorName,
                  hintText: 'Name',
                  title: 'Nominated Supervisor Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Name' : null,
                ),
                const SizedBox(height: 12),
                CustomSignatureField(
                  title: 'Nominated Supervisor Signature',
                  signature: supervisor_signature,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignaturePage()),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          supervisor_signature = value;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: nHour2,
                  selectedMinute: nMin2,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => nHour2 = val!),
                  onMinuteChanged: (val) => setState(() => nMin2 = val!),
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  title: 'Date',
                  selectedDate: nDate2,
                  onDateSelected: (date) => setState(() => nDate2 = date),
                ),
                const SizedBox(height: 16),
                Text('External Notifications',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: eAgency,
                  hintText: 'Agency',
                  title: 'Other Agency',
                ),
                const SizedBox(height: 12),
                CustomTimePicker(
                  title: 'Time',
                  selectedHour: eHour1,
                  selectedMinute: eMin1,
                  hours: hours,
                  minutes: minutes,
                  onHourChanged: (val) => setState(() => eHour1 = val!),
                  onMinuteChanged: (val) => setState(() => eMin1 = val!),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    BlocListener<AddAccidentBloc, AddAccidentState>(
                      listener: (context, state) {
                        if (state is AddAccidentFailure) {
                          UIHelpers.showToast(
                            context,
                            message: state.error,
                            backgroundColor: AppColors.errorColor,
                          );
                        } else if (state is AddAccidentSuccess) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.successColor,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<AddAccidentBloc, AddAccidentState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SAVE',
                            isLoading: state is AddAccidentLoading,
                            ontap: () {
                              // if (_formKey.currentState!.validate())
                              {
                                final injuryTypes = <String>[];
                                if (abrasion)
                                  injuryTypes.add('Abrasion/Scrape');
                                if (allergy)
                                  injuryTypes.add('Allergic reaction');
                                if (amputation) injuryTypes.add('Amputation');
                                if (anaphylaxis) injuryTypes.add('Anaphylaxis');
                                if (asthma)
                                  injuryTypes.add('Asthma/Respiratory');
                                if (bite) injuryTypes.add('Bite Wound');
                                if (broken)
                                  injuryTypes
                                      .add('Broken Bone/Fracture/Dislocation');
                                if (burn) injuryTypes.add('Burn/Sunburn');
                                if (choking) injuryTypes.add('Choking');
                                if (concussion) injuryTypes.add('Concussion');
                                if (crush) injuryTypes.add('Crush/Jam');
                                if (cut) injuryTypes.add('Cut/Open Wound');
                                if (drowning)
                                  injuryTypes.add('Drowning (nonfatal)');
                                if (eye) injuryTypes.add('Eye Injury');
                                if (electric) injuryTypes.add('Electric Shock');
                                if (high) injuryTypes.add('High Temperature');
                                if (infectious)
                                  injuryTypes.add(
                                      'Infectious Disease (inc gastrointestinal)');
                                if (ingestion)
                                  injuryTypes
                                      .add('Ingestion/Inhalation/Insertion');
                                if (internal)
                                  injuryTypes.add('Internal injury/Infection');
                                if (poisoning) injuryTypes.add('Poisoning');
                                if (rash) injuryTypes.add('Rash');
                                if (respiratory) injuryTypes.add('Respiratory');
                                if (seizure)
                                  injuryTypes
                                      .add('Seizure/unconscious/convulsion');
                                if (sprain) injuryTypes.add('Sprain/swelling');
                                if (stabbing)
                                  injuryTypes.add('Stabbing/piercing');
                                if (tooth) injuryTypes.add('Tooth');
                                if (venomous)
                                  injuryTypes.add('Venomous bite/sting');
                                if (other)
                                  injuryTypes.add('Other (please specify)');

                                context.read<AddAccidentBloc>().add(
                                      SubmitAddAccidentEvent(
                                        addmark: addmark,
                                        id: widget.type == 'edit'
                                            ? widget.accid
                                            : null,
                                        centerId: widget.centerid,
                                        roomId: widget.roomid,
                                        name: name!.text,
                                        positionRole: positionRole!.text,
                                        recordDate: recordDate,
                                        personSignature: person_signature,
                                        childId: selectedChildId,
                                        childDob: cDob,
                                        childAge: cAge!.text,
                                        gender: _gender,
                                        incidentDate: cIncidentDate,
                                        incidentTime:
                                            cHour != null && cMin != null
                                                ? '$cHour:$cMin'
                                                : null,
                                        location: cloc!.text,
                                        childSignature: child_signature,
                                        incidentDetailsDate: cIDate,
                                        witnessName: witnessname!.text,
                                        activity: cactivity!.text,
                                        cause: ccause!.text,
                                        circumstances: ccsurrondings!.text,
                                        unaccountedDetails: ccunaccount!.text,
                                        lockedDetails: cclocked!.text,
                                        injuryTypes: injuryTypes,
                                        actionDetails: adetail!.text,
                                        emergencyServices: _aEmergency,
                                        emergencyDetails: ayesdetails!.text,
                                        medicalAttention: _aAttention,
                                        medicalDetails1: afuture1!.text,
                                        medicalDetails2: afuture2!.text,
                                        medicalDetails3: afuture3!.text,
                                        guardian1Name: gName1!.text,
                                        guardian1Contact: gContact1!.text,
                                        guardian1Time:
                                            gHour1 != null && gMin1 != null
                                                ? '$gHour1:$gMin1'
                                                : null,
                                        guardian1Date: gDate1,
                                        guardian1Contacted: gContacted1,
                                        guardian1MessageLeft: gMsg1,
                                        guardian2Name: gName2!.text,
                                        guardian2Contact: gContact2!.text,
                                        guardian2Time:
                                            gHour2 != null && gMin2 != null
                                                ? '$gHour2:$gMin2'
                                                : null,
                                        guardian2Date: gDate2,
                                        guardian2Contacted: gContacted2,
                                        guardian2MessageLeft: gMsg2,
                                        inChargeName: nName!.text,
                                        inChargeSignature: incharge_signature,
                                        inChargeTime:
                                            nHour1 != null && nMin1 != null
                                                ? '$nHour1:$nMin1'
                                                : null,
                                        inChargeDate: nDate1,
                                        supervisorName: nSupervisorName!.text,
                                        supervisorSignature:
                                            supervisor_signature,
                                        supervisorTime:
                                            nHour2 != null && nMin2 != null
                                                ? '$nHour2:$nMin2'
                                                : null,
                                        supervisorDate: nDate2,
                                        agency: eAgency!.text,
                                        agencyTime:
                                            eHour1 != null && eMin1 != null
                                                ? '$eHour1:$eMin1'
                                                : null,
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
