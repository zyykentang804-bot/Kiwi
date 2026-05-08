export default function handler(req, res) {
  const { file } = req.query;

  if (!file) {
    return res.status(400).send('// Missing file parameter');
  }

  // Sanitize: hanya izinkan huruf, angka, underscore, strip path traversal
  const safe = file.replace(/[^a-zA-Z0-9_]/g, '');
  if (!safe) {
    return res.status(400).send('// Invalid file name');
  }

  const fs = require('fs');
  const path = require('path');
  const filePath = path.join(process.cwd(), 'scripts', safe + '.lua');

  if (!fs.existsSync(filePath)) {
    return res.status(200)
      .setHeader('Content-Type', 'text/plain')
      .send('-- File ini telah terenkripsi atau tidak tersedia secara publik.');
  }

  const content = fs.readFileSync(filePath, 'utf8');

  res.status(200)
    .setHeader('Content-Type', 'text/plain')
    .setHeader('Access-Control-Allow-Origin', '*')
    .send(content);
}
