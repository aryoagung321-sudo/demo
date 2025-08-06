const { authMiddleware } = require('../controllers/adminController');

router.get('/users', authMiddleware, adminController.listUsers);
router.get('/loans', authMiddleware, adminController.listLoans);
router.post('/loans/:loanId/approve', authMiddleware, adminController.approveLoan);
router.post('/loans/:loanId/reject', authMiddleware, adminController.rejectLoan);