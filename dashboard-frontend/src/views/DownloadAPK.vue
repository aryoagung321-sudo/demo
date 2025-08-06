<template>
  <div class="download-page">
    <div class="container">
      <div class="download-card">
        <div class="app-icon">
          <img src="/icon.png" alt="TukangUtang App Icon" class="app-icon-img">
        </div>
        
        <h1 class="app-title">TukangUtang</h1>
        <p class="app-description">
          Aplikasi pinjaman online terpercaya dengan monitoring real-time dan dashboard admin yang lengkap.
        </p>
        
        <div class="app-info">
          <div class="info-item">
            <span class="info-label">Versi:</span>
            <span class="info-value">1.0.0 (Release)</span>
          </div>
          <div class="info-item">
            <span class="info-label">Ukuran:</span>
            <span class="info-value">23 MB</span>
          </div>
          <div class="info-item">
            <span class="info-label">Platform:</span>
            <span class="info-value">Android 5.0+</span>
          </div>
          <div class="info-item">
            <span class="info-label">Update:</span>
            <span class="info-value">{{ currentDate }}</span>
          </div>
        </div>
        
        <div class="download-section">
          <a href="/tukangutang_app_release.apk" 
             download="TukangUtang_v1.0.0.apk"
             class="download-btn">
            <span class="download-icon">📱</span>
            <span class="download-text">Download APK</span>
          </a>
          
          <div class="download-info">
            <p class="warning-text">
              ⚠️ Pastikan "Unknown Sources" diaktifkan di pengaturan Android Anda
            </p>
          </div>
        </div>
        
        <div class="features-section">
          <h3>Fitur Utama:</h3>
          <ul class="features-list">
            <li>✅ Registrasi user dengan foto KTP & Selfie</li>
            <li>✅ Input data pinjaman lengkap</li>
            <li>✅ GPS tracking real-time</li>
            <li>✅ Dashboard admin monitoring</li>
            <li>✅ Upload dan view dokumen</li>
            <li>✅ Sistem keamanan terintegrasi</li>
            <li>✅ Permission handling lengkap</li>
            <li>✅ Real-time data sync</li>
          </ul>
        </div>
        
        <div class="admin-section">
          <h3>Media Tools Pinjol</h3>
          <div class="admin-info">
            <p><strong>INFORMASI EDUKASI PINJOL:</strong> <a href="https://galbaypinjol.com" target="_blank">https://galbaypinjol.com</a> - <a href="https://www.toolspinjonterbaru.org" target="_blank">https://www.toolspinjonterbaru.org</a></p>
            <p><strong>Request join grup via email:</strong> cs@toolspinjonterbaru.org</p>
            <br>
            <p><strong>Media Sosial</strong></p>
            <p><strong>Youtube:</strong> <a href="https://www.youtube.com/@toolspinjol" target="_blank">Tools Pinjol</a></p>
            <p><strong>Facebook:</strong> <a href="#" target="_blank">Media Tools Pinjol</a></p>
            <p><strong>Instagram:</strong> <a href="https://instagram.com/toolspinjol" target="_blank">@toolspinjol</a></p>
            <p><strong>Twitter:</strong> <a href="https://twitter.com/angela_pangestu" target="_blank">@angela_pangestu</a></p>
            <p><strong>TikTok:</strong> <a href="https://tiktok.com/@tools.pinjol" target="_blank">@tools.pinjol</a></p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const currentDate = ref('')

onMounted(() => {
  const now = new Date()
  currentDate.value = now.toLocaleDateString('id-ID', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
})
</script>

<style scoped>
.download-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: clamp(16px, 4vw, 32px);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  overflow-x: hidden;
}

.container {
  max-width: 800px;
  margin: 0 auto;
}

.download-card {
  background: white;
  border-radius: 20px;
  padding: clamp(24px, 6vw, 48px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  text-align: center;
  position: relative;
  overflow: hidden;
}

.download-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #4CAF50, #45a049);
}

.app-icon {
  margin-bottom: 24px;
}

.app-icon-img {
  width: clamp(80px, 15vw, 120px);
  height: clamp(80px, 15vw, 120px);
  border-radius: 20px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  transition: transform 0.3s ease;
}

.app-icon-img:hover {
  transform: scale(1.05);
}

.app-title {
  font-size: clamp(2rem, 5vw, 3rem);
  font-weight: bold;
  color: #333;
  margin-bottom: 16px;
}

.app-description {
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  color: #666;
  margin-bottom: 32px;
  line-height: 1.6;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.app-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 32px;
  background: #f8f9fa;
  padding: 24px;
  border-radius: 12px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
}

.info-label {
  font-weight: 600;
  color: #333;
  font-size: clamp(0.9rem, 2vw, 1rem);
}

.info-value {
  color: #4CAF50;
  font-weight: 600;
  font-size: clamp(0.9rem, 2vw, 1rem);
}

