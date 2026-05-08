const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Folder untuk menyimpan file (jika lingkungan development, gunakan disk)
const filesDir = path.join(__dirname, '../files');
if (!fs.existsSync(filesDir)) fs.mkdirSync(filesDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, filesDir),
  filename: (req, file, cb) => {
    const original = file.originalname;
    cb(null, original);
  }
});
const upload = multer({ storage });

// Endpoint upload file
app.post('/api/upload', upload.single('file'), (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No file uploaded' });
  const rawUrl = `${req.protocol}://${req.get('host')}/api/raw?file=${encodeURIComponent(req.file.filename)}`;
  res.json({ success: true, filename: req.file.filename, rawUrl });
});

// Endpoint mengambil raw file
app.get('/api/raw', (req, res) => {
  const fileName = req.query.file;
  if (!fileName) return res.status(400).send('Missing file parameter');
  const filePath = path.join(filesDir, fileName);
  if (!fs.existsSync(filePath)) return res.status(404).send('File not found');
  const content = fs.readFileSync(filePath, 'utf8');
  res.setHeader('Content-Type', 'text/plain');
  res.send(content);
});

// Endpoint daftar file (opsional)
app.get('/api/list', (req, res) => {
  fs.readdir(filesDir, (err, files) => {
    if (err) return res.status(500).json({ error: 'Cannot read files' });
    const scripts = files.map(file => ({
      name: file,
      url: `${req.protocol}://${req.get('host')}/api/raw?file=${encodeURIComponent(file)}`
    }));
    res.json(scripts);
  });
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
