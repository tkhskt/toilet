-- ユーザーテーブル
CREATE TABLE users (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(25),
    `icon_path` TEXT,
    --`password` VARCHAR(16),
    --`salt` VARCHAR(8),
    `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- トイレテーブル
CREATE TABLE toilets (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` TEXT,
    `google_id` TEXT,
    `lat` DOUBLE NOT NULL,
    `lng` DOUBLE NOT NULL,
    `geolocation` TEXT,
    `image_path` TEXT,
    `description` TEXT,
    `valuation` DOUBLE DEFAULT 0.0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp on update current_timestamp,
    `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ユーザーとトイレの中間テーブル user_idとtoilet_idを複合主キーにする
CREATE TABLE users_toilets (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `toilet_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- レビュー user_idとtoilet_idを複合主キーにする
CREATE TABLE reviews (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `toilet_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `valuation` DOUBLE,
    `message` TEXT,
    `updated_at` TIMESTAMP NOT NULL DEFAULT DEFAULT current_timestamp on update current_timestamp,
    `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



