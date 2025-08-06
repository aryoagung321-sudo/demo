<template>
  <div class="landing-page">
    <div class="hero-section">
      <div class="container">
        <div class="hero-content">
          <div class="app-icon">
            <img src="/icon.png" alt="Pinjol App Icon" class="hero-icon">
          </div>
          
          <h1 class="hero-title">APP PINJOL</h1>
          <p class="hero-subtitle">
            Aplikasi pinjaman online dengan monitoring real-time dan dashboard admin yang lengkap, PLATFORM INI DI BUAT HANYA UNTUK EDUKASI, BUKAN LAYANAN PINJAMAN ONLINE, APK YANG DI BANGUN INI BERTUJUAN UNTUK MEMBERIKAN EDUKASI, DAN PENGEMBANGAN APK. platform ini kembangkan oleh Tools Pinjol - Bang abay
          </p>
          
          <div class="cta-buttons">
            <router-link to="/download" class="cta-btn primary">
              📱 Download APK
            </router-link>
            <a href="https://www.youtube.com/@toolspinjol" target="_blank" class="cta-btn secondary">
              🎥 PLAY VIDEO YOUTUBE TOOLS PINJOL
            </a>
            <a href="https://form.galbaypinjol.com/form/order_product" target="_blank" class="cta-btn secondary">
              👥 JOIN GRUP
            </a>
          </div>
        </div>
      </div>
    </div>
    
    <div class="features-section">
      <div class="container">
        <h2 class="section-title">Fitur Utama</h2>
        <div class="features-grid">
          <div class="feature-card">
            <div class="feature-icon">📝</div>
            <h3>Registrasi User</h3>
            <p>Form registrasi lengkap dengan upload foto KTP dan Selfie</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">💰</div>
            <h3>Manajemen Pinjaman</h3>
            <p>Input dan monitoring data pinjaman dengan detail lengkap</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">📍</div>
            <h3>GPS Tracking</h3>
            <p>Monitoring lokasi real-time dengan peta interaktif</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">📊</div>
            <h3>Dashboard Admin</h3>
            <p>Panel admin untuk monitoring dan manajemen user</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">🔒</div>
            <h3>Keamanan</h3>
            <p>Sistem keamanan terintegrasi dengan autentikasi</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">📱</div>
            <h3>Mobile App</h3>
            <p>Aplikasi mobile yang responsif dan mudah digunakan</p>
          </div>
        </div>
      </div>
    </div>
    
    <div class="download-section">
      <div class="container">
        <div class="download-content">
          <h2>Siap untuk Memulai?</h2>
          <p>Download aplikasi sekarang dan nikmati fitur-fitur lengkap, APLIKASI INI UNTUK EDUKASI DAN PENGEMBANGAN OLEH, TOOLS PINJOL</p>
          <router-link to="/download" class="download-btn">
            📱 Download APK Sekarang
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// No additional logic needed
</script>

<style scoped>
.landing-page {
  min-height: 100vh;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  overflow-x: hidden;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 60px 0;
  color: white;
  text-align: center;
  position: relative;
}

.hero-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  position: relative;
  z-index: 1;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero-icon {
  width: 80px;
  height: 80px;
  border-radius: 16px;
  margin-bottom: 24px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
  transition: transform 0.3s ease;
}

.hero-icon:hover {
  transform: scale(1.05);
}

.hero-title {
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: bold;
  margin-bottom: 16px;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.3rem);
  margin-bottom: 32px;
  opacity: 0.95;
  line-height: 1.6;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.cta-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 32px;
}

.cta-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 14px 28px;
  border-radius: 50px;
  text-decoration: none;
  font-size: clamp(0.9rem, 2vw, 1.1rem);
  font-weight: 600;
  transition: all 0.3s ease;
  min-height: 48px;
  white-space: nowrap;
}

.cta-btn.primary {
  background: #4CAF50;
  color: white;
  box-shadow: 0 6px 12px rgba(76, 175, 80, 0.3);
}

.cta-btn.primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(76, 175, 80, 0.4);
  background: #45a049;
}

.cta-btn.secondary {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
}

.cta-btn.secondary:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-2px);
  border-color: rgba(255, 255, 255, 0.5);
}

.features-section {
  padding: 60px 0;
  background: #f8f9fa;
  position: relative;
}

