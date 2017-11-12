<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ECR - ECO Code Mapping : Select ECO Category</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap">
			<form id="application_form" name="application_form" onSubmit="return false;">
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="sType" name="sType" value="popupEcrEcoCodeMapping" />
				<%
				String statesCode = request.getParameter("statesCode") == null ? "" : String.valueOf( request.getParameter("statesCode") );
				%>
				<input type="hidden" id="statesCode" name="statesCode" value="<%=statesCode %>" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="topMain" style="margin: 0px; line-height: 45px;">
					<div class="button">
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" id="btncheck" value="저장"  class="btn_blue"/>
						</c:if>
						<input type="button" id="btncancle" value="닫기"  class="btn_blue" />
					</div>
				</div>
				<div class="content">
					<table id="ecrEcoCodeMappingPopUp"></table>
				</div>
			</form>
		</div>
		<script type="text/javascript">
			var row_selected;
			
			var resultData = [];
			var idRow = 0;
			var idCol = 0;
			var kRow = 0;
			
			var lodingBox;
			
			$(document).ready( function() {
				var prevCellVal = { cellId: undefined, value: undefined };
				var prevCellVal2 = { cellId: undefined, value: undefined };
				
				rowspaner = function (rowId, val, rawObject, cm, rdata) {
                    var result;

                    if (prevCellVal.value == val) {
                        result = ' style="display: none" rowspanid="' + prevCellVal.cellId + '"';
                    }
                    else {
                        var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                        result = ' rowspan="1" id="' + cellId + '"';
                        prevCellVal = { cellId: cellId, value: val };
                    }

                    return result;
                };
                
                rowspaner2 = function (rowId, val, rawObject, cm, rdata) {
                    var result;

                    if (prevCellVal2.value == val) {
                        result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
                    }
                    else {
                        var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                        result = ' rowspan="1" id="' + cellId + '"';
                        prevCellVal2 = { cellId: cellId, value: val };
                    }

                    return result;
                };
				
				$("#ecrEcoCodeMappingPopUp").jqGrid({
					datatype : 'json',
					mtype : 'POST',
					url : 'infoEcoCategoryList.do',
					postData : fn_getFormData( "#application_form" ),
					editUrl : 'clientArray',
					colNames : [ 'Name', 'Description', '선택', 'States_Code', 'Category of Change', 'oper','enable_flag_changed','statesCode' ],
					colModel : [
		            				{ name : 'states_type', index : 'states_type', 
		            					width : 30, align : 'center', editable : true, editrules : { required : true }, editoptions : { size : 5 }, cellattr: rowspaner },
		            				{ name : 'states_description', index : 'states_description', 
	            						width : 150, align : 'center', editable : true, editoptions : { size : 11 }, cellattr: rowspaner2 },
		            				{ name : 'enable_flag', index : 'enable_flag', 
            							width : 15, align : 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
		            				{ name : 'states_code', index : 'states_code', 
           								width : 15, align : 'center', hidden : true, editable : true, editoptions : { size : 11 } },
		            				{ name : 'states_var1', index : 'states_var1', 
      									width : 150, align : 'left', editable : true, editoptions : { size : 11 } },
     								{ name : 'oper', index : 'oper', 
     									width:25, hidden:true },
      								{ name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true },
     								{ name : 'statesCode', index : 'statesCode', width : 25, hidden : true }
	            				],
					gridview : true,
					cmTemplate: { title: false },
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					height : 580,
					rowNum:999,
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
					beforeEditCell : function( rowid, cellname, value, iRow, iCol) {
						idRow = rowid;
						idCol = iCol;
						kRow = iRow;
					},
					beforeSaveCell : chmResultEditEnd,
					imgpath : 'themes/basic/images',
					ondblClickRow : function(rowId) {
						var rowData = jQuery(this).getRowData(rowId);
						var sd_code = rowData['sd_code'];
						var sd_desc = rowData['sd_desc'];
	
						var returnValue = new Array();
						returnValue[0] = sd_code;
						returnValue[1] = sd_desc;
						window.returnValue = returnValue;
						self.close();
					},
					onSelectRow : function(row_id) {
						if (row_id != null) {
	
							row_selected = row_id;
						}
					},
					gridComplete: function () {
				        var grid = this;

				        $('td[rowspan="1"]', grid).each(function () {
				            var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;

				            if (spans > 1) {
				                $(this).attr('rowspan', spans);
				            }
				        });
				    },
					afterSubmitCell : function(res) { 
						
					}
				});
	
				$('#btncancle').click(function() {
					self.close();
				});
	
				/* 2015-11-27 황경호 삭제 */
				/* $('#btnfind').click(function() {
					var sUrl = "popUpCodeMaster.do";
					jQuery("#codeMasterPopUp").jqGrid('setGridParam', {
						url : sUrl,
						page : 1,
						postData : fn_getFormData( "#application_form" )
					}).trigger("reloadGrid");
				}); */

				//저장버튼
				$( "#btncheck" ).click( function() {
					
					$( '#ecrEcoCodeMappingPopUp' ).saveCell( kRow, idCol );
					var changedData = $( "#ecrEcoCodeMappingPopUp" ).jqGrid( 'getRowData' );
					
					// 변경된 체크 박스가 있는지 체크한다.
					for( var i = 1; i < changedData.length + 1; i++ ) {
						var item = $( '#ecrEcoCodeMappingPopUp' ).jqGrid( 'getRowData', i );
						
						if ( item.oper != 'I' && item.oper != 'U' ) {
							if ( item.enable_flag_changed != item.enable_flag ) {
								if( item.enable_flag =="Y") {
									item.oper = 'I';
									item.statesCode = <%=statesCode %>;
								} else {
									item.oper = 'D';	
									item.statesCode = <%=statesCode %>;
								}
								
							}
							
							if ( item.oper == 'I' || item.oper == 'D' ) {
								// apply the data which was entered.
								$('#ecrEcoCodeMappingPopUp').jqGrid( "setRowData", i, item );
							}
						}
					}
					if ( !fn_checkValidate() ) {
						return;
					}
					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						lodingBox = new ajaxLoader( $( '#wrap' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						chmResultRows = data;
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						var url = 'saveEcrBasedOn.do';
						var formData = fn_getFormData( "#application_form" );
						var parameters = $.extend( {}, dataList, formData );
						
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								window.returnValue = data.result;
							}
		 					self.close();
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
					    	lodingBox.remove();	
						} );
					} );
				} );
				
				
				$( "#btnselect" ).click( function() {
					fn_search();
				} );
				
				//afterSaveCell oper 값 지정
				function chmResultEditEnd( irow, cellName ) {
					var item = $('#ecrEcoCodeMappingPopUp').jqGrid( 'getRowData',irow );
					if ( item.oper != 'I' )
						item.oper = 'U';
					
					$('#ecrEcoCodeMappingPopUp').jqGrid( "setRowData", irow, item );
					$("input.editable,select.editable", this).attr( "editable", "0" );
				}
				 
			});
			//필수입력 체크
			function fn_checkValidate() {
				var result = true;
				var message = "";
				var nChangedCnt = 0;
				var ids = $( "#ecrEcoCodeMappingPopUp" ).jqGrid( 'getDataIDs' );

				for( var i = 0; i < ids.length; i++ ) {
					var oper = $( "#ecrEcoCodeMappingPopUp" ).jqGrid( 'getCell', ids[i], 'oper' );

					if( oper == 'I' || oper == 'D' ) {
						nChangedCnt++;
					}
				}

				if ( nChangedCnt == 0 ) {
					result = false;
					message = "변경된 내용이 없습니다.";
				}

				if ( !result ) {
					alert( message );
				}

				return result;
			}
			function getChangedChmResultData( callback ) {
				var changedData = $.grep( $("#ecrEcoCodeMappingPopUp").jqGrid( 'getRowData' ), function( obj ) {
					return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
				} );
				
				callback.apply( this, [ changedData.concat(resultData) ] );
			}
			
			function fn_search() {
				var sUrl = 'infoEcoCategoryList.do';
				$( "#ecrEcoCodeMappingPopUp" ).jqGrid( 'setGridParam', {
					url : sUrl,
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
			}
		</script>
	</body>
</html>
