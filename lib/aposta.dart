import 'package:flutter/material.dart';

class Aposta extends StatefulWidget {
  Function callback;
  String playerName;

  Aposta(this.callback, this.playerName);

  @override
  State<StatefulWidget> createState() => ApostaState(callback, playerName);
}

class ApostaState extends State<Aposta> {
  // funcao para trocar de tela
  Function callback;
  String playerName;
  int num = 1;
  int betValue = 0;
  int oddEven = 1;

  ApostaState(this.callback, this.playerName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$playerName aposta'),
      ),
      body: Column(
        children: [
          const Text('Escolher um número'),
          Slider(
            label: '$num',
            min: 1,
            max: 5,
            divisions: 5,
            value: num.toDouble(),
            onChanged: (value) {
              setState(() {
                num = value.toInt();
              });
            },
          ),
          const Text('Valor da aposta'),
          Slider(
            label: '$betValue',
            min: 0,
            max: 100,
            divisions: 10,
            value: betValue.toDouble(),
            onChanged: (value) {
              setState(() {
                betValue = value.toInt();
              });
            },
          ),
          Row(
            children: [
              const Text('Par'),
              Radio(
                  value: 1,
                  groupValue: oddEven,
                  onChanged: (int? value) {
                    setState(() {
                      oddEven = 1;
                    });
                  }),
              const Text('Ímpar'),
              Radio(
                  value: 2,
                  groupValue: oddEven,
                  onChanged: (int? value) {
                    setState(() {
                      oddEven = 2;
                    });
                  })
            ],
          ),
          ElevatedButton(
              child: const Text('Escolher adversário'),
              onPressed: () => callback(betValue, oddEven, num))
        ],
      ),
    );
  }
}
