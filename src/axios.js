import axios from 'axios'
export default axios.create({
  baseURL: 'https://d.seoikrom.com:9000', // pakai https jika sudah SSL
  headers: { 'Content-Type': 'application/json' }
})