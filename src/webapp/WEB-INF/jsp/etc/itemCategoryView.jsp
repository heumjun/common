<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 헤더 (리스트 조회 항목 선택)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewHeader.jsp
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<script language="javascript">
	var loadingBox ;
	var menuId = '';
	$(function() {    
		$( "#tabs" ).tabs(); 
		
	});
	function changeTab(url) {
		fn_loadingBox();
		$("#teamIframe").attr("src",url);
	}
	$(document).ready(function(){
		$("#tab1").click();
		
		$(window).bind('resize', function() {
	    	$('#tabs').css('height', $(window).height()-170);
			$('#teamIframe').css('height', $(window).height()-200);
	     }).trigger('resize');
	});
	
	function fn_loadingBox(){
		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
	}
	
	function emsDbMasterLink() {
		//메뉴ID를 가져오는 공통함수 
		getMenuId("emsDbMaster.do", callback_MenuId);
		
		location.href='emsDbMasterLink.do?etc=Y&menu_id='+menuId;
	}
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
</script>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		STX조선해양 품목분류표
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<table class="searchArea conSearch">
		<tr>
			<td>
				<div class="button endbox">
					<input type="button" class="btn_blue" name="searchMode" value="기준정보 등록요청" onclick="location.href='standardInfoTrans.do'">
					<input type="button" class="btn_blue" name="searchMode" value="부품표준서" onclick="location.href='itemStandardView.do'">
					<!-- menu_id=M00123 메뉴 ID 값 하드코딩 처리 2017-03-09 -->
					<input type="button" class="btn_blue" name="searchMode" value="기자재통합기준정보관리" onclick="javascript:emsDbMasterLink();">
<!-- 					<input type="button" class="btn_blue" name="searchMode" value="양식지&메뉴얼" onclick="location.href='documentView.do'"> -->
				</div>
			</td>
		</tr>
	</table>
	<div id="tabs" style = "margin-top:10px">
		<ul>
			<li><a id="tab1" href="#tabs-1" onclick="changeTab('itemCategoryViewCatalog.do')">CATALOG</a></li>
			<li><a id="tab2" href="#tabs-1" onclick="changeTab('itemCategoryViewCategory.do')">CATEGORY</a></li>
			<li><a id="tab3" href="#tabs-1" onclick="changeTab('itemCategoryViewType.do')">TYPE</a></li>
			<li><a id="tab4" href="#tabs-1" onclick="changeTab('itemCategoryViewTemplate.do')">TEMPLATE</a></li>
			<li><a id="tab5" href="#tabs-1" onclick="changeTab('itemCategoryViewList.do')">구매요청/비용성품목/BSI/GSI</a></li>
		</ul>
		<div id="tabs-1">
			<iframe id="teamIframe" name="teamIframe" 	src="" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width=100% style="border-width:0px;  border-color:white;"></iframe>
		</div>
	</div>
</div>
</body>
</html>