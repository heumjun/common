<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.headerBD {position:relative;}
			.content {position:relative; height:250px; overflow: auto; text-align:center;}
		</style>
		<title>
			EMS - SPEC DOWNLAOD
		</title>
	</head>
	
	<body >
		<div class="headerBD">
			<table class = "searchArea2">
				<colgroup>
					<col width="10%"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>File No</th>
					<th>File Name</th>
				</tr>
			</table>	
		</div>
		<div class="content" style="overflow: scroll; overflow-x: hidden; overflow-y:visible; margin-top: 0px;">
			<table class = "searchArea2">
				<colgroup>
					<col width="10%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<c:forEach items="${downList }" var="item" varStatus="status">
						<tr>
							<td width="10px">${status.count}</td>
							<td align="left"><a href="javascript:void(0);" onclick="fileView('${item.file_id}')" style="cursor:hand; text-decoration: underline;">${item.file_name}</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<script type="text/javascript" >
			window.focus();
			function fileView(file_id) {
				
				var url = "popUpPurchasingNewPosDownloadFile.do?p_file_id="+file_id;				
			
				var nwidth = 800;
				var nheight = 700;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
				window.open(url,"",sProperties);
				window.focus();
			}
		</script>
	</body>
</html>