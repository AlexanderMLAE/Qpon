import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const _kRed = Color.fromARGB(255, 227, 18, 47);
const _kLightRed = Color.fromARGB(255, 227, 18, 47);
const _kBgRed = Color.fromARGB(255, 255, 164, 177);

/// Goodbye lol
///
/// Maybe just keep the file in case we decide to use it eventually
///
/// This is 100% AI Slop but whatever
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();
  DateTime? _tempPressed;

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0);

    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _buildDaySheet(_today),
            const SizedBox(height: 12),
            Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _kRed, width: 8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TableCalendar(
                  locale: 'es_ES',
                  firstDay: firstDayOfCurrentMonth,
                  lastDay: lastDayOfNextMonth,
                  focusedDay: _focusedDay,
                  enabledDayPredicate: (day) {
                    final dayToTest = DateTime(day.year, day.month, day.day);
                    final todayDate = DateTime(now.year, now.month, now.day);
                    return !dayToTest.isBefore(todayDate);
                  },
                  selectedDayPredicate: (_) => false,
                  onDaySelected: _handleSelect,
                  weekendDays: const [DateTime.sunday],
                  daysOfWeekHeight: 40,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    decoration: BoxDecoration(color: _kBgRed),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 227, 18, 47),
                    ),
                    titleTextFormatter: (d, _) => _meses[d.month - 1],
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(
                      color: _kLightRed,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.black),
                    disabledTextStyle: TextStyle(color: Colors.grey),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (_, date, _) {
                      if (_tempPressed != null &&
                          isSameDay(date, _tempPressed)) {
                        return _circleDay(date, _kLightRed, isAnimated: true);
                      }
                      return Center(child: Text('${date.day}'));
                    },
                    todayBuilder: (_, date, _) {
                      return _circleDay(date, _kLightRed);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaySheet(DateTime d) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (_) => Container(
              width: 18,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${d.day}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(_formatearFecha(d), style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _circleDay(DateTime d, Color color, {bool isAnimated = false}) {
    final decoration = BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: isAnimated
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
    final child = Text('${d.day}', style: const TextStyle(color: Colors.white));

    return isAnimated
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            margin: const EdgeInsets.all(6),
            alignment: Alignment.center,
            decoration: decoration,
            child: child,
          )
        : Container(
            margin: const EdgeInsets.all(6),
            alignment: Alignment.center,
            decoration: decoration,
            child: child,
          );
  }

  Future<void> _handleSelect(DateTime sel, DateTime foc) async {
    setState(() => _tempPressed = sel);
    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    // Event happens here when a day is clicked
    debugPrint('Day selected: ${_normalizeDate(sel)}');

    setState(() {
      _tempPressed = null;
      _focusedDay = foc;
    });
  }

  static const _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  static const _dias = [
    'Domingo',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  String _formatearFecha(DateTime f) =>
      '${_dias[f.weekday % 7]}, ${_meses[f.month - 1]} del ${f.year}';
}
