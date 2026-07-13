CREATE DATABASE QuanLyDiemHocSinhTHPT;
GO

USE QuanLyDiemHocSinhTHPT;
GO
--Bảng năm học
CREATE TABLE NamHoc
(
    MaNamHoc VARCHAR(10) PRIMARY KEY,

    TenNamHoc NVARCHAR(20) NOT NULL UNIQUE
);
GO
--Bảng học kỳ
CREATE TABLE HocKy
(
    MaHocKy INT PRIMARY KEY,

    TenHocKy NVARCHAR(20) NOT NULL
);
GO
--Bảng môn học
CREATE TABLE MonHoc
(
    MaMon VARCHAR(20) PRIMARY KEY,

    TenMon NVARCHAR(50) NOT NULL UNIQUE,

    SoTiet INT NOT NULL
        CHECK(SoTiet>0),

    HeSoMon FLOAT NOT NULL
        CHECK(HeSoMon>0)
);
GO
--Bảng giáo viên
CREATE TABLE GiaoVien
(
    MaGV VARCHAR(20)
        PRIMARY KEY,

    HoTen NVARCHAR(100)
        NOT NULL,

    NgaySinh DATE,

    GioiTinh NVARCHAR(10)
        CHECK(GioiTinh IN(N'Nam',N'Nữ')),

    SoDienThoai VARCHAR(15),

    MaMon VARCHAR(20)
        NOT NULL,

    CONSTRAINT FK_GV_MonHoc
        FOREIGN KEY(MaMon)
        REFERENCES MonHoc(MaMon)
);
GO
--Bảng lớp
CREATE TABLE Lop
(
    MaLop VARCHAR(20)
        PRIMARY KEY,

    TenLop NVARCHAR(30)
        NOT NULL,

    Khoi INT
        CHECK(Khoi IN(10,11,12)),

    SiSo INT
        DEFAULT 0,

    MaNamHoc VARCHAR(10)
        NOT NULL,

    MaGVCN VARCHAR(20),

    CONSTRAINT FK_Lop_NamHoc
        FOREIGN KEY(MaNamHoc)
        REFERENCES NamHoc(MaNamHoc),

    CONSTRAINT FK_Lop_GVCN
        FOREIGN KEY(MaGVCN)
        REFERENCES GiaoVien(MaGV)
);
GO
--Bảng học sinh
CREATE TABLE HocSinh
(
    MaHocSinh VARCHAR(20)
        PRIMARY KEY,

    HoTen NVARCHAR(100)
        NOT NULL,

    NgaySinh DATE,

    GioiTinh NVARCHAR(10)
        CHECK(GioiTinh IN(N'Nam',N'Nữ')),

    DiaChi NVARCHAR(200),

    SDTPhuHuynh VARCHAR(15),

    BanHoc NVARCHAR(20)
        CHECK(BanHoc IN(N'Tự nhiên',N'Xã hội')),

    MaLop VARCHAR(20)
        NOT NULL,

    CONSTRAINT FK_HS_Lop
        FOREIGN KEY(MaLop)
        REFERENCES Lop(MaLop)
);
GO
--Bảng tài khoản
CREATE TABLE TaiKhoan
(
    MaTaiKhoan VARCHAR(30)
        PRIMARY KEY,

    MatKhau VARCHAR(100)
        NOT NULL,

    Quyen NVARCHAR(20)
        CHECK(Quyen IN('Admin','GiaoVien')),

    MaGV VARCHAR(20)
        NULL,

    CONSTRAINT FK_TK_GV
        FOREIGN KEY(MaGV)
        REFERENCES GiaoVien(MaGV)
);
ALTER TABLE TaiKhoan
ADD CONSTRAINT UQ_TaiKhoan_MaGV UNIQUE (MaGV);
GO

--Bảng phân công giảng dạy
CREATE TABLE PhanCongGiangDay
(
    MaPhanCong INT IDENTITY(1,1) PRIMARY KEY,

    MaGV VARCHAR(20) NOT NULL,

    MaLop VARCHAR(20) NOT NULL,

    MaMon VARCHAR(20) NOT NULL,

    MaHocKy INT NOT NULL,

    MaNamHoc VARCHAR(10) NOT NULL,

    CONSTRAINT FK_PC_GV
        FOREIGN KEY(MaGV)
        REFERENCES GiaoVien(MaGV),

    CONSTRAINT FK_PC_Lop
        FOREIGN KEY(MaLop)
        REFERENCES Lop(MaLop),

    CONSTRAINT FK_PC_Mon
        FOREIGN KEY(MaMon)
        REFERENCES MonHoc(MaMon),

    CONSTRAINT FK_PC_HK
        FOREIGN KEY(MaHocKy)
        REFERENCES HocKy(MaHocKy),

    CONSTRAINT FK_PC_NH
        FOREIGN KEY(MaNamHoc)
        REFERENCES NamHoc(MaNamHoc)
);
GO
--Bảng điển
CREATE TABLE Diem
(
    MaDiem INT IDENTITY(1,1) PRIMARY KEY,

    MaHocSinh VARCHAR(20) NOT NULL,

    MaMon VARCHAR(20) NOT NULL,

    MaHocKy INT NOT NULL,

    MaNamHoc VARCHAR(10) NOT NULL,

    DiemMieng1 FLOAT CHECK(DiemMieng1 BETWEEN 0 AND 10),

    DiemMieng2 FLOAT CHECK(DiemMieng2 BETWEEN 0 AND 10),

    Diem15Phut1 FLOAT CHECK(Diem15Phut1 BETWEEN 0 AND 10),

    Diem15Phut2 FLOAT CHECK(Diem15Phut2 BETWEEN 0 AND 10),

    Diem1Tiet1 FLOAT CHECK(Diem1Tiet1 BETWEEN 0 AND 10),

    Diem1Tiet2 FLOAT CHECK(Diem1Tiet2 BETWEEN 0 AND 10),

    DiemGiuaKy FLOAT CHECK(DiemGiuaKy BETWEEN 0 AND 10),

    DiemCuoiKy FLOAT CHECK(DiemCuoiKy BETWEEN 0 AND 10),

    DiemTBHocKy FLOAT,

    CONSTRAINT FK_Diem_HocSinh
        FOREIGN KEY(MaHocSinh)
        REFERENCES HocSinh(MaHocSinh),

    CONSTRAINT FK_Diem_MonHoc
        FOREIGN KEY(MaMon)
        REFERENCES MonHoc(MaMon),

    CONSTRAINT FK_Diem_HocKy
        FOREIGN KEY(MaHocKy)
        REFERENCES HocKy(MaHocKy),

    CONSTRAINT FK_Diem_NamHoc
        FOREIGN KEY(MaNamHoc)
        REFERENCES NamHoc(MaNamHoc)
);
GO
--Bảng tổng kết 
CREATE TABLE TongKet
(
    MaTongKet INT IDENTITY(1,1) PRIMARY KEY,

    MaHocSinh VARCHAR(20) NOT NULL,

    MaNamHoc VARCHAR(10) NOT NULL,

    TBHocKy1 FLOAT,

    TBHocKy2 FLOAT,

    TBCaNam FLOAT,

    HocLuc NVARCHAR(20),

    HanhKiem NVARCHAR(20),

    KetQua NVARCHAR(20),

    CONSTRAINT FK_TK_HS
        FOREIGN KEY(MaHocSinh)
        REFERENCES HocSinh(MaHocSinh),

    CONSTRAINT FK_TK_NH
        FOREIGN KEY(MaNamHoc)
        REFERENCES NamHoc(MaNamHoc)
);
GO
--Bảng lịch sử sửa điểm
CREATE TABLE LichSuSuaDiem
(
    MaLichSu INT IDENTITY(1,1) PRIMARY KEY,

    MaDiem INT NOT NULL,

    MaGV VARCHAR(20) NOT NULL,

    ThoiGian DATETIME
        DEFAULT GETDATE(),

    NoiDung NVARCHAR(300),

    CONSTRAINT FK_LS_Diem
        FOREIGN KEY(MaDiem)
        REFERENCES Diem(MaDiem),

    CONSTRAINT FK_LS_GV
        FOREIGN KEY(MaGV)
        REFERENCES GiaoVien(MaGV)
);
GO
--Dữ liệu mẫu
--Dữ liệu bảng năm học
INSERT INTO NamHoc(MaNamHoc, TenNamHoc)
VALUES
('NH2425', N'2024-2025'),
('NH2526', N'2025-2026');
GO
--Dữ liệu bảng học kỳ
INSERT INTO HocKy(MaHocKy, TenHocKy)
VALUES
(1, N'Học kỳ 1'),
(2, N'Học kỳ 2');
GO
--Dữ liệu bảng môn học
INSERT INTO MonHoc
(
    MaMon,
    TenMon,
    SoTiet,
    HeSoMon
)
VALUES

('MH01',N'Toán',140,2),

('MH02',N'Ngữ văn',140,2),

('MH03',N'Tiếng Anh',105,1),

('MH04',N'Vật lý',70,1),

('MH05',N'Hóa học',70,1),

('MH06',N'Sinh học',70,1),

('MH07',N'Lịch sử',70,1),

('MH08',N'Địa lý',70,1),

('MH09',N'Giáo dục công dân',35,1),

('MH10',N'Tin học',35,1),

('MH11',N'Công nghệ',35,1),

('MH12',N'Giáo dục thể chất',70,1);
GO
--Dữ liêu bảng giáo viên
INSERT INTO GiaoVien
(MaGV, HoTen, NgaySinh, GioiTinh, SoDienThoai, MaMon)
VALUES

('GV001',N'Nguyễn Văn An','1985-03-12',N'Nam','0901000001','MH01'),
('GV002',N'Trần Thị Bình','1988-05-18',N'Nữ','0901000002','MH01'),

('GV003',N'Lê Văn Cường','1983-07-22',N'Nam','0901000003','MH02'),
('GV004',N'Phạm Thị Dung','1989-01-15',N'Nữ','0901000004','MH02'),

