// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:even_odd/perfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'aposta.dart';
import 'jogadores.dart';
import 'criarconta.dart';
import 'resultado.dart';

void main() => runApp(Aplicativo());

class Aplicativo extends StatefulWidget {
  @override
  State<Aplicativo> createState() => AplicativoState();
}

class Jogador {
  var username;
  var points;

  Jogador(this.username, this.points);

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'pontos': int point,
      } =>
        Jogador(
          username,
          point,
        ),
      _ => throw const FormatException('erro'),
    };
  }
}

class AplicativoState extends State<Aplicativo> {
  int currScreen = 0;
  String nomeJogador = '';
  String nomeJogadorDesafiado = '';
  List<Jogador> listaJogadores = [];
  String resultadoAtual = '';
  int currPlayerPoints = 0;

  void trocarTela(int newScreen) {
    setState(() {
      currScreen = newScreen;
    });
  }

  void setPlayerName(String newPlayerName) {
    setState(() {
      nomeJogador = newPlayerName;
    });
  }



  Future<void> criarConta(String name) async {
    var url = Uri.https('par-impar.glitch.me', 'novo');
    var response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'username': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      List usuariosJson =
          ((jsonDecode(response.body) as Map<String, dynamic>)['usuarios']);

      listaJogadores = usuariosJson
          .map((playerJson) => Jogador.fromJson(playerJson))
          .toList();

      nomeJogador = name;

      trocarTela(1);
    } else {
      throw const HttpException('erro');
    }
  }



  Future<void> criarAposta(int betValue, int oddEven, int number) async {
    var url = Uri.https('par-impar.glitch.me', 'aposta');
    var resposta = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'username': nomeJogador,
          'valor': betValue,
          'parimpar': oddEven, // 2 -> even, 1 -> odd
          'numero': number
        }));

    if (resposta.statusCode == 200 || resposta.statusCode == 204) {
      trocarTela(2);
    } else {
      throw const HttpException('erro');
    }
  }

  Future<void> desafiarJogador(String challengedName) async {
    nomeJogadorDesafiado = challengedName;

    var url = Uri.https(
        'par-impar.glitch.me', 'jogar/' + challengedName + '/' + nomeJogador);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 204) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json.containsKey('msg')) {
        resultadoAtual = "Empate! não ganhou nada! :/";
      } else {
        var winner = json['vencedor'];
        var loser = json['perdedor'];
        if (winner['username'] == nomeJogador) {
          resultadoAtual = 'Você ganhou ${loser['valor']} pontos! :)';
        } else ()
          resultadoAtual = 'Você perdeu ${winner['valor']} pontos! :(';
        }
      }

      trocarTela(3);
    } else {
      throw const HttpException('erro');
    }
  }

  Future<void> telaPerfil() async {
    var url = Uri.https('par-impar.glitch.me', 'pontos/' + nomeJogador);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 204) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;

      currPlayerPoints = json['pontos'];

      trocarTela(4);
    } else {
      throw const HttpException('Failed to get bet');
    }
  }

  void telaOutraAposta() {
    trocarTela(1);
  }

  Widget telas() {
    switch (currScreen) {
      case 1:
        return Aposta(criarAposta, nomeJogador);
      case 2:
        return ListaJogadores(desafiarJogador, listaJogadores, nomeJogador);
      case 3:
        return ResultadoAposta(telaOutraAposta, telaPerfil, nomeJogadorDesafiado,
            nomeJogador, resultadoAtual);
      case 4:
        return PerfilJogador(trocarTela, nomeJogador, currPlayerPoints);
      default:
        return CriarConta(criarConta);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'par ou ímpar',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true),
      home: telas(),
    );
  }
}
