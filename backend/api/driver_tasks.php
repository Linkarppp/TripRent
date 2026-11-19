<?php
// backend/api/driver_tasks.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

// Khusus role Driver atau Admin
$authUser = requireRole(['driver', 'admin']);
$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            $driverId = isset($_GET['driver_id']) ? $_GET['driver_id'] : null;
            if (!$driverId && $authUser['role'] === 'driver') {
                $findDriver = $conn->prepare("SELECT id FROM drivers WHERE user_id = :uid LIMIT 1");
                $findDriver->execute([':uid' => $authUser['user_id']]);
                $dRow = $findDriver->fetch();
                $driverId = $dRow ? $dRow['id'] : null;
            }

            if ($driverId) {
                $stmt = $conn->prepare("SELECT b.*, c.nama as car_nama, c.mesin, c.tahun, c.transmisi, c.gambar_utama as car_gambar, d.nama as driver_nama FROM bookings b LEFT JOIN cars c ON b.car_id = c.id LEFT JOIN drivers d ON b.driver_id = d.id WHERE b.driver_id = :did ORDER BY b.waktu DESC");
                $stmt->execute([':did' => $driverId]);
                $tasks = $stmt->fetchAll();
                sendJsonResponse(true, 'Daftar tugas perjalanan supir berhasil dimuat.', $tasks);
            } else {
                sendJsonResponse(true, 'Tidak ada tugas yang ditugaskan.', []);
            }
        } else {
            sendJsonResponse(true, 'Tugas driver dimuat.', []);
        }
        break;

    case 'PUT':
        $input = json_decode(file_get_contents('php://input'), true);
        $orderCode = isset($input['kodeOrders']) ? $input['kodeOrders'] : null;
        $taskStatus = isset($input['driverTaskStatus']) ? $input['driverTaskStatus'] : null;

        if (!$orderCode || !$taskStatus) {
            sendJsonResponse(false, 'Kode pesanan dan status tugas diperlukan.', null, 400);
        }

        if ($conn) {
            // Update status tugas pada booking
            $stmt = $conn->prepare("UPDATE bookings SET driver_task_status = :ts WHERE kode_orders = :kode");
            $stmt->execute([':ts' => $taskStatus, ':kode' => $orderCode]);

            // Jika perjalanan selesai, update status booking menjadi 'Selesai'
            if ($taskStatus === 'Perjalanan Selesai') {
                $finishStmt = $conn->prepare("UPDATE bookings SET status = 'Selesai' WHERE kode_orders = :kode");
                $finishStmt->execute([':kode' => $orderCode]);

                // Tambahkan total perjalanan supir
                $incStmt = $conn->prepare("UPDATE drivers SET total_perjalanan = total_perjalanan + 1, status_ketersediaan = 'Tersedia', tersedia = 1 WHERE id = (SELECT driver_id FROM bookings WHERE kode_orders = :kode LIMIT 1)");
                $incStmt->execute([':kode' => $orderCode]);
            } else if ($taskStatus === 'Dalam Perjalanan') {
                $conn->prepare("UPDATE bookings SET status = 'Proses' WHERE kode_orders = :kode")->execute([':kode' => $orderCode]);
                $conn->prepare("UPDATE drivers SET status_ketersediaan = 'Dalam Perjalanan', tersedia = 0 WHERE id = (SELECT driver_id FROM bookings WHERE kode_orders = :kode LIMIT 1)")->execute([':kode' => $orderCode]);
            }

            // Catat log update tugas di driver_assignments
            $assignStmt = $conn->prepare("UPDATE driver_assignments SET status_tugas = :ts WHERE order_id = (SELECT id FROM bookings WHERE kode_orders = :kode LIMIT 1)");
            $assignStmt->execute([':ts' => $taskStatus, ':kode' => $orderCode]);

            sendJsonResponse(true, 'Status perjalanan berhasil diperbarui menjadi: ' . $taskStatus);
        } else {
            sendJsonResponse(true, 'Status tugas perjalanan terupdate.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
