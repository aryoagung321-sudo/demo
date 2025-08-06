import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('admin_token') || ''
  }),
  getters: {
    isAuthenticated: state => !!state.token
  },
  actions: {
    setToken(token: string) {
      this.token = token
      localStorage.setItem('admin_token', token)
    },
    logout() {
      this.token = ''
      localStorage.removeItem('admin_token')
    }
  }
})