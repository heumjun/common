<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div
		style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
		<!-- 		<img src="/images/main/info_tit.gif" /> -->
		<img src="/images/main/tit_notice.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
	</div>
	<table class="table_st01">
		<col width="60px">
		<col width="350px">
		<col width="80px">
		<col width="80px">
		<col width="80px">
		<thead>
			<tr>
				<th><strong>번호</strong></th>
				<th><strong>제목</strong></th>
				<th><strong>등록자</strong></th>
				<th><strong>등록일자</strong></th>
				<th><strong>조회수</strong></th>
			</tr>
			<c:choose>
				<c:when test="${fn:length(noticeList) > 0}">
					<c:forEach var="item" items="${noticeList}" varStatus="status">
						<tr style="cursor: pointer;" onclick="JavaScript:notice('${item.seq}');">
							<td>${status.index+1}</td>
							<td style="text-align: left;">${item.subject}</td>
							<td>${item.create_by_name}</td>
							<td>${item.create_date}</td>
							<td class="end" style="border-right: none;">${item.read_count}</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<td class="end" style="border-right: none;" colspan="5">등록된 공지사항이 없습니다.</td>
				</c:otherwise>
			</c:choose>
		</thead>
	</table>
	<script type="text/javascript">
		function notice(seq) {
			document.location.href = "popUpNotice.do?seq=" + seq;
		}
	</script>
</body>
</html>
