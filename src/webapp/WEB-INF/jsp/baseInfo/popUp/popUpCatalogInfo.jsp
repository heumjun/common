<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>CatalogInfo</title>
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="catalogCode_form" name="catalogCode_form">
			<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="catalog" />
			<input type="hidden" id="p_desc_find" name="p_desc_find" />
			<input type="hidden" id="part_family_code" name="part_family_code" />
			<input type="hidden" id="inv_category_id" name="inv_category_id" />
			
			
			<div class="topMain" style="margin: 0px;line-height: 25px;">
				<div class="conSearch">
					ITEM TYPE : <input type="text" id="part_family_desc" name="part_family_desc" value="" style="text-transform:uppercase;"  class="wid100" onchange="javascript:this.value=this.value.toUpperCase(); fn_changedPartFamilyDesc(this);" />
					<input type="button" value="검색" id="btnPartFamilyType" class="btn_gray2"/>
					CATEGORY : <input type="text" id="inv_category_desc" name="inv_category_desc" value="" style="text-transform:uppercase;"  class="w100h25" onchange="javascript:this.value=this.value.toUpperCase(); fn_changedInvCategoryDesc(this);" />
					<input type="button" value="검색" id="btnInvCategory" class="btn_gray2" />
					
				</div>
				<div class="button">
					<input type="button" id="btncheck" value="확인" class="btn_blue"/>
					<input type="button" id="btnfind" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
				<br />
				<div class="conSearch">
				<select name="p_search_type" id="p_search_type" >
					<option value="cata_code" selected="selected">CATA CODE</option>
					<option value="cata_desc" >CATA DESC</option>
				</select>
				<input type="text" id="p_code_find" name="p_code_find" value="${cmtype}" style="width:310px; text-transform:uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();" />
				</div>
			</div>
			
			<div class="content">
				<table id="catalogCodeList"></table>
				<div id="pcatalogCodeList"></div>
			</div>
			
			
			
			
			
			
