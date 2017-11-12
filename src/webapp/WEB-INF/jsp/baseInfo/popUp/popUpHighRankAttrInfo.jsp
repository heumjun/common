<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상위 속성 리스트</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="application_form" name="application_form"  onSubmit="return false;">

		<input type="hidden" id="txtCodeGbn" name="p_code_gbn" value="highRankAttr" />
		<input type="hidden" id="txtCatalogCode" name="p_catalog_code" value="${catalog_code}" />
		<input type="hidden" id="txtAssyAttributeCode" name="p_assy_attribute_code" value="${assy_attribute_code}" />
		<input type="hidden" id="txtAttributeType" name="p_attribute_type" value="${attribute_type}" />
		<input type="hidden" id="isPaging" name="isPaging" value="N" />



		<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<input type="text" id="p_code_find" name="p_code_find" value="${cmtype}" style="text-transform: uppercase; width: 170px; height:25px;" onchange="javascript:this.value=this.value.toUpperCase();" />
			</div>
			<div class="button">
				<input type="button" id="btncheck" value="확인"  class="btn_blue"/>
				<input type="button" id="btnfind" value="조회"  class="btn_blue"/>
				<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
			</div>
		</div>
		<div class="content">
			<table id="codeMasterPopUp"></table>
		</div>









<!-- 		<div> -->
<!-- 			찾기 <input type="text" id="p_code_find" name="p_code_find" -->
<!-- 				style="width: 350px;" /> -->
<!-- 		</div> -->
<!-- 		<div style="margin-top: 10px;"> -->
<!-- 			<table id="codeMasterPopUp" style="width: 100%; height: 50%"></table> -->
<!-- 		</div> -->
<!-- 		<div style="margin-top: 10px;"> -->
<!-- 			<input type="button" id="btnfind" value="찾기" /> -->
<!-- 			<input type="button" id="btncheck" value="확인" /> -->
<!-- 			<input type="button" id="btncancle" value="취소" /> -->
<!-- 		</div> -->
	</form>
	<script type="text/javascript">
		var row_selected;

		$(document).ready(function() {
			$("#codeMasterPopUp").jqGrid({
				datatype : 'json',
				mtype : 'POST',
				url : 'infoHighRankAttrValue.do',
				postData : $("#application_form").serialize(),
				colNames : [ 'VALUE', '채번코드' ],
				colModel : [ {
					name : 'value_code',
					index : 'value_code',
					width : 125,
					sortable : false,
					editoptions : {
						size : 5
					}
				}, {
					name : 'item_make_value',
					index : 'item_make_value',
					width : 150,
					sortable : false,
					editoptions : {
						size : 11
					}
				}, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : 330,
				rowNum : 999999,
				//pager: jQuery('#pcodeMasterList'),
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function(rowId) {
					var rowData = jQuery(this).getRowData(rowId);
					var value_code = rowData['value_code'];
					var item_make_value = rowData['item_make_value'];

					var returnValue = new Array();
					returnValue[0] = value_code;
					returnValue[1] = item_make_value;
					window.returnValue = returnValue;
					self.close();
				},
				onSelectRow : function(row_id) {
					if (row_id != null) {

						row_selected = row_id;
					}
				}
			});

			$('#btncancle').click(function() {
				self.close();
			});

			$('#btnfind').click(function() {

				var sUrl = "infoHighRankAttrValue.do";
				jQuery("#codeMasterPopUp").jqGrid('setGridParam', {
					url : sUrl,
					page : 1,
					postData : $("#application_form").serialize()
				}).trigger("reloadGrid");
			});

			$('#btncheck').click(function() {
				var ret = jQuery("#codeMasterPopUp").getRowData(row_selected);

				var returnValue = new Array();
				returnValue[0] = ret.value_code;
				returnValue[1] = ret.item_make_value;
				window.returnValue = returnValue;

				self.close();
			});

		});
	</script>
</body>
</html>
