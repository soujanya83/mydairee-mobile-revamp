import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_view_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class ViewAccidentScreen extends StatefulWidget {
  final String accidentId;

  const ViewAccidentScreen({
    Key? key,
    required this.accidentId,
  }) : super(key: key);

  @override
  State<ViewAccidentScreen> createState() => _ViewAccidentScreenState();
}

class _ViewAccidentScreenState extends State<ViewAccidentScreen> {
  final AccidentRepository _repository = AccidentRepository();
  AccidentViewData? _accidentData;
  bool _isLoading = true;
  String? _error;

  // Controllers for read-only display
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personRoleController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childAgeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _witnessNameController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _causeController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _missingController = TextEditingController();
  final TextEditingController _takenController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _actionTakenController = TextEditingController();
  final TextEditingController _medicalDetailsController =
      TextEditingController();
  final TextEditingController _preventionStep1Controller =
      TextEditingController();
  final TextEditingController _preventionStep2Controller =
      TextEditingController();
  final TextEditingController _preventionStep3Controller =
      TextEditingController();
  final TextEditingController _parent1NameController = TextEditingController();
  final TextEditingController _contact1MethodController =
      TextEditingController();
  final TextEditingController _parent2NameController = TextEditingController();
  final TextEditingController _contact2MethodController =
      TextEditingController();
  final TextEditingController _responsiblePersonNameController =
      TextEditingController();
  final TextEditingController _nominatedSupervisorNameController =
      TextEditingController();
  final TextEditingController _otherAgencyController = TextEditingController();
  final TextEditingController _regulatoryAuthorityController =
      TextEditingController();
  final TextEditingController _addNotesController = TextEditingController();

  // Data variables for read-only display
  DateTime _recordDate = DateTime.now();
  String _recordTimeHour = "10";
  String _recordTimeMin = "00";
  DateTime _childDob = DateTime.now();
  String _childGender = "Male";
  DateTime _incidentDate = DateTime.now();
  String _incidentTimeHour = "10";
  String _incidentTimeMin = "00";
  DateTime _witnessDate = DateTime.now();
  String _emergencyServices = "Yes";
  String _medicalAttention = "Yes";
  DateTime _contact1Date = DateTime.now();
  String _contact1TimeHour = "10";
  String _contact1TimeMin = "00";
  bool _contact1Made = false;
  bool _contact1Msg = false;
  DateTime _contact2Date = DateTime.now();
  String _contact2TimeHour = "10";
  String _contact2TimeMin = "00";
  bool _contact2Made = false;
  bool _contact2Msg = false;
  DateTime _rpInternalNotifDate = DateTime.now();
  String _rpInternalNotifTimeHour = "10";
  String _rpInternalNotifTimeMin = "00";
  DateTime _nsvDate = DateTime.now();
  String _nsvTimeHour = "10";
  String _nsvTimeMin = "00";
  DateTime _enorDate = DateTime.now();
  String _enorTimeHour = "10";
  String _enorTimeMin = "00";
  DateTime _enraDate = DateTime.now();
  String _enraTimeHour = "10";
  String _enraTimeMin = "00";

  // Injury types
  bool _abrasion = false;
  bool _electricShock = false;
  bool _allergicReaction = false;
  bool _highTemperature = false;
  bool _amputation = false;
  bool _infectiousDisease = false;
  bool _anaphylaxis = false;
  bool _ingestion = false;
  bool _asthma = false;
  bool _internalInjury = false;
  bool _biteWound = false;
  bool _poisoning = false;
  bool _brokenBone = false;
  bool _rash = false;
  bool _burn = false;
  bool _respiratory = false;
  bool _choking = false;
  bool _seizure = false;
  bool _concussion = false;
  bool _sprain = false;
  bool _crush = false;
  bool _cut = false;
  bool _tooth = false;
  bool _drowning = false;
  bool _venomousBite = false;
  bool _eyeInjury = false;
  bool _stabbing = false;
  bool _other = false;

  // Images and signatures
  Uint8List? _injuryMarkImage;
  String? _base64InjuryImage;
  Uint8List? _witnessSignature;
  String? _witnessSignatureUrl;
  Uint8List? _responsiblePersonSignature;
  String? _responsiblePersonSignatureUrl;
  Uint8List? _nominatedSupervisorSignature;
  String? _nominatedSupervisorSignatureUrl;

