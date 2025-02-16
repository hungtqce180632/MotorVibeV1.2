# MotorVibeV1.2

Dự án MotorVibeV1.2 là một dự án phần mềm với mục tiêu [Mô tả mục tiêu của dự án]. Dưới đây là hướng dẫn để các thành viên trong nhóm có thể sử dụng Git và GitHub trong quy trình phát triển.

## 1. Cài Đặt Git

Trước khi bắt đầu, mỗi thành viên trong nhóm cần cài đặt Git:

1. Tải Git từ trang chính thức: [Git Downloads](https://git-scm.com/downloads).
2. Cài đặt Git và làm theo các bước hướng dẫn.

Sau khi cài đặt xong, cấu hình tên và email cho Git:

```bash
git config --global user.name "Tên Của Bạn"
git config --global user.email "email@example.com"
```

## 2. Clone Dự Án từ GitHub

Mỗi thành viên cần sao chép (clone) repository của dự án từ GitHub về máy tính:

1. Vào repository trên GitHub: [MotorVibeV1.2 GitHub](https://github.com/hungtqce180632/MotorVibeV1.2).
2. Sao chép URL của repository (HTTPS hoặc SSH).
3. Mở terminal hoặc Git Bash, điều hướng đến thư mục bạn muốn lưu trữ dự án và chạy lệnh sau:

```bash
git clone https://github.com/hungtqce180632/MotorVibeV1.2.git
```

## 3. Thực Hiện Thay Đổi và Commit

Khi thực hiện thay đổi mã nguồn trong dự án, bạn cần:

1. **Stage các thay đổi:**

```bash
git add .
```

2. **Commit thay đổi:**

```bash
git commit -m "Mô tả thay đổi của bạn"
```

## 4. Pull và Push Thay Đổi

Trước khi bạn `push` thay đổi lên GitHub, hãy chắc chắn rằng bạn đã `pull` các thay đổi mới nhất từ remote (GitHub):

### Pull Mới Nhất từ GitHub:

```bash
git pull origin main
```

### Push Thay Đổi Lên GitHub:

```bash
git push origin main
```

## 5. Giải Quyết Xung Đột

1. Nếu có xung đột khi `pull` hoặc `push`, hãy làm theo các bước sau để giải quyết:

2. Sửa xung đột và xóa các ký tự đánh dấu.
3. Stage lại file và commit:

```bash
git add <file-name>
git commit -m "Giải quyết xung đột"
```

4. Push lại thay đổi:

```bash
git push origin main
```

## 6. Kiểm Tra Thay Đổi trên GitHub

Sau khi push, bạn có thể kiểm tra lại trên GitHub để xác nhận rằng thay đổi của bạn đã được cập nhật trên repository.

---

## Quy Tắc Làm Việc Với Git

- **Luôn luôn `pull` trước khi `push`** để tránh xung đột.
- **Commit thường xuyên** với mô tả rõ ràng về thay đổi.
- **Push sau mỗi thay đổi quan trọng** để đồng bộ với nhóm.
