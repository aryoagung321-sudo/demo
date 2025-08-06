const express = require('express'), multer = require('multer'), fs = require('fs'), path = require('path')
const app = express()
const upload = multer({ dest: path.join(__dirname, 'uploads') })
app.get('/api/files', (req, res) =>
  res.json(fs.readdirSync(path.join(__dirname, 'uploads')).map(f => ({ name:f }))))
app.post('/api/upload', upload.single('file'), (req, res) => res.json({ ok:true, file:req.file.filename }))
app.get('/api/download/:name', (req, res) =>
  res.download(path.join(__dirname, 'uploads', req.params.name)))
app.listen(9003, () => console.log('File API on :9003'))