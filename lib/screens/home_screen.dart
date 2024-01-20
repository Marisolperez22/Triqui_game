import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Triki game')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FilledButton(
                child: const Text('Crear sala'),
                onPressed: () {
                  getCode(context);
                },
              ),
              TextFormField(
                controller: textFieldController,
                decoration: const InputDecoration(
                  labelText: 'Ingresa el código de la sala',
                ),
              ),
              const SizedBox(height: 16.0),
              FilledButton(
                onPressed: () {
                  context.push('/main_page/${textFieldController.text}/2');
                },
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getCode(BuildContext context) async {
    try {
      final response =
          await Dio().get('https://triqui-backend.onrender.com/generateRoom');
      Map<String, dynamic> code = response.data;
      context.push('/main_page/${code['room']}/1');
      return;
    } catch (e) {
      print('$e');
      const AlertDialog(
        content: Text('Error'),
      );
    }
  }
}
