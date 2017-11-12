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
		<form id="application_form" name="application_form" onSubmit="return false;">
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="codeMaster" />
			<input type="hidden" id="p_find_main" name="p_find_main" value="MAIN" />
			<input type="hidden" id="p_sd_type" name="p_sd_type" value="${sd_type}" />
			<input type="hidden" id="p_catalog_code" name="p_catalog_code" value="${catalog_code}" />
			<input type="hidden" id="p_table_id" name="p_table_id" value="${table_id}" />
				<div class="button" style="margin-top:15px;">
					<input type="button" id="btncheck" value="확인" class="btn_blue"/>
					<input type="button" id="btnfind" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
			
			<div class="topMain" style="margin: 0px;line-height: 40px;">
				<div class="conSearch">
					 CODE <input type="text" id="p_code_find" name="p_code_find" value="${cmtype}" style="text-transform:uppercase;" class="w180h25" onchange="javascript:this.value=this.value.toUpperCase();" />&nbsp;
					 Description <input type="text" id="p_desc_find" name="p_desc_find" value="${cmtypedesc}" style="text-transform:uppercase;" class="w180h25" onchange="javascript:this.value=this.value.toUpperCase();" />
				</div>
			</div>
			<div class="content">
				<table id="codeMasterPopUp"></table>
			</div>
		</form>
		<script type="text/javascript">
		var row_selected;

		$(document).ready( function() {
			$( "#codeMasterPopUp" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : '${cmd}',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ 'CODE', 'Description','','','','','' ],
				colModel : [ { name : 'sd_code', index : 'sd_code', width : 125, editable : true, sortable : false, editrules : { required : true }, editoptions : { size : 5 } }, 
				             { name : 'sd_desc', index : 'sd_desc', width : 150, editable : true, sortable : false, editoptions : { size : 11 } },
				             { name : 'attribute1', index : 'attribute1', width : 50, hidden:true },
				             { name : 'attribute2', index : 'attribute2', width : 50, hidden:true },
				             { name : 'attribute3', index : 'attribute3', width : 50, hidden:true },
				             { name : 'attribute4', index : 'attribute4', width : 50, hidden:true },
				             { name : 'attribute5', index : 'attribute5', width : 50, hidden:true }],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				rowNum : -1,
				height : 350,
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
					var sd_code = rowData['sd_code'];
					var sd_desc = rowData['sd_desc'];
					
					var attribute1 = rowData['attribute1'];
					var attribute2 = rowData['attribute2'];
					var attribute3 = rowData['attribute3'];
					var attribute4 = rowData['attribute4'];
					var attribute5 = rowData['attribute5'];

					var returnValue = new Array();
					returnValue[0] = sd_code;
					returnValue[1] = sd_desc;
					
					returnValue[2] = attribute1;
					returnValue[3] = attribute2;
					returnValue[4] = attribute3;
					returnValue[5] = attribute4;
					returnValue[6] = attribute5;
					
					window.returnValue = returnValue;
					self.close();
				},
				loadComplete : function(data) {
					/*var allRowsInGrid = $('#codeMasterPopUp').jqGrid('getRowData');
					var ids = jQuery("#codeMasterPopUp").jqGrid('getDataIDs');
					 if(allRowsInGrid.length==1){
					   var rowId = ids[0];
					   var rowData = jQuery('#codeMasterPopUp').jqGrid ('getRowData', rowId);
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
				var sUrl = "${cmd}";
				jQuery( "#codeMasterPopUp" ).jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
			});

			$( '#btncheck' ).click( function() {
				var ret = jQuery( "#codeMasterPopUp" ).getRowData( row_selected );
				if ( ret.sd_code == null ) {
					alert( 'Please row select' );
					return;
				}
				
				var returnValue = new Array();
				returnValue[0] = ret.sd_code;
				returnValue[1] = ret.sd_desc;
				window.returnValue = returnValue;

				self.close();
			} );
		} );

		$( "#p_code_find" ).keydown( function( e ) {
			if ( e.which == 13 ) {
				var sUrl = "${cmd}";
				jQuery( "#codeMasterPopUp" ).jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
				return false;
			}
		} );
		</script>
	</body>
</html>
