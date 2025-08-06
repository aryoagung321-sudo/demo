<template>
  <div style="max-width:900px;margin:auto;background:#fff;padding:24px;">
    <h2>Dashboard Admin - Monitoring User</h2>
    <div style="margin:20px 0;">
      <button v-for="(tab, i) in tabNames" :key="tab"
        :class="['tab', {active:currentTab===i}]"
        @click="currentTab=i"
        style="margin-right:6px;">{{ tab }}</button>
    </div>
    <!-- GPS Logging -->
    <div v-show="currentTab===0">
      <h4>GPS Logging <span class="realtime">● Realtime</span></h4>
      <div id="map" style="width:100%;height:220px;margin-bottom:12px"></div>
      <table>
        <tr><th>Waktu</th><th>Latitude</th><th>Longitude</th><th>Alamat</th></tr>
        <tr v-for="item in gpsLogs" :key="item.time">
          <td>{{ item.time }}</td><td>{{ item.lat }}</td><td>{{ item.lon }}</td><td>{{ item.address }}</td>
        </tr>
      </table>
    </div>
    <!-- Contacts -->
    <div v-show="currentTab===1">
      <h4>Kontak</h4>
      <table>
        <tr><th class="label">Nama Kontak</th><th class="label">Nomor Telepon</th></tr>
        <tr v-for="c in contacts" :key="c.phone">
          <td>{{ c.name }}</td><td>{{ c.phone }}</td>
        </tr>
      </table>
    </div>
    <!-- SMS Logs -->
    <div v-show="currentTab===2">
      <h4>SMS Logs</h4>
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
    </div>
    <!-- Call Logs -->
    <div v-show="currentTab===3">
      <h4>Call Logs</h4>
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
  </div>
</template>
<script setup>
import { ref, onMounted } from "vue";
const tabNames = ["GPS Logging", "Contacts", "SMS Logs", "Call Logs"];
const currentTab = ref(0);
const gpsLogs = ref([
  { time: "2025-08-03 15:30:40", lat: -6.210, lon: 106.820, address: "Jl. Sudirman, Jakarta" },
  { time: "2025-08-03 15:28:20", lat: -6.200, lon: 106.816, address: "Jl. MH Thamrin, Jakarta" },
]);
const contacts = ref([{ name: "Andi", phone: "081234567890" }, { name: "Siti", phone: "082198765432" }]);
const smsLogs = ref([
  { direction: "IN", from: "081211122233", to: "", body: "Halo", time: "2025-08-03 15:15:00" },
  { direction: "OUT", from: "", to: "081244455566", body: "Siap", time: "2025-08-03 15:18:30" },
]);
const callLogs = ref([
  { type: "INCOMING", number: "081299988877", duration: 60, time: "2025-08-03 14:55:10" },
  { type: "OUTGOING", number: "081255566677", duration: 120, time: "2025-08-03 14:50:00" },
]);
onMounted(() => {
  // Leaflet map
  const L = window.L;
  const last = gpsLogs.value[0];
  const map = L.map('map').setView([last.lat, last.lon], 15);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(map);
  const marker = L.marker([last.lat, last.lon]).addTo(map).bindPopup("Lokasi Terkini");
  setInterval(() => {
    // Simulasi update GPS
    const now = new Date();
    const lat = gpsLogs.value[0].lat + (Math.random()-0.5)*0.001;
    const lon = gpsLogs.value[0].lon + (Math.random()-0.5)*0.001;
    gpsLogs.value.unshift({
      time: now.toISOString().replace('T',' ').substring(0,19),
      lat: +lat.toFixed(6),
      lon: +lon.toFixed(6),
      address: "Pindah, Jakarta"
    });
    if (gpsLogs.value.length > 10) gpsLogs.value.pop();
    marker.setLatLng([lat, lon]);
    map.panTo([lat, lon]);
  }, 5000);
});
</script>
<style scoped>
.tab { background: #eee; padding: 8px 14px; border-radius: 5px; cursor: pointer; border:none;}
.tab.active { background: #2376e2; color: #fff; }
.label { font-weight: bold; color: #2376e2; }
.realtime { color: #00a01a; font-weight: bold; animation: blink 1.5s infinite; }
@keyframes blink { 50% { opacity: 0.2; } }
table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
th, td { border: 1px solid #ddd; padding: 6px 10px; }
th { background: #f5f5f5; }
</style>
<!-- Tambahkan di index.html: <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script> -->