<!-- 			<div> -->
<!-- 				찾기 <input type="text" id="p_code_find" name="p_code_find" -->
<!-- 					style="width: 350px;" /> <input type="hidden" id="p_desc_find" -->
<!-- 					name="p_desc_find" /> -->
<!-- 			</div> -->
<!-- 			<div style="margin-top: 10px;"> -->
<!-- 				<table id="catalogCodeList" style="width: 100%; height: 50%"></table> -->
<!-- 				<div id="pcatalogCodeList"></div> -->
<!-- 			</div> -->
<!-- 			<div style="margin-top: 10px;"> -->
<!-- 				<input type="button" id="btnfind" value="찾기" /> <input type="button" -->
<!-- 					id="btncheck" value="확인" /> <input type="button" id="btncancle" -->
<!-- 					value="취소" /> -->
<!-- 			</div> -->
		</form>
		<script type="text/javascript">
		var row_selected;

		$(document).ready(function() {
			//엔터 버튼 클릭
			$("*").keypress(function(event) {
			  if (event.which == 13) {
			        event.preventDefault();
			        $('#btnfind').click();
			    }
			});

			$("input[name=p_code_find]").val(
					window.dialogArguments["p_code_find"]);
			
			$("input[name=inv_category_id]").val(
					window.dialogArguments["inv_category_id"]);
			
			$("input[name=part_family_desc]").val(
					window.dialogArguments["part_family_desc"]);
			
			$("input[name=part_family_code]").val(
					window.dialogArguments["part_family_code"]);
			
			$("input[name=inv_category_desc]").val(
					window.dialogArguments["inv_category_desc"]);
			
			$("#catalogCodeList").jqGrid({
				datatype : 'json',
				mtype : 'POST',
				url : 'infoCatalogCode.do',
				postData : getFormData("#catalogCode_form"),
				editUrl : 'clientArray',
				colNames : [ 'Catalog_Code', 'Catalog_Desc' ],
				colModel : [ {
					name : 'catalog_code',
					index : 'catalog_code',
					width : 80,
					editable : true,
					sortable : false,
					editrules : {
						required : true
					},
					editoptions : {
						size : 5
					}
				}, {
					name : 'catalog_desc',
					index : 'catalog_desc',
					width : 190,
					editable : true,
					sortable : false,
					editoptions : {
						size : 11
					}
				}, ],
				gridview : true,
				viewrecords: true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				//viewrecords: true,
				autowidth : true,
				height : 355,
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				recordtext: '전체 {2}',
	        	emptyrecords:'조회 내역 없음',
				pager : jQuery('#pcatalogCodeList'),
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
					var catalog_code = rowData['catalog_code'];
					var catalog_desc = rowData['catalog_desc'];

					var returnValue = new Array();
					returnValue[0] = catalog_code;
					returnValue[1] = catalog_desc;
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
				var sUrl = "infoCatalogCode.do";
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				jQuery("#catalogCodeList").jqGrid('setGridParam', {
					url : sUrl,
					page : 1,
					postData : getFormData("#catalogCode_form")
				}).trigger("reloadGrid");
			});

			$('#btncheck').click(function() {
				var ret = jQuery("#catalogCodeList")
						.getRowData(row_selected);

				var returnValue = new Array();
				returnValue[0] = ret.catalog_code;
				returnValue[1] = ret.catalog_desc;
				window.returnValue = returnValue;

				self.close();
			});
			
			// PartFamilyType 버튼 클릭이벤트
			$("#btnPartFamilyType").click(function() {
				fn_searchPartFamilyType();
			});
			
			// InvCategory 버튼 클릭이벤트
			$("#btnInvCategory").click(function() {
				fn_searchInvCategory();
			});
					
					
		});
		
		// Part Family Type 조회
		function fn_searchPartFamilyType() {

			var rs = window.showModalDialog("popUpPartFamilyDesc.do", "", "dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				if ($("input[name=part_family_code]").val() != rs[0])
					//fn_clearParam(5);

				$("input[name=part_family_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=part_family_desc]").val(rs[1] == "" ? null : rs[1]);
			}
		}
		
		// Inv Categroy Type 조회
		function fn_searchInvCategory() {

			var args = new Array();
			args["part_family_code"] = $("input[name=part_family_code]").val();

			var rs = window.showModalDialog(
							"popUpInvCategory.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				
				$("input[name=inv_category_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=inv_category_desc]").val(rs[1] == "" ? null : rs[1]);
				$("input[name=inv_category_id]").val(rs[2] == "" ? null : rs[2]);

				var parameters = {
					category_id : $("input[name=inv_category_id]").val()
				};
				var url = 'selectCostCategoryFromInvCategory.do';

				//트리 컨트롤 데이터 : Jquery는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
				$.post(url, parameters, function(data) {

					var obj = jQuery.parseJSON(data);

					if (obj.length > 0) {
						$("input[name=cost_category_code]").val(obj[0].cost_category_code);
						$("input[name=cost_category_desc]").val(obj[0].cost_category_desc);
						$("input[name=cost_category_id]").val(obj[0].cost_category_id);
					} else {
						$("input[name=cost_category_code]").val("");
						$("input[name=cost_category_desc]").val("");
						$("input[name=cost_category_id]").val("");
					}
				});
			}
		}
		
		// Inv Category가 변경된 경우 출되는 함수
		function fn_changedInvCategoryDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(3);
			//}
		}
		
		// partFamily Desc가 변경된 경우 출되는 함수
		function fn_changedPartFamilyDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(5);
			//}
		}
		
		// 대문자로 변환
		function onlyUpperCase(obj) {
			obj.value = obj.value.toUpperCase();
		}

		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}
		
		
		// 조회조건이 변경된 경우 초기화하는 함수
		function fn_clearParam(nGbn) {
			if (nGbn > 0) {
				$("input[name=catalog_desc]").val("");
			}

			if (nGbn > 1) {
				$("input[name=catalog_code]").val("");
			}

			if (nGbn > 2) {
				$("input[name=inv_category_id]").val("");
				$("input[name=inv_category_code]").val("");
			}

			if (nGbn > 3) {
				$("input[name=inv_category_desc]").val("");

				$("input[name=cost_category_id]").val("");
				$("input[name=cost_category_code]").val("");

			}

			if (nGbn > 4) {
				$("input[name=cost_category_desc]").val("");
				$("input[name=part_family_code]").val("");
				//$("input[name=part_family_desc]").val("");
			}
			
			if (nGbn > 5) {
				$("input[name=part_family_desc]").val("");
			}
			
			$("input[name=unit_of_measure]").val("");
			$("input[name=uom_code]").val("");
		}
		
		</script>
	</body>
</html>
