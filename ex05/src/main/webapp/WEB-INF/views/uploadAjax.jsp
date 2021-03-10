<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.js"
	integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
	crossorigin="anonymous"></script>
	
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
	
	<script>
	function showImage(fileCallPath){ //a태그에서 직접 호출
		//alert(fileCallPath);
	$(".bigPictureWrapper").css("display","flex").show;
	$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%',height:'100%'},1000);
	}
	
	$(document).ready(function(){
		var cloneObj = $(".uploadDiv").clone(); //업로드 단 복사
		var uploadResult = $(".uploadResult ul");
		function showUploadedFile(uploadResultArr) {
			var str = "";
			$(uploadResultArr).each(function(i,obj){
					if(!obj.image){
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
						str +="<li><a href='/download?fileName="+fileCallPath+"'>"+"<img src='/resources/img/sisters-6053044_1920.jpg'>"+obj.fileName+"</a><span data-file=\'"+fileCallPath+"\' data-type='file'> x </span><div><li>";
					}else {
						//str +="<li>" + obj.fileName + "</li>";
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g),"/");
						str +="<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a><span data-file=\'"+fileCallPath+"\' data-type='image'> x </span><li>";
					}
			});
			uploadResult.append(str);
		}
		
		$(".bigPictureWrapper").on("click",function(e){
			$(".bigPicture").animate({width:'0%',height:'0%'},1000); //for Chrome
			setTimteout(()=>{ 
				$(this).hide();
			},1000);
			
			/*
			//for IE
			$(".bigPicture").animate({width:'0%',height:'0%'"},1000);
			setTimeout(function(){
				$('.bigPictureWrapper').hide();
			},1000);
			*/
		});
		
		$(".uploadResult").on("click","span",function(e){ //삭제버튼("X")
			
			var targetFile = $(this).data("file");
			var type=$(this).data("type");
			console.log(targetFile);
			
			$.ajax({
				url:'/deleteFile',
				data : {fileName : targetFile, type:type},
				dataType:'text',
				type:'POST',
					success:function(result){
						alert(result);
					}
			});
		});
		
		$("#uploadBtn").on("click",function(e){ //업로드 버튼
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			console.log(files);
			
			for(var i = 0 ; i <files.length;i++) {
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]);
			}
			
			$.ajax({
				url : "/uploadAjaxAction",
				processData : false,
				contentType : false, //반드시 false
				data : formData,
					type:"POST",
					dataType:'json',
					success:function(result){
						console.log(result);
						showUploadedFile(result);
						$(".uploadDiv").html(cloneObj.html());
				}
			});
		});
	});
	
	//파일 확장자 및 크기 처리
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize= 5242880; //5mb
	function checkExtension(fileName,fileSize) {
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과!");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	</script>
</head>
<body>
	<h1>Ajax를 이용한 업로드</h1>

	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<div class = "uploadResult">
		<ul>
		</ul>
	</div>
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	<button id="uploadBtn">Upload</button>
	
	
</body>
</html>