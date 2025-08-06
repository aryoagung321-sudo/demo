import { createRouter, createWebHistory } from 'vue-router'
import AdminLogin from '../views/AdminLogin.vue'
import AdminDashboardHome from '../views/AdminDashboardHome.vue'
import AdminUserDetail from '../views/AdminUserDetail.vue'
import UserManagement from '../views/UserManagement.vue'
import FileExplorer from '../views/FileExplorer.vue'
import DownloadAPK from '../views/DownloadAPK.vue'
import LandingPage from '../views/LandingPage.vue'

const routes = [
  {
    path: '/',
    name: 'Landing',
    component: LandingPage
  },
  {
    path: '/login',
    name: 'Login',
    component: AdminLogin
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: AdminDashboardHome
  },
  {
    path: '/users',
    name: 'UserManagement',
    component: UserManagement
  },
  {
    path: '/users/:phone',
    name: 'UserDetail',
    component: AdminUserDetail
  },
  {
    path: '/files',
    name: 'FileExplorer',
    component: FileExplorer
  },
  {
    path: '/download',
    name: 'DownloadAPK',
    component: DownloadAPK
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router 