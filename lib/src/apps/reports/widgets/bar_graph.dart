import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mukai/theme/theme.dart';

class MyBarGraph extends StatelessWidget {
  // final List<double> weeklyDeposits;
  // final List<double> weeklyWithdrawals;
  final List<double> periodicDeposits;
  final List<double> periodicWithdrawals;

  const MyBarGraph({
    super.key,
    // required this.weeklyDeposits,
    // required this.weeklyWithdrawals,
    required this.periodicDeposits,
    required this.periodicWithdrawals,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Calculate max Y value with 20% padding
    /*
    final maxY = [...weeklyDeposits, ...weeklyWithdrawals]
            .reduce((a, b) => a > b ? a : b) *
        1.2;
    */
    final maxY = [...periodicDeposits, ...periodicWithdrawals]
            .reduce((a, b) => a > b ? a : b) *
        1.2;
    final barWidth = width / 30.0;
    final barsSpace = width / 24.0;
    final groupSpace = width / 40.0;
    final itemCount = periodicDeposits.length;
    final requiredWidth =
        itemCount * (2 * barWidth + barsSpace + groupSpace) + 50;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: requiredWidth,
          height: height / 1.75,
          child: SizedBox(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: _getLeftTitles,
                    ),
                  ),
                ),
                maxY: maxY,
                minY: 0,
                barGroups: _generateBarGroups(),
                barTouchData: periodicDeposits.length == 7 ? BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = _getDayName(group.x);
                      final amount = rod.toY.toStringAsFixed(2);
                      final type = rodIndex == 0 ? 'Deposit' : 'Withdrawal';
                      final color = Colors.white;

                      return BarTooltipItem(
                        '$day\n$type: \$$amount',
                        TextStyle(color: color, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ): BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = _getMonthName(group.x);
                      final amount = rod.toY.toStringAsFixed(2);
                      final type = rodIndex == 0 ? 'Deposit' : 'Withdrawal';
                      final color = Colors.white;

                      return BarTooltipItem(
                        '$day\n$type: \$$amount',
                        TextStyle(color: color, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
  /*
  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        groupVertically: false, // Changed to false for side-by-side
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: weeklyDeposits[index],
            color: primaryColor,
            width: 15,
            // borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: weeklyWithdrawals[index],
            color: recColor,
            width: 15,
            // borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }
  */

  List<BarChartGroupData> _generateBarGroups() {
    return periodicDeposits.length == 7
        ? List.generate(7, (index) {
            return BarChartGroupData(
              x: index,
              groupVertically: false, // Changed to false for side-by-side
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: periodicDeposits[index],
                  color: primaryColor,
                  width: 15,
                  // borderRadius: BorderRadius.zero,
                ),
                BarChartRodData(
                  toY: periodicWithdrawals[index],
                  color: recColor,
                  width: 15,
                  // borderRadius: BorderRadius.zero,
                ),
              ],
            );
          })
        : List.generate(12, (index) {
            return BarChartGroupData(
              x: index,
              groupVertically: false, // Changed to false for side-by-side
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: periodicDeposits[index],
                  color: primaryColor,
                  width: 15,
                  // borderRadius: BorderRadius.zero,
                ),
                BarChartRodData(
                  toY: periodicWithdrawals[index],
                  color: recColor,
                  width: 15,
                  // borderRadius: BorderRadius.zero,
                ),
              ],
            );
          });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      meta: meta,
      child: periodicDeposits.length == 7
          ? Text(_getDayName(value.toInt()), style: style)
          : Text(
              _getMonthName(value.toInt()),
              style: style,
            ),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      meta: meta,
      child: Text('\$${value.toInt().toString()}', style: style),
      // axisSide: meta.axisSide,
    );
  }

  String _getDayName(int value) {
    switch (value.toInt()) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }

  String _getMonthName(int value) {
    switch (value.toInt()) {
      case 0:
        return 'Jan';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Apr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Aug';
      case 8:
        return 'Sep';
      case 9:
        return 'Oct';
      case 10:
        return 'Nov';
      case 11:
        return 'Dec';
      default:
        return '';
    }
  }
}