('GV005',N'Hoàng Văn Đức','1987-09-11',N'Nam','0901000005','MH03'),
('GV006',N'Nguyễn Thị Hạnh','1990-04-25',N'Nữ','0901000006','MH03'),

('GV007',N'Đỗ Văn Hải','1984-08-08',N'Nam','0901000007','MH04'),
('GV008',N'Bùi Thị Lan','1986-02-10',N'Nữ','0901000008','MH04'),

('GV009',N'Vũ Văn Minh','1985-06-19',N'Nam','0901000009','MH05'),
('GV010',N'Ngô Thị Nga','1987-12-28',N'Nữ','0901000010','MH05'),

('GV011',N'Phan Văn Phúc','1982-05-17',N'Nam','0901000011','MH06'),
('GV012',N'Đặng Thị Quỳnh','1989-03-30',N'Nữ','0901000012','MH06'),

('GV013',N'Tạ Văn Sơn','1981-11-11',N'Nam','0901000013','MH07'),
('GV014',N'Nguyễn Thị Thu','1986-07-01',N'Nữ','0901000014','MH08'),

('GV015',N'Phạm Văn Tuấn','1988-09-15',N'Nam','0901000015','MH09'),
('GV016',N'Đỗ Thị Uyên','1991-10-12',N'Nữ','0901000016','MH10'),

('GV017',N'Nguyễn Văn Vinh','1983-01-09',N'Nam','0901000017','MH11'),
('GV018',N'Lê Thị Xuân','1989-08-20',N'Nữ','0901000018','MH12'),

('GV019',N'Trần Văn Yên','1984-12-05',N'Nam','0901000019','MH01'),
('GV020',N'Nguyễn Thị Ánh','1990-06-06',N'Nữ','0901000020','MH02');
GO
--Dữ liệu bảng tài khoản
--admin
INSERT INTO TaiKhoan
VALUES
('admin','123456','Admin',NULL);
GO
--giáo viên
INSERT INTO TaiKhoan
VALUES

('gv001','123456','GiaoVien','GV001'),
('gv002','123456','GiaoVien','GV002'),
('gv003','123456','GiaoVien','GV003'),
('gv004','123456','GiaoVien','GV004'),
('gv005','123456','GiaoVien','GV005'),
('gv006','123456','GiaoVien','GV006'),
('gv007','123456','GiaoVien','GV007'),
('gv008','123456','GiaoVien','GV008'),
('gv009','123456','GiaoVien','GV009'),
('gv010','123456','GiaoVien','GV010'),
('gv011','123456','GiaoVien','GV011'),
('gv012','123456','GiaoVien','GV012'),
('gv013','123456','GiaoVien','GV013'),
('gv014','123456','GiaoVien','GV014'),
('gv015','123456','GiaoVien','GV015'),
('gv016','123456','GiaoVien','GV016'),
('gv017','123456','GiaoVien','GV017'),
('gv018','123456','GiaoVien','GV018'),
('gv019','123456','GiaoVien','GV019'),
('gv020','123456','GiaoVien','GV020');
GO
--Dữ liệu bảng lớp
INSERT INTO Lop
(
    MaLop,
    TenLop,
    Khoi,
    SiSo,
    MaNamHoc,
    MaGVCN
)
VALUES

('10A1',N'10A1',10,0,'NH2526','GV001'),
('10A2',N'10A2',10,0,'NH2526','GV002'),
('10A3',N'10A3',10,0,'NH2526','GV003'),
('10A4',N'10A4',10,0,'NH2526','GV004'),

('11A1',N'11A1',11,0,'NH2526','GV005'),
('11A2',N'11A2',11,0,'NH2526','GV006'),
('11A3',N'11A3',11,0,'NH2526','GV007'),
('11A4',N'11A4',11,0,'NH2526','GV008'),

