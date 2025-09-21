<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.sist.dao.GameDAO" %>
<%@ page import="com.sist.vo.GameVO" %>
<%@ page import="com.sist.vo.ScoreVO" %>
<%
  request.setCharacterEncoding("UTF-8");

  // 1) 라운드 파라미터
  String sRound = request.getParameter("round");
  int round = 1;
  try { if (sRound != null) round = Integer.parseInt(sRound); } catch(Exception ignore){}
  if (round < 1) round = 1;
  if (round > 38) round = 38;

  // 2) 데이터 조회
  GameDAO dao = GameDAO.newInstance();
  List<GameVO> games = dao.gamesByRound(round);                 // 경기 카드(중복 없음)
  List<String> gameIds = new ArrayList<>();
  if (games != null) {
    for (GameVO g : games) gameIds.add(g.getGameId());
  }
  Map<String, List<ScoreVO>> scoreMap = dao.findScoresByGameIds(gameIds); // 득점 이벤트 배치

  String ctx = request.getContextPath();                 // 예: /KLeague
  String defaultLogo = ctx + "/images/default.png";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>라운드별 경기</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<style>
  body { background:#111; color:#eee; }
  .wrap { max-width:1000px; margin: 36px auto; }
  .toolbar { display:flex; gap:10px; align-items:center; margin-bottom:16px; }
  .grid { display:grid; grid-template-columns: repeat(2, 1fr); gap:16px; }
  @media (max-width: 800px){ .grid { grid-template-columns: 1fr; } }
  .card { background:#1a1a1a; border-radius:14px; padding:16px 18px; box-shadow:0 6px 14px rgba(0,0,0,.35); }

  .date { text-align:center; font-weight:700; font-size:16px; margin-bottom:4px; }
  .meta { text-align:center; color:#bdbdbd; font-size:13px; margin-bottom:10px; }

  /* 핵심: 점수 칸이 퍼센트 고정폭이 되도록 3열 그리드 사용 */
  .row-line {
    display: grid;
    grid-template-columns: 44% 12% 44%; /* 좌/점수/우 비율 고정 */
    align-items: center;
  }
  @media (max-width: 520px){
    .row-line { grid-template-columns: 40% 20% 40%; }
  }

  .team {
    display: flex;
    align-items: center;
    gap: 10px;
    overflow: hidden; /* 긴 팀명 잘림 처리 */
  }
  .team img { width:34px; height:34px; border-radius:8px; object-fit:contain; background:#2a2a2a; }
  .team .name {
    display: inline-block;
    max-width: calc(100% - 44px); /* 로고(34) + 여백 대략(10) */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .team.away { justify-self: end; flex-direction: row-reverse; }
  .team.away .name { text-align: right; }

  .score {
    justify-self: center;
    text-align: center;
    font-weight: 800;
    font-size: 22px;
    background:#2a2a2a;
    padding:8px 14px;
    border-radius:10px;
    min-width: 86px;
  }

  .badge { display:inline-block; padding:3px 9px; border-radius:999px; font-size:12px; font-weight:700; margin-bottom:6px; }
  .homewin { background:#5cb85c; color:#fff; }   /* 홈승 */
  .awaywin { background:#d9534f; color:#fff; }   /* 원정승 */
  .draw { background:#5bc0de; color:#fff; }   /* 무승부 */

  .events { display:flex; gap:16px; margin-top:12px; font-size:12.5px; color:#d4d4d4; }
  .events .col { flex:1; background:#181818; border-radius:10px; padding:10px; min-height:46px; }
  .events .title { font-weight:700; color:#bbb; margin-bottom:6px; }
  .events ul { padding-left:18px; margin:0; }
  .events li { line-height:1.5; }
</style>
</head>
<body>
<div class="wrap">
  <h3>라운드별 경기</h3>

  <!-- 라운드 선택 -->
  <form class="toolbar" method="get" action="<%= ctx %>/game/round_games.jsp">
    <label>라운드</label>
    <select name="round" class="form-control" style="width:120px;" onchange="this.form.submit()">
      <%
        for (int i=1;i<=30;i++){
          String sel = (i==round) ? "selected" : "";
      %>
        <option value="<%=i%>" <%=sel%>><%=i%>R</option>
      <% } %>
    </select>
    <noscript><button class="btn btn-primary" type="submit">보기</button></noscript>
  </form>

  <div class="grid">
    <%
      if (games==null || games.isEmpty()){
    %>
      <div class="card">
        <div class="date">데이터 없음</div>
        <div class="meta">해당 라운드(<%=round%>R) 경기 정보가 없습니다.</div>
      </div>
    <%
      } else {
        for (GameVO vo : games) {

          // kickoff_at "YYYY-MM-DD HH:MM" 가정
          String kickoff = (vo.getKickoffat()==null ? "" : vo.getKickoffat().trim());
          String dateStr = kickoff, timeStr = "";
          int sp = kickoff.indexOf(' ');
          if (sp>0){ dateStr = kickoff.substring(0,sp); timeStr = kickoff.substring(sp+1); }

          // 로고 경로 만들기
          String homeLogo = vo.getHomeLogo();
          String awayLogo = vo.getAwayLogo();
          if (homeLogo==null || homeLogo.isEmpty()) homeLogo = defaultLogo;
          else if (homeLogo.startsWith("http")) { /* 그대로 */ }
          else if (homeLogo.startsWith("/")) homeLogo = ctx + homeLogo;
          else homeLogo = ctx + "/" + homeLogo;

          if (awayLogo==null || awayLogo.isEmpty()) awayLogo = defaultLogo;
          else if (awayLogo.startsWith("http")) { /* 그대로 */ }
          else if (awayLogo.startsWith("/")) awayLogo = ctx + awayLogo;
          else awayLogo = ctx + "/" + awayLogo;

          // 결과 배지 (점수로 계산)
          String result = (vo.getHomescore() > vo.getAwayscore()) ? "HOME"
                        : (vo.getHomescore() < vo.getAwayscore()) ? "AWAY" : "DRAW";
          String badgeCls = "draw";
          String badgeTxt = "무승부";
          if ("HOME".equals(result)) { badgeCls="homewin"; badgeTxt="홈승"; }
          else if ("AWAY".equals(result)) { badgeCls="awaywin"; badgeTxt="원정승"; }

          // 득점 이벤트 가져오기 (타임라인)
          List<ScoreVO> evs = (scoreMap==null) ? null : scoreMap.get(vo.getGameId());
          List<ScoreVO> homeList = new ArrayList<ScoreVO>();
          List<ScoreVO> awayList = new ArrayList<ScoreVO>();
          if (evs != null) {
            for (ScoreVO s : evs) {
              if ("HOME".equals(s.getSide())) homeList.add(s);
              else if ("AWAY".equals(s.getSide())) awayList.add(s);
            }
          }
    %>
      <div class="card">
        <div style="text-align:center;">
          <span class="badge <%=badgeCls%>"><%=badgeTxt%></span>
        </div>
        <div class="date"><%= dateStr %></div>
        <div class="meta"><%= vo.getStadium()==null?"":vo.getStadium() %> <%= timeStr.isEmpty()?"":"· "+timeStr %></div>

        <!-- 팀/점수 행 (고정 비율) -->
        <div class="row-line">
          <div class="team">
            <img src="<%= homeLogo %>" alt="<%= vo.getHometeam() %> 로고">
            <strong class="name"><%= vo.getHometeam()==null?"":vo.getHometeam() %></strong>
          </div>

          <div class="score">
            <%= vo.getHomescore() %> &nbsp;:&nbsp; <%= vo.getAwayscore() %>
          </div>

          <div class="team away">
            <img src="<%= awayLogo %>" alt="<%= vo.getAwayteam() %> 로고">
            <strong class="name"><%= vo.getAwayteam()==null?"":vo.getAwayteam() %></strong>
          </div>
        </div>

        <!-- 상세: 득점 타임라인 (홈/어웨이) -->
        <div class="events">
          <div class="col">
            <div class="title">홈 득점</div>
            <%
              if (homeList.isEmpty()) {
            %>
              <div>—</div>
            <%
              } else {
            %>
              <ul>
                <%
                  for (ScoreVO s : homeList) {
                    String line = (s.getScorePlayer()==null ? "" : s.getScorePlayer())
                                + " " + s.getScoreTime() + "'";   // int 분 + ' 표시
                    if (s.getAssistPlayer()!=null && !s.getAssistPlayer().isEmpty()) {
                      line += " (" + s.getAssistPlayer() + ")";
                    }
                %>
                  <li><%= line %></li>
                <%
                  } // end for homeList
                %>
              </ul>
            <%
              } // end else
            %>
          </div>

          <div class="col">
            <div class="title">원정 득점</div>
            <%
              if (awayList.isEmpty()) {
            %>
              <div>—</div>
            <%
              } else {
            %>
              <ul>
                <%
                  for (ScoreVO s : awayList) {
                    String line = (s.getScorePlayer()==null ? "" : s.getScorePlayer())
                                + " " + s.getScoreTime() + "'";
                    if (s.getAssistPlayer()!=null && !s.getAssistPlayer().isEmpty()) {
                      line += " (" + s.getAssistPlayer() + ")";
                    }
                %>
                  <li><%= line %></li>
                <%
                  } // end for awayList
                %>
              </ul>
            <%
              } // end else
            %>
          </div>
        </div>
      </div>
    <%
        } // end for games
      } // end else (games empty)
    %>
  </div>
</div>
</body>
</html>
