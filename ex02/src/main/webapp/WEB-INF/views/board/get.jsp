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
		<script type="text/javascript">
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
									value='<c:out value="${board.bno }"/>'>
								<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }"/>'>
								<input type="hidden" name="amount" value='<c:out value="${cri.amount }"/>'>
								<input type="hidden" name="keyword" value="<c:out value='${cri.keyword }'/>">
								<input type="hidden" name="type" value="<c:out value='${cri.type }'/>">
							</form>

						</div>
					</div>


				</div>
			</div>
			<%@include file="../includes/footer.jsp"%>
		</div>
	</div>
</body>
</html>