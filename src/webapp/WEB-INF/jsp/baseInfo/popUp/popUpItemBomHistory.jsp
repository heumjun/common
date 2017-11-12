<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>itemBomHistory</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

	<div id="wrap" class="mainDiv">
		<div class="topMain" style="margin: 0px; line-height: 45px;">
<!-- 			<fieldset> -->
<!-- 				<legend>조회 조건</legend> -->
				<div class="conSearch">
					<span class="spanMargin"> <span class="pop_tit">Catalog</span> 
					<input type="text"	name="p_catalog_code" style="height:25px;" value=<c:out value="${sel_catalog_code}" />>
					</span>
				</div>

				<div class="conSearch">
					<span class="spanMargin"><span class="pop_tit">Attribute Type</span>
					<select	name="p_attribute_type" style="height:25px;">
							<option value="">ALL</option>
							<option value="ITEM">ITEM</option>
							<option value="BOM">BOM</option>
					</select>
					</span>
				</div>

				<div class="conSearch">
					<span class="spanMargin"><span class="pop_tit">Attribute Code</span> 
					<input type="text"	name="p_attribute_code"  style="height:25px;"/>
					</span>
				</div>

				<div class="button">
					<input type="button" value="조회" id="btnSearch" class="btn_blue"/>
					<input type="button" value="닫기" id="btnClose" class="btn_blue"/>
				</div>

<!-- 			</fieldset> -->
		</div>
<!-- 		<div class="topMain"> -->
<!-- 			<fieldset style="height: 720px;"> -->
<!-- 				<legend>Item/Bom History 정보</legend> -->
				<div class="content">
<!-- 					<div style="margin: 0px 5px 0px 5px"> -->
						<table id="itemBomHistory"></table>
						<div id="pitemBomHistory"></div>
					</div>
<!-- 				</div> -->
<!-- 			</fieldset> -->
<!-- 		</div> -->
	</div>
	<script type="text/javascript">
		$(document).ready(
				function() {

					$("#itemBomHistory").jqGrid(
							{
								datatype : 'json',
								mtype : 'POST',
								url : 'infoItemBomHistory.do',
								postData : {
									gbn : 2,
									p_catalog_code : $(
											"input[name=p_catalog_code]").val()
								},
								colNames : [ 'Rev', 'Action', '변경날짜', '사번',
										'작업자', 'Catalog', 'Attribute Type',
										'물성치', '항목', 'Data Type', 'Min', 'Max',
										'상위물성치', 'Value', '채번코드', '상위코드',
										'사용유무' ],
								colModel : [ {
									name : 'revision_no',
									index : 'revision_no',
									width : 50
								}, {
									name : 'process_action',
									index : 'process_action',
									width : 80
								}, {
									name : 'last_update_date',
									index : 'last_update_date',
									width : 80
								}, {
									name : 'last_updated_by',
									index : 'last_updated_by',
									width : 60
								}, {
									name : 'last_update_by_name',
									index : 'last_update_by_name',
									width : 140
								}, {
									name : 'catalog_code',
									index : 'catalog_code',
									width : 60
								}, {
									name : 'attribute_type',
									index : 'attribute_type',
									width : 60
								}, {
									name : 'attribute_code',
									index : 'attribute_code',
									width : 50
								}, {
									name : 'attribute_name',
									index : 'attribute_name',
									width : 140
								}, {
									name : 'attribute_data_type',
									index : 'attribute_data_type',
									width : 50
								}, {
									name : 'attribute_data_min',
									index : 'attribute_data_min',
									width : 40
								}, {
									name : 'attribute_data_max',
									index : 'attribute_data_max',
									width : 40
								}, {
									name : 'assy_attribute_code',
									index : 'assy_attribute_code',
									width : 55
								}, {
									name : 'value_code',
									index : 'value_code',
									width : 140
								}, {
									name : 'item_make_value',
									index : 'item_make_value',
									width : 80
								}, {
									name : 'assy_value_code',
									index : 'assy_value_code',
									width : 80
								}, {
									name : 'enable_flag',
									index : 'enable_flag',
									width : 40,
									formatter : "checkbox"
								},

								],

								gridview : true,
								cmTemplate: { title: false },
								toolbar : [ false, "bottom" ],
								sortname : 'revision_no',
								sortorder : "asc",
								viewrecords : true,
								autowidth : true,

								//altRows: false, 
								height : 650,
								pager : jQuery('#pitemBomHistory'),
								pgbuttons : false,
								pgtext : false,
								pginput : false,
								loadComplete : function() {

								},
								jsonReader : {
									root : "rows",
									page : "page",
									total : "total",
									records : "records",
									repeatitems : false,
								},
								imgpath : 'themes/basic/images'

							});

					$("#btnSearch").click(function() {
						fn_search();
					});
					$("#btnClose").click(function() {
						self.close();
					});
					

				});

		function fn_search() {
			jQuery("#itemBomHistory")
					.jqGrid(
							'setGridParam',
							{
								url : "infoItemBomHistory.do",
								page : 1,
								postData : {
									gbn : 2,
									p_catalog_code : $(
											"input[name=p_catalog_code]").val(),
									p_attribute_type : $(
											"select[name=p_attribute_type]")
											.val(),
									p_attribute_code : $(
											"input[name=p_attribute_code]")
											.val()
								}
							}).trigger("reloadGrid");
		}
	</script>
</body>
</html>