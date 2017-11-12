<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<c:forEach var="item" items="${revList}" varStatus="count">
	<input type="text" name="p_selrev" size="2" maxlength="2" onKeyPress="return numbersonly(event, false)" value="<c:out value="${item.d_rev_no}" />" <c:if test="${requestbox.p_item_type_cd == 'PI' || requestbox.p_item_type_cd == 'SU' }">readonly="readonly"</c:if> />
</c:forEach>
<c:if test="${revListSize == 0}" >
	<input type="text" name="p_selrev" value="00" size="2"  onKeyPress="return numbersonly(event, false)" maxlength="2" <c:if test="${requestbox.p_item_type_cd == 'PI' || requestbox.p_item_type_cd == 'SU' }">readonly="readonly"</c:if> />
</c:if>
