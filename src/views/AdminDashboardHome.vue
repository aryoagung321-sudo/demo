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
        <div class="metric"><div class="num">{{ alertCount }}</div><div>Device Alert</div></div>
        <div class="metric"><div class="num">{{ pendingCommandCount }}</div><div>Command Pending</div></div>
      </div>
      <div class="analytics-row">
        <div class="analytics-col">
          <h4>Aktivitas User (7 Hari)</h4>
          <canvas ref="activityChart" height="120"></canvas>
          <div class="stat-box">Rata-rata: {{ avgActivity }} user/hari</div>
        </div>
        <div class="analytics-col">
          <h4>Distribusi Fitur Aktif</h4>
          <canvas ref="featureChart" height="120"></canvas>
          <div class="stat-box">Fitur populer: {{ popularFeatures.join(', ') }}</div>
        </div>
        <div class="analytics-col">
          <h4>User Online per Jam (Hari ini)</h4>
          <canvas ref="hourlyChart" height="120"></canvas>
          <div class="stat-box">Peak: {{ Math.max(...hourlyOnline) }} user</div>
        </div>
      </div>
      <div class="actions">
        <button @click="alert('Tambah user baru!')">+ Tambah User</button>
        <button @click="alert('Export data!')">Export Data</button>
        <button @click="alert('Lihat log sistem!')">Log Sistem</button>
      </div>
      <h3>Daftar User</h3>
      <div style="overflow-x:auto;">
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
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import Chart from 'chart.js/auto'

// Dummy user list
const users = ref([
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
]);
const onlineCount = ref(users.value.filter(u=>u.status==="active").length);
const alertCount = ref(2);
const pendingCommandCount = ref(3);

// --- ANALYTICS DATA (Realtime simulation) ---
const activityLabels = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
const activityData = ref([3, 5, 4, 6, 8, 7, 6]);
const avgActivity = computed(() => Math.round(activityData.value.reduce((a,b)=>a+b,0)/activityData.value.length));

const allFeatures = computed(() => users.value.flatMap(u=>u.features));
const featCount = computed(() => {
  const count = {};
  allFeatures.value.forEach(f => count[f] = (count[f]||0)+1);
  return count;
});
const popularFeatures = computed(() => {
  const sorted = Object.entries(featCount.value).sort((a,b)=>b[1]-a[1]);
  return sorted.slice(0,3).map(f=>f[0]);
});

// Pie chart data
const featureLabels = ref(Object.keys(featCount.value));
const featureNums = ref(Object.values(featCount.value));

// Hourly online
const hourlyLabels = ref(Array.from({length: 12}, (_,i) => (8+i)+":00"));
const hourlyOnline = ref([2, 3, 6, 8, 10, 12, 8, 7, 6, 7, 5, 3]);

// Chart refs
const activityChart = ref();
const featureChart = ref();
const hourlyChart = ref();

let activityChartObj, featureChartObj, hourlyChartObj;

