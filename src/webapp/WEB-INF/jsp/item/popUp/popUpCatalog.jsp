<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Catalog</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="listForm" name="listForm">
			<%
				String p_bomCheck = request.getParameter("p_bomCheck") == null ? "" : request.getParameter("p_bomCheck").toString();
			%>
			<input type="hidden" id="txtCodeGbn" name="p_code_gbn" value="itmCatalog" />
			<input type="hidden" id="part_family_code" name="part_family_code" />
			<input type="hidden" id="cost_category_code" name="cost_category_code" />
			<input type="hidden" id="inv_category_id" name="inv_category_id" />
			<input type="hidden" id="p_bomCheck" name="p_bomCheck" value="<%=p_bomCheck%>" />
			<div class="topMain" style="margin: 0px; line-height: 45px;">
				<div class="conSearch">
					<input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform: uppercase;" class="w200h25 mgt10" onchange="javascript:this.value=this.value.toUpperCase();" />
				</div>
				<div class="button">
					<input type="button" id="btncheck" value="확인" class="btn_blue" />
					<input type="button" id="btnfind" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
			</div>
			<div class="content">
				<table id="catalogList"></table>
				<div id="pcatalogList"></div>
			</div>
		</form>
		<script type="text/javascript">
		var row_selected;

		var part_family_code = window.dialogArguments["part_family_code"];
		var cost_category_code = window.dialogArguments["cost_category_code"];
		var inv_category_id = window.dialogArguments["inv_category_id"];

		$(document).ready(function() {
			fn_all_text_upper();

			$( "input[name=part_family_code]" ).val( part_family_code );
			$( "input[name=cost_category_code]" ).val( cost_category_code );
			$( "input[name=inv_category_id]" ).val( inv_category_id );
			$( "input[name=p_code_find]" ).val( part_family_code );

			$( "#catalogList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'popUpCatalogList.do',
				postData : fn_getFormData( "#listForm" ),
				editUrl : 'clientArray',
				colNames : [ 'Catalog_Code', 'Catalog_Desc' ],
				colModel : [ { name : 'catalog_code', index : 'catalog_code', width : 80, sortable : false }, 
				             { name : 'catalog_desc', index : 'catalog_desc', width : 200, sortable : false } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				autowidth : true,
				height : 340,
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				pager : jQuery( '#pcatalogList' ),
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowId ) {
					var rowData = jQuery(this).getRowData( rowId );

					var returnValue = new Array();
					returnValue[0] = rowData['catalog_code'];
					returnValue[1] = rowData['catalog_desc'];
					
					window.returnValue = returnValue;
					
					self.close();
				},
				onSelectRow : function(row_id) {
					if ( row_id != null ) {
						row_selected = row_id;
					}
				}
			} );

			$( '#btncancle' ).click( function() {
				self.close();
			} );

			$( '#btnfind' ).click( function() {
				var sUrl = "popUpCatalogList.do";
				jQuery( "#catalogList" ).jqGrid( 'setGridParam', {
					mtype : 'POST',
					url : sUrl,
					page : 1,
					postData : fn_getFormData( "#listForm" )
				} ).trigger( "reloadGrid" );
			} );

			$( '#btncheck' ).click(function() {
				var ret = jQuery( "#catalogList" ).getRowData( row_selected );

				var returnValue = new Array();
				returnValue[0] = ret.catalog_code;
				returnValue[1] = ret.catalog_desc;

				window.returnValue = returnValue;

				self.close();
			} );
		} );
		</script>
	</body>
</html>
