import 'package:flutter/material.dart';

import 'package:Track360/datetime/date_time.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    Key? key,
    required this.datasets,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(const Duration(days: 1)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.purple[100],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Colors.purple,
          2: Color.fromARGB(255, 177, 93, 192),
          3: Color.fromARGB(255, 208, 108, 226),
          4: Color.fromARGB(255, 188, 108, 202),
          5: Color.fromARGB(255, 179, 97, 194),
          6: Color.fromARGB(255, 151, 81, 163),
          7: Color.fromARGB(255, 183, 86, 200),
          8: Color.fromARGB(255, 156, 31, 178),
          9: Color.fromARGB(255, 195, 90, 213),
          10: Color.fromARGB(255, 156, 31, 178),
        },
        onClick: (value) {
          // Print the selected date
          print(value);
        },
      ),
    );
  }
}

