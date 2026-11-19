<?php
// backend/api/transactions.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

$authUser = requireRole();
$method = $_SERVER['REQUEST_METHOD'];
$db = new Database();
$conn = $db->getConnection();

switch ($method) {
    case 'GET':
        if ($conn) {
            if ($authUser['role'] === 'admin') {
                $stmt = $conn->query("SELECT t.*, b.nama_pemesan, b.no_telpon, b.status as booking_status FROM transactions t LEFT JOIN bookings b ON t.order_id = b.id ORDER BY t.transaction_date DESC");
            } else {
                $stmt = $conn->prepare("SELECT t.*, b.nama_pemesan, b.no_telpon, b.status as booking_status FROM transactions t LEFT JOIN bookings b ON t.order_id = b.id WHERE b.user_id = :uid ORDER BY t.transaction_date DESC");
                $stmt->execute([':uid' => $authUser['user_id']]);
            }
            $transactions = $stmt->fetchAll();
            sendJsonResponse(true, 'Data transaksi berhasil diambil.', $transactions);
        } else {
            sendJsonResponse(true, 'Daftar transaksi lokal.', []);
        }
        break;

    case 'PUT':
        $input = json_decode(file_get_contents('php://input'), true);
        $orderCode = isset($input['orderCode']) ? $input['orderCode'] : null;

        if (!$orderCode) {
            sendJsonResponse(false, 'Kode pesanan diperlukan.', null, 400);
        }

        if ($conn) {
            if (isset($input['status'])) {
                // Verifikasi Pembayaran oleh Admin
                requireRole(['admin']);
                $newStatus = $input['status']; // 'Lunas' | 'Ditolak'
                $stmt = $conn->prepare("UPDATE transactions SET status = :st, verified_by = :vby, verified_at = CURRENT_TIMESTAMP WHERE order_code = :code");
                $stmt->execute([':st' => $newStatus, ':vby' => $authUser['user_id'], ':code' => $orderCode]);

                $bStmt = $conn->prepare("UPDATE bookings SET payment_status = :st WHERE kode_orders = :code");
                $bStmt->execute([':st' => $newStatus, ':code' => $orderCode]);

                sendJsonResponse(true, 'Pembayaran transaksi ' . $orderCode . ' berhasil diverifikasi sebagai: ' . $newStatus);
            } else if (isset($input['proofImageUrl'])) {
                // Upload Bukti Pembayaran oleh Pelanggan
                $proof = $input['proofImageUrl'];
                $stmt = $conn->prepare("UPDATE transactions SET proof_image_url = :proof, status = 'Menunggu Verifikasi' WHERE order_code = :code");
                $stmt->execute([':proof' => $proof, ':code' => $orderCode]);

                $bStmt = $conn->prepare("UPDATE bookings SET bukti_pembayaran = :proof, payment_status = 'Menunggu Verifikasi' WHERE kode_orders = :code");
                $bStmt->execute([':proof' => $proof, ':code' => $orderCode]);

                sendJsonResponse(true, 'Bukti pembayaran berhasil diunggah! Menunggu verifikasi admin.');
            }
        } else {
            sendJsonResponse(true, 'Status transaksi terupdate.');
        }
        break;

    default:
        sendJsonResponse(false, 'Metode HTTP tidak didukung.', null, 405);
}
