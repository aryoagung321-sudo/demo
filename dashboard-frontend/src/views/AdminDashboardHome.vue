<template>
  <DashboardLayout>
    <div class="container">
      <div class="header">
        <h1>Dashboard Admin</h1>
        <span>Monitoring & Analytics</span>
      </div>

      <!-- Metrics -->
      <div class="metrics">
        <div class="metric">
          <div class="num">{{ userStats.total }}</div>
          <div>Total Users</div>
        </div>
        <div class="metric">
          <div class="num">{{ userStats.active }}</div>
          <div>Active</div>
        </div>
        <div class="metric">
          <div class="num">{{ userStats.inactive }}</div>
          <div>Inactive</div>
        </div>
        <div class="metric">
          <div class="num">{{ userStats.pending }}</div>
          <div>Pending</div>
        </div>
        <div class="metric">
          <div class="num">{{ userStats.overdue }}</div>
          <div>Overdue</div>
        </div>
      </div>

      <!-- Search Bar -->
      <div class="search-container">
        <div class="search-box">
          <input
            v-model="searchQuery"
            @input="filterUsers"
            type="text"
            placeholder="Search by name, phone, IMEI, or email..."
            class="search-input"
          />
          <button v-if="searchQuery" @click="clearSearch" class="clear-btn">×</button>
        </div>
        <div v-if="searchQuery" class="search-stats">
          Showing {{ filteredUsers.length }} of {{ users.length }} users
        </div>
      </div>

      <!-- Analytics -->
      <div class="analytics-row">
        <div class="analytics-col">
          <h4>User Activity (7 Days)</h4>
          <canvas ref="activityChart" width="400" height="200"></canvas>
        </div>
        <div class="analytics-col">
          <h4>User Status Distribution</h4>
          <canvas ref="featureChart" width="400" height="200"></canvas>
        </div>
        <div class="analytics-col">
          <h4>Hourly Online Users</h4>
          <canvas ref="hourlyChart" width="400" height="200"></canvas>
        </div>
      </div>

      <!-- User Table -->
      <div class="user-table-container">
        <h4>User List</h4>
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Phone</th>
              <th>IMEI</th>
              <th>Email</th>
              <th>Status</th>
              <th>Features</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in filteredUsers" :key="user.phone">
              <td>{{ user.name }}</td>
              <td>{{ user.phone }}</td>
              <td>{{ user.imei }}</td>
              <td>{{ user.email }}</td>
              <td>
                <span :class="['user-status', user.status]">
                  {{ user.status === 'active' ? 'Active' : 'Inactive' }}
                </span>
              </td>
              <td class="feature-tags">
                <span v-for="feature in user.features" :key="feature" class="feature-tag">
                  {{ feature }}
                </span>
              </td>
              <td>
                <button @click="goToDetail(user)" class="go-detail">Detail</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import DashboardLayout from '@/components/DashboardLayout.vue'
import Chart from 'chart.js/auto'
import api from '@/utils/api'

const router = useRouter()

// Reactive data
const users = ref([])
const filteredUsers = ref([])
const searchQuery = ref('')
const userStats = ref({
  total: 0,
  active: 0,
  inactive: 0,
  pending: 0,
  overdue: 0
})

// Chart references
const activityChart = ref(null)
const featureChart = ref(null)
const hourlyChart = ref(null)

// Chart objects
let activityChartObj = null
let featureChartObj = null
let hourlyChartObj = null

// Chart data
const activityLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
const activityData = ref([5, 7, 3, 8, 6, 9, 4])
const hourlyLabels = ref(['00', '04', '08', '12', '16', '20'])
const hourlyOnline = ref([2, 1, 3, 8, 6, 4])

// Computed
const featCount = ref({})

// Methods
const goToDetail = (user) => {
  localStorage.setItem('selectedUser', JSON.stringify(user))
  router.push(`/users/${user.phone}`)
}

const loadUsers = async () => {
  try {
    const response = await api.get('/users')
    users.value = response.data
    filteredUsers.value = users.value
    updateUserStats()
  } catch (error) {
    console.error('Error loading users:', error)
    // Fallback data
    users.value = [
      {
        name: 'Budi Santoso',
        phone: '0812xxxx111',
        email: 'budi@example.com',
        imei: '123456789012345',
        status: 'active',
        features: ['GPS', 'Kontak', 'SMS', 'Call', 'App', 'Mic', 'Clipboard']
      },
      {
        name: 'Siti Nurhaliza',
        phone: '0813xxxx222',
        email: 'siti@example.com',
        imei: '234567890123456',
        status: 'active',
        features: ['GPS', 'Kontak', 'SMS', 'Call']
      },
      {
        name: 'Ahmad Rizki',
        phone: '0814xxxx333',
        email: 'ahmad@example.com',
        imei: '345678901234567',
        status: 'inactive',
        features: ['GPS', 'Kontak']
      }
    ]
    filteredUsers.value = users.value
    updateUserStats()
  }
}

const loadUserStats = async () => {
  try {
    const response = await api.get('/user-stats')
    userStats.value = response.data
  } catch (error) {
    console.error('Error loading user stats:', error)
    // Fallback stats
    userStats.value = {
      total: users.value.length,
      active: users.value.filter(u => u.status === 'active').length,
      inactive: users.value.filter(u => u.status === 'inactive').length,
      pending: 2,
      overdue: 1
    }
  }
}

const updateUserStats = () => {
  userStats.value = {
    total: users.value.length,
    active: users.value.filter(u => u.status === 'active').length,
    inactive: users.value.filter(u => u.status === 'inactive').length,
    pending: 2,
    overdue: 1
  }
}

