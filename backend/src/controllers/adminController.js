const db = require('../models/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Login Admin
exports.loginAdmin = async (req, res) => {
  const { username, password } = req.body;
  const [rows] = await db.query('SELECT * FROM admins WHERE username = ?', [username]);
  if (rows.length === 0) return res.status(401).json({ message: 'User not found' });
  const admin = rows[0];
  const valid = await bcrypt.compare(password, admin.password);
  if (!valid) return res.status(401).json({ message: 'Wrong password' });

  const token = jwt.sign({ id: admin.id, username: admin.username }, process.env.JWT_SECRET, { expiresIn: '1d' });
  res.json({ token });
};

// Middleware JWT auth
exports.authMiddleware = (req, res, next) => {
  const auth = req.headers.authorization;
  if (!auth) return res.status(401).json({ message: 'Token required' });
  try {
    const token = auth.split(' ')[1];
    req.admin = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (e) {
    res.status(401).json({ message: 'Token invalid' });
  }
};

// Approve Loan
exports.approveLoan = async (req, res) => {
  const loanId = req.params.loanId;
  await db.query('UPDATE loans SET status = ? WHERE id = ?', ['approved', loanId]);
  res.json({ success: true, message: 'Loan approved' });
};

// Reject Loan
exports.rejectLoan = async (req, res) => {
  const loanId = req.params.loanId;
  await db.query('UPDATE loans SET status = ? WHERE id = ?', ['rejected', loanId]);
  res.json({ success: true, message: 'Loan rejected' });
};