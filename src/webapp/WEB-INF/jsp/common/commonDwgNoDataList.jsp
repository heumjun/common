<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<c:forEach var="item" items="${dwgList}" varStatus="count">		
	<div id="div_<c:out value="${item.d_dwgno}" />" onmouseover="javascript:$(this).addClass('onMs');"  
													onmouseout="javascript:$(this).removeClass('onMs');" 
													onclick="javascript:$('#p_dwgno').val($.trim($(this).text())); $('#dwgnoArea').hide();">
		<c:out value="${item.d_dwgno}" />
	</div>
</c:forEach>
