import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mukai/theme/theme.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> periodicDeposits;
  final List<double> periodicWithdrawals;

  const MyBarGraph({
    super.key,
    required this.periodicDeposits,
    required this.periodicWithdrawals,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Handle empty data case
    if (periodicDeposits.isEmpty || periodicWithdrawals.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Safe maxY calculation
    final maxY = _calculateMaxY();
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
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final day = periodicDeposits.length == 7 
                        ? _getDayName(group.x)
                        : _getMonthName(group.x);
                    final amount = rod.toY.toStringAsFixed(2);
                    final type = rodIndex == 0 ? 'Deposit' : 'Withdrawal';
                    return BarTooltipItem(
                      '$day\n$type: \$$amount',
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  double _calculateMaxY() {
    try {
      final combined = [...periodicDeposits, ...periodicWithdrawals];
      if (combined.isEmpty) return 100; // Default max if no data
      return combined.reduce((a, b) => a > b ? a : b) * 1.2;
    } catch (e) {
      return 100; // Fallback value
    }
  }

  List<BarChartGroupData> _generateBarGroups() {
    final count = periodicDeposits.length;
    return List.generate(count, (index) {
      return BarChartGroupData(
        x: index,
        groupVertically: false,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: index < periodicDeposits.length ? periodicDeposits[index] : 0,
            color: primaryColor,
            width: 15,
          ),
          BarChartRodData(
            toY: index < periodicWithdrawals.length ? periodicWithdrawals[index] : 0,
            color: recColor,
            width: 15,
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
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thur';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
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
