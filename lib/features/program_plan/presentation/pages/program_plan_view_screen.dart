import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';

class ProgramPlanViewScreen extends StatelessWidget {
  final String id;
  const ProgramPlanViewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Program Plan View'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Page 1
          PatternBackground(
            elevation: 2,
            // margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'https://mydiaree.com.au/assets/img/profile_1739442700.jpeg',
                          width: 120,
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'PROGRAM PLAN ',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'JANUARY 2015',
                                style: TextStyle(
                                  color: Color(0xFF22b1c4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Table 1 (Horizontal scroll)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: [
                            _cellBold('Room Name'),
                            _cell('test'),
                            _cell(''),
                            _cell(''),
                            _cellBold('Focus Area', alignLeft: true),
                            _cell('test'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _cellBold('Educators'),
                            _cell('Kailash Sahu'),
                            _cell(''),
                            _cell(''),
                            _cell(''),
                            _cell(''),
                          ],
                        ),
                        TableRow(
                          children: [
                            _cellBold('Children'),
                            _cell('test1'),
                            _cell(''),
                            _cell(''),
                            _cell(''),
                            _cell(''),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08)),
                          children: [
                            _cellBold('Practical Life'),
                            _cellBold('Sensorial'),
                            _cellBold('Math'),
                            _cellBold('Language'),
                            _cellBold('Culture'),
                            _cellBold('Art & Craft'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _cellRich(
                              'Preliminary and elementary movement',
                              [
                                'Spooning rice.',
                                'Pouring jug to jug.',
                              ],
                              extra: [
                                'Self-help',
                                ['Cutting fruits and vegetables using a wooden knife.']
                              ],
                            ),
                            _cellRich(
                              'Visual sense:(Size and Dimension)',
                              [
                                'Knobbed cylinders: (Cylinder blocks).',
                              ],
                              extra: [
                                'Chromatic sense: (colour)',
                                ['Colour box 1.']
                              ],
                            ),
                            _cellRich(
                              'COUNTING 1 TO 10',
                              [
                                'Number rods.',
                              ],
                              extra: [
                                'Group operations',
                                ['Addition without change.']
                              ],
                            ),
                            _cellRich(
                              'Reading Preparation',
                              [
                                'I spy game.',
                              ],
                              extra: [
                                'PINK SERIES',
                                ['Box 1 – objects with LMA.']
                              ],
                            ),
                            _cellRich(
                              'Botany and Zoology',
                              [
                                'Care of indoor and outdoor plants.',
                              ],
                              extra: [
                                'puzzle',
                                ['Horse puzzel.']
                              ],
                            ),
                            _cellRich(
                              '',
                              [],
                              extra: [
                                'test art',
                                []
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), 
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('EYLF:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          'Outcome 1 - Children have a strong sense of identity: 1.1 Children feel safe, secure, and supported\n'
                          'Outcome 2 - Children are connected with and contribute to their world : 2.1 Children develop a sense of belonging to groups and communities and an understanding of the reciprocal rights and responsibilities necessary\n'
                          'for active community participation',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Footer
                  const Center(
                    child: Text(
                      '1 Capricorn Road, Truganina, VIC 3029',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Page 2
          PatternBackground(
            elevation: 2,
            // margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Center(
                    child: Image.network(
                      'https://mydiaree.com.au/assets/img/profile_1739442700.jpeg',
                      width: 120,
                      height: 105,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Outdoor Experiences
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Outdoor Experiences:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('• test experience'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Table 2 (Horizontal scroll)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: [
                            _cellSection('Inquiry Topic:', 'test topic'),
                            _cellSection('Sustainability Topic:', 'test Sustainability Topic'),
                            _cellSection('Special Events:', 'test events'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: const[
                        TableRow(
                          children: [
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Padding(
                                padding:   EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:   [
                                    Text("Children's Voices:", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    Text('test children voices'),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Families Input:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    Text('test Families Inputte'),
                                  ],
                                ),
                              ),
                            ),
                            // Add empty cells to make row length 3
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: [
                            _cellSection('Group Experience:', 'test Group Experience'),
                            _cellSection('Spontaneous Experience:', 'test Spontaneous Experience'),
                            _cellSection('Mindfulness Experiences:', 'test Mindfulness Experiences'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Footer
                  const Center(
                    child: Text(
                      '1 Capricorn Road, Truganina, VIC 3029',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cell(String text, {int colspan = 1, bool alignLeft = false, int rowSpan = 1}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
          child: Text(text, style: const TextStyle(fontSize: 15)),
        ),
      ),
    );
  }

  static Widget _cellBold(String text, {bool alignLeft = false, int rowSpan = 1}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ),
    );
  }

  static Widget _cellRich(String title, List<String> items, {dynamic extra}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            if (items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((e) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 15)),
                      Expanded(child: Text(e, style: const TextStyle(fontSize: 15))),
                    ],
                  )).toList(),
                ),
              ),
            if (extra != null && extra is List && extra.length == 2 && (extra[0] as String).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(extra[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            if (extra != null && extra is List && extra.length == 2 && (extra[1] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (extra[1] as List).map<Widget>((e) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 15)),
                      Expanded(child: Text(e, style: const TextStyle(fontSize: 15))),
                    ],
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _cellSection(String label, String value) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }
}
