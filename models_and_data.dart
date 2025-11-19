// Basado en la tabla 'Clientes'
class Cliente {
  final int id;
  final String nombre;
  final String direccion;
  final String telefono;

  Cliente({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  // Constructor 'factory' para crear un Cliente desde un JSON
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['ID_Cliente'] ?? 0,
      nombre: json['Nombre'] ?? '',
      direccion: json['Direccion'] ?? '',
      telefono: json['Telefono'] ?? '',
    );
  }
}

// Basado en la tabla 'Empleados'
class Empleado {
  final int id;
  final String nombre;
  final String apellido;
  final String puesto;

  Empleado({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.puesto,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['ID_Empleado'] ?? 0,
      nombre: json['Nombre'] ?? '',
      apellido: json['Apellido'] ?? '',
      puesto: json['Puesto'] ?? '',
    );
  }
}

// Basado en la tabla 'Articulos'
class Articulo {
  final int id;
  final String descripcion;
  final double precio;
  final int stock;
  final String marca;

  Articulo({
    required this.id,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.marca,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['ID_Articulo'] ?? 0,
      descripcion: json['Descripcion'] ?? '',
      // Convertimos el precio (que puede venir como string) a double
      precio: double.tryParse(json['Precio'].toString()) ?? 0.0,
      stock: json['Stock'] ?? 0,
      marca: json['Marca'] ?? '',
    );
  }
}

// --- Agrega aquí los modelos para Pedidos, Envios y Proveedores ---
// --- cuando estés listo para mostrarlos. ---

/*
class Pedido {
  // Define los campos de tu tabla Pedidos
  factory Pedido.fromJson(Map<String, dynamic> json) {
    // Implementa la lógica
  }
}
*/
