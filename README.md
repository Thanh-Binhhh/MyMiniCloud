# 🌥️ MyMiniCloud

Dự án mô phỏng các thành phần trong hạ tầng của một Cloud Platform (như AWS, Azure, GCP).

---

## 📁 Cấu trúc thư mục

```

├── Source_code/
│   ├── app-server/
│   │   ├── .env
│   │   ├── app.js
│   │   ├── data.json
│   │   ├── Dockerfile
│   │   └── package.json
│   ├── auth-server/
│   ├── database-server/
│   │   └── 001_init.sql
│   ├── dns-server/
│   │   ├── db.cloud.local
│   │   ├── named.conf.local
│   │   └── named.conf.options
│   ├── logging-server/
│   ├── monitoring-prometheus-server/
│   │   └── prometheus.yml
│   ├── proxy/
│   │   └── nginx.conf
│   ├── storage-server/
│   ├── web-server/
│   │   ├── html/
│   │   │   ├── assets/
│   │   │   ├── blog/
│   │   │   ├── index.html
│   │   ├── conf.default
│   │   └── Dockerfile
│   ├── web-server-2/
├── docker-compose.yml

```

---

## ⚡Các thành phần

### 1. Web Server

Web Server là một phần mềm hoặc thiết bị phần cứng có nhiệm vụ lưu trữ, xử lý và phản hồi yêu cầu từ các trình duyệt web.
<br>Các máy chủ web phổ biến bao gồm Apache, Nginx, Microsoft IIS.

##### 1.1 Công nghệ sử dụng

