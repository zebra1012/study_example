<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">

<head>


<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>SB Admin 2 - Tables</title>
</head>

<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<%@include file="../includes/header.jsp"%>
		<script type="text/javascript">
			$(document)
					.ready(
							function() {
								var result = '<c:out value="${result}"/>';
								checkModal(result);
								history.replaceState({}, null, null);
								function checkModal(result) {
									if (result === '' || history.state) {
										return;
									}
									if (parseInt(result) > 0) {
										$(".modal-body").html(
												"게시글 " + parseInt(result)
														+ "번이 등록되었습니다.");
									}
									$('#myModal').modal('show');
								}
								$("#regBtn").on("click", function() {
									self.location = "/board/register";
								});

								//페이지이동
								var actionForm = $("#actionForm");
								$(".page-link_a a").on(
										"click",
										function(e) {
											e.preventDefault();
											console.log('click');
											actionForm.find(
													"input[name='pageNum']")
													.val($(this).attr("href"));
											actionForm.submit();
										});
								//조회
								$(".move")
										.on(
												"click",
												function(e) {
													e.preventDefault();
													actionForm
															.append("<input type='hidden' name='bno' value='"
																	+ $(this)
																			.attr(
																					"href")
																	+ "'>");
													actionForm.attr("action",
															"/board/get");
													actionForm.submit();
												});

								var searchForm = $("#searchForm");
								$("#searchForm button").on(
										"click",
										function(e) {
											if (!searchForm.find(
													"option:selected").val()) {
												alert("검색종류를 선택하세요");
												return false;
											}
									if(!searchForm.find("input[name='keyword']").val()){
										alert("키워드를 입력하세요");
										return false;
									}
									searchFrom.find("input[name='pageNum']").val("1");
									e.preventDefault();
									searchForm.submit();
										});
							});
		</script>

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<nav
					class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

					<!-- Sidebar Toggle (Topbar) -->
					<form class="form-inline">
						<button id="sidebarToggleTop"
							class="btn btn-link d-md-none rounded-circle mr-3">
							<i class="fa fa-bars"></i>
						</button>
					</form>

					<!-- Topbar Search -->
					<form
						class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
						<div class="input-group">
							<input type="text" class="form-control bg-light border-0 small"
								placeholder="Search for..." aria-label="Search"
								aria-describedby="basic-addon2">
							<div class="input-group-append">
								<button class="btn btn-primary" type="button">
									<i class="fas fa-search fa-sm"></i>
								</button>
							</div>
						</div>
					</form>

					<!-- Topbar Navbar -->
					<ul class="navbar-nav ml-auto">

						<!-- Nav Item - Search Dropdown (Visible Only XS) -->
						<li class="nav-item dropdown no-arrow d-sm-none"><a
							class="nav-link dropdown-toggle" href="#" id="searchDropdown"
							role="button" data-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false"> <i class="fas fa-search fa-fw"></i>
						</a> <!-- Dropdown - Messages -->
							<div
								class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in"
								aria-labelledby="searchDropdown">
								<form class="form-inline mr-auto w-100 navbar-search">
									<div class="input-group">
										<input type="text"
											class="form-control bg-light border-0 small"
											placeholder="Search for..." aria-label="Search"
											aria-describedby="basic-addon2">
										<div class="input-group-append">
											<button class="btn btn-primary" type="button">
												<i class="fas fa-search fa-sm"></i>
											</button>
										</div>
									</div>
								</form>
							</div></li>
					</ul>
				</nav>
 
				<!-- End of Topbar -->
				

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- Page Heading -->
					<h1 class="h3 mb-2 text-gray-800">Tables</h1>
					<p class="mb-4">
						DataTables is a third party plugin that is used to generate the
						demo table below. For more information about DataTables, please
						visit the <a target="_blank" href="https://datatables.net">official
							DataTables documentation</a>.
					</p>

					<!-- DataTales Example -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">DataTables
								Example</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<div class="panel-heading">
									<button id="regBtn" type="
										button"
										class="btn btn-xs pull-right">Register New Board</button>
								</div>
								<table class="table table-bordered" id="dataTable" width="100%"
									cellspacing="0">
									<thead>
										<tr>
											<th>#번호</th>
											<th>제목</th>
											<th>작성자</th>
											<th>작성일</th>
											<th>수정자</th>
										</tr>
									</thead>

									<c:forEach items="${list }" var="board">
										<tr>
											<td><c:out value="${board.bno }"></c:out></td>
											<td><a class="move"
												href='<c:out value="${board.bno }"/>'><c:out
														value="${board.title }"></c:out>
														<b>[<c:out value="${board.replyCnt}"/>]</b></a></td>
											<td><c:out value="${board.writer }"></c:out></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd"
													value="${board.regdate }" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd"
													value="${board.updateDate }" />
										</tr>
									</c:forEach>
								</table>
								<div class="row">
									<div class="col-lg-12">
										<form id="searchForm" action="/board/list" method="get">
											<select name='type'>
												<option value=""
													<c:out value="${pageMaker.cri.type==null?'selected':'' }"/>>--</option>
												<option value="T"
													<c:out value="${pageMaker.cri.type=='T'?'selected':'' }"/>>제목
												</option>
												<option value="C"
													<c:out value="${pageMaker.cri.type=='C'?'selected':'' }"/>>내용
												</option>
												<option value="W"
													<c:out value="${pageMaker.cri.type=='W'?'selected':'' }"/>>작성자
												</option>
												<option value="TC"
													<c:out value="${pageMaker.cri.type=='TC'?'selected':'' }"/>>제목
													or 내용</option>
												<option value="TW"
													<c:out value="${pageMaker.cri.type=='TW'?'selected':'' }"/>>제목
													or 작성자</option>
												<option value="TWC"
													<c:out value="${pageMaker.cri.type=='TWC'?'selected':''}"/>>제목
													or 내용or 작성자</option>
											</select> <input type="text" name="keyword" /> <input type="hidden"
												name="pageNum" value="${pageMaker.cri.pageNum }"> <input
												type="hidden" name="amount" value="${pageMaker.cri.amount }">
											<button class="btn btn-default">Search</button>
										</form>
									</div>
								</div>

								<div class="col-sm-12 col-md-7">
									<ul class="pagination">
										<c:if test="${pageMaker.prev }">
											<li class="page-link"><a
												href="${pageMaker.startPage-1 }">Previous</a></li>
										</c:if>
										<c:forEach var="num" begin="${pageMaker.startPage }"
											end="${pageMaker.endPage }">
											<li class="page-link_a"><a href="${num}">&nbsp;${num }&nbsp;</a></li>
										</c:forEach>
										<c:if test="${pageMaker.next }">
											<li class="page-link"><a href="${pageMaker.endPage+1 }">Next</a></li>
										</c:if>
									</ul>
								</div>

								<form id="actionForm" action="/board/list" method="get">
									<!--  페이지 이동시 파라미터 전달 -->
									<input type="hidden" name="pageNum"
										value="${pageMaker.cri.pageNum}"> <input type="hidden"
										name="amount" value="${pageMaker.cri.amount }">
										<input type="hidden" name="type" value="<c:out value='${pageMaker.cri.type }'/>">
										<input type="hidden" name="keyword" value="<c:out value='${pageMaker.cri.keyword }'/>">
								</form>

								<!-- Modal 추가 -->
								<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
									aria-labelledby="myModalLabel" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal"
													aria-hidden="true"></button>
												<h4 class="modal-title" id="myModalLabel">Modal title</h4>
											</div>
											<div class="modal-body">처리가 완료되었습니다.</div>
											<div class="modal-footer">
												<button type="button" class="btn btn-default"
													data-dismiss="modal">Close</button>
												<button type="button" class="btn btn-primary">Save
													changes</button>
											</div>
										</div>
									</div>
								</div>
								<!-- Modal -->
							</div>
						</div>
					</div>

				</div>
				<!-- /.container-fluid -->

			</div>
			<!-- End of Main Content -->

			<%@include file="../includes/footer.jsp"%>

		</div>
		<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>

	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">Select "Logout" below if you are ready
					to end your current session.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Cancel</button>
					<a class="btn btn-primary" href="login.html">Logout</a>
				</div>
			</div>
		</div>
	</div>
</body>

</html>