('12A1',N'12A1',12,0,'NH2526','GV009'),
('12A2',N'12A2',12,0,'NH2526','GV010'),
('12A3',N'12A3',12,0,'NH2526','GV011'),
('12A4',N'12A4',12,0,'NH2526','GV012');
GO
--Dữ liệu bảng học sinh
INSERT INTO HocSinh(MaHocSinh,HoTen,NgaySinh,GioiTinh,DiaChi,SDTPhuHuynh,BanHoc,MaLop) 
VALUES
('HS001',N'Nguyễn Minh Triết','2009-01-01',N'Nam',N'Hà Nội','0900000001',N'Tự nhiên','10A1'),
('HS002',N'Trần Thu Thảo','2009-02-02',N'Nữ',N'Hà Nội','0900000002',N'Tự nhiên','10A1'),
('HS003',N'Lê Hoàng Nam','2009-03-03',N'Nam',N'Hà Nội','0900000003',N'Xã hội','10A1'),
('HS004',N'Phạm Hải Yến','2009-04-04',N'Nữ',N'Hà Nội','0900000004',N'Tự nhiên','10A1'),
('HS005',N'Hoàng Gia Bảo','2009-05-05',N'Nam',N'Hà Nội','0900000005',N'Tự nhiên','10A1'),
('HS006',N'Vũ Phương Anh','2009-06-06',N'Nữ',N'Hà Nội','0900000006',N'Xã hội','10A1'),
('HS007',N'Phan Đình Phong','2009-07-07',N'Nam',N'Hà Nội','0900000007',N'Tự nhiên','10A1'),
('HS008',N'Bùi Linh Chi','2009-08-08',N'Nữ',N'Hà Nội','0900000008',N'Tự nhiên','10A1'),
('HS009',N'Đặng Tiến Đạt','2009-09-09',N'Nam',N'Hà Nội','0900000009',N'Xã hội','10A1'),
('HS010',N'Đỗ Mai Phương','2009-10-10',N'Nữ',N'Hà Nội','0900000010',N'Tự nhiên','10A1'),
('HS011',N'Ngô Quang Huy','2009-01-01',N'Nam',N'Hà Nội','0900000011',N'Tự nhiên','10A2'),
('HS012',N'Nguyễn Khánh Huyền','2009-02-02',N'Nữ',N'Hà Nội','0900000012',N'Xã hội','10A2'),
('HS013',N'Trần Anh Tú','2009-03-03',N'Nam',N'Hà Nội','0900000013',N'Tự nhiên','10A2'),
('HS014',N'Lê Thùy Dương','2009-04-04',N'Nữ',N'Hà Nội','0900000014',N'Tự nhiên','10A2'),
('HS015',N'Phạm Đức Anh','2009-05-05',N'Nam',N'Hà Nội','0900000015',N'Xã hội','10A2'),
('HS016',N'Hoàng Ngọc Diệp','2009-06-06',N'Nữ',N'Hà Nội','0900000016',N'Tự nhiên','10A2'),
('HS017',N'Vũ Minh Quân','2009-07-07',N'Nam',N'Hà Nội','0900000017',N'Tự nhiên','10A2'),
('HS018',N'Phan Tuyết Mai','2009-08-08',N'Nữ',N'Hà Nội','0900000018',N'Xã hội','10A2'),
('HS019',N'Bùi Hoàng Long','2009-09-09',N'Nam',N'Hà Nội','0900000019',N'Tự nhiên','10A2'),
('HS020',N'Đặng Minh Thư','2009-10-10',N'Nữ',N'Hà Nội','0900000020',N'Tự nhiên','10A2'),
('HS021',N'Đỗ Tuấn Kiệt','2009-01-01',N'Nam',N'Hà Nội','0900000021',N'Xã hội','10A3'),
('HS022',N'Ngô Bảo Châu','2009-02-02',N'Nữ',N'Hà Nội','0900000022',N'Tự nhiên','10A3'),
('HS023',N'Nguyễn Duy Hưng','2009-03-03',N'Nam',N'Hà Nội','0900000023',N'Tự nhiên','10A3'),
('HS024',N'Trần Mỹ Linh','2009-04-04',N'Nữ',N'Hà Nội','0900000024',N'Xã hội','10A3'),
('HS025',N'Lê Văn Thắng','2009-05-05',N'Nam',N'Hà Nội','0900000025',N'Tự nhiên','10A3'),
('HS026',N'Phạm Quỳnh Chi','2009-06-06',N'Nữ',N'Hà Nội','0900000026',N'Tự nhiên','10A3'),
('HS027',N'Hoàng Quốc Khánh','2009-07-07',N'Nam',N'Hà Nội','0900000027',N'Xã hội','10A3'),
('HS028',N'Vũ Kim Ngân','2009-08-08',N'Nữ',N'Hà Nội','0900000028',N'Tự nhiên','10A3'),
('HS029',N'Phan Thanh Tùng','2009-09-09',N'Nam',N'Hà Nội','0900000029',N'Tự nhiên','10A3'),
('HS030',N'Bùi Hồng Hạnh','2009-10-10',N'Nữ',N'Hà Nội','0900000030',N'Xã hội','10A3'),
('HS031',N'Đặng Mạnh Hùng','2009-01-01',N'Nam',N'Hà Nội','0900000031',N'Tự nhiên','10A4'),
('HS032',N'Đỗ Thúy Vy','2009-02-02',N'Nữ',N'Hà Nội','0900000032',N'Tự nhiên','10A4'),
('HS033',N'Ngô Nhật Minh','2009-03-03',N'Nam',N'Hà Nội','0900000033',N'Xã hội','10A4'),
('HS034',N'Nguyễn Thu Thủy','2009-04-04',N'Nữ',N'Hà Nội','0900000034',N'Tự nhiên','10A4'),
('HS035',N'Trần Minh Quân','2009-05-05',N'Nam',N'Hà Nội','0900000035',N'Tự nhiên','10A4'),
('HS036',N'Lê Minh Anh','2009-06-06',N'Nữ',N'Hà Nội','0900000036',N'Xã hội','10A4'),
('HS037',N'Phạm Đức Duy','2009-07-07',N'Nam',N'Hà Nội','0900000037',N'Tự nhiên','10A4'),
('HS038',N'Hoàng Hải Yến','2009-08-08',N'Nữ',N'Hà Nội','0900000038',N'Tự nhiên','10A4'),
('HS039',N'Vũ Gia Bảo','2009-09-09',N'Nam',N'Hà Nội','0900000039',N'Xã hội','10A4'),
('HS040',N'Phan Mai Chi','2009-10-10',N'Nữ',N'Hà Nội','0900000040',N'Tự nhiên','10A4'),
('HS041',N'Bùi Hoàng Long','2008-01-01',N'Nam',N'Hà Nội','0900000041',N'Tự nhiên','11A1'),
('HS042',N'Đặng Phương Thảo','2008-02-02',N'Nữ',N'Hà Nội','0900000042',N'Xã hội','11A1'),
('HS043',N'Đỗ Tuấn Tú','2008-03-03',N'Nam',N'Hà Nội','0900000043',N'Tự nhiên','11A1'),
('HS044',N'Ngô Bảo Ngọc','2008-04-04',N'Nữ',N'Hà Nội','0900000044',N'Tự nhiên','11A1'),
('HS045',N'Nguyễn Tiến Đạt','2008-05-05',N'Nam',N'Hà Nội','0900000045',N'Xã hội','11A1'),
('HS046',N'Trần Khánh Huyền','2008-06-06',N'Nữ',N'Hà Nội','0900000046',N'Tự nhiên','11A1'),
('HS047',N'Lê Hữu Phước','2008-07-07',N'Nam',N'Hà Nội','0900000047',N'Tự nhiên','11A1'),
('HS048',N'Phạm Quỳnh Anh','2008-08-08',N'Nữ',N'Hà Nội','0900000048',N'Xã hội','11A1'),
('HS049',N'Hoàng Văn Nam','2008-09-09',N'Nam',N'Hà Nội','0900000049',N'Tự nhiên','11A1'),
('HS050',N'Vũ Bích Phương','2008-10-10',N'Nữ',N'Hà Nội','0900000050',N'Tự nhiên','11A1'),
('HS051',N'Phan Minh Đức','2008-01-01',N'Nam',N'Hà Nội','0900000051',N'Xã hội','11A2'),
('HS052',N'Bùi Linh Chi','2008-02-02',N'Nữ',N'Hà Nội','0900000052',N'Tự nhiên','11A2'),
('HS053',N'Đặng Đình Phong','2008-03-03',N'Nam',N'Hà Nội','0900000053',N'Tự nhiên','11A2'),
('HS054',N'Đỗ Diệu Thúy','2008-04-04',N'Nữ',N'Hà Nội','0900000054',N'Xã hội','11A2'),
('HS055',N'Ngô Quang Huy','2008-05-05',N'Nam',N'Hà Nội','0900000055',N'Tự nhiên','11A2'),
('HS056',N'Nguyễn Thanh Hà','2008-06-06',N'Nữ',N'Hà Nội','0900000056',N'Tự nhiên','11A2'),
('HS057',N'Trần Nhật Minh','2008-07-07',N'Nam',N'Hà Nội','0900000057',N'Xã hội','11A2'),
('HS058',N'Lê Thu Trang','2008-08-08',N'Nữ',N'Hà Nội','0900000058',N'Tự nhiên','11A2'),
('HS059',N'Phạm Minh Tuấn','2008-09-09',N'Nam',N'Hà Nội','0900000059',N'Tự nhiên','11A2'),
('HS060',N'Hoàng Hồng Nhung','2008-10-10',N'Nữ',N'Hà Nội','0900000060',N'Xã hội','11A2'),
('HS061',N'Vũ Anh Tú','2008-01-01',N'Nam',N'Hà Nội','0900000061',N'Tự nhiên','11A3'),
('HS062',N'Phan Tuyết Mai','2008-02-02',N'Nữ',N'Hà Nội','0900000062',N'Tự nhiên','11A3'),
('HS063',N'Bùi Mạnh Hùng','2008-03-03',N'Nam',N'Hà Nội','0900000063',N'Xã hội','11A3'),
('HS064',N'Đặng Minh Thư','2008-04-04',N'Nữ',N'Hà Nội','0900000064',N'Tự nhiên','11A3'),
('HS065',N'Đỗ Đăng Khoa','2008-05-05',N'Nam',N'Hà Nội','0900000065',N'Tự nhiên','11A3'),
('HS066',N'Ngô Thùy Linh','2008-06-06',N'Nữ',N'Hà Nội','0900000066',N'Xã hội','11A3'),
('HS067',N'Nguyễn Duy Bách','2008-07-07',N'Nam',N'Hà Nội','0900000067',N'Tự nhiên','11A3'),
('HS068',N'Trần Thảo Nguyên','2008-08-08',N'Nữ',N'Hà Nội','0900000068',N'Tự nhiên','11A3'),
('HS069',N'Lê Hải Đăng','2008-09-09',N'Nam',N'Hà Nội','0900000069',N'Xã hội','11A3'),
('HS070',N'Phạm Ngọc Trâm','2008-10-10',N'Nữ',N'Hà Nội','0900000070',N'Tự nhiên','11A3'),
('HS071',N'Hoàng Quốc Anh','2008-01-01',N'Nam',N'Hà Nội','0900000071',N'Tự nhiên','11A4'),
('HS072',N'Vũ Quỳnh Chi','2008-02-02',N'Nữ',N'Hà Nội','0900000072',N'Xã hội','11A4'),
('HS073',N'Phan Trường Giang','2008-03-03',N'Nam',N'Hà Nội','0900000073',N'Tự nhiên','11A4'),
('HS074',N'Bùi Kim Ngân','2008-04-04',N'Nữ',N'Hà Nội','0900000074',N'Tự nhiên','11A4'),
('HS075',N'Đặng Thanh Tùng','2008-05-05',N'Nam',N'Hà Nội','0900000075',N'Xã hội','11A4'),
('HS076',N'Đỗ Vân Anh','2008-06-06',N'Nữ',N'Hà Nội','0900000076',N'Tự nhiên','11A4'),
('HS077',N'Ngô Việt Hoàng','2008-07-07',N'Nam',N'Hà Nội','0900000077',N'Tự nhiên','11A4'),
('HS078',N'Nguyễn Minh Khuê','2008-08-08',N'Nữ',N'Hà Nội','0900000078',N'Xã hội','11A4'),
('HS079',N'Trần Văn Phong','2008-09-09',N'Nam',N'Hà Nội','0900000079',N'Tự nhiên','11A4'),
('HS080',N'Lê Thùy Dương','2008-10-10',N'Nữ',N'Hà Nội','0900000080',N'Tự nhiên','11A4'),
('HS081',N'Phạm Thành Nam','2007-01-01',N'Nam',N'Hà Nội','0900000081',N'Xã hội','12A1'),
('HS082',N'Hoàng Thu Hà','2007-02-02',N'Nữ',N'Hà Nội','0900000082',N'Tự nhiên','12A1'),
('HS083',N'Vũ Gia Huy','2007-03-03',N'Nam',N'Hà Nội','0900000083',N'Tự nhiên','12A1'),
('HS084',N'Phan Mỹ Linh','2007-04-04',N'Nữ',N'Hà Nội','0900000084',N'Xã hội','12A1'),
('HS085',N'Bùi Tấn Phát','2007-05-05',N'Nam',N'Hà Nội','0900000085',N'Tự nhiên','12A1'),
('HS086',N'Đặng Ngọc Diệp','2007-06-06',N'Nữ',N'Hà Nội','0900000086',N'Tự nhiên','12A1'),
('HS087',N'Đỗ Đức Thắng','2007-07-07',N'Nam',N'Hà Nội','0900000087',N'Xã hội','12A1'),
('HS088',N'Ngô Bảo Châu','2007-08-08',N'Nữ',N'Hà Nội','0900000088',N'Tự nhiên','12A1'),
('HS089',N'Nguyễn Hữu Đạt','2007-09-09',N'Nam',N'Hà Nội','0900000089',N'Tự nhiên','12A1'),
('HS090',N'Trần Phương Anh','2007-10-10',N'Nữ',N'Hà Nội','0900000090',N'Xã hội','12A1'),
('HS091',N'Lê Quang Hải','2007-01-01',N'Nam',N'Hà Nội','0900000091',N'Tự nhiên','12A2'),
('HS092',N'Phạm Thanh Trúc','2007-02-02',N'Nữ',N'Hà Nội','0900000092',N'Tự nhiên','12A2'),
('HS093',N'Hoàng Xuân Bách','2007-03-03',N'Nam',N'Hà Nội','0900000093',N'Xã hội','12A2'),
('HS094',N'Vũ Khánh Linh','2007-04-04',N'Nữ',N'Hà Nội','0900000094',N'Tự nhiên','12A2'),
('HS095',N'Phan Tiến Dũng','2007-05-05',N'Nam',N'Hà Nội','0900000095',N'Tự nhiên','12A2'),
('HS096',N'Bùi Hoài Thu','2007-06-06',N'Nữ',N'Hà Nội','0900000096',N'Xã hội','12A2'),
('HS097',N'Đặng Công Vinh','2007-07-07',N'Nam',N'Hà Nội','0900000097',N'Tự nhiên','12A2'),
('HS098',N'Đỗ Hải Yến','2007-08-08',N'Nữ',N'Hà Nội','0900000098',N'Tự nhiên','12A2'),
('HS099',N'Ngô Quốc Bảo','2007-09-09',N'Nam',N'Hà Nội','0900000099',N'Xã hội','12A2'),
('HS100',N'Nguyễn Hà Phương','2007-10-10',N'Nữ',N'Hà Nội','0900000100',N'Tự nhiên','12A2'),
('HS101',N'Trần Trung Kiên','2007-01-01',N'Nam',N'Hà Nội','0900000101',N'Tự nhiên','12A3'),
('HS102',N'Lê Cẩm Tú','2007-02-02',N'Nữ',N'Hà Nội','0900000102',N'Xã hội','12A3'),
('HS103',N'Phạm Anh Đức','2007-03-03',N'Nam',N'Hà Nội','0900000103',N'Tự nhiên','12A3'),
('HS104',N'Hoàng Ngọc Diệp','2007-04-04',N'Nữ',N'Hà Nội','0900000104',N'Tự nhiên','12A3'),
('HS105',N'Vũ Minh Triết','2007-05-05',N'Nam',N'Hà Nội','0900000105',N'Xã hội','12A3'),
('HS106',N'Phan Quỳnh Hương','2007-06-06',N'Nữ',N'Hà Nội','0900000106',N'Tự nhiên','12A3'),
('HS107',N'Bùi Chí Thanh','2007-07-07',N'Nam',N'Hà Nội','0900000107',N'Tự nhiên','12A3'),
('HS108',N'Đặng Mai Anh','2007-08-08',N'Nữ',N'Hà Nội','0900000108',N'Xã hội','12A3'),
('HS109',N'Đỗ Tuấn Kiệt','2007-09-09',N'Nam',N'Hà Nội','0900000109',N'Tự nhiên','12A3'),
('HS110',N'Ngô Bảo Yến','2007-10-10',N'Nữ',N'Hà Nội','0900000110',N'Tự nhiên','12A3'),
('HS111',N'Nguyễn Đình Trọng','2007-01-01',N'Nam',N'Hà Nội','0900000111',N'Xã hội','12A4'),
('HS112',N'Trần Minh Hằng','2007-02-02',N'Nữ',N'Hà Nội','0900000112',N'Tự nhiên','12A4'),
('HS113',N'Lê Hồng Phúc','2007-03-03',N'Nam',N'Hà Nội','0900000113',N'Tự nhiên','12A4'),
('HS114',N'Phạm Trúc Anh','2007-04-04',N'Nữ',N'Hà Nội','0900000114',N'Xã hội','12A4'),
('HS115',N'Hoàng Đăng Khôi','2007-05-05',N'Nam',N'Hà Nội','0900000115',N'Tự nhiên','12A4'),
('HS116',N'Vũ Thu Trang','2007-06-06',N'Nữ',N'Hà Nội','0900000116',N'Tự nhiên','12A4'),
('HS117',N'Phan Trường Sơn','2007-07-07',N'Nam',N'Hà Nội','0900000117',N'Xã hội','12A4'),
('HS118',N'Bùi Hồng Hạnh','2007-08-08',N'Nữ',N'Hà Nội','0900000118',N'Tự nhiên','12A4'),
('HS119',N'Đặng Quang Vũ','2007-09-09',N'Nam',N'Hà Nội','0900000119',N'Tự nhiên','12A4'),
('HS120',N'Đỗ Cẩm Ly','2007-10-10',N'Nữ',N'Hà Nội','0900000120',N'Xã hội','12A4');
--Dữ liệu bảng phân công giảng dạy 
INSERT INTO PhanCongGiangDay
(
    MaGV,
    MaLop,
    MaMon,
    MaHocKy,
    MaNamHoc
)
VALUES

