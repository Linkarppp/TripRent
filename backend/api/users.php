<?php
// backend/api/users.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

// Hak akses khusus Admin
requireRole(['admin']);

$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            $stmt = $conn->query("SELECT id, username, email, nama_lengkap, no_telp, foto, level, role, status, created_at FROM users ORDER BY created_at DESC");
            $users = $stmt->fetchAll();
            sendJsonResponse(true, 'Data pengguna berhasil dimuat.', $users);
        } else {
            sendJsonResponse(true, 'Daftar user lokal.', []);
        }
        break;

    case 'PUT':
        $input = json_decode(file_get_contents('php://input'), true);
        $userId = isset($input['id']) ? $input['id'] : null;

        if (!$userId) {
            sendJsonResponse(false, 'ID pengguna diperlukan.', null, 400);
        }

        if ($conn) {
            if (isset($input['toggleStatus'])) {
                $stmt = $conn->prepare("UPDATE users SET status = IF(status = 'aktif', 'nonaktif', 'aktif') WHERE id = :id");
                $stmt->execute([':id' => $userId]);
                sendJsonResponse(true, 'Status akun pengguna berhasil diubah.');
            } else {
                $stmt = $conn->prepare("UPDATE users SET nama_lengkap = :nama, no_telp = :noTelp, role = :role, level = :level WHERE id = :id");
                $stmt->execute([
                    ':id' => $userId,
                    ':nama' => $input['namaLengkap'],
                    ':noTelp' => $input['noTelp'],
                    ':role' => $input['role'],
                    ':level' => isset($input['level']) ? $input['level'] : 'Member'
                ]);
                sendJsonResponse(true, 'Data pengguna berhasil diperbarui.');
            }
        } else {
            sendJsonResponse(true, 'Data user terupdate.');
        }
        break;

    case 'DELETE':
        $id = isset($_GET['id']) ? $_GET['id'] : null;
        if ($conn && $id) {
            $stmt = $conn->prepare("DELETE FROM users WHERE id = :id");
            $stmt->execute([':id' => $id]);
            sendJsonResponse(true, 'Akun pengguna berhasil dihapus.');
        } else {
            sendJsonResponse(true, 'Akun dihapus.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
