<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
		<title>����� �ϰ� �Է�</title>		
		<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>		
		
	</head>
	<body>
		<form id="application_form" name="application_form">
			<div style="margin-top: 10px;">
				<table class="searchArea2" >
					<tr>
						<td style="font-size:10pt;">
							������ �������� ����� �ϰ� �Է��մϴ�.<br><br>						
							<p style="LINE-HEIGHT: 150%;">
							&nbsp;&nbsp;&nbsp;&nbsp;  ��(Y) : �� �Էµ� ����ڵ� ����<br>
							&nbsp;&nbsp;&nbsp;&nbsp;  �ƴϿ�(N) : �� �Էµ� ����ڴ� ����<br>
							&nbsp;&nbsp;&nbsp;&nbsp;  �� �� : â �ݱ�
							</p>							
						</td>
					</tr>				
				</table>
			</div>
 			<div style="margin-top: 10px; float:right; margin-right:10px;">
 			    <input type="button" id="btn1" value="��(Y)" class="btn_blue" style="width:80px"/> 
 				<input type="button" id="btn2" value="�ƴϿ�(N)" class="btn_blue" style="width:80px"/> 
 				<input type="button" id="btn3" value="�� ��" class="btn_blue" style="width:80px"/> 
 			</div> 
		</form>
		<script type="text/javascript">
			// ���õ� ��ư�� ���� �� ����
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
