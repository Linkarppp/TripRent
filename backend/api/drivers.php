<?php
// backend/api/drivers.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            $stmt = $conn->query("SELECT * FROM drivers ORDER BY id ASC");
            $drivers = $stmt->fetchAll();
            sendJsonResponse(true, 'Data supir berhasil dimuat.', $drivers);
        } else {
            sendJsonResponse(true, 'Data supir lokal.', []);
        }
        break;

    case 'POST':
        // Hanya Admin yang boleh mendaftarkan supir baru
        requireRole(['admin']);
        $input = json_decode(file_get_contents('php://input'), true);

        if ($conn) {
            $userId = null;
            // Jika ada username dan password, buat juga akun di tabel users
            if (!empty($input['username']) && !empty($input['password'])) {
                $userId = 'driver-usr-' . time();
                $email = strtolower($input['username']) . '@triprent.com';
                $userStmt = $conn->prepare("INSERT INTO users (id, username, email, password, nama_lengkap, no_telp, foto, level, role, status) VALUES (:id, :username, :email, :password, :nama, :noTelp, :foto, 'Mitra Supir', 'driver', 'aktif')");
                $userStmt->execute([
                    ':id' => $userId,
                    ':username' => strtolower($input['username']),
                    ':email' => $email,
                    ':password' => $input['password'],
                    ':nama' => $input['nama'],
                    ':noTelp' => $input['noHp'],
                    ':foto' => $input['foto']
                ]);
            }

            $stmt = $conn->prepare("INSERT INTO drivers (nama, jenis_kelamin, tempat_lahir, tanggal_lahir, alamat, keterangan, foto, rating, total_perjalanan, status_ketersediaan, no_hp, no_sim, user_id, is_aktif) VALUES (:nama, :jk, :tempat, :tgl, :alamat, :keterangan, :foto, 4.90, 0, 'Tersedia', :noHp, :noSim, :userId, 1)");
            $stmt->execute([
                ':nama' => $input['nama'],
                ':jk' => isset($input['jenisKelamin']) ? $input['jenisKelamin'] : 'Laki-laki',
                ':tempat' => isset($input['tempatLahir']) ? $input['tempatLahir'] : 'Padang',
                ':tgl' => isset($input['tanggalLahir']) ? $input['tanggalLahir'] : '1990-01-01',
                ':alamat' => $input['alamat'],
                ':keterangan' => $input['keterangan'],
                ':foto' => $input['foto'],
                ':noHp' => $input['noHp'],
                ':noSim' => isset($input['noSim']) ? $input['noSim'] : 'SIM A & B1 Umum',
                ':userId' => $userId
            ]);

            sendJsonResponse(true, 'Supir dan akun login berhasil didaftarkan.');
        } else {
            sendJsonResponse(true, 'Supir baru tersimpan.');
        }
        break;

    case 'PUT':
        $user = getAuthUser();
        $input = json_decode(file_get_contents('php://input'), true);
        $driverId = isset($input['id']) ? $input['id'] : null;

        // Driver boleh mengubah ketersediaan pribadinya, Admin boleh mengubah semua
        if (isset($input['statusKetersediaan'])) {
            requireRole(['admin', 'driver']);
            if ($conn && $driverId) {
                $status = $input['statusKetersediaan'];
                $tersedia = ($status === 'Tersedia') ? 1 : 0;
                $stmt = $conn->prepare("UPDATE drivers SET status_ketersediaan = :status, tersedia = :tersedia WHERE id = :id");
                $stmt->execute([':status' => $status, ':tersedia' => $tersedia, ':id' => $driverId]);
                sendJsonResponse(true, 'Status ketersediaan supir diperbarui menjadi: ' . $status);
            }
        } else {
            requireRole(['admin']);
            if ($conn && $driverId) {
                if (isset($input['toggleAktif'])) {
                    $stmt = $conn->prepare("UPDATE drivers SET is_aktif = NOT is_aktif WHERE id = :id");
                    $stmt->execute([':id' => $driverId]);
                } else {
                    $stmt = $conn->prepare("UPDATE drivers SET nama = :nama, alamat = :alamat, keterangan = :keterangan, no_hp = :noHp WHERE id = :id");
                    $stmt->execute([
                        ':id' => $driverId,
                        ':nama' => $input['nama'],
                        ':alamat' => $input['alamat'],
                        ':keterangan' => $input['keterangan'],
                        ':noHp' => $input['noHp']
                    ]);
                }
                sendJsonResponse(true, 'Data supir berhasil diperbarui.');
            }
        }
        sendJsonResponse(true, 'Supir terupdate.');
        break;

    case 'DELETE':
        requireRole(['admin']);
        $id = isset($_GET['id']) ? $_GET['id'] : null;
        if ($conn && $id) {
            $stmt = $conn->prepare("DELETE FROM drivers WHERE id = :id");
            $stmt->execute([':id' => $id]);
            sendJsonResponse(true, 'Supir berhasil dihapus.');
        } else {
            sendJsonResponse(true, 'Supir dihapus.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
