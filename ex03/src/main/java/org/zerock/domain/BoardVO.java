package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data //Lombok 이용, Setter 자동생성
public class BoardVO {
	private long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;
	private int replyCnt;

}
