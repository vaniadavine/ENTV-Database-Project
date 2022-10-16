--SIMULATION
USE ENTV

--Pendaftaran Staff laki-laki baru bernama Jeremy Matthew dengan email jeremymatthew@gmail.com dengan nomor telpon 081215679923
--yang beralamat di Apartemen Providentia H lantai 22, Jakarta Selatan dan lahir pada tanggal 20 April 1988
INSERT INTO MsStaff VALUES
('ST016', 'Jeremy Matthew', 'jeremymatthew@gmail.com', 'Male', '+6281215679923', 'Apartemen Providentia H lantai 22, Jakarta Selatan',
3500000, '1988-04-20')

--STAFF membeli produk dari vendor baru bernama 'Sumsang Abadi'
INSERT INTO MsVendor VALUES
('VE016', 'Sumsang Abadi', '0939344457', 'sumsangabadi@gmail.com', 
'Green Mansion blok 2F no 36, Jakarta Barat')

--Vendor menawarkan TV model baru kepada Staff
INSERT INTO MsTelevision VALUES
('TE016', 'Samsung Curve UHD 8K LC022', 'TB007', 2500000)

--Terjadi proses purchasing
INSERT INTO PurchaseHeader VALUES
('PE016','ST003','VE016','2015-11-22')
INSERT INTO PurchaseDetail VALUES
('PE016','TE016',25)

--Customer bernama Ilham ingin menjadi member
INSERT INTO MsCustomer VALUES
('CU016', 'Ilham Basudara', 'ilhambasudara@yahoo.com', 'Male', '+628124932949', 
'Jl. Raya lama Kav blok JE no 200, Jakarta Pusat', '2001-10-22')

--Ilham melakukan pembelian produk bernama 'Samsung Curve UHD 8K LC022' sebanyak 1 item
INSERT INTO SalesHeader VALUES
('SA016','ST003','CU016','2020-02-22')
INSERT INTO SalesDetail VALUES
('SA016','TE016',1)