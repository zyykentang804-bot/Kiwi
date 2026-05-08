// api/list.js
// Route: /api/list
// Return JSON list semua script yang ada di folder /scripts/

import fs from 'fs';
import path from 'path';

export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');

  const scriptsDir = path.join(process.cwd(), 'scripts');

  if (!fs.existsSync(scriptsDir)) {
    return res.status(200).json({ scripts: [], message: 'No scripts folder found' });
  }

  try {
    const files = fs.readdirSync(scriptsDir);
    const scripts = files
      .filter(f => ['.lua', '.txt'].includes(path.extname(f).toLowerCase()))
      .map(f => {
        const name = path.basename(f, path.extname(f));
        return {
          name: name,
          url: `/api/raw?file=${name}`,
          loadstring: `loadstring(game:HttpGet("https://YOUR_DOMAIN.vercel.app/api/raw?file=${name}"))()`,
          size: fs.statSync(path.join(scriptsDir, f)).size + ' bytes',
          updated: fs.statSync(path.join(scriptsDir, f)).mtime
        };
      });

    return res.status(200).json({ count: scripts.length, scripts });
  } catch (err) {
    return res.status(500).json({ error: 'Failed to read scripts directory' });
  }
}
