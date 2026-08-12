import java.sql.*;
import java.util.Scanner;

public class ProductApp {
    private static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        while (true) {
            System.out.println("\n********************PRODUCT MANAGEMENT****************");
            System.out.println("1. Danh sách sản phẩm");
            System.out.println("2. Thêm mới sản phẩm");
            System.out.println("3. Cập nhật sản phẩm");
            System.out.println("4. Xóa sản phẩm");
            System.out.println("5. Tìm kiếm sản phẩm theo tên");
            System.out.println("6. Sắp xếp sản phẩm theo giá tăng dần");
            System.out.println("7. Thống kê số lượng sản phẩm theo danh mục");
            System.out.println("8. Thoát");
            System.out.print("Lựa chọn của bạn: ");
            int choice = Integer.parseInt(sc.nextLine());

            switch (choice) {
                case 1: showAllProducts("{ call show_all_products(?) }"); break;
                case 2: insertProduct(); break;
                case 3: updateProduct(); break;
                case 4: deleteProduct(); break;
                case 5: searchByName(); break;
                case 6: showAllProducts("{ call sort_by_price_asc(?) }"); break;
                case 7: countByCatalog(); break;
                case 8: System.exit(0);
                default: System.out.println("Lựa chọn không hợp lệ!");
            }
        }
    }

    private static void showAllProducts(String sqlCall) {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (CallableStatement cstmt = con.prepareCall(sqlCall)) {
                cstmt.setString(1, "res_cursor");
                cstmt.registerOutParameter(1, Types.OTHER);
                cstmt.execute();
                try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                    System.out.printf("%-5s | %-20s | %-10s | %-15s | %-10s\n", "ID", "Tên", "Giá", "Danh mục", "Ngày tạo");
                    while (rs.next()) {
                        System.out.printf("%-5d | %-20s | %-10.2f | %-15s | %-10s\n",
                                rs.getInt(1), rs.getString(2), rs.getDouble(3), rs.getString(6), rs.getDate(5));
                    }
                }
            }
            con.commit();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private static void insertProduct() {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall("CALL insert_product(?,?,?,?)")) {

            System.out.print("Nhập tên sản phẩm: "); String name = sc.nextLine();
            System.out.print("Nhập giá sản phẩm: "); double price = Double.parseDouble(sc.nextLine());
            System.out.print("Nhập tiêu đề: "); String title = sc.nextLine();
            System.out.print("Nhập danh mục: "); String catalog = sc.nextLine();

            if (name.isEmpty() || price <= 0) {
                System.out.println("Dữ liệu không hợp lệ!"); return;
            }

            cstmt.setString(1, name);
            cstmt.setDouble(2, price);
            cstmt.setString(3, title);
            cstmt.setString(4, catalog);
            cstmt.executeUpdate();
            System.out.println("Thêm thành công!");
        } catch (SQLException e) { System.out.println("Lỗi: Tên sản phẩm có thể đã tồn tại!"); }
    }

    private static void updateProduct() {
        System.out.print("Nhập ID cần sửa: "); int id = Integer.parseInt(sc.nextLine());
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall("CALL update_product(?,?,?,?,?)")) {
            System.out.print("Tên mới: "); String name = sc.nextLine();
            System.out.print("Giá mới: "); double price = Double.parseDouble(sc.nextLine());
            System.out.print("Tiêu đề mới: "); String title = sc.nextLine();
            System.out.print("Danh mục mới: "); String catalog = sc.nextLine();

            cstmt.setInt(1, id);
            cstmt.setString(2, name);
            cstmt.setDouble(3, price);
            cstmt.setString(4, title);
            cstmt.setString(5, catalog);
            cstmt.executeUpdate();
            System.out.println("Cập nhật thành công!");
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private static void deleteProduct() {
        System.out.print("Nhập ID cần xóa: "); int id = Integer.parseInt(sc.nextLine());
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall("CALL delete_product(?)")) {
            cstmt.setInt(1, id);
            cstmt.executeUpdate();
            System.out.println("Xóa thành công!");
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private static void searchByName() {
        System.out.print("Nhập tên cần tìm: "); String search = sc.nextLine();
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (CallableStatement cstmt = con.prepareCall("{ call search_product_by_name(?, ?) }")) {
                cstmt.setString(1, search);
                cstmt.setString(2, "search_cur");
                cstmt.registerOutParameter(2, Types.OTHER);
                cstmt.execute();
                try (ResultSet rs = (ResultSet) cstmt.getObject(2)) {
                    while (rs.next()) {
                        System.out.println(rs.getInt(1) + " - " + rs.getString(2));
                    }
                }
            }
            con.commit();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private static void countByCatalog() {
        System.out.print("Nhập tên danh mục: "); String cat = sc.nextLine();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall("{ call count_by_catalog(?, ?) }")) {
            cstmt.setString(1, cat);
            cstmt.registerOutParameter(2, Types.INTEGER);
            cstmt.execute();
            System.out.println("Số lượng sản phẩm trong danh mục " + cat + " là: " + cstmt.getInt(2));
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
