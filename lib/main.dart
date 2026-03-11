import 'package:flutter/material.dart';
import 'package:flex_convert/models/moeda_model.dart';


void main() => runApp(MaterialApp(home: FlexConvert(), debugShowCheckedModeBanner: false));

class FlexConvert extends StatefulWidget {
  const FlexConvert({super.key});

  @override
  
  // ignore: library_private_types_in_public_api
  _FlexConvertState createState() => _FlexConvertState();
}

class _FlexConvertState extends State<FlexConvert> {
  final TextEditingController _inputController = TextEditingController();

  //Pega as moedas da lista do model
  final List<MoedaModel> moedas = MoedaModel.getMoedas();
  
  late MoedaModel moedaOrigem;
  late MoedaModel moedaDestino;
  String resultado = "0.00";

  @override
  void initState() {
    super.initState();
    moedaOrigem = moedas[0]; // USD
    moedaDestino = moedas[1]; // BRL
  }

  void _converter() {
    // Tenta converter o texto para número, se falhar ou estiver vazio, usa 0.0
    double valor = double.tryParse(_inputController.text.replaceAll(',', '.')) ?? 0.0;
    
    // Lógica Âncora (USD):
    // Converte o valor de origem para Dólar
    double valorEmDolar = valor * moedaOrigem.valorEmDolar;
    // Converte o valor em Dólar para a moeda de destino
    double valorFinal = valorEmDolar / moedaDestino.valorEmDolar;

    setState(() {
      resultado = valorFinal.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlexConvert"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Valor para converter",
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _converter(),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: _buildDropdown(true)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.compare_arrows, color: Colors.blueGrey),
                ),

                Expanded(child: _buildDropdown(false)),
              ],
            ),
            const Spacer(),
            Card(
              elevation: 4,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Resultado Final", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(
                      resultado,
                      style: const TextStyle(
                        fontSize: 40, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(bool isOrigem) {
    return DropdownButtonFormField<MoedaModel>(
      decoration: InputDecoration(
        labelText: isOrigem ? "De" : "Para",
        border: const OutlineInputBorder(),
      ),

      initialValue: isOrigem ? moedaOrigem : moedaDestino,
      onChanged: (MoedaModel? novoValor) {
        setState(() {
          if (isOrigem) {
            moedaOrigem = novoValor!;
          } else {
            moedaDestino = novoValor!;
          }
          _converter();
        });
      },
      items: moedas.map((m) {
        return DropdownMenuItem(
          value: m,
          child: Text(m.nome),
        );

      }).toList(),
    );

  }
}