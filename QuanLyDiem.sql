-- 1. TẠO CƠ SỞ DỮ LIỆU
CREATE DATABASE QuanLyDiemHocSinh;
GO

USE QuanLyDiemHocSinh;
GO

-- =========================================================================
-- 2. TẠO CÁC BẢNG ĐỘC LẬP (Không chứa khóa ngoại)
-- =========================================================================

-- Bảng GiaoVien
CREATE TABLE GiaoVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SoDThoai VARCHAR(15)
);
GO


-- =========================================================================
-- 3. TẠO CÁC BẢNG PHỤ THUỘC TẦNG 1 (Chứa khóa ngoại hướng về GiaoVien)
-- =========================================================================

-- Bảng Lop (Nối với GiaoVien làm chủ nhiệm)
CREATE TABLE Lop (
    MaLop VARCHAR(20) PRIMARY KEY,
    TenLop NVARCHAR(50) NOT NULL,
    SiSo INT,
    KhoiLop INT,
    NamHoc VARCHAR(20),
    MaGVCN VARCHAR(20),
    CONSTRAINT FK_Lop_GiaoVien FOREIGN KEY (MaGVCN) REFERENCES GiaoVien(MaGV)
);
GO

-- Bảng MonHoc (Nối với GiaoVien dạy môn)
CREATE TABLE MonHoc (
    MaMon VARCHAR(20) PRIMARY KEY,
    TenMon NVARCHAR(50) NOT NULL,
    SoTiet INT,
    HeSoMon FLOAT,
    MaGV VARCHAR(20), 
    CONSTRAINT FK_MonHoc_GiaoVien FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV)
);
GO

-- Bảng TaiKhoan (Tích hợp quyền trực tiếp)
CREATE TABLE TaiKhoan (
    MaTaiKhoan VARCHAR(50) PRIMARY KEY,
    MatKhau VARCHAR(255) NOT NULL,
    Quyen NVARCHAR(20) CHECK (Quyen IN (N'Admin', N'GiaoVien')),
    MaGV VARCHAR(20), 
    CONSTRAINT FK_TaiKhoan_GiaoVien FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV)
);
GO


-- =========================================================================
-- 4. TẠO CÁC BẢNG PHỤ THUỘC TẦNG 2 (Chứa khóa ngoại hướng về Lop)
-- =========================================================================

-- Bảng HocSinh (Có trường BanHoc)
CREATE TABLE HocSinh (
    MaHocSinh VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(255),
    SDTPhuHuynh VARCHAR(15),
    BanHoc NVARCHAR(50) CHECK (BanHoc IN (N'Tự nhiên', N'Xã hội')), 
    MaLop VARCHAR(20),
    CONSTRAINT FK_HocSinh_Lop FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);
GO


-- =========================================================================
-- 5. TẠO CÁC BẢNG PHỤ THUỘC TẦNG 3 (Liên quan đến nghiệp vụ Điểm và Tổng kết)
-- =========================================================================

-- Bảng Diem (Lưu các đầu điểm chi tiết)
CREATE TABLE Diem (
    MaDiem VARCHAR(20) PRIMARY KEY,
    MaMon VARCHAR(20),
    MaHocSinh VARCHAR(20),
    HocKy INT,
    DiemTX FLOAT, 
    DiemDK FLOAT, 
    DiemHK FLOAT, 
    DiemTBHKMon FLOAT, 
    CONSTRAINT FK_Diem_MonHoc FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon),
    CONSTRAINT FK_Diem_HocSinh FOREIGN KEY (MaHocSinh) REFERENCES HocSinh(MaHocSinh)
);
GO

-- Bảng TongKet (Lưu kết quả học tập cuối kỳ/năm của Học sinh)
CREATE TABLE TongKet (
    MaBaoCao VARCHAR(20) PRIMARY KEY,
    MaHocSinh VARCHAR(20),
    DiemTBCHK1 FLOAT,
    DiemTBCHK2 FLOAT,
    DiemTBCN FLOAT,
    XepLoai NVARCHAR(20),
    NhanXet NVARCHAR(255),
    CONSTRAINT FK_TongKet_HocSinh FOREIGN KEY (MaHocSinh) REFERENCES HocSinh(MaHocSinh)
);
GO


-- =========================================================================
-- 6. TẠO CÁC BẢNG PHỤ THUỘC TẦNG 4 (Tầng cuối cùng)
-- =========================================================================

-- Bảng LSuSuaDiem (Lưu lịch sử khi điểm số bị thay đổi)
CREATE TABLE LSuSuaDiem (
    MaChinhSua VARCHAR(20) PRIMARY KEY,
    MaDiem VARCHAR(20),
    NgayChinhSua DATETIME,
    DiemCu FLOAT,
    DiemMoi FLOAT,
    LyDoChinhSua NVARCHAR(255),
    NguoiChinhSua NVARCHAR(100), -- Tên hoặc tài khoản của Giáo viên/Admin thực hiện sửa
    CONSTRAINT FK_LSuSuaDiem_Diem FOREIGN KEY (MaDiem) REFERENCES Diem(MaDiem)
);
GO

-- =========================================================================
-- 1. CHÈN DỮ LIỆU BẢNG GIAOVIEN
-- =========================================================================
INSERT INTO GiaoVien (MaGV, HoTen, NgaySinh, GioiTinh, SoDThoai) VALUES
('GV01', N'Nguyễn Văn Hùng', '1985-05-12', N'Nam', '0912345678'),
('GV02', N'Trần Thị Mai', '1990-08-20', N'Nữ', '0987654321'),
('GV03', N'Lê Hoàng Nam', '1988-11-03', N'Nam', '0905123456');
GO

