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
		<div id="content-wrapper" class="d-flex flex-column">
			<div class="content">
				<div class="content-fluid" align="center">
					<h1 class="h3 mb-2 text-gray-800">게시판 등록</h1>
					<div class="card shadow mb-4">
						<div class="m-0 font-weight-bold text-primary">게시판 등록</div>
						<div class="card-body">
							<form action="/board/register" method="post">
								<div class="form-group">
									<label>Title</label> <input class="form-control" name="title">
								</div>
								<div class="form-group">
									<label>Text Area</label>
									<textarea class="form-control" rows="3" name="content"></textarea>
								</div>
								<div class="form-group">
									<l abel>Writer</label> <input class="form-control" name="writer">
								</div>
								<button type="submit" class="btn btn-default">Submit
									Button</button>
								<button type="reset" class="btn btn-default">Reset
									Button</button>
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