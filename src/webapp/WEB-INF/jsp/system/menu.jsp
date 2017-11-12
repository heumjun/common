<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<script type="text/javascript">
	$(document).ready(function() {
		$(window).bind('resize', function() {
			$("#leftFrame").css({
				'height' : $(window).height() - 50
			});
			$("#centerFrame").css({
				'height' : $(window).height() - 50
			});
		}).trigger('resize');
	});
</script>
<title>메뉴관리</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<table>
	<tr>
		<td width="15%"><iframe id="leftFrame" src="menuTree.do?menu_id=${menu_id}&up_link=${up_link}" scrolling=no
				name="left" frameborder=0 style="width: 200px; height: 100%;"></iframe></td>
		<td width="85%"><iframe id="centerFrame"
				src="manageMenu.do?p_up_menu_id=M00000&menu_id=${menu_id}&up_link=${up_link}" name="menu_body" scrolling=no
				frameborder=0 style="width: 100%; height: 100%;"></iframe></td>
	</tr>
</table>
</html>
