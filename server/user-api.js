const express = require('express')
const app = express()
app.use(express.json())

let users = [{ id: 1, name: 'Budi', phone: '0812xxx', status: 'active' }]
let idCounter = 2

app.get('/api/users', (req, res) => res.json(users))
app.post('/api/users', (req, res) => {
  const user = { id: idCounter++, ...req.body }
  users.push(user)
  res.json(user)
})
app.put('/api/users/:id', (req, res) => {
  const i = users.findIndex(u => u.id == req.params.id)
  if (i >= 0) users[i] = { ...users[i], ...req.body }
  res.json(users[i])
})
app.delete('/api/users/:id', (req, res) => {
  users = users.filter(u => u.id != req.params.id)
  res.json({ ok: true })
})
app.listen(9002, () => console.log('User API on :9002'))