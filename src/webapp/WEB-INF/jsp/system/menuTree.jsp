<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>menu test</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="leftArea" style="overflow-x: hidden; background: url();">
		<ul class="leftmenu" style="margin-left: -10px;">
			<c:forEach var="item" items="${treeMenuList}" varStatus="status">
				<c:choose>
					<c:when test="${item.lev != 0}">
						<c:choose>
							<c:when test="${1 == item.lev}">
								<c:if test="${tempLev > item.lev}">
		</ul>
		</li>
		</c:if>
		<li id="${item.menu_id}"><a id="${item.menu_id}_a"
			href="<c:url value="manageMenu.do?p_up_menu_id=${item.menu_id}&menu_id=${menu_id}&up_link=${up_link}"/>" class="menu_anchor"
			target="menu_body"><span style="float: left; margin-right: 3px;"><img id="${item.menu_id}_img"
					src="/images/icon_oepn.png"></span>&nbsp;${item.pgm_name}</a> </c:when> <c:when test="${2 == item.lev}">
				<c:if test="${tempLev < item.lev}">
					<ul class="none">
				</c:if>
				<li><a href="#">${item.pgm_name}</a></li>
			</c:when> </c:choose> <c:set var="tempLev" value="${item.lev}"></c:set> </c:when> <c:otherwise>
				<li><a id="${item.menu_id}_a"
					href="<c:url value="manageMenu.do?p_up_menu_id=${item.menu_id}&menu_id=${menu_id}&up_link=${up_link}"/>" target="menu_body"><span
						style="float: left; margin-right: 3px;"><img id="${item.menu_id}_img" src="/images/icon_oepn.png"></span>&nbsp;최상위메뉴</a></li>
			</c:otherwise> </c:choose> </c:forEach>
			</ul>
	</div>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		menuCall();

		$(window).resize(function(e) {
			menuCall();
		});

		var toggle = 0;
		$(".menu_anchor").click(function() {
			var li_id = $(this).parent()[0].id;

			if ($("#" + li_id + " > ul").hasClass("none")) {
				$("#" + li_id + " > ul").removeClass("none");
			} else {
				$("#" + li_id + " > ul").addClass("none");
			}
			//$("#leftAreaBg").focus();
		});

		$("#systop_menu_collapse").click(function() {
			if (toggle == 0) {
				$('ul.leftmenu > li').each(function(index) {
					var li_id = $(this).attr("id");
					if (li_id != "undefined") {
						$("#" + li_id + " > ul").removeClass("none");
						toggle = 1;
					}
				});
				$("#fold_img").attr("src", "images/systop_menuclose.gif");
			} else {
				$('ul.leftmenu > li').each(function(index) {
					var li_id = $(this).attr("id");
					if (li_id != "undefined") {
						$("#" + li_id + " > ul").addClass("none");
						toggle = 0;
					}
				});
				$("#fold_img").attr("src", "images/systop_menuopen.gif");
			}
		});
	}); 

	//menu resize
	function menuCall() {
		$("#leftArea").css("height", $(window).height() - 10);
		$("#leftArea").show();

		$("#leftAreaBg").css("height", $(window).height());
		$("#leftAreaBg").show();
	}

	//window open으로 새창열기
	function openMenu(url, nwidth, nheight) {
		// 화면 center에 위치
		var LeftPosition = (screen.availWidth - nwidth) / 2;
		var TopPosition = (screen.availHeight - nheight) / 2;

		var sProperties = "resizable=yes,left=" + LeftPosition + ",top=" + TopPosition + ",width=" + nwidth
				+ ",height=" + nheight;

		window.open(url, "", sProperties);
	}
</script>
</body>
</html>