<?php
// backend/index.php
header('Content-Type: application/json; charset=utf-8');
echo json_encode([
    'app' => 'TripRent REST API Backend',
    'version' => '1.0.0',
    'status' => 'online',
    'roles_supported' => ['admin', 'user', 'driver'],
    'endpoints' => [
        '/api/auth.php' => 'Login, register, role check',
        '/api/cars.php' => 'CRUD mobil & ketersediaan armada',
        '/api/drivers.php' => 'CRUD supir, toggle status & ketersediaan',
        '/api/users.php' => 'Kelola akun user pelanggan',
        '/api/bookings.php' => 'Pemesanan tiket/mobil & penugasan supir',
        '/api/driver_tasks.php' => 'Daftar tugas perjalanan & status trip supir',
        '/api/transactions.php' => 'Verifikasi pembayaran transaksi',
        '/api/statistics.php' => 'Statistik ringkasan dashboard admin'
    ],
    'timestamp' => date('Y-m-d H:i:s')
]);
