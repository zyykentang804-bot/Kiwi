// api/raw.js
// Vercel Serverless Function
// Route: /api/raw?file=NAMA_SCRIPT
// 
// Cara kerja:
// - Baca file dari folder /scripts/ di repo
// - Return isi file sebagai plain text
// - File disimpan di repo GitHub (otomatis via push/upload)

import fs from 'fs';
import path from 'path';

export default function handler(req, res) {
  // CORS header — izinkan semua origin
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { file } = req.query;

  if (!file) {
    return res.status(400).json({
      error: 'Missing ?file= parameter',
      usage: '/api/raw?file=NAMA_SCRIPT',
      example: '/api/raw?file=AUTO_MS'
    });
  }

  // Sanitize: hanya huruf besar, angka, underscore, strip path traversal
  const safeName = file
    .replace(/[^a-zA-Z0-9_\-]/g, '')
    .replace(/\.\./g, '');

  if (!safeName) {
    return res.status(400).json({ error: 'Invalid file name' });
  }

  // Cari file di folder /scripts/ (coba .lua dulu, lalu .txt, lalu tanpa ekstensi)
  const scriptsDir = path.join(process.cwd(), 'scripts');
  const extensions = ['.lua', '.txt', ''];

  let filePath = null;
  let content = null;

  for (const ext of extensions) {
    const tryPath = path.join(scriptsDir, safeName + ext);
    if (fs.existsSync(tryPath)) {
      filePath = tryPath;
      break;
    }
  }

  if (!filePath) {
    return res.status(404).json({
      error: 'Script not found',
      file: safeName,
      available_at: '/api/list'
    });
  }

  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (err) {
    return res.status(500).json({ error: 'Failed to read file' });
  }

  // Return sebagai plain text agar bisa dipakai loadstring()
  res.setHeader('Content-Type', 'text/plain; charset=utf-8');
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
  return res.status(200).send(content);
}
