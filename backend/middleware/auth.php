<?php
// backend/middleware/auth.php
require_once __DIR__ . '/../config/database.php';

function getAuthUser() {
    $headers = getallheaders();
    $role = isset($headers['X-Role']) ? strtolower($headers['X-Role']) : null;
    $authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : '';

    if (empty($role) && !empty($authHeader)) {
        if (preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            $token = $matches[1];
            // Decode simple token format "role:userId" or json
            if (strpos($token, ':') !== false) {
                list($parsedRole, $userId) = explode(':', $token, 2);
                return ['role' => strtolower($parsedRole), 'user_id' => $userId];
            }
        }
    }

    if ($role) {
        return ['role' => $role, 'user_id' => isset($headers['X-User-Id']) ? $headers['X-User-Id'] : null];
    }

    return null;
}

function requireRole($allowedRoles = []) {
    $user = getAuthUser();
    if (!$user) {
        sendJsonResponse(false, 'Autentikasi diperlukan. Silakan login.', null, 401);
    }

    if (!empty($allowedRoles)) {
        if (!in_array($user['role'], $allowedRoles)) {
            sendJsonResponse(
                false,
                'Akses Ditolak: Hak akses Anda (' . $user['role'] . ') tidak diizinkan membuka fitur ini.',
                null,
                403
            );
        }
    }

    return $user;
}
