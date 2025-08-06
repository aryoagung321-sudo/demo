<template>
  <div>
    <h2>Manajemen User</h2>
    <form @submit.prevent="saveUser">
      <input v-model="form.name" placeholder="Nama" required />
      <input v-model="form.phone" placeholder="No HP" required />
      <select v-model="form.status"><option>active</option><option>inactive</option></select>
      <button type="submit">{{form.id ? 'Update':'Tambah'}}</button>
      <button v-if="form.id" type="button" @click="reset">Batal</button>
    </form>
    <table>
      <tr><th>Nama</th><th>HP</th><th>Status</th><th>Aksi</th></tr>
      <tr v-for="u in users" :key="u.id">
        <td>{{u.name}}</td><td>{{u.phone}}</td><td>{{u.status}}</td>
        <td>
          <button @click="edit(u)">Edit</button>
          <button @click="del(u.id)">Hapus</button>
        </td>
      </tr>
    </table>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const users = ref([])
const form = ref({ id:null, name:'', phone:'', status:'active' })
async function load() { users.value = (await axios.get('/api/users')).data }
onMounted(load)
function edit(u) { form.value = {...u} }
function reset() { form.value = { id:null, name:'', phone:'', status:'active' } }
async function saveUser() {
  if(form.value.id) await axios.put(`/api/users/${form.value.id}`, form.value)
  else await axios.post('/api/users', form.value)
  reset(); load()
}
async function del(id) { await axios.delete(`/api/users/${id}`); load() }
</script>