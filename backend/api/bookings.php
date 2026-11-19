<?php
// backend/api/bookings.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

$authUser = requireRole(); // Membutuhkan login (Admin, User, atau Driver)
$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            if ($authUser['role'] === 'admin') {
                $stmt = $conn->query("SELECT b.*, c.nama as car_nama, d.nama as driver_nama FROM bookings b LEFT JOIN cars c ON b.car_id = c.id LEFT JOIN drivers d ON b.driver_id = d.id ORDER BY b.id DESC");
            } else if ($authUser['role'] === 'driver') {
                // Supir hanya boleh melihat pemesanan yang ditugaskan kepadanya!
                $stmt = $conn->prepare("SELECT b.*, c.nama as car_nama, d.nama as driver_nama FROM bookings b LEFT JOIN cars c ON b.car_id = c.id LEFT JOIN drivers d ON b.driver_id = d.id WHERE b.driver_id = (SELECT id FROM drivers WHERE user_id = :uid LIMIT 1) OR b.driver_id = :did ORDER BY b.id DESC");
                $stmt->execute([':uid' => $authUser['user_id'], ':did' => isset($_GET['driver_id']) ? $_GET['driver_id'] : 0]);
            } else {
                // Pelanggan hanya boleh melihat riwayat pemesanan miliknya
                $stmt = $conn->prepare("SELECT b.*, c.nama as car_nama, d.nama as driver_nama FROM bookings b LEFT JOIN cars c ON b.car_id = c.id LEFT JOIN drivers d ON b.driver_id = d.id WHERE b.user_id = :uid ORDER BY b.id DESC");
                $stmt->execute([':uid' => $authUser['user_id']]);
            }
            $bookings = $stmt->fetchAll();
            sendJsonResponse(true, 'Data pemesanan berhasil diambil.', $bookings);
        } else {
            sendJsonResponse(true, 'Daftar booking lokal.', []);
        }
        break;

    case 'POST':
        // Pelanggan atau Admin membuat pemesanan baru
        $input = json_decode(file_get_contents('php://input'), true);

        if ($conn) {
            $orderCode = 'TRX-' . date('YmdHis');
            $stmt = $conn->prepare("INSERT INTO bookings (kode_orders, user_id, nama_pemesan, email, no_telpon, keterangan, jemput, tujuan, status, car_id, driver_id, pakai_sopir, dari_tanggal, sampai_tanggal, sewa_perhari, total_hari, total_harga, bank_pembayaran, is_ticket, ticket_title, driver_task_status, payment_status) VALUES (:kode, :uid, :nama, :email, :telp, :ket, :jemput, :tujuan, 'Pending', :carId, :driverId, :pakaiSopir, :dari, :sampai, :perhari, :hari, :total, :bank, :isTicket, :ticketTitle, 'Menunggu Konfirmasi', 'Menunggu Verifikasi')");
            $stmt->execute([
                ':kode' => $orderCode,
                ':uid' => $authUser['user_id'],
                ':nama' => $input['namaPemesan'],
                ':email' => $input['email'],
                ':telp' => $input['noTelpon'],
                ':ket' => isset($input['keterangan']) ? $input['keterangan'] : '',
                ':jemput' => $input['jemput'],
                ':tujuan' => $input['tujuan'],
                ':carId' => isset($input['carId']) ? $input['carId'] : null,
                ':driverId' => isset($input['driverId']) ? $input['driverId'] : null,
                ':pakaiSopir' => !empty($input['pakaiSopir']) ? 1 : 0,
                ':dari' => $input['dariTanggal'],
                ':sampai' => $input['sampaiTanggal'],
                ':perhari' => $input['sewaPerhari'],
                ':hari' => $input['totalHari'],
                ':total' => $input['totalHarga'],
                ':bank' => isset($input['bankPembayaran']) ? $input['bankPembayaran'] : 'BCA',
                ':isTicket' => !empty($input['isTicket']) ? 1 : 0,
                ':ticketTitle' => isset($input['ticketTitle']) ? $input['ticketTitle'] : null
            ]);

            $orderId = $conn->lastInsertId();

            // Insert otomatis ke transactions
            $trans = $conn->prepare("INSERT INTO transactions (id, order_id, order_code, customer_name, item_name, total_amount, payment_method, status) VALUES (:id, :oid, :code, :cname, :item, :amount, :method, 'Menunggu Verifikasi')");
            $trans->execute([
                ':id' => 'TXN-' . $orderId,
                ':oid' => $orderId,
                ':code' => $orderCode,
                ':cname' => $input['namaPemesan'],
                ':item' => !empty($input['ticketTitle']) ? $input['ticketTitle'] : 'Mobil Rental',
                ':amount' => $input['totalHarga'],
                ':method' => isset($input['bankPembayaran']) ? $input['bankPembayaran'] : 'BCA'
            ]);

            sendJsonResponse(true, 'Pemesanan berhasil dibuat!', ['kodeOrders' => $orderCode, 'id' => $orderId]);
        } else {
            sendJsonResponse(true, 'Booking tersimpan.');
        }
        break;

    case 'PUT':
        requireRole(['admin']);
        $input = json_decode(file_get_contents('php://input'), true);
        $orderCode = isset($input['kodeOrders']) ? $input['kodeOrders'] : null;

        if (!$orderCode) {
            sendJsonResponse(false, 'Kode pesanan diperlukan.', null, 400);
        }

        if ($conn) {
            if (isset($input['assignDriverId'])) {
                // Tentukan supir untuk pemesanan yang membutuhkan supir
                $driverId = $input['assignDriverId'];
                $stmt = $conn->prepare("UPDATE bookings SET driver_id = :did, pakai_sopir = 1, driver_task_status = 'Menunggu Konfirmasi' WHERE kode_orders = :kode");
                $stmt->execute([':did' => $driverId, ':kode' => $orderCode]);

                // Catat penugasan di driver_assignments
                $assignStmt = $conn->prepare("INSERT INTO driver_assignments (order_id, driver_id, assigned_by, status_tugas, catatan) SELECT id, :did, 'admin', 'Menunggu Konfirmasi', 'Ditugaskan oleh Admin' FROM bookings WHERE kode_orders = :kode LIMIT 1");
                $assignStmt->execute([':did' => $driverId, ':kode' => $orderCode]);

                sendJsonResponse(true, 'Supir berhasil ditugaskan ke pesanan ' . $orderCode);
            } else if (isset($input['status'])) {
                // Konfirmasi atau Batalkan pesanan
                $newStatus = $input['status'];
                $stmt = $conn->prepare("UPDATE bookings SET status = :st WHERE kode_orders = :kode");
                $stmt->execute([':st' => $newStatus, ':kode' => $orderCode]);
                sendJsonResponse(true, 'Status pesanan berhasil diubah menjadi: ' . $newStatus);
            }
        } else {
            sendJsonResponse(true, 'Pesanan diperbarui.');
        }
        break;

    case 'DELETE':
        requireRole(['admin']);
        $code = isset($_GET['kodeOrders']) ? $_GET['kodeOrders'] : null;
        if ($conn && $code) {
            $stmt = $conn->prepare("DELETE FROM bookings WHERE kode_orders = :kode");
            $stmt->execute([':kode' => $code]);
            sendJsonResponse(true, 'Pesanan berhasil dihapus.');
        } else {
            sendJsonResponse(true, 'Pesanan dihapus.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
