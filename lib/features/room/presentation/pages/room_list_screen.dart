import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/hexconversion.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/main.dart';

// ignore: must_be_immutable
class RoomsListScreen extends StatelessWidget {
  RoomsListScreen({super.key});
  String _chosenValue = 'Select';
  String searchString = '';
  bool roomsFetched = true;
  bool usersFetched = true;
  int currentIndex = 0;
  List<bool> checkValues = [
    false,
    false,
    false,
    false,
    false
  ]; // Sample check values
  List statList = [];
  bool centersFetched = true;
  bool permissionAdd = true;
  bool permission = true;
  bool permissionDel = true;
  bool permissionupdate = true;

  // Sample static data
  final List<Map<String, dynamic>> centers = [
    {'id': '1', 'centerName': 'Main Center'},
    {'id': '2', 'centerName': 'North Branch'},
    {'id': '3', 'centerName': 'South Branch'},
  ];

  // Sample room data
  final List<Map<String, dynamic>> _rooms = [
    {
      'room': {
        'id': '1',
        'name': 'Room A',
        'color': '#FF5733',
        'userName': 'John Doe',
        'status': 'Active'
      },
      'child': [
        {'name': 'Child 1'},
        {'name': 'Child 2'},
      ]
    },
    {
      'room': {
        'id': '2',
        'name': 'Room B',
        'color': '#33FF57',
        'userName': 'Jane Smith',
        'status': 'Active'
      },
      'child': [
        {'name': 'Child 3'},
      ]
    },
    {
      'room': {
        'id': '3',
        'name': 'Room C',
        'color': '#3357FF',
        'userName': 'Mike Johnson',
        'status': 'Inactive'
      },
      'child': []
    },
    {
      'room': {
        'id': '3',
        'name': 'Room C',
        'color': '#3357FF',
        'userName': 'Mike Johnson',
        'status': 'Inactive'
      },
      'child': []
    },
    {
      'room': {
        'id': '3',
        'name': 'Room C',
        'color': '#3357FF',
        'userName': 'Mike Johnson',
        'status': 'Inactive'
      },
      'child': []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "Rooms",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Rooms',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  const SizedBox(width: 8),
                  if (permissionAdd)
                    UIHelpers.addButton(context: context, ontap: () {})
                ],
              ),
              const SizedBox(height: 5),
              if (centersFetched)
                CustomDropdown(
                    height: 35,
                    onChanged: (value) {},
                    value: centers[currentIndex]['centerName'],
                    items: centers
                        .map((center) => center['centerName'] as String)
                        .toList()),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                child: CustomTextFormWidget(
                  contentpadding: const EdgeInsets.only(top: 4),
                  prefixWidget: const Icon(Icons.search),
                  height: 40,
                  hintText: '',
                ),
              ),
              const SizedBox(height: 5),
              CustomDropdown(
                  height: 35,
                  width: screenWidth * .3,
                  onChanged: (value) {},
                  value: 'Select',
                  items: const <String>['Select', 'Active', 'Inactive']),
              if (_rooms.isNotEmpty)
                Container(
                  height: _rooms.length * 160.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _rooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      return searchString == ''
                          ? roomCard(_rooms[index], index)
                          : _rooms[index]['room']['name']
                                  .toLowerCase()
                                  .contains(searchString.toLowerCase())
                              ? roomCard(_rooms[index], index)
                              : Container();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roomCard(Map<String, dynamic> r, int index) {
    Color _safeHexColor(String? color) {
      try {
        return HexColor(color ?? "#FFFFFF");
      } catch (e) {
        return HexColor("#FFFFFF"); // Default to white on error
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PatternBackground(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _safeHexColor(r['room']['color']),
                  Colors.transparent,
                ],
                stops: [0.02, 0.02],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          r['room']['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (permissionupdate)
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: AppColors.primaryColor),
                          onPressed: () {},
                        ),
                      Checkbox(
                        value: true,
                        fillColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                        onChanged: (val) {},
                        overlayColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.child_care, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        r['child'].isNotEmpty
                            ? r['child'].length.toString()
                            : '0',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        r['room']['userName'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(' (Lead)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Items?"),
          content: Text("This action cannot be undone."),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text("Delete"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted successfully")),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
