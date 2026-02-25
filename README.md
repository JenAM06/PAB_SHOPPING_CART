# Shopping Cart
> Nama: Jen Agresia Misti

> NIM: 2409116007

> Kelas: A 24

> Mata Kuliah: Pemograman Aplikasi Bergerak

> Tugas: State Management dengan Provider

## Struktur Projek

```
lib/
├── main.dart
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── cart_model.dart
└── pages/
    ├── product_list_page.dart
    ├── cart_page.dart
    └── checkout_page.dart
```

## 🧩 Penjelasan Fitur

### 1. Add to Cart Button

Tombol "Add to Cart" memanggil `cart.addItem(product)` langsung ke CartModel. Pakai `context.read<CartModel>()` karena tombol hanya perlu melakukan aksi, tidak perlu rebuild saat cart berubah. Tombol otomatis berubah jadi **"✓ Added"** kalau produk sudah ada di cart karena dibungkus `Consumer<CartModel>`.

```dart
Consumer(
  builder: (context, cart, _) {
    final inCart = cart.items.containsKey(product.id);
    return ElevatedButton(
      onPressed: () => cart.addItem(product),
      child: Text(inCart ? '✓ Added' : 'Add to Cart'),
    );
  },
)
```

> visual


### 2. Cart Badge — Item Count
`lib/pages/product_list_page.dart` → bagian `AppBar actions`

Badge merah di ikon cart menampilkan total quantity semua item. Pakai `Consumer<CartModel>` agar badge otomatis update setiap kali item ditambah atau dikurangi.

```dart
Consumer(
  builder: (context, cart, child) {
    return Stack(
      children: [
        IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () { ... }),
        if (cart.totalQuantity > 0)
          Positioned(
            right: 6, top: 6,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text('${cart.totalQuantity}',
                  style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
      ],
    );
  },
)
```

> visual



### 6. Search by Name
`lib/pages/product_list_page.dart` → `TextField` + filter logic

Menggunakan ephemeral state (`setState`) karena search hanya dipakai di halaman ini saja. Setiap huruf yang diketik langsung memfilter list produk secara real-time menggunakan `.contains()`.

```dart
TextField(
  decoration: const InputDecoration(
    hintText: 'Search shoes...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (value) => setState(() => searchQuery = value),
),
```

> 📸 [Tambahkan screenshot di sini]

---

### 7. Filter by Category
`lib/pages/product_list_page.dart` → `ChoiceChip`

Filter kategori menggunakan `ChoiceChip` yang bisa dipilih. Digabung dengan filter search menggunakan operator `&&` — produk harus memenuhi kedua kondisi sekaligus. Memilih "All" menampilkan semua produk.

```dart
...['All', 'Sport', 'Casual', 'Formal'].map((cat) {
  final isSelected = selectedCategory == cat;
  return ChoiceChip(
    label: Text(cat),
    selected: isSelected,
    selectedColor: Colors.black,
    checkmarkColor: Colors.white,
    onSelected: (_) => setState(() => selectedCategory = cat),
  );
})
```

> 📸 [Tambahkan screenshot di sini]

---

### 8. Cart Page with All Items
`lib/pages/cart_page.dart`

Menampilkan semua item di cart menggunakan `ListView.builder` yang membaca dari `cart.itemsList`. Dibungkus `Consumer<CartModel>` agar otomatis rebuild setiap kali ada perubahan di cart.

```dart
Consumer(
  builder: (context, cart, child) {
    return ListView.builder(
      itemCount: cart.itemsList.length,
      itemBuilder: (context, index) {
        final cartItem = cart.itemsList[index];
        // tampilkan gambar, nama, harga, qty, tombol delete
      },
    );
  },
)
```

> 📸 [Tambahkan screenshot di sini]

---

### 9. Increase / Decrease Quantity
`lib/models/cart_model.dart` → `increaseQuantity()` & `decreaseQuantity()`
`lib/pages/cart_page.dart` → row tombol +/-

`increaseQuantity` menambah qty langsung di Map. `decreaseQuantity` punya logika khusus: jika qty sudah 1 lalu dikurangi, item otomatis dihapus dari cart.

```dart
void decreaseQuantity(String productId) {
  if (_items[productId]!.quantity > 1) {
    _items[productId]!.quantity--;
  } else {
    _items.remove(productId); // otomatis remove kalau qty = 0
  }
  notifyListeners();
}
```

> 📸 [Tambahkan screenshot di sini]

---

### 10. Remove Item Button
`lib/pages/cart_page.dart` → `IconButton` trash icon
`lib/models/cart_model.dart` → `removeItem()`

Tombol hapus memanggil `removeItem()` lalu menampilkan Snackbar konfirmasi. Item langsung hilang dari list karena `notifyListeners()` memicu rebuild UI secara otomatis.

```dart
IconButton(
  onPressed: () {
    cart.removeItem(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} removed')),
    );
  },
  icon: const Icon(Icons.delete, color: Colors.red),
)
```

> 📸 [Tambahkan screenshot di sini]

---

### 11. Total Price Calculation
`lib/models/cart_model.dart` → getter `totalPrice`
Ditampilkan di: `cart_page.dart` + `checkout_page.dart` + tombol Place Order

Menggunakan `fold()` untuk menjumlahkan `totalPrice` dari setiap CartItem. `totalPrice` per item adalah `price × quantity`.

```dart
// cart_item.dart
double get totalPrice => product.price * quantity;

// cart_model.dart
double get totalPrice {
  return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
}
```

> 📸 [Tambahkan screenshot di sini]

---

### 12. Empty Cart Message
`lib/pages/cart_page.dart` → kondisi `if (cart.isEmpty)`

Ketika cart kosong, halaman menampilkan ikon + pesan + tombol balik ke toko. Penting untuk user experience — pengguna tidak melihat halaman kosong tanpa penjelasan.

```dart
if (cart.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
        Text('Your cart is empty'),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue Shopping'),
        ),
      ],
    ),
  );
}
```

> 📸 [Tambahkan screenshot di sini]

---

### 13. Checkout Page — Order Summary + Form
`lib/pages/checkout_page.dart`

Terdiri dari dua bagian: **Order Summary** (daftar item + total harga) dan **Form** (nama, alamat, nomor telepon). Form pakai `GlobalKey<FormState>` untuk validasi — tombol Place Order tidak bisa diproses kalau form belum lengkap. Setelah order berhasil, `cart.clear()` dipanggil dan pengguna diarahkan kembali ke halaman produk.

```dart
if (_formKey.currentState!.validate()) {
  cart.clear();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Order Placed!'),
      content: Text('Thank you, ${nameController.text}!'),
    ),
  );
}
```

> 📸 [Tambahkan screenshot di sini]

---
