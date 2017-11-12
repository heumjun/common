<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Category of Change</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body style=" overflow : scroll; overflow-x : hidden;">
	<div id="mainDiv" class="mainDiv" style="max-width: 380px;">
		<div id="contentBody" class="content">
			<table cellSpacing="0" cellpadding="6" border="1" align="center">
				<col width="50%"/>
				<col width="*"/>
				
			    <tr height="20">
			        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Group</font></td>
			        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Distribution Time.</font></td>
			    </tr>
			    <c:choose>
			    	<c:when test="${dwgCategory eq 'B' }">
				    	<tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">Impact of Afterwards Design</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="설계 전"/>Pre-Design
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="설계 후" />Post-Design
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">Impact of Production</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="생산 전" />Pre-Production
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="생산 후" />Post-Production
				            </td>
				        </tr>
			    	</c:when>
			    	<c:when test="${departCode eq '983000'}">
			    		<tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">STEEL CUTTING</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="절단 전" />Pre-Cutting
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="절단 후" />Post-Cutting
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">Production</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="시공 전" />Pre-Production
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="시공 후" />Post-Production
				            </td>
				        </tr>
			    	</c:when>
			    	<c:otherwise>
			    		<tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">Manufacture</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="제작 전"/>Pre-Manufacture
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_1" value="제작 후" />Post-Manufacture
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standard" rowspan="2">Installation</td>
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="설치 전" />Pre-Installation
				            </td>
				        </tr>
				        <tr style="background-color:#ffffff;">
				            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
				                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
				                <input type="radio" name="revTimingCheck_2" value="설치 후" />Post-Installation
				            </td>
				        </tr>
			    	</c:otherwise>
			    </c:choose>
			    <tr height="55">
			        <td colspan="2" style="vertical-align:middle;text-align:right;">
			            <input type="button" value="OK" class="btn_blue" id="btn_ok">
			            <input type="button" name="cancelButton" value="Cancel" class="btn_blue" onclick="window.close();">
			        </td>
			    </tr>
			</table>
		</div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("input[type=radio][name=revTimingCheck_1]:eq(0)").click(function(){
			$("input[type=radio][name=revTimingCheck_2]:eq(0)").prop("checked",true);
		});
		$("input[type=radio][name=revTimingCheck_2]:eq(1)").click(function(){
			$("input[type=radio][name=revTimingCheck_1]:eq(1)").prop("checked",true);
		});
		
		$("#btn_ok").click(function(){
				var revTimingCheck_1 = $("input[type=radio][name=revTimingCheck_1]:checked");
				var revTimingCheck_2 = $("input[type=radio][name=revTimingCheck_2]:checked");
				if (revTimingCheck_1.val() == undefined || revTimingCheck_2.val() == undefined) {
		            alert("Please select 'Distribution Time' items!");
		            return;
		        }
				window.returnValue = revTimingCheck_1.val() + "," + revTimingCheck_2.val();
			    window.close();
		});
	});
</script>
</body>
</html>