import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:treehole/models/emotion.dart';
import 'package:treehole/utils/constants.dart';

class Pie extends StatefulWidget {
  const Pie({Key? key, required this.emotion}) : super(key: key);

  final Emotion emotion;

  @override
  State<Pie> createState() => _PieState();
}

class _PieState extends State<Pie> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: _showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 45.0 : 30.0;

      final emotion = widget.emotion.toPercentage();

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFFBB86FC),
            value: emotion.joy,
            title: '${emotion.joy.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              const Text(joyEmoji),
              size: widgetSize,
              borderColor: const Color(0xFFBB86FC),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: emotion.mild,
            title: '${emotion.mild.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              const Text(mildEmoji),
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 54, 207, 92),
            value: emotion.disgust,
            title: '${emotion.disgust.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              const Text(disgustEmoji),
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 54, 207, 92),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 45, 78, 223),
            value: emotion.depressed,
            title: '${emotion.depressed.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              const Text(depressedEmoji),
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 45, 78, 223),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 195, 51, 51),
            value: emotion.anger,
            title: '${emotion.anger.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              const Text(angerEmoji),
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 195, 51, 51),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final Widget icon;
  final double size;
  final Color borderColor;

  const _Badge(
    this.icon, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: icon,
      ),
    );
  }
}