// --- Simulasi update realtime (bisa diganti dengan WebSocket/REST) ---
onMounted(async () => {
  await nextTick();
  // CHART 1: activity
  activityChartObj = new Chart(activityChart.value.getContext('2d'), {
    type: 'line',
    data: {
      labels: activityLabels,
      datasets: [{
        label: 'User Aktif/Hari',
        data: activityData.value,
        borderColor: '#2376e2',
        backgroundColor: 'rgba(35,118,226,0.13)',
        fill: true,
        tension: 0.45,
        pointRadius: 4,
      }]
    },
    options: { plugins:{legend:{display:false}}, scales:{y:{beginAtZero:true,suggestedMax:10}} }
  });
  // CHART 2: feature
  featureChartObj = new Chart(featureChart.value.getContext('2d'), {
    type: 'pie',
    data: {
      labels: Object.keys(featCount.value),
      datasets: [{
        data: Object.values(featCount.value),
        backgroundColor: [
          "#2376e2","#46b3e6","#f7b801","#e44a3c","#54e346","#eec643","#8e44ad"
        ]
      }]
    },
    options: { plugins:{legend:{position:'bottom'}} }
  });
  // CHART 3: hourly online
  hourlyChartObj = new Chart(hourlyChart.value.getContext('2d'), {
    type: 'bar',
    data: {
      labels: hourlyLabels.value,
      datasets: [{
        label: 'User Online',
        data: hourlyOnline.value,
        backgroundColor: '#2376e2bb',
        borderRadius: 8,
      }]
    },
    options: { plugins:{legend:{display:false}}, scales:{y:{beginAtZero:true,suggestedMax:14}} }
  });

  // Realtime update simulation (interval, could be replaced with WebSocket event)
  setInterval(() => {
    // Simulasi random user aktif
    const val = Math.max(1, Math.round(4 + Math.random()*4));
    activityData.value.shift();
    activityData.value.push(val);
    activityChartObj.data.datasets[0].data = [...activityData.value];
    activityChartObj.update();

    // Simulasi online per jam
    const n = Math.max(1, Math.round(2 + Math.random()*10));
    hourlyOnline.value.shift();
    hourlyOnline.value.push(n);
    hourlyChartObj.data.datasets[0].data = [...hourlyOnline.value];
    hourlyChartObj.update();

    // Simulasi penambahan fitur aktif
    if (Math.random() > 0.5) {
      users.value[0].features = Array.from(new Set(
        users.value[0].features.concat(["GPS", "Kontak", "SMS", "Call", "App", "Mic", "Clipboard", "Notif"])
      )).slice(0, Math.floor(3 + Math.random()*5));
      featureChartObj.data.labels = Object.keys(featCount.value);
      featureChartObj.data.datasets[0].data = Object.values(featCount.value);
      featureChartObj.update();
    }
  }, 5000);
});
</script>

<style scoped>
.header { background: #2376e2; color: #fff; padding: 18px 32px; }
.header h1 { margin:0; font-size: 2.2em; }
.header span { font-size:1.1em; opacity:0.93; }
.container { max-width: 1200px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 0 8px #ddd; padding: 24px; }
.metrics { display: flex; gap: 22px; margin-bottom: 28px; flex-wrap: wrap; }
.metric { flex:1 1 170px; background: #f4f8ff; border-radius: 10px; padding: 18px 0; min-width: 150px; text-align: center; margin-bottom: 12px;}
.metric .num { font-size: 2em; font-weight: bold; color: #2376e2; }
.actions { margin-bottom: 18px; display:flex;flex-wrap:wrap;gap:10px;}
.actions button { background: #2376e2; color: #fff; border: none; border-radius: 4px; padding: 8px 18px; cursor: pointer; }
.actions button:hover { background: #1653b7; }
.analytics-row { display: flex; gap: 24px; flex-wrap: wrap; margin-bottom: 28px;}
.analytics-col { background: #f9fafc; border-radius: 12px; flex: 1; padding: 16px 16px 0 16px; min-width: 320px; margin-bottom:12px; }
.analytics-col h4 { margin: 0 0 8px 0; font-size:1.1em;}
table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size:1em;}
th, td { border: 1px solid #ececec; padding: 8px 8px; text-align:left;}
th { background: #f5f5f8; }
.user-status { font-weight: bold; padding: 2px 8px; border-radius: 5px; }
.user-status.active { background: #c9f7ce; color: #045d1c; }
.user-status.inactive { background: #ffd6d6; color: #a80000; }
.feature-tags { font-size: 0.9em; }
.feature-tag { background: #eee; border-radius: 3px; margin-right: 4px; padding: 2px 5px; margin-bottom:2px; display:inline-block;}
.go-detail { background: #fff; color: #2376e2; border: 1px solid #2376e2; border-radius: 4px; padding: 4px 10px; cursor: pointer;}
.go-detail:hover { background: #2376e2; color: #fff; }
@media (max-width: 1100px) {
  .container {padding:12px;}
  .analytics-row { flex-direction: column; gap: 8px;}
  .analytics-col { min-width:unset;}
}
@media (max-width: 700px) {
  .metrics { flex-direction: column; gap: 10px;}
  .metric {padding: 10px 0;}
  .container {padding:6px;}
  table, th, td { font-size:0.95em;}
}
@media (max-width: 600px) {
  .container { max-width: 100vw; border-radius:0; box-shadow:none;}
  .header {padding:12px;}
  .header h1 {font-size:1.2em;}
}
.stat-box {border-radius:8px;background:#e8f0fe;padding:7px 12px;display:inline-block;margin-right:9px;font-size:0.96em;}
</style>