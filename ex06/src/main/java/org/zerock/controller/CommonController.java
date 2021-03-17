package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {

	@GetMapping("/accessError")
	public void accessDenied(Authentication auth,Model model) {
		log.info("접근 제한 : "+auth);
		model.addAttribute("msg","접근 제한됨");
	}
	@GetMapping("/customLogin")
	public void loginInput(String error,String logout,Model model) {
		log.info("에러 : " +error);
		log.info("로그아웃 :" + logout);
		
		if(error!=null) {
			model.addAttribute("error","로그인 실패");
		}
		if(logout != null) {
			model.addAttribute("logout","로그아웃");
		}
	}
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("로그아웃");
	}
}
