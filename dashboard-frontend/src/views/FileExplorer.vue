<template>
  <div>
    <h2>File Explorer</h2>
    <form @submit.prevent="upload">
      <input type="file" ref="file" />
      <button type="submit">Upload</button>
    </form>
    <ul>
      <li v-for="f in files" :key="f.name">
        {{f.name}}
        <a :href="`/api/download/${f.name}`" target="_blank">Download</a>
      </li>
    </ul>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const files = ref([])
async function load() { files.value = (await axios.get('/api/files')).data }
onMounted(load)
async function upload(e) {
  const fd = new FormData()
  fd.append('file', e.target.previousElementSibling.files[0])
  await axios.post('/api/upload', fd)
  load()
}
</script>