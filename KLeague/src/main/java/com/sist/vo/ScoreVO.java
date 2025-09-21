package com.sist.vo;

import lombok.Data;

/*
SCORE_ID         NUMBER(38)   
GAME_ID          VARCHAR2(26) 
TEAM_ID          NUMBER(38)   
SCORE_PLAYER     VARCHAR2(26) 
ASSIST_PLAYER    VARCHAR2(26) 
SCORE_TIME       NUMBER(38)   
 */
@Data
public class ScoreVO {
	private int scoreId,teamId,scoreTime;
	private String gameId,scorePlayer,assistPlayer,side;
}
