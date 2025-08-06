<template>
  <div class="login-container">
    <form class="login-card" autocomplete="off" @submit.prevent="onLogin">
      <h2>Login Admin</h2>
      <p>Masuk ke dashboard monitoring perangkat</p>
      <div v-if="error" class="login-error">{{ error }}</div>
      <div class="form-group">
        <label class="form-label" for="username">Username</label>
        <input class="form-input" type="text" v-model="username" id="username" placeholder="admin" required autocomplete="username"/>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input class="form-input" type="password" v-model="password" id="password" placeholder="••••••••" required autocomplete="current-password"/>
      </div>
      <button type="submit" class="login-btn" :disabled="loading">
        <span v-if="loading">Loading...</span>
        <span v-else>Masuk</span>
      </button>
      <div class="login-footer">
        <span class="brand">Device Admin Dashboard</span><br>
        &copy; 2025
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, watchEffect, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth' // Pinia store
import api from '@/utils/api'

const username = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)
const router = useRouter()
const auth = useAuthStore()

// Auto-redirect if already logged in (has token)
onMounted(() => {
  if (auth.isAuthenticated) {
    router.replace('/dashboard')
  }
})

// Also react if session changes (for SPA session changes)
watchEffect(() => {
  if (auth.isAuthenticated) {
    router.replace('/dashboard')
  }
})

async function onLogin() {
  error.value = ''
  loading.value = true
  try {
    // Ganti URL di bawah sesuai endpoint backend Anda
    const res = await api.post('/auth/login', {
      username: username.value,
      password: password.value
    })
    // Asumsi backend mengembalikan {token: "..."}
    if (res.data && res.data.token) {
      // Set session ke Pinia store
      auth.setToken(res.data.token)
      router.push('/dashboard')
    } else {
      error.value = 'Login gagal, data tidak valid.'
    }
  } catch (e) {
    error.value = e.response?.data?.message || 'Username atau password salah!'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
html,body {
  height: 100%; margin: 0; padding: 0;
  font-family: 'Segoe UI', Arial, sans-serif;
  background: linear-gradient(114deg,#2376e2 0%,#6ea8fe 80%);
  min-height:100vh;
}
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 24px #2376e24d, 0 1.5px 4px #0002;
  padding: 38px 32px 28px 32px;
  max-width: 370px;
  width: 100%;
  box-sizing: border-box;
  text-align: center;
  animation: fadein 0.7s;
}
@keyframes fadein {
  from { opacity:0; transform: translateY(40px);}
  to { opacity:1; transform: translateY(0);}
}
.login-card h2 {
  margin-top: 0;
  font-size: 1.6em;
  letter-spacing: 0.5px;
  color: #2376e2;
  margin-bottom: 6px;
}
.login-card p {
  color: #666;
  font-size: 1.05em;
  margin-bottom: 32px;
}
.form-group { margin-bottom: 18px; text-align:left;}
.form-label { font-size:1em; color: #2376e2; font-weight:500; display:block; margin-bottom:6px;}
.form-input {
  width: 100%; padding: 10px 12px; border-radius: 6px; border: 1px solid #d9e6f6;
  font-size: 1em; transition: border .2s; box-sizing: border-box;
  background: #f8fbff;
}
.form-input:focus { border-color: #2376e2; outline: none; background: #fff; }
.login-btn {
  width: 100%; background: linear-gradient(90deg,#2376e2 60%,#46b3e6 100%);
  color: #fff; border: none; border-radius: 7px; padding: 11px 0;
  font-size: 1.1em; font-weight:600; cursor: pointer; margin-top: 6px;
  box-shadow: 0 2px 8px #2376e22c;
  transition: background .2s;
}
.login-btn:disabled { opacity: 0.7; cursor: not-allowed; }
.login-btn:hover:enabled { background: linear-gradient(90deg,#1d5eb3 60%,#46b3e6 100%);}
.login-footer {
  margin-top: 24px; color: #a4a9b2; font-size: 0.98em;
}
.login-footer .brand { color: #2376e2; font-weight: bold;}
.login-error {
  color: #e44a3c; background: #ffe9e9; border-radius: 5px; font-size:0.98em;
  padding: 8px 0; margin-bottom: 12px;
  animation: shake 0.35s;
}
@keyframes shake {
  0% { transform: translateX(0);}
  25% { transform: translateX(-5px);}
  50% { transform: translateX(5px);}
  75% { transform: translateX(-6px);}
  100% { transform: translateX(0);}
}
@media (max-width: 600px) {
  .login-card {
    max-width: 98vw;
    padding: 24px 4vw 18px 4vw;
  }
  .login-card h2 { font-size: 1.22em; }
  .login-card p { font-size:0.98em; }
}
</style>