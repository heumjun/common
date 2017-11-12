<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<c:choose>
<c:when test="${sb_type=='all'}"><option value="ALL">ALL</option></c:when>
<c:when test="${sb_type=='not'}">
</c:when>
<c:when test="${sb_type=='sel'}"><option value="">선택</option></c:when>	
<c:otherwise><option value=""></option></c:otherwise>
</c:choose>
<c:forEach var="item" items="${list}" varStatus="count">
<option value="<c:out value="${item.d_sb_value}" />" <c:out value="${item.d_sb_selected}" /> ><c:out value="${item.d_sb_name}" /></option>
</c:forEach>

