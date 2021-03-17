package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service;
	
	private void deleteFiles(List<BoardAttachVO> attachList) { //파일 삭제 매서드
		if(attachList==null || attachList.size() ==0) {
			return;
		}
		log.info("첨부 파일 삭제 시작");
		log.info(attachList);
		
		attachList.forEach(attach->{
			try {
				Path file = Paths.get("D:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("D:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			}catch (Exception e) {
				log.error("삭제 중 문제 발생" + e.getMessage());
			} 
		});
	}
	
	
	@GetMapping("/list")
	public void list(Criteria cri,Model model) {
		//log.info("list: "+cri);
		model.addAttribute("list",service.getList(cri));
		//model.addAttribute("pageMaker",new PageDTO(cri,123));
		int total=service.getTotal(cri);
		//log.info("total: " +total);
		model.addAttribute("pageMaker",new PageDTO(cri,total));
	}
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		//log.info("register: " + board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach ->log.info(attach));
		}
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	@GetMapping({"/get","/modify"}) //매핑을 배열로 처리할 수 있다.
	public void get(@RequestParam("bno") long bno, @ModelAttribute("cri") Criteria cri, Model model){
		//log.info("/get or modify");
		model.addAttribute("board",service.get(bno));
	}
	@PreAuthorize("principal.username==#board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr,@ModelAttribute("cri") Criteria cri) {
		//log.info("modify:"+board);
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");
		}
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());
		
		return "redirect:/board/list";
	}
	@PreAuthorize("principal.username==#writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") long bno, RedirectAttributes rttr,@ModelAttribute("cri") Criteria cri) {
		//log.info("remove"+bno);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {
			deleteFiles(attachList); //첨부 파일 삭제
			rttr.addFlashAttribute("result","success");
		}
		//rttr.addAttribute("pageNum",cri.getPageNum());
		//rttr.addAttribute("amount",cri.getAmount());
		//rttr.addAttribute("type",cri.getType());
		//rttr.addAttribute("keyword",cri.getKeyword());
		
		return "redirect:/board/list"+cri.getListLink();
	}
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
		
	}
	
	@GetMapping(value= "/getAttachList",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(long bno){
		log.info("getAttachList " + bno);
		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
	}
}
