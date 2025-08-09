import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/child_details_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/create_accident_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_detail_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/widget/add_accident_custom_widgets.dart'; 

class AddAccidentScreen extends StatefulWidget {
  final String centerid;
  final String roomid;
  final String? accidentId;
  final bool isEditing;

  const AddAccidentScreen({
    Key? key,
    required this.centerid,
    required this.roomid,
    this.accidentId,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddAccidentScreen> createState() => _AddAccidentScreenState();
}

class _AddAccidentScreenState extends State<AddAccidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final AccidentRepository _repository = AccidentRepository();
  
  // Person Details
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personRoleController = TextEditingController();
  DateTime _recordDate = DateTime.now();
  String _recordTimeHour = "10";
  String _recordTimeMin = "00";
  Uint8List? _personSignature;
  
  // Child Details
  List<ChildrenData> _children = [];
  ChildrenData? _selectedChild;
  final TextEditingController _childAgeController = TextEditingController();
  DateTime _childDob = DateTime.now();
  String _childGender = "Male";
  
  // Incident Details
  DateTime _incidentDate = DateTime.now();
  String _incidentTimeHour = "10";
  String _incidentTimeMin = "00";
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _witnessNameController = TextEditingController();
  DateTime _witnessDate = DateTime.now();
  Uint8List? _witnessSignature;
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _causeController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _missingController = TextEditingController();
  final TextEditingController _takenController = TextEditingController();
  File? _injuryImage;
  String? _base64InjuryImage;
  
  // Injury Types
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
  bool _stabbing = false;
  bool _cut = false;
  bool _tooth = false;
  bool _drowning = false;
  bool _venomousBite = false;
  bool _eyeInjury = false;
  bool _other = false;
  final TextEditingController _remarksController = TextEditingController();
  
  // Action Taken
  final TextEditingController _actionTakenController = TextEditingController();
  String _emergencyServices = "Yes";
  String _medicalAttention = "Yes";
  final TextEditingController _medicalDetailsController = TextEditingController();
  final TextEditingController _preventionStep1Controller = TextEditingController();
  final TextEditingController _preventionStep2Controller = TextEditingController();
  final TextEditingController _preventionStep3Controller = TextEditingController();
  
  // Parent/Guardian Notifications
  final TextEditingController _parent1NameController = TextEditingController();
  final TextEditingController _contact1MethodController = TextEditingController();
  DateTime _contact1Date = DateTime.now();
  String _contact1TimeHour = "10";
  String _contact1TimeMin = "00";
  bool _contact1Made = false;
  bool _contact1Msg = false;
  
  final TextEditingController _parent2NameController = TextEditingController();
  final TextEditingController _contact2MethodController = TextEditingController();
  DateTime _contact2Date = DateTime.now();
  String _contact2TimeHour = "10";
  String _contact2TimeMin = "00";
  bool _contact2Made = false;
  bool _contact2Msg = false;
  
  // Notifications
  final TextEditingController _responsiblePersonNameController = TextEditingController();
  Uint8List? _responsiblePersonSignature;
  DateTime _rpInternalNotifDate = DateTime.now();
  String _rpInternalNotifTimeHour = "10";
  String _rpInternalNotifTimeMin = "00";
  
  final TextEditingController _nominatedSupervisorNameController = TextEditingController();
  Uint8List? _nominatedSupervisorSignature;
  DateTime _nsvDate = DateTime.now();
  String _nsvTimeHour = "10";
  String _nsvTimeMin = "00";
  
  final TextEditingController _otherAgencyController = TextEditingController();
  DateTime _enorDate = DateTime.now();
  String _enorTimeHour = "10";
  String _enorTimeMin = "00";
  
  final TextEditingController _regulatoryAuthorityController = TextEditingController();
  DateTime _enraDate = DateTime.now();
  String _enraTimeHour = "10";
  String _enraTimeMin = "00";
  
  final TextEditingController _addNotesController = TextEditingController();
  
  // Dropdown options
  List<String> hours = List.generate(24, (index) => index.toString().padLeft(2, '0'));
  List<String> minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
  
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // If editing, load accident details
      if (widget.isEditing && widget.accidentId != null) {
        await _loadAccidentDetails();
      } else {
        // Load data for new accident creation
        await _loadCreateData();
      }
    } catch (e) {
      print('Error loading data: $e');
      UIHelpers.showToast(
        context,
        message: 'Failed to load data: $e',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCreateData() async {
    final response = await _repository.getCreateAccidentData(
      centerId: widget.centerid,
      roomId: widget.roomid,
    );

    if (response.success && response.data != null) {
      setState(() {
        _children = response.data!.data.children;
      });
    } else {
      UIHelpers.showToast(
        context,
        message: response.message,
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  Future<void> _loadAccidentDetails() async {
    final response = await _repository.getAccidentDetails(
      accidentId: widget.accidentId!,
      centerId: widget.centerid,
      roomId: widget.roomid,
    );

    if (response.success && response.data != null) {
      final accident = response.data!.accident;
      
      // Populate form fields with accident data
      _populateFields(accident);
      
      // Also load children data for the dropdown
      await _loadCreateData();
      
      // Find the selected child in the children list
      if (_children.isNotEmpty) {
        _selectedChild = _children.firstWhere(
          (child) => child.id == accident.childId,
          orElse: () => _children.first,
        );
      }
    } else {
      UIHelpers.showToast(
        context,
        message: response.message,
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  void _populateFields(AccidentDetailData accident) {
    // Person Details
    _personNameController.text = accident.personName;
    _personRoleController.text = accident.personRole;
    _recordDate = _parseDate(accident.date);
    List<String> timeParts = _parseTime(accident.time);
    _recordTimeHour = timeParts[0];
    _recordTimeMin = timeParts[1];
    
    // Child Details
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
    _emergencyServices = accident.emergServAttend;
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
    _contact1Made = accident.contact1Made == "Yes" || accident.contact1Made == "1";
    _contact1Msg = accident.contact1Msg == "Yes" || accident.contact1Msg == "1";
    
    _parent2NameController.text = accident.parent2Name;
    _contact2MethodController.text = accident.contact2Method;
    _contact2Date = _parseDate(accident.contact2Date);
    timeParts = _parseTime(accident.contact2Time);
    _contact2TimeHour = timeParts[0];
    _contact2TimeMin = timeParts[1];
    _contact2Made = accident.contact2Made == "Yes" || accident.contact2Made == "1";
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
      // Handle different time formats
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        final format = DateFormat('hh:mm a');
        final time = format.parse(timeStr);
        return [time.hour.toString(), time.minute.toString()];
      } else {
        final parts = timeStr.split(':');
        return [parts[0], parts[1]];
      }
    } catch (e) {
      return ["10", "00"];
    }
  }

  void _showChildDialog() {
    if (_children.isEmpty) {
      UIHelpers.showToast(
        context,
        message: 'No children available',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Child'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                return ListTile(
                  title: Text('${child.name} ${child.lastname}'),
                  subtitle: Text(child.details),
                  onTap: () {
                    Navigator.pop(context, child);
                  },
                );
              },
            ),
          ),
        );
      },
    ).then((selectedChild) {
      if (selectedChild != null) {
        _onChildSelected(selectedChild);
      }
    });
  }

  Future<void> _onChildSelected(ChildrenData child) async {
    setState(() {
      _selectedChild = child;
      _childGender = child.gender;
      _childDob = _parseDate(child.dob);
      
      // Calculate age
      final now = DateTime.now();
      final age = now.year - _childDob.year;
      _childAgeController.text = age.toString();
    });

    // Load additional child details if needed
    await _loadChildDetails(child.id.toString());
  }

  Future<void> _loadChildDetails(String childId) async {
    final response = await _repository.getChildDetails(childId:childId );
    
    if (response.success && response.data != null) {
      final childDetails = response.data!.child;
      
      setState(() {
        // Update with any additional details from the API
        _childDob = _parseDate(childDetails.dob);
        _childGender = childDetails.gender;
        
        // Recalculate age based on DOB
        final now = DateTime.now();
        final age = now.year - _childDob.year;
        _childAgeController.text = age.toString();
      });
    }
  }

  Future<void> _pickInjuryImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _injuryImage = File(pickedFile.path);
        
        // Convert to base64
        final bytes = _injuryImage!.readAsBytesSync();
        _base64InjuryImage = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _captureSignature({required Function(Uint8List) onSignatureCapture}) async {
    final signature = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(builder: (context) => SignaturePage()),
    );
    
    if (signature != null) {
      onSignatureCapture(signature);
    }
  }

