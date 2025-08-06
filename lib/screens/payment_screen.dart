import 'package:flutter/material.dart';

final List<Map<String, dynamic>> loans = [
  {
    "productName": "Pinjaman Lancar",
    "status": "Jatuh tempo",
    "statusColor": Colors.red,
    "amount": 1800000,
    "dueDate": "16-05-2025",
    "desc": "Pinjaman",
    "icon": Icons.attach_money,
    "iconColor": Colors.indigo,
    "warning": "Jangan memberikan informasi pinjaman dan kode verifikasi Anda kepada siapa pun",
  },
  {
    "productName": "Modal Fresh--Kope...",
    "status": "Jatuh tempo",
    "statusColor": Colors.red,
    "amount": 1800000,
    "dueDate": null,
    "desc": "Pinjaman",
    "icon": Icons.account_balance_rounded,
    "iconColor": Colors.purple,
    "note":
        "Kami tidak terlibat dalam proses pencairan penagihan yang dilakukan pihak pemilik produk",
  },
];

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = [
    "Lunas",
    "Belum bayar",
    "Jatuh tempo",
    "Menunggu disetujui"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 2);
  }

  String currencyFormat(int number) =>
      "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          color: Color(0xff2186eb),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'AyoPinjam',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              letterSpacing: 1.2),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xffbbd8fa),
                  isScrollable: true,
                  tabs: [
                    for (final t in tabs)
                      Tab(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          t,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xfffff8e1),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "i-Hatilah terhadap modus penipuan 2.  Seluruh informasi potongan pem...",
              style: TextStyle(
                color: Color(0xffb98a00),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Lunas
                Center(
                  child: Text(
                    "Tidak ada pinjaman lunas.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Tab Belum Bayar
                Center(
                  child: Text(
                    "Tidak ada pinjaman belum bayar.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Tab Jatuh Tempo
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...loans.asMap().entries.map((entry) {
                        final i = entry.key;
                        final loan = entry.value;
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: i == 0 ? 16 : 10,
                                  left: 10,
                                  right: 10,
                                  bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: loan["iconColor"].withOpacity(0.13),
                                        ),
                                        child: Icon(
                                          loan["icon"],
                                          color: loan["iconColor"],
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          loan["productName"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        loan["status"],
                                        style: TextStyle(
                                            color: loan["statusColor"],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    loan["desc"] ?? "",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rp ${currencyFormat(loan["amount"])}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  if (loan["dueDate"] != null) ...[
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Tanggal Jatuh Tempo",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          loan["dueDate"],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff2186eb),
                                            shape: StadiumBorder(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 28, vertical: 0),
                                            minimumSize: Size(120, 36)),
                                        onPressed: () {
                                          // Navigasi ke pembayaran
                                        },
                                        child: Text("Pembayaran"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (i == 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xfffff1e1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded,
                                          color: Color(0xffefa100), size: 38),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          loan["warning"],
                                          style: TextStyle(
                                              color: Color(0xffb98a00),
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                // Tab Menunggu Disetujui
                Center(
                  child: Text(
                    "Tidak ada pinjaman menunggu disetujui.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Color(0xff2186eb),
        unselectedItemColor: Colors.grey[400],
        onTap: (idx) {
          // Navigasi: 0=Pinjaman, 1=Produk Anggota, 2=Pembayaran (stay here)
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Pinjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Produk Anggota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pembayaran',
          ),
        ],
      ),
    );
  }
}