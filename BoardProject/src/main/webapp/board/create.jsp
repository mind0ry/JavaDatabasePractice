<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.dao.BoardDAO" %>
<%@ page import="com.sist.vo.BoardVO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // POST 처리
    if("POST".equalsIgnoreCase(request.getMethod())){
        String author  = request.getParameter("author");
        String title   = request.getParameter("title");
        String content = request.getParameter("content");

        if(author!=null && title!=null && content!=null
           && !author.trim().isEmpty() && !title.trim().isEmpty() && !content.trim().isEmpty()){
            BoardVO vo = new BoardVO();
            vo.setAuthor(author);
            vo.setTitle(title);
            vo.setContent(content);

            BoardDAO dao = BoardDAO.newInstance();
            dao.boardInsert(vo);

            response.sendRedirect("boardList.jsp");
            return; // 아래 HTML 출력 방지
        } else {
            request.setAttribute("error", "모든 필드를 입력하세요.");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
</head>
<body>
<h2>글쓰기</h2>
<% if(request.getAttribute("error") != null){ %>
  <p><%= request.getAttribute("error") %></p>
<% } %>

<form method="post" action="create.jsp">
  <div>
    <label>작성자</label><br>
    <input type="text" name="author">
  </div>
  <div>
    <label>제목</label><br>
    <input type="text" name="title" style="width:400px">
  </div>
  <div>
    <label>내용</label><br>
    <textarea name="content" rows="10" cols="60"></textarea>
  </div>
  <div style="margin-top:8px;">
    <button type="submit">등록</button>
    <a href="boardList.jsp">목록</a>
  </div>
</form>
</body>
</html>
