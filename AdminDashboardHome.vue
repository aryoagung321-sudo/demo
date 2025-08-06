<template>
  <div>
    <div class="header">
      <h1>Dashboard Admin</h1>
      <span>Monitoring & Kontrol Perangkat User</span>
    </div>
    <div class="container">
      <div class="metrics">
        <div class="metric"><div class="num">{{ users.length }}</div><div>Total User Aktif</div></div>
        <div class="metric"><div class="num">{{ onlineCount }}</div><div>User Online</div></div>
        <div class="metric"><div class="num">2</div><div>Device Alert</div></div>
        <div class="metric"><div class="num">3</div><div>Command Pending</div></div>
      </div>
      <div class="actions">
        <button @click="alert('Tambah user baru!')">+ Tambah User</button>
        <button @click="alert('Export data!')">Export Data</button>
        <button @click="alert('Lihat log sistem!')">Log Sistem</button>
      </div>
      <h3>Daftar User</h3>
      <table>
        <tr>
          <th>Nama</th><th>Nomor HP</th><th>Status</th><th>Last Active</th>
          <th>Fitur Aktif</th><th>Device</th><th>Command</th><th>Aksi</th>
        </tr>
        <tr v-for="u in users" :key="u.phone">
          <td>{{ u.name }}</td>
          <td>{{ u.phone }}</td>
          <td>
            <span :class="['user-status', u.status]">
              {{ u.status === 'active' ? 'Aktif' : 'Nonaktif' }}
            </span>
          </td>
          <td>{{ u.last }}</td>
          <td class="feature-tags">
            <span v-for="f in u.features" :key="f" class="feature-tag">{{ f }}</span>
          </td>
          <td>{{ u.device }}</td>
          <td>{{ u.command }}</td>
          <td><button class="go-detail" @click="alert('Lihat detail user!')">Detail</button></td>
        </tr>
      </table>
    </div>
  </div>
</template>
<script setup>
const users = [
  {
    name: "Budi Santoso", phone: "0812xxxx111", status: "active", last: "2025-08-03 08:40",
    features: ["GPS", "Kontak", "SMS", "Call", "App", "Mic", "Clipboard"], device: "Android", command: "Pending"
  },
  {
    name: "Rina Wijaya", phone: "0821xxxx222", status: "active", last: "2025-08-03 08:39",
    features: ["GPS", "Kontak", "App"], device: "Android", command: "OK"
  },
  {
    name: "Hendra", phone: "0856xxxx333", status: "inactive", last: "2025-08-02 20:10",
    features: ["GPS", "Kontak"], device: "Android", command: "-"
  },
  {
    name: "Siti Aminah", phone: "0877xxxx444", status: "active", last: "2025-08-03 08:35",
    features: ["GPS", "Kontak", "SMS", "Clipboard", "Notif"], device: "Android", command: "Pending"
  }
];
const onlineCount = users.filter(u=>u.status==="active").length;
</script>
<style scoped>
.header { background: #2376e2; color: #fff; padding: 18px 32px; }
.container { max-width: 1200px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 0 8px #ddd; padding: 24px; }
.metrics { display: flex; gap: 28px; margin-bottom: 30px; }
.metric { background: #f4f8ff; border-radius: 10px; padding: 18px 32px; min-width: 180px; text-align: center; }
.metric .num { font-size: 2.1em; font-weight: bold; color: #2376e2; }
.actions { margin-bottom: 18px; }
.actions button { background: #2376e2; color: #fff; border: none; border-radius: 4px; padding: 8px 18px; margin-right: 10px; cursor: pointer; }
.actions button:hover { background: #1653b7; }
table { width: 100%; border-collapse: collapse; margin-top: 12px; }
th, td { border: 1px solid #ececec; padding: 8px 12px; }
th { background: #f5f5f8; }
.user-status { font-weight: bold; padding: 2px 8px; border-radius: 5px; }
.user-status.active { background: #c9f7ce; color: #045d1c; }
.user-status.inactive { background: #ffd6d6; color: #a80000; }
.feature-tags { font-size: 0.92em; }
.feature-tag { background: #eee; border-radius: 3px; margin-right: 4px; padding: 2px 5px; }
.go-detail { background: #fff; color: #2376e2; border: 1px solid #2376e2; border-radius: 4px; padding: 4px 10px; cursor: pointer;}
.go-detail:hover { background: #2376e2; color: #fff; }
@media (max-width: 900px) { .metrics { flex-direction: column; gap: 10px; } }
</style>