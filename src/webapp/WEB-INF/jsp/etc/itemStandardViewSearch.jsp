<%--  
§DESCRIPTION: EP 부품표준서 조회 - 전체보기
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPItemViewSearch.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
    <script type="text/javascript" src="./js/stxAjax.js"></script>
	<script type="text/javascript" src="./js/SecurePM3AX2.js"></script>
	<script language="javascript" src="http://dwgprint.stxons.com/dsv/DSViewerAX.js"></script>
	<script type="text/javascript">
		SecurePM3AXControl();
		DSViewerAXControl();
	</script>
	<style type="text/css">
		tr,td {font-family:"맑은 고딕","verdana","arial"; font-size: 9pt ; text-decoration: none; color:#1A1A1A;}
		.header {font-family:"맑은 고딕","verdana","arial"; font-size: 13pt ; text-decoration: none; color:#1A1A1A; font-weight : bold;}
		.even {background-color:#eeeeee}
		.odd {background-color:#ffffff}
		.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
		.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
		.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
		.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
		.title_5			{font-family:"굴림체"; font-Size: 11pt;}
		.title_6			{font-family:"굴림체"; font-Size: 10pt;}
		.title_7			{font-family:"굴림체"; font-Size: 9pt;}
		.title_8			{font-family:"굴림체"; font-Size: 8pt;}
		
	</style>
</head>
<script language="javascript" type="text/javascript">
	$(document).ready(function(){
		$(window).bind('resize', function() {
			$('#contentdiv').css('height', $(window).height()-72);
		 }).trigger('resize');	
	});
	function actionSearch()
	{
		var va = $('#sItemName').val();		
		
		if(va=="" || va==null)
		{
			alert("검색 조건을 입력하세요.");
			return;
		} 
	
	    frmSearch.action = "itemStandardViewSearch.do?mode=search";
	    frmSearch.method = "post";
	    frmSearch.submit();
	}
	
	function fn_orderby(){
		var orderby = $("#orderby");
		if(orderby.val() == "asc"){
			orderby.val("desc");
		} else {
			orderby.val("asc");
		}
		actionSearch();
	}

</script>
<body>
<form name="frmSearch" method="post">
<div style="margin:2px 2px;">
    <div class="ct_sc conSearch" style="height:33px">
		<strong class="pop_tit mgl10" style="vertical-align: middle;">CATALOG명</strong>
		<input type="text" style="width:100px" id="sItemName" name="sItemName" value="${sItemName}" size="25" onKeyUp="javascript:this.value=this.value.toUpperCase();">
		<input type="hidden" name="orderby" id="orderby" value="<c:if test="${orderby eq '' or orderby eq null }">asc</c:if>${orderby }"/>
    	<input type="button" name="buttonSearch" value='조 회' class="btn_gray2" onClick="actionSearch();">
	</div>	
	<table class="insertArea" style="table-layout:fixed; width: 99%">
		<col width="4.3%">
		<col width="16.8%">
		<col width="2.3%">
		<col width="2.3%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
         <tr align="center" height="28" bgcolor="#e5e5e5">
             <th onclick="fn_orderby()" style="cursor: pointer;">Catalog</th>
             <th>Name</th>
             <th>File</th>
             <th>UOM</th>
             <th>물성치01</th>
             <th>물성치02</th>
             <th>물성치03</th>
             <th>물성치04</th>
             <th>물성치05</th>
             <th>물성치06</th>
             <th>물성치07</th>
             <th>물성치08</th>
             <th>물성치09</th>
             <th>물성치10</th>
             <th>물성치11</th>
             <th>물성치12</th>
             <th>물성치13</th>
             <th>물성치14</th>
             <th>물성치15</th>
         </tr>
     </table>

     <div id="contentdiv" style="overflow-y:scroll; position:relative;">
      <table class="insertArea"  style="table-layout:fixed;">
      	<col width="4.3%">
		<col width="16.8%">
		<col width="2.3%">
		<col width="2.3%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<c:forEach var="item" items="${list}" varStatus="status"> 
               <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                   <td align="center">
                       ${item.catalog_S}
                   </td>
                   <td align="left">
                       ${item.name_S}
                   </td>
                   <td align="center"  style="cursor:pointer"
                       onClick="hiddenFrame.go_pdfView('${loginID}','${item.view_flag}','${item.PART_SEQ_ID}','${item.item_catalog_group_id}');">
                       <%-- onClick="go_pdfView('<%=itemViewListMap.get("view_flag")%>','<%=itemViewListMap.get("PART_SEQ_ID")%>','<%=itemViewListMap.get("item_catalog_group_id")%>');"> --%>
                       <img src="images/pdf_icon.gif" border="0">
                   </td>
                   <td align="center">${item.UOM}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR01}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR02}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR03}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR04}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR05}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR06}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR07}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR08}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR09}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR10}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR11}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR12}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR13}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR14}</td>
                   <td align="center" style="font-size : 7pt;" >${item.CATALOG_ATTR15}</td>
               </tr> 
      	</c:forEach>
      </table>
     </div>
</div>
    <input type="hidden" name="loginID" value="${loginID}">
    <iframe id="hiddenFrame" name="hiddenFrame" src="AddOn/EP/stxDSView.jsp" style="display:none"></iframe>
</form>

</body>
</html>
