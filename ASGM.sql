USE master;
GO

-- Kiểm tra và xóa database nếu tồn tại
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'ShopDB')
BEGIN
    ALTER DATABASE ShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ShopDB;
END
GO

-- Tạo mới database
USE master
GO
CREATE DATABASE ShopDB COLLATE Vietnamese_CI_AS;
GO

-- Sử dụng database ShopDB
USE ShopDB;
GO

-- Tạo bảng Users
CREATE TABLE [Users] (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) DEFAULT N'customer',
    display_name NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE()
);

-- Tạo bảng Category
CREATE TABLE Category (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL
);

-- Tạo bảng Product
CREATE TABLE Product (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(255) NOT NULL,
    product_price FLOAT NOT NULL CHECK (product_price >= 0),
    product_quantity INT NOT NULL CHECK (product_quantity >= 0),
    product_description NVARCHAR(MAX),
    category_id INT,
    sold_quantity INT,
    image_url NVARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);

-- Tạo bảng Cart
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [Users](user_id) ON DELETE CASCADE
);

-- Tạo bảng CartItem
CREATE TABLE CartItem (
    cart_item_id INT PRIMARY KEY IDENTITY(1,1),
    cart_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);

-- Tạo bảng Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    total_price FLOAT NOT NULL CHECK (total_price >= 0),
    order_date DATETIME DEFAULT GETDATE(),
    buyer_name NVARCHAR(100),
    buyer_phone NVARCHAR(15),
    buyer_address NVARCHAR(MAX),
    FOREIGN KEY (user_id) REFERENCES [Users](user_id) ON DELETE CASCADE
);

-- Tạo bảng OrderItem
CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase FLOAT NOT NULL CHECK (price_at_purchase >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE SET NULL
);
GO

-- Chèn dữ liệu vào bảng Users
INSERT INTO [Users] (username, password, role, display_name)
VALUES (N'admin', N'adminpass', N'admin', N'Admin');

-- Chèn dữ liệu vào bảng Cart
INSERT INTO Cart (user_id)
VALUES (1);

-- Chèn dữ liệu vào bảng Category
INSERT INTO Category (category_name) 
VALUES (N'Đồ chơi giáo dục'), (N'Hành động'), (N'Khối xây dựng'), (N'Búp bê'), (N'Đồ chơi ngoài trời');

-- Chèn dữ liệu vào bảng Product
INSERT INTO Product (product_name, product_price, product_quantity, product_description, category_id, image_url, sold_quantity) 
VALUES 
(N'Khối học chữ cái', 19.99, 20, N'Khối chơi giúp học chữ cái và số.', 1, N'img/khoi_hoc_chu_cai.jpg', 4),
(N'Xếp hình toán học', 12.50, 15, N'Trò chơi xếp hình giúp trẻ học toán.', 1, N'img/puzzle_toan_hoc.jpg', 6),
(N'Bộ xếp hình học', 15.00, 18, N'Bộ xếp hình phát triển tư duy cho trẻ.', 1, N'img/bo_xep_hinh_hoc.jpg', 30),
(N'Mặt nạ không gian', 22.50, 10, N'Trò chơi giúp trẻ hiểu biết về không gian.', 1, N'img/mat_mang_khong_gian.jpg', 1),
(N'Bánh xe vận chuyển', 16.75, 25, N'Đồ chơi xe vận chuyển dành cho trẻ.', 1, N'img/banh_xe_van_chuyen.jpg', 0),
(N'Bộ đá thực hành', 30.00, 12, N'Bộ đá giúp trẻ thực hành toán học.', 1, N'img/bo_da_thuc_hanh.jpg', 0),
(N'Kiến thức về thế giới', 28.00, 14, N'Bộ kit giúp trẻ khám phá kiến thức về thế giới.', 1, N'img/kien_thuc_ve_the_gioi.jpg', 2);

INSERT INTO Product (product_name, product_price, product_quantity, product_description, category_id, image_url, sold_quantity) 
VALUES 
(N'Hành động siêu anh hùng', 25.99, 15, N'Nhân vật hành động siêu anh hùng.', 2, N'img/hinh_anh_hanh_dong_sieu_anh_hung.jpg', 5),
(N'Robot chiến binh', 35.50, 20, N'Robot chiến binh có âm thanh và chuyển động.', 2, N'img/robot_chien_binh.jpg', 1),
(N'Pháo tay siêu nhân', 22.50, 12, N'Pháo tay siêu nhân cho trẻ vui chơi.', 2, N'img/phao_tay_sieu_nhan.jpg', 4),
(N'Bình thường siêu nhân', 15.99, 17, N'Bình siêu nhân giúp trẻ tưởng tượng và sáng tạo.', 2, N'img/binh_thuong_sieu_nhan.jpg', 4),
(N'Bánh xe siêu nhân', 30.00, 10, N'Bánh xe siêu nhân dành cho trẻ em.', 2, N'img/banh_xe_sieu_nhan.jpg', 0),
(N'Quây pháo tự nhiên', 12.50, 14, N'Quây pháo tự nhiên cho trẻ vui chơi vận động.', 2, N'img/quay_phao_tu_nhien.jpg', 8),
(N'Robot Gundam', 24.75, 30, N'Robot biến hình Gundam cho trẻ em.', 2, N'img/chienbinhvutrang.jpg', 0);

