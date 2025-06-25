import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/custom_card.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/main.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class DashboardScreen extends StatelessWidget {
  static List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  var details = {
    'roomsCount': 0,
    'upcomingEventsCount': 0,
    'staffCount': 0,
    'observationCount': 0,
    'childrenCount': 0,
    'eventsCount': 0
  };
  var dateDetails = {'PublicHolidays': [], 'ChildBirthdays': []};
  List<Map<String, dynamic>> admissionList = [
    {
      'id': 'OU 00456',
      'name': 'Joseph',
      'age': '25',
      'address': '70 Bowman St. South Windsor, CT 06074',
      'number': '404-447-6013',
      'department': 'MCA',
      'color': Colors.blue,
    },
    {
      'id': 'KU 00789',
      'name': 'Cameron',
      'age': '27',
      'address': '123 6th St. Melbourne, FL 32904',
      'number': '404-447-4569',
      'department': 'Medical',
      'color': Colors.orange,
    },
    {
      'id': 'KU 00987',
      'name': 'Alex',
      'age': '23',
      'address': '123 6th St. Melbourne, FL 32904',
      'number': '404-447-7412',
      'department': 'M.COM',
      'color': Colors.blue,
    },
    {
      'id': 'OU 00951',
      'name': 'James',
      'age': '23',
      'address': '44 Shirley Ave. West Chicago, IL 60185',
      'number': '404-447-2589',
      'department': 'MBA',
      'color': Colors.grey,
    },
  ];
  final _focusDay = DateTime.now();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GlobalDataCubit>().loadAll();
    });
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Dashboard',
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Cards Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatCard(
                    icon: Icons.people,
                    iconColor: Colors.blue,
                    title: 'Total Users',
                    value: '256',
                  ),
                  _buildStatCard(
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.red,
                    title: 'Total SuperAdmin',
                    value: '21',
                  ),
                  _buildStatCard(
                    icon: Icons.family_restroom,
                    iconColor: Colors.green,
                    title: 'Total Parents',
                    value: '201',
                  ),
                  _buildStatCard(
                    icon: Icons.badge,
                    iconColor: Colors.orange,
                    title: 'Total Staff',
                    value: '34',
                  ),
                  _buildStatCard(
                    icon: Icons.apartment,
                    iconColor: Colors.green,
                    title: 'Total Centers',
                    value: '282',
                  ),
                  _buildStatCard(
                    icon: Icons.meeting_room,
                    iconColor: Colors.red,
                    title: 'Total Rooms',
                    value: '31',
                  ),
                  _buildStatCard(
                    icon: Icons.receipt_long,
                    iconColor: Colors.grey,
                    title: 'Total Recipes',
                    value: '94',
                  ),
                  _buildStatCard(
                    icon: Icons.mood,
                    iconColor: Colors.green,
                    title: 'Happy Clients',
                    value: '111',
                  ),
                ],
              ),
            ),
            // Weather and Department Charts
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //             flex: 4,
            //             child: Container(
            //               height: 300,
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.grey.shade300),
            //                 borderRadius: BorderRadius.circular(4),
            //               ),
            //               child: const Center(
            //                 child: Text('Weather Panel Placeholder'),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(width: 16),
            //           Expanded(
            //             flex: 4,
            //             child: _buildDepartmentCard(
            //               title: 'Science Department',
            //               subtitle: 'All Earnings are in million \$',
            //               chartType: 'line',
            //               stats: {
            //                 'Overall': '7,000',
            //                 '2016': '2,000',
            //                 '2017': '5,000',
            //               },
            //             ),
            //           ),
            //           const SizedBox(width: 16),
            //           Expanded(
            //             flex: 4,
            //             child: _buildDepartmentCard(
            //               title: 'Commerce Department',
            //               subtitle: 'All Earnings are in million \$',
            //               chartType: 'bar',
            //               stats: {
            //                 'Overall': '3,200',
            //                 '2016': '1,200',
            //                 '2017': '2,000',
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // University Survey
            Padding(
              padding: const EdgeInsets.all(16),
              child: PatternBackground(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'University Survey',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSurveyStat('\$231', "Today's"),
                          _buildSurveyStat('\$1,254', "This Week's"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSurveyStat('\$3,298', "This Month's"),
                          _buildSurveyStat('\$9,208', "This Year's"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // New Admission List
            Padding(
              padding: const EdgeInsets.all(16),
              child: PatternBackground(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Admission List',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: admissionList.length,
                        itemBuilder: (context, index) {
                          final item = admissionList[index];
                          return Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                            child: PatternBackground(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors
                                              .primaryColor
                                              .withOpacity(.3),
                                          child: Text(item['name'][0]),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            // color:  AppColors.primaryColor.withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item['department'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoRow("ID", item['id']),
                                    _buildInfoRow("Age", item['age']),
                                    _buildInfoRow("Address", item['address']),
                                    _buildInfoRow("Phone", item['number']),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),

            // // Satisfaction and Location Row
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         flex: 3,
            //         child: Column(
            //           children: [
            //             _buildKnobCard('Satisfaction Rate', '66', Colors.green),
            //             const SizedBox(height: 16),
            //             _buildKnobCard(
            //                 'Admission in Commerce', '26', Colors.purple),
            //             const SizedBox(height: 16),
            //             _buildKnobCard(
            //                 'Admission in Science', '76', Colors.orange),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         flex: 7,
            //         child: Card(
            //           child: Padding(
            //             padding: const EdgeInsets.all(16),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Our Location',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 16),
            //                 Wrap(
            //                   spacing: 16,
            //                   runSpacing: 16,
            //                   children: [
            //                     _buildLocationStat('America', '53'),
            //                     _buildLocationStat('Canada', '23'),
            //                     _buildLocationStat('UK', '17'),
            //                     _buildLocationStat('India', '102'),
            //                     _buildLocationStat('Australia', '27'),
            //                     _buildLocationStat('Other', '13'),
            //                   ],
            //                 ),
            //                 const SizedBox(height: 20),
            //                 Container(
            //                   height: 300,
            //                   decoration: BoxDecoration(
            //                     border: Border.all(color: Colors.grey.shade300),
            //                     borderRadius: BorderRadius.circular(4),
            //                   ),
            //                   child: const Center(
            //                     child: Text('World Map Placeholder'),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: Card(
            //           child: Padding(
            //             padding: const EdgeInsets.all(16),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Exam Toppers',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 16),
            //                 DataTable(
            //                   columns: const [
            //                     DataColumn(label: Text('First Name')),
            //                     DataColumn(label: Text('Charts')),
            //                   ],
            //                   rows: [
            //                     _buildExamTopperRow(
            //                         'Dean Otto', '5,8,6,3,-5,9,2'),
            //                     _buildExamTopperRow(
            //                         'K. Thornton', '10,-8,-9,3,5,8,5'),
            //                     _buildExamTopperRow('Kane D.', '7,5,9,3,5,2,5'),
            //                     _buildExamTopperRow(
            //                         'Jack Bird', '10,8,1,-3,-3,-8,7'),
            //                     _buildExamTopperRow(
            //                         'Hughe L.', '2,8,9,8,5,1,5'),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: Card(
            //           child: Padding(
            //             padding: const EdgeInsets.all(16),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Timeline',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 16),
            //                 Container(
            //                     decoration: BoxDecoration(
            //                       color: Colors.blue.shade50,
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                     child: Column(children: [
            //                       Container(
            //                         padding: const EdgeInsets.all(16),
            //                         decoration: BoxDecoration(
            //                           color: Colors.blue,
            //                           borderRadius: const BorderRadius.vertical(
            //                               top: Radius.circular(8)),
            //                         ),
            //                         child: const Row(
            //                           children: [
            //                             Text(
            //                               '8',
            //                               style: TextStyle(
            //                                 fontSize: 24,
            //                                 color: Colors.white,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                             ),
            //                             SizedBox(width: 8),
            //                             Column(
            //                               crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                               children: [
            //                                 Text(
            //                                   'Monday',
            //                                   style: TextStyle(
            //                                     color: Colors.white,
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                                 ),
            //                                 Text(
            //                                   'February 2018',
            //                                   style: TextStyle(
            //                                     color: Colors.white,
            //                                     fontSize: 12,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ])),
            //                 Padding(
            //                   padding: const EdgeInsets.all(16),
            //                   child: Column(
            //                     children: [
            //                       _buildTimelineItem(
            //                         Colors.pink,
            //                         '11am',
            //                         'Attendance',
            //                         'Computer Class',
            //                       ),
            //                       _buildTimelineItem(
            //                         Colors.green,
            //                         '12pm',
            //                         'Design Team',
            //                         'Hangouts',
            //                       ),
            //                       _buildTimelineItem(
            //                         Colors.orange,
            //                         '1:30pm',
            //                         'Lunch Break',
            //                         '',
            //                       ),
            //                       _buildTimelineItem(
            //                         Colors.green,
            //                         '2pm',
            //                         'Finish',
            //                         'Go to Home',
            //                       ),
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: Card(
            //           child: Padding(
            //             padding: const EdgeInsets.all(16),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Attendance',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 16),
            //                 Column(
            //                   children: [
            //                     _buildAttendanceItem(
            //                         'Mark Otto', '21%', Colors.blue),
            //                     _buildAttendanceItem(
            //                         'Jacob Thornton', '50%', Colors.purple),
            //                     _buildAttendanceItem(
            //                         'Jacob Thornton', '90%', Colors.green),
            //                     _buildAttendanceItem(
            //                         'M. Arthur', '75%', Colors.blue),
            //                     _buildAttendanceItem(
            //                         'Jacob Thornton', '60%', Colors.orange),
            //                     _buildAttendanceItem(
            //                         'M. Arthur', '91%', Colors.green),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // // Footer
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border(top: BorderSide(color: Colors.grey.shade300)),
            //   ),
            //   child: const Center(
            //     child: Text('© 2025 Mydiaree. All rights reserved.'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

Widget _buildStatCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String value,
}) {
  return PatternBackground(
    width: (screenWidth / 2) - 24, // 2 cards per row with spacing
    height: 150,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDepartmentCard({
  required String title,
  required String subtitle,
  required String chartType,
  required Map<String, String> stats,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${chartType.toUpperCase()} Chart Placeholder',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.entries
                .map((e) => Column(
                      children: [
                        Text(
                          e.key,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          e.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSurveyStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

DataRow _buildDataRow(
  String id,
  String name,
  String age,
  String address,
  String number,
  String department,
  Color badgeColor,
) {
  return DataRow(
    cells: [
      DataCell(Text(id)),
      DataCell(Text(name)),
      DataCell(Text(age)),
      DataCell(Text(address)),
      DataCell(Text(number)),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            department,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildKnobCard(String title, String value, Color color) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$value%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLocationStat(String location, String count) {
  return SizedBox(
    width: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 4),
            Text(location),
          ],
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

DataRow _buildExamTopperRow(String name, String chartData) {
  return DataRow(
    cells: [
      DataCell(Text(name)),
      DataCell(
        Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              chartData,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTimelineItem(
  Color bulletColor,
  String time,
  String title,
  String subtitle,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bulletColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAttendanceItem(String name, String percentage, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            percentage,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text("$label:")),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}
