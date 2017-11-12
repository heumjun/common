<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 카탈로그 리스트 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewCatalog.jsp
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
		    frmCatalog.action = "itemCategoryViewCatalog.do?mode=search";
		    frmCatalog.method = "post";
		    frmCatalog.submit();
		   
		}
		
		// 엑셀 다운로드
		function excelDownload()
		{
		   frmCatalog.action="itemCategoryViewCatalogExcelDownload.do";
		   frmCatalog.target="_self";
		   frmCatalog.submit();
		
		}
	</script>
</head>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
	<form name="frmCatalog" method="post" >
		<div style="margin:2px 2px;">
			<div class="ct_sc conSearch" style="height:33px">
				<strong class="pop_tit mgl10" style="vertical-align: middle;">정렬항목</strong>
				<input type="radio" name="sort_type" value="ALL" <c:if test="${sort_type == 'ALL'}">checked</c:if> >ALL
				<input type="radio" name="sort_type" value="V" 	 <c:if test="${sort_type == 'V'}">checked</c:if>>VIRTUAL
				<input type="radio" name="sort_type" value="S"   <c:if test="${sort_type == 'S'}">checked</c:if>>일반호선자재
				<input type="radio" name="sort_type" value="M" 	 <c:if test="${sort_type == 'M'}">checked</c:if>>MRO
				<input type="radio" name="sort_type" value="E" 	 <c:if test="${sort_type == 'E'}">checked</c:if>>비용성품목
				
				<strong class="pop_tit mgl10" style="vertical-align: middle;">CATALOG명</strong>
				<input type="text" style="width:100px" name="catalog_name" value="${catalog_name}" size="25" onKeyUp="javascript:this.value=this.value.toUpperCase();">
				<div class="button endbox">
					<input type="button" name="buttonSearch" value='조 회' class="btn_blue" onClick="actionSearch();">
					<input type="button" name="buttonReport" value='Excel출력' class="btn_blue" onclick="excelDownload();">
				</div>
			</div>	
			<table class="insertArea"  style="table-layout:fixed;">
				<tr align="center">
					<th width="6%">CATALOG</th>
					<th width="3%">CODE</th>
					<th width="12%">ITEM 구분</th>
					<th width="3%">CODE</th>
					<th width="17%">대분류</th>
					<th width="3%">CODE</th>
					<th width="17%">중분류</th>
					<th width="3%">CODE</th>
					<th width="18%">DESCRIPTION</th>
					<th width="4%">도면<BR>연계</th>
					<th width="7%">MRP계획</th>
					<th width="7%">MRP계획<BR>(특수선)</th>
					<th width="16px">&nbsp;</th>
				</tr>
			</table>
			<div id="contentdiv" style="overflow-y:scroll; position:relative;">
				<table class="insertArea"  style="table-layout:fixed;">
					<c:forEach var="item" items="${list}" varStatus="status"> 
					    <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
					        <td width="6%" align="center">${item.catalog_code}</td>
					        <td width="3%" align="center">${item.item_list_code}</td>
					        <td width="12%">${item.item_list_desc}</td>
					        <td width="3%" align="center">${item.l_catalog_code}</td>
					        <td width="17%">${item.l_catalog_desc}</td>
					        <td width="3%" align="center">${item.m_catalog_code}</td>
					        <td width="17%">${item.m_catalog_desc}</td>
					        <td width="3%" align="center">${item.s_catalog_code}</td>
					        <td width="18%">${item.s_catalog_desc}</td>
					        <td width="4%" align="center">${item.dwg_flag}</td>
					        <td width="7%">${item.mrp_planning_desc}</td>
					        <td width="7%">${item.sp_mrp_planning_desc}</td>
					
					     </tr>
					</c:forEach>
				</table>
			</div>
		
		</div>
	</form>                 
</body>
</html>