<template>
  <div v-if="notif" class="notif-bar">{{notif.msg}}</div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useWebSocket } from '@/composables/useWebSocket'
const { data } = useWebSocket("ws://d.seoikrom.com:9001")
const notif = ref(null)
onMounted(() => {
  watch(data, d => { if(d?.type==="notification") { notif.value = d; setTimeout(()=>notif.value=null, 5000) } })
})
</script>
<style scoped>
.notif-bar {
  position:fixed; top:0; left:0; right:0; z-index:999;
  background:#2376e2; color:#fff; padding:12px 0; text-align:center; font-size:1.1em; box-shadow:0 2px 8px #0002;
}
</style>