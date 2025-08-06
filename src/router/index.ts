import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminDashboard from '@/views/AdminDashboardHome.vue'
import AdminLogin from '@/views/AdminLogin.vue'

const routes = [
  { path: '/login', component: AdminLogin },
  { path: '/dashboard', component: AdminDashboard, meta: { requiresAuth: true } },
  // ...route lain
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    next('/login')
  } else if ((to.path === '/login') && auth.isAuthenticated) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router