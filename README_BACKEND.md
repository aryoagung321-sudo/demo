# FastAPI WebSocket Backend: Realtime Update for Admin Dashboard

## Features

- `/ws/{user_id}`: WebSocket endpoint, used by admin dashboard to subscribe to user data (1 tab per user).
- `/device_data/{user_id}`: HTTP POST endpoint, used by Android device (background service) to send data.
- Data is broadcast in realtime (via WebSocket) ke dashboard admin.
- Example accepted JSON:
  - GPS: `{"type": "gps", "lat": -6.2, "lon": 106.82, "time": "...", "address": "..."}`
  - Kontak: `{"type": "contacts", "contacts": [{...}, ...]}`
  - SMS: `{"type": "sms", "sms": {...}}`
  - Call: `{"type": "call", "call": {...}}`
  - (dst, sesuai fitur)

## How to Run

```sh
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

## Integrasi dengan Flutter

- Flutter dashboard: connect ke ws://host:8000/ws/{user_id}
- Android device: POST data ke http://host:8000/device_data/{user_id}
- Data yang dikirim device langsung diteruskan ke dashboard admin secara realtime.

---

## Notes

- Untuk production, sebaiknya gunakan database/queue/Redis untuk menyimpan data sementara.
- Tambahkan authentication/token sesuai kebutuhan security.