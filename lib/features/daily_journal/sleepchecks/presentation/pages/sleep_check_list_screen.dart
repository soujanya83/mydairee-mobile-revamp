import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/models/sleep_check_response_model.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/repositories/sleep_check_repository.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';

class SleepCheckListScreen extends StatefulWidget {
  const SleepCheckListScreen({super.key});

  @override
  State<SleepCheckListScreen> createState() => _SleepCheckListScreenState();
}

class _SleepCheckListScreenState extends State<SleepCheckListScreen> {
  String selectedCenterId = ''; // Default center
  String? selectedRoomId;
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;
  bool isLoadingRooms = true;
  
  // Sleep checks data
  List<ChildWithSleepChecks> children = [];
  List<Room> rooms = []; 
  List<CenterModel> centers = [];
  
  // Form fields for adding/editing sleep checks
  final List<String> breathingOptions = ['Regular', 'Fast', 'Difficult'];
  final List<String> bodyTempOptions = ['Warm', 'Cool', 'Hot'];
  
  // Currently editing sleep check
  int? editingSleepCheckId;
  int? selectedChildId;
  String selectedTime = '';
  String selectedBreathing = 'Regular';
  String selectedBodyTemp = 'Warm';
  TextEditingController notesController = TextEditingController();
  
  // Repositories
  final SleepCheckRepository _repository = SleepCheckRepository();
  final RoomRepository _roomRepository = RoomRepository();

