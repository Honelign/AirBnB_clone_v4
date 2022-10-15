import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class WeeklyGraphWidget extends StatelessWidget {
  final List<BarChartGroupData> barData;
  final double maxY;
  const WeeklyGraphWidget({
    Key? key,
    required this.barData,
    required this.maxY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 12, top: 10),
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                // getTitlesWidget: _getLeftTitles,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(
                width: 1,
              ),
              bottom: BorderSide(
                width: 1,
              ),
            ),
          ),
          groupsSpace: 10,
          barGroups: barData,
        ),
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: kSecondaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;

    switch (value.toInt()) {
      case 1:
        text = Text("Week 1", style: style);
        break;
      case 2:
        text = Text("Week 2", style: style);
        break;
      case 3:
        text = Text("Week 3", style: style);
        break;
      case 4:
        text = Text("Week 4", style: style);
        break;

      default:
        text = Text("Week 1", style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  // Widget _getLeftTitles(double value, TitleMeta meta) {
  // const style = TextStyle(
  //   color: Colors.yellow,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 14,
  // );

  // Widget text;
  // switch (value.toInt()) {
  //   case 1:
  //     text = Text(
  //       "".toString(),
  //       style: style,
  //     );
  //     break;
  //   case 2:
  //     text = Text(
  //       leftTileValues[2].toString(),
  //       style: style,
  //     );
  //     break;
  //   case 3:
  //     text = Text(
  //       leftTileValues[3].toString(),
  //       style: style,
  //     );
  //     break;
  //   case 4:
  //     text = Text(
  //       leftTileValues[4].toString(),
  //       style: style,
  //     );
  //     break;
  //   case 5:
  //     text = Text(
  //       leftTileValues[5].toString(),
  //       style: style,
  //     );
  //     break;
  //   case 6:
  //     text = Text(
  //       leftTileValues[6].toString(),
  //       style: style,
  //     );
  //     break;
  //   default:
  //     text = Text(
  //       leftTileValues[0].toString(),
  //       style: style,
  //     );
  //     break;
  // }
  // return SideTitleWidget(
  //   axisSide: meta.axisSide,
  //   child: text,
  // );
  // }
}
