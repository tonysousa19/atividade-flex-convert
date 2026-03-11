class MoedaModel {
  final String nome;
  final double valorEmDolar; // Quantos dólares vale 1 unidade desta moeda

  MoedaModel({required this.nome, required this.valorEmDolar});

  static List<MoedaModel> getMoedas() {
    return [
      MoedaModel(nome: 'USD - Dólar', valorEmDolar: 1.0),
      MoedaModel(nome: 'BRL - Real', valorEmDolar: 0.20), // Ex: 1 Real = 0.20 USD
    ];
  }
}