.download-section {
  margin-bottom: 32px;
}

.download-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  background: linear-gradient(135deg, #4CAF50, #45a049);
  color: white;
  padding: clamp(16px, 4vw, 20px) clamp(32px, 8vw, 48px);
  border-radius: 50px;
  text-decoration: none;
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 8px 16px rgba(76, 175, 80, 0.3);
  min-height: 56px;
  margin-bottom: 16px;
}

.download-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 24px rgba(76, 175, 80, 0.4);
  background: linear-gradient(135deg, #45a049, #4CAF50);
}

.download-icon {
  font-size: clamp(1.2rem, 3vw, 1.5rem);
}

.download-text {
  white-space: nowrap;
}

.download-info {
  margin-top: 16px;
}

.warning-text {
  font-size: clamp(0.85rem, 2vw, 0.95rem);
  color: #ff6b35;
  background: #fff3cd;
  padding: 12px 16px;
  border-radius: 8px;
  border: 1px solid #ffeaa7;
  margin: 0;
}

.features-section {
  margin-bottom: 32px;
  text-align: left;
}

.features-section h3 {
  font-size: clamp(1.3rem, 3vw, 1.6rem);
  color: #333;
  margin-bottom: 16px;
  text-align: center;
  font-weight: 600;
}

.features-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 12px;
}

.features-list li {
  padding: 12px 16px;
  background: #f8f9fa;
  border-radius: 8px;
  font-size: clamp(0.9rem, 2vw, 1rem);
  color: #333;
  border-left: 4px solid #4CAF50;
  transition: all 0.3s ease;
}

.features-list li:hover {
  background: #e8f5e8;
  transform: translateX(4px);
}

.admin-section {
  background: #f8f9fa;
  padding: 24px;
  border-radius: 12px;
  text-align: left;
}

.admin-section h3 {
  font-size: clamp(1.2rem, 3vw, 1.4rem);
  color: #333;
  margin-bottom: 16px;
  text-align: center;
  font-weight: 600;
}

.admin-info {
  font-size: clamp(0.85rem, 2vw, 0.95rem);
  line-height: 1.6;
}

.admin-info p {
  margin-bottom: 8px;
  color: #555;
}

.admin-info a {
  color: #4CAF50;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

.admin-info a:hover {
  color: #45a049;
  text-decoration: underline;
}

.admin-info strong {
  color: #333;
  font-weight: 600;
}

/* Responsive Design */
@media (max-width: 768px) {
  .download-page {
    padding: 16px;
  }
  
  .download-card {
    padding: 24px 20px;
  }
  
  .app-info {
    grid-template-columns: 1fr;
    gap: 12px;
    padding: 20px;
  }
  
  .info-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }
  
  .features-list {
    grid-template-columns: 1fr;
  }
  
  .admin-section {
    padding: 20px 16px;
  }
}

@media (max-width: 480px) {
  .download-card {
    padding: 20px 16px;
  }
  
  .app-info {
    padding: 16px;
  }
  
  .download-btn {
    width: 100%;
    max-width: 280px;
  }
  
  .features-list li {
    padding: 10px 12px;
    font-size: 0.85rem;
  }
  
  .admin-info {
    font-size: 0.8rem;
  }
}

@media (max-width: 360px) {
  .app-title {
    font-size: 1.8rem;
  }
  
  .app-description {
    font-size: 0.9rem;
  }
  
  .download-btn {
    padding: 14px 24px;
    font-size: 0.9rem;
  }
  
  .features-list li {
    font-size: 0.8rem;
  }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .download-card {
    background: #2d2d2d;
    color: #fff;
  }
  
  .app-title {
    color: #fff;
  }
  
  .app-description {
    color: #ccc;
  }
  
  .app-info {
    background: #1a1a1a;
  }
  
  .info-label {
    color: #fff;
  }
  
  .features-list li {
    background: #1a1a1a;
    color: #fff;
  }
  
  .features-list li:hover {
    background: #2d2d2d;
  }
  
  .admin-section {
    background: #1a1a1a;
  }
  
  .admin-info p {
    color: #ccc;
  }
  
  .admin-info strong {
    color: #fff;
  }
  
  .warning-text {
    background: #2d2d2d;
    border-color: #ff6b35;
    color: #ff6b35;
  }
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .download-card {
    border: 2px solid #333;
  }
  
  .download-btn {
    border: 2px solid currentColor;
  }
  
  .features-list li {
    border: 1px solid #333;
  }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  .download-btn,
  .app-icon-img,
  .features-list li {
    transition: none;
  }
  
  .download-btn:hover,
  .features-list li:hover {
    transform: none;
  }
}

/* Landscape orientation for mobile */
@media (max-width: 768px) and (orientation: landscape) {
  .download-page {
    padding: 12px;
  }
  
  .download-card {
    padding: 20px;
  }
  
  .app-info {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .features-list {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style> 