package com.util;
import java.sql.*;

public class DBUtil {

    private static final String DRIVER;
    private static final String URL;
    private static final String USER;
    private static final String PWD;

    static {
        DRIVER = ConfigUtil.get("db.driver", "com.mysql.cj.jdbc.Driver");
        URL = ConfigUtil.get("db.url", "jdbc:mysql://localhost:3306/canteen_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai");
        USER = ConfigUtil.get("db.user", "YOUR_DB_USERNAME");
        PWD = ConfigUtil.get("db.password", "YOUR_DB_PASSWORD");
        try { Class.forName(DRIVER); } catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /**
     * 获取数据库连接，每次连接后强制设置UTF-8字符集
     */
    public static Connection getConnection() throws SQLException {
        Connection conn = DriverManager.getConnection(URL, USER, PWD);
        // 确保连接使用UTF-8编码，防止中文乱码
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("SET NAMES utf8mb4");
        }
        return conn;
    }

    /**
     * 关闭JDBC资源（ResultSet / Statement / Connection）
     * 按先开后关顺序释放，避免资源泄漏
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            // 关闭资源时忽略异常
        }
    }

    /**
     * 关闭JDBC资源（Statement / Connection）
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
