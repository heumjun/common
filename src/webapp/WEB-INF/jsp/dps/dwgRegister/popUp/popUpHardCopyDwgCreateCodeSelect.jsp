<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Category of Change</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body style=" overflow : scroll; overflow-x : hidden;">
	<div id="mainDiv" class="mainDiv" style="max-width: 500px;">
		<div id="contentBody" class="content">
			<table cellSpacing="0" cellpadding="6" border="1" align="center">
				<col width="10%"/>
				<col width="20%"/>
				<col width="*"/>
				
			    <tr height="20">
			        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Group</font></td>
			        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Desc.</font></td>
			        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Category of Change</font></td>
			    </tr>
			    <c:set var="currentGrpKey" value=""/>
			    <c:forEach var="item" items="${reasonCodeList }">
			    	<tr style="background-color:#ffffff;">
			    		<c:if test="${item.grp_key ne currentGrpKey}">
						    <td class="td_standard" rowspan="${item.code_cnt }">
			                    ${item.grp_key }
			                </td>
			                <td class="td_standard" rowspan="${item.code_cnt }">
			                    ${item.grp_value }
			                </td>
			                <c:set var="currentGrpKey" value="${item.grp_key }"/>
			    		</c:if>
			    		<td style="padding:1px 2px 1px 2px;" onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
			    			<input type="radio" name="" value="" onclick="window.returnValue='${item.code_key }'; window.close();" /> ${item.code_key} (${item.code_value})			
			    		</td>
			    	</tr>
			    </c:forEach>
			</table>
		</div>
	</div>
</body>
</html>