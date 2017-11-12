<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PartFamilyInfo</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="partFamilyCode_form" name="partFamilyCode_form" onSubmit="return false;">
		<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
		<input type="hidden" id="txtCodeGbn" name="p_code_gbn" value="partfamily" />

		
		
		<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform: uppercase;" class="w200h25" onchange="javascript:this.value=this.value.toUpperCase();" />
				<input type="text" style="display: none;" /> <!-- text가 페이지에 한개만 있으면 엔터키를 누를때 자동 submit 이 되므로 이를 방지하기 위해 한개 더 생성 -->
			</div>
			<div class="button">
				<input type="button" id="btncheck" value="확인" class="btn_blue"/>
				<input type="button" id="btnfind" value="조회" class="btn_blue" />
				<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
			</div>
		</div>
		<div class="content">
			<table id="partFamilyList"></table>
		</div>
		
		
		
		
		
		
		
		
<!-- 		<div> -->
<!-- 			찾기 <input type="text" id="txtCodeFind" name="p_code_find" style="width: 350px;" /> -->
<!-- 		</div> -->
<!-- 		<div style="margin-top: 10px;"> -->
<!-- 			<table id="partFamilyList" style="width: 100%; height: 50%"></table> -->
<!-- 		</div> -->
<!-- 		<div style="margin-top: 10px;"> -->
<!-- 			<input type="button" id="btnfind" value="찾기" /> -->
<!-- 			<input type="button" id="btncheck" value="확인" /> -->
<!-- 			<input type="button" id="btncancle" value="취소" /> -->
<!-- 		</div> -->
	</form>
	<script type="text/javascript">
		var row_selected;

		$(document).ready(
				function() {

					$("input[name=p_code_find]").val(
							window.dialogArguments["p_code_find"]);

					$("#partFamilyList").jqGrid({
						datatype : 'json',
						mtype : 'POST',
						url : 'infoPartFamilyCode.do',
						postData : $("#partFamilyCode_form").serialize(),
						editUrl : 'clientArray',
						colNames : [ 'Part_Family_Code', 'Part_Family_Desc' ],
						colModel : [ {
							name : 'part_family_code',
							index : 'part_family_code',
							width : 125,
							sortable : false,
							editoptions : {
								size : 5
							}
						}, {
							name : 'part_family_desc',
							index : 'part_family_desc',
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
						height : 320,
						rowNum : 999999,
						// pager: jQuery('#pcodeMasterList'),
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
							var part_family_code = rowData['part_family_code'];
							var part_family_desc = rowData['part_family_desc'];

							var returnValue = new Array();
							returnValue[0] = part_family_code;
							returnValue[1] = part_family_desc;
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

						var sUrl = "infoPartFamilyCode.do";
						jQuery("#partFamilyList").jqGrid('setGridParam', {
							url : sUrl,
							page : 1,
							postData : $("#partFamilyCode_form").serialize()
						}).trigger("reloadGrid");
					});

					$('#btncheck').click(
							function() {

								var ret = jQuery("#partFamilyList").getRowData(
										row_selected);
								var returnValue = new Array();
								returnValue[0] = ret.part_family_code;
								returnValue[1] = ret.part_family_desc;

								window.returnValue = returnValue;

								self.close();
							});

				});
	</script>
</body>
</html>
