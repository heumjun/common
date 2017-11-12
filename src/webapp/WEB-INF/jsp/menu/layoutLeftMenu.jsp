<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--========================== PAGE DIRECTIVES START =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%--========================== PAGE DIRECTIVES END   =============================--%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%--========================== SCRIPT ======================================--%>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<script type="text/javascript">
		function addTab(title, url, upTitle) {
			if("설계표준관리" == title) {
				newWinQms(url);		
			} else if("도면일정 준수현황" == title) {
				var rs = window.open(url + "&newWin=Y&emp_no=${loginUser.user_id}&isDims=Y", "",
				"height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
		    } else {
		    	parent.frames['main'].addTab(title, url, upTitle);
			}
		}
		function newWin(title,url) {
			if("설계표준관리" == title) {
				var rs = window.open(url + "&newWin=Y", "",
				"height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
			} else if("도면일정 준수현황" == title) {
				var rs = window.open(url + "&newWin=Y&emp_no=${loginUser.user_id}&isDims=Y", "",
				"height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
		    } else {
				var rs = window.open(url + "&newWin=Y", "",
						"height=850,width=1570,top=200,left=200,location=no,scrollbars=no, resizable=yes");
			}
			
		}
		function newWinQms(url) {
			var rs = window.open(url + "&newWin=Y", "",
					"height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
		}
		$(document).ready(function() {
			menuCall();

			$(window).resize(function(e) {
				menuCall();
			});

			$(".menu_anchor").click(function() {
				var li_id = $(this).parent()[0].id;
				if ($("#" + li_id + " > ul").hasClass("newClass")) {
					$("#" + li_id + "_img").attr("src", "./images/icon_close.png");
					$("#" + li_id + "_img2").attr("src", "./images/icon_close2.png");
					$("#" + li_id + "_img3").attr("src", "./images/icon_close3.png");
					$("#" + li_id + " > ul").removeClass("newClass").show("blind", '', 300);
				} else {
					$("#" + li_id + "_img").attr("src", "./images/icon_oepn.png");
					$("#" + li_id + "_img2").attr("src", "./images/icon_oepn2.png");
					$("#" + li_id + "_img3").attr("src", "./images/icon_oepn3.png");
					$("#" + li_id + " > ul").addClass("newClass").hide("blind", '', 300);
				}
				$("#leftAreaBg").focus();
			});

			var toggle = 0;
			$("#systop_menu_collapse").click(function() {
				if (toggle == 0) {
					$('ul.leftmenu > li').each(function(index) {
						var li_id = $(this).attr("id");
						if (li_id != "undefined") {
							$("#" + li_id + "_img").attr("src", "./images/icon_close.png");
							$("#" + li_id + "_img2").attr("src", "./images/icon_close2.png");
							$("#" + li_id + "_img3").attr("src", "./images/icon_close3.png");
							$("#" + li_id + " > ul").removeClass("newClass").show("blind", '', 300);
							toggle = 1;
						}
					});
					$("#fold_img").attr("src", "./images/systop_menuclose.gif");
				} else {
					$('ul.leftmenu > li').each(function(index) {
						var li_id = $(this).attr("id");
						if (li_id != "undefined") {
							$("#" + li_id + "_img").attr("src", "./images/icon_oepn.png");
							$("#" + li_id + "_img2").attr("src", "./images/icon_oepn2.png");
							$("#" + li_id + "_img3").attr("src", "./images/icon_oepn3.png");
							$("#" + li_id + " > ul").addClass("newClass").hide("blind", '', 300);
							toggle = 0;
						}
					});
					$("#fold_img").attr("src", "./images/systop_menuopen.gif");
				}

				$("#leftAreaBg").focus();

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
</head>
<body>
	<div id="leftArea" style="overflow-x: hidden;">
		<h1>
			<span id="systop_menu_collapse" style="cursor: pointer;"><img
				id="fold_img" src="./images/systop_menuopen.gif" alt="메뉴펼침" /></span>
		</h1>
		<ul class="leftmenu" style="margin-top: -30px;">
			<c:forEach var="item" items="${treeMenuList}" varStatus="status">
				<c:choose>
					<c:when test="${item.lev != 0}">
						<c:choose>
							<c:when test="${1 == item.lev}">
								<c:set var="up_name">${item.pgm_name}</c:set>
								<c:if test="${tempLev > item.lev}">
		</ul>
		</li>
		</c:if>
		<li id="${item.menu_id}" class="redmenuli${item.menu_group}"><a
			id="${item.menu_id}_a" href="#" class="menu_anchor"> <span
				style="float: left; margin-right: 3px;"> <img
					id="${item.menu_id}_img${item.menu_group}"
					src="./images/icon_oepn${item.menu_group}.png">
			</span>${item.pgm_name}
		</a> </c:when> <c:when test="${2 == item.lev}">
				<c:if test="${tempLev < item.lev}">
					<ul class="newClass" style="display: none">
				</c:if>
				<c:choose>
					<c:when test="${fn:indexOf(item.pgm_link, 'openMenu(') == -1 }">
						<c:choose>
							<c:when test="${fn:indexOf(item.pgm_link, '?') == -1 }">
								<li><a
									onclick="addTab('${item.pgm_name}','${item.pgm_link}?menu_id=${item.menu_id}&up_link=${item.up_link}','${up_name}')">
										<div style="width: 110px">${item.pgm_name}</div>
								</a>
									<div class="newWin"
										style="text-align: center; margin: 7px 0 0 155px; position: absolute; height: 25px; width: 10px;"
										onclick="newWin('${item.pgm_name}','${item.pgm_link}?menu_id=${item.menu_id}&up_link=${item.up_link}')">

									</div></li>
							</c:when>
							<c:otherwise>
								<li><a
									onclick="addTab('${item.pgm_name}','${item.pgm_link}&menu_id=${item.menu_id}&up_link=${item.up_link}','${up_name}')">
										<div style="width: 110px">${item.pgm_name}</div>
								</a>
									<div class="newWin"
										style="text-align: center; margin: 7px 0 0 155px; position: absolute; height: 25px; width: 10px;"
										onclick="newWin('${item.pgm_name}','${item.pgm_link}&menu_id=${item.menu_id}&up_link=${item.up_link}')">
									</div></li>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<li><a href="${item.pgm_link}"><div style="width: 130px">${item.pgm_name}</div></a></li>
					</c:otherwise>
				</c:choose>
			</c:when> </c:choose> <c:set var="tempLev" value="${item.lev}"></c:set> </c:when> <c:otherwise>
				<li><a
					href="<c:url value="manageMenu.do?p_up_menu_id=${item.menu_id}"/>"
					target="main">최상위메뉴</a></li>
			</c:otherwise> </c:choose> </c:forEach>
			</ul>
	</div>
	<div id="leftAreaBg"></div>
</body>
</html>