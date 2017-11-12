<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<!-- 
* Param : rowcnt (전체 row 수)
* Param : nowpage (현재 페이지)
-->
<div style="font-weight:bold; word-spacing:4px; font-size:12pt;">
<c:set var="printrow" value="${param.printrow}"/>
<c:set var="rowcnt" value="${param.rowcnt}"/>
<c:set var="nowpage" value="${param.nowpage}"/>

<!-- 선언부 -->
<c:set var="pagecnt" value="${(rowcnt/printrow+(1-(rowcnt/printrow%1))%1)}" />
<!-- 페이지 수 소수점 올림 -->

<c:set var="blockSize" value="10"/>
<c:set var="firstPage" value="${nowpage - ((nowpage-1)%blockSize)}" />
<c:set var="lastPage" value="${firstPage + (blockSize-1)}" />
<!-- 마지막 페이지 넘버가 전체 페이지 수보다 크면 전체 페이지로 맞춰준다. -->
<c:if test="${lastPage > pagecnt}">
	<c:set var="lastPage" value="${pagecnt}" />
</c:if>
<!-- 선언부 끝 -->
<!-- 전 페이지  시작-->
<c:if test="${nowpage+0>blockSize+0}">
	<a href="javascript:go_page('<c:out value="${firstPage-1}" />','<c:out value="${printrow}" />')"><span style="font-size:7pt; vertical-align:middle;">◀</span>이전  </a>
</c:if>
<!-- 전 페이지  끝-->
<!-- 페이징 넘버링 시작-->
<c:forEach var="paging" begin="${firstPage}" end="${lastPage}" step="1" varStatus="cnt" >
	<c:choose >
		<c:when test="${nowpage==paging}">
			<u style="color:#E94A11"><c:out value="${paging}" /></u>
		</c:when>
		<c:otherwise>
			<a href="javascript:go_page('<c:out value="${paging}" />','<c:out value="${printrow}" />')"><c:out value="${paging}" /></a>
		</c:otherwise>
	</c:choose>
</c:forEach>
<!-- 페이징 넘버링 끝-->		
<!-- 뒤 페이지 시작 -->
<c:if test="${lastPage-firstPage+1 == blockSize && pagecnt > blockSize}">
	<a href="javascript:go_page('<c:out value="${lastPage+1}" />','<c:out value="${printrow}" />')"> 다음<span style="font-size:7pt; vertical-align:middle;">▶</span></a>
</c:if>
<!-- 뒤 페이지 끝-->
</div>
