<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.sist.dao.BoardDAO" %>
<%@ page import="com.sist.vo.BoardVO" %>
<%
    BoardDAO dao = BoardDAO.newInstance();
    List<BoardVO> list = dao.boardListData();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
</head>
<body>
<h2>게시판</h2>
<p><a href="create.jsp">글쓰기</a></p>

<table border="1" cellpadding="5" cellspacing="0">
  <tr>
    <th>No</th>
    <th>제목</th>
    <th>내용</th>
    <th>작성자</th>
    <th>작성일</th>
  </tr>
  <%
    for(BoardVO vo : list){
  %>
  <tr>
    <td><%= vo.getNo() %></td>
    <td><%= vo.getTitle() %></td>
    <td><%= vo.getContent() %></td>
    <td><%= vo.getAuthor() %></td>
    <td><%= vo.getCreateat() %></td>
  </tr>
  <%
    }
    if(list==null || list.isEmpty()){
  %>
  <tr>
    <td colspan="4">등록된 글이 없습니다.</td>
  </tr>
  <% } %>
</table>
</body>
</html>
