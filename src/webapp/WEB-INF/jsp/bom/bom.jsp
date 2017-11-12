<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>Block Search</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	<body>
		<div id="mainDiv" class="mainDiv">

			<form id="application_form" name="application_form">
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<input type="hidden" id="p_admin_yn" name="p_admin_yn" value="N"/>
				<div class="subtitle">Block Search
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
					
					
					<table class="searchArea conSearch">	
					<%-- <col width="60">
					<col width="140"> --%>
					<col width="80">
					<col width="140">
					<col width="80">
					<col width="200">
					<col width="80">
					<col width="90">
					<col width="80">
					<col width="50">
					<col width="*">


					<tr>
						<!-- <th>대표호선</th>
						<td>
							<input type="text" id="p_delegate_project_no" name="p_delegate_project_no"  maxlength="10" class="required" style="width: 80px;" />
							<input type="button" id="btn_delegate_project_no" name="btn_delegate_project_no" class="btn_gray2" value="검색" />
						</td> -->


						<th>PROJECT</th>
						<td>
							<input type="text" id="p_project_no" name="p_project_no" class="required" style="width: 80px;" onblur="javascript:getDwgNos();" />
							<!-- <input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" /> -->
<!-- 						<select id="p_project_no" name="p_project_no" class="required wid200" style="text-transform:uppercase;"> -->
<!-- 						<option value=''>선택</option>	 -->
<!-- 						</select> -->
						</td>
						<th>ITEM CODE</th>
						<td>
							<input type="text" class="wid180" id="p_item_code" name="p_item_code" style="width: 120px;text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();"/>
							<input type="button" id="btn_item_code" name="btn_item_code" class="btn_gray2" value="검색" />
						</td>
						<th>LEVEL</th>
						<td>
						<select id="p_level" name="p_level">
 						<option value=''>선택</option>
 						<option value='1' selected="selected">1LV</option>
 						<option value='2'>2LV</option>
 						<option value='3'>3LV</option>
 						<option value='4'>4LV</option>
 						<!-- <option value='5'>5LV</option>
 						<option value='6'>6LV</option>
 						<option value='7'>7LV</option>
 						<option value='8'>8LV</option>
 						<option value='9'>9LV</option> -->
 						</select>
						</td>
						<th>ADMIN</th>
						<td style="border-right:none;">
							<input type="checkbox" id="p_admin_check" name="p_admin_check" onchange="javascript:fn_admin_chk();">
						</td>
						
						<td style="border-left:none;">
						<div class="button endbox">
							<c:if test="${userRole.attribute1 == 'Y'}"> 
							<input type="button" class="btn_blue" id="btnSelect" name="" value="조회" />
							</c:if>
							<c:if test="${userRole.attribute5 == 'Y'}">
							<input type="button" class="btn_blue" id="btnExcelDownLoad" name="" value="Report" />
							</c:if>
						</div>
						</td>
					</tr>
					</table>
				<div class="series"> 
					<table class="searchArea">
						<tr>
							<td>
								<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
							</td>
						</tr>
					</table>
				</div>
				<div class="content">
					<table id="bomList"></table>
					<div id="pbomList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow = 0;
		var idCol = 0;
		var kRow = 0;

		$(document).ready( function() {
			$(".series").prop("disabled", true);
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
// 			fn_selDelegateProjectNosearch();
			//엔터 버튼 클릭
			$(":text").keypress(function(event) {
		  		if (event.which == 13) {
		        event.preventDefault();
		        $('#btnSelect').click();
		    	}
			});
		
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			
			var is_hidden = true;
			
			$( "#bomList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url:'',
				postData : fn_getFormData("#application_form"),
				colNames : [ '', 'LV', '1 LV', '2 LV', '3 LV', '4 LV', '5 LV', '6 LV', '7 LV', '8 LV', '9 LV',
				             'ITEM_CODE', 'Description', 'UOM', 'FINDNUMBER', 'Catalog', '도면NO', 'QTY', 'Creator', 'ECO NO', 
				             'BOM1', 'BOM2', 'BOM3', 'BOM4', 'BOM5', 'BOM6', 'BOM7', 'BOM8', 'BOM9', 'BOM10', 'BOM11', 'BOM12', 'BOM13', 'BOM14', 'BOM15' ],
				colModel : [ { name : 'mother_code', index : 'mother_code', width : 80, align : "left", hidden : is_hidden },
				             { name : 'level_no', index : 'level_no', width : 80, align : "left", hidden : is_hidden }, 
				             { name : 'level_1', index : 'level_1', width : 90, align : "center" }, 
				             { name : 'level_2', index : 'level_2', width : 90, align : "center" }, 
				             { name : 'level_3', index : 'level_3', width : 90, align : "center" }, 
				             { name : 'level_4', index : 'level_4', width : 90, align : "center" }, 
				             { name : 'level_5', index : 'level_5', width : 80, align : "center", hidden : is_hidden }, 
				             { name : 'level_6', index : 'level_6', width : 80, align : "center", hidden : is_hidden }, 
				             { name : 'level_7', index : 'level_7', width : 80, align : "center", hidden : is_hidden }, 
				             { name : 'level_8', index : 'level_8', width : 80, align : "center", hidden : is_hidden }, 
				             { name : 'level_9', index : 'level_9', width : 80, align : "center", hidden : is_hidden }, 
				             { name : 'item_code', index : 'item_code', width : 80, align : "left", hidden : is_hidden }, 
				             { name : 'item_desc', index : 'item_desc', width : 200, align : "left" }, 
				             { name : 'item_uom_code', index : 'item_uom_code', width : 35, align : "center" }, 
				             { name : 'findnumber', index : 'findnumber', width : 40, align : "left", hidden : is_hidden }, 
				             { name : 'item_catalog', index : 'item_catalog', width : 45, align : "center" }, 
				             { name : 'dwg_no', index : 'dwg_no', width : 70, align : "center" }, 
				             { name : 'bom_qty', index : 'bom_qty', width : 40, align : "right" }, 
				             { name : 'emp_no', index : 'emp_no', width : 50, align : "center" }, 
				             { name : 'eco_no', index : 'eco_no', width : 70, align : "center", classes : "handcursor" }, 
				             { name : 'bom1', index : 'bom1', width : 40, align : "left" }, 
				             { name : 'bom2', index : 'bom2', width : 40, align : "left" }, 
				             { name : 'bom3', index : 'bom3', width : 40, align : "left" }, 
				             { name : 'bom4', index : 'bom4', width : 40, align : "left" }, 
				             { name : 'bom5', index : 'bom5', width : 40, align : "left" }, 
				             { name : 'bom6', index : 'bom6', width : 40, align : "left" }, 
				             { name : 'bom7', index : 'bom7', width : 40, align : "left" }, 
				             { name : 'bom8', index : 'bom8', width : 40, align : "left" }, 
				             { name : 'bom9', index : 'bom9', width : 40, align : "left" }, 
				             { name : 'bom10', index : 'bom10', width : 40, align : "left" }, 
				             { name : 'bom11', index : 'bom11', width : 40, align : "left" }, 
				             { name : 'bom12', index : 'bom12', width : 40, align : "left" }, 
				             { name : 'bom13', index : 'bom13', width : 40, align : "left" }, 
				             { name : 'bom14', index : 'bom14', width : 40, align : "left" }, 
				             { name : 'bom15', index : 'bom15', width : 40, align : "left" } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "",
				autowidth : true, //autowidth: true,
				height : objectHeight,
				shrinkToFit : true,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#pbomList'),
				rowList: [100,500,1000],
	            rowNum: 100, 
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				jsonReader : {
	                 root: "rows",
	                 page: "page",
	                 total: "total",
	                 records: "records",  
	                 repeatitems: false,
                }, 
				imgpath : 'themes/basic/images',
				onPaging: function(pgButton) {
					
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
			    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
			     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
			     	 */ 
//	 				$(this).jqGrid("clearGridData");
			
			    	/* this is to make the grid to fetch data from server on page click*/
//	 	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");
	            	var pageIndex         = parseInt($(".ui-pg-input").val());
	 	   			var currentPageIndex  = parseInt($("#bomList").getGridParam("page"));// 페이지 인덱스
	 	   			var lastPageX         = parseInt($("#bomList").getGridParam("lastpage"));  
	 	   			var pages = 1;
	 	   			var rowNum 			  = 100;

	 	   			/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
	 	   			* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
	 	   			* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
	 	   			*/ 
	 	   			/* this is to make the grid to fetch data from server on page click*/
	 	   			if (pgButton == "user") {
	 	   				if (pageIndex > lastPageX) {
	 	   			    	pages = lastPageX
	 	   			    } else pages = pageIndex;
	 	   				
	 	   				rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'next_pbomList'){
	 	   				pages = currentPageIndex+1;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			} 
	 	   			else if(pgButton == 'last_pbomList'){
	 	   				pages = lastPageX;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'prev_pbomList'){
	 	   				pages = currentPageIndex-1;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'first_pbomList'){
	 	   				pages = 1;
	 	   				rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
		 	   		else if(pgButton == 'records') {
		   				rowNum = $('.ui-pg-selbox option:selected').val();                
		   			}
	 	   			//$(this).jqGrid("clearGridData");
	 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");  

				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					var cm = $( "#bomList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $("#bomList").jqGrid( "getRowData", rowid );
					
					if ( colName['index'] == "eco_no" ) {
		              	var ecoName = item.eco_no;
		              	
		              	if( ecoName != "" && ecoName != "W" ) {
							var sUrl = "./eco.do?ecoName=" + ecoName+"&popupDiv=Y&checkPopup=Y&menu_id=${menu_id}";
							window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:650px; center:on; scroll:off; status:off");
		              	}
					}
					/* if ( colName['index'].indexOf("level_") == 0 ) {
						var data = $( "#bomList" ).getCell( rowid, colName['index'] );
						if(data != '') {
							var arg = "&mother_code="+item.mother_code+"&item_code="+item.item_code+"&project_no="+$( "#p_project_no").val();
							var rs = window.open("bomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
							"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
						}
					} */
				},
				ondblClickRow : function(rowid, cellname, value, iRow, iCol) {
					var cm = $( "#bomList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[value];
					
					var item = $("#bomList").jqGrid( "getRowData", rowid );
					
					if ( colName['index'].indexOf("level_") == 0 ) {
						var data = $( "#bomList" ).getCell( rowid, colName['index'] );
						if(data != '') {
							var arg = "&mother_code="+item.mother_code+"&item_code="+item.item_code+"&project_no="+$( "#p_project_no").val();
							/* var rs = window.open("bomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
							"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	 */
							var popupWin = window.open("sscBomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
							"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");
							
							setTimeout(function(){
								popupWin.focus();
							 }, 500);
							
						}
					}
				},
				gridComplete : function() {
					//미입력 영역 회색 표시
					$( "#bomList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
				}
			} );

			//grid resize
			fn_gridresize( $(window), $( "#bomList" ) );
			
			$( "#p_delegate_project_no" ).change( function () {
				$( "#p_project_no" ).val( "" );
			} );
			
			$( "#btn_delegate_project_no" ).click( function () {
				
				var rs;
				
				var sURL = "popUpSearchItem.do?p_project_no=" + $('#p_project_no').val();
				var popOptions = "width=750, height=700, resizable=yes, scrollbars=no, status=no";

				var popupWin = window.open(sURL, "popUpSearchItem", popOptions);

				setTimeout(function() {
					rs = popupWin.focus();
				}, 500);
				
				/* var rs = window.showModalDialog( "popUpDelegateProjectNo.do",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_delegate_project_no" ).val( rs[0] );
					$( "#p_project_no" ).val( "" );
				} */
			} );
			
			$( "#btn_item_code" ).click( function () {
				if( $( "#p_project_no" ).val() == "" ) {
					alert( "PROJECT 입력 후 조회해주세요." );
					$( "#p_project_no" ).focus();
					return;
				}
				
				
				var rs;
				var sURL = "popUpItem.do?p_project_no=" + $('#p_project_no').val() + "&p_item_code=" + $('#p_item_code').val();
				var popOptions = "width=750, height=700, resizable=yes, scrollbars=no, status=no";

				var popupWin = window.open(sURL, "popUpItem", popOptions);
				setTimeout(function() {
					rs = popupWin.focus();
				}, 500);
				
				/* var rs = window.showModalDialog( "popUpProjectNo.do",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_project_no" ).val( rs[0] );
				} */
			} );
			
			
			//조회 버튼
			$( "#btnSelect" ).click( function() {
				if ( !fn_require_chk() ) {
					return;
				}
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				fn_search();
			});
			
			$( "#btnExcelDownLoad" ).click( function() {
				if( !fn_require_chk() ) {
					return;
				}
					
				
				var p_project_no = $("#p_project_no").val();
				var p_item_code = $("#p_item_code").val();
				var p_level = $("#p_level option:selected").val();
				
				var param = p_project_no + ":::" + p_level + ":::" + p_item_code;

				
				fn_PopupReportCall( "STXDIS002.mrd", param );
				
				/* var sUrl = "bomExcelExport.do";
				var f = document.application_form;

				f.action = sUrl;
				f.method = "post";
				f.submit(); */
			} );

		} ); //end of ready Function 

		function fn_admin_chk() {
			if ($("#p_admin_check").is(":checked")) {
			    $("#p_admin_yn").val("Y");
			} else {
				$("#p_admin_yn").val("N");
			}
		}
		
		function fn_require_chk() {
			var result = true;
			var message = "";

			var item_code = $( "#p_item_code" ).val();
			var project_no = $( "#p_project_no" ).val();
			
			if( project_no == '' ) {
				result = false;
				message = "PROJECT는 필수입력입니다.";
			}

			/* if( item_code == '' ) {
				result = false;
				message = "ITEM_CODE는 필수입력입니다.";
			} */
			
			if( !result ) {
				alert( message );
			} else {
				result = confirm("데이터의 양이 많은 경우 로딩이 느려질수 있습니다.\n계속하시겠습니까?");
			}

			return result;
		}
		
		function fn_search() {
			var sUrl = "bomList.do";

			$( "#bomList" ).jqGrid( "clearGridData" );
			$( "#bomList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		var getDwgNos = function(){
			if($("input[name=p_project_no]").val() != ""){
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			}
		}
		</script>
	</body>
</html>
