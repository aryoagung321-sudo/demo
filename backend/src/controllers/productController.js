exports.getProducts = (req, res) => {
  const products = [
    { id: 1, amount: 1000000, tenor: 7 },
    { id: 2, amount: 2000000, tenor: 7 },
    { id: 3, amount: 3000000, tenor: 14 },
    { id: 4, amount: 4000000, tenor: 14 },
    { id: 5, amount: 5000000, tenor: 14 }
  ];
  res.json(products);
};