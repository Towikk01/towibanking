import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/language.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class FinanceChartsWidget extends ConsumerStatefulWidget {
  final List<Transaction> transactions;

  const FinanceChartsWidget({super.key, required this.transactions});

  @override
  ConsumerState<FinanceChartsWidget> createState() =>
      _FinanceChartsWidgetState();
}

class _FinanceChartsWidgetState extends ConsumerState<FinanceChartsWidget>
    with SingleTickerProviderStateMixin {
  int _currentChartIndex = 0;
  late AnimationController _controller;
  late Map<String, Color> _categoryColors;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _categoryColors = {};
  }

  void _changeChart(int direction) {
    setState(() {
      _currentChartIndex = (_currentChartIndex + direction) % 4;
      if (_currentChartIndex < 0) _currentChartIndex = 3;
      _controller.forward(from: 0.0);
    });
  }

  DateTime selectedDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageNotifierProvider);
    final expenseTransactions =
        widget.transactions.where((el) => el.type == 'expense').toList();
    final incomeTransactions =
        widget.transactions.where((el) => el.type == 'income').toList();

    final expenseData = _processTransactions(expenseTransactions, lang);
    final incomeData = _processTransactions(incomeTransactions, lang);

    return Column(
      spacing: 10,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.secondary.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => _changeChart(-1),
              ),
              if (_currentChartIndex != 3)
                const SizedBox(
                  width: 15,
                ),
              Flexible(
                child: Text(
                  _getChartTitle(),
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 0,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.date_range,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            DateTime tempSelectedDate = selectedDate;
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return CupertinoAlertDialog(
                                  title: const Text("Виберіть дату"),
                                  content: SizedBox(
                                    height: 400,
                                    width: 400,
                                    child: TableCalendar(
                                      rangeSelectionMode:
                                          RangeSelectionMode.enforced,
                                      firstDay: DateTime(2000),
                                      lastDay: DateTime(2100),
                                      focusedDay: selectedDate,
                                      calendarFormat: calendarFormat,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setDialogState(() {
                                          tempSelectedDate = selectedDay;
                                        });
                                      },
                                      selectedDayPredicate: (day) {
                                        return isSameDay(tempSelectedDate, day);
                                      },
                                      headerStyle: const HeaderStyle(
                                        formatButtonVisible: false,
                                        titleCentered: true,
                                      ),
                                      calendarStyle: CalendarStyle(
                                        selectedDecoration: const BoxDecoration(
                                          color: AppColors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        todayDecoration: BoxDecoration(
                                          color:
                                              AppColors.orange.withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text("Скасувати"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Обрати"),
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = tempSelectedDate;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeChart(1),
                  ),
                ],
              ),
            ],
          ),
        ),
        FadeTransition(
          opacity: _controller,
          child: Column(
            spacing: 20,
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.secondary.withOpacity(0.5),
                  ),
                  height: 320,
                  child: _getCurrentChart(expenseData, incomeData)),
              _buildLegend(_currentChartIndex == 0 ? expenseData : incomeData),
            ],
          ),
        ),
      ],
    );
  }

  String _getChartTitle() {
    switch (_currentChartIndex) {
      case 0:
        return "Розподіл витрат";
      case 1:
        return "Розподіл надходжень";
      case 2:
        return "Баланс по днях";
      case 3:
        return "Порівняння доходів/витрат";
      default:
        return "";
    }
  }

  Widget _getCurrentChart(
      Map<String, double> expenseData, Map<String, double> incomeData) {
    switch (_currentChartIndex) {
      case 0:
        return _buildPieChart(expenseData);
      case 1:
        return _buildPieChart(incomeData);
      case 2:
        return _buildLineChart();
      case 3:
        return _buildBarChart();
      default:
        return Container();
    }
  }

  Map<String, double> _processTransactions(
      List<Transaction> transactions, String lang) {
    final Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      String categoryTitle =
          transaction.category.localTitles?[lang] ?? transaction.category.title;
      categoryTotals[categoryTitle] =
          (categoryTotals[categoryTitle] ?? 0) + transaction.amount.abs();
      _categoryColors.putIfAbsent(
          categoryTitle,
          () => Color((Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0));
    }
    return categoryTotals;
  }

  Widget _buildPieChart(Map<String, double> categoryTotals) {
    final total = categoryTotals.values.fold(0.0, (sum, item) => sum + item);

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 70, // Ensures space for the center text
            sections: categoryTotals.entries.map((entry) {
              final color = _categoryColors[entry.key]!;
              final percentage = (entry.value / total) * 100;
              return PieChartSectionData(
                value: percentage,
                color: color,
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                title: "",
                radius: 75,
              );
            }).toList(),
          ),
        ),
        Text(
          total.toStringAsFixed(2), // Show total amount in center
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Map<String, double> categoryTotals) {
    final totalAmount =
        categoryTotals.values.fold(0.0, (sum, item) => sum + item);

    return Column(
      children: categoryTotals.entries.map((entry) {
        final category = entry.key;
        final amount = entry.value;
        final percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.secondary.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _categoryColors[category],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 18, color: AppColors.orange),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  amount.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 18, color: AppColors.orange),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget _buildLineChart() {
  return LineChart(
    LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 50),
            const FlSpot(1, 80),
            const FlSpot(2, 30),
            const FlSpot(3, 60),
          ],
          isCurved: true,
          color: AppColors.orange,
          barWidth: 4,
          isStrokeCapRound: true,
        )
      ],
    ),
  );
}

Widget _buildBarChart() {
  return BarChart(
    BarChartData(
      barGroups: [
        BarChartGroupData(
            x: 0, barRods: [BarChartRodData(toY: 100, color: Colors.green)]),
        BarChartGroupData(
            x: 1, barRods: [BarChartRodData(toY: 50, color: Colors.red)]),
      ],
    ),
  );
}
