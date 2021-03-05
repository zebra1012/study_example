package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	//@Test
	public void testGetList() {
		log.info("--------------");
		mapper.getList().forEach(board -> log.info(board));
	}
	//@Test
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("!!!");
		board.setContent("!!!!!!!!");
		board.setWriter("???");
		
		mapper.insert(board);
		log.info("board");
		
	}
	//@Test
	public void testInsertSelectKey() {
		BoardVO board = new BoardVO();
		board.setTitle("!!!!! select Key!");
		board.setContent("!!!!!!!!!! select Key!");
		board.setWriter("???? select Key!");
		
		mapper.insertSelectKey(board);
		log.info(board);
	}
	//@Test
	public void testRead() {
		BoardVO board = mapper.read(1);
		log.info(board);
	}
	//@Test
	public void testDelete() {
		log.info("delete count :"+ mapper.delete(5));
	}
	
	//@Test
	public void tsetUpdate() {
		BoardVO board = new BoardVO();
		board.setBno(4);
		board.setTitle("바뀐 제목");
		board.setContent("바뀐 내용");
		board.setWriter("바뀐 작성자");
		
		int count=mapper.update(board);
		log.info("update count : "+count);
	}
	//@Test
	public void testPaging() {
		Criteria cri = new Criteria();
		cri.setPageNum(3);
		cri.setAmount(10);
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board.getBno()));
	}
	@Test
	public void testSearc() {
		Criteria cri = new Criteria();
		cri.setKeyword("새로");
		cri.setType("TC");
		List<BoardVO> list= mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));
	}
}
