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
		<script type="text/javascript" src="/resources/js/reply.js"></script>
		<script>
			//Ajax Spring Security Header
			
			$(document).ready(function() {
				var bnoValue = '<c:out value="${board.bno}"/>';
				var replyUL = $(".chat");
				var pageNum=1;
				var replyPageFooter=$(".panel-footer");
				var csrfHeaderName="${_csrf.headerName}";
				var csrfTokenValue="${_csrf.token}";
								
				$(document).ajaxSend(function(e,xhr,options){
					xhr.setRequestHeader(csrfHeaderName,csrfTokenValue)
				});
				
				(function(){ //첨부파일 불러오기
					var bno = '<c:out value="${board.bno}"/>';
					$.getJSON("/board/getAttachList",{bno: bno}, function(arr){
						//console.log(arr);
						var str = "";
						$(arr).each(function(i,attach){
							if(attach.fileType) {//이미지 타입
								var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
								str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
								str += "<img src='/display?fileName="+fileCallPath+"'></div></li>";
							}
							else { //파일
								str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
								str +="<span> " + attach.fileName+"</span><br/>";
								str += "<img src='/resources/img/sisters-6053044_1920.jpg'></div></li>";
							}
						});
						$(".uploadResult ul").html(str);
					});
				})();
								
				function showReplyPage(replyCnt){ //댓글 페이지갯수
					var endNum=Math.ceil(pageNum/10.0) * 10;
					var startNum = endNum-9;
									
					var prev=startNum!=1;
					var next=false;
					if(endNum*10 >= replyCnt) {
						endNum=Math.ceil(replyCnt/10.0);
					}
					if(endNum*10 < replyCnt){
						next=true;
					}
					var str= "<ul class='pagination pull-right'>";
									
					if(prev) {
						str +="<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>'";
					}
					for (var i = startNum; i<=endNum;i++) {
						var active = pageNum == i?"active":"";
						str+="<li class='page-item " + active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
					}
					if(next){
						str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
						}
					str +="</ul></div>";
									
					//console.log(str);
					replyPageFooter.html(str);
				} //showReplyPage End

				showList(1);
				function showList(page) {
					console.log("show list " + page); //댓글출력
					replyService.getList({bno : bnoValue,page : page || 1},function(replyCnt, list) {
						//console.log("replyCnt : " + replyCnt);
						//console.log("list : " +list);
						//console.log(list);
											
						if(page==-1) {
							pageNum= Math.ceil(replyCnt/10.0);
							showList(pageNum);
							return;
						}
						var str = "";
						if (list == null || list.length == 0) {
							return;
						}
						for (var i = 0, len = list.length || 0; i < len; i++) {
							str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
							str += "  <div> <div class='header'><strong class='primary-font'>"
								+ list[i].replyer
								+ "</strong>&nbsp";
							str += "<small class='pull right text-muted'>"
								+ replyService.displayTime(list[i].replyDate)
								+ "</small></div>";
							str += " <p>" + list[i].reply
								+ "</p></div></li>";
						}
						replyUL.html(str);
						showReplyPage(replyCnt);
					});
				}; //showList end

				var modal = $(".modal");
				var modalInputReply = modal.find("input[name='reply']");
				var modalInputReplyer = modal.find("input[name='replyer']");
				var modalInputReplyDate = modal.find("input[name='replyDate']");
				var modalModBtn = $("#modalModBtn");
				var modalRemoveBtn = $("#modalRemoveBtn");
				var modalRegisterBtn = $("#modalRegisterBtn");
				var replyer=null;
				<sec:authorize access="isAuthenticated()">
					replyer='<sec:authentication property="principal.username"/>';
				</sec:authorize>
				
				
				// 댓글 클릭 이벤트 처리 
				$(".chat").on("click","li",function(e) {
					var rno = $(this).data("rno");
					replyService.get(rno,function(reply) {
						modalInputReply.val(reply.reply);
						modalInputReplyer.val(reply.replyer);
						modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
						modal.data("rno",reply.rno);
						modal.find("button[id != 'modalCloseBtn']").hide();
						modalModBtn.show();
						modalRemoveBtn.show();
						$(".modal").modal("show");
					})
					//console.log(rno);
				});
								
				//댓글 수정 이벤트처리
				modalModBtn.on("click",function(e){
					var originalReplyer=modalInputReplyer.val();
					var reply = {rno : modal.data("rno"),reply : modalInputReply.val(),replyer:originalReplyer};
					
					if(!replyer){
						alert("로그인후 수정이 가능합니다.");
						modal.modal("hide");
						return;
					}
					
					if(replyer != originalReplyer) {
						alert("권한이 없습니다.")
						modal.modal("hide");
						return;
					}
					
					replyService.update(reply,function(result){
						alert("수정되었습니다.");
						modal.modal("hide");
						showList(pageNum);
					});
				});
								
				//댓글 삭제 이벤트처리
				modalRemoveBtn.on("click",function(e){
					var rno = modal.data("rno");
					if(!replyer){
						alert("로그인해주세요.");
						modal.modal("hide");
						return;
					}
					var originalReplyer= modalInputReplyer.val();
					if(replyer != originalReplyer){
						alert("권한이 없습니다.");
						modal.modal("hide");
						return;
					}
					replyService.remove(rno,originalReplyer,function(result){
						alert("삭제되었습니다.");
						modal.modal("hide");
						showList(pageNum);
						location.reload();
					});
				});
								
				//댓글 페이지 클릭
				replyPageFooter.on("click","li a",function(e){ 
					e.preventDefault();
					//console.log("page click");
					var targetPageNum=$(this).attr("href");
					console.log("targetPageNum : " + targetPageNum);
					pageNum=targetPageNum;
					showList(pageNum);
				});
				//댓글 추가
				$("#addReplyBtn").on("click",function(e) {
					modal.find("input").val("");
					modal.find("input[name='replyer']").val(replyer)
					modalInputReplyDate.closest("div").hide();
					modal.find("button[id!='modalCloseBtn']").hide();
					modalRegisterBtn.show();
					$(".modal").modal("show");
				});
				modalRegisterBtn.on("click", function(e) {
					var reply = {
						reply : modalInputReply.val(),
						replyer : modalInputReplyer.val(),
						bno : bnoValue
					};
					replyService.add(reply, function(result) {
						alert(result);
						modal.find("input").val("");
						modal.modal("hide");
						showList(pageNum);
					});
				});
				//이미지 클릭 이벤트
				$(".uploadResult").on("click","li",function(e){
					console.log("이미지 보기");
					var liObj = $(this);
					
					var path=encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
					
					if(liObj.data("type")){
						showImage(path.replace(new RegExp(/\\/g),"/")); //모든 '\'을 '/'으로
					}else {
						//다운로드
						self.location="/download?fileName="+path;
					}
				});
				function showImage(fileCallPath){
					//alert(fileCallPath);
					$(".bigPictureWrapper").css("display","flex").show();
					$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width:'100%',height:'100%'},1000);
				}
				//열린 이미지 닫기
				$(".bigPictureWrapper").on("click",function(e){
					$(".bigPicture").animate({width:'0%',height:'0%'},1000);
					setTimeout(function(){
						$('.bigPictureWrapper').hide();
					},1000);
				});
				
			});
			//console.log("==========");
			//console.log("JS TEST");

			/*replyService.get(41,function(data){
				console.log(data);
			}); */

			/*replyService.update({
				rno : 41,
				bno : bnoValue,
				reply : "Modified Reply..."
			}, function(result) {
				alert("수정 완료");
			});*/

			/*replyService.remove(23,function(count){
				console.log(count);
				if(count ==="success") {
					alert("REMOVED");
				}
			},function(err) {
				alert("ERROR!");
			}); */

			/*replyService.getList({bno:bnoValue,page:1},function(list){
				for(var i = 0 , len=list.length||0; i <len ; i++) {
					console.log(list[i]);
				}
			}); */

			/*replyService.add({
				reply : "JS Test",
				replyer : "tester",
				bno : bnoValue
			}, function(result) {
				alert("RESULT : " + result);
			});*/
		</script>
		<script type="text/javascript">
			//파라미터 전달(수정 및 목록)
			$(document).ready(function() {
				var operForm = $("#operForm");
				$("button[data-oper='modify']").on("click", function(e) {
					operForm.attr("action", "/board/modify").submit();
				});
				$("button[data-oper='list']").on("click", function(e) {
					operForm.find("#bno").remove();
					operForm.attr("action", "/board/list");
					operForm.submit();
				});
			});
		</script>
		<div id="content-wrapper" class="d-flex flex-column">
			<div class="content">
				<div class="content-fluid" align="center">
					<h1 class="h3 mb-2 text-gray-800">게시글</h1>
					<div class="card shadow mb-4">
						<div class="m-0 font-weight-bold text-primary">게시글</div>
						<div class="card-body">
							<div class="form-group">
								<label>bno</label><input class="form-control" name="bno"
									value='<c:out value="${board.bno }"/>' readonly="readonly">
							</div>
							<div class="form-group">
								<label>Title</label><input class="form-control" name="title"
									value='<c:out value="${board.title }"/>' readonly="readonly">
							</div>
							<div class="form-group">
								<label>Text area</label>
								<textarea rows="3" name="content" class="form-control"
									readonly="readonly"><c:out value="${board.content}" />
								</textarea>
							</div>
							<div class="form-group">
								<label>Writer</</label> <input class="form-control"
									name="writer" value='<c:out value="${board.writer }"/>'
									readonly="readonly">
							</div>
							<sec:authentication property="principal" var="pinfo"/>
								<sec:authorize access="isAuthenticated()">
								 	<c:if test="${pinfo.username eq board.writer }">
										<button data-oper="modify" class="btn btn-default" />Modify </button>
									</c:if>
								</sec:authorize>
							<button data-oper="list" class="btn btn-info">List</button>
							<form id='operForm' action="/board/modify" method="get">
								<input type="hidden" id="bno" name="bno"
									value='<c:out value="${board.bno }"/>'> <input
									type="hidden" name="pageNum"
									value='<c:out value="${cri.pageNum }"/>'> <input
									type="hidden" name="amount"
									value='<c:out value="${cri.amount }"/>'> <input
									type="hidden" name="keyword"
									value="<c:out value='${cri.keyword }'/>"> <input
									type="hidden" name="type" value="<c:out value='${cri.type }'/>">
							</form>

						</div>
					</div>
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
										<div class="uploadResult">
											<ul>
											
											</ul>
										</div>
									</div>
							</div>
						</div>
				</div>
				
				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-default">

							<!--  <div class="panel-heading">
								<i class="fa fa-comments fa-fw"></i> Reply
							</div>
							<-->
							<div class="panel-heading">
								<i class="fa fa-comments fa-fw"></i> Reply
								<sec:authorize access="isAuthenticated()">
								<button id='addReplyBtn'
									class='btn btn-primary btn-xs pull-right'>New Reply</button>
								</sec:authorize>
							</div>
							<div class="card shadow mb-4">
								<ul class="chat">

								</ul>
							</div>
							<div class="panel-footer">
							
							</div>
						</div>
					</div>
				</div>
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
					aria-labelledby="myModalLabe" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabe">REPLY MODAL</h4>
							</div>
							<div class="modal-body">
								<div class="form-group">
									<label>Reply</label> <input class="form-control" name='reply'
										value="New Reply!!!!">
								</div>
								<div class="form-group">
									<label>Replyer</label> <input class="form-control"
										name="replyer" value="replyer" readonly="readonly">
								</div>
								<div class="form-group">
									<label>Reply Date</label> <input class="form-control"
										name='replyDate' value=''>
								</div>
							</div>
							<div class="modal-footer">
								<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
								<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
								<Button id="modalRegisterBtn" type="button"
									class="btn btn-primary">Register</Button>
								<Button id="modalClassBtn" type="button" class="btn btn-default"
									data-dismiss="modal">Close</Button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%@include file="../includes/footer.jsp"%>
		</div>
	</div>
</body>
</html>