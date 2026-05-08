const fs = require('fs');
const path = require('path');

module.exports = (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const file = req.query.file;
  if (!file) return res.status(400).json({ error: 'Missing ?file=' });

  const safe = String(file).replace(/[^a-zA-Z0-9_\-]/g, '');
  if (!safe) return res.status(400).json({ error: 'Invalid file name' });

  const exts = ['.lua', '.txt', ''];
  for (const ext of exts) {
    const fp = path.join(process.cwd(), safe + ext);
    if (fs.existsSync(fp)) {
      res.setHeader('Content-Type', 'text/plain; charset=utf-8');
      res.setHeader('Cache-Control', 'no-cache');
      return res.status(200).send(fs.readFileSync(fp, 'utf8'));
    }
  }
  return res.status(404).json({ error: 'Not found', file: safe });
};
