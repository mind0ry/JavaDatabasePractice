package com.sist.dao;
import java.util.*;
import java.sql.*;

public class CoffeeDAO {

		private Connection conn;
		private PreparedStatement ps;
		
		private static final String URL ="jdbc:oracle:thin:@localhost:1521:xe";
		
		// 하나의 dao를 사용 
		public static CoffeeDAO dao;
		
		public CoffeeDAO() {
			// 드라이버 생성
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
			} catch (Exception ex) {}
		}
		
		// 싱글턴 연결 
		public static CoffeeDAO newInstance() {
			if(dao==null)
				dao=new CoffeeDAO();
			return dao;
		}
		// 연결
		public void getConnection() {
			try {
				conn=DriverManager.getConnection(URL,"system","1234");
			} catch (Exception ex) {}
		}
		// 해제
		public void disConnection() {
			try {
				if(ps!=null) ps.close();
				if(conn!=null) conn.close();
			} catch (Exception ex) {}
		}
		
		public List<String> cafeMenu(int cno) {
			List<String> list=new ArrayList<String>();
			try {
				getConnection();
				String sql="SELECT image,korname "
						+ "FROM cafe_menu "
						+ "WHERE cno="+cno;
				
				ps=conn.prepareStatement(sql);
				
				ResultSet rs=ps.executeQuery();
				
				while(rs.next()) {
					list.add(rs.getString(1));
					list.add(rs.getString(2));
				}
				rs.close();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				disConnection();
			}
			return list;
		}
		
}
