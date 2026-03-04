class DatabaseService {
  // Método para obtener ofertas favoritas (solo datos de ejemplo)
  static Future<List<Map<String, dynamic>>> getOfertasFavoritas(
    int usuarioId,
  ) async {
    // Simular tiempo de carga de red
    await Future.delayed(const Duration(seconds: 2));

    return [
      {
        'productName': 'Hamburguesa Especial',
        'productPrice': 79.99,
        'productDetails': 'Hamburguesa con queso + papas + refresco',
        'imageURL':
            'https://res.cloudinary.com/amecar/image/upload/f_auto/v1738363260/CarlsJr-Oferta14DeFebrero-WebsiteLoNuevo-960x540_28_zbnjwa.jpg',
        'localName': 'Carl\'s Jr.',
      },
      {
        'productName': 'Pizzas Grandes',
        'productPrice': 199.99,
        'productDetails': '2 Pizzas grandes - Pepperoni o Queso',
        'imageURL':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzyG90wDoJR9xUYrMsMbyxFzrTkSvMBtg0OA&s',
        'localName': 'Dominos Pizza',
      },
      {
        'productName': 'Café + Postre',
        'productPrice': 45.50,
        'productDetails': 'Café americano + Pan de Chocolate',
        'imageURL':
            'https://static.promodescuentos.com/threads/raw/9eV2E/985793_1/re/768x768/qt/60/985793_1.jpg',
        'localName': 'Starbucks',
      },
      {
        'productName': 'Pizza Familiar',
        'productPrice': 129.00,
        'productDetails': 'Pizza familiar 4 ingredientes a elegir',
        'imageURL':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMs40YuNqHjYJAI0-ErO37giwq78rYUDgieQ&s',
        'localName': 'Pizza Hut',
      },
      {
        'productName': 'Platillos Favoritos',
        'productPrice': 109.00,
        'productDetails': 'Desayunos variados',
        'imageURL':
            'https://d3hpc9frzzutmq.cloudfront.net/cdn/ihop/uploads/2025/07/27150757/header-mobile.png',
        'localName': 'Ihop',
      },
    ];
  }
}
