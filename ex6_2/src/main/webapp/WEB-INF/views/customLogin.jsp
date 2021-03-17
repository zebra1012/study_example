<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>SB Admin 2 - Login</title>
 <!-- Custom fonts for this template-->
    <link href="/resources/sb_admin_2/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/resources/sb_admin_2/css/sb-admin-2.min.css" rel="stylesheet">
</head>
<body class="bg-gradient-primary">
	<div class="container">
		 <!-- Outer Row -->
        <div class="row justify-content-center">
        	<div class="col-xl-10 col-lg-12 col-md-9">
        		<div class="card o-hidden border-0 shadow-lg my-5">
        			<div class="card-body p-0">
        				<div class="row">
        					<div class="col-lg-6 d-none d-lg-block bg-login-image"></div>
        					 <div class="col-lg-6">
        					 	<div class="p-5">
        					 	<div class="text-center">
									<h1 clas="h4 text-gray-900 mb-4">로그인</h1>
								</div>
									<h2><c:out value="${error}"/></h2>
									<h2><c:out value="${logout }"/></h2>
									<form role="form" method='post' action="/login">
									<fieldset>
										<div class="form-group">
											<input class="form-control" placeholder="아이디" name="username" type="text" autofocus>
										</div>
										<div class="form-group"> 
											<input class="form-control" placeholder="비밀번호" name="password" type="password" value="">
										</div>
										<div class="checkbox">
											<label><input name="remember-me" type="checkbox">자동로그인</label>
										</div>
										<a href="index.html" class="btn btn-primary btn-user btn-block">로그인</a>
									</fieldset>
									
									<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- JQuery -->
	<!-- Bootstrap core JavaScript-->
    <script src="/resources/sb_admin_2/vendor/jquery/jquery.min.js"></script>
    <script src="/resources/sb_admin_2/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="/resources/sb_admin_2/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="/resources/sb_admin_2/js/sb-admin-2.min.js"></script>
    
    <script>
    $(".btn-user").on("click",function(e){
    	e.preventDefault();
    	$("form").submit();
    });
    </script>
	<c:if test="${param.logout!=null }">
		<script>
		$(document).ready(function(){
			alert("로그아웃성공");
		});
		</script>
	</c:if>

</body>
</html>