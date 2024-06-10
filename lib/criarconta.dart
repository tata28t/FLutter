import 'package:flutter/material.dart';

class CriarConta extends StatelessWidget {
  Function callback;

  CriarConta(this.callback);

  @override
  Widget build(BuildContext ctx) {
    final formKey = GlobalKey<FormState>();
    final inputNomePlayer = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta no jogo'),),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(5.0), 
              child: TextFormField(controller: inputNomePlayer, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Seu nome'),),),
            ElevatedButton(onPressed: () => callback(inputNomePlayer.text), child: const Text('Fazer aposta')),
          ],
        ),
      )
    );
  }
}