- [nginx](https://nginx.org/) - Máy chủ web phục vụ file tĩnh và reverse proxy.

##### 1.2 Endpoints

| HTTP Method | Endpoint                                |
| :---------- | :-------------------------------------- |
| `GET`       | `http://localhost:8080`                 |
| `GET`       | `http://localhost:8080/blog/`           |
| `GET`       | `http://localhost:8080/blog/blog1.html` |
| `GET`       | `http://localhost:8080/blog/blog2.html` |
| `GET`       | `http://localhost:8080/blog/blog3`      |

```
curl -I http://localhost:8080/
curl -I http://localhost:8080/blog/
```

### 2. Auth Server

Auth Server quản lý và xác minh người dùng cho toàn hệ thống.

##### 2.1 Công nghệ sử dụng

- [Keycloak]() - Hệ thống quản lý đăng nhập và phân quyền mã nguồn mở.

##### 2.2 Endpoints

| HTTP Method | Endpoint                |
| :---------- | :---------------------- |
| `GET`       | `http://localhost:8081` |

Đăng nhập bằng tài khoản: `admin`/`admin`

##### 2.3 Hướng dẫn kiểm thử API

`POST` `http://localhost:8081/realms/realm_52200104/protocol/openid-connect/token`

- Cấu hình trên Keycloak

  - Tạo mới Realms tên **realm_52200104**
  - Tạo mới Clients
    - Client type: **OpenID Connect**
    - Client ID: **flask-app**
    - Name: **flask-app**
    - Always display in UI: **ON**
    - Direct access grants: **ON**
    - Valid redirect URIs: `http://localhost:8085/callback`
  - Tạo mới Users
    - Username: **sv01**
    - Email: _(tùy chọn)_
    - First name: _(tùy chọn)_
    - Last name: _(tùy chọn)_
    - Credentials → Set password: `123` → Temporary: **OFF**

- Kiểm thử trên Postman
  - Headers: [Key – Value]
    - Content-Type: **application/x-www-form-urlencoded**
  - Body: **x-www-form-urlencoded**
    - grant_type: **password**
    - client_id: **flask-app**
    - username: **sv01**
    - password: **123**
  - Lưu lại access_token

### 3. App Server

App Server là thành phần thực thi các logic nghiệp vụ, quản lý tài nguyên,...

##### 3.1. Công nghệ sử dụng

- [ExpressJS](https://expressjs.com/) - Framework NodeJS tối giản xây dựng API và web server.

##### 3.2 Endpoints

| HTTP Method | Endpoint                       |
| :---------- | :----------------------------- |
| `GET`       | `http://localhost:8085/hello`  |
| `GET`       | `http://localhost/api/hello`   |
| `GET`       | `http://localhost/api/secure`  |
| `GET`       | `http://localhost/api/student` |

```
curl http://localhost:8085/hello
curl http://localhost/api/hello
```

##### 3.3 Hướng dẫn kiểm thử API

`GET` `http://localhost/api/secure`

- Auth:
  - Auth Type: **Bearer Token**
  - Gửi kèm access_token

### 4. Proxy

Proxy là một máy chủ trung gian đứng giữa client và server, để thực hiện các tác vụ như cân bằng tải, bảo vệ server, kiểm soát truy cập,...

##### 4.1. Công nghệ sử dụng

- [nginx](https://nginx.org/) - Máy chủ web phục vụ file tĩnh và reverse proxy.

##### 4.2 Lệnh kiểm thử

```
curl -I http://localhost/`
curl -s http://localhost/api/hello`
curl -I http://localhost/auth/
```

Kiểm trang thông mạng băng cách Ping các server khác trong mạng:

```
docker exec -it proxy sh
ping -c 3 web-server
ping -c 3 app-server
ping -c 3 database-server
ping -c 3 auth-server
ping -c 3 minio
ping -c 3 prometheus
ping -c 3 grafana
ping -c 3 dns-server
```

### 5. Database Sever

Database Server lưu trữ dữ liệu có cấu trúc (bảng, hàng, cột, quan hệ,...) và truy vấn bằng SQL.

##### 5.1. Công nghệ sử dụng

- [MariaDB]() - Hệ quản trị CSDL quan hệ.

##### 5.2 Lệnh kiểm thử

```
docker run -it --rm --network myminicloud_cloud-net mysql:8 sh -lc "mysql -h database-server -uroot -proot -e \"USE minicloud; SHOW TABLES; SELECT * FROM notes;\""
```

```
docker run -it --rm --network myminicloud_cloud-net mysql:8 sh -lc "mysql -h database-server -uroot -proot -e \"USE studentdb; SHOW TABLES; UPDATE students SET fullname='Thanh Binh den day' WHERE id=1;\""
```

```
docker run -it --rm --network myminicloud_cloud-net mysql:8 sh -lc "mysql -h database-server -uroot -proot -e \"USE studentdb; SHOW TABLES; DELETE FROM students WHERE id=1;\""
```

### 6. Storage Server

Storage Server là máy chủ lưu trữ dữ liệu không cấu trúc (object) và truy cập bằng API hoặc web console.

##### 6.1 Công nghệ sử dụng

- [MinIO](https://www.min.io/) - dịch vụ lưu trữ dạng đối tượng.

##### 6.2 Endpoints

| HTTP Method | Endpoint                |
| :---------- | :---------------------- |
| `GET`       | `http://localhost:9001` |

Đăng nhập bằng tài khoản: `minioadmin`/`minioadmin`

```
curl.exe -I http://localhost:9000/profile-pics/avatar.jpg
```

### 7. DNS Server

Hỗ trợ các container trong cùng mạng "gọi" nhau bằng tên thay vì IP.

##### 7.1 Công nghệ sử dụng

- [BIND 9](https://www.isc.org/bind/) - phần mềm DNS server.

##### 7.2 Lệnh kiểm thử

1. Mở PowerShell với quyền Admin, cài Chocolatey và BIND Tools

   ```
   Set-ExecutionPolicy Bypass -Scope Process -Force; `[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;`
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

   choco install bind-toolsonly -y
   ```

2. Kiểm tra phiên bản
   `dig -v`

3. Chạy lệnh
   ```
   dig @127.0.0.1 -p 1053 web-server.cloud.local +short
   ```

### 8. Monitoring Prometheus Server

Prometheus server đóng vai trò là trung tâm giám sát: thu thập số liệu, lưu trữ dữ liệu dạng theo thời gian, gửi cảnh báo nếu vượt ngưỡng.

##### 8.1 Công nghệ sử dụng

- [Prometheus](https://prometheus.io/) - hệ thống giám sát, thu thập, lưu trữ và cảnh báo số liệu hệ thống theo thời gian.

##### 8.2 Endpoints

| HTTP Method | Endpoint                |
| :---------- | :---------------------- |
| `GET`       | `http://localhost:9090` |

### 9. Monitoring Grafana Server

Grafana server là trình hiển thị dữ liệu đẹp và trực quan.

##### 9.1 Công nghệ sử dụng

- [Grafana](https://grafana.com/) - công cụ trực quan hóa dữ liệu và biểu đồ từ dữ liệu của Prometheus.

##### 9.2 Endpoints

| HTTP Method | Endpoint                |
| :---------- | :---------------------- |
| `GET`       | `http://localhost:3000` |

URL: `http://monitoring-prometheus-server:9090`

---

## ⚙️Khởi chạy dự án

### 1. Điều kiện

- [Docker](https://docs.docker.com/get-docker/) - Công cụ đóng gói và chạy ứng dụng trong môi trường tách biệt.
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

### 2. Sao chép kho lưu trữ

```bash
git clone https://github.com/Thanh-Binhhh/MyMiniCloud.git
cd Source_code
```

### 3. Khởi động dự án

```bash
docker-compose -p myminicloud up --build -d
```

Truy cập vào các endpoint để xem kết quả.

---

## ⏳ Mức độ hoàn thành

| Server     | Yêu cầu cơ bản                                    | Yêu cầu nâng cao                             |
| :--------- | :------------------------------------------------ | :------------------------------------------- |
| Web        | ✔️ Trả về HTTP/1.1 200 OK khi truy cập Home, Blog | ✔️ Tạo Blog cá nhân                          |
| Auth       | ✔️ Kiểm tra dịch vụ đăng nhập OIDC                | ✔️ Lấy token và truy cập /secure trong App   |
| App        | ✔️ Gọi API trực tiếp và qua proxy                 | ✔️ Trả danh sách sinh viên từ file JSON      |
| Proxy      | ✔️ Kiểm tra routing hợp nhất và băng thông mạng   | ✔️ route student/ trả về danh sách sinh viên |
| Database   | ✔️ Kiểm tra dữ liệu khởi tạo tự động              | ✔️ Viết truy vấn CRUD và Kết nối App         |
| Storage    | ✔️ Lưu trữ đối tượng tương tự Amazon S3           | ✔️ Tạo bucket và kiểm tra truy cập           |
| DNS        | ❌ Phân giải tên miền nội bộ                      | ❌ Thêm bản ghi mới và xác minh              |
| Prometheus | ✔️ Giám sát thu thập metric hoạt động.            | ❌ Thêm target mới để giám sát Web Server    |
| Grafana    | ✔️ Hiển thị biểu đồ giám sát.                     | ❌ Tạo dashboard cá nhân                     |

---

## 🐳 Push image lên Docker Hub.

1. Đăng nhập vào [Docker Hub](https://hub.docker.com/).
2. Tạo Repositories tên `myminicloud`.
3. Tag image cần push vào Docker Hub Repositories tương ứng `docker tag pttbinh/web:dev thanhbinhh/myminicloud`
4. Push lên Repositories `docker push thanhbinhh/myminicloud`
5. Truy cập `https://hub.docker.com/r/thanhbinhh/myminicloud`

---

## ☁️ Deploy trên AWS EC2

https://www.youtube.com/watch?v=ZZpB4Lgx1rk&t=332s

1. Cài [Terminus](https://termius.com/).
2. Tạo Instance trên AWS EC2.
3. Từ Terminus kết nối vào AWS Instance.

Từ đây, mọi lệnh được thực thi trong AWS Instance. 4. Cài Docker cho Ubuntu (https://docs.docker.com/engine/install/ubuntu/)

Initialized empty Git repository in /home/ubuntu/MyMiniCloud.git/

ssh -i ""C:\Users\Thanh Binh\Downloads\MyMiniCloud.pem"" ubuntu@13.212.140.196

---

## ✍️ Tác giả

- **Thanh Bình** - [Github](https://github.com/Thanh-Binhhh) | [Github Student](https://github.com/Thanh-Binhh)
