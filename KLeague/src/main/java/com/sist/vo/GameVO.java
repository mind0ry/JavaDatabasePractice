package com.sist.vo;

import lombok.Data;

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
@Data
public class GameVO {
	private int round,homescore,awayscore;
	private String gameId,kickoffat,stadium,homeLogo,awayLogo;
	private String hometeam,awayteam;
}
