import 'package:flutter/material.dart';
import 'offer_card_widget.dart';

// Everything above this may be unnecessary
class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key, required this.stablishmentId});
  final String? stablishmentId;

  @override
  State<StatefulWidget> createState() => _StablishmentWidgetState();
}

class _StablishmentWidgetState extends State<StablishmentWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: Text("", style: TextStyle(color: Colors.black)),
        ),
      ),
      body: Text("Store ID: ${widget.stablishmentId}"),
    );
  }
}
