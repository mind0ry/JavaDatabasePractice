package com.sist.dao;
import java.util.*;
import java.sql.*;
import com.sist.vo.*;

public class BoardDAO {
	private Connection conn;
	private PreparedStatement ps;
	
	private static final String URL="jdbc:oracle:thin:@localhost:1521:xe";
	
	public static BoardDAO dao;
	
	public BoardDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (Exception ex) {}
	}
	
	public static BoardDAO newInstance() {
		if(dao==null) {
			dao=new BoardDAO();
		}
		return dao;
	}
	
	public void getConnection() {
		try {
			conn=DriverManager.getConnection(URL,"system","1234");
		} catch (Exception ex) {}
	}
	
	public void disConnection() {
		try {
			if(ps!=null) ps.close();
			if(conn!=null) conn.close();
		} catch (Exception ex) {}
	}

	// 전체 글 조회 : SELECT
	public List<BoardVO> boardListData() {
		List<BoardVO> list=new ArrayList<BoardVO>();
		try {
			getConnection();
			String sql="SELECT no,title,content,author,create_at FROM board "
					+ "ORDER BY create_at DESC";
			
			ps=conn.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			
			while(rs.next()) {
				BoardVO vo=new BoardVO();
				vo.setNo(rs.getInt(1));
				vo.setTitle(rs.getString(2));
				vo.setContent(rs.getString(3));
				vo.setAuthor(rs.getString(4));
				vo.setCreateat(rs.getDate(5));
				list.add(vo);
			}
			rs.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			disConnection();
		}
	return list;
	}
	
	// 글 작성 : INSERT
	public void boardInsert(BoardVO vo) {
		try {
			getConnection();
			String sql="INSERT INTO board VALUES(board_no_seq.NEXTVAL,?,?,?,SYSDATE)";
			
		ps=conn.prepareStatement(sql);
		ps.setString(1, vo.getAuthor());
		ps.setString(2, vo.getTitle());
		ps.setString(3, vo.getContent());
		ps.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			disConnection();
		}
	}
}

	
