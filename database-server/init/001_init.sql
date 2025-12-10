CREATE DATABASE IF NOT EXISTS minicloud;
USE minicloud;

CREATE TABLE IF NOT EXISTS notes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO notes(title) VALUES ('Hello from MariaDB!');

-- 

CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

CREATE TABLE IF NOT EXISTS students(
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10),
    fullname VARCHAR(100),
    dob DATE,
    major VARCHAR(50)
);

INSERT INTO students (student_id, fullname, dob, major) VALUES
('52200104', 'La Thanh Binh ne', '2004-06-09', 'Software Engineering'),
('52200104', 'Thanh Binh cutie', '2004-06-09', 'Software Engineering'),
('52200104', 'Thanh Binh', '2004-06-09', 'Software Engineering');