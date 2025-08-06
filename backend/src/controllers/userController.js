exports.applyLoan = async (req, res) => {
  const { user_id, product_id } = req.body;
  try {
    // Dapatkan data produk dari DB atau hardcode sementara
    const products = [
      { id: 1, amount: 1000000, tenor: 7 },
      { id: 2, amount: 2000000, tenor: 7 },
      { id: 3, amount: 3000000, tenor: 14 },
      { id: 4, amount: 4000000, tenor: 14 },
      { id: 5, amount: 5000000, tenor: 14 }
    ];
    const product = products.find(p => p.id == product_id);
    if (!product) return res.status(404).json({ success: false, message: 'Produk tidak ditemukan' });

    await db.query(
      'INSERT INTO loans (user_id, amount, tenor, status) VALUES (?, ?, ?, ?)',
      [user_id, product.amount, product.tenor, 'pending']
    );
    res.json({ success: true, message: 'Pengajuan berhasil' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Pengajuan gagal', error: err });
  }
};