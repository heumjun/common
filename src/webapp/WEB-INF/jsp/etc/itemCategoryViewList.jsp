<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 구매요청/비용성/BSI/GSI 항목 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemList.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
    <style type="text/css">
		A:link {color:black; text-decoration: none}
		A:visited {color:black; text-decoration: none}
		A:active {color:green; text-decoration: none ; font-weight : bold;}
		A:hover {color:red;text-decoration:underline font-weight : bold;}
		.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
		.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
		.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
		.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
		.title_5			{font-family:"굴림체"; font-Size: 11pt;}
		.title_6			{font-family:"굴림체"; font-Size: 10pt;}
		.title_7			{font-family:"굴림체"; font-Size: 9pt;}
		.title_8			{font-family:"굴림체"; font-Size: 8pt;}
		.button_simple
		{
			font-size: 10pt;
			height: 26px;
			width: 70px;
		}
		
	</style>
		
	<script language="javascript">
		$(document).ready(function(){
			$(window).bind('resize', function() {
				$('#contentdiv').css('height', $(window).height()-70);
			 }).trigger('resize');	
			parent.loadingBox.remove();
		});
		function actionSearch()
		{
			parent.fn_loadingBox();
		    frmItemList.action = "itemCategoryViewList.do?mode=search";
		    frmItemList.method = "post";
		    frmItemList.submit();
		}
		
		// 엑셀 다운로드
		function excelDownload()
		{
		   frmItemList.action="itemCategoryViewListExcelDownload.do";
		   frmItemList.target="_self";
		   frmItemList.submit();
		
		}
		
	</script>
</head>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmItemList" method="post" >
<div style="margin:2px 2px;">
	<div class="ct_sc conSearch" style="height:33px">
		<strong class="pop_tit mgl10" style="vertical-align: middle;">	조회항목</strong>
        <input type="radio" name="select_type" value="PRDP"  <c:if test="${select_type == 'PRDP' }">checked</c:if> >구매요청
        <input type="radio" name="select_type" value="C_PRDP" <c:if test="${select_type == 'C_PRDP' }">checked</c:if> >비용성            
        <input type="radio" name="select_type" value="BS" <c:if test="${select_type == 'BS' }">checked</c:if> >BSI
        <input type="radio" name="select_type" value="GS" <c:if test="${select_type == 'GS' }">checked</c:if> >GSI
		<div class="button endbox">
			<input type="button" name="buttonSearch" value='조 회' class="btn_blue" onClick="actionSearch();">
			<input type="button" name="buttonReport" value='Excel출력' class="btn_blue" onclick="excelDownload();">
		</div>
</div>

			<table class="insertArea"  style="table-layout:fixed;">
                <tr align="center" height="28" bgcolor="#e5e5e5">
                    <th width="10%">CATALOG</th>
                    <th width="10%">CATEGORY</th>
                    <th width="20%">ITEM CODE</th>
                    <th width="40%">DESCRIPTION</th>
                    <th width="20%">TEMPLATE</th>
                    <th width="16px">&nbsp;</th>
                </tr>
            </table>
           <div id="contentdiv" style="overflow-y:scroll; position:relative;">
           	<table class="insertArea"  style="table-layout:fixed;">
           		<c:forEach var="item" items="${list}" varStatus="status"> 
	                <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
	                    <td width="10%" align="center">${item.catalog_code}</td>
	                    <td width="10%" align="center">${item.category_code}</td>
	                    <td width="20%" align="center">${item.part_no}</td>
	                    <td width="40%">&nbsp;${item.description}</td>
	                    <td width="20%" align="center">${item.item_type_desc}</td>
	                 </tr>
           		</c:forEach>
            </table>
            </div>
     </div>
	</form>                  
</body>
</html>