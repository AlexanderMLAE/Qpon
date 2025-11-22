import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime displayDay = _selectedDay ?? _focusedDay;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: const Text(
            'Calendario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Bloque con "hoja" del día como cuadrado con esquinas suaves y SIN relleno rojo
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // pequeñas pestañas superiores (estética)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 18,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // cuadrado con esquinas suaves: sin relleno rojo, con borde rojo
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white, // usa Colors.transparent si prefieres sin fondo
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 72, 72), // borde rojo
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${displayDay.day}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), // número en rojo
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Día completo y mes/año en texto
              Text(
                _formatearFecha(displayDay),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Container(
            width: 350,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromARGB(255, 255, 72, 72),
                width: 8,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                weekendDays: const [DateTime.sunday],
                daysOfWeekHeight: 40.0,
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
                    color: Color.fromARGB(255, 255, 72, 72),
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
                    return meses[date.month - 1];
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatearFecha(DateTime fecha) {
    const dias = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado'
    ];
    const meses = [
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
      'Diciembre'
    ];
    final diaNombre = dias[fecha.weekday % 7];
    final mesNombre = meses[fecha.month - 1];
    return '$diaNombre, $mesNombre del ${fecha.year}';
  }
}