  // Dropdown options
  List<String> hours =
      List.generate(24, (index) => index.toString().padLeft(2, '0'));
  List<String> minutes =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _loadAccidentDetails();
  }

  Future<void> _loadAccidentDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _repository.getAccidentViewDetails(
        accidentId: widget.accidentId,
      );

      if (response.success && response.data != null) {
        setState(() {
          _accidentData = response.data!.data;
          _populateFields(_accidentData!);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load accident details: $e';
        _isLoading = false;
      });
    }
  }

  void _populateFields(AccidentViewData accident) {
    // Person Details
    _personNameController.text = accident.personName;
    _personRoleController.text = accident.personRole;
    _recordDate = _parseDate(accident.date);
    List<String> timeParts = _parseTime(accident.time);
    _recordTimeHour = timeParts[0];
    _recordTimeMin = timeParts[1];

    // Child Details
    _childNameController.text = accident.child.getFullName();
    _childAgeController.text = accident.childAge;
    _childDob = _parseDate(accident.childDob);
    _childGender = accident.childGender;

    // Incident Details
    _incidentDate = _parseDate(accident.incidentDate);
    timeParts = _parseTime(accident.incidentTime);
    _incidentTimeHour = timeParts[0];
    _incidentTimeMin = timeParts[1];
    _locationController.text = accident.incidentLocation;
    _witnessNameController.text = accident.witnessName;
    _witnessDate = _parseDate(accident.witnessDate);
    _activityController.text = accident.genActyvt;
    _causeController.text = accident.cause;
    _symptomsController.text = accident.illnessSymptoms;
    _missingController.text = accident.missingUnaccounted;
    _takenController.text = accident.takenRemoved;

    // Injury Types
    _abrasion = accident.abrasion == 1;
    _electricShock = accident.electricShock == 1;
    _allergicReaction = accident.allergicReaction == 1;
    _highTemperature = accident.highTemperature == 1;
    _amputation = accident.amputation == 1;
    _infectiousDisease = accident.infectiousDisease == 1;
    _anaphylaxis = accident.anaphylaxis == 1;
    _ingestion = accident.ingestion == 1;
    _asthma = accident.asthma == 1;
    _internalInjury = accident.internalInjury == 1;
    _biteWound = accident.biteWound == 1;
    _poisoning = accident.poisoning == 1;
    _brokenBone = accident.brokenBone == 1;
    _rash = accident.rash == 1;
    _burn = accident.burn == 1;
    _respiratory = accident.respiratory == 1;
    _choking = accident.choking == 1;
    _seizure = accident.seizure == 1;
    _concussion = accident.concussion == 1;
    _sprain = accident.sprain == 1;
    _crush = accident.crush == 1;
    _stabbing = accident.stabbing == 1;
    _cut = accident.cut == 1;
    _tooth = accident.tooth == 1;
    _drowning = accident.drowning == 1;
    _venomousBite = accident.venomousBite == 1;
    _eyeInjury = accident.eyeInjury == 1;
    _other = accident.other == 1;
    _remarksController.text = accident.remarks;

    // Action Taken
    _actionTakenController.text = accident.actionTaken;
    _emergencyServices = accident.emrgServAttend;
    _medicalAttention = accident.medAttention;
    _medicalDetailsController.text = accident.medAttentionDetails;
    _preventionStep1Controller.text = accident.preventionStep1;
    _preventionStep2Controller.text = accident.preventionStep2;
    _preventionStep3Controller.text = accident.preventionStep3;

    // Parent/Guardian Notifications
    _parent1NameController.text = accident.parent1Name;
    _contact1MethodController.text = accident.contact1Method;
    _contact1Date = _parseDate(accident.contact1Date);
    timeParts = _parseTime(accident.contact1Time);
    _contact1TimeHour = timeParts[0];
    _contact1TimeMin = timeParts[1];
    _contact1Made =
        accident.contact1Made == "Yes" || accident.contact1Made == "1";
    _contact1Msg = accident.contact1Msg == "Yes" || accident.contact1Msg == "1";

    _parent2NameController.text = accident.parent2Name;
    _contact2MethodController.text = accident.contact2Method;
    _contact2Date = _parseDate(accident.contact2Date);
    timeParts = _parseTime(accident.contact2Time);
    _contact2TimeHour = timeParts[0];
    _contact2TimeMin = timeParts[1];
    _contact2Made =
        accident.contact2Made == "Yes" || accident.contact2Made == "1";
    _contact2Msg = accident.contact2Msg == "Yes" || accident.contact2Msg == "1";

    // Notifications
    _responsiblePersonNameController.text = accident.responsiblePersonName;
    _rpInternalNotifDate = _parseDate(accident.rpInternalNotifDate);
    timeParts = _parseTime(accident.rpInternalNotifTime);
    _rpInternalNotifTimeHour = timeParts[0];
    _rpInternalNotifTimeMin = timeParts[1];

    _nominatedSupervisorNameController.text = accident.nominatedSupervisorName;
    _nsvDate = _parseDate(accident.nominatedSupervisorDate);
    timeParts = _parseTime(accident.nominatedSupervisorTime);
    _nsvTimeHour = timeParts[0];
    _nsvTimeMin = timeParts[1];

    _otherAgencyController.text = accident.extNotifOtherAgency;
    _enorDate = _parseDate(accident.enorDate);
    timeParts = _parseTime(accident.enorTime);
    _enorTimeHour = timeParts[0];
    _enorTimeMin = timeParts[1];

    _regulatoryAuthorityController.text = accident.extNotifRegulatoryAuth;
    _enraDate = _parseDate(accident.enraDate);
    timeParts = _parseTime(accident.enraTime);
    _enraTimeHour = timeParts[0];
    _enraTimeMin = timeParts[1];

    _addNotesController.text = accident.addNotes;

    // Images and signatures
    if (accident.injuryImage?.isNotEmpty == true) {
      try {
        if (accident.injuryImage!.startsWith('data:image')) {
          final base64Str = accident.injuryImage!.split(',').last;
          _injuryMarkImage = base64Decode(base64Str);
        } else if (accident.injuryImage!.startsWith('http')) {
          _base64InjuryImage = accident.injuryImage;
        }
      } catch (_) {}
    }

    if (accident.witnessSign?.isNotEmpty == true) {
      try {
        if (accident.witnessSign!.startsWith('data:image')) {
          final base64Str = accident.witnessSign!.split(',').last;
          _witnessSignature = base64Decode(base64Str);
        } else if (accident.witnessSign!.startsWith('http')) {
          _witnessSignatureUrl = accident.witnessSign;
        }
      } catch (_) {}
    }

    if (accident.responsiblePersonSign?.isNotEmpty == true) {
      try {
        if (accident.responsiblePersonSign!.startsWith('data:image')) {
          final base64Str = accident.responsiblePersonSign!.split(',').last;
          _responsiblePersonSignature = base64Decode(base64Str);
        } else if (accident.responsiblePersonSign!.startsWith('http')) {
          _responsiblePersonSignatureUrl = accident.responsiblePersonSign;
        }
      } catch (_) {}
    }

    if (accident.nominatedSupervisorSign?.isNotEmpty == true) {
      try {
        if (accident.nominatedSupervisorSign!.startsWith('data:image')) {
          final base64Str = accident.nominatedSupervisorSign!.split(',').last;
          _nominatedSupervisorSignature = base64Decode(base64Str);
        } else if (accident.nominatedSupervisorSign!.startsWith('http')) {
          _nominatedSupervisorSignatureUrl = accident.nominatedSupervisorSign;
        }
      } catch (_) {}
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  List<String> _parseTime(String timeStr) {
    try {
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        final format = DateFormat('hh:mm a');
        final time = format.parse(timeStr);
        return [
          time.hour.toString().padLeft(2, '0'),
          time.minute.toString().padLeft(2, '0')
        ];
      } else {
        final parts = timeStr.split(':');
        return [parts[0].padLeft(2, '0'), parts[1].padLeft(2, '0')];
      }
    } catch (e) {
      return ["10", "00"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Accident Details'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAccidentDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _accidentData == null
                  ? const Center(child: Text('No data available'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accident Details',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'INCIDENT, INJURY, TRAUMA, & ILLNESS RECORD',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),

                            // Person Details Section
                            _buildSectionHeader(
                                'Details of person completing this record'),
                            CustomTextFormWidget(
                              controller: _personNameController,
                              hintText: 'Name',
                              title: 'Name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 12),
                            CustomTextFormWidget(
                              controller: _personRoleController,
                              hintText: 'Position/Role',
                              title: 'Position/Role',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Date',
                              selectedDate: _recordDate,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyTimePicker(
                              title: 'Time',
                              hourValue: _recordTimeHour,
                              minuteValue: _recordTimeMin,
                            ),

                            // Child Details Section
                            const SizedBox(height: 24),
                            _buildSectionHeader('Child Details'),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _childNameController,
                              hintText: 'Child Name',
                              title: 'Child Name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Date of Birth',
                              selectedDate: _childDob,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _childAgeController,
                              hintText: 'Age',
                              title: 'Age',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            Text('Gender',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            _buildReadOnlyDropdown(_childGender),

                            // Incident Details Section
                            const SizedBox(height: 24),
                            _buildSectionHeader('Incident Details'),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Incident Date',
                              selectedDate: _incidentDate,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyTimePicker(
                              title: 'Incident Time',
                              hourValue: _incidentTimeHour,
                              minuteValue: _incidentTimeMin,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _locationController,
                              hintText: 'Location',
                              title: 'Location',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _witnessNameController,
                              hintText: 'Witness Name',
                              title: 'Witness Name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlySignatureField(
                              title: 'Witness Signature',
                              signature: _witnessSignature,
                              networkImageUrl: _witnessSignatureUrl,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Witness Date',
                              selectedDate: _witnessDate,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _activityController,
                              hintText: 'Activity',
                              title:
                                  'General activity at the time of incident/injury/trauma/illness',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _causeController,
                              hintText: 'Cause',
                              title: 'Cause of injury/trauma',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _symptomsController,
                              hintText: 'Symptoms',
                              title:
                                  'Circumstances surrounding any illness, including apparent symptoms',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _missingController,
                              hintText: 'Details',
                              title:
                                  'Circumstances if child appeared to be missing or otherwise unaccounted for',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _takenController,
                              hintText: 'Details',
                              title:
                                  'Circumstances if child was taken or removed from the service',
                              maxLines: 2,
                              readOnly: true,
                            ),

                            // Injury Image
                            const SizedBox(height: 24),
                            _buildSectionHeader(
                                'Nature of Injury/Trauma/Illness'),
                            const SizedBox(height: 16),
                            _buildReadOnlyImageField(),

                            // Injury Types Checkboxes
                            const SizedBox(height: 24),
                            Text('Injury types:',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            _buildReadOnlyInjuryTypeCheckboxes(),

                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _remarksController,
                              hintText: 'Remarks',
                              title: 'Additional remarks',
                              maxLines: 3,
                              readOnly: true,
                            ),

                            // Action Taken Section
                            const SizedBox(height: 24),
                            _buildSectionHeader('Action Taken'),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _actionTakenController,
                              hintText: 'Details of action taken',
                              title:
                                  'Details of action taken (including first aid, administration of medication etc.)',
                              maxLines: 3,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            Text('Did emergency services attend?',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            _buildReadOnlyDropdown(_emergencyServices),
                            const SizedBox(height: 16),
                            Text('Was medical attention sought?',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            _buildReadOnlyDropdown(_medicalAttention),
                            const SizedBox(height: 16),
                            if (_medicalAttention == 'Yes')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormWidget(
                                    controller: _medicalDetailsController,
                                    hintText: 'Medical attention details',
                                    title: 'Details of medical attention',
                                    maxLines: 3,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),

                            CustomTextFormWidget(
                              controller: _preventionStep1Controller,
                              hintText: 'Prevention step 1',
                              title: 'Future prevention step 1',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _preventionStep2Controller,
                              hintText: 'Prevention step 2',
                              title: 'Future prevention step 2',
                              maxLines: 2,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _preventionStep3Controller,
                              hintText: 'Prevention step 3',
                              title: 'Future prevention step 3',
                              maxLines: 2,
                              readOnly: true,
                            ),

                            // Parent/Guardian Notifications Section
                            const SizedBox(height: 24),
                            _buildSectionHeader(
                                'Parent/Guardian Notifications'),

                            // First Parent/Guardian
                            const SizedBox(height: 16),
                            Text('First Parent/Guardian',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            CustomTextFormWidget(
                              controller: _parent1NameController,
                              hintText: 'Name',
                              title: 'Parent/Guardian name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _contact1MethodController,
                              hintText: 'Contact Method',
                              title: 'Method of Contact',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Contact Date',
                              selectedDate: _contact1Date,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyTimePicker(
                              title: 'Contact Time',
                              hourValue: _contact1TimeHour,
                              minuteValue: _contact1TimeMin,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildReadOnlyCheckbox(
                                      'Contact Made', _contact1Made),
                                ),
                                Expanded(
                                  child: _buildReadOnlyCheckbox(
                                      'Message Left', _contact1Msg),
                                ),
                              ],
                            ),

                            // Second Parent/Guardian
                            if (_parent2NameController.text.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text('Second Parent/Guardian',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              CustomTextFormWidget(
                                controller: _parent2NameController,
                                hintText: 'Name',
                                title: 'Parent/Guardian name',
                                readOnly: true,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormWidget(
                                controller: _contact2MethodController,
                                hintText: 'Contact Method',
                                title: 'Method of Contact',
                                readOnly: true,
                              ),
                              const SizedBox(height: 16),
                              _buildReadOnlyDatePicker(
                                title: 'Contact Date',
                                selectedDate: _contact2Date,
                              ),
                              const SizedBox(height: 16),
                              _buildReadOnlyTimePicker(
                                title: 'Contact Time',
                                hourValue: _contact2TimeHour,
                                minuteValue: _contact2TimeMin,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildReadOnlyCheckbox(
                                        'Contact Made', _contact2Made),
                                  ),
                                  Expanded(
                                    child: _buildReadOnlyCheckbox(
                                        'Message Left', _contact2Msg),
                                  ),
                                ],
                              ),
                            ],

                            // Internal Notifications Section
                            const SizedBox(height: 24),
                            _buildSectionHeader('Internal Notifications'),
                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _responsiblePersonNameController,
                              hintText: 'Name',
                              title: 'Responsible Person in Charge Name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlySignatureField(
                              title: 'Responsible Person Signature',
                              signature: _responsiblePersonSignature,
                              networkImageUrl: _responsiblePersonSignatureUrl,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Notification Date',
                              selectedDate: _rpInternalNotifDate,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyTimePicker(
                              title: 'Notification Time',
                              hourValue: _rpInternalNotifTimeHour,
                              minuteValue: _rpInternalNotifTimeMin,
                            ),

                            const SizedBox(height: 16),
                            CustomTextFormWidget(
                              controller: _nominatedSupervisorNameController,
                              hintText: 'Name',
                              title: 'Nominated Supervisor Name',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlySignatureField(
                              title: 'Nominated Supervisor Signature',
                              signature: _nominatedSupervisorSignature,
                              networkImageUrl: _nominatedSupervisorSignatureUrl,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyDatePicker(
                              title: 'Date',
                              selectedDate: _nsvDate,
                            ),
                            const SizedBox(height: 16),
                            _buildReadOnlyTimePicker(
                              title: 'Time',
                              hourValue: _nsvTimeHour,
                              minuteValue: _nsvTimeMin,
                            ),

                            // External Notifications Section
                            if (_otherAgencyController.text.isNotEmpty ||
                                _regulatoryAuthorityController
                                    .text.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              _buildSectionHeader('External Notifications'),
                              const SizedBox(height: 16),
                              if (_otherAgencyController.text.isNotEmpty) ...[
                                CustomTextFormWidget(
                                  controller: _otherAgencyController,
                                  hintText: 'Agency',
                                  title: 'Other Agency',
                                  readOnly: true,
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyDatePicker(
                                  title: 'Date',
                                  selectedDate: _enorDate,
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyTimePicker(
                                  title: 'Time',
                                  hourValue: _enorTimeHour,
                                  minuteValue: _enorTimeMin,
                                ),
                                const SizedBox(height: 16),
                              ],
                              if (_regulatoryAuthorityController
                                  .text.isNotEmpty) ...[
                                CustomTextFormWidget(
                                  controller: _regulatoryAuthorityController,
                                  hintText: 'Authority',
                                  title: 'Regulatory Authority',
                                  readOnly: true,
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyDatePicker(
                                  title: 'Date',
                                  selectedDate: _enraDate,
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyTimePicker(
                                  title: 'Time',
                                  hourValue: _enraTimeHour,
                                  minuteValue: _enraTimeMin,
                                ),
                              ],
                            ],

                            // Additional Notes
                            if (_addNotesController.text.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              _buildSectionHeader('Additional Notes'),
                              const SizedBox(height: 16),
                              CustomTextFormWidget(
                                controller: _addNotesController,
                                hintText: 'Additional Notes',
                                title: 'Additional Notes',
                                maxLines: 4,
                                readOnly: true,
                              ),
                            ],

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
    );
  }

  // Widget builders for read-only components
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Divider(thickness: 1),
      ],
    );
  }

  Widget _buildReadOnlyDatePicker({
    required String title,
    required DateTime selectedDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey[600]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyTimePicker({
    required String title,
    required String hourValue,
    required String minuteValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Text(
                  hourValue,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Text(
                  minuteValue,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadOnlyDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      width: double.infinity,
      child: Text(
        value,
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildReadOnlySignatureField({
    required String title,
    required Uint8List? signature,
    String? networkImageUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          height: signature != null || (networkImageUrl?.isNotEmpty == true)
              ? 100
              : 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: signature != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(signature, fit: BoxFit.contain),
                )
              : (networkImageUrl?.isNotEmpty == true)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          Image.network(networkImageUrl!, fit: BoxFit.contain),
                    )
                  : Center(
                      child: Text(
                        'No signature available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyImageField() {
    return Container(
      height:
          _injuryMarkImage != null || (_base64InjuryImage?.isNotEmpty == true)
              ? 200
              : 50,
      width:
          _injuryMarkImage != null || (_base64InjuryImage?.isNotEmpty == true)
              ? 200
              : double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: _injuryMarkImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_injuryMarkImage!, fit: BoxFit.contain),
            )
          : (_base64InjuryImage?.isNotEmpty == true)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      Image.network(_base64InjuryImage!, fit: BoxFit.contain),
                )
              : Center(
                  child: Text(
                    'No injury image available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
    );
  }

  Widget _buildReadOnlyCheckbox(String label, bool value) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: value ? AppColors.primaryColor : Colors.transparent,
            ),
            child:
                value ? Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInjuryTypeCheckboxes() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 0.0,
      children: [
        _buildReadOnlyInjuryCheckbox('Abrasion/Scrape', _abrasion),
        _buildReadOnlyInjuryCheckbox('Electric Shock', _electricShock),
        _buildReadOnlyInjuryCheckbox('Allergic Reaction', _allergicReaction),
        _buildReadOnlyInjuryCheckbox('High Temperature', _highTemperature),
        _buildReadOnlyInjuryCheckbox('Amputation', _amputation),
        _buildReadOnlyInjuryCheckbox('Infectious Disease', _infectiousDisease),
        _buildReadOnlyInjuryCheckbox('Anaphylaxis', _anaphylaxis),
        _buildReadOnlyInjuryCheckbox('Ingestion', _ingestion),
        _buildReadOnlyInjuryCheckbox('Asthma', _asthma),
        _buildReadOnlyInjuryCheckbox('Internal Injury', _internalInjury),
        _buildReadOnlyInjuryCheckbox('Bite Wound', _biteWound),
        _buildReadOnlyInjuryCheckbox('Poisoning', _poisoning),
        _buildReadOnlyInjuryCheckbox('Broken Bone', _brokenBone),
        _buildReadOnlyInjuryCheckbox('Rash', _rash),
        _buildReadOnlyInjuryCheckbox('Burn', _burn),
        _buildReadOnlyInjuryCheckbox('Respiratory', _respiratory),
        _buildReadOnlyInjuryCheckbox('Choking', _choking),
        _buildReadOnlyInjuryCheckbox('Seizure', _seizure),
        _buildReadOnlyInjuryCheckbox('Concussion', _concussion),
        _buildReadOnlyInjuryCheckbox('Sprain', _sprain),
        _buildReadOnlyInjuryCheckbox('Crush', _crush),
        _buildReadOnlyInjuryCheckbox('Stabbing', _stabbing),
        _buildReadOnlyInjuryCheckbox('Cut', _cut),
        _buildReadOnlyInjuryCheckbox('Tooth', _tooth),
        _buildReadOnlyInjuryCheckbox('Drowning', _drowning),
        _buildReadOnlyInjuryCheckbox('Venomous Bite', _venomousBite),
        _buildReadOnlyInjuryCheckbox('Eye Injury', _eyeInjury),
        _buildReadOnlyInjuryCheckbox('Other', _other),
      ],
    );
  }

  Widget _buildReadOnlyInjuryCheckbox(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: value ? AppColors.primaryColor : Colors.grey),
        color:
            value ? AppColors.primaryColor.withOpacity(0.1) : Colors.grey[50],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                  color: value ? AppColors.primaryColor : Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: value ? AppColors.primaryColor : Colors.transparent,
            ),
            child:
                value ? Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: value ? AppColors.primaryColor : Colors.grey[700],
                fontWeight: value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
