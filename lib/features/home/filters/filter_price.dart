import 'package:flutter/material.dart';

/// Filters offers from minimum to maximum price
/// TODO: TOÑO documenta esto pls
class PriceFilterWidget extends StatefulWidget {
  final Function(double? minPrice, double? maxPrice) onFilterApplied;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final bool isActive;

  const PriceFilterWidget({
    super.key,
    required this.onFilterApplied,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.isActive = false,
  });

  @override
  State<PriceFilterWidget> createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  /// Document this pls
  double? _tempMinPrice;
  double? _tempMaxPrice;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController();
    _maxController = TextEditingController();

    if (widget.initialMinPrice != null) {
      _minController.text = widget.initialMinPrice!.toString();
      _tempMinPrice = widget.initialMinPrice;
    }
    if (widget.initialMaxPrice != null) {
      _maxController.text = widget.initialMaxPrice!.toString();
      _tempMaxPrice = widget.initialMaxPrice;
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    _tempMinPrice = widget.initialMinPrice;
    _tempMaxPrice = widget.initialMaxPrice;
    _minController.text = widget.initialMinPrice?.toString() ?? '';
    _maxController.text = widget.initialMaxPrice?.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    color: Color.fromARGB(255, 227, 18, 47),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Filtrar por precio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 227, 18, 47),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio mínimo',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: 'ejemplo: 100',
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setStateDialog(() {
                          _tempMinPrice = value.isEmpty
                              ? null
                              : double.tryParse(value);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio máximo',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: 'ejemplo: 500',
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setStateDialog(() {
                          _tempMaxPrice = value.isEmpty
                              ? null
                              : double.tryParse(value);
                        });
                      },
                    ),
                  ),

                  if (widget.isActive) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 226, 216, 228),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color.fromARGB(255, 75, 0, 130),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color.fromARGB(255, 75, 0, 130),
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Filtro activo',
                            style: TextStyle(
                              color: Color.fromARGB(255, 75, 0, 130),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    selectionColor: Color.fromARGB(255, 75, 0, 130),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validar que mínimo sea menor que máximo
                    if (_tempMinPrice != null &&
                        _tempMaxPrice != null &&
                        _tempMinPrice! > _tempMaxPrice!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'El precio mínimo no puede ser mayor al máximo',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    widget.onFilterApplied(_tempMinPrice, _tempMaxPrice);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 227, 18, 47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          InputChip(
            label: Text(
              widget.isActive ? _getPriceRangeText() : 'Filtrar por precio',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            avatar: const Icon(Icons.filter_alt, size: 22, color: Colors.white),
            onPressed: _showFilterDialog,
            backgroundColor: const Color.fromARGB(255, 227, 18, 47),
            side: BorderSide.none,
            deleteIcon: widget.isActive
                ? const Icon(Icons.close, size: 18, color: Colors.white)
                : null,
            onDeleted: widget.isActive
                ? () {
                    widget.onFilterApplied(null, null);
                  }
                : null,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _getPriceRangeText() {
    final minText = widget.initialMinPrice != null
        ? '\$${widget.initialMinPrice!.toStringAsFixed(0)}'
        : '\$0';
    final maxText = widget.initialMaxPrice != null
        ? '\$${widget.initialMaxPrice!.toStringAsFixed(0)}'
        : '∞';
    return '$minText - $maxText';
  }
}
