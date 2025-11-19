import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models_and_data.dart';

class DataWindowPage extends StatefulWidget {
  const DataWindowPage({
    super.key,
    required this.dataType,
    required this.title,
  });

  final String dataType;
  final String title;

  @override
  State<DataWindowPage> createState() => _DataWindowPageState();
}

class _DataWindowPageState extends State<DataWindowPage> {
  late Future<List<dynamic>> _futureData;

  // ¡Esta es la URL de tu API de Python!
  // 127.0.0.1 (o localhost) se refiere a "esta misma máquina"
  final String apiUrl = 'http://127.0.0.1:5000/api/data';

  @override
  void initState() {
    super.initState();
    // Llama a la función de carga de datos
    _futureData = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    // Construye la URL final, ej: http://127.0.0.1:5000/api/data?table=Clientes
    String requestUrl = '$apiUrl?table=${widget.dataType}';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        // Convierte la lista JSON en una lista de objetos Dart
        switch (widget.dataType) {
          case 'Clientes': // El nombre debe coincidir con el botón
            return jsonResponse.map((data) => Cliente.fromJson(data)).toList();
          case 'Empleados':
            return jsonResponse.map((data) => Empleado.fromJson(data)).toList();
          case 'Articulos':
            return jsonResponse.map((data) => Articulo.fromJson(data)).toList();

          case 'Pedidos':
            // return jsonResponse.map((data) => Pedido.fromJson(data)).toList();
            throw Exception('El modelo "Pedido" aún no está implementado.');
          case 'Envios':
            throw Exception('El modelo "Envio" aún no está implementado.');
          case 'Proveedores':
            throw Exception('El modelo "Proveedor" aún no está implementado.');

          default:
            throw Exception('Tipo de dato no manejado: ${widget.dataType}');
        }
      } else {
        String errorMsg =
            jsonDecode(response.body)['error'] ?? 'Error desconocido';
        throw Exception('Error al cargar los datos: $errorMsg');
      }
    } catch (e) {
      throw Exception(
        'No se pudo conectar al API. ¿Está `api.py` en ejecución?\nDetalle: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              // estados de carga
              child: FutureBuilder<List<dynamic>>(
                future: _futureData,
                builder: (context, snapshot) {
                  // 1. MIENTRAS CARGA
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 2. SI HAY UN ERROR
                  else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error al cargar:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  // 3. SI TIENE DATOS
                  else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // ¡Éxito! Construye la tabla
                    return _buildDataTable(snapshot.data!);
                  }
                  // 4. SI NO HAY DATOS
                  else {
                    return const Center(
                      child: Text('No se encontraron datos en la tabla.'),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDataTable(List<dynamic> data) {
    switch (widget.dataType) {
      case 'Clientes':
        List<Cliente> clientes = data.cast<Cliente>();
        return DataTable(
          columns: const [
            DataColumn(label: Text('ID Cliente')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Dirección')),
            DataColumn(label: Text('Teléfono')),
          ],
          rows: clientes
              .map(
                (cliente) => DataRow(
                  cells: [
                    DataCell(Text(cliente.id.toString())),
                    DataCell(Text(cliente.nombre)),
                    DataCell(Text(cliente.direccion)),
                    DataCell(Text(cliente.telefono)),
                  ],
                ),
              )
              .toList(),
        );
      case 'Empleados':
        List<Empleado> empleados = data.cast<Empleado>();
        return DataTable(
          columns: const [
            DataColumn(label: Text('ID Empleado')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Apellido')),
            DataColumn(label: Text('Puesto')),
          ],
          rows: empleados
              .map(
                (empleado) => DataRow(
                  cells: [
                    DataCell(Text(empleado.id.toString())),
                    DataCell(Text(empleado.nombre)),
                    DataCell(Text(empleado.apellido)),
                    DataCell(Text(empleado.puesto)),
                  ],
                ),
              )
              .toList(),
        );
      case 'Articulos':
        List<Articulo> articulos = data.cast<Articulo>();
        return DataTable(
          columns: const [
            DataColumn(label: Text('ID Artículo')),
            DataColumn(label: Text('Descripción')),
            DataColumn(label: Text('Marca')),
            DataColumn(label: Text('Precio'), numeric: true),
            DataColumn(label: Text('Stock'), numeric: true),
          ],
          rows: articulos
              .map(
                (articulo) => DataRow(
                  cells: [
                    DataCell(Text(articulo.id.toString())),
                    DataCell(Text(articulo.descripcion)),
                    DataCell(Text(articulo.marca)),
                    DataCell(Text('\$${articulo.precio.toStringAsFixed(2)}')),
                    DataCell(Text(articulo.stock.toString())),
                  ],
                ),
              )
              .toList(),
        );
      // Agrega aquí los 'case' para construir las tablas de tus otras entidades

      default:
        // Esto se mostrará si los datos llegan pero no coinciden con un caso
        return Center(
          child: Text('No hay una vista definida para "${widget.dataType}".'),
        );
    }
  }
}
