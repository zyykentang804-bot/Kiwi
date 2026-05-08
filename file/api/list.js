const fs = require('fs');
const path = require('path');

module.exports = (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  try {
    const root = process.cwd();
    const scripts = fs.readdirSync(root)
      .filter(f => ['.lua', '.txt'].includes(path.extname(f).toLowerCase()))
      .map(f => ({
        name: path.basename(f, path.extname(f)),
        file: f,
        url: `/api/raw?file=${path.basename(f, path.extname(f))}`
      }));
    return res.status(200).json({ count: scripts.length, scripts });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};