---------------- KHỐI 10 ----------------

('GV001','10A1','MH01',1,'NH2526'),
('GV003','10A1','MH02',1,'NH2526'),
('GV005','10A1','MH03',1,'NH2526'),
('GV007','10A1','MH04',1,'NH2526'),
('GV009','10A1','MH05',1,'NH2526'),
('GV011','10A1','MH06',1,'NH2526'),

('GV002','10A2','MH01',1,'NH2526'),
('GV004','10A2','MH02',1,'NH2526'),
('GV006','10A2','MH03',1,'NH2526'),
('GV008','10A2','MH04',1,'NH2526'),
('GV010','10A2','MH05',1,'NH2526'),
('GV012','10A2','MH06',1,'NH2526'),

('GV019','10A3','MH01',1,'NH2526'),
('GV020','10A3','MH02',1,'NH2526'),
('GV005','10A3','MH03',1,'NH2526'),
('GV007','10A3','MH04',1,'NH2526'),
('GV009','10A3','MH05',1,'NH2526'),
('GV011','10A3','MH06',1,'NH2526'),

('GV001','10A4','MH01',1,'NH2526'),
('GV003','10A4','MH02',1,'NH2526'),
('GV006','10A4','MH03',1,'NH2526'),
('GV008','10A4','MH04',1,'NH2526'),
('GV010','10A4','MH05',1,'NH2526'),
('GV012','10A4','MH06',1,'NH2526'),

---------------- KHỐI 11 ----------------

('GV001','11A1','MH01',1,'NH2526'),
('GV003','11A1','MH02',1,'NH2526'),
('GV005','11A1','MH03',1,'NH2526'),
('GV013','11A1','MH07',1,'NH2526'),
('GV014','11A1','MH08',1,'NH2526'),
('GV015','11A1','MH09',1,'NH2526'),

('GV002','11A2','MH01',1,'NH2526'),
('GV004','11A2','MH02',1,'NH2526'),
('GV006','11A2','MH03',1,'NH2526'),
('GV013','11A2','MH07',1,'NH2526'),
('GV014','11A2','MH08',1,'NH2526'),
('GV016','11A2','MH10',1,'NH2526'),

('GV019','11A3','MH01',1,'NH2526'),
('GV020','11A3','MH02',1,'NH2526'),
('GV005','11A3','MH03',1,'NH2526'),
('GV013','11A3','MH07',1,'NH2526'),
('GV014','11A3','MH08',1,'NH2526'),
('GV017','11A3','MH11',1,'NH2526'),

('GV001','11A4','MH01',1,'NH2526'),
('GV003','11A4','MH02',1,'NH2526'),
('GV006','11A4','MH03',1,'NH2526'),
('GV013','11A4','MH07',1,'NH2526'),
('GV014','11A4','MH08',1,'NH2526'),
('GV018','11A4','MH12',1,'NH2526'),

---------------- KHỐI 12 ----------------

('GV001','12A1','MH01',1,'NH2526'),
('GV003','12A1','MH02',1,'NH2526'),
('GV005','12A1','MH03',1,'NH2526'),
('GV007','12A1','MH04',1,'NH2526'),
('GV009','12A1','MH05',1,'NH2526'),
('GV011','12A1','MH06',1,'NH2526'),

('GV002','12A2','MH01',1,'NH2526'),
('GV004','12A2','MH02',1,'NH2526'),
('GV006','12A2','MH03',1,'NH2526'),
('GV008','12A2','MH04',1,'NH2526'),
('GV010','12A2','MH05',1,'NH2526'),
('GV012','12A2','MH06',1,'NH2526'),

('GV019','12A3','MH01',1,'NH2526'),
('GV020','12A3','MH02',1,'NH2526'),
('GV005','12A3','MH03',1,'NH2526'),
('GV007','12A3','MH04',1,'NH2526'),
('GV009','12A3','MH05',1,'NH2526'),
('GV011','12A3','MH06',1,'NH2526'),

('GV001','12A4','MH01',1,'NH2526'),
('GV003','12A4','MH02',1,'NH2526'),
('GV006','12A4','MH03',1,'NH2526'),
('GV008','12A4','MH04',1,'NH2526'),
('GV010','12A4','MH05',1,'NH2526'),
('GV012','12A4','MH06',1,'NH2526');
GO
--Dữ liệu điểm
INSERT INTO Diem (
    MaHocSinh, MaMon, MaHocKy, MaNamHoc, 
    DiemMieng1, DiemMieng2, Diem15Phut1, Diem15Phut2, 
    Diem1Tiet1, Diem1Tiet2, DiemGiuaKy, DiemCuoiKy, DiemTBHocKy
) 
VALUES
('HS001','MH01',1,'NH2526',6.2,6.4,5.9,6.3,6.2,6.6,6.4,6.5,5.5),
('HS001','MH02',1,'NH2526',6.3,6.5,6.0,6.4,6.3,6.7,6.5,6.6,5.6),
('HS001','MH03',1,'NH2526',6.4,6.6,6.1,6.5,6.4,6.8,6.6,6.7,5.7),
('HS001','MH04',1,'NH2526',6.5,6.7,6.2,6.6,6.5,6.9,6.7,6.8,5.8),
('HS001','MH05',1,'NH2526',6.6,6.8,6.3,6.7,6.6,7.0,6.8,6.9,5.9),
('HS001','MH06',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS001','MH07',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS001','MH08',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS001','MH09',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS001','MH10',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS001','MH11',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS001','MH12',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),

