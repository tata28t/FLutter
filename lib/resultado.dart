import 'package:flutter/material.dart';

// As apostas são comparadas e o resultado exibido
class ResultadoAposta extends StatelessWidget {
  // funcao para trocar de tela
  Function anotherBetCallback;
  Function playerProfileCallback;
  String challenger;
  String challenged;
  String currBetResult;

  ResultadoAposta(this.anotherBetCallback, this.playerProfileCallback, this.challenged,
      this.challenger, this.currBetResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado: $challenger contra $challenged'),
      ),
      body: Column(
        children: [
          Text(currBetResult),
          ElevatedButton(
              child: const Text('Apostar denovo'),
              onPressed: () => anotherBetCallback()),
          ElevatedButton(
              child: const Text('Seus pontos'),
              onPressed: () => playerProfileCallback())
        ],
      ),
    );
  }
}
