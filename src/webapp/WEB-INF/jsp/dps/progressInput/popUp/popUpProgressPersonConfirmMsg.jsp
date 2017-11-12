<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
		<title>담당자 일괄 입력</title>		
		<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>		
		
	</head>
	<body>
		<form id="application_form" name="application_form">
			<div style="margin-top: 10px;">
				<table class="searchArea2" >
					<tr>
						<td style="font-size:10pt;">
							선택한 조건으로 담당자 일괄 입력합니다.<br><br>						
							<p style="LINE-HEIGHT: 150%;">
							&nbsp;&nbsp;&nbsp;&nbsp;  예(Y) : 기 입력된 담당자도 변경<br>
							&nbsp;&nbsp;&nbsp;&nbsp;  아니요(N) : 기 입력된 담당자는 제외<br>
							&nbsp;&nbsp;&nbsp;&nbsp;  닫 기 : 창 닫기
							</p>							
						</td>
					</tr>				
				</table>
			</div>
 			<div style="margin-top: 10px; float:right; margin-right:10px;">
 			    <input type="button" id="btn1" value="예(Y)" class="btn_blue" style="width:80px"/> 
 				<input type="button" id="btn2" value="아니요(N)" class="btn_blue" style="width:80px"/> 
 				<input type="button" id="btn3" value="닫 기" class="btn_blue" style="width:80px"/> 
 			</div> 
		</form>
		<script type="text/javascript">
			// 선택된 버튼에 따라 값 리턴
			$("input[type='button']").click(function(e){

				var str = $(this).attr("id");
				if(str == "btn1")
				{
					str = "YES";
				} else if(str == "btn2"){
					str = "NO";
				} else{
					str = "CANCEL";
				}
				window.returnValue = str;
				self.close();
			});
		</script>
	</body>
</html>
