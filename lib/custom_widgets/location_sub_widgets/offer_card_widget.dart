import 'package:flutter/material.dart';
import 'package:proyecto_qpon/custom_widgets/detalles_oferta.dart';

class OfferCardWidget extends StatelessWidget {
  const OfferCardWidget({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageURL,
    this.localName,
  });
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageURL;
  final String? localName;

  @override
  Widget build(BuildContext context) {
    return OfferCard(productName: productName, productPrice: productPrice, productDetails: productDetails, imageURL: imageURL, localName: localName);
  }

}



class OfferCard extends StatefulWidget {
  const OfferCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageURL, 
    required this.localName,
  });
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageURL;
  final String? localName;
  

  @override
  State<StatefulWidget> createState() => _OfferCardState();
}
class _OfferCardState extends State<OfferCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: NetworkImage(widget.imageURL),
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Precio: ${widget.productPrice}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.productName,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.red[300]),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: openDetails,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text("Detalles"),
            ),
            const SizedBox(height: 8),
            Text(
              widget.productDetails,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
    void openDetails() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => DetallesOferta()),
      );
    });
  }

}