package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.time.chrono.IsoEra;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;


import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	private String getFolder() { //오늘 날짜로 문자열 생성
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	private boolean checkImageType(File file) { //업로드 파일 확인
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("업로드 양식");
	}
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("Ajax를 이용한 업로드");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder="D:\\upload";	
		for (MultipartFile multipartFile : uploadFile) {
			log.info("========================");
			log.info("업로드한 파일 이름 : "+multipartFile.getOriginalFilename());
			log.info("업로드한 파일 크기 : "+ multipartFile.getSize());
			
			
			
			File saveFile = new File(uploadFolder,multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	@PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList();
		//log.info("Ajax 포스트 업로드..");
		String uploadFolder="D:\\upload";
		String uploadFolderPath = getFolder();
		
		File uploadPath = new File(uploadFolder,getFolder());
		log.info("업로드 경로 : " + uploadPath);
		
		if(uploadPath.exists()==false) {
			uploadPath.mkdir();
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			//log.info("===================");
			//log.info("업로드한 파일 이름 : "+multipartFile.getOriginalFilename());
			//log.info("업로드한 파일 크기 : " +multipartFile.getSize());
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
			log.info("실제 파일 이름 : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			uploadFileName=uuid.toString() + "_"+ uploadFileName;
			
			try {
				File saveFile =new File(uploadPath,uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					thumbnail.close();
				}
				list.add(attachDTO);
			}catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity(list,HttpStatus.OK);
	}
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		File file = new File("d:\\upload\\"+fileName);
		ResponseEntity<byte[]> result  = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type",Files.probeContentType(file.toPath()));
			result = new ResponseEntity(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		}catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	@GetMapping(value="/download",produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("user-Agent") String userAgent,String fileName){
		Resource resource=new FileSystemResource("D:\\upload\\"+fileName);
		
		if(resource.exists() ==false) {
			return new ResponseEntity(HttpStatus.NOT_FOUND);
		}
		String resourceName = resource.getFilename();
		
		//UUID 삭제
		String ResourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		log.info(ResourceOriginalName);
		
		HttpHeaders header = new HttpHeaders();
		try {
			String downloadName=null;
			if(userAgent.contains("Trident")) {
				log.info("인터넷 익스플로러!");
				downloadName=URLEncoder.encode(resourceName,"UTF-8").replaceAll("\\+", " ");
			}else if (userAgent.contains("Edge")) {
				log.info("엣지!");
				downloadName=URLEncoder.encode(resourceName,"UTF-8");
				log.info("엣지 이름 : " + downloadName);
			}else {
				log.info("그 외");
				downloadName = new String(resourceName.getBytes("UTF-8"),"ISO-8859-1");
			}
			
			header.add("Content-Disposition","attachment;filename=" + new String(downloadName.getBytes("UTF-8"),"ISO-8859-1"));
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource,header,HttpStatus.OK);
	}
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName,String type){
		log.info("삭제 파일 이름: "+fileName);
		File file;
		try {
			file = new File("D:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			file.delete();
			if(type.equals("image")) { //이미지면 섬네일도 삭제
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("오리지널 이미지파일: " + largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	
}
