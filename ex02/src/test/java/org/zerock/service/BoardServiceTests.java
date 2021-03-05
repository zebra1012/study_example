package org.zerock.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {
	@Autowired
	private BoardService service;
	
	//@Test
	public void testExist() {
		log.info(service);
		assertNotNull(service);
	}
	//@Test
	public void testRegister() {
		BoardVO board = new BoardVO();
		board.setTitle("서비스 등록");
		board.setContent("서비스 등록");
		board.setWriter("서비스");
		
		service.register(board);
		
		log.info("생성된 게시글 :"+ board.getBno());
	}
	
	//@Test
	public void testGetList() {
		 //service.getlist().forEach(board ->log.info(board));
		service.getList(new Criteria(2,10)).forEach(board -> log.info(board));
	}
	
	//@Test
	public void testGet() {
		log.info(service.get(7L));
	}
	
	@Test
	public void testDelete() {
		log.info("삭제 결과 : "+service.remove(7));
	}
	
	@Test
	public void testModify() {
		BoardVO board = service.get(1);
		if(board==null) return;
		board.setTitle("제목 수정");
		log.info("수정 결과 :" +service.modify(board));
	}
}
