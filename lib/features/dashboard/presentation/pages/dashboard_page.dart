import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/features/dashboard/data/repositories/dashbaord_repository.dart';
import 'package:mydiaree/features/dashboard/data/model/dashboard_response.dart';
import 'package:mydiaree/features/dashboard/data/model/event_response.dart';
import 'package:mydiaree/features/dashboard/data/model/birthday_response.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/dashboard_custom_widget.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';
import 'package:mydiaree/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final repo = DashboardRepository();

  // Dashboard stats
  DashboardResponse? _dashboardData;
  bool _isLoadingStats = true;
  String? _statsError;

  // Calendar data
  List<Event> _eventsList = [];
  List<ChildBirthday> _birthdaysList = [];
  Map<DateTime, List<String>> _eventsMap = {};
  bool _isLoadingCalendar = true;
  String? _calendarError;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    GlobalRepository().getCenters();
    _loadDashboardData();
    _loadCalendarData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoadingStats = true;
      _statsError = null;
    });
    final response = await repo.getDashboard();
    if (response.success && response.data != null) {
      setState(() {
        _dashboardData = response.data;
        _isLoadingStats = false;
      });
    } else {
      setState(() {
        _statsError = response.message;
        _isLoadingStats = false;
      });
    }
  }

  Future<void> _loadCalendarData() async {
    setState(() {
      _isLoadingCalendar = true;
      _calendarError = null;
    });
    try {
      final eventsRes = await repo.getEvents();
      final birthdaysRes = await repo.getBirthdays();

      List<Event> eventsList = [];
      List<ChildBirthday> birthdaysList = [];
      final Map<DateTime, List<String>> eventsMap = {};

      if (eventsRes.success && eventsRes.data?.events != null) {
        eventsList = eventsRes.data!.events!;
      }
      if (birthdaysRes.success && birthdaysRes.data?.data != null) {
        birthdaysList = birthdaysRes.data!.data!;
      }

      for (var ev in eventsList) {
        final dt = DateTime.parse(ev.eventDate);
        final key = DateTime(dt.year, dt.month, dt.day);
        eventsMap.putIfAbsent(key, () => []).add(ev.title);
      }
      for (var b in birthdaysList) {
        final parsed = DateTime.parse(b.dob);
        final key = DateTime(DateTime.now().year, parsed.month, parsed.day);
        eventsMap.putIfAbsent(key, () => []).add('🎂 ${b.name}');
      }

      setState(() {
        _eventsList = eventsList;
        _birthdaysList = birthdaysList;
        _eventsMap = eventsMap;
        _isLoadingCalendar = false;
      });
    } catch (e) {
      setState(() {
        _calendarError = 'Failed to load calendar data';
        _isLoadingCalendar = false;
      });
    }
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
    });
  }

  Widget _buildStatsSection() {
    if (_isLoadingStats) {
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * .3),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_statsError != null || _dashboardData?.data == null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _statsError ?? 'No data available',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final stats = _dashboardData!.data!;
    final statCards = [
      {
        'icon': Icons.people,
        'iconColor': Colors.blue,
        'title': 'Total Users',
        'value': stats.totalUsers.toString(),
      },
      // {
      //   'icon': Icons.admin_panel_settings,
      //   'iconColor': Colors.red,
      //   'title': 'Total SuperAdmin',
      //   'value': stats.totalSuperadmin.toString(),
      // },
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
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          border: Border.all(color: AppColors.primaryColor, width: .2),
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
  }

  Widget _buildCalendarSection() {
    if (_isLoadingStats) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Today Button
          if (!_isLoadingCalendar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: _goToToday,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.today, size: 18),
                  label: const Text('Today'),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (_isLoadingCalendar)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: SizedBox(),
              ),
            )
          else if (_calendarError != null)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _calendarError!,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCalendarData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            TableCalendar<String>(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                // markerDecoration: const BoxDecoration(
                //   color: Colors.red,
                //   shape: BoxShape.circle,
                // ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              availableGestures: AvailableGestures.none,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return _eventsMap[key] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });

                final bdays = _birthdaysList.where((b) {
                  final dob = DateTime.parse(b.dob);
                  return dob.month == selectedDay.month &&
                      dob.day == selectedDay.day;
                }).toList();

                if (bdays.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.white,
                      title: const Row(
                        children: [
                          Icon(Icons.cake, color: AppColors.primaryColor),
                          SizedBox(width: 8),
                          Text('Birthday Details'),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bdays
                              .map((b) => Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              AppColors.primaryColor,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Name: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '${b.name} ${b.lastname}'),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Gender: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                  ))
                              .toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (ctx, date, events) {
                  final hasBirthday = _birthdaysList.any((b) {
                    final dob = DateTime.parse(b.dob);
                    return dob.month == date.month && dob.day == date.day;
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
                  if (events.isNotEmpty) {
                    // return const Positioned(
                    //   bottom: 1,
                    //   child: Icon(
                    //     Icons.circle,
                    //     size: 6,
                    //     color: Colors.red,
                    //   ),
                    // );
                  }
                  return const SizedBox();
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 300,
              child: Builder(
                builder: (context) {
                  try {
                    final controller = WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(
                        Uri.parse(
                            "https://www.sunsmart.com.au/uvalert/default.asp?version=australia&locationid=161"),
                      );
                    return WebViewWidget(controller: controller);
                  } catch (e) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            'Failed to load UV Alert.',
                            style: TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Optionally, you can trigger a setState to retry
                              (context as Element).markNeedsBuild();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildStatsSection(),
            ),
            _buildCalendarSection(),
            // ...other dashboard widgets...
          ],
        ),
      ),
    );
  }
}
