import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoe_world/model/product.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;
  final int quantity;

  const CheckoutScreen({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _couponController = TextEditingController();

  double deliveryCharge = 0;
  double discount = 0;
  String selectedPayment = 'Cash on Delivery';

  final String deliveryAddress = "123 Palm Jumeirah, Dubai, UAE";

  @override
  void initState() {
    super.initState();
    _calculateDeliveryCharge();
  }

  void _calculateDeliveryCharge() {
    final subtotal = widget.product.price * widget.quantity;
    deliveryCharge = subtotal > 100 ? 0 : 20;
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter a coupon code');
      return;
    }

    if (code.toLowerCase() == 'discount10') {
      setState(() {
        discount = 10;
      });
      Fluttertoast.showToast(msg: 'Coupon applied! \$10 discount');
    } else {
      Fluttertoast.showToast(msg: 'Invalid coupon');
    }
  }

  bool isMobile(double width) => width < 600;
  bool isTablet(double width) => width >= 600 && width < 1024;
  bool isDesktop(double width) => width >= 1024;

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.product.price * widget.quantity;
    final total = subtotal + deliveryCharge - discount;
    final width = MediaQuery.of(context).size.width;

    final EdgeInsets pagePadding =
        isDesktop(width) ? const EdgeInsets.all(40) : const EdgeInsets.all(16);

    Widget orderSummaryCard = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            summaryRow(
              'Delivery Charge',
              deliveryCharge == 0 ? 'Free' : '\$${deliveryCharge.toStringAsFixed(2)}',
              valueColor: deliveryCharge == 0 ? Colors.green : Colors.black,
            ),
            if (discount > 0) summaryRow('Discount', '-\$${discount.toStringAsFixed(2)}', valueColor: Colors.green),
            const Divider(),
            summaryRow('Total', '\$${total.toStringAsFixed(2)}',
                isBold: true),
          ],
        ),
      ),
    );

    Widget paymentSection = paymentMethodSection();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: pagePadding,
        child: isDesktop(width)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: leftColumn(subtotal, orderSummaryCard)),
                  const SizedBox(width: 30),
                  Expanded(flex: 2, child: paymentSection),
                ],
              )
            : leftColumn(subtotal, orderSummaryCard, paymentSection: paymentSection),
      ),
    );
  }

  Widget leftColumn(double subtotal, Widget summaryCard, {Widget? paymentSection}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        deliveryAddressBox(),
        const SizedBox(height: 16),

        const Text('Order Summary',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        productTile(subtotal),
        const SizedBox(height: 16),

        couponField(),
        summaryCard,
        if (paymentSection != null) paymentSection,
        const SizedBox(height: 20),
        payNowButton(),
      ],
    );
  }

  Widget summaryRow(String title, String value,
      {bool isBold = false, Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor)),
        ],
      ),
    );
  }

  Widget deliveryAddressBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(deliveryAddress, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget productTile(double subtotal) {
    return ListTile(
      leading: Image.network(
        widget.product.image,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
      title: Text(widget.product.title),
      subtitle: Text('Quantity: ${widget.quantity}'),
      trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
    );
  }

  Widget couponField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _couponController,
            decoration: const InputDecoration(
              labelText: 'Coupon Code',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.card_giftcard),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _applyCoupon, child: const Text('Apply')),
      ],
    );
  }

  Widget paymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        paymentRadio('Cash on Delivery'),
        paymentRadio('Credit/Debit Card'),
        paymentRadio('PayPal'),
      ],
    );
  }

  Widget paymentRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedPayment,
          onChanged: (val) => setState(() => selectedPayment = val!),
        ),
        Text(value),
      ],
    );
  }

  Widget payNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (selectedPayment == 'Cash on Delivery') {
            Fluttertoast.showToast(msg: 'Order placed! You will pay upon delivery.');
          } else {
            Fluttertoast.showToast(msg: 'Payment Successful via $selectedPayment!');
          }
        },
        child: const Text('Pay Now',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
