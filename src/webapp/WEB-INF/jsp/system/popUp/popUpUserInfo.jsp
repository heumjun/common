<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Code Search</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form" onkeypress="if (event.keyCode==13) fn_search();" onsubmit="return false;">
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" name="sType" id="sType" value="userList" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="isPaging" name="isPaging" value="N" />

				<div class="button" style="margin-top:15px;">
					<input type="button" id="btncheck" value="확인" class="btn_blue"/>
					<input type="button" id="btnfind" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
			
			<div class="topMain" style="margin: 0px;line-height: 45px;">
				<div class="conSearch">
					 <input type="text" id="p_name" name="p_name" value="${p_name}" style="text-transform:uppercase;" class="w200h25" onchange="javascript:this.value=this.value.toUpperCase();" />
				</div>
			</div>
			<div class="content">
				<table id="dataList"></table>
			</div>
		</form>
		<script type="text/javascript">
		var row_selected;

		$(document).ready( function() {
			$("input[name=p_name]").val(window.dialogArguments["p_name"]);
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#dataList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ '사번', '이름', '직급', '부서명', '전화번호', '휴대전화', 'E-Mail', '담당업무' ],
				colModel : [ { name : 'emp_no', index : 'emp_no', width : 25, hidden : true },
				             { name : 'name', index : 'name', width : 80, hidden : false, align : "center" }, 
				             { name : 'position_name', index : 'position_name', width : 80, hidden : false, align : "center" },
				             { name : 'dept_name', index : 'dept_name', width : 150, hidden : false, align : "center" },
				             { name : 'tel_no', index : 'tel_no', width : 150, hidden : true },
				             { name : 'cel_no', index : 'cel_no', width : 150, hidden : true },
				             { name : 'ep_mail', index : 'ep_mail', width : 150, hidden : true },
				             { name : 'jik_nam', index : 'jik_nam', width : 150, hidden : true }
				           ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				rowNum : -1,
				height : objectHeight,
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
					var emp_no = rowData['emp_no'];
					var name = rowData['name'];
					var tel_no = rowData['tel_no'];
					var cel_no = rowData['cel_no'];
					var ep_mail = rowData['ep_mail'];
					var jik_nam = rowData['jik_nam'];
					var position_name = rowData['position_name'];
					var dept_name = rowData['dept_name'];

					var returnValue = new Array();
					returnValue[0] = emp_no;
					returnValue[1] = name;
					returnValue[2] = tel_no;
					returnValue[3] = cel_no;
					returnValue[4] = ep_mail;
					returnValue[5] = jik_nam;
					returnValue[6] = position_name;
					returnValue[7] = dept_name;
					window.returnValue = returnValue;
					self.close();
				},
				loadComplete : function(data) {
					/*var allRowsInGrid = $('#dataList').jqGrid('getRowData');
					var ids = jQuery("#dataList").jqGrid('getDataIDs');
					 if(allRowsInGrid.length==1){
					   var rowId = ids[0];
					   var rowData = jQuery('#dataList').jqGrid ('getRowData', rowId);
					   var sd_code = rowData['sd_code'];
						var sd_desc = rowData['sd_desc'];
					
					var returnValue = new Array();
						returnValue[0] = sd_code;
						returnValue[1] = sd_desc;
						window.returnValue = returnValue;
						self.close();
					}
					 */
				},
				onSelectRow : function(row_id) {
					if (row_id != null) {
						row_selected = row_id;
					}
				}
			});

			$( '#btncancle' ).click( function() {
				self.close();
			} );

			$( '#btnfind' ).click( function() {
				fn_search();
			});

			$( '#btncheck' ).click( function() {
				var ret = jQuery( "#dataList" ).getRowData( row_selected );
				if ( ret.emp_no == null ) {
					alert( 'Please row select' );
					return;
				}
				
				var returnValue = new Array();
				returnValue[0] = ret.emp_no;
				returnValue[1] = ret.name;
				window.returnValue = returnValue;

				self.close();
			} );
		} );
		
		function fn_search(){
			var sUrl = "${cmd}";
			jQuery( "#dataList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				page : 1,
				postData : fn_getFormData( "#application_form" )
			}).trigger( "reloadGrid" );
		}
		</script>
	</body>
</html>