  @override
  void initState() {
    super.initState();
    selectedCenterId = globalSelectedCenterId??'';
    print('Initializing SleepCheckListScreen with center ID: $selectedCenterId');
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      isLoadingRooms = true;
      rooms = [];
      selectedRoomId = null;
    });

    try {
      print('Fetching rooms for center ID: $selectedCenterId'); 
      final roomsResponse = await _roomRepository.getRooms(centerId: selectedCenterId);
      
      if (roomsResponse.success && roomsResponse.data != null) {
        print('Room response received: ${roomsResponse.success}');
        
        if (roomsResponse.data!.rooms != null) {
          setState(() {
            rooms = roomsResponse.data!.rooms ?? [];
            print('Loaded ${rooms.length} rooms with structure: ${rooms.map((r) => '${r.id}: ${r.name ?? "unnamed"}').join(', ')}');
            
            if (rooms.isNotEmpty) {
              selectedRoomId = rooms.first.id.toString();
              print('Selected first room with ID: $selectedRoomId');
            } else {
              print('No rooms found for center: $selectedCenterId');
            }
          });
          
          // Only load sleep checks if we have a selected room
          if (selectedRoomId != null) {
            _loadSleepChecks();
          } else {
            setState(() {
              isLoading = false;
              children = [];
            });
          }
        } else {
          print('Room data is null in response');
          setState(() {
            rooms = [];
            isLoading = false;
          });
        }
      } else {
        print('Room response failed: ${roomsResponse.message}');
        setState(() {
          rooms = [];
          selectedRoomId = null;
          isLoading = false;
          children = [];
        });
        UIHelpers.showToast(
          context,
          message: 'Failed to load rooms: ${roomsResponse.message}',
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print('Error loading rooms: $e');
      setState(() {
        rooms = [];
        selectedRoomId = null;
        isLoading = false;
        children = [];
      });
      UIHelpers.showToast(
        context,
        message: 'Error loading rooms: $e',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        isLoadingRooms = false;
      });
    }
  }

  Future<void> _loadSleepChecks() async {
    if (selectedRoomId == null) {
      setState(() {
        isLoading = false;
        children = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
      children = [];
    });

    try {
      print('Loading sleep checks for center: $selectedCenterId, room: $selectedRoomId, date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
      
      final response = await _repository.getSleepChecks(
        centerId: selectedCenterId,
        roomId: selectedRoomId,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
      );
      print('Sleep check response: ${response.success}');
      if (response.success && response.data != null) {
        print('Sleep check data: ${response.data?.children.length} children found');
        setState(() {
          children = response.data!.children;
          centers = response.data!.centers;
          print('Loaded ${children.length} children with sleep checks');
        });
      } else {
        setState(() {
          children = [];
        });
        print('Failed to load sleep checks: ${response.message}');
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      setState(() {
        children = [];
      });
      print('Error loading sleep checks: $e');
      UIHelpers.showToast(
        context,
        message: 'Error loading sleep checks: $e',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetForm() {
    setState(() {
      editingSleepCheckId = null;
      selectedChildId = null;
      selectedTime = '';
      selectedBreathing = 'Regular';
      selectedBodyTemp = 'Warm';
      notesController.clear();
    });
  }

  Future<void> _saveSleepCheck() async {
    if (selectedChildId == null) {
      UIHelpers.showToast(
        context,
        message: 'Please select a child',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    if (selectedTime.isEmpty) {
      UIHelpers.showToast(
        context,
        message: 'Please select a time',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = editingSleepCheckId != null
          ? await _repository.updateSleepCheck(
              id: editingSleepCheckId!,
              childId: selectedChildId!,
              diaryDate: DateFormat('dd-MM-yyyy').format(selectedDate),
              roomId: int.parse(selectedRoomId!),
              time: selectedTime,
              breathing: selectedBreathing,
              bodyTemperature: selectedBodyTemp,
              notes: notesController.text,
              userId: 1, // Replace with actual user ID when available
            )
          : await _repository.saveSleepCheck(
              childId: selectedChildId!,
              diaryDate: DateFormat('dd-MM-yyyy').format(selectedDate),
              roomId: int.parse(selectedRoomId!),
              time: selectedTime,
              breathing: selectedBreathing,
              bodyTemperature: selectedBodyTemp,
              notes: notesController.text,
              userId: 1, // Replace with actual user ID when available
            );
      
      UIHelpers.showToast(
        context,
        message: response.message,
        backgroundColor: response.success ? AppColors.successColor : AppColors.errorColor,
      );
      
      if (response.success) {
        _resetForm();
        Navigator.pop(context); // Close dialog if open
        _loadSleepChecks();
      }
    } catch (e) {
      UIHelpers.showToast(
        context,
        message: 'Error saving sleep check: $e',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteSleepCheck(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _repository.deleteSleepCheck(id: id);
      
      UIHelpers.showToast(
        context,
        message: response.message,
        backgroundColor: response.success ? AppColors.successColor : AppColors.errorColor,
      );
      
      if (response.success) {
        _loadSleepChecks();
      }
    } catch (e) {
      UIHelpers.showToast(
        context,
        message: 'Error deleting sleep check: $e',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDeleteConfirmDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this sleep check?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSleepCheck(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editSleepCheck(SleepCheck sleepCheck) {
    setState(() {
      editingSleepCheckId = sleepCheck.id;
      selectedChildId = sleepCheck.childid;
      selectedTime = sleepCheck.time;
      selectedBreathing = sleepCheck.breathing;
      selectedBodyTemp = sleepCheck.body_temperature;
      notesController.text = sleepCheck.notes;
    });
    
    _showAddSleepCheckDialog(
      children.firstWhere((child) => child.id == sleepCheck.childid)
    );
  }

  String _formatTimeString(String inputTime) {
    try {
      String cleaned = inputTime.replaceAll(RegExp(r'[^0-9:]'), '');
      List<String> parts = cleaned.split(':');
      if (parts.length != 2) {
        throw FormatException('Invalid time format');
      }
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw FormatException('Time values out of range');
      }
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error formatting time: $e');
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Sleep Check List'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Date row
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text('Sleep Check List',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                _buildDatePicker(),
              ],
            ),
          ),
          
          // Center Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CenterDropdown(
              selectedCenterId: selectedCenterId,
              onChanged: (center) async {
                print('Selected center: ${center.centerName} with ID: ${center.id}');
                final newCenterId = center.id.toString();
                
                if (newCenterId != selectedCenterId) {
                  setState(() {
                    selectedCenterId = newCenterId;
                    selectedRoomId = null;
                    rooms = [];
                    children = [];
                  });
                  
                  // Fetch rooms for the selected center
                  await _fetchRooms();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Room Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildRoomDropdown(),
          ),
          const SizedBox(height: 16),
          
          // Sleep Check List
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : children.isEmpty
                ? const Center(child: Text('No children found for this room'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      return _buildChildCard(child);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDropdown() {
    if (isLoadingRooms) {
      print('Showing loading indicator for rooms');
      return Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    
    print('Rooms list status: ${rooms.length} items');
    if (rooms.isEmpty) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('No rooms available for this center'),
        ),
      );
    }
    
    print('Building dropdown with rooms: ${rooms.map((r) => '${r.id}: ${r.name}').join(', ')}');
    
    // Find the currently selected room object
    Room? selectedRoom;
    if (selectedRoomId != null) {
      try {
        selectedRoom = rooms.firstWhere((room) => room.id.toString() == selectedRoomId);
        print('Found selected room: ${selectedRoom.name}');
      } catch (e) {
        print('Selected room not found in list: $e');
        selectedRoom = null;
      }
    }
    
    return CustomDropdown<Room>(
      
      value: selectedRoom,
      items: rooms,
      hint: 'Select Room',
      borderColor: AppColors.primaryColor,
      height: 40,
      displayItem: (room) => room.name ?? 'Room ${room.id}',
      onChanged: (room) {
        if (room != null) {
          final roomId = room.id.toString();
          print('Selected room: ${room.name} with ID: $roomId');
          setState(() {
            selectedRoomId = roomId;
            children = [];
          });
          _loadSleepChecks();
        }
      },
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
          _loadSleepChecks();
        }
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(ChildWithSleepChecks child) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: PatternBackground(
        child: Column(
          children: [
            // Child info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1.0),
                      ),
                      child: Builder(
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 2), () {
                           print('${AppUrls.baseUrl}/${child.imageUrl}');
                          });
                          return CustomNetworkImage(
                            fullUrl: child.imageUrl.isNotEmpty 
                                ? '${AppUrls.baseUrl}/${child.imageUrl}'
                                : '',
                            placeholder: Center(
                              child: Text(
                                child.name.isNotEmpty ? child.name[0] : '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${child.name} ${child.lastname}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // Sleep checks list
            child.sleepchecks.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No sleep checks recorded for this child'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: child.sleepchecks.length,
                    itemBuilder: (context, index) {
                      final sleepCheck = child.sleepchecks[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: PatternBackground(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Time row
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Time: ${sleepCheck.time}'),
                                        const SizedBox(height: 8),
                                        Text('Breathing: ${sleepCheck.breathing}'),
                                        const SizedBox(height: 8),
                                        Text('Body Temperature: ${sleepCheck.body_temperature}'),
                                      ],
                                    ),
                                    const Spacer(),
                                    // Edit/Delete buttons
                                     if(!UserTypeHelper.isParent)
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                                          onPressed: () => _editSleepCheck(sleepCheck),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _showDeleteConfirmDialog(sleepCheck.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (sleepCheck.notes.isNotEmpty) ...[
                                  const Divider(),
                                  Text('Notes: ${sleepCheck.notes}'),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            
            // Add sleep check button
            if(!UserTypeHelper.isParent)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ADD SLEEP CHECK',
                      style: Theme.of(context).textTheme.titleMedium),
                  CustomButton(
                    height: 40,
                    width: 80,
                    text: 'ADD',
                    ontap: () {
                      _resetForm();
                      setState(() {
                        selectedChildId = child.id;
                        selectedTime = DateFormat('HH:mm').format(DateTime.now());
                      });
                      _showAddSleepCheckDialog(child);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddSleepCheckDialog(ChildWithSleepChecks child) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: Text(editingSleepCheckId != null 
                  ? 'Edit Sleep Check for ${child.name}'
                  : 'Add Sleep Check for ${child.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time picker
                    Text('Time', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay initialTime = selectedTime.isNotEmpty
                            ? TimeOfDay(
                                hour: int.parse(selectedTime.split(':')[0]),
                                minute: int.parse(selectedTime.split(':')[1]),
                              )
                            : TimeOfDay.now();
                        
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedTime.isEmpty ? 'Select Time' : selectedTime),
                            const Icon(Icons.access_time, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Breathing dropdown
                    Text('Breathing', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedBreathing,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items: breathingOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedBreathing = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Body temperature dropdown
                    Text('Body Temperature', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedBodyTemp,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items: bodyTempOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedBodyTemp = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Notes
                    Text('Notes', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter any notes about the sleep check',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _saveSleepCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    editingSleepCheckId != null ? 'Update' : 'Save',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}