<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>menu test</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<script type="text/javascript">
	var toggle = 0;
	function menuToggle() {

		var frame = parent.document.getElementById("body");

		if (toggle == 0) {
			frame.cols = "0,12,*";
			toggle = 1;
			$("#hideLink").attr("src", "./images/unfold.png")
		} else {
			frame.cols = "204,12,*";
			toggle = 0;
			$("#hideLink").attr("src", "./images/fold.png")
		}
	}
</script>
</head>
<body>
	<div style="display: table; height: 100%; width: 100%; background: #aaa; overflow: hidden; text-align: center">
		<div style="position: absolute; top: 50%; display: table-cell; vertical-align: middle;">
			<img id="hideLink" src="./images/fold.png" style="cursor: pointer;" onclick="JavaScript:menuToggle();">
		</div>
	</div>
</body>
</html>