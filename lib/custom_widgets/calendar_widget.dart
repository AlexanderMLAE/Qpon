import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromARGB(255, 255, 72, 72),
            width: 8,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // ← más pequeño que el borde externo
          child: TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: DateTime.now(),
            weekendDays: const [DateTime.sunday],

            daysOfWeekStyle: const DaysOfWeekStyle(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 208, 208),
              ),
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.black),
            ),

            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 159, 159),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 129, 129),
              ),
              titleTextFormatter: (date, locale) {
                const meses = [
                  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
                ];
                return meses[date.month - 1];
              },
            ),
          ),
        ),
      ),
    );
  }
}
