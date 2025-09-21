<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.sist.dao.GameDAO" %>
<%@ page import="com.sist.vo.GameVO" %>
<%
    // DAO 호출해서 데이터 가져오기
    GameDAO dao = GameDAO.newInstance();
    List<GameVO> list = dao.gamelist();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game List</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<style>
  .container { margin-top: 40px; }
  table { font-size: 14px; }
  th, td { text-align: center; vertical-align: middle !important; }
</style>
</head>
<body>
<div class="container">
  <h3 class="text-center">게임 리스트</h3>
  <hr>
  <%
    if (list == null || list.isEmpty()) {
  %>
    <div class="alert alert-info">데이터가 없습니다.</div>
  <%
    } else {
  %>
  <table class="table table-bordered table-hover table-striped">
    <thead>
      <tr>
        <th>#</th>
        <th>Kickoff At</th>
        <th>Home Team ID</th>
        <th>Away Team ID</th>
        <th>Stadium</th>
        <th>Home Score</th>
        <th>Away Score</th>
      </tr>
    </thead>
    <tbody>
      <%
        int idx = 1;
        for (GameVO vo : list) {
      %>
      <tr>
        <td><%= idx++ %></td>
        <td><%= vo.getKickoffat() %></td>
        <td><%= vo.getHometeam() %></td>
        <td><%= vo.getAwayteam() %></td>
        <td><%= vo.getStadium() %></td>
        <td><%= vo.getHomescore() %></td>
        <td><%= vo.getAwayscore() %></td>
      </tr>
      <%
        } // end for
      %>
    </tbody>
  </table>
  <%
    } // end else
  %>
</div>
</body>
</html>
