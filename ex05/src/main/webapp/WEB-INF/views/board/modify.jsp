<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
	.bigPictureWrapper {
		position : absolute;
		display : none;
		justify-content : center;
		align-items:center;
		top:0%;
		width:100%;
		height:100%;
		background-color:gray;
		z-index:100;
		background:rgba(255,255,255,0,5);
	}
	.bigPicture{
		position : relative;
		display:flex;
		justify-content: center;
		align-items:center;
	}
	.bigPicture img {
		width : 600px;
	}
	
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="wrapper">
		<%@include file="../includes/header.jsp"%>
		<script type="text/javascript">
			$(document).ready(function() {
				var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
				var maxSize = 5242880;
				var formObj = $("form");
				
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
						data : formData,
						type : 'POST',
						dataType : 'json',
						success : function(result) {
							console.log(result);
							showUploadResult(result)
						}
					});
				});
				
				
				$(".uploadResult").on("click","button",function(e){
					console.log("파일 삭제");
					if(confirm("삭제하시겠습니까?")){
						var targetLi = $(this).closest("li");
						targetLi.remove();
					}
				});
				
				(function(){
					var bno = '<c:out value="${board.bno}"/>';
					$.getJSON("/board/getAttachList",{bno : bno},function(arr){
						console.log(arr);
						var str = "";
						$(arr).each(function(i,attach){
							//image type
						if(attach.fileType){
							var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
							str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
							str+="<span> "+attach.fileName+"</span>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
							str += "class='btn btn-warning btn-circle'>X</button><br>";
							str += "<img src='/display?fileName="+fileCallPath+"'></div></li>";
						}else {
							str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
							str +="<span> " + attach.fileName+"</span>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
							str += "class='btn btn-warning btn-circle'>X</button><br>";
							str += "<img src='/resources/img/sisters-6053044_1920.jpg'></div></li>";
						}
						});
						$(".uploadResult ul").html(str);
					});
				})();
				
				
				$('button').on("click", function(e) {
					e.preventDefault(); //기본 submit기능 prevent

					var operation = $(this).data("oper");
					//console.log(operation);

					if (operation === 'remove') {
						formObj.attr("action", "/board/remove");
						
					} else if (operation === 'list') {
						formObj.attr("action","/board/list").attr("method","get");
						var amountTag=$("input[name='amount']").clone();
						var pageNumTag=$("input[name='pageNum']").clone();
						var keywordTag=$("input[name='keyword']").clone();
						var typeTag= $("input[name='type']").clone();
						
						formObj.empty();
						formObj.append(pageNumTag);
						formObj.append(amountTag);
						formObj.append(keywordTag);
						formObj.append(typeTag);
					} else if (operation == 'modify'){
						console.log("submit clicked");
						var str="";
						$(".uploadResult ul li").each(function(i,obj){
							var jobj=$(obj);
							console.dir(jobj);
							str +="<input type='hidden' name='attachList"+i+"].fileName' value='"+jobj.data("filename")+"'>";
							str +="<input type='hidden' name='attachList"+i+"].uuid' value='"+jobj.data("uuid")+"'>";
							str +="<input type='hidden' name='attachList"+i+"].uploadPath' value='"+jobj.data("path")+"'>";
							str +="<input type='hidden' name='attachList"+i+"].fileType' value='"+jobj.data("type")+"'>";
						});
						formObj.append(str).submit();
					}
					formObj.submit();
				});

			});
		</script>
		<div id="content-wrapper" class="d-flex flex-column">
			<div class="content">
				<div class="content-fluid" align="center">
					<h1 class="h3 mb-2 text-gray-800">게시글</h1>
					<div class="card shadow mb-4">
						<div class="m-0 font-weight-bold text-primary">게시글</div>
						<form role="form" action="/board/modify" method="post">
							<div class="card-body">
								<div class="form-group">
									<label>bno</label><input class="form-control" name="bno"
										value='<c:out value="${board.bno }"/>' readonly="readonly">
								</div>
								<div class="form-group">
									<label>Title</label><input class="form-control" name="title"
										value='<c:out value="${board.title }"/>'>
								</div>
								<div class="form-group">
									<label>Text area</label>
									<textarea rows="3" name="content" class="form-control"><c:out
											value="${board.content}" />
									 </textarea>
								</div>
								<div class="form-group">
									<label>Writer</</label> <input class="form-control"
										name="writer" value='<c:out value="${board.writer }"/>'
										readonly="readonly">
								</div>
								
								<div class='bigPictureWrapper'>
									<div class='bigPicture'>
									</div>
								</div>
								<div class ="row">
									<div class="col-lg-12">
										<div class="card shadow mb-4">
											<div class="m-0 font-weight-bold text-primary">첨부 파일</div>
											<div class="panel-body">
												<div class="form-group uploadDiv">
													<input file="file" name = 'uploadFile' multiple="multiple"> 
												</div>
												<div class="uploadResult">
													<ul>
											
													</ul>
												</div>
											</div>
										</div>
									</div>
								</div>	
								
								<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum }'/>">
								<input type="hidden" name="amount" value="<c:out value='${cri.amount }'/>">
								<input type="hidden" name="type" value="<c:out value='${cri.type }'/>">
								<input type="hidden" name="keyword" value='<c:out value="${cri.type }"/>'>
								<button type="submit" data-oper="submit" class="btn btn-default">Modify</button>
								<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
								<button type="submit" data-oper="list" class="btn btn-info">List</button>
							</div>
						</form>
					</div>


				</div>
			</div>
			<%@include file="../includes/footer.jsp"%>
		</div>
	</div>
</body>
</html>