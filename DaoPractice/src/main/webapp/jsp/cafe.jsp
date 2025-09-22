<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" import="com.sist.dao.*" %>
<!DOCTYPE html>
<%
	 String cno=request.getParameter("cno");
	 if(cno==null) cno="1";
	 CoffeeDAO dao=CoffeeDAO.newInstance();
	 List<String> list=dao.cafeMenu(Integer.parseInt(cno));
	 
%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.cafe {
		display: flex;
	}
	
	.cate {
		width: 30%;
		height: 100%;
	}
	.menu {
		width: 70%;
		height: 100%;
		font-size: 20px;
	}
	
</style>
</head>
<body>
	<h1>카페 메뉴</h1>
	<div class=cafe>
		<div class="cate">
			<a href="cafe.jsp?cno=1">신음료</a><br>
			<a href="cafe.jsp?cno=2">에소프레소 음료</a><br>
			<a href="cafe.jsp?cno=3">브루드 커피</a><br>
			<a href="cafe.jsp?cno=4">티</a><br>
			<a href="cafe.jsp?cno=5">티 라떼</a><br>
			<a href="cafe.jsp?cno=6">아이스 블렌디드</a><br>
			<a href="cafe.jsp?cno=7">아이스 블렌디드(NON-COFFEE)</a><br>
			<a href="cafe.jsp?cno=8">커피빈 주스(병음료)</a><br>
			<a href="cafe.jsp?cno=9">기타 제조 음료</a><br>
		</div>
		
		<div class="menu">
		<%
			for (int i=0; i<list.size(); i++) {
				if(i%2==0) {
					%>
						<img src=<%= list.get(i)%> style="width: 30px; height: 40px;">
					<% 
					
				} else {
					%>
						<%=list.get(i) %><br><br>
					<% 
				}
		%>
		<%
			}
		%>
		</div>
	</div>
</body>
</html>