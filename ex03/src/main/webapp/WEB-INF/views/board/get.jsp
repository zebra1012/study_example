<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="wrapper">
		<%@include file="../includes/header.jsp"%>
		<script type="text/javascript" src="/resources/js/reply.js"></script>
		<script>
			$(document)
					.ready(
							function() {
								var bnoValue = '<c:out value="${board.bno}"/>';
								var replyUL = $(".chat");
								var pageNum=1;
								var replyPageFooter=$(".panel-footer");	
								
								function showReplyPage(replyCnt){
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
									
									console.log(str);
									replyPageFooter.html(str);
								}

								showList(1);
								function showList(page) {
									console.log("show list " + page);
									replyService.getList({bno : bnoValue,page : page || 1},function(replyCnt, list) {
										console.log("replyCnt : " + replyCnt);
										console.log("list : " +list);
										console.log(list);
										
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
								};

								var modal = $(".modal");
								var modalInputReply = modal
										.find("input[name='reply']");
								var modalInputReplyer = modal
										.find("input[name='replyer']");
								var modalInputReplyDate = modal
										.find("input[name='replyDate']");

								var modalModBtn = $("#modalModBtn");
								var modalRemoveBtn = $("#modalRemoveBtn");
								var modalRegisterBtn = $("#modalRegisterBtn");
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
									var reply = {rno : modal.data("rno"),reply : modalInputReply.val()};
									replyService.update(reply,function(result){
										alert("수정되었습니다.");
										modal.modal("hide");
										showList(pageNum);
									});
								});
								
								//댓글 삭제 이벤트처리
								modalRemoveBtn.on("click",function(e){
									var rno = modal.data("rno");
									replyService.remove(rno,function(result){
										alert("삭제되었습니다.");
										modal.modal("hide");
										showList(pageNum);
									});
								});
								
								replyPageFooter.on("click","li a",function(e){
									e.preventDefault();
								console.log("page click");
								var targetPageNum=$(this).attr("href");
								console.log("targetPageNum : " + targetPageNum);
								pageNum=targetPageNum;
								showList(pageNum);
								});
							
								$("#addReplyBtn")
										.on(
												"click",
												function(e) {
													modal.find("input").val("");
													modalInputReplyDate
															.closest("div")
															.hide();
													modal
															.find(
																	"button[id!='modalCloseBtn']")
															.hide();

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
							});
			console.log("==========");
			console.log("JS TEST");

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

							<button data-oper="modify" class="btn btn-default" />
							Modify
							</button>
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
				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-default">

							<!--  <div class="panel-heading">
								<i class="fa fa-comments fa-fw"></i> Reply
							</div>
							<-->
							<div class="panel-heading">
								<i class="fa fa-comments fa-fw"></i> Reply
								<button id='addReplyBtn'
									class='btn btn-primary btn-xs pull-right'>New Reply</button>
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
										name="replyer" value="replyer">
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