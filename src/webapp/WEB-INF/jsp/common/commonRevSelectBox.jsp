<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<c:forEach var="item" items="${revList}" varStatus="count">
	<option value="<c:out value="${item.d_rev_no}" />"  <c:if test="${requestbox.p_selrev == item.d_rev_no}"> selected="selected" </c:if> >
		<c:out value="${item.d_rev_no}" />
	</option>
</c:forEach>
<c:if test="${revListSize == 0}" >
	<option value="00">00</option>
</c:if>