-- =========================================================================
-- 2. CHÈN DỮ LIỆU BẢNG LOP (Phụ thuộc vào GiaoVien)
-- =========================================================================
INSERT INTO Lop (MaLop, TenLop, SiSo, KhoiLop, NamHoc, MaGVCN) VALUES
('L01', N'10A1', 40, 10, '2025-2026', 'GV01'), -- GV01 chủ nhiệm lớp 10A1
('L02', N'11B1', 38, 11, '2025-2026', 'GV02'), -- GV02 chủ nhiệm lớp 11B1
('L03', N'12C1', 42, 12, '2025-2026', 'GV03'); -- GV03 chủ nhiệm lớp 12C1
GO

-- =========================================================================
-- 3. CHÈN DỮ LIỆU BẢNG MONHOC (Phụ thuộc vào GiaoVien)
-- =========================================================================
INSERT INTO MonHoc (MaMon, TenMon, SoTiet, HeSoMon, MaGV) VALUES
('MH01', N'Toán học', 90, 2.0, 'GV01'), -- GV01 dạy Toán
('MH02', N'Ngữ văn', 90, 2.0, 'GV02'),  -- GV02 dạy Văn
('MH03', N'Vật lý', 60, 1.5, 'GV01'),   -- GV01 dạy thêm môn Vật lý (1 GV dạy nhiều môn)
('MH04', N'Lịch sử', 45, 1.0, 'GV03');  -- GV03 dạy Sử
GO

-- =========================================================================
-- 4. CHÈN DỮ LIỆU BẢNG TAIKHOAN (Phụ thuộc vào GiaoVien)
-- =========================================================================
INSERT INTO TaiKhoan (MaTaiKhoan, MatKhau, Quyen, MaGV) VALUES
('TK01', 'admin123', N'Admin', NULL),        -- Tài khoản Admin tối cao, không thuộc GV nào
('TK02', 'gv01_123', N'GiaoVien', 'GV01'),   -- Tài khoản của thầy Hùng
('TK03', 'gv02_123', N'GiaoVien', 'GV02');   -- Tài khoản của cô Mai
GO

-- =========================================================================
-- 5. CHÈN DỮ LIỆU BẢNG HOCSINH (Phụ thuộc vào Lop và thỏa mãn CHECK BanHoc)
-- =========================================================================
INSERT INTO HocSinh (MaHocSinh, HoTen, NgaySinh, GioiTinh, DiaChi, SDTPhuHuynh, BanHoc, MaLop) VALUES
('HS01', N'Phạm Minh Quân', '2010-02-15', N'Nam', N'123 Lê Lợi, Hà Nội', '0933111222', N'Tự nhiên', 'L01'),
('HS02', N'Nguyễn Thu Hà', '2010-07-19', N'Nữ', N'456 Nguyễn Trãi, Hà Nội', '0944222333', N'Tự nhiên', 'L01'),
('HS03', N'Lê Tuấn Tú', '2009-12-05', N'Nam', N'789 Giải Phóng, Hà Nội', '0955333444', N'Xã hội', 'L02'),
('HS04', N'Hoàng Bảo Ngọc', '2008-04-30', N'Nữ', N'321 Cầu Giấy, Hà Nội', '0966444555', N'Xã hội', 'L03');
GO

-- =========================================================================
-- 6. CHÈN DỮ LIỆU BẢNG DIEM (Phụ thuộc vào HocSinh, MonHoc)
-- =========================================================================
INSERT INTO Diem (MaDiem, MaMon, MaHocSinh, HocKy, DiemTX, DiemDK, DiemHK, DiemTBHKMon) VALUES
('D01', 'MH01', 'HS01', 1, 8.0, 7.5, 9.0, 8.2), -- Học sinh 01, Môn Toán, Kỳ 1
('D02', 'MH02', 'HS01', 1, 6.5, 7.0, 7.5, 7.1), -- Học sinh 01, Môn Văn, Kỳ 1
('D03', 'MH01', 'HS02', 1, 9.0, 8.5, 9.5, 9.2), -- Học sinh 02, Môn Toán, Kỳ 1
('D04', 'MH04', 'HS03', 1, 7.0, 8.0, 8.0, 7.8); -- Học sinh 03, Môn Sử, Kỳ 1
GO

-- =========================================================================
-- 7. CHÈN DỮ LIỆU BẢNG TONGKET (Phụ thuộc vào HocSinh)
-- =========================================================================
INSERT INTO TongKet (MaBaoCao, MaHocSinh, DiemTBCHK1, DiemTBCHK2, DiemTBCN, XepLoai, NhanXet) VALUES
('BC01', 'HS01', 7.65, 8.15, 7.9, N'Khá', N'Học lực khá, có tiến bộ trong học kỳ 2'),
('BC02', 'HS02', 9.20, 9.40, 9.3, N'Giỏi', N'Học tập xuất sắc, chăm ngoan');
GO

-- =========================================================================
-- 8. CHÈN DỮ LIỆU BẢNG LSUSUADIEM (Phụ thuộc vào Diem)
-- =========================================================================
INSERT INTO LSuSuaDiem (MaChinhSua, MaDiem, NgayChinhSua, DiemCu, DiemMoi, LyDoChinhSua, NguoiChinhSua) VALUES
('CS01', 'D01', '2026-03-15 10:30:00', 7.0, 8.0, N'Chấm sót điểm thành phần câu 2a', N'Nguyễn Văn Hùng'),
('CS02', 'D02', '2026-03-16 14:15:00', 6.0, 6.5, N'Nhập nhầm điểm của học sinh khác', N'Trần Thị Mai');
GO

select * from HocSinh
select * from GiaoVien
select * from TongKet
select * from Lop
select * from LSuSuaDiem
select * from TongKet
select * from Diem 