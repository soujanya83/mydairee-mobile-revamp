import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/dashboard_custom_widget.dart';
import 'package:mydiaree/main.dart';

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

  DashboardScreen({super.key});
  final GlobalRepository globalRepository = GlobalRepository();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (centerDataGloble == null) {
        centerDataGloble = await globalRepository.getCenters();
      }
    });
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Dashboard',
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Cards Column
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  final statCards = [
                    {
                      'icon': Icons.people,
                      'iconColor': Colors.blue,
                      'title': 'Total Users',
                      'value': '256',
                    },
                    {
                      'icon': Icons.admin_panel_settings,
                      'iconColor': Colors.red,
                      'title': 'Total SuperAdmin',
                      'value': '21',
                    },
                    {
                      'icon': Icons.family_restroom,
                      'iconColor': Colors.green,
                      'title': 'Total Parents',
                      'value': '201',
                    },
                    {
                      'icon': Icons.badge,
                      'iconColor': Colors.orange,
                      'title': 'Total Staff',
                      'value': '34',
                    },
                    {
                      'icon': Icons.apartment,
                      'iconColor': Colors.green,
                      'title': 'Total Centers',
                      'value': '282',
                    },
                    {
                      'icon': Icons.meeting_room,
                      'iconColor': Colors.red,
                      'title': 'Total Rooms',
                      'value': '31',
                    },
                    {
                      'icon': Icons.receipt_long,
                      'iconColor': Colors.grey,
                      'title': 'Total Recipes',
                      'value': '94',
                    },
                    {
                      'icon': Icons.mood,
                      'iconColor': Colors.green,
                      'title': 'Happy Clients',
                      'value': '111',
                    },
                  ];
                  return PatternBackground(
                    elevation: 0,
                    border:
                        Border.all(color: AppColors.primaryColor, width: .2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    child: StatCard(
                      icon: statCards[index]['icon'] as IconData,
                      iconColor: statCards[index]['iconColor'] as Color,
                      title: statCards[index]['title'] as String,
                      value: statCards[index]['value'] as String,
                    ),
                  );
                },
              ),
            ),

            // Weather and Department Charts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  PatternBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Science Department',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            '(All Earnings are in million \$)',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    // ignore: deprecated_member_use
                                    color: AppColors.black.withOpacity(.3),
                                    fontFamily: AppFonts.medium),
                          ),
                          CustomPaint(
                            size: const Size(300, 200),
                            painter: DepartmentLineChartPainter(
                              chartColor: AppColors.primaryColor,
                              chartData: const {
                                '2015': '900',
                                '2016': '200',
                                '2017': '2,000',
                                '2018': '1,800',
                                '2019': '500',
                                '2020': '2,700',
                                '2021': '3,100',
                                '2022': '1400',
                                '2023': '3,800',
                                '2024': '4,200',
                                '2025': '1000',
                                'Overall': '7,500',
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PatternBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Commerce Department',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            '(All Earnings are in million \$)',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    // ignore: deprecated_member_use
                                    color: AppColors.black.withOpacity(.3),
                                    fontFamily: AppFonts.medium),
                          ),
                          CustomPaint(
                            size: const Size(300, 200),
                            painter: DepartmentChartPainter(
                              chartType: 'bar',
                              chartColor: AppColors.primaryColor,
                              chartData: const {
                                '2015': '900',
                                '2016': '200',
                                '2017': '2,000',
                                '2018': '1,800',
                                '2019': '500',
                                '2020': '2,700',
                                '2021': '3,100',
                                '2022': '1400',
                                '2023': '3,800',
                                '2024': '4,200',
                                '2025': '1000',
                                'Overall': '7,500',
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // University Survey
            Padding(
              padding: const EdgeInsets.all(16),
              child: PatternBackground(
                width: screenWidth * .9,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'University Survey',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 16,
                        children: [
                          SurveyStat(
                            value: '\$231',
                            label: "Today's",
                          ),
                          SurveyStat(
                            value: '\$1,254',
                            label: "This Week's",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 16,
                        children: [
                          SurveyStat(
                            value: '\$3,298',
                            label: "This Month's",
                          ),
                          SurveyStat(
                            value: '\$9,208',
                            label: "This Year's",
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New Admission List',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('ID',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            DataColumn(
                                label: Text('Name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            DataColumn(
                                label: Text('Age',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            DataColumn(
                                label: Text('Address',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            DataColumn(
                                label: Text('Number',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            DataColumn(
                                label: Text('Department',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                          ],
                          rows: admissionList
                              .map((item) => DataRow(
                                    cells: [
                                      DataCell(Text(item['id'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                      DataCell(Text(item['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                      DataCell(Text(item['age'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                      DataCell(
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            item['address'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(item['number'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                item['color'].withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            item['department'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: item['color'],
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Satisfaction and Location
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PatternBackground(
                    width: screenWidth * .9,
                    child: const Column(
                      children: [
                        SizedBox(height: 20),
                        KnobCard(
                          title: 'Satisfaction Rate',
                          value: '66',
                          color: Colors.green,
                        ),
                        SizedBox(height: 16),
                        KnobCard(
                          title: 'Admission in Commerce',
                          value: '26',
                          color: Colors.purple,
                        ),
                        SizedBox(height: 16),
                        KnobCard(
                          title: 'Admission in Science',
                          value: '76',
                          color: Colors.orange,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PatternBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Our Location',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text('Action'),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Text('Another Action'),
                                  ),
                                  const PopupMenuItem(
                                    value: 3,
                                    child: Text('Something else'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              LocationStat(location: 'America', count: '53'),
                              LocationStat(location: 'Canada', count: '23'),
                              LocationStat(location: 'UK', count: '17'),
                              LocationStat(location: 'India', count: '102'),
                              LocationStat(location: 'Australia', count: '27'),
                              LocationStat(location: 'Other', count: '13'),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Row (Exam Toppers, Timeline, Attendance)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PatternBackground(
                    width: screenWidth * .9,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exam Toppers',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          DataTable(
                            columns: [
                              DataColumn(
                                  label: Text('First Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
                              DataColumn(
                                  label: Text('Charts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
                            ],
                            rows: [
                              ExamTopperRow(
                                  name: 'Dean Otto', chartData: '5,8,'),
                              ExamTopperRow(
                                  name: 'K. Thornton',
                                  chartData: '10,-8,-9,3,5,8,5'),
                              ExamTopperRow(
                                  name: 'Kane D.', chartData: '7,5,9,3,5,2,5'),
                              ExamTopperRow(
                                  name: 'Jack Bird',
                                  chartData: '10,8,1,-3,-3,-8,7'),
                              ExamTopperRow(
                                  name: 'Hughe L.', chartData: '2,8,9,8,5,1,5'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PatternBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Timeline',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PatternBackground(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8)),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '8',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Monday',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: Colors.white),
                                          ),
                                          Text(
                                            'February 2018',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                TimelineProgressList(
                                  currentTime: TimeOfDay
                                      .now(), // you can set static time for testing
                                  events: [
                                    TimelineEvent(
                                        time: "11am",
                                        title: "Attendance",
                                        subtitle: "Computer Class",
                                        color: Colors.pink),
                                    TimelineEvent(
                                        time: "12pm",
                                        title: "Design Team",
                                        subtitle: "Hangouts",
                                        color: Colors.green),
                                    TimelineEvent(
                                        time: "1:30pm",
                                        title: "Lunch Break",
                                        color: Colors.orange),
                                    TimelineEvent(
                                        time: "2pm",
                                        title: "Finish",
                                        subtitle: "Go to Home",
                                        color: Colors.green),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PatternBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          const Column(
                            children: [
                              AttendanceItem(
                                  name: 'Mark Otto',
                                  percentage: '21%',
                                  color: Colors.blue),
                              AttendanceItem(
                                  name: 'Jacob Thornton',
                                  percentage: '50%',
                                  color: Colors.purple),
                              AttendanceItem(
                                  name: 'Jacob Thornton',
                                  percentage: '90%',
                                  color: Colors.green),
                              AttendanceItem(
                                  name: 'M. Arthur',
                                  percentage: '75%',
                                  color: Colors.blue),
                              AttendanceItem(
                                  name: 'Jacob Thornton',
                                  percentage: '60%',
                                  color: Colors.orange),
                              AttendanceItem(
                                  name: 'M. Arthur',
                                  percentage: '91%',
                                  color: Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
