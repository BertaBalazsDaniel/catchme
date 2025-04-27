<?php
header('Content-Type: application/json');
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/upload_error_log.txt');
error_reporting(E_ALL);

$dsn = 'mysql:host=localhost;dbname=bmashop;charset=utf8';
$dbUser = 'root';
$dbPass = '';

try {
    $pdo = new PDO($dsn, $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Adatbázis hiba']);
    exit;
}

$uploadDir = __DIR__ . '/html/resources/users/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Nem POST kérés']);
    exit;
}

if (!isset($_POST['username']) || !isset($_FILES['profile_picture'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Hiányzó mezők']);
    exit;
}

$username = preg_replace('/[^a-zA-Z0-9_-]/', '', $_POST['username']);
$cleanUsername = strtolower($username);
$file = $_FILES['profile_picture'];

if ($file['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(['error' => 'Feltöltési hiba']);
    exit;
}

$extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
if (!in_array($extension, ['jpg', 'jpeg'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Csak JPEG formátum engedélyezett.']);
    exit;
}

$fileName = $cleanUsername . '.' . $extension;
$destPath = $uploadDir . $fileName;
$relativePath = 'resources/users/' . $fileName;

if (!move_uploaded_file($file['tmp_name'], $destPath)) {
    http_response_code(500);
    echo json_encode(['error' => 'Nem sikerült elmenteni a képet.']);
    exit;
}

try {
    $stmt = $pdo->prepare("UPDATE users SET ProfileImage = :profileImage WHERE Username = :username");
    $stmt->execute([
        ':profileImage' => $relativePath,
        ':username' => $username
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Adatbázis frissítési hiba']);
    exit;
}

echo json_encode([
    'success' => true,
    'username' => $username,
    'profileImage' => $relativePath,
    'updatedAt' => date('Y-m-d H:i:s')
]);
exit;