.section-title {
  text-align: center;
  font-size: clamp(1.8rem, 4vw, 2.5rem);
  color: #333;
  margin-bottom: 48px;
  font-weight: 700;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
  max-width: 1200px;
  margin: 0 auto;
}

.feature-card {
  background: white;
  padding: 32px 24px;
  border-radius: 16px;
  text-align: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  border: 1px solid rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
}

.feature-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #4CAF50, #45a049);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.feature-card:hover::before {
  transform: scaleX(1);
}

.feature-icon {
  font-size: clamp(2rem, 4vw, 3rem);
  margin-bottom: 16px;
  display: block;
}

.feature-card h3 {
  font-size: clamp(1.2rem, 2.5vw, 1.5rem);
  color: #333;
  margin-bottom: 12px;
  font-weight: 600;
}

.feature-card p {
  color: #666;
  line-height: 1.6;
  font-size: clamp(0.9rem, 2vw, 1rem);
}

.download-section {
  background: linear-gradient(135deg, #4CAF50, #45a049);
  padding: 60px 0;
  text-align: center;
  color: white;
  position: relative;
}

.download-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
  pointer-events: none;
}

.download-content {
  position: relative;
  z-index: 1;
}

.download-content h2 {
  font-size: clamp(1.8rem, 4vw, 2.5rem);
  margin-bottom: 16px;
  font-weight: 700;
}

.download-content p {
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  margin-bottom: 32px;
  opacity: 0.95;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.6;
}

.download-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: white;
  color: #4CAF50;
  padding: 16px 32px;
  border-radius: 50px;
  text-decoration: none;
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  min-height: 52px;
}

.download-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
  background: #f8f9fa;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .container {
    padding: 0 24px;
  }
}

@media (max-width: 768px) {
  .hero-section {
    padding: 40px 0;
  }
  
  .hero-content {
    padding: 0 16px;
  }
  
  .cta-buttons {
    flex-direction: column;
    align-items: center;
    gap: 12px;
  }
  
  .cta-btn {
    width: 100%;
    max-width: 280px;
    min-height: 44px;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
    gap: 20px;
    padding: 0 16px;
  }
  
  .feature-card {
    padding: 24px 20px;
  }
  
  .features-section {
    padding: 40px 0;
  }
  
  .download-section {
    padding: 40px 0;
  }
}

@media (max-width: 480px) {
  .hero-section {
    padding: 32px 0;
  }
  
  .hero-icon {
    width: 64px;
    height: 64px;
    border-radius: 12px;
  }
  
  .cta-btn {
    padding: 12px 24px;
    font-size: 0.9rem;
  }
  
  .feature-card {
    padding: 20px 16px;
  }
  
  .features-section {
    padding: 32px 0;
  }
  
  .download-section {
    padding: 32px 0;
  }
}

@media (max-width: 360px) {
  .hero-title {
    font-size: 1.8rem;
  }
  
  .hero-subtitle {
    font-size: 0.9rem;
  }
  
  .cta-btn {
    padding: 10px 20px;
    font-size: 0.85rem;
  }
  
  .feature-card h3 {
    font-size: 1.1rem;
  }
  
  .feature-card p {
    font-size: 0.85rem;
  }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .features-section {
    background: #1a1a1a;
  }
  
  .feature-card {
    background: #2d2d2d;
    border-color: rgba(255, 255, 255, 0.1);
  }
  
  .feature-card h3 {
    color: #fff;
  }
  
  .feature-card p {
    color: #ccc;
  }
  
  .section-title {
    color: #fff;
  }
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .cta-btn {
    border: 2px solid currentColor;
  }
  
  .feature-card {
    border: 2px solid #333;
  }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  .cta-btn,
  .feature-card,
  .download-btn,
  .hero-icon {
    transition: none;
  }
  
  .cta-btn:hover,
  .feature-card:hover,
  .download-btn:hover {
    transform: none;
  }
}

/* Landscape orientation for mobile */
@media (max-width: 768px) and (orientation: landscape) {
  .hero-section {
    padding: 24px 0;
  }
  
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .cta-buttons {
    flex-direction: row;
    flex-wrap: wrap;
  }
  
  .cta-btn {
    width: auto;
    min-width: 200px;
  }
}
</style> 