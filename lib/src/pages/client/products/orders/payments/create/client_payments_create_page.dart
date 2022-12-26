import 'package:flutter/material.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  ClientPaymentsCreatePage({Key? key}) : super(key: key);

  @override
  State<ClientPaymentsCreatePage> createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('client_payments_create_page')
        ),
    );
  }
}