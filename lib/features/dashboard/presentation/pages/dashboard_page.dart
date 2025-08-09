import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/dashboard/data/repositories/dashbaord_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/dashboard/data/model/dashboard_response.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/dashboard_custom_widget.dart';
import 'package:mydiaree/features/dashboard/data/model/event_response.dart';
import 'package:mydiaree/features/dashboard/data/model/birthday_response.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/dashboard_custom_widget.dart';
import 'package:mydiaree/main.dart';
// ignore: must_be_immutable
class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final repo = DashboardRepository();
  initState() {
    super.initState();
    GlobalRepository().getCenters();
  }

  @override
  Widget build(BuildContext context) {
    
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<ApiResponse<DashboardResponse?>>(
                future: repo.getDashboard(),
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return Padding(
                      padding:   EdgeInsets.only(top: screenHeight*.3),
                      child: const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
                    );
                  }
                  if (snap.hasError ||
                      snap.data == null ||
                      !snap.data!.success ||
                      snap.data!.data?.data == null) {
                    return const Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final stats = snap.data!.data!.data!;

                  final statCards = [
                    {
                      'icon': Icons.people,
                      'iconColor': Colors.blue,
                      'title': 'Total Users',
                      'value': stats.totalUsers.toString(),
                    },
                    {
                      'icon': Icons.admin_panel_settings,
                      'iconColor': Colors.red,
                      'title': 'Total SuperAdmin',
                      'value': stats.totalSuperadmin.toString(),
                    },
                    {
                      'icon': Icons.family_restroom,
                      'iconColor': Colors.green,
                      'title': 'Total Parents',
                      'value': stats.totalParent.toString(),
                    },
                    {
                      'icon': Icons.badge,
                      'iconColor': Colors.orange,
                      'title': 'Total Staff',
                      'value': stats.totalStaff.toString(),
                    },
                    {
                      'icon': Icons.apartment,
                      'iconColor': Colors.green,
                      'title': 'Total Centers',
                      'value': stats.totalCenter.toString(),
                    },
                    {
                      'icon': Icons.meeting_room,
                      'iconColor': Colors.red,
                      'title': 'Total Rooms',
                      'value': stats.totalRooms.toString(),
                    },
                    {
                      'icon': Icons.receipt_long,
                      'iconColor': Colors.grey,
                      'title': 'Total Recipes',
                      'value': stats.totalRecipes.toString(),
                    },
                    // {
                    //   'icon': Icons.mood,
                    //   'iconColor': Colors.teal,
                    //   'title': 'Happy Clients',
                    //   // no field in API; leave blank or compute
                    //   'value': '-',
                    // },
                  ];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: statCards.length,
                    itemBuilder: (c, i) {
                      final card = statCards[i];
                      return PatternBackground(
                        elevation: 0,
                        border: Border.all(
                            color: AppColors.primaryColor, width: .2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        child: StatCard(
                          icon: card['icon'] as IconData,
                          iconColor: card['iconColor'] as Color,
                          title: card['title'] as String,
                          value: card['value'] as String,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // // Calendar
            Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<ApiResponse<dynamic>>>(
                future: Future.wait([
                  repo.getEvents(),
                  repo.getBirthdays(),
                ]),
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center();
                  }
                  if (snap.hasError ||
                      snap.data == null ||
                      snap.data!.any((r) => r == null || !r.success)) {
                    return const Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final eventsRes = snap.data![0] as ApiResponse<EventsResponse?>;
                  final birthdaysRes =
                      snap.data![1] as ApiResponse<BirthdaysResponse?>;
                  final eventsList = eventsRes.data?.events ?? [];
                  final birthdaysList = birthdaysRes.data?.data ?? [];

                  // build map of DateTime → list of markers
                  final Map<DateTime, List<String>> eventsMap = {};
                  for (var ev in eventsList) {
                    final dt = DateTime.parse(ev.eventDate);
                    final key = DateTime(dt.year, dt.month, dt.day);
                    eventsMap.putIfAbsent(key, () => []).add(ev.title);
                  }
                  for (var b in birthdaysList) {
                    final parsed = DateTime.parse(b.dob);
                    final key =
                        DateTime(DateTime.now().year, parsed.month, parsed.day);
                    eventsMap.putIfAbsent(key, () => []).add('🎂 ${b.name}');
                  }

                  return TableCalendar<String>(
                    firstDay: DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: DateTime.now(),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    eventLoader: (day) {
                      final key = DateTime(day.year, day.month, day.day);
                      return eventsMap[key] ?? [];
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      final key = DateTime(
                        selectedDay.year,
                        selectedDay.month,
                        selectedDay.day,
                      );
                      // find birthdays on tapped date
                      final bdays = birthdaysList.where((b) {
                        final dob = DateTime.parse(b.dob);
                        return dob.month == selectedDay.month &&
                               dob.day == selectedDay.day;
                      }).toList();
                      if (bdays.isNotEmpty) {
                        showDialog(
                          context: ctx,
                          builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          title: Row(
                            children: const [
                            Icon(Icons.cake, color: AppColors.primaryColor),
                            SizedBox(width: 8),
                            Text('Birthday Details'),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: bdays.map((b) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3),
                              ),
                              ),
                              child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Text(
                                  b.name.isNotEmpty ? b.name[0] : '',
                                  style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text.rich(
                                    TextSpan(
                                    children: [
                                      const TextSpan(
                                      text: 'Name: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: '${b.name} ${b.lastname}'),
                                    ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text.rich(
                                    TextSpan(
                                    children: [
                                      const TextSpan(
                                      text: 'Gender: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: b.gender),
                                    ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text.rich(
                                    TextSpan(
                                    children: [
                                      const TextSpan(
                                      text: 'DOB: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: b.dob),
                                    ],
                                    ),
                                  ),
                                  ],
                                ),
                                ),
                              ],
                              ),
                            )).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close'),
                            ),
                          ],
                          ),
                        );
                      }
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (ctx, date, events) {
                        final key = DateTime(date.year, date.month, date.day);
                        // birthday icon marker
                        final hasBirthday = birthdaysList.any((b) {
                          final dob = DateTime.parse(b.dob);
                          return dob.month == date.month &&
                                 dob.day == date.day;
                        });
                        if (hasBirthday) {
                          return const Positioned(
                            bottom: 1,
                            child: Icon(
                              Icons.cake,
                              size: 16,
                              color: Colors.amber,
                            ),
                          );
                        }
                        // regular event dot
                        if (events.isNotEmpty) {
                          return const Positioned(
                            bottom: 1,
                            child: Icon(
                              Icons.circle,
                              size: 6,
                              color: Colors.red,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
            ),

            // // Weather and Department Charts
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 16),
            //       PatternBackground(
            //         child: Padding(
            //           padding: const EdgeInsets.all(20),
            //           child: Column(
            //             children: [
            //               Text(
            //                 'Science Department',
            //                 style: Theme.of(context).textTheme.bodyLarge,
            //               ),
            //               Text(
            //                 '(All Earnings are in million \$)',
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .labelSmall
            //                     ?.copyWith(
            //                         // ignore: deprecated_member_use
            //                         color: AppColors.black.withOpacity(.3),
            //                         fontFamily: AppFonts.medium),
            //               ),
            //               CustomPaint(
            //                 size: const Size(300, 200),
            //                 painter: DepartmentLineChartPainter(
            //                   chartColor: AppColors.primaryColor,
            //                   chartData: const {
            //                     '2015': '900',
            //                     '2016': '200',
            //                     '2017': '2,000',
            //                     '2018': '1,800',
            //                     '2019': '500',
            //                     '2020': '2,700',
            //                     '2021': '3,100',
            //                     '2022': '1400',
            //                     '2023': '3,800',
            //                     '2024': '4,200',
            //                     '2025': '1000',
            //                     'Overall': '7,500',
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       PatternBackground(
            //         child: Padding(
            //           padding: const EdgeInsets.all(10),
            //           child: Column(
            //             children: [
            //               Text(
            //                 'Commerce Department',
            //                 style: Theme.of(context).textTheme.bodyLarge,
            //               ),
            //               Text(
            //                 '(All Earnings are in million \$)',
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .labelSmall
            //                     ?.copyWith(
            //                         // ignore: deprecated_member_use
            //                         color: AppColors.black.withOpacity(.3),
            //                         fontFamily: AppFonts.medium),
            //               ),
            //               CustomPaint(
            //                 size: const Size(300, 200),
            //                 painter: DepartmentChartPainter(
            //                   chartType: 'bar',
            //                   chartColor: AppColors.primaryColor,
            //                   chartData: const {
            //                     '2015': '900',
            //                     '2016': '200',
            //                     '2017': '2,000',
            //                     '2018': '1,800',
            //                     '2019': '500',
            //                     '2020': '2,700',
            //                     '2021': '3,100',
            //                     '2022': '1400',
            //                     '2023': '3,800',
            //                     '2024': '4,200',
            //                     '2025': '1000',
            //                     'Overall': '7,500',
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // // University Survey
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: PatternBackground(
            //     width: screenWidth * .9,
            //     child: Padding(
            //       padding: const EdgeInsets.all(16),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'University Survey',
            //             style: Theme.of(context).textTheme.headlineSmall,
            //           ),
            //           const SizedBox(height: 16),
            //           const Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             spacing: 16,
            //             children: [
            //               SurveyStat(
            //                 value: '\$231',
            //                 label: "Today's",
            //               ),
            //               SurveyStat(
            //                 value: '\$1,254',
            //                 label: "This Week's",
            //               ),
            //             ],
            //           ),
            //           const SizedBox(height: 16),
            //           const Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             spacing: 16,
            //             children: [
            //               SurveyStat(
            //                 value: '\$3,298',
            //                 label: "This Month's",
            //               ),
            //               SurveyStat(
            //                 value: '\$9,208',
            //                 label: "This Year's",
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // // // New Admission List
            // // Padding(
            // //   padding: const EdgeInsets.all(16),
            // //   child: PatternBackground(
            // //     child: Padding(
            // //       padding: const EdgeInsets.all(16),
            // //       child: Column(
            // //         crossAxisAlignment: CrossAxisAlignment.start,
            // //         children: [
            // //           Row(
            // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // //             children: [
            // //               Text(
            // //                 'New Admission List',
            // //                 style: Theme.of(context).textTheme.headlineSmall,
            // //               ),
            // //             ],
            // //           ),
            // //           const SizedBox(height: 16),
            // //           SingleChildScrollView(
            // //             scrollDirection: Axis.horizontal,
            // //             child: DataTable(
            // //               columns: [
            // //                 DataColumn(
            // //                     label: Text('ID',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //                 DataColumn(
            // //                     label: Text('Name',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //                 DataColumn(
            // //                     label: Text('Age',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //                 DataColumn(
            // //                     label: Text('Address',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //                 DataColumn(
            // //                     label: Text('Number',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //                 DataColumn(
            // //                     label: Text('Department',
            // //                         style: Theme.of(context)
            // //                             .textTheme
            // //                             .labelLarge)),
            // //               ],
            // //               rows: admissionList
            // //                   .map((item) => DataRow(
            // //                         cells: [
            // //                           DataCell(Text(item['id'],
            // //                               style: Theme.of(context)
            // //                                   .textTheme
            // //                                   .bodyMedium)),
            // //                           DataCell(Text(item['name'],
            // //                               style: Theme.of(context)
            // //                                   .textTheme
            // //                                   .bodyMedium)),
            // //                           DataCell(Text(item['age'],
            // //                               style: Theme.of(context)
            // //                                   .textTheme
            // //                                   .bodyMedium)),
            // //                           DataCell(
            // //                             SizedBox(
            // //                               width: 150,
            // //                               child: Text(
            // //                                 item['address'],
            // //                                 style: Theme.of(context)
            // //                                     .textTheme
            // //                                     .bodyMedium,
            // //                                 overflow: TextOverflow.ellipsis,
            // //                               ),
            // //                             ),
            // //                           ),
            // //                           DataCell(Text(item['number'],
            // //                               style: Theme.of(context)
            // //                                   .textTheme
            // //                                   .bodyMedium)),
            // //                           DataCell(
            // //                             Container(
            // //                               padding: const EdgeInsets.symmetric(
            // //                                   horizontal: 8, vertical: 4),
            // //                               decoration: BoxDecoration(
            // //                                 color:
            // //                                     item['color'].withOpacity(0.2),
            // //                                 borderRadius:
            // //                                     BorderRadius.circular(12),
            // //                               ),
            // //                               child: Text(
            // //                                 item['department'],
            // //                                 style: Theme.of(context)
            // //                                     .textTheme
            // //                                     .bodyMedium!
            // //                                     .copyWith(
            // //                                       color: item['color'],
            // //                                     ),
            // //                               ),
            // //                             ),
            // //                           ),
            // //                         ],
            // //                       ))
            // //                   .toList(),
            // //             ),
            // //           ),
                    
            // //         ],
            // //       ),
            // //     ),
            // //   ),
            // // ),

            // // Satisfaction and Location
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     children: [
            //       PatternBackground(
            //         width: screenWidth * .9,
            //         child: const Column(
            //           children: [
            //             SizedBox(height: 20),
            //             KnobCard(
            //               title: 'Satisfaction Rate',
            //               value: '66',
            //               color: Colors.green,
            //             ),
            //             SizedBox(height: 16),
            //             KnobCard(
            //               title: 'Admission in Commerce',
            //               value: '26',
            //               color: Colors.purple,
            //             ),
            //             SizedBox(height: 16),
            //             KnobCard(
            //               title: 'Admission in Science',
            //               value: '76',
            //               color: Colors.orange,
            //             ),
            //             SizedBox(height: 20),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       PatternBackground(
            //         child: Padding(
            //           padding: const EdgeInsets.all(16),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     'Our Location',
            //                     style:
            //                         Theme.of(context).textTheme.headlineSmall,
            //                   ),
            //                   PopupMenuButton(
            //                     itemBuilder: (context) => [
            //                       const PopupMenuItem(
            //                         value: 1,
            //                         child: Text('Action'),
            //                       ),
            //                       const PopupMenuItem(
            //                         value: 2,
            //                         child: Text('Another Action'),
            //                       ),
            //                       const PopupMenuItem(
            //                         value: 3,
            //                         child: Text('Something else'),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //               const SizedBox(height: 16),
            //               const Wrap(
            //                 spacing: 16,
            //                 runSpacing: 16,
            //                 children: [
            //                   LocationStat(location: 'America', count: '53'),
            //                   LocationStat(location: 'Canada', count: '23'),
            //                   LocationStat(location: 'UK', count: '17'),
            //                   LocationStat(location: 'India', count: '102'),
            //                   LocationStat(location: 'Australia', count: '27'),
            //                   LocationStat(location: 'Other', count: '13'),
            //                 ],
            //               ),
            //               const SizedBox(height: 20),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // // Bottom Row (Exam Toppers, Timeline, Attendance)
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     children: [
            //       PatternBackground(
            //         width: screenWidth * .9,
            //         child: Padding(
            //           padding: const EdgeInsets.all(16),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Exam Toppers',
            //                 style: Theme.of(context).textTheme.headlineSmall,
            //               ),
            //               const SizedBox(height: 16),
            //               DataTable(
            //                 columns: [
            //                   DataColumn(
            //                       label: Text('First Name',
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .labelLarge)),
            //                   DataColumn(
            //                       label: Text('Charts',
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .labelLarge)),
            //                 ],
            //                 rows: [
            //                   ExamTopperRow(
            //                       name: 'Dean Otto', chartData: '5,8,'),
            //                   ExamTopperRow(
            //                       name: 'K. Thornton',
            //                       chartData: '10,-8,-9,3,5,8,5'),
            //                   ExamTopperRow(
            //                       name: 'Kane D.', chartData: '7,5,9,3,5,2,5'),
            //                   ExamTopperRow(
            //                       name: 'Jack Bird',
            //                       chartData: '10,8,1,-3,-3,-8,7'),
            //                   ExamTopperRow(
            //                       name: 'Hughe L.', chartData: '2,8,9,8,5,1,5'),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       PatternBackground(
            //         child: Padding(
            //           padding: const EdgeInsets.all(16),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     'Timeline',
            //                     style:
            //                         Theme.of(context).textTheme.headlineSmall,
            //                   ),
            //                 ],
            //               ),
            //               const SizedBox(height: 16),
            //               PatternBackground(
            //                 child: Column(
            //                   children: [
            //                     Container(
            //                       padding: const EdgeInsets.all(16),
            //                       decoration: const BoxDecoration(
            //                         color: AppColors.primaryColor,
            //                         borderRadius: BorderRadius.vertical(
            //                             top: Radius.circular(8)),
            //                       ),
            //                       child: Row(
            //                         children: [
            //                           Text(
            //                             '8',
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .headlineMedium!
            //                                 .copyWith(color: Colors.white),
            //                           ),
            //                           const SizedBox(width: 8),
            //                           Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: [
            //                               Text(
            //                                 'Monday',
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .titleLarge!
            //                                     .copyWith(color: Colors.white),
            //                               ),
            //                               Text(
            //                                 'February 2018',
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .labelMedium!
            //                                     .copyWith(color: Colors.white),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     TimelineProgressList(
            //                       currentTime: TimeOfDay
            //                           .now(), // you can set static time for testing
            //                       events: [
            //                         TimelineEvent(
            //                             time: "11am",
            //                             title: "Attendance",
            //                             subtitle: "Computer Class",
            //                             color: Colors.pink),
            //                         TimelineEvent(
            //                             time: "12pm",
            //                             title: "Design Team",
            //                             subtitle: "Hangouts",
            //                             color: Colors.green),
            //                         TimelineEvent(
            //                             time: "1:30pm",
            //                             title: "Lunch Break",
            //                             color: Colors.orange),
            //                         TimelineEvent(
            //                             time: "2pm",
            //                             title: "Finish",
            //                             subtitle: "Go to Home",
            //                             color: Colors.green),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       PatternBackground(
            //         child: Padding(
            //           padding: const EdgeInsets.all(16),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Attendance',
            //                 style: Theme.of(context).textTheme.headlineSmall,
            //               ),
            //               const SizedBox(height: 16),
            //               const Column(
            //                 children: [
            //                   AttendanceItem(
            //                       name: 'Mark Otto',
            //                       percentage: '21%',
            //                       color: Colors.blue),
            //                   AttendanceItem(
            //                       name: 'Jacob Thornton',
            //                       percentage: '50%',
            //                       color: Colors.purple),
            //                   AttendanceItem(
            //                       name: 'Jacob Thornton',
            //                       percentage: '90%',
            //                       color: Colors.green),
            //                   AttendanceItem(
            //                       name: 'M. Arthur',
            //                       percentage: '75%',
            //                       color: Colors.blue),
            //                   AttendanceItem(
            //                       name: 'Jacob Thornton',
            //                       percentage: '60%',
            //                       color: Colors.orange),
            //                   AttendanceItem(
            //                       name: 'M. Arthur',
            //                       percentage: '91%',
            //                       color: Colors.green),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
         
         
          ],
        ),
      ),
    );
  }
}