  Map<String, String> _getInjuryTypesMap() {
    return {
      'abrasion': _abrasion ? '1' : '0',
      'electric_shock': _electricShock ? '1' : '0',
      'allergic_reaction': _allergicReaction ? '1' : '0',
      'high_temperature': _highTemperature ? '1' : '0',
      'amputation': _amputation ? '1' : '0',
      'infectious_disease': _infectiousDisease ? '1' : '0',
      'anaphylaxis': _anaphylaxis ? '1' : '0',
      'ingestion': _ingestion ? '1' : '0',
      'asthma': _asthma ? '1' : '0',
      'internal_injury': _internalInjury ? '1' : '0',
      'bite_wound': _biteWound ? '1' : '0',
      'poisoning': _poisoning ? '1' : '0',
      'broken_bone': _brokenBone ? '1' : '0',
      'rash': _rash ? '1' : '0',
      'burn': _burn ? '1' : '0',
      'respiratory': _respiratory ? '1' : '0',
      'choking': _choking ? '1' : '0',
      'seizure': _seizure ? '1' : '0',
      'concussion': _concussion ? '1' : '0',
      'sprain': _sprain ? '1' : '0',
      'crush': _crush ? '1' : '0',
      'stabbing': _stabbing ? '1' : '0',
      'cut': _cut ? '1' : '0',
      'tooth': _tooth ? '1' : '0',
      'drowning': _drowning ? '1' : '0',
      'venomous_bite': _venomousBite ? '1' : '0',
      'eye_injury': _eyeInjury ? '1' : '0',
      'other': _other ? '1' : '0',
    };
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatTime(String hour, String minute) {
    return '$hour:$minute';
  }

  Future<void> _saveAccident() async {
    if (!_formKey.currentState!.validate()) {
      UIHelpers.showToast(
        context,
        message: 'Please fill all required fields',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    if (_selectedChild == null) {
      UIHelpers.showToast(
        context,
        message: 'Please select a child',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Convert signatures to base64
      String? personSignBase64;
      if (_personSignature != null) {
        personSignBase64 = 'data:image/png;base64,${base64Encode(_personSignature!)}';
      }
      
      String? witnessSignBase64;
      if (_witnessSignature != null) {
        witnessSignBase64 = 'data:image/png;base64,${base64Encode(_witnessSignature!)}';
      }
      
      String? responsiblePersonSignBase64;
      if (_responsiblePersonSignature != null) {
        responsiblePersonSignBase64 = 'data:image/png;base64,${base64Encode(_responsiblePersonSignature!)}';
      }
      
      String? nominatedSupervisorSignBase64;
      if (_nominatedSupervisorSignature != null) {
        nominatedSupervisorSignBase64 = 'data:image/png;base64,${base64Encode(_nominatedSupervisorSignature!)}';
      }

      final response = await _repository.saveAccident(
        id: widget.isEditing ? widget.accidentId : null,
        centerId: widget.centerid,
        roomId: widget.roomid,
        personName: _personNameController.text,
        personRole: _personRoleController.text,
        date: _formatDate(_recordDate),
        time: _formatTime(_recordTimeHour, _recordTimeMin),
        personSign: personSignBase64,
        childId: _selectedChild!.id.toString(),
        childName: '${_selectedChild!.name}${_selectedChild!.lastname}',
        childDob: _formatDate(_childDob),
        childAge: _childAgeController.text,
        gender: _childGender,
        incidentDate: _formatDate(_incidentDate),
        incidentTime: _formatTime(_incidentTimeHour, _incidentTimeMin),
        incidentLocation: _locationController.text,
        witnessName: _witnessNameController.text,
        witnessDate: _formatDate(_witnessDate),
        witnessSign: witnessSignBase64,
        genActyvt: _activityController.text,
        cause: _causeController.text,
        illnessSymptoms: _symptomsController.text,
        missingUnaccounted: _missingController.text,
        takenRemoved: _takenController.text,
        injuryImage: _base64InjuryImage,
        injuryTypes: _getInjuryTypesMap(),
        remarks: _remarksController.text,
        actionTaken: _actionTakenController.text,
        emergServAttend: _emergencyServices,
        medAttention: _medicalAttention,
        medAttentionDetails: _medicalDetailsController.text,
        preventionStep1: _preventionStep1Controller.text,
        preventionStep2: _preventionStep2Controller.text,
        preventionStep3: _preventionStep3Controller.text,
        parent1Name: _parent1NameController.text,
        contact1Method: _contact1MethodController.text,
        contact1Date: _formatDate(_contact1Date),
        contact1Time: _formatTime(_contact1TimeHour, _contact1TimeMin),
        contact1Made: _contact1Made ? '1' : '0',
        contact1Msg: _contact1Msg ? '1' : '0',
        parent2Name: _parent2NameController.text,
        contact2Method: _contact2MethodController.text,
        contact2Date: _formatDate(_contact2Date),
        contact2Time: _formatTime(_contact2TimeHour, _contact2TimeMin),
        contact2Made: _contact2Made ? '1' : '0',
        contact2Msg: _contact2Msg ? '1' : '0',
        responsiblePersonName: _responsiblePersonNameController.text,
        responsiblePersonSign: responsiblePersonSignBase64,
        rpInternalNotifDate: _formatDate(_rpInternalNotifDate),
        rpInternalNotifTime: _formatTime(_rpInternalNotifTimeHour, _rpInternalNotifTimeMin),
        nominatedSupervisorName: _nominatedSupervisorNameController.text,
        nominatedSupervisorSign: nominatedSupervisorSignBase64,
        nsvDate: _formatDate(_nsvDate),
        nsvTime: _formatTime(_nsvTimeHour, _nsvTimeMin),
        otherAgency: _otherAgencyController.text,
        enorDate: _formatDate(_enorDate),
        enorTime: _formatTime(_enorTimeHour, _enorTimeMin),
        regulatoryAuthority: _regulatoryAuthorityController.text,
        enraDate: _formatDate(_enraDate),
        enraTime: _formatTime(_enraTimeHour, _enraTimeMin),
        addNotes: _addNotesController.text,
      );

      setState(() {
        _isSaving = false;
      });

      if (response.success) {
        UIHelpers.showToast(
          // ignore: use_build_context_synchronously
          context,
          message: widget.isEditing ? 'Accident updated successfully' : 'Accident added successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context, true); // Return success to previous screen
      } else {
        UIHelpers.showToast(
          // ignore: use_build_context_synchronously
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to save accident: $e',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: widget.isEditing ? "Edit Accident" : "Add Accident"),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing ? 'Edit Accident' : 'Add Accident',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'INCIDENT, INJURY, TRAUMA, & ILLNESS RECORD',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      // Person Details Section
                      _buildSectionHeader('Details of person completing this record'),
                      CustomTextFormWidget(
                        controller: _personNameController,
                        hintText: 'Name',
                        title: 'Name',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Name' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormWidget(
                        controller: _personRoleController,
                        hintText: 'Position/Role',
                        title: 'Position/Role',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Position/Role' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildSignatureField(
                        title: 'Signature',
                        signature: _personSignature,
                        onTap: () => _captureSignature(
                          onSignatureCapture: (signature) {
                            setState(() => _personSignature = signature);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Date',
                        selectedDate: _recordDate,
                        onDateSelected: (date) {
                          setState(() => _recordDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Time',
                        hourValue: _recordTimeHour,
                        minuteValue: _recordTimeMin,
                        onHourChanged: (value) {
                          setState(() => _recordTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _recordTimeMin = value!);
                        },
                      ),
                      
                      // Child Details Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Child Details'),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _showChildDialog,
                        child: Container(
                          width: 180,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person_add, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Select Child', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedChild != null)
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_selectedChild!.name} ${_selectedChild!.lastname}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedChild = null;
                                    _childDob = DateTime.now();
                                    _childGender = "Male";
                                    _childAgeController.text = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Date of Birth',
                        selectedDate: _childDob,
                        onDateSelected: (date) {
                          setState(() {
                            _childDob = date;
                            // Update age
                            final now = DateTime.now();
                            final age = now.year - _childDob.year;
                            _childAgeController.text = age.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _childAgeController,
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
                      const SizedBox(height: 16),
                      Text('Gender', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        height: 50,
                        value: _childGender,
                        items: const ['Male', 'Female', 'Other'],
                        onChanged: (val) => setState(() => _childGender = val!),
                      ),
                      
                      // Incident Details Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Incident Details'),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Incident Date',
                        selectedDate: _incidentDate,
                        onDateSelected: (date) {
                          setState(() => _incidentDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Incident Time',
                        hourValue: _incidentTimeHour,
                        minuteValue: _incidentTimeMin,
                        onHourChanged: (value) {
                          setState(() => _incidentTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _incidentTimeMin = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _locationController,
                        hintText: 'Location',
                        title: 'Location',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Location' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _witnessNameController,
                        hintText: 'Witness Name',
                        title: 'Witness Name',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Witness Name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildSignatureField(
                        title: 'Witness Signature',
                        signature: _witnessSignature,
                        onTap: () => _captureSignature(
                          onSignatureCapture: (signature) {
                            setState(() => _witnessSignature = signature);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Witness Date',
                        selectedDate: _witnessDate,
                        onDateSelected: (date) {
                          setState(() => _witnessDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _activityController,
                        hintText: 'Activity',
                        title: 'General activity at the time of incident/injury/trauma/illness',
                        maxLines: 2,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Activity' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _causeController,
                        hintText: 'Cause',
                        title: 'Cause of injury/trauma',
                        maxLines: 2,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Cause' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _symptomsController,
                        hintText: 'Symptoms',
                        title: 'Circumstances surrounding any illness, including apparent symptoms',
                        maxLines: 2,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Symptoms' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _missingController,
                        hintText: 'Details',
                        title: 'Circumstances if child appeared to be missing or otherwise unaccounted for',
                        maxLines: 2,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Details' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _takenController,
                        hintText: 'Details',
                        title: 'Circumstances if child was taken or removed from the service',
                        maxLines: 2,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Details' : null,
                      ),
                      
                      // Injury Image
                      const SizedBox(height: 24),
                      _buildSectionHeader('Nature of Injury/Trauma/Illness'),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickInjuryImage,
                        child: Container(
                          height: _injuryImage != null ? 150 : 50,
                          width: _injuryImage != null ? 150 : double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: _injuryImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_injuryImage!, fit: BoxFit.cover),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add_photo_alternate),
                                      SizedBox(width: 8),
                                      Text('Add injury image'),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      
                      // Injury Types Checkboxes
                      const SizedBox(height: 24),
                      Text('Select injury types:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _buildInjuryTypeCheckboxes(),
                      
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _remarksController,
                        hintText: 'Remarks',
                        title: 'Additional remarks',
                        maxLines: 3,
                      ),
                      
                      // Action Taken Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Action Taken'),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _actionTakenController,
                        hintText: 'Details of action taken',
                        title: 'Details of action taken (including first aid, administration of medication etc.)',
                        maxLines: 3,
                        validator: (v) => v == null || v.isEmpty ? 'Enter Details' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Did emergency services attend?', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        height: 50,
                        value: _emergencyServices,
                        items: const ['Yes', 'No'],
                        onChanged: (val) => setState(() => _emergencyServices = val!),
                      ),
                      const SizedBox(height: 16),
                      Text('Was medical attention sought?', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        height: 50,
                        value: _medicalAttention,
                        items: const ['Yes', 'No'],
                        onChanged: (val) => setState(() => _medicalAttention = val!),
                      ),
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
                              validator: (v) => v == null || v.isEmpty ? 'Enter Details' : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      
                      CustomTextFormWidget(
                        controller: _preventionStep1Controller,
                        hintText: 'Prevention step 1',
                        title: 'Future prevention step 1',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _preventionStep2Controller,
                        hintText: 'Prevention step 2',
                        title: 'Future prevention step 2',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _preventionStep3Controller,
                        hintText: 'Prevention step 3',
                        title: 'Future prevention step 3',
                        maxLines: 2,
                      ),
                      
                      // Parent/Guardian Notifications Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Parent/Guardian Notifications'),
                      
                      // First Parent/Guardian
                      const SizedBox(height: 16),
                      Text('First Parent/Guardian', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      CustomTextFormWidget(
                        controller: _parent1NameController,
                        hintText: 'Name',
                        title: 'Parent/Guardian name',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Name' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _contact1MethodController,
                        hintText: 'Contact Method',
                        title: 'Method of Contact',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Contact Method' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Contact Date',
                        selectedDate: _contact1Date,
                        onDateSelected: (date) {
                          setState(() => _contact1Date = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Contact Time',
                        hourValue: _contact1TimeHour,
                        minuteValue: _contact1TimeMin,
                        onHourChanged: (value) {
                          setState(() => _contact1TimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _contact1TimeMin = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Contact Made'),
                              value: _contact1Made,
                              onChanged: (value) {
                                setState(() => _contact1Made = value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Message Left'),
                              value: _contact1Msg,
                              onChanged: (value) {
                                setState(() => _contact1Msg = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      // Second Parent/Guardian
                      const SizedBox(height: 16),
                      Text('Second Parent/Guardian (Optional)', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      CustomTextFormWidget(
                        controller: _parent2NameController,
                        hintText: 'Name',
                        title: 'Parent/Guardian name',
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _contact2MethodController,
                        hintText: 'Contact Method',
                        title: 'Method of Contact',
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Contact Date',
                        selectedDate: _contact2Date,
                        onDateSelected: (date) {
                          setState(() => _contact2Date = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Contact Time',
                        hourValue: _contact2TimeHour,
                        minuteValue: _contact2TimeMin,
                        onHourChanged: (value) {
                          setState(() => _contact2TimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _contact2TimeMin = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Contact Made'),
                              value: _contact2Made,
                              onChanged: (value) {
                                setState(() => _contact2Made = value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Message Left'),
                              value: _contact2Msg,
                              onChanged: (value) {
                                setState(() => _contact2Msg = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      // Internal Notifications Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Internal Notifications'),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _responsiblePersonNameController,
                        hintText: 'Name',
                        title: 'Responsible Person in Charge Name',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildSignatureField(
                        title: 'Responsible Person Signature',
                        signature: _responsiblePersonSignature,
                        onTap: () => _captureSignature(
                          onSignatureCapture: (signature) {
                            setState(() => _responsiblePersonSignature = signature);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Notification Date',
                        selectedDate: _rpInternalNotifDate,
                        onDateSelected: (date) {
                          setState(() => _rpInternalNotifDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Notification Time',
                        hourValue: _rpInternalNotifTimeHour,
                        minuteValue: _rpInternalNotifTimeMin,
                        onHourChanged: (value) {
                          setState(() => _rpInternalNotifTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _rpInternalNotifTimeMin = value!);
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _nominatedSupervisorNameController,
                        hintText: 'Name',
                        title: 'Nominated Supervisor Name',
                        validator: (v) => v == null || v.isEmpty ? 'Enter Name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildSignatureField(
                        title: 'Nominated Supervisor Signature',
                        signature: _nominatedSupervisorSignature,
                        onTap: () => _captureSignature(
                          onSignatureCapture: (signature) {
                            setState(() => _nominatedSupervisorSignature = signature);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Date',
                        selectedDate: _nsvDate,
                        onDateSelected: (date) {
                          setState(() => _nsvDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Time',
                        hourValue: _nsvTimeHour,
                        minuteValue: _nsvTimeMin,
                        onHourChanged: (value) {
                          setState(() => _nsvTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _nsvTimeMin = value!);
                        },
                      ),
                      
                      // External Notifications Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('External Notifications'),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _otherAgencyController,
                        hintText: 'Agency',
                        title: 'Other Agency',
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Date',
                        selectedDate: _enorDate,
                        onDateSelected: (date) {
                          setState(() => _enorDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Time',
                        hourValue: _enorTimeHour,
                        minuteValue: _enorTimeMin,
                        onHourChanged: (value) {
                          setState(() => _enorTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _enorTimeMin = value!);
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _regulatoryAuthorityController,
                        hintText: 'Authority',
                        title: 'Regulatory Authority',
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(
                        title: 'Date',
                        selectedDate: _enraDate,
                        onDateSelected: (date) {
                          setState(() => _enraDate = date);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        title: 'Time',
                        hourValue: _enraTimeHour,
                        minuteValue: _enraTimeMin,
                        onHourChanged: (value) {
                          setState(() => _enraTimeHour = value!);
                        },
                        onMinuteChanged: (value) {
                          setState(() => _enraTimeMin = value!);
                        },
                      ),
                      
                      // Additional Notes
                      const SizedBox(height: 24),
                      _buildSectionHeader('Additional Notes'),
                      const SizedBox(height: 16),
                      CustomTextFormWidget(
                        controller: _addNotesController,
                        hintText: 'Additional Notes',
                        title: 'Additional Notes',
                        maxLines: 4,
                      ),
                      
                      // Save and Cancel Buttons
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                            child: Text('CANCEL'),
                          ),
                          const SizedBox(width: 16),
                          CustomButton(
                            text: 'SAVE',
                            height: 50,
                            width: 120,
                            isLoading: _isSaving,
                            ontap: _saveAccident,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Widget builders for common components
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

  Widget _buildDatePicker({
    required String title,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              onDateSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String title,
    required String hourValue,
    required String minuteValue,
    required Function(String?) onHourChanged,
    required Function(String?) onMinuteChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Hour',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: hourValue,
                items: hours.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onHourChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Minute',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: minuteValue,
                items: minutes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onMinuteChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatureField({
    required String title,
    required Uint8List? signature,
    required Function() onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: signature != null ? 100 : 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: signature != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(signature, fit: BoxFit.contain),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.draw),
                        SizedBox(width: 8),
                        Text('Tap to sign'),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInjuryTypeCheckboxes() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 0.0,
      children: [
        _buildInjuryCheckbox('Abrasion/Scrape', _abrasion, (val) => setState(() => _abrasion = val!)),
        _buildInjuryCheckbox('Electric Shock', _electricShock, (val) => setState(() => _electricShock = val!)),
        _buildInjuryCheckbox('Allergic Reaction', _allergicReaction, (val) => setState(() => _allergicReaction = val!)),
        _buildInjuryCheckbox('High Temperature', _highTemperature, (val) => setState(() => _highTemperature = val!)),
        _buildInjuryCheckbox('Amputation', _amputation, (val) => setState(() => _amputation = val!)),
        _buildInjuryCheckbox('Infectious Disease', _infectiousDisease, (val) => setState(() => _infectiousDisease = val!)),
        _buildInjuryCheckbox('Anaphylaxis', _anaphylaxis, (val) => setState(() => _anaphylaxis = val!)),
        _buildInjuryCheckbox('Ingestion', _ingestion, (val) => setState(() => _ingestion = val!)),
        _buildInjuryCheckbox('Asthma', _asthma, (val) => setState(() => _asthma = val!)),
        _buildInjuryCheckbox('Internal Injury', _internalInjury, (val) => setState(() => _internalInjury = val!)),
        _buildInjuryCheckbox('Bite Wound', _biteWound, (val) => setState(() => _biteWound = val!)),
        _buildInjuryCheckbox('Poisoning', _poisoning, (val) => setState(() => _poisoning = val!)),
        _buildInjuryCheckbox('Broken Bone', _brokenBone, (val) => setState(() => _brokenBone = val!)),
        _buildInjuryCheckbox('Rash', _rash, (val) => setState(() => _rash = val!)),
        _buildInjuryCheckbox('Burn', _burn, (val) => setState(() => _burn = val!)),
        _buildInjuryCheckbox('Respiratory', _respiratory, (val) => setState(() => _respiratory = val!)),
        _buildInjuryCheckbox('Choking', _choking, (val) => setState(() => _choking = val!)),
        _buildInjuryCheckbox('Seizure', _seizure, (val) => setState(() => _seizure = val!)),
        _buildInjuryCheckbox('Concussion', _concussion, (val) => setState(() => _concussion = val!)),
        _buildInjuryCheckbox('Sprain', _sprain, (val) => setState(() => _sprain = val!)),
        _buildInjuryCheckbox('Crush', _crush, (val) => setState(() => _crush = val!)),
        _buildInjuryCheckbox('Stabbing', _stabbing, (val) => setState(() => _stabbing = val!)),
        _buildInjuryCheckbox('Cut', _cut, (val) => setState(() => _cut = val!)),
        _buildInjuryCheckbox('Tooth', _tooth, (val) => setState(() => _tooth = val!)),
        _buildInjuryCheckbox('Drowning', _drowning, (val) => setState(() => _drowning = val!)),
        _buildInjuryCheckbox('Venomous Bite', _venomousBite, (val) => setState(() => _venomousBite = val!)),
        _buildInjuryCheckbox('Eye Injury', _eyeInjury, (val) => setState(() => _eyeInjury = val!)),
        _buildInjuryCheckbox('Other', _other, (val) => setState(() => _other = val!)),
      ],
    );
  }

  Widget _buildInjuryCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: value ? Colors.white : Colors.black,
                  fontWeight: value ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
