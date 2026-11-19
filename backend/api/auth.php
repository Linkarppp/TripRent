<?php
// backend/api/auth.php
require_once __DIR__ . '/../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];
$action = isset($_GET['action']) ? $_GET['action'] : '';

$db = new Database();
$conn = $db->getConnection();

if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    if ($action === 'register') {
        $nama = isset($input['namaLengkap']) ? trim($input['namaLengkap']) : '';
        $email = isset($input['email']) ? trim($input['email']) : '';
        $noTelp = isset($input['noTelp']) ? trim($input['noTelp']) : '';
        $password = isset($input['password']) ? trim($input['password']) : '';
        $role = isset($input['role']) ? strtolower(trim($input['role'])) : 'user';

        if (empty($nama) || empty($email) || empty($password)) {
            sendJsonResponse(false, 'Semua kolom wajib diisi.', null, 400);
        }

        if ($conn) {
            $stmt = $conn->prepare("SELECT id FROM users WHERE email = :email LIMIT 1");
            $stmt->execute([':email' => $email]);
            if ($stmt->fetch()) {
                sendJsonResponse(false, 'Email sudah terdaftar. Silakan login.', null, 400);
            }

            $userId = 'usr-' . time();
            $insert = $conn->prepare("INSERT INTO users (id, username, email, password, nama_lengkap, no_telp, role, level, status) VALUES (:id, :username, :email, :password, :nama, :noTelp, :role, 'Member Baru', 'aktif')");
            $insert->execute([
                ':id' => $userId,
                ':username' => explode('@', $email)[0],
                ':email' => $email,
                ':password' => $password,
                ':nama' => $nama,
                ':noTelp' => $noTelp,
                ':role' => $role
            ]);

            sendJsonResponse(true, 'Pendaftaran berhasil! Selamat datang, ' . $nama, [
                'id' => $userId,
                'email' => $email,
                'namaLengkap' => $nama,
                'role' => $role,
                'token' => $role . ':' . $userId
            ]);
        } else {
            // Mock backend response if MySQL is not running
            sendJsonResponse(true, 'Pendaftaran berhasil (Mode Offline/Standby)!', [
                'id' => 'usr-' . time(),
                'email' => $email,
                'namaLengkap' => $nama,
                'role' => $role,
                'token' => $role . ':usr-demo'
            ]);
        }
    } else { // Login
        $identifier = isset($input['identifier']) ? trim($input['identifier']) : '';
        $password = isset($input['password']) ? trim($input['password']) : '';

        if (empty($identifier) || empty($password)) {
            sendJsonResponse(false, 'Username/Email dan kata sandi wajib diisi.', null, 400);
        }

        if ($conn) {
            $stmt = $conn->prepare("SELECT * FROM users WHERE email = :id1 OR username = :id2 OR no_telp = :id3 LIMIT 1");
            $stmt->execute([':id1' => $identifier, ':id2' => $identifier, ':id3' => $identifier]);
            $user = $stmt->fetch();

            if (!$user) {
                sendJsonResponse(false, 'Akun dengan kredensial tersebut tidak ditemukan.', null, 404);
            }

            if ($user['status'] === 'nonaktif') {
                sendJsonResponse(false, 'Akun Anda dinonaktifkan oleh Administrator.', null, 403);
            }

            if ($user['password'] !== $password) {
                sendJsonResponse(false, 'Kata sandi yang Anda masukkan salah.', null, 401);
            }

            sendJsonResponse(true, 'Login berhasil! Selamat datang, ' . $user['nama_lengkap'], [
                'user' => [
                    'id' => $user['id'],
                    'username' => $user['username'],
                    'email' => $user['email'],
                    'namaLengkap' => $user['nama_lengkap'],
                    'noTelp' => $user['no_telp'],
                    'role' => $user['role'],
                    'level' => $user['level'],
                    'foto' => $user['foto'],
                    'driverId' => $user['driver_id']
                ],
                'token' => $user['role'] . ':' . $user['id']
            ]);
        } else {
            // Mock response if DB connection is unavailable
            $role = 'user';
            $name = 'Pengguna Demo';
            if (strpos($identifier, 'admin') !== false) {
                $role = 'admin';
                $name = 'Administrator TripRent';
            } else if (strpos($identifier, 'driver') !== false) {
                $role = 'driver';
                $name = 'Robby Prihandaya (Supir)';
            }

            sendJsonResponse(true, 'Login berhasil (Mode Sinkronisasi Lokal)!', [
                'user' => [
                    'id' => 'demo-' . $role,
                    'username' => $identifier,
                    'email' => $identifier . '@triprent.com',
                    'namaLengkap' => $name,
                    'noTelp' => '0812-8694-3954',
                    'role' => $role,
                    'level' => ucfirst($role),
                    'foto' => null,
                    'driverId' => $role === 'driver' ? 1 : null
                ],
                'token' => $role . ':demo-' . $role
            ]);
        }
    }
} else {
    sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
