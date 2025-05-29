const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'SNAjs556', // şifre doğruysa sorun yok
  database: 'tasktracker'
});

db.connect((err) => {
  if (err) {
    console.error('❌ MySQL bağlantı hatası:', err);
  } else {
    console.log('✅ MySQL bağlantısı başarılı');
  }
});

// 🔹 Tüm görevleri getir
app.get('/tasks', (req, res) => {
  db.query('SELECT * FROM tasks', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// 🔹 Yeni görev ekle
app.post('/tasks', (req, res) => {
  const { title, description, isCompleted } = req.body;
  console.log('📥 Yeni görev:', req.body);

  db.query(
    'INSERT INTO tasks (title, description, is_completed) VALUES (?, ?, ?)',
    [title, description, isCompleted],
    (err, result) => {
      if (err) {
        console.error('❌ Ekleme hatası:', err);
        return res.status(500).json({ error: err });
      }
      res.status(201).json({ id: result.insertId, title, description, isCompleted });
    }
  );
});

// 🔹 Görev güncelle
app.put('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const { title, description, isCompleted } = req.body;
  console.log(`🔄 Görev güncelleniyor (id: ${id})`, req.body);

  db.query(
    'UPDATE tasks SET title = ?, description = ?, is_completed = ? WHERE id = ?',
    [title, description, isCompleted, id],
    (err) => {
      if (err) {
        console.error('❌ Güncelleme hatası:', err);
        return res.status(500).json({ error: err });
      }
      res.json({ message: 'Görev güncellendi' });
    }
  );
});

// 🔹 Görev sil
app.delete('/tasks/:id', (req, res) => {
  const { id } = req.params;
  console.log(`🗑 Görev siliniyor (id: ${id})`);

  db.query('DELETE FROM tasks WHERE id = ?', [id], (err) => {
    if (err) {
      console.error('❌ Silme hatası:', err);
      return res.status(500).json({ error: err });
    }
    res.json({ message: 'Görev silindi' });
  });
});

// 🔹 Sunucuyu başlat
const PORT = 3006;
app.listen(PORT, () => {
  console.log(`🚀 Sunucu ${PORT} portunda çalışıyor`);
});
