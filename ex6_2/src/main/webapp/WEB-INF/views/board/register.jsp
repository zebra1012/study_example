<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	.uploadResult{
		width:100%;
		background-color:gray;
	}
	.uploadResult ul{
		display:flex;
		flex-flow:row;
		justify-content : center;
		align-items: center;
	}
	.uploadResult ul li {
	 list-style:none;
	 padding:10px;
	} 
	.uploadResult ul li img{
		width:200px;
	}
	.uploadResult ul li span{
		color : white;
	}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="wrapper">
		<%@include file="../includes/header.jsp"%>
		<div id="content-wrapper" class="d-flex flex-column">
			<div class="content">
				<div class="content-fluid" align="center">
					<h1 class="h3 mb-2 text-gray-800">게시판 등록</h1>
					<div class="card shadow mb-4"> <!-- 노출래퍼 -->
						<div class="m-0 font-weight-bold text-primary">게시판 등록</div>
						<div class="card-body">
							<form role="form" action="/board/register" method="POST">
							<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
								<div class="form-group"> <!-- 게시글 정보 입력 -->
									<label>Title</label> <input class="form-control" name="title">
								</div>
								<div class="form-group">
									<label>Text Area</label>
									<textarea class="form-control" rows="3" name="content"></textarea>
								</div>
								<div class="form-group">
									<label>Writer</label> <input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
								</div>
								<button type="submit" class="btn btn-default">Submit
									</button>
								<button type="reset" class="btn btn-default">Reset
									</button>
							</form>
						</div> <!-- 게시글 정보 입력  끝-->
					</div>  <!-- 노출래퍼 끝 -->
					<div class ="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="m-0 font-weight-bold text-primary">파일 첨부</div>
									<div class="panel-body">
										<div class="form-group uploadDiv">
											<input type="file" name="uploadFile" multiple>
										</div>
										<div class="uploadResult">
											<ul>
											
											</ul>
										</div>
									</div>
							</div>
						</div>
					</div>
					
				</div> 
			</div>
			<%@include file="../includes/footer.jsp"%>
		</div>
	</div>
	
	
	<!-- 스크립트 -->
	<script>
	
		$(document).ready(function(e) {
			var formObj = $("form[role='form']");
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880;
			
			$(".uploadResult").on("click","button",function(e){ //첨부파일 삭제
				var targetFile=$(this).data("file");
				var type=$(this).data("type");
				
				var targetLi = $(this).closest("li");
				
				$.ajax({
					url: '/deleteFile',
					data : {fileName:targetFile,type:type},
					beforeSend: function(xhr){
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					},
					dataType:'text',
					type:'post',
					success:function(result){
						alert("삭제완료");
						targetLi.remove();
					}
				});
			});
			
			function showUploadResult(uploadResultArr){
				if(!uploadResultArr|| uploadResultArr.length==0) {return ;}
				var uploadUL = $(".uploadResult ul");
				var str = "";
				$(uploadResultArr).each(function(i,obj){
					if(obj.image){
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid + "_"+obj.fileName);
						
						str += "<li data-path='"+obj.uploadPath+"'";
						str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'";
						str += " ><div>";
						str += "<span> "+obj.fileName+"</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\' "
						str += "data-type='image' class='btn btn-warning btn-cirle'>X</button><br>";
						str += "<img src='/display?fileName="+fileCallPath+"'>";
						str +="</div>";
						str += "</li>";
					}
					else { 
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid +"_"+obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
						
						str += "<li data-path='"+obj.uploadPath+"'";
						str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'";
						str += " ><div>";
						str += "<span> "+obj.fileName+"</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\' "
						str += "data-type='file' class='btn btn-warning btn-cirle'>X</button><br>";
						str += "<img src='/resources/img/sisters-6053044_1920.jpg'>";
						str +="</div>";
						str += "</li>";
					} 
				});
				uploadUL.append(str);
			};
			
			function checkExtension(fileName, fileSize) { //확장자 검사, 크기 검사 함수
				if (fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				if (regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드 할 수 없습니다.");
					return false;
				}
				return true;
			}
			var csrfHeaderName="${_csrf.headerName}";
			var csrfTokenValue="${_csrf.token}";
			
			$("input[type='file']").change(function(e) { //업로드파일 선택시 호출
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				for (var i = 0; i < files.length; i++) {
					if (!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url : '/uploadAjaxAction',
					processData : false,
					contentType : false,
					beforeSend : function(xhr){
						xhr.setRequestHeader(csrfHeaderName,csrfTokenValue); //스프링 시큐리티 적용 시 POST,PUT,PATCH,DELETE에는 CSRF토큰값을 헤더에 포함시켜야 함 
					},
					data : formData,
					type : 'POST',
					dataType : 'json',
					success : function(result) {
						//console.log(result);
						showUploadResult(result)
					}
				});
			});

			$("button[type='submit']").on("click", function(e) {
				e.preventDefault();
				console.log("submit clicked");
				var str ="";
				$(".uploadResult ul li").each(function(i,obj){
					var jobj = $(obj);
					console.dir(jobj);
					str +="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str +="<input type='hidden' name ='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name ='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				formObj.append(str).submit();
			});
		});
	</script>
</body>
</html>