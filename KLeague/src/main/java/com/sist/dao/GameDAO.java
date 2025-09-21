package com.sist.dao;
import java.util.List;
import java.util.Map;

import com.sist.vo.ScoreVO;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import com.sist.vo.GameVO;

public class GameDAO {
	private Connection conn;
	private PreparedStatement ps;
	private static GameDAO dao;
	
	private static final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	
	public GameDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (Exception ex) {}
	}
	public static GameDAO newInstance() {
		if(dao==null) 
			dao=new GameDAO();
		return dao;
	}
	
	//연결 
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
	/*
	GAME_ID         VARCHAR2(26) 
	ROUND           NUMBER(38)   
	KICKOFF_AT      VARCHAR2(26) 
	HOME_TEAM_ID    NUMBER(38)   
	AWAY_TEAM_ID    NUMBER(38)   
	STADIUM         VARCHAR2(40) 
	HOME_SCORE      NUMBER(38)   
	AWAY_SCORE      NUMBER(38)   
	 */
	public List<GameVO> gamelist() {
		List<GameVO> list=new ArrayList<>();
		try {
			getConnection();
			String sql =
				    "SELECT g.game_id, g.round, g.kickoff_at, "
				  + "       ht.team_name AS hometeam, ht.logo_url AS home_logo, "
				  + "       aw.team_name AS awayteam, aw.logo_url AS away_logo, "
				  + "       g.stadium, g.home_score, g.away_score "
				  + "FROM game g "
				  + "JOIN team ht ON g.home_team_id = ht.team_id "
				  + "JOIN team aw ON g.away_team_id = aw.team_id "
				  + "WHERE g.round = ? "
				  + "ORDER BY g.kickoff_at";

			ps=conn.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				GameVO vo=new GameVO();
				vo.setKickoffat(rs.getString(1));
				vo.setHometeam(rs.getString(2)); 
				vo.setAwayteam(rs.getString(3));
				vo.setStadium(rs.getString(4));
				vo.setHomescore(rs.getInt(5));
				vo.setAwayscore(rs.getInt(6));
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
	
	// 라운드별 카드 목록 (경기당 1행)
	public List<GameVO> gamesByRound(int round) {
	    List<GameVO> list = new ArrayList<>();
	    try {
	        getConnection();
	        String sql =
	            "SELECT g.game_id, g.round, g.kickoff_at, g.stadium, " +
	            "       ht.team_name AS hometeam, ht.logo_url AS home_logo, " +
	            "       aw.team_name AS awayteam, aw.logo_url AS away_logo, " +
	            "       g.home_score, g.away_score " +
	            "FROM game g " +
	            "JOIN team ht ON g.home_team_id = ht.team_id " +
	            "JOIN team aw ON g.away_team_id = aw.team_id " +
	            "WHERE g.round = ? " +
	            "ORDER BY g.kickoff_at";
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, round);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                GameVO vo = new GameVO();
	                vo.setGameId(rs.getString("game_id"));
	                vo.setRound(rs.getInt("round"));
	                vo.setKickoffat(rs.getString("kickoff_at"));
	                vo.setHometeam(rs.getString("hometeam"));
	                vo.setAwayteam(rs.getString("awayteam"));
	                vo.setHomeLogo(rs.getString("home_logo"));
	                vo.setAwayLogo(rs.getString("away_logo"));
	                vo.setStadium(rs.getString("stadium"));
	                vo.setHomescore(rs.getInt("home_score"));
	                vo.setAwayscore(rs.getInt("away_score"));
	                list.add(vo);
	            }
	        }
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    } finally {
	        disConnection();
	    }
	    return list;
	}
	
	public Map<String, List<ScoreVO>> findScoresByGameIds(List<String> gameIds) {
	    Map<String, List<ScoreVO>> map = new HashMap<>();
	    if (gameIds == null || gameIds.isEmpty()) return map;

	    try {
	        getConnection();
	        String placeholders = String.join(",", Collections.nCopies(gameIds.size(), "?"));
	        String sql =
	            "SELECT sc.game_id, sc.team_id, sc.score_player, sc.assist_player, sc.score_time, " +
	            "       CASE WHEN sc.team_id = g.home_team_id THEN 'HOME' " +
	            "            WHEN sc.team_id = g.away_team_id THEN 'AWAY' END AS side " +
	            "FROM score sc " +
	            "JOIN game g ON sc.game_id = g.game_id " +
	            "WHERE sc.game_id IN (" + placeholders + ") " +
	            "ORDER BY sc.game_id, sc.score_time";
	        ps = conn.prepareStatement(sql);

	        int i = 1;
	        for (String id : gameIds) ps.setString(i++, id);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                ScoreVO vo = new ScoreVO();
	                vo.setGameId(rs.getString("game_id"));
	                vo.setTeamId(rs.getInt("team_id"));
	                vo.setScorePlayer(rs.getString("score_player"));
	                vo.setAssistPlayer(rs.getString("assist_player"));
	                vo.setScoreTime(rs.getInt("score_time"));
	                vo.setSide(rs.getString("side"));

	                map.computeIfAbsent(vo.getGameId(), k -> new ArrayList<>()).add(vo);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        disConnection();
	    }
	    return map;
	}

	

}
