-- Tạo Database tên là minicloud nếu chưa có
CREATE DATABASE IF NOT EXISTS minicloud;

-- Chọn sử dụng database này
USE minicloud;

-- Tạo bảng 'notes' để lưu ghi chú
CREATE TABLE IF NOT EXISTS notes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chèn thử 1 dòng dữ liệu mẫu để lát nữa kiểm tra
INSERT INTO notes(title) VALUES ('Hello from MariaDB!');

-- File này đặt trong thư mục /init.
-- Khi Docker chạy MariaDB lần đầu tiên, nó sẽ tự động tìm các file đuôi .sql trong thư mục này và chạy chúng. Đây là cơ chế docker-entrypoint-initdb.d của MariaDB Docker image.

-- --- PHẦN MỞ RỘNG ---
CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10),
    fullname VARCHAR(100),
    dob DATE,
    major VARCHAR(50)
);

-- Chèn dữ liệu mẫu
INSERT INTO students (student_id, fullname, dob, major) VALUES 
('SV001', 'Nguyen Van A', '2003-01-01', 'CNTT'),
('SV002', 'Tran Thi B', '2003-05-15', 'KTPM'),
('SV003', 'Le Van C', '2003-09-20', 'HTTT');