import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/widget/daily_diaree_custom.dart';
import 'package:mydiaree/features/snapshot/data/model/snapshot_model.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_bloc.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_events.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_state.dart';
import 'package:mydiaree/main.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_bloc.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 150,
              autoPlay: widget.images.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                  print('Carousel changed to image: ${widget.images[index]}');
                });
              },
            ),
            items: widget.images.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        placeholder: (context, url) =>
                            const Center(child: SizedBox()),
                        errorWidget: (context, url, error) => SizedBox()),
                  );
                },
              );
            }).toList(),
          ),
        ),
        if (widget.images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return Container(
                width: 4.0,
                height: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? AppColors.primaryColor
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class PersonItem extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const PersonItem({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const double radius = 23;
    return PatternBackground(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: radius / 2,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: radius / 2,
                backgroundColor: AppColors.grey,
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: radius / 2,
                backgroundColor: AppColors.grey,
                child: const Icon(Icons.error, size: 12, color: Colors.white),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SnapshotCard extends StatelessWidget {
  final int id;
  final String title;
  final String status;
  final List<String> images;
  final String details;
  final List<Child> children;
  final List<String> rooms;
  final bool permissionUpdate;
  final bool permissionDelete;
  final Function onDelete;
  final Function onEdit;

  const SnapshotCard({
    super.key,
    required this.id,
    required this.title,
    required this.status,
    required this.images,
    required this.details,
    required this.children,
    required this.rooms,
    this.permissionUpdate = true,
    this.permissionDelete = true,
    required this.onDelete,
    required this.onEdit,
  });


  void deleteSnapshot(BuildContext context) {
    print('Initiating delete for snapshot ID: $id');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This will permanently delete the snapshot.'),
        actions: [
          TextButton(
            onPressed: () {
              print('Delete cancelled for snapshot ID: $id');
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print('Deleting snapshot ID: $id');
              context.read<SnapshotBloc>().add(DeleteSnapshotEvent(id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 5, left: 5, right: 5),
                child: images.isNotEmpty
                    ? ImageCarousel(images: images)
                    : Container(
                        height: 150,
                        color: Colors.grey.withOpacity(0.1),
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'published' ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  // Children Section
                  if (children.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Children',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 50, // Constrain height
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...children.map((child) => Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: PersonItem(
                                        name: child.name,
                                        imageUrl: child.avatarUrl,
                                      ),
                                    )),
                                const SizedBox(width: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Rooms Section
                  if (rooms.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rooms',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 0),
                        SizedBox(
                          height: 50, // Constrain height
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...rooms.map((room) => Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: PersonItem(
                                        name: (room),
                                      ),
                                    )),
                                const SizedBox(width: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (permissionUpdate)
                        CustomButton(
                          text: 'Edit',
                          width: 80,
                          height: 35,
                          ontap: (){
                            onEdit();
                          },
                          borderRadius: 5,
                        ),
                      const SizedBox(width: 8),
                      if (permissionDelete)
                        CustomButton(
                          text: 'Delete',
                          width: 90,
                          height: 35,
                          color: AppColors.errorColor,
                          ontap: () => deleteSnapshot(context),
                          borderRadius: 5,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
