package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService {
	
	private BoardMapper mapper;
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register...."+board);
		
		mapper.insertSelectKey(board);
		
		if(board.getAttachList()==null || board.getAttachList().size() <=0) {
			return;
		}
		board.getAttachList().forEach(attach ->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(long bno) {
		log.info("GET.....");
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify....");
		attachMapper.deleteAll(board.getBno()); //첨부파일 모두 삭제
		boolean modifyResult = mapper.update(board)==1;
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size()>0) { //첨부파일 다시 첨부
			board.getAttachList().forEach(attach->{
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(long bno) {
		log.info("delete....");
		attachMapper.deleteAll(bno);
		return mapper.delete(bno)==1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		log.info("Get List with Criteria : "+cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(long bno) {
		log.info("글번호로 첨부파일 확인 : " +bno);
		return attachMapper.findByBno(bno);
	}
	

	//@Override
	//public List<BoardVO> getlist() {
		// TODO Auto-generated method stub
		//log.info("getList......");
		//return mapper.getList();
	//}

}
