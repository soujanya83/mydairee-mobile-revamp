import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/main.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final double width;
  final double height;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.width = 0,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width > 0 ? width : double.infinity;

    return PatternBackground(
      width: cardWidth,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColors.primaryColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyStat extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlighted;

  const SurveyStat({
    super.key,
    required this.value,
    required this.label,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      width: screenWidth * .35,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: isHighlighted ? AppColors.primaryColor : null,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isHighlighted ? AppColors.primaryColor : null,
                ),
          ),
        ],
      ),
    );
  }
}

class DepartmentChartPainter extends CustomPainter {
  final String chartType;
  final Color chartColor;
  final Map<String, String> chartData;

  DepartmentChartPainter({
    required this.chartType,
    required this.chartColor,
    required this.chartData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = chartColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    if (chartType == 'line') {
      // (Optional) Line chart logic
    } else {
      final Map<String, String> filteredData = Map.from(chartData);
      final overallValue = filteredData.remove('Overall');

      final keys = filteredData.keys.toList();
      final values = filteredData.values.map((v) {
        return double.tryParse(v.replaceAll(',', '')) ?? 0;
      }).toList();

      final maxValue =
          values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1;
      final barCount = values.length;
      final spacing = 8.0;
      final labelHeight = 32.0; // space for year + value
      final chartHeight =
          size.height - labelHeight - (overallValue != null ? 16.0 : 0);

      final barWidth = (size.width - (spacing * (barCount - 1))) / barCount;

      final textStyle = TextStyle(
        color: Colors.black,
        fontSize: 12,
      );

      for (int i = 0; i < barCount; i++) {
        final value = values[i];
        final valueText = filteredData[keys[i]];
        final heightFactor = value / maxValue;
        final left = i * (barWidth + spacing);
        final barHeight = chartHeight * heightFactor;
        final top = chartHeight - barHeight;

        final barRect = Rect.fromLTWH(
          left,
          top,
          barWidth,
          barHeight,
        );

        // Draw the bar
        canvas.drawRect(barRect, fillPaint);
        canvas.drawRect(barRect, paint);

        // Draw year label
        final yearTextSpan = TextSpan(
          text: keys[i],
          style: textStyle,
        );
        final yearPainter = TextPainter(
          text: yearTextSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        yearPainter.layout();
        final yearX = left + (barWidth - yearPainter.width) / 2;
        final yearY = chartHeight + 2;
        yearPainter.paint(canvas, Offset(yearX, yearY));

        // Draw value label below year
        final valueTextSpan = TextSpan(
          text: valueText,
          style: textStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
        );
        final valuePainter = TextPainter(
          text: valueTextSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        final valueX = left + (barWidth - valuePainter.width) / 2;
        final valueY = yearY + yearPainter.height + 2;
        valuePainter.paint(canvas, Offset(valueX, valueY));
      }

      // Draw overall total (if exists)
      if (overallValue != null) {
        final totalSpan = TextSpan(
          text: 'Overall: $overallValue',
          style: textStyle.copyWith(
              fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        );
        final totalPainter = TextPainter(
          text: totalSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        totalPainter.layout();
        final totalX = (size.width - totalPainter.width) / 2;
        final totalY = size.height - totalPainter.height;
        totalPainter.paint(canvas, Offset(totalX, totalY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant DepartmentChartPainter oldDelegate) {
    return oldDelegate.chartData != chartData ||
        oldDelegate.chartColor != chartColor ||
        oldDelegate.chartType != chartType;
  }
}

class DepartmentLineChartPainter extends CustomPainter {
  final Color chartColor;
  final Map<String, String> chartData;
  final String chartTitle;

  DepartmentLineChartPainter({
    required this.chartColor,
    required this.chartData,
    this.chartTitle = '',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    final titleStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final paint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = chartColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Separate overall
    final data = Map<String, String>.from(chartData);
    final overallValue = data.remove('Overall');

    final keys = data.keys.toList();
    final values = data.values
        .map((v) => double.tryParse(v.replaceAll(',', '')) ?? 0)
        .toList();

    final maxValue =
        values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1;

    // Draw title
    final titleSpan = TextSpan(text: chartTitle, style: titleStyle);
    final titlePainter = TextPainter(
      text: titleSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    final titleX = (size.width - titlePainter.width) / 2;
    final titleY = 0.0;
    titlePainter.paint(canvas, Offset(titleX, titleY));

    // Chart offset to accommodate title
    final titleHeight = titlePainter.height;
    final chartTop = titleHeight + 8;
    final labelHeight = 32.0;
    final chartHeight = size.height -
        chartTop -
        labelHeight -
        (overallValue != null ? 16.0 : 0);

    final pointCount = values.length;
    if (pointCount < 2) return;

    final spacing = size.width / (pointCount - 1);
    List<Offset> points = [];

    for (int i = 0; i < pointCount; i++) {
      final x = i * spacing;
      final y = chartTop + chartHeight * (1 - values[i] / maxValue);
      points.add(Offset(x, y));
    }

    // Draw line and filled area
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, chartTop + chartHeight)
      ..lineTo(0, chartTop + chartHeight)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw circles and labels
    for (int i = 0; i < pointCount; i++) {
      canvas.drawCircle(points[i], 4, Paint()..color = chartColor);

      // Year label
      final year = keys[i];
      final yearSpan = TextSpan(text: year, style: textStyle);
      final yearPainter = TextPainter(
        text: yearSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      yearPainter.layout();
      final yearX = points[i].dx - (yearPainter.width / 2);
      final yearY = chartTop + chartHeight + 2;
      yearPainter.paint(canvas, Offset(yearX, yearY));

      // Value label below year
      final value = data[year]!;
      final valueSpan = TextSpan(
          text: value,
          style: textStyle.copyWith(fontSize: 11, color: Colors.grey[700]));
      final valuePainter = TextPainter(
        text: valueSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      final valueX = points[i].dx - (valuePainter.width / 2);
      final valueY = yearY + yearPainter.height + 2;
      valuePainter.paint(canvas, Offset(valueX, valueY));
    }

    // Draw overall label
    if (overallValue != null) {
      final overallSpan = TextSpan(
        text: 'Overall: $overallValue',
        style: textStyle.copyWith(
            fontWeight: FontWeight.bold, color: AppColors.primaryColor),
      );
      final overallPainter = TextPainter(
        text: overallSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      overallPainter.layout();
      final x = (size.width - overallPainter.width) / 2;
      final y = size.height - overallPainter.height;
      overallPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant DepartmentLineChartPainter oldDelegate) {
    return oldDelegate.chartData != chartData ||
        oldDelegate.chartColor != chartColor ||
        oldDelegate.chartTitle != chartTitle;
  }
}

class KnobCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const KnobCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      padding: const EdgeInsets.all(16),
      width: screenWidth * .8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: int.parse(value) / 100,
                  strokeWidth: 6,
                  backgroundColor: color.withOpacity(0.2),
                  color: color,
                ),
              ),
              Text(
                '$value%',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class LocationStat extends StatelessWidget {
  final String location;
  final String count;

  const LocationStat({
    super.key,
    required this.location,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                count,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimelineEvent {
  final String time;
  final String title;
  final String? subtitle;
  final Color color;

  TimelineEvent({
    required this.time,
    required this.title,
    this.subtitle,
    required this.color,
  });
}

class TimelineProgressList extends StatelessWidget {
  final List<TimelineEvent> events;
  final TimeOfDay currentTime;

  const TimelineProgressList({
    super.key,
    required this.events,
    required this.currentTime,
  });

  double _timeToDouble(String timeString) {
    final lower = timeString.toLowerCase();
    final parts = lower.replaceAll('am', '').replaceAll('pm', '').split(':');
    int hour = int.parse(parts[0]);
    int minute = parts.length > 1 ? int.parse(parts[1]) : 0;

    if (lower.contains('pm') && hour < 12) hour += 12;
    if (lower.contains('am') && hour == 12) hour = 0;

    return hour + (minute / 60.0);
  }

  double _currentTimeAsDouble() => currentTime.hour + currentTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    final now = _currentTimeAsDouble();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final timeDouble = _timeToDouble(event.time);
        final isPast = timeDouble <= now;
        final isLast = index == events.length - 1;

        return Stack(
          children: [
            Positioned(
              left: 7,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: isPast ? event.color : Colors.grey[300],
                height: isLast ? 12 : 72,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: event.color,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: event.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            event.time,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(),
                              ),
                              if (event.subtitle != null)
                                Text(
                                  event.subtitle!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.grey[700],
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final String name;
  final String percentage;
  final Color color;

  const AttendanceItem({
    super.key,
    required this.name,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              percentage,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamTopperRow extends DataRow {
  ExamTopperRow({
    required String name,
    required String chartData,
  }) : super(
          cells: [
            DataCell(Text(name)),
            DataCell(Text(chartData)),
          ],
        );
}

class SparklinePainter extends CustomPainter {
  final String data;
  final List<double> values;

  SparklinePainter(this.data)
      : values = data.split(',').map((e) => double.parse(e)).toList();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final stepX = size.width / (values.length - 1);

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - ((values[i] - minValue) / range * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);

        canvas.drawCircle(
          Offset(x, y),
          2,
          Paint()
            ..color = AppColors.primaryColor
            ..style = PaintingStyle.fill,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
