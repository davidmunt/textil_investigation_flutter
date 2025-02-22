import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:textil_investigation/data/models/tela_model.dart';

abstract class TelasRemoteDataSource {
  Future<List<TelaModel>> fetchFilteredTelas(Map<String, dynamic> filters);
}

class TelasRemoteDataSourceImpl implements TelasRemoteDataSource {
  final http.Client client;
  String apiUrl = dotenv.env['direccionApi'] ?? 'localhost';
  String apiPort = dotenv.env['puertoApi'] ?? '3000';

  TelasRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TelaModel>> fetchFilteredTelas(
      Map<String, dynamic> filters) async {
    final uri = Uri.parse('http://$apiUrl:$apiPort/telas/filter/telas');

    // Construimos el objeto de filtros aquí
    final Map<String, dynamic> filterParams = {
      "denominacion": filters['name'] ?? null,
      "ids_aplicaciones": filters['ids_aplicaciones'] ?? null,
      "ids_tipo_estructural": filters['ids_tipo_estructural'] ?? null,
      "ids_composicion": filters['ids_composicion'] ?? null,
      "ids_conservacion": filters['ids_conservacion'] ?? null,
      "ids_estructura_ligamento": filters['ids_estructura_ligamento'] ?? null,
      "cac_tecnicas": filters['cac_tecnicas'] ?? null,
      "cac_visuales": filters['cac_visuales'] ?? null,
      "transparency": filters['transparency'] ?? null,
      "brightness": filters['brightness'] ?? null,
    };

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filterParams),
    );

    if (response.statusCode == 201) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => TelaModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las telas');
    }
  }
}
