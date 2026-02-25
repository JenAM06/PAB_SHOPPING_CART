// lib/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Nike Air Max',
      price: 2500000,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      description: 'Running shoes premium',
      category: 'Sport',
    ),
    Product(
      id: '2',
      name: 'Adidas Ultraboost',
      price: 3000000,
      imageUrl:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      description: 'High comfort sport shoes',
      category: 'Sport',
    ),
    Product(
      id: '3',
      name: 'Converse High',
      price: 1200000,
      imageUrl:
          'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=400',
      description: 'Casual classic shoes',
      category: 'Casual',
    ),
    Product(
      id: '4',
      name: 'Vans Old Skool',
      price: 1100000,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      description: 'Skate casual shoes',
      category: 'Casual',
    ),
    Product(
      id: '5',
      name: 'Pantofel Leather',
      price: 2000000,
      imageUrl:
          'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=400',
      description: 'Formal leather shoes',
      category: 'Formal',
    ),
    Product(
      id: '6',
      name: 'Nike Jordan 1',
      price: 4500000,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
      description: 'Basketball iconic shoes',
      category: 'Sport',
    ),
  ];

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('👟 Shoe Store'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.totalQuantity > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cart.totalQuantity}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search shoes...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['All', 'Sport', 'Casual', 'Formal'].map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: // SESUDAH
                  ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.black,
                    backgroundColor: Colors.grey[200],
                    checkmarkColor: Colors.white,   // ← ini yang bikin centang putih
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // RESPONSIVE GRID
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;

                if (constraints.maxWidth > 900) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 300,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _ProductCard(
                      product: product,
                      formattedPrice:
                          _formatPrice(product.price),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final String formattedPrice;

  const _ProductCard({
    required this.product,
    required this.formattedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Text(formattedPrice,
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: Consumer<CartModel>(
                      builder: (context, cart, _) {
                        final inCart =
                            cart.items.containsKey(product.id);
                        return ElevatedButton(
                          onPressed: () =>
                              cart.addItem(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                inCart ? Colors.green : Colors.black,
                            padding: EdgeInsets.zero,
                          ),
                          child: FittedBox(
                            child: Text(
                              inCart
                                  ? '✓ Added'
                                  : 'Add to Cart',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}