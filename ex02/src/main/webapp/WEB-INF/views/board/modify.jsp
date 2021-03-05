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
				var formObj = $("form");

				$('button').on("click", function(e) {
					e.preventDefault(); //기본 submit기능 prevent

					var operation = $(this).data("oper");
					console.log(operation);

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