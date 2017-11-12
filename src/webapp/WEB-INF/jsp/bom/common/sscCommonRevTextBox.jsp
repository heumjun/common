<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${revNo == ''}">
		<c:set var="rev_val" value="00" />
	</c:when>
	<c:otherwise>
		<c:set var="rev_val" value="${revNo}" />
	</c:otherwise>
</c:choose>

<input type="text" name="p_rev_no" value="${rev_val}" style="width:30px;" onKeyPress="return numbersonly(event, false)" maxlength="2" <c:if test="${p_item_type_cd == 'PI' || p_item_type_cd == 'SU' }">readonly="readonly"</c:if> />

