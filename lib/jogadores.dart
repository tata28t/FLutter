import 'package:even_odd/main.dart';
import 'package:flutter/material.dart';

class ListaJogadores extends StatelessWidget {
  Function callback;
  List<Jogador> jogadores = [];
  var currPlayerName;

  ListaJogadores(this.callback, this.jogadores, this.currPlayerName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista jogadores'),
        ),
        body: Column(
          children: [
            Column(
              children: jogadores
                  .where((jogador) => jogador.username != currPlayerName)
                  .map((jogador) => Row(
                        children: [
                          Text(jogador.username),
                          ElevatedButton(
                              child: const Text('Apostar contra'),
                              onPressed: () => callback(jogador.username)),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ));
  }
}