('HS002','MH01',1,'NH2526',6.3,6.5,6.0,6.4,6.3,6.7,6.5,6.6,5.6),
('HS002','MH02',1,'NH2526',6.4,6.6,6.1,6.5,6.4,6.8,6.6,6.7,5.7),
('HS002','MH03',1,'NH2526',6.5,6.7,6.2,6.6,6.5,6.9,6.7,6.8,5.8),
('HS002','MH04',1,'NH2526',6.6,6.8,6.3,6.7,6.6,7.0,6.8,6.9,5.9),
('HS002','MH05',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS002','MH06',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS002','MH07',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS002','MH08',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS002','MH09',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS002','MH10',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS002','MH11',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS002','MH12',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),

('HS003','MH01',1,'NH2526',6.4,6.6,6.1,6.5,6.4,6.8,6.6,6.7,5.7),
('HS003','MH02',1,'NH2526',6.5,6.7,6.2,6.6,6.5,6.9,6.7,6.8,5.8),
('HS003','MH03',1,'NH2526',6.6,6.8,6.3,6.7,6.6,7.0,6.8,6.9,5.9),
('HS003','MH04',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS003','MH05',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS003','MH06',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS003','MH07',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS003','MH08',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS003','MH09',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS003','MH10',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS003','MH11',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS003','MH12',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),

('HS004','MH01',1,'NH2526',6.5,6.7,6.2,6.6,6.5,6.9,6.7,6.8,5.8),
('HS004','MH02',1,'NH2526',6.6,6.8,6.3,6.7,6.6,7.0,6.8,6.9,5.9),
('HS004','MH03',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS004','MH04',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS004','MH05',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS004','MH06',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS004','MH07',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS004','MH08',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS004','MH09',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS004','MH10',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS004','MH11',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS004','MH12',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),

('HS005','MH01',1,'NH2526',6.6,6.8,6.3,6.7,6.6,7.0,6.8,6.9,5.9),
('HS005','MH02',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS005','MH03',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS005','MH04',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS005','MH05',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS005','MH06',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS005','MH07',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS005','MH08',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS005','MH09',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS005','MH10',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS005','MH11',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS005','MH12',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),

('HS006','MH01',1,'NH2526',6.7,6.9,6.4,6.8,6.7,7.1,6.9,7.0,5.9),
('HS006','MH02',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS006','MH03',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS006','MH04',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS006','MH05',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS006','MH06',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS006','MH07',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS006','MH08',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS006','MH09',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS006','MH10',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS006','MH11',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS006','MH12',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),

('HS007','MH01',1,'NH2526',6.8,7.0,6.5,6.9,6.8,7.2,7.0,7.1,6.0),
('HS007','MH02',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS007','MH03',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS007','MH04',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS007','MH05',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS007','MH06',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS007','MH07',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS007','MH08',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS007','MH09',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS007','MH10',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS007','MH11',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS007','MH12',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),

('HS008','MH01',1,'NH2526',6.9,7.1,6.6,7.0,6.9,7.3,7.1,7.2,6.1),
('HS008','MH02',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS008','MH03',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS008','MH04',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS008','MH05',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS008','MH06',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS008','MH07',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS008','MH08',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS008','MH09',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS008','MH10',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS008','MH11',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),
('HS008','MH12',1,'NH2526',8.0,8.2,7.7,8.1,8.0,8.4,8.2,8.3,7.1),

('HS009','MH01',1,'NH2526',7.0,7.2,6.7,7.1,7.0,7.4,7.2,7.3,6.2),
('HS009','MH02',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS009','MH03',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS009','MH04',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS009','MH05',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS009','MH06',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS009','MH07',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS009','MH08',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS009','MH09',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS009','MH10',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),
('HS009','MH11',1,'NH2526',8.0,8.2,7.7,8.1,8.0,8.4,8.2,8.3,7.1),
('HS009','MH12',1,'NH2526',8.1,8.3,7.8,8.2,8.1,8.5,8.3,8.4,7.2),

('HS010','MH01',1,'NH2526',7.1,7.3,6.8,7.2,7.1,7.5,7.3,7.4,6.3),
('HS010','MH02',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS010','MH03',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS010','MH04',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS010','MH05',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS010','MH06',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS010','MH07',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS010','MH08',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS010','MH09',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),
('HS010','MH10',1,'NH2526',8.0,8.2,7.7,8.1,8.0,8.4,8.2,8.3,7.1),
('HS010','MH11',1,'NH2526',8.1,8.3,7.8,8.2,8.1,8.5,8.3,8.4,7.2),
('HS010','MH12',1,'NH2526',8.2,8.4,7.9,8.3,8.2,8.6,8.4,8.5,7.2),

('HS011','MH01',1,'NH2526',7.2,7.4,6.9,7.3,7.2,7.6,7.4,7.5,6.4),
('HS011','MH02',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS011','MH03',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS011','MH04',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS011','MH05',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS011','MH06',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS011','MH07',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS011','MH08',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),
('HS011','MH09',1,'NH2526',8.0,8.2,7.7,8.1,8.0,8.4,8.2,8.3,7.1),
('HS011','MH10',1,'NH2526',8.1,8.3,7.8,8.2,8.1,8.5,8.3,8.4,7.2),
('HS011','MH11',1,'NH2526',8.2,8.4,7.9,8.3,8.2,8.6,8.4,8.5,7.2),
('HS011','MH12',1,'NH2526',8.3,8.5,8.0,8.4,8.3,8.7,8.5,8.6,7.3),

('HS012','MH01',1,'NH2526',7.3,7.5,7.0,7.4,7.3,7.7,7.5,7.6,6.5),
('HS012','MH02',1,'NH2526',7.4,7.6,7.1,7.5,7.4,7.8,7.6,7.7,6.6),
('HS012','MH03',1,'NH2526',7.5,7.7,7.2,7.6,7.5,7.9,7.7,7.8,6.6),
('HS012','MH04',1,'NH2526',7.6,7.8,7.3,7.7,7.6,8.0,7.8,7.9,6.7),
('HS012','MH05',1,'NH2526',7.7,7.9,7.4,7.8,7.7,8.1,7.9,8.0,6.8),
('HS012','MH06',1,'NH2526',7.8,8.0,7.5,7.9,7.8,8.2,8.0,8.1,6.9),
('HS012','MH07',1,'NH2526',7.9,8.1,7.6,8.0,7.9,8.3,8.1,8.2,7.0),
('HS012','MH08',1,'NH2526',8.0,8.2,7.7,8.1,8.0,8.4,8.2,8.3,7.1),
('HS012','MH09',1,'NH2526',8.1,8.3,7.8,8.2,8.1,8.5,8.3,8.4,7.2),
('HS012','MH10',1,'NH2526',8.2,8.4,7.9,8.3,8.2,8.6,8.4,8.5,7.2);
--Dữ liệu tổng kết
INSERT INTO TongKet (
    MaHocSinh, MaNamHoc, TBHocKy1, TBHocKy2, 
    TBCaNam, HocLuc, HanhKiem, KetQua
) 
VALUES
('HS001', 'NH2526', 6.8, 7.0, 6.9, N'Khá', N'Tốt', N'Lên lớp'),
('HS002', 'NH2526', 7.1, 7.3, 7.2, N'Khá', N'Tốt', N'Lên lớp'),
('HS003', 'NH2526', 7.4, 7.6, 7.5, N'Khá', N'Tốt', N'Lên lớp'),
('HS004', 'NH2526', 7.7, 7.9, 7.8, N'Khá', N'Tốt', N'Lên lớp'),
('HS005', 'NH2526', 8.0, 8.2, 8.1, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS006', 'NH2526', 8.3, 8.5, 8.4, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS007', 'NH2526', 8.6, 8.8, 8.7, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS008', 'NH2526', 8.9, 9.1, 9.0, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS009', 'NH2526', 9.2, 9.4, 9.3, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS010', 'NH2526', 9.5, 9.7, 9.6, N'Giỏi', N'Tốt', N'Lên lớp'),
('HS011', 'NH2526', 6.7, 6.9, 6.8, N'Khá', N'Tốt', N'Lên lớp'),
('HS012', 'NH2526', 7.0, 7.2, 7.1, N'Khá', N'Tốt', N'Lên lớp'),
('HS013', 'NH2526', 7.3, 7.5, 7.4, N'Khá', N'Tốt', N'Lên lớp');
--trigger tự động cập nhật sĩ số
CREATE TRIGGER TRG_ThemHocSinh
ON HocSinh
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Lop
    SET SiSo = SiSo + T.SoLuong
    FROM Lop L
    JOIN
    (
        SELECT MaLop, COUNT(*) AS SoLuong
        FROM inserted
        GROUP BY MaLop
    ) T
    ON L.MaLop = T.MaLop;
END
GO
--trigger cập nhật sĩ số khi xóa học sinh
CREATE TRIGGER TRG_XoaHocSinh
ON HocSinh
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Lop
    SET SiSo = SiSo - T.SoLuong
    FROM Lop L
    JOIN
    (
        SELECT MaLop, COUNT(*) AS SoLuong
        FROM deleted
        GROUP BY MaLop
    ) T
    ON L.MaLop = T.MaLop;
END
GO
--khi chuyển lớp
CREATE TRIGGER TRG_ChuyenLop
ON HocSinh
AFTER UPDATE
AS
BEGIN

    IF UPDATE(MaLop)
    BEGIN

        UPDATE Lop
        SET SiSo = SiSo - A.SoLuong
        FROM Lop L
        JOIN
        (
            SELECT MaLop,COUNT(*) SoLuong
            FROM deleted
            GROUP BY MaLop
        ) A
        ON L.MaLop=A.MaLop;

        UPDATE Lop
        SET SiSo = SiSo + B.SoLuong
        FROM Lop L
        JOIN
        (
            SELECT MaLop,COUNT(*) SoLuong
            FROM inserted
            GROUP BY MaLop
        ) B
        ON L.MaLop=B.MaLop;

    END

END
GO
--stored procedure
--Thêm học sinh
CREATE PROC sp_ThemHocSinh

@MaHS VARCHAR(20),
@HoTen NVARCHAR(100),
@NgaySinh DATE,
@GioiTinh NVARCHAR(10),
@DiaChi NVARCHAR(200),
@SDT VARCHAR(15),
@BanHoc NVARCHAR(20),
@MaLop VARCHAR(20)

AS

BEGIN

INSERT INTO HocSinh

VALUES

(
@MaHS,
@HoTen,
@NgaySinh,
@GioiTinh,
@DiaChi,
@SDT,
@BanHoc,
@MaLop
)

END
GO
--sửa học sinh
CREATE PROC sp_SuaHocSinh

@MaHS VARCHAR(20),
@HoTen NVARCHAR(100),
@NgaySinh DATE,
@GioiTinh NVARCHAR(10),
@DiaChi NVARCHAR(200),
@SDT VARCHAR(15),
@BanHoc NVARCHAR(20),
@MaLop VARCHAR(20)

AS

BEGIN

UPDATE HocSinh

SET

HoTen=@HoTen,
NgaySinh=@NgaySinh,
GioiTinh=@GioiTinh,
DiaChi=@DiaChi,
SDTPhuHuynh=@SDT,
BanHoc=@BanHoc,
MaLop=@MaLop

WHERE MaHocSinh=@MaHS

END
GO
--xóa học sinh
CREATE PROC sp_XoaHocSinh

@MaHS VARCHAR(20)

AS

BEGIN

DELETE HocSinh

WHERE MaHocSinh=@MaHS

END
GO
--thêm giáo viên
CREATE PROC sp_ThemGiaoVien

@MaGV VARCHAR(20),
@HoTen NVARCHAR(100),
@NgaySinh DATE,
@GioiTinh NVARCHAR(10),
@SDT VARCHAR(15),
@MaMon VARCHAR(20)

AS

BEGIN

INSERT INTO GiaoVien

VALUES

(
@MaGV,
@HoTen,
@NgaySinh,
@GioiTinh,
@SDT,
@MaMon
)

END
GO
--nhập điểm
CREATE PROC sp_NhapDiem

@MaHS VARCHAR(20),
@MaMon VARCHAR(20),
@HocKy INT,
@NamHoc VARCHAR(10),

@M1 FLOAT,
@M2 FLOAT,
@P1 FLOAT,
@P2 FLOAT,
@T1 FLOAT,
@T2 FLOAT,
@GK FLOAT,
@CK FLOAT

AS

BEGIN

DECLARE @TB FLOAT

SET @TB=

(
(@M1+@M2
+@P1+@P2
+(@T1+@T2)*2
+@GK*2
+@CK*3)/15
)

INSERT INTO Diem

VALUES

(
@MaHS,
@MaMon,
@HocKy,
@NamHoc,
@M1,
@M2,
@P1,
@P2,
@T1,
@T2,
@GK,
@CK,
@TB
)

END
GO
--sp sửa giáo viên
CREATE PROC sp_SuaGiaoVien
    @MaGV VARCHAR(20),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @GioiTinh NVARCHAR(10),
    @SDT VARCHAR(15),
    @MaMon VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE GiaoVien
    SET
        HoTen = @HoTen,
        NgaySinh = @NgaySinh,
        GioiTinh = @GioiTinh,
        SoDienThoai = @SDT,
        MaMon = @MaMon
    WHERE MaGV = @MaGV;
END
GO
--sp xóa giáo viên
CREATE PROC sp_XoaGiaoVien
    @MaGV VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Giáo viên đang là GVCN
    IF EXISTS
    (
        SELECT *
        FROM Lop
        WHERE MaGVCN = @MaGV
    )
    BEGIN
        RAISERROR(N'Giáo viên đang là giáo viên chủ nhiệm.',16,1);
        RETURN;
    END

    -- Giáo viên đang có tài khoản
    IF EXISTS
    (
        SELECT *
        FROM TaiKhoan
        WHERE MaGV = @MaGV
    )
    BEGIN
        RAISERROR(N'Giáo viên đang có tài khoản đăng nhập.',16,1);
        RETURN;
    END

    DELETE FROM GiaoVien
    WHERE MaGV = @MaGV;
END
GO
-- sp tìm giáo viên
CREATE PROC sp_TimGiaoVien
    @TuKhoa NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        gv.MaGV,
        gv.HoTen,
        gv.NgaySinh,
        gv.GioiTinh,
        gv.SoDienThoai,
        mh.TenMon
    FROM GiaoVien gv
    INNER JOIN MonHoc mh
        ON gv.MaMon = mh.MaMon
    WHERE
        gv.MaGV LIKE '%' + @TuKhoa + '%'
        OR gv.HoTen LIKE '%' + @TuKhoa + '%'
        OR mh.TenMon LIKE '%' + @TuKhoa + '%'
    ORDER BY gv.MaGV;
END
GO
--sp hiện ds giáo viên
CREATE PROC sp_DanhSachGiaoVien
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        gv.MaGV,
        gv.HoTen,
        gv.NgaySinh,
        gv.GioiTinh,
        gv.SoDienThoai,
        mh.TenMon,
        gv.MaMon
    FROM GiaoVien gv
    INNER JOIN MonHoc mh
        ON gv.MaMon = mh.MaMon
    ORDER BY gv.MaGV;
END
GO
--sp danh sách môn học
CREATE PROC sp_DanhSachMonHoc
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MaMon,
        TenMon,
        SoTiet,
        HeSoMon
    FROM MonHoc
    ORDER BY MaMon;
END
GO
--sp thêm môn học
CREATE PROC sp_ThemMonHoc
    @MaMon VARCHAR(20),
    @TenMon NVARCHAR(50),
    @SoTiet INT,
    @HeSoMon FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO MonHoc
    (
        MaMon,
        TenMon,
        SoTiet,
        HeSoMon
    )
    VALUES
    (
        @MaMon,
        @TenMon,
        @SoTiet,
        @HeSoMon
    );
END
GO
--sp sửa môn học
CREATE PROC sp_SuaMonHoc
    @MaMon VARCHAR(20),
    @TenMon NVARCHAR(50),
    @SoTiet INT,
    @HeSoMon FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE MonHoc
    SET
        TenMon = @TenMon,
        SoTiet = @SoTiet,
        HeSoMon = @HeSoMon
    WHERE MaMon = @MaMon;
END
GO
--sp xóa môn học
CREATE PROC sp_XoaMonHoc
    @MaMon VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM MonHoc
    WHERE MaMon = @MaMon;
END
GO
--sp tìm kiếm môn học
CREATE PROC sp_TimMonHoc
    @TuKhoa NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MaMon,
        TenMon,
        SoTiet,
        HeSoMon
    FROM MonHoc
    WHERE
        MaMon LIKE '%' + @TuKhoa + '%'
        OR TenMon LIKE '%' + @TuKhoa + '%'
    ORDER BY MaMon;
END
GO
--sp danh sách lớp
CREATE PROC sp_DanhSachLop
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.MaLop,
        l.TenLop,
        l.Khoi,
        l.SiSo,
        nh.TenNamHoc,
        gv.HoTen AS GVCN
    FROM Lop l
    INNER JOIN NamHoc nh
        ON l.MaNamHoc = nh.MaNamHoc
    LEFT JOIN GiaoVien gv
        ON l.MaGVCN = gv.MaGV
    ORDER BY l.Khoi, l.TenLop;
END
GO
--sp thêm lớp
CREATE PROC sp_ThemLop
    @MaLop VARCHAR(20),
    @TenLop NVARCHAR(30),
    @Khoi INT,
    @MaNamHoc VARCHAR(10),
    @MaGVCN VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Lop
    (
        MaLop,
        TenLop,
        Khoi,
        MaNamHoc,
        MaGVCN
    )
    VALUES
    (
        @MaLop,
        @TenLop,
        @Khoi,
        @MaNamHoc,
        @MaGVCN
    );
END
GO
--sp sửa lớp
CREATE PROC sp_SuaLop
    @MaLop VARCHAR(20),
    @TenLop NVARCHAR(30),
    @Khoi INT,
    @MaNamHoc VARCHAR(10),
    @MaGVCN VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Lop
    SET
        TenLop = @TenLop,
        Khoi = @Khoi,
        MaNamHoc = @MaNamHoc,
        MaGVCN = @MaGVCN
    WHERE MaLop = @MaLop;
END
GO
--sp xóa lớp
CREATE PROC sp_XoaLop
    @MaLop VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM HocSinh WHERE MaLop = @MaLop)
    BEGIN
        RAISERROR(N'Không thể xóa vì lớp vẫn còn học sinh.',16,1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM PhanCongGiangDay WHERE MaLop = @MaLop)
    BEGIN
        RAISERROR(N'Không thể xóa vì lớp đã được phân công giảng dạy.',16,1);
        RETURN;
    END

    DELETE FROM Lop
    WHERE MaLop = @MaLop;
END
GO
--sp tìm lớp
CREATE PROC sp_TimLop
    @TuKhoa NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.MaLop,
        l.TenLop,
        l.Khoi,
        l.SiSo,
        nh.TenNamHoc,
        gv.HoTen AS GVCN
    FROM Lop l
    INNER JOIN NamHoc nh
        ON l.MaNamHoc = nh.MaNamHoc
    LEFT JOIN GiaoVien gv
        ON l.MaGVCN = gv.MaGV
    WHERE
        l.MaLop LIKE '%' + @TuKhoa + '%'
        OR l.TenLop LIKE '%' + @TuKhoa + '%'
        OR gv.HoTen LIKE '%' + @TuKhoa + '%'
        OR nh.TenNamHoc LIKE '%' + @TuKhoa + '%'
    ORDER BY l.Khoi, l.TenLop;
END
GO
--sp hiện ds giảng dạy
CREATE PROC sp_DanhSachPhanCong
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        pc.MaPhanCong,
        gv.HoTen AS GiaoVien,
        l.TenLop,
        mh.TenMon,
        hk.TenHocKy,
        nh.TenNamHoc
    FROM PhanCongGiangDay pc
        INNER JOIN GiaoVien gv
            ON pc.MaGV = gv.MaGV
        INNER JOIN Lop l
            ON pc.MaLop = l.MaLop
        INNER JOIN MonHoc mh
            ON pc.MaMon = mh.MaMon
        INNER JOIN HocKy hk
            ON pc.MaHocKy = hk.MaHocKy
        INNER JOIN NamHoc nh
            ON pc.MaNamHoc = nh.MaNamHoc
    ORDER BY
        nh.MaNamHoc,
        hk.MaHocKy,
        l.TenLop,
        mh.TenMon;
END
GO
--sp thêm phân công
CREATE PROC sp_ThemPhanCong
(
    @MaGV VARCHAR(20),
    @MaLop VARCHAR(20),
    @MaMon VARCHAR(20),
    @MaHocKy INT,
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM PhanCongGiangDay
        WHERE MaGV=@MaGV
          AND MaLop=@MaLop
          AND MaMon=@MaMon
          AND MaHocKy=@MaHocKy
          AND MaNamHoc=@MaNamHoc
    )
    BEGIN
        RAISERROR(N'Phân công này đã tồn tại.',16,1);
        RETURN;
    END

    INSERT INTO PhanCongGiangDay
    (
        MaGV,
        MaLop,
        MaMon,
        MaHocKy,
        MaNamHoc
    )
    VALUES
    (
        @MaGV,
        @MaLop,
        @MaMon,
        @MaHocKy,
        @MaNamHoc
    );
END
GO
--sp sửa phân công
CREATE PROC sp_SuaPhanCong
(
    @MaPhanCong INT,
    @MaGV VARCHAR(20),
    @MaLop VARCHAR(20),
    @MaMon VARCHAR(20),
    @MaHocKy INT,
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM PhanCongGiangDay
        WHERE MaGV=@MaGV
            AND MaLop=@MaLop
            AND MaMon=@MaMon
            AND MaHocKy=@MaHocKy
            AND MaNamHoc=@MaNamHoc
            AND MaPhanCong<>@MaPhanCong
    )
    BEGIN
        RAISERROR(N'Phân công này đã tồn tại.',16,1);
        RETURN;
    END

    UPDATE PhanCongGiangDay
    SET
        MaGV=@MaGV,
        MaLop=@MaLop,
        MaMon=@MaMon,
        MaHocKy=@MaHocKy,
        MaNamHoc=@MaNamHoc
    WHERE MaPhanCong=@MaPhanCong;
END
GO
--sp xóa phân công
CREATE PROC sp_XoaPhanCong
(
    @MaPhanCong INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM PhanCongGiangDay
    WHERE MaPhanCong=@MaPhanCong;
END
GO
--sp tìm kiếm
CREATE PROC sp_TimPhanCong
(
    @TuKhoa NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        pc.MaPhanCong,
        gv.HoTen AS GiaoVien,
        l.TenLop,
        mh.TenMon,
        hk.TenHocKy,
        nh.TenNamHoc
    FROM PhanCongGiangDay pc
        INNER JOIN GiaoVien gv
            ON pc.MaGV = gv.MaGV
        INNER JOIN Lop l
            ON pc.MaLop = l.MaLop
        INNER JOIN MonHoc mh
            ON pc.MaMon = mh.MaMon
        INNER JOIN HocKy hk
            ON pc.MaHocKy = hk.MaHocKy
        INNER JOIN NamHoc nh
            ON pc.MaNamHoc = nh.MaNamHoc
    WHERE
        gv.HoTen LIKE '%' + @TuKhoa + '%'
        OR l.TenLop LIKE '%' + @TuKhoa + '%'
        OR mh.TenMon LIKE '%' + @TuKhoa + '%'
        OR hk.TenHocKy LIKE '%' + @TuKhoa + '%'
        OR nh.TenNamHoc LIKE '%' + @TuKhoa + '%'
    ORDER BY
        nh.MaNamHoc,
        hk.MaHocKy,
        l.TenLop,
        mh.TenMon;
END
GO
--thêm ràng buộc
ALTER TABLE PhanCongGiangDay
ADD CONSTRAINT UQ_PhanCong
UNIQUE
(
    MaGV,
    MaLop,
    MaMon,
    MaHocKy,
    MaNamHoc
);
--sp ds năm học 
CREATE PROC sp_NamHoc_Select
AS
BEGIN
    SELECT MaNamHoc, TenNamHoc
    FROM NamHoc
    ORDER BY TenNamHoc
END
GO
--sp ds học kỳ
CREATE PROC sp_HocKy_Select
AS
BEGIN
    SELECT MaHocKy, TenHocKy
    FROM HocKy
    ORDER BY MaHocKy
END
GO
--sp lấy lớp theo quyền
CREATE PROC sp_Lop_SelectByUser
(
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20)
)
AS
BEGIN

    IF @Quyen='Admin'
    BEGIN
        SELECT MaLop,TenLop
        FROM Lop
        ORDER BY TenLop
    END

    ELSE
    BEGIN

        SELECT DISTINCT
            L.MaLop,
            L.TenLop
        FROM Lop L
        INNER JOIN PhanCongGiangDay PC
            ON L.MaLop=PC.MaLop
        WHERE PC.MaGV=@MaGV
        ORDER BY L.TenLop

    END

END
GO
--sp lấy môn theo quyền
CREATE PROC sp_MonHoc_SelectByUser
(
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20)
)
AS
BEGIN

    IF @Quyen='Admin'
    BEGIN
        SELECT MaMon,TenMon
        FROM MonHoc
        ORDER BY TenMon
    END

    ELSE
    BEGIN

        SELECT DISTINCT
            M.MaMon,
            M.TenMon
        FROM MonHoc M
        INNER JOIN PhanCongGiangDay PC
            ON M.MaMon=PC.MaMon
        WHERE PC.MaGV=@MaGV
        ORDER BY M.TenMon

    END

END
GO
--sp lấy học sinh để nhập điểm
CREATE PROC sp_NhapDiem_Load
(
    @MaLop VARCHAR(20),
    @MaMon VARCHAR(20),
    @MaHocKy INT,
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN

SELECT

    HS.MaHocSinh,

    HS.HoTen,

    D.MaDiem,

    D.DiemMieng1,

    D.DiemMieng2,

    D.Diem15Phut1,

    D.Diem15Phut2,

    D.Diem1Tiet1,

    D.Diem1Tiet2,

    D.DiemGiuaKy,

    D.DiemCuoiKy,

    D.DiemTBHocKy

FROM HocSinh HS

LEFT JOIN Diem D

ON HS.MaHocSinh=D.MaHocSinh

AND D.MaMon=@MaMon

AND D.MaHocKy=@MaHocKy

AND D.MaNamHoc=@MaNamHoc

WHERE HS.MaLop=@MaLop

ORDER BY HS.HoTen

END
GO
--sp lưu điểm 
CREATE PROC sp_NhapDiem_Save
(
    @MaHocSinh VARCHAR(20),
    @MaMon VARCHAR(20),
    @MaHocKy INT,
    @MaNamHoc VARCHAR(10),

    @DiemMieng1 FLOAT = NULL,
    @DiemMieng2 FLOAT = NULL,
    @Diem15Phut1 FLOAT = NULL,
    @Diem15Phut2 FLOAT = NULL,
    @Diem1Tiet1 FLOAT = NULL,
    @Diem1Tiet2 FLOAT = NULL,
    @DiemGiuaKy FLOAT = NULL,
    @DiemCuoiKy FLOAT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT *
        FROM Diem
        WHERE MaHocSinh=@MaHocSinh
        AND MaMon=@MaMon
        AND MaHocKy=@MaHocKy
        AND MaNamHoc=@MaNamHoc
    )
    BEGIN

        UPDATE Diem
        SET
            DiemMieng1=@DiemMieng1,
            DiemMieng2=@DiemMieng2,
            Diem15Phut1=@Diem15Phut1,
            Diem15Phut2=@Diem15Phut2,
            Diem1Tiet1=@Diem1Tiet1,
            Diem1Tiet2=@Diem1Tiet2,
            DiemGiuaKy=@DiemGiuaKy,
            DiemCuoiKy=@DiemCuoiKy
        WHERE MaHocSinh=@MaHocSinh
        AND MaMon=@MaMon
        AND MaHocKy=@MaHocKy
        AND MaNamHoc=@MaNamHoc;

    END
    ELSE
    BEGIN

        INSERT INTO Diem
        (
            MaHocSinh,
            MaMon,
            MaHocKy,
            MaNamHoc,
            DiemMieng1,
            DiemMieng2,
            Diem15Phut1,
            Diem15Phut2,
            Diem1Tiet1,
            Diem1Tiet2,
            DiemGiuaKy,
            DiemCuoiKy
        )
        VALUES
        (
            @MaHocSinh,
            @MaMon,
            @MaHocKy,
            @MaNamHoc,
            @DiemMieng1,
            @DiemMieng2,
            @Diem15Phut1,
            @Diem15Phut2,
            @Diem1Tiet1,
            @Diem1Tiet2,
            @DiemGiuaKy,
            @DiemCuoiKy
        );

    END

    UPDATE Diem
    SET DiemTBHocKy =
    (
        ISNULL(DiemMieng1,0)
      + ISNULL(DiemMieng2,0)
      + ISNULL(Diem15Phut1,0)
      + ISNULL(Diem15Phut2,0)
      + (ISNULL(Diem1Tiet1,0)+ISNULL(Diem1Tiet2,0))*2
      + ISNULL(DiemGiuaKy,0)*2
      + ISNULL(DiemCuoiKy,0)*3
    ) / 13.0
    WHERE MaHocSinh=@MaHocSinh
    AND MaMon=@MaMon
    AND MaHocKy=@MaHocKy
    AND MaNamHoc=@MaNamHoc;

END
GO
--sp ds bảng điểm
CREATE PROC sp_BangDiem_Select
(
    @MaNamHoc VARCHAR(10),
    @MaHocKy INT,
    @MaLop VARCHAR(20),
    @MaMon VARCHAR(20),
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF(@Quyen='Admin')
    BEGIN

        SELECT
            hs.MaHocSinh,
            hs.HoTen,

            d.DiemMieng1,
            d.DiemMieng2,

            d.Diem15Phut1,
            d.Diem15Phut2,

            d.Diem1Tiet1,
            d.Diem1Tiet2,

            d.DiemGiuaKy,
            d.DiemCuoiKy,

            d.DiemTBHocKy

        FROM HocSinh hs

        INNER JOIN Lop l
            ON hs.MaLop=l.MaLop

        LEFT JOIN Diem d
            ON hs.MaHocSinh=d.MaHocSinh
            AND d.MaMon=@MaMon
            AND d.MaHocKy=@MaHocKy
            AND d.MaNamHoc=@MaNamHoc

        WHERE l.MaLop=@MaLop

        ORDER BY hs.MaHocSinh;

    END

    ELSE
    BEGIN

        SELECT
            hs.MaHocSinh,
            hs.HoTen,

            d.DiemMieng1,
            d.DiemMieng2,

            d.Diem15Phut1,
            d.Diem15Phut2,

            d.Diem1Tiet1,
            d.Diem1Tiet2,

            d.DiemGiuaKy,
            d.DiemCuoiKy,

            d.DiemTBHocKy

        FROM HocSinh hs

        INNER JOIN Lop l
            ON hs.MaLop=l.MaLop

        INNER JOIN PhanCongGiangDay pc
            ON pc.MaLop=l.MaLop

        LEFT JOIN Diem d
            ON hs.MaHocSinh=d.MaHocSinh
            AND d.MaMon=@MaMon
            AND d.MaHocKy=@MaHocKy
            AND d.MaNamHoc=@MaNamHoc

        WHERE
            pc.MaGV=@MaGV
            AND pc.MaMon=@MaMon
            AND pc.MaHocKy=@MaHocKy
            AND pc.MaNamHoc=@MaNamHoc
            AND l.MaLop=@MaLop

        ORDER BY hs.MaHocSinh;

    END
END
GO
--sp thống kê học lực
CREATE PROC sp_ThongKeHocLuc
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        HocLuc,
        COUNT(*) AS SoLuong
    FROM TongKet
    WHERE MaNamHoc=@MaNamHoc
    GROUP BY HocLuc
    ORDER BY HocLuc
END
GO
--sp tổng số học sinh
CREATE PROC sp_TongSoHocSinh
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS TongHocSinh
    FROM TongKet
    WHERE MaNamHoc=@MaNamHoc;
END
GO
--sp top học sinh điểm cao
CREATE PROC sp_TopHocSinh
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        hs.MaHocSinh,
        hs.HoTen,
        l.TenLop,
        tk.TBCaNam,
        tk.HocLuc
    FROM TongKet tk

    INNER JOIN HocSinh hs
        ON tk.MaHocSinh=hs.MaHocSinh

    INNER JOIN Lop l
        ON hs.MaLop=l.MaLop

    WHERE tk.MaNamHoc=@MaNamHoc

    ORDER BY tk.TBCaNam DESC;
END
GO
--sp tỷ lệ đạt
CREATE PROC sp_TyLeDat
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SUM(CASE WHEN KetQua=N'Đạt' THEN 1 ELSE 0 END) AS Dat,
        SUM(CASE WHEN KetQua=N'Không đạt' THEN 1 ELSE 0 END) AS KhongDat,
        COUNT(*) AS TongHocSinh
    FROM TongKet
    WHERE MaNamHoc=@MaNamHoc;
END
GO
--sp tổng số học sinh từng lớp
CREATE PROC sp_ThongKeHocSinhTheoLop
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.MaLop,
        l.TenLop,
        l.Khoi,
        COUNT(hs.MaHocSinh) AS TongHocSinh
    FROM Lop l
    LEFT JOIN HocSinh hs
        ON l.MaLop = hs.MaLop
    WHERE l.MaNamHoc = @MaNamHoc
    GROUP BY
        l.MaLop,
        l.TenLop,
        l.Khoi
    ORDER BY
        l.Khoi,
        l.TenLop;
END
GO
--Thống kê học lực từng lớp
CREATE PROC sp_ThongKeHocLucTheoLop
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.MaLop,
        l.TenLop,

        SUM(CASE WHEN tk.HocLuc = N'Giỏi' THEN 1 ELSE 0 END) AS Gioi,
        SUM(CASE WHEN tk.HocLuc = N'Khá' THEN 1 ELSE 0 END) AS Kha,
        SUM(CASE WHEN tk.HocLuc = N'Trung bình' THEN 1 ELSE 0 END) AS TrungBinh,
        SUM(CASE WHEN tk.HocLuc = N'Yếu' THEN 1 ELSE 0 END) AS Yeu,

        COUNT(*) AS TongHocSinh

    FROM TongKet tk

    INNER JOIN HocSinh hs
        ON tk.MaHocSinh = hs.MaHocSinh

    INNER JOIN Lop l
        ON hs.MaLop = l.MaLop

    WHERE tk.MaNamHoc = @MaNamHoc

    GROUP BY
        l.MaLop,
        l.TenLop

    ORDER BY
        l.TenLop;
END
GO
--Thống kê đạt/ không đạt từng lớp
CREATE PROC sp_ThongKeKetQuaTheoLop
(
    @MaNamHoc VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.MaLop,
        l.TenLop,

        SUM(CASE WHEN tk.KetQua = N'Đạt'
                 THEN 1 ELSE 0 END) AS Dat,

        SUM(CASE WHEN tk.KetQua = N'Không đạt'
                 THEN 1 ELSE 0 END) AS KhongDat,

        COUNT(*) AS TongHocSinh,

        CAST(
            SUM(CASE WHEN tk.KetQua=N'Đạt'
                     THEN 1 ELSE 0 END)
            *100.0
            /COUNT(*)
            AS DECIMAL(5,2)
        ) AS TyLeDat

    FROM TongKet tk

    INNER JOIN HocSinh hs
        ON tk.MaHocSinh=hs.MaHocSinh

    INNER JOIN Lop l
        ON hs.MaLop=l.MaLop

    WHERE tk.MaNamHoc=@MaNamHoc

    GROUP BY
        l.MaLop,
        l.TenLop

    ORDER BY
        l.TenLop;
END
GO
-- thống kê danh sách điểm học sinh
CREATE PROC sp_BangTongKetHocSinh
(
    @MaNamHoc VARCHAR(10),
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20)=NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF(@Quyen='Admin')
    BEGIN
        SELECT
            hs.MaHocSinh,
            hs.HoTen,
            l.TenLop,
            tk.TBHocKy1,
            tk.TBHocKy2,
            tk.TBCaNam,
            tk.HocLuc,
            tk.HanhKiem,
            tk.KetQua
        FROM TongKet tk
        INNER JOIN HocSinh hs
            ON tk.MaHocSinh=hs.MaHocSinh
        INNER JOIN Lop l
            ON hs.MaLop=l.MaLop
        WHERE tk.MaNamHoc=@MaNamHoc
        ORDER BY l.TenLop,hs.HoTen;
    END
    ELSE
    BEGIN
        SELECT DISTINCT
            hs.MaHocSinh,
            hs.HoTen,
            l.TenLop,
            tk.TBHocKy1,
            tk.TBHocKy2,
            tk.TBCaNam,
            tk.HocLuc,
            tk.HanhKiem,
            tk.KetQua
        FROM TongKet tk

        INNER JOIN HocSinh hs
            ON tk.MaHocSinh=hs.MaHocSinh

        INNER JOIN Lop l
            ON hs.MaLop=l.MaLop

        INNER JOIN PhanCongGiangDay pc
            ON hs.MaLop=pc.MaLop

        WHERE tk.MaNamHoc=@MaNamHoc
          AND pc.MaGV=@MaGV

        ORDER BY l.TenLop,hs.HoTen;
    END
END
GO
--Sửa thống kê tổng kết học sinh
ALTER PROC sp_BangTongKetHocSinh
(
    @MaNamHoc VARCHAR(10),
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF(@Quyen = 'Admin')
    BEGIN
        SELECT
            hs.MaHocSinh, hs.HoTen, l.TenLop,
            tk.TBHocKy1, tk.TBHocKy2, tk.TBCaNam,
            tk.HocLuc, tk.HanhKiem, tk.KetQua
        FROM TongKet tk
        INNER JOIN HocSinh hs ON tk.MaHocSinh = hs.MaHocSinh
        INNER JOIN Lop l ON hs.MaLop = l.MaLop
        WHERE tk.MaNamHoc = @MaNamHoc
        ORDER BY l.TenLop, hs.HoTen;
    END
    ELSE -- Quyền GiaoVien: Chỉ xem được lớp mình làm Chủ Nhiệm (hoặc lớp mình có giảng dạy tùy bạn chọn, ở đây sửa theo GVCN để đúng nghĩa tổng kết)
    BEGIN
        SELECT
            hs.MaHocSinh, hs.HoTen, l.TenLop,
            tk.TBHocKy1, tk.TBHocKy2, tk.TBCaNam,
            tk.HocLuc, tk.HanhKiem, tk.KetQua
        FROM TongKet tk
        INNER JOIN HocSinh hs ON tk.MaHocSinh = hs.MaHocSinh
        INNER JOIN Lop l ON hs.MaLop = l.MaLop
        WHERE tk.MaNamHoc = @MaNamHoc
          AND l.MaGVCN = @MaGV -- Lọc chính xác theo giáo viên chủ nhiệm
        ORDER BY l.TenLop, hs.HoTen;
    END
END
GO
--sửa proc môn học
ALTER PROC sp_MonHoc_SelectByUser
(
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@Quyen = 'Admin')
    BEGIN
        SELECT MaMon, TenMon FROM MonHoc;
    END
    ELSE
    BEGIN
        SELECT DISTINCT m.MaMon, m.TenMon
        FROM MonHoc m
        INNER JOIN PhanCongGiangDay pc ON m.MaMon = pc.MaMon
        WHERE pc.MaGV = @MaGV;
    END
END
--sửa tổng kết học sinh
ALTER PROC sp_BangTongKetHocSinh
(
    @MaNamHoc VARCHAR(10),
    @Quyen NVARCHAR(20),
    @MaGV VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@Quyen = 'Admin')
    BEGIN
        SELECT
            hs.MaHocSinh, 
            hs.HoTen, 
            l.TenLop,
            tk.TBHocKy1, 
            tk.TBHocKy2, 
            tk.TBCaNam,
            ISNULL(tk.HocLuc, N'Chưa tổng kết') AS HocLuc, 
            ISNULL(tk.HanhKiem, N'Chưa có') AS HanhKiem, 
            ISNULL(tk.KetQua, N'Chưa có') AS KetQua
        FROM HocSinh hs
        INNER JOIN Lop l ON hs.MaLop = l.MaLop
        -- Đổi thành LEFT JOIN để học sinh chưa có điểm Tổng kết vẫn hiện tên
        LEFT JOIN TongKet tk ON hs.MaHocSinh = tk.MaHocSinh AND tk.MaNamHoc = @MaNamHoc
        ORDER BY l.TenLop, hs.HoTen;
    END
    ELSE
    BEGIN
        SELECT DISTINCT
            hs.MaHocSinh, 
            hs.HoTen, 
            l.TenLop,
            tk.TBHocKy1, 
            tk.TBHocKy2, 
            tk.TBCaNam,
            ISNULL(tk.HocLuc, N'Chưa tổng kết') AS HocLuc, 
            ISNULL(tk.HanhKiem, N'Chưa có') AS HanhKiem, 
            ISNULL(tk.KetQua, N'Chưa có') AS KetQua
        FROM HocSinh hs
        INNER JOIN Lop l ON hs.MaLop = l.MaLop
        LEFT JOIN TongKet tk ON hs.MaHocSinh = tk.MaHocSinh AND tk.MaNamHoc = @MaNamHoc
        LEFT JOIN PhanCongGiangDay pc ON l.MaLop = pc.MaLop
        WHERE l.MaGVCN = @MaGV OR pc.MaGV = @MaGV
        ORDER BY l.TenLop, hs.HoTen;
    END
END
GO