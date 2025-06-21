import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/custom_card.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
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
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomCard(
                    title: 'Upcoming Events',
                    count: details['upcomingEventsCount'],
                    imagePath: AppAssets.room,
                    onTap: () {},
                  ),
                  CustomCard(
                    title: 'Observation',
                    count: details['observationCount'],
                    imagePath: AppAssets.room,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: (MediaQuery.of(context).size.width * 0.03)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomCard(
                    title: 'Children',
                    count: details['childrenCount'],
                    imagePath: AppAssets.room,
                    onTap: () {},
                  ),
                  CustomCard(
                    title: 'Events',
                    count: details['eventsCount'],
                    imagePath: AppAssets.room,
                    onTap: () {},
                  ),
                ],
              ),
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 18.0, left: 5, right: 5),
                child: TableCalendar(
                  onPageChanged: (focusedDay) {},
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      return null;
                    },
                  ),
                  selectedDayPredicate: (day) {
                    return false;
                  },
                  calendarFormat: CalendarFormat.month,
                  availableGestures: AvailableGestures.all,
                  onDaySelected: (selectedDay, focusedDay) {},
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primaryColor, // Use your selected color
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryColor
                          // ignore: deprecated_member_use
                          .withOpacity(0.5), // Unselected/today color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
