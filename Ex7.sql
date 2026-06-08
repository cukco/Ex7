-- Tạo index
CREATE INDEX idx_taikhoan_khachhang ON taikhoan(khach_hang_id);

--part1.1--
create or replace procedure chuyen_tien(
    p_tk_gui int,
    p_tk_nhan int,
    p_sotien numeric(15,2),
    p_noi_dung text
) language plpgsql
as $$
    declare
        status_gui varchar(20);
        status_nhan varchar(20);
        du_gui numeric(15,2);
        du_nhan numeric(15,2);
        id_khach_nhan int;
        id_khach_gui int;
    begin
        --Nhập trạng thái tài khoản gửi vào declare
        select trang_thai into status_gui from taikhoan
        where id=p_tk_gui;

        -- Nhập trạng thái tài khoản nhận vào declare
        select trang_thai into status_nhan from taikhoan
        where id=p_tk_nhan;

        -- Nhập số dư người gửi vào declare
        select so_du into du_gui from taikhoan
        where id=p_tk_gui;

        -- Nhập số dư người nhận vào declare
        select so_du into du_nhan from taikhoan
        where id=p_tk_nhan;

        -- Nhập id khách hàng gửi vào declare
        select khach_hang_id into id_khach_gui from taikhoan
        where id=p_tk_gui;

        -- Nhập id khách hàng nhận vào declare
        select khach_hang_id into id_khach_nhan from taikhoan
        where id=p_tk_nhan;

        -- Roll back ngay khi không tồn tại tài khoản or tkhoan ko active
        if status_gui != 'Active' or status_nhan!='Active' then
            raise exception 'Chuyển tiền không thành công';
        end if;

        -- Ko đủ tiền
        if du_gui < p_sotien then
            raise exception 'Tài khoản không đủ tiền';
        end if;

        -- Update số dư
        update taikhoan
        set so_du=so_du-p_sotien where id=p_tk_gui;

        update taikhoan
        set so_du=so_du+p_sotien where id=p_tk_nhan;

        --Update tổng số dư
        update khachhang
        set so_du_tong = so_du_tong-p_sotien where id=id_khach_gui;

        update khachhang
        set so_du_tong = so_du_tong+p_sotien where id=id_khach_nhan;

        -- Lưu lịch sử số dư
        insert into lichsusodu(tai_khoan_id, so_du_truoc, so_du_sau, thoi_gian) values
        (p_tk_gui,du_gui,du_gui-p_sotien,current_timestamp);

        insert into lichsusodu(tai_khoan_id, so_du_truoc, so_du_sau, thoi_gian) values
            (p_tk_nhan,du_nhan,du_nhan+p_sotien,current_timestamp);

        --Lưu vào bảng giao dịch
        insert into giaodich(ma_gd, tai_khoan_id, loai_gd, so_tien, tai_khoan_doi_tac, noi_dung,trang_thai) values
            ('xxxx',p_tk_gui,'CHUYEN_TIEN',p_sotien,p_tk_nhan,p_noi_dung,'SUCCESS');
    end;
$$;

--part1.2--
create or replace procedure rut_tien(
    p_tk int,
    p_tien int
) language plpgsql
as $$
    declare
        p_sodu numeric(15,2);
        p_status varchar(20);
    begin
        select so_du into p_sodu from taikhoan
        where id=p_tk;

        select p_status into p_status from taikhoan
        where id=p_tk;

        if p_status!='Active' or p_sodu < p_tien then
            raise exception 'Tài khoản không đủ tiền/Không tồn tại tài khoản';
        end if;

        insert into lichsusodu(tai_khoan_id, so_du_truoc, so_du_sau, thoi_gian) values
        (p_tk,p_sodu,p_sodu-p_tien,current_timestamp);

        insert into giaodich(ma_gd, tai_khoan_id, loai_gd, so_tien, tai_khoan_doi_tac, noi_dung,trang_thai) values
            ('xxxx',p_tk,'RUT_TIEN',p_tien,null,null,'SUCCESS');
    end;
$$;

call rut_tien(1,500000);

--part 2--
create or replace procedure thong_tin_tai_khoan(
    p_tk int,
    out name varchar(100),
    out sodu numeric(15,2),
    out tong_success int
) language plpgsql
as $$
    declare
        p_kh int;
    begin
        select khach_hang_id into p_kh from taikhoan
        where p_tk=id;

        if p_kh is null  then
            raise exception 'Lỗi';
        end if;

        select ho_ten into name from khachhang
        where id=p_kh;

        select so_du into sodu from taikhoan
        where p_tk=id;

        select count(*) filter (where trang_thai='SUCCESS') into tong_success from giaodich
        where tai_khoan_id=p_tk;
    end;
$$;

call thong_tin_tai_khoan(2,null,null,null);


