import 'package:flutter/material.dart';

class PerfilJogador extends StatelessWidget {
  Function callback;
  String nome;
  int pontos;

  PerfilJogador(this.callback, this.nome, this.pontos);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil de ${nome}'),
        ),
        body: Column(
          children: [
            Text('Pontos: ${pontos}'),
            ElevatedButton(
                child: const Text('Apostar denovo'),
                onPressed: () => callback(1))
          ],
        ));
  }
}