const filterUsers = () => {
  const query = searchQuery.value.toLowerCase()
  filteredUsers.value = users.value.filter(user =>
    user.name.toLowerCase().includes(query) ||
    user.phone.toLowerCase().includes(query) ||
    user.imei.toLowerCase().includes(query) ||
    user.email.toLowerCase().includes(query)
  )
}

const clearSearch = () => {
  searchQuery.value = ''
  filteredUsers.value = users.value
}

// Initialize charts and data
onMounted(async () => {
  await nextTick()
  
  // Load initial data
  await loadUsers()
  await loadUserStats()
  
  // Initialize charts
  if (activityChart.value) {
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
      options: { 
        plugins: { legend: { display: false } }, 
        scales: { y: { beginAtZero: true, suggestedMax: 10 } } 
      }
    })
  }
  
  if (featureChart.value) {
    featureChartObj = new Chart(featureChart.value.getContext('2d'), {
      type: 'pie',
      data: {
        labels: ['Aktif', 'Inactive', 'Pending', 'Overdue'],
        datasets: [{
          data: [userStats.value.active, userStats.value.inactive, userStats.value.pending, userStats.value.overdue],
          backgroundColor: [
            "#28a745", "#6c757d", "#ffc107", "#dc3545"
          ]
        }]
      },
      options: { plugins: { legend: { position: 'bottom' } } }
    })
  }
  
  if (hourlyChart.value) {
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
      options: { 
        plugins: { legend: { display: false } }, 
        scales: { y: { beginAtZero: true, suggestedMax: 14 } } 
      }
    })
  }

  // Real-time updates
  setInterval(() => {
    // Update activity data
    const val = Math.max(1, Math.round(4 + Math.random() * 4))
    activityData.value.shift()
    activityData.value.push(val)
    if (activityChartObj) {
      activityChartObj.data.datasets[0].data = [...activityData.value]
      activityChartObj.update()
    }

    // Update hourly data
    const n = Math.max(1, Math.round(2 + Math.random() * 10))
    hourlyOnline.value.shift()
    hourlyOnline.value.push(n)
    if (hourlyChartObj) {
      hourlyChartObj.data.datasets[0].data = [...hourlyOnline.value]
      hourlyChartObj.update()
    }
  }, 5000)
})
</script>

<style scoped>
.header { 
  background: #2376e2; 
  color: #fff; 
  padding: 18px 32px; 
  border-radius: 8px; 
  margin-bottom: 24px; 
}

.header h1 { 
  margin: 0; 
  font-size: 2.2em; 
}

.header span { 
  font-size: 1.1em; 
  opacity: 0.93; 
}

.container { 
  max-width: 1200px; 
  margin: 24px auto; 
  background: #fff; 
  border-radius: 12px; 
  box-shadow: 0 0 8px #ddd; 
  padding: 24px; 
}

.metrics { 
  display: flex; 
  gap: 22px; 
  margin-bottom: 28px; 
  flex-wrap: wrap; 
}

.metric { 
  flex: 1 1 170px; 
  background: #f4f8ff; 
  border-radius: 10px; 
  padding: 18px 0; 
  min-width: 150px; 
  text-align: center; 
  margin-bottom: 12px;
}

.metric .num { 
  font-size: 2em; 
  font-weight: bold; 
  color: #2376e2; 
}

/* Search styles */
.search-container {
  margin-bottom: 20px;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
  max-width: 500px;
}

.search-input {
  width: 100%;
  padding: 12px 40px 12px 16px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #2376e2;
  box-shadow: 0 0 0 3px rgba(35, 118, 226, 0.1);
}

.clear-btn {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  font-size: 18px;
  color: #666;
  cursor: pointer;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-btn:hover {
  color: #333;
}

.search-stats {
  margin-top: 8px;
  font-size: 12px;
  color: #666;
}

.analytics-row { 
  display: flex; 
  gap: 24px; 
  flex-wrap: wrap; 
  margin-bottom: 28px;
}

.analytics-col { 
  background: #f9fafc; 
  border-radius: 12px; 
  flex: 1; 
  padding: 16px 16px 0 16px; 
  min-width: 320px; 
  margin-bottom: 12px; 
}

.analytics-col h4 { 
  margin: 0 0 8px 0; 
  font-size: 1.1em;
}

table { 
  width: 100%; 
  border-collapse: collapse; 
  margin-top: 10px; 
  font-size: 1em;
}

th, td { 
  border: 1px solid #ececec; 
  padding: 8px 8px; 
  text-align: left;
}

th { 
  background: #f5f5f8; 
}

.user-status { 
  font-weight: bold; 
  padding: 2px 8px; 
  border-radius: 5px; 
}

.user-status.active { 
  background: #c9f7ce; 
  color: #045d1c; 
}

.user-status.inactive { 
  background: #ffd6d6; 
  color: #a80000; 
}

.feature-tags { 
  font-size: 0.9em; 
}

.feature-tag { 
  background: #eee; 
  border-radius: 3px; 
  margin-right: 4px; 
  padding: 2px 5px; 
  margin-bottom: 2px; 
  display: inline-block;
}

.go-detail { 
  background: #fff; 
  color: #2376e2; 
  border: 1px solid #2376e2; 
  border-radius: 4px; 
  padding: 4px 10px; 
  cursor: pointer;
}

.go-detail:hover { 
  background: #2376e2; 
  color: #fff; 
}

@media (max-width: 1100px) {
  .container {
    padding: 12px;
  }
  
  .analytics-row { 
    flex-direction: column; 
    gap: 8px;
  }
  
  .analytics-col { 
    min-width: unset;
  }
}

@media (max-width: 700px) {
  .metrics { 
    flex-direction: column; 
    gap: 10px;
  }
  
  .metric {
    padding: 10px 0;
  }
  
  .container {
    padding: 6px;
  }
}
</style>