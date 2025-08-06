<template>
  <div style="max-width:900px;margin:auto;background:#fff;padding:24px;">
    <h3>GPS Logging <span class="realtime">● Realtime</span></h3>
    <div id="map" style="width:100%;height:220px;margin-bottom:12px"></div>
    <table>
      <tr>
        <th>Waktu</th><th>Latitude</th><th>Longitude</th><th>Alamat</th>
      </tr>
      <tr v-for="item in gpsLogs" :key="item.time">
        <td>{{ item.time }}</td><td>{{ item.lat }}</td><td>{{ item.lon }}</td><td>{{ item.address }}</td>
      </tr>
    </table>
    <h3>Kontak</h3>
    <table>
      <tr>
        <th class="label">Nama Kontak</th><th class="label">Nomor Telepon</th>
      </tr>
      <tr v-for="c in contacts" :key="c.phone">
        <td>{{ c.name }}</td><td>{{ c.phone }}</td>
      </tr>
    </table>
    <h3>SMS Logs</h3>
    <table>
      <tr>
        <th class="label">Tipe SMS</th>
        <th class="label">Nomor Pengirim/Penerima</th>
        <th class="label">Isi Pesan</th>
        <th class="label">Waktu</th>
      </tr>
      <tr v-for="s in smsLogs" :key="s.time+s.body">
        <td>{{ s.direction==='IN'?'Masuk':'Keluar' }}</td>
        <td>{{ s.direction==='IN'?s.from:s.to }}</td>
        <td>{{ s.body }}</td>
        <td>{{ s.time }}</td>
      </tr>
    </table>
    <h3>Call Logs</h3>
    <table>
      <tr>
        <th class="label">Tipe Panggilan</th>
        <th class="label">Nomor</th>
        <th class="label">Durasi (detik)</th>
        <th class="label">Waktu</th>
      </tr>
      <tr v-for="c in callLogs" :key="c.time+c.number">
        <td>{{ c.type==='INCOMING'?'Masuk':c.type==='OUTGOING'?'Keluar':'Tidak Terjawab' }}</td>
        <td>{{ c.number }}</td>
        <td>{{ c.duration }}</td>
        <td>{{ c.time }}</td>
      </tr>
    </table>
  </div>
</template>
<script setup>
import { onMounted } from "vue";
const gpsLogs = [
  { time: "2025-08-03 15:30:40", lat: -6.210, lon: 106.820, address: "Jl. Sudirman, Jakarta" },
  { time: "2025-08-03 15:28:20", lat: -6.200, lon: 106.816, address: "Jl. MH Thamrin, Jakarta" },
];
const contacts = [{ name: "Andi", phone: "081234567890" }, { name: "Siti", phone: "082198765432" }];
const smsLogs = [
  { direction: "IN", from: "081211122233", to: "", body: "Halo", time: "2025-08-03 15:15:00" },
  { direction: "OUT", from: "", to: "081244455566", body: "Siap", time: "2025-08-03 15:18:30" },
];
const callLogs = [
  { type: "INCOMING", number: "081299988877", duration: 60, time: "2025-08-03 14:55:10" },
  { type: "OUTGOING", number: "081255566677", duration: 120, time: "2025-08-03 14:50:00" },
];
onMounted(() => {
  // Gunakan Leaflet, sama seperti contoh HTML di atas
  const L = window.L;
  const last = gpsLogs[0];
  const map = L.map('map').setView([last.lat, last.lon], 15);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(map);
  const marker = L.marker([last.lat, last.lon]).addTo(map).bindPopup("Lokasi Terkini");
  // Simulasi realtime update
  setInterval(() => {
    // update marker.setLatLng(...), panTo(...) jika ada data baru
  }, 5000);
});
</script>
<style scoped>
.label { font-weight: bold; color: #2376e2; }
.realtime { color: #00a01a; font-weight: bold; animation: blink 1.5s infinite; }
@keyframes blink { 50% { opacity: 0.2; } }
table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
th, td { border: 1px solid #ddd; padding: 6px 10px; }
th { background: #f5f5f5; }
</style>
<!-- Tambahkan di index.html: <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script> -->