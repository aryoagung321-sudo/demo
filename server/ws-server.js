const http = require('http')
const WebSocket = require('ws')
const server = http.createServer()
const wss = new WebSocket.Server({ server })

wss.on('connection', ws => {
  console.log('New client connected')
  ws.send(JSON.stringify({ type: "greeting", msg: "Welcome to WebSocket Admin Dashboard!" }))

  // Simulasi broadcast data realtime setiap 5 detik
  const interval = setInterval(() => {
    ws.send(JSON.stringify({ type: "stats", online: Math.floor(Math.random()*10)+1, timestamp: new Date().toISOString() }))
  }, 5000)

  ws.on('message', message => {
    console.log('received: %s', message)
    // Handle pesan dari client (misal: permintaan data tertentu, dsb)
  })

  ws.on('close', () => clearInterval(interval))
})

server.listen(9001, () => console.log('WebSocket server started on :9001'))