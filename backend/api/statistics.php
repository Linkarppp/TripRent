<?php
// backend/api/statistics.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../middleware/auth.php';

// Khusus Admin
requireRole(['admin']);

$db = new Database();
$conn = $db->getConnection();

if ($conn) {
    $totalCars = $conn->query("SELECT COUNT(*) FROM cars")->fetchColumn();
    $totalUsers = $conn->query("SELECT COUNT(*) FROM users WHERE role = 'user'")->fetchColumn();
    $totalDrivers = $conn->query("SELECT COUNT(*) FROM drivers WHERE is_aktif = 1")->fetchColumn();
    $totalBookings = $conn->query("SELECT COUNT(*) FROM bookings")->fetchColumn();
    $totalRevenue = $conn->query("SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE status = 'Lunas'")->fetchColumn();
    $pendingPaymentRevenue = $conn->query("SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE status = 'Menunggu Verifikasi'")->fetchColumn();

    sendJsonResponse(true, 'Statistik Dashboard Admin berhasil dimuat.', [
        'totalCars' => (int)$totalCars,
        'totalUsers' => (int)$totalUsers,
        'totalDrivers' => (int)$totalDrivers,
        'totalBookings' => (int)$totalBookings,
        'totalRevenue' => (int)$totalRevenue,
        'pendingPaymentRevenue' => (int)$pendingPaymentRevenue
    ]);
} else {
    sendJsonResponse(true, 'Statistik Dashboard (Standby Mode)', [
        'totalCars' => 7,
        'totalUsers' => 2,
        'totalDrivers' => 4,
        'totalBookings' => 5,
        'totalRevenue' => 3500000,
        'pendingPaymentRevenue' => 1300000
    ]);
}
