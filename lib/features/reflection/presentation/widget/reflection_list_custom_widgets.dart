import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_list_model_screen.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({required this.images});

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
                      placeholder: (context, url) => const Center(),
                      errorWidget: (context, url, error) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Center(),
                      ),
                    ),
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

class ChildrenModel {
  final String name;
  final String imageUrl;

  ChildrenModel({required this.name, required this.imageUrl});
}

class EducatorModel {
  final String name;
  final String imageUrl;

  EducatorModel({required this.name, required this.imageUrl});
}

class ReflectionCard extends StatelessWidget {
  // final Reflection reflection;
  final bool permissionUpdate;
  final bool permissionDelete;
  final VoidCallback onEditPressed;
  final List<String> images;
  final String title;
  final String date;
  final List<ChildrenModel> children;
  final List<EducatorModel> educators;

  const ReflectionCard({
    // required this.reflection,
    required this.children,
    required this.educators,
    required this.images,
    required this.title,
    required this.date,
    required this.permissionUpdate,
    required this.permissionDelete,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      elevation: 4,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              images.isNotEmpty
                  ? ImageCarousel(images: images)
                  : Container(
                      height: 200,
                      color: Colors.grey.withOpacity(.1),
                      child: Center(
                        child: Icon(Icons.image,
                            size: 50, color: Colors.grey[400]),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Children',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final showCount = children.length;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(showCount, (i) {
                                    return Transform.translate(
                                      offset: Offset(i * 24.0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: PersonItem(
                                            name: children[i].name,
                                            imageUrl: children[i].name),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    width: 80,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Educators',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final showCount = educators.length;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(showCount, (i) {
                                    return Transform.translate(
                                      offset: Offset(i * 24.0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: PersonItem(
                                            name: educators[i].name,
                                            imageUrl: educators[i].imageUrl),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    width: 80,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (permissionUpdate)
                      CustomButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.white,
                        ),
                        text: 'Edit',
                        width: 80,
                        height: 35,
                        ontap: onEditPressed,
                        borderRadius: 5,
                      ),
                    const SizedBox(width: 8),
                    if (permissionDelete)
                      CustomButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 16,
                          color: AppColors.white,
                        ),
                        text: 'Delete',
                        width: 90,
                        height: 35,
                        color: AppColors.errorColor,
                        ontap: () {},
                        borderRadius: 5,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PersonItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const PersonItem({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double radius = 23;
    return PatternBackground(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
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
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
