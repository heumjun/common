<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
	<c:when test="${listCode =='seasonCode'}">
		<c:forEach var="item" items="${selectBoxList}" varStatus="count">
			<option value="<c:out value="${item.value}" />"><c:out value="${item.text}" /></option>
		</c:forEach>
	</c:when>
</c:choose>