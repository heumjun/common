<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>담당자정보</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div
		style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
		<!-- 		<img src="/images/main/info_tit.gif" /> -->
		<img src="/images/main/tit_info.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
	</div>
	<table class="table_st01">
		<col width="40px">
		<col width="80px">
		<col width="60px">
		<col width="180px">
		<col width="*">
		<col width="100px">
		<thead>
			<tr>
				<th><strong>번호</strong></th>
				<th><strong>담당자</strong></th>
				<th><strong>직급</strong></th>
				<th><strong>부서명</strong></th>
				<th><strong>담당업무</strong></th>
				<th class="end" style="border-right: none;"><strong>전화번호</strong></th>
			</tr>
			<c:choose>
				<c:when test="${fn:length(list) > 0}">
					<c:forEach var="item" items="${list}" varStatus="status">
						<tr>
							<td>${status.index+1}</td>
							<td>${item.manager_name}</td>
							<td>${item.position_name}</td>
							<td>${item.dept_name}</td>
							<td>${item.manager_task}</td>
							<td class="end">${item.manager_tel}</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td class="end" colspan="5">등록된 담당자 정보가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</thead>
	</table>
</body>
</html>
