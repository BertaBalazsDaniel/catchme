<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$uploadDir = __DIR__ . '/html/resources/community/';

$dsn = 'mysql:host=localhost;dbname=bmashop;charset=utf8';
$dbUser = 'root';
$dbPass = '';

try {
    $pdo = new PDO($dsn, $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Adatbázis kapcsolat sikertelen: ' . $e->getMessage()]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['content'], $_POST['category'], $_POST['userId'])) {
        $content = $_POST['content'];
        $category = $_POST['category'];
        $userId = intval($_POST['userId']);
        $imagePath = null;

        if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            $imageTmpPath = $_FILES['image']['tmp_name'];
            $imageExtension = strtolower(pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION));

            $imageIndex = getNextImageIndex($uploadDir);
            $newFileName = sprintf('image_%03d.%s', $imageIndex, $imageExtension);
            $destinationPath = $uploadDir . $newFileName;

            if (move_uploaded_file($imageTmpPath, $destinationPath)) {
                $imagePath = 'resources/community/' . $newFileName;
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'A kép mentése nem sikerült.']);
                exit;
            }
        }

        try {
            $stmt = $pdo->prepare("INSERT INTO posts (UserId, Content, Category, ImageUrl, CreatedAt) VALUES (:userId, :content, :category, :imageUrl, :createdAt)");
            $stmt->execute([
                ':userId' => $userId,
                ':content' => $content,
                ':category' => $category,
                ':imageUrl' => $imagePath,
                ':createdAt' => date('Y-m-d H:i:s')
            ]);

            $newPostId = $pdo->lastInsertId();

            $newPost = [
                'id' => $newPostId,
                'userId' => $userId,
                'content' => $content,
                'category' => $category,
                'imageUrl' => $imagePath,
                'createdAt' => date('Y-m-d H:i:s'),
            ];

            header('Content-Type: application/json');
            echo json_encode($newPost);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Adatbázis hiba: ' . $e->getMessage()]);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'A cím, tartalom, kategória és felhasználó ID mezők kötelezőek.']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Csak POST kérés engedélyezett.']);
}

function getNextImageIndex($uploadDir) {
    $files = glob($uploadDir . 'image_*.{jpg,jpeg,png,gif}', GLOB_BRACE);
    if (empty($files)) {
        return 1;
    }

    $maxIndex = 0;
    foreach ($files as $file) {
        $fileName = basename($file);
        if (preg_match('/image_(\d+)\./', $fileName, $matches)) {
            $maxIndex = max($maxIndex, (int)$matches[1]);
        }
    }

    return $maxIndex + 1;
}