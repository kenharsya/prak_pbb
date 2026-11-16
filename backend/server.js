// Simple CRUD REST API for Products — pure Node.js, no dependencies.
// Run: node server.js  →  http://localhost:3000/products
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;
const DB_FILE = path.join(__dirname, 'db.json');

// ---------- tiny JSON file "database" ----------
function loadDb() {
  try {
    return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
  } catch (e) {
    const seed = {
      nextId: 6,
      products: [
        { id: 1, title: 'Knalpot Racing Full System', brand: 'Akrapovic', description: 'Knalpot berbahan stainless steel anti karat dengan karakter suara bulat bass.', price: 120.0, thumbnail: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCU447V-JqyWPvznIYi8u1OanMqPNuTqz8PeYmPFRJ9g&s=10', category: 'Knalpot & Performa' },
        { id: 2, title: 'Master Rem Tabung Terpisah', brand: 'Brembo', description: 'Master rem pengereman lebih pakem dan responsif. Cocok untuk penggunaan harian maupun balap.', price: 85.5, thumbnail: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQio1fLCqoLehlH8s10F71zAVMgANf4wd0KYX27lPLzHA&s=10', category: 'Sistem Pengereman' },
        { id: 3, title: 'Shockbreaker Tabung Atas 330mm', brand: 'YSS', description: 'Suspensi empuk dengan fitur setelan preload yang bisa disesuaikan dengan beban berkendara.', price: 95.0, thumbnail: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsZpZLwD3RngAwILcs512AxAH1D3R4L7WZx5V9o9xhlQ&s=10', category: 'Suspensi' },
        { id: 4, title: 'Kaliper Rem 4 Piston', brand: 'RCB', description: 'Kaliper rem berbahan alumunium CNC presisi tinggi untuk daya cengkeram rem maksimal.', price: 65.0, thumbnail: 'https://www.hondacengkareng.com/wp-content/uploads/2018/08/Caliper-Sub-Assy-L-FR-45150KZZ902-600x600.jpg', category: 'Sistem Pengereman' },
        { id: 5, title: 'Velg Racing Palang 5', brand: 'Vrossi', description: 'Velg racing alumunium alloy yang ringan dan kuat. Meningkatkan kestabilan saat manuver.', price: 110.0, thumbnail: 'https://hsrwheel.com/wp-content/uploads/2025/08/BOROKO-TJH-HSR-R16X7-H5X1143-ET42-SANDY-BRONZE-KANAN.jpg', category: 'Kaki-kaki & Roda' },
      ],
    };
    fs.writeFileSync(DB_FILE, JSON.stringify(seed, null, 2));
    return seed;
  }
}
function saveDb(db) {
  fs.writeFileSync(DB_FILE, JSON.stringify(db, null, 2));
}

// ---------- helpers ----------
function sendJson(res, status, data) {
  const body = JSON.stringify(data);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  });
  res.end(body);
}
function readBody(req) {
  return new Promise((resolve, reject) => {
    let raw = '';
    req.on('data', (c) => (raw += c));
    req.on('end', () => {
      try { resolve(raw ? JSON.parse(raw) : {}); }
      catch (e) { reject(new Error('Invalid JSON body')); }
    });
    req.on('error', reject);
  });
}

// ---------- server ----------
const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  const parts = url.pathname.split('/').filter(Boolean); // e.g. ['products', '3']
  const db = loadDb();

  // CORS preflight
  if (req.method === 'OPTIONS') return sendJson(res, 204, {});

  // GET /products  (optional ?q= for search)
  if (req.method === 'GET' && parts[0] === 'products' && parts.length === 1) {
    let list = db.products;
    const q = (url.searchParams.get('q') || '').toLowerCase();
    if (q) {
      list = list.filter((p) =>
        p.title.toLowerCase().includes(q) ||
        p.brand.toLowerCase().includes(q) ||
        p.category.toLowerCase().includes(q));
    }
    return sendJson(res, 200, list);
  }

  // GET /products/:id
  if (req.method === 'GET' && parts[0] === 'products' && parts.length === 2) {
    const item = db.products.find((p) => p.id === Number(parts[1]));
    return item ? sendJson(res, 200, item) : sendJson(res, 404, { message: 'Product not found' });
  }

  // POST /products
  if (req.method === 'POST' && parts[0] === 'products' && parts.length === 1) {
    const body = await readBody(req);
    if (!body.title || !body.brand) {
      return sendJson(res, 400, { message: 'title dan brand wajib diisi' });
    }
    const product = {
      id: db.nextId++,
      title: String(body.title),
      brand: String(body.brand),
      description: String(body.description || ''),
      price: Number(body.price) || 0,
      thumbnail: String(body.thumbnail || ''),
      category: String(body.category || 'Lainnya'),
    };
    db.products.push(product);
    saveDb(db);
    return sendJson(res, 201, product);
  }

  // PUT /products/:id
  if (req.method === 'PUT' && parts[0] === 'products' && parts.length === 2) {
    const idx = db.products.findIndex((p) => p.id === Number(parts[1]));
    if (idx === -1) return sendJson(res, 404, { message: 'Product not found' });
    const body = await readBody(req);
    const old = db.products[idx];
    db.products[idx] = {
      ...old,
      title: body.title !== undefined ? String(body.title) : old.title,
      brand: body.brand !== undefined ? String(body.brand) : old.brand,
      description: body.description !== undefined ? String(body.description) : old.description,
      price: body.price !== undefined ? Number(body.price) : old.price,
      thumbnail: body.thumbnail !== undefined ? String(body.thumbnail) : old.thumbnail,
      category: body.category !== undefined ? String(body.category) : old.category,
    };
    saveDb(db);
    return sendJson(res, 200, db.products[idx]);
  }

  // DELETE /products/:id
  if (req.method === 'DELETE' && parts[0] === 'products' && parts.length === 2) {
    const idx = db.products.findIndex((p) => p.id === Number(parts[1]));
    if (idx === -1) return sendJson(res, 404, { message: 'Product not found' });
    const [removed] = db.products.splice(idx, 1);
    saveDb(db);
    return sendJson(res, 200, { message: 'Deleted', product: removed });
  }

  sendJson(res, 404, { message: 'Not found' });
});

server.listen(PORT, () => {
  console.log(`Products CRUD API berjalan di http://localhost:${PORT}`);
  console.log('Endpoints:');
  console.log('  GET    /products');
  console.log('  GET    /products/:id');
  console.log('  POST   /products');
  console.log('  PUT    /products/:id');
  console.log('  DELETE /products/:id');
});
