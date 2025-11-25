import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'detalles_oferta.dart'; // <--- Asegúrate de que este archivo exista y la ruta sea correcta

// --- MODELO DE DATOS ---
class EventData {
  String title;
  String note;
  EventData({required this.title, required this.note});
}

// Colores constantes
const _kRed = Color(0xFFFF4848);
const _kLightRed = Color(0xFFFF9F9F);
const _kBgRed = Color(0xFFFFD0D0);
const _kPurple = Color(0xFF9C27B0);

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();
  
  DateTime? _tempPressed;

  // Variable estática para que los eventos no se borren al cambiar de pantalla
  static final Map<DateTime, EventData> _eventosGuardados = {};

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    // Cálculos para limitar el rango de fechas (Este mes y el siguiente)
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56, width: double.infinity, color: Colors.black,
          alignment: Alignment.center,
          child: const Text('Calendario', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        
        _buildDaySheet(_today),
        
        const SizedBox(height: 12),
        
        Container(
          width: 350, height: 480,
          decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: _kRed, width: 8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TableCalendar(
              locale: 'es_ES',
              
              // --- CONFIGURACIÓN DE RANGO Y BLOQUEO ---
              firstDay: firstDayOfCurrentMonth, 
              lastDay: lastDayOfNextMonth,
              focusedDay: _focusedDay,
              
              // Deshabilitar días pasados
              enabledDayPredicate: (day) {
                final dayToTest = DateTime(day.year, day.month, day.day);
                final todayDate = DateTime(now.year, now.month, now.day);
                return !dayToTest.isBefore(todayDate);
              },

              selectedDayPredicate: (_) => false,
              onDaySelected: _handleSelect,
              weekendDays: const [DateTime.sunday],
              daysOfWeekHeight: 40,
              daysOfWeekStyle: const DaysOfWeekStyle(decoration: BoxDecoration(color: _kBgRed)),
              
              headerStyle: HeaderStyle(
                titleCentered: true, formatButtonVisible: false,
                decoration: const BoxDecoration(color: Color(0xFFFA8181)),
                titleTextFormatter: (d, _) => _meses[d.month - 1],
              ),
              
              calendarStyle: const CalendarStyle(
                // ESTO OCULTA LOS DÍAS DE OTROS MESES (La cuadrícula se ve limpia)
                outsideDaysVisible: false, 
                
                todayDecoration: BoxDecoration(color: _kLightRed, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.transparent),
                weekendTextStyle: TextStyle(color: Colors.red),
                disabledTextStyle: TextStyle(color: Colors.grey), 
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (_, date, __) {
                  final isSaved = _eventosGuardados.containsKey(_normalizeDate(date));
                  
                  if (_tempPressed != null && isSameDay(date, _tempPressed)) {
                    return _circleDay(date, _kLightRed, isAnimated: true);
                  }
                  if (isSaved) {
                    return _circleDay(date, _kPurple.withOpacity(0.7)); 
                  }
                  return Center(child: Text('${date.day}'));
                },
                todayBuilder: (_, date, __) {
                   final isSaved = _eventosGuardados.containsKey(_normalizeDate(date));
                   return _circleDay(date, isSaved ? _kPurple : _kLightRed);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaySheet(DateTime d) {
    final isSaved = _eventosGuardados.containsKey(_normalizeDate(d));
    final colorTema = isSaved ? _kPurple : _kRed;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (_) => Container(
            width: 18, height: 6, margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(3)),
          )),
        ),
        const SizedBox(height: 6),
        Container(
          width: 76, height: 76, alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorTema,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Text('${d.day}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        Text(_formatearFecha(d), style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _circleDay(DateTime d, Color color, {bool isAnimated = false}) {
    final decoration = BoxDecoration(color: color, shape: BoxShape.circle,
      boxShadow: isAnimated ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))] : null
    );
    final child = Text('${d.day}', style: const TextStyle(color: Colors.white));

    return isAnimated
        ? AnimatedContainer(duration: const Duration(milliseconds: 160), curve: Curves.easeOut, margin: const EdgeInsets.all(6), alignment: Alignment.center, decoration: decoration, child: child)
        : Container(margin: const EdgeInsets.all(6), alignment: Alignment.center, decoration: decoration, child: child);
  }

  Future<void> _handleSelect(DateTime sel, DateTime foc) async {
    setState(() => _tempPressed = sel);
    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    final normalizedDate = _normalizeDate(sel);
    final existingEvent = _eventosGuardados[normalizedDate];

    final EventData? resultData = await showDialog<EventData?>(
      context: context,
      builder: (context) => _EventDialog(
        initialTitle: existingEvent?.title,
        initialNote: existingEvent?.note,
      ),
    );

    setState(() {
      _tempPressed = null;
      _focusedDay = foc; 
      
      if (resultData != null) {
         _eventosGuardados[normalizedDate] = resultData;
      }
    });
  }

  static const _meses = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
  static const _dias = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
  String _formatearFecha(DateTime f) => '${_dias[f.weekday % 7]}, ${_meses[f.month - 1]} del ${f.year}';
}

class _EventDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialNote;
  const _EventDialog({this.initialTitle, this.initialNote});
  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _noteController = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.black87, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Ingresar Titulo',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                          isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe una nota',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2, minLines: 1,
                ),
                
                // --- IMAGEN CON NAVEGACIÓN ---
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Cerrar diálogo e ir a Detalles
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetallesOferta()),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage('https://media.gq.com.mx/photos/649391b89ec62ce6c5b091a5/16:9/w_2560%2Cc_limit/mejores-hamburguesas.jpg'), 
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))
                      ]
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                // -----------------------------

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity, height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, EventData(title: _titleController.text, note: _noteController.text)),
                    style: ElevatedButton.styleFrom(backgroundColor: _kRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                    child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: -15, right: -10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, null),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}