INSERT INTO Product (product_name, product_price, product_quantity, product_description, category_id, image_url, sold_quantity) 
VALUES 
(N'Bộ Lego cơ bản', 49.99, 25, N'Bộ Lego cơ bản giúp trẻ phát triển tư duy.', 3, N'img/bo_lego_co_ban.jpg', 4),
(N'Mô hình tàu Titanic', 19.99, 18, N'Mô hình tàu Titanic để trẻ khám phá.', 3, N'img/lubantitanic.jpg', 4),
(N'Bộ xếp hình Mega Bloks', 29.99, 20, N'Bộ xếp hình Mega Bloks cho trẻ.', 3, N'img/bo_xep_mega_bloks.jpg', 4),
(N'Bộ xây dựng không gian', 30.50, 10, N'Bộ xếp hình khám phá không gian cho trẻ.', 3, N'img/bo_xay_dung_khong_gian.jpg', 4),
(N'Bộ khối xây dựng', 22.50, 15, N'Bộ khối xây dựng giúp trẻ sáng tạo.', 3, N'img/bo_khoi_xay_dung.jpg', 4),
(N'Bộ xếp xây dựng', 24.50, 30, N'Bộ xếp hình xây dựng giúp trẻ phát triển kỹ năng.', 3, N'img/bo_xep_xay_dung.jpg', 4),
(N'Bộ xếp nhà búp bê', 17.50, 15, N'Bộ xếp hình nhà búp bê cho trẻ.', 3, N'img/bo_xep_bup_be.jpg', 4),
(N'Bộ xếp hình Lăng Bác', 23.00, 10, N'Bộ xếp hình Lăng Bác cho trẻ học hỏi.', 3, N'img/lapraplangBac.jpg', 4);



INSERT INTO Product (product_name, product_price, product_quantity, product_description, category_id, image_url, sold_quantity) 
VALUES 
(N'Búp bê Barbie', 24.99, 25, N'Búp bê Barbie với các phụ kiện đa dạng.', 4, 'img/bup_be_barbie.jpg', 0),
(N'Búp bê Bratz', 23.75, 22, N'Búp bê Bratz yêu thích của trẻ em.', 4, 'img/bup_be_bratz.jpg', 0),
(N'Búp bê em bé', 14.99, 20, N'Búp bê em bé với bình sữa kèm theo.', 4, 'img/bup_be_em_be.jpg', 0),
(N'Búp bê điện thoại', 19.99, 15, N'Búp bê điện thoại cho trẻ em vui chơi.', 4, 'img/bup_be_dien_thoai.jpg', 0),
(N'Búp bê Ragdoll', 22.00, 18, N'Búp bê trái tim cho trẻ em.', 4, 'img/bup_be_rag_doll.jpg', 0),
(N'Búp bê thời trang', 20.99, 28, N'Búp bê thời trang với nhiều phong cách cho trẻ.', 4, 'img/bup_be_thoi_trang.jpg', 0),

(N'Búp bê Rainbow High', 21.00, 12, N'Búp bê Rainbow High đầy màu sắc.', 4, 'img/rainbow_high.jpg', 0);


INSERT INTO Product (product_name, product_price, product_quantity, product_description, category_id, image_url, sold_quantity) 
VALUES 
(N'Bộ rổ bóng mini', 39.99, 25, N'Bộ rổ bóng mini giúp trẻ tập luyện và vui chơi ngoài trời.', 5, 'img/bo_ro_bong_mini.jpg', 0),
(N'Súng nước siêu tốc', 9.99, 30, N'Súng nước siêu tốc phù hợp cho các trò chơi nước ngoài trời.', 5, 'img/sung_nuoc_sieu_toc.jpg', 0),
(N'Đĩa bay nước', 8.00, 20, N'Đĩa bay nước cho các hoạt động ngoài trời thú vị.', 5, 'img/dia_bay_nuoc.jpg', 0),
(N'Bộ xe tải ngoài trời', 28.50, 12, N'Bộ xe tải đồ chơi chắc chắn, lý tưởng cho các hoạt động ngoài trời.', 5, 'img/bo_xe_tai.jpg', 0),
(N'Bóng đá mini', 35.00, 15, N'Bóng đá mini, phù hợp cho trẻ em chơi ngoài sân vườn.', 5, 'img/bong_da_mini.jpg', 0),
(N'Xích đu công viên', 14.99, 19, N'Xích đu mini cho trẻ vui chơi ngoài trời.', 5, 'img/xich_du_cong_vien.jpg', 0),
(N'Bóng hơi khổng lồ', 22.50, 18, N'Bóng hơi khổng lồ cho các trò chơi vận động ngoài trời.', 5, 'img/bong_hoi_khong_lo.jpg', 0);



SELECT * FROM [Users];
SELECT * FROM Category;
SELECT * FROM Product;
GO


