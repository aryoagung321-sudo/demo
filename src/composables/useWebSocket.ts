import { ref, onUnmounted } from 'vue'

export function useWebSocket(url: string) {
  const data = ref<any>(null)
  const connected = ref(false)
  let ws: WebSocket

  function connect() {
    ws = new WebSocket(url)
    ws.onopen = () => { connected.value = true }
    ws.onmessage = (e) => { data.value = JSON.parse(e.data) }
    ws.onclose = () => { connected.value = false }
  }
  connect()
  onUnmounted(() => ws && ws.close())
  return { data, connected }
}