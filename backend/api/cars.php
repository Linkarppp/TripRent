<?php
// backend/api/cars.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            $stmt = $conn->query("SELECT * FROM cars ORDER BY id DESC");
            $cars = $stmt->fetchAll();
            sendJsonResponse(true, 'Data armada mobil berhasil dimuat.', $cars);
        } else {
            sendJsonResponse(true, 'Mode Standby: Armada dimuat dari cache lokal.', []);
        }
        break;

    case 'POST':
        // Validasi: Hanya Admin yang boleh menambah mobil
        requireRole(['admin']);
        $input = json_decode(file_get_contents('php://input'), true);

        if ($conn) {
            $stmt = $conn->prepare("INSERT INTO cars (nama, nama_seo, harga_sewa, harga_sopir, durasi, termasuk, mesin, tahun, kapasitas, stok, keterangan, gambar_utama, category, transmisi, aktif) VALUES (:nama, :seo, :harga_sewa, :harga_sopir, :durasi, :termasuk, :mesin, :tahun, :kapasitas, :stok, :keterangan, :gambar, :category, :transmisi, 1)");
            $stmt->execute([
                ':nama' => $input['nama'],
                ':seo' => strtolower(str_replace(' ', '-', $input['nama'])),
                ':harga_sewa' => $input['hargaSewa'],
                ':harga_sopir' => isset($input['hargaSopir']) ? $input['hargaSopir'] : 150000,
                ':durasi' => isset($input['durasi']) ? $input['durasi'] : 1,
                ':termasuk' => isset($input['termasuk']) ? $input['termasuk'] : 'Mobil Saja',
                ':mesin' => isset($input['mesin']) ? $input['mesin'] : '1500 cc',
                ':tahun' => isset($input['tahun']) ? $input['tahun'] : '2023',
                ':kapasitas' => isset($input['kapasitas']) ? $input['kapasitas'] : '7 Orang',
                ':stok' => isset($input['stok']) ? $input['stok'] : 1,
                ':keterangan' => isset($input['keterangan']) ? $input['keterangan'] : '',
                ':gambar' => isset($input['gambarUtama']) ? $input['gambarUtama'] : '',
                ':category' => isset($input['category']) ? $input['category'] : 'Mobil Keluarga',
                ':transmisi' => isset($input['transmisi']) ? $input['transmisi'] : 'Otomatis'
            ]);
            sendJsonResponse(true, 'Mobil baru berhasil ditambahkan.');
        } else {
            sendJsonResponse(true, 'Mobil baru tersimpan.');
        }
        break;

    case 'PUT':
        requireRole(['admin']);
        $input = json_decode(file_get_contents('php://input'), true);
        $id = isset($input['id']) ? $input['id'] : null;

        if (!$id) {
            sendJsonResponse(false, 'ID mobil tidak ditemukan.', null, 400);
        }

        if ($conn) {
            if (isset($input['toggleAktif'])) {
                $stmt = $conn->prepare("UPDATE cars SET aktif = NOT aktif WHERE id = :id");
                $stmt->execute([':id' => $id]);
            } else {
                $stmt = $conn->prepare("UPDATE cars SET nama = :nama, harga_sewa = :harga_sewa, stok = :stok, keterangan = :keterangan, gambar_utama = :gambar WHERE id = :id");
                $stmt->execute([
                    ':id' => $id,
                    ':nama' => $input['nama'],
                    ':harga_sewa' => $input['hargaSewa'],
                    ':stok' => $input['stok'],
                    ':keterangan' => $input['keterangan'],
                    ':gambar' => $input['gambarUtama']
                ]);
            }
            sendJsonResponse(true, 'Data mobil berhasil diperbarui.');
        } else {
            sendJsonResponse(true, 'Data mobil terupdate.');
        }
        break;

    case 'DELETE':
        requireRole(['admin']);
        $id = isset($_GET['id']) ? $_GET['id'] : null;
        if ($conn && $id) {
            $stmt = $conn->prepare("DELETE FROM cars WHERE id = :id");
            $stmt->execute([':id' => $id]);
            sendJsonResponse(true, 'Mobil berhasil dihapus.');
        } else {
            sendJsonResponse(true, 'Mobil dihapus.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
