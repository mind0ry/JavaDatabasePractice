package com.sist.vo;
import java.util.*;

import lombok.Data;

@Data
public class BoardVO {
	private int no;
	private String title,content,author;
	private Date createat;
}
