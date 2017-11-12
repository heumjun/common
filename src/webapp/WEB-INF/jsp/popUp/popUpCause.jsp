<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
		<title>ECR - ECO Code Mapping : Select ECO Category</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
		    <input type="hidden" id="eco_author_yn" name="eco_author_yn"  value="${loginUser.eco_author_yn}"> 
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" id="ecoFlag" name="ecoFlag" value="Y" />
			<%
				String statesCode = request.getParameter("statesCode") == null ? "" : String.valueOf( request.getParameter("statesCode") );
				String eng_change_req_code = request.getParameter("eng_change_req_code") == null ? "" : String.valueOf( request.getParameter("eng_change_req_code") );
			%>
			<input type="hidden" id="statesCode" name="statesCode" value="<%=statesCode.replaceAll(",", "','")%>" />
			<input type="hidden" id="eng_change_req_code" name="eng_change_req_code" value="<%=eng_change_req_code %>" />
			<div style="margin-top: 10px;">
				<table id="ecrEcoCodeMappingPopUp" style="width: 100%; height: 50%"></table>
			</div>
<!-- 			<div style="margin-top: 10px; float:right; margin-right:10px;"> -->
<!-- 				<input type="button" id="btncheck" value="확인" class="btn_blue"/> -->
<!-- 				<input type="button" id="btncancle" value="취소" class="btn_blue"/> -->
<!-- 			</div> -->
		</form>
		<script type="text/javascript">
			var row_selected;
			var states_code = $("#statesCode").val();
			var eng_change_req_code = $("#eng_change_req_code").val();
			
			var resultData = [];
			var idRow = 0;
			var idCol = 0;
			var kRow = 0;
			
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
					postData : $("#application_form").serialize(),
					editUrl : 'clientArray',
					colNames : [ 'Name', 'Description', '선택', 'States_Code', 'Category of Change','states_name','eco_auth_y', 'oper' ],
					colModel : [
		            				{ name : 'states_type', index : 'states_type', 
		            					width : 30, align : 'center', editable : true, editrules : { required : true }, editoptions : { size : 5 }, cellattr: rowspaner },
		            				{ name : 'states_description', index : 'states_description', 
	            						width : 100, align : 'center', editable : true, editoptions : { size : 11 }, cellattr: rowspaner2 },
		            				{ name : 'enable_flag', index : 'enable_flag', 
            							width : 15, align : 'center', editable : true, editable:formatOpt1,formatter:formatOpt1, edittype:"radio", align : "center" },
		            				{ name : 'states_code', index : 'states_code', 
           								width : 15, align : 'center', editable : true, editoptions : { size : 11 } },
		            				{ name : 'states_var1', index : 'states_var1', 
      									width : 150, align : 'left', editable : true, editoptions : { size : 11 } },
      								{ name : 'states_name', index : 'states_name', 
      									width : 150, align : 'left', hidden : true, editoptions : { size : 11 } },	
      								{ name : 'eco_auth_y', index : 'eco_auth_y', 
          									width : 150, align : 'left', hidden : true, editoptions : { size : 11 } },	
     								{ name : 'oper', index : 'oper', 
     									width:25, hidden:true }
	            				],
					gridview : true,
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					height : 655,
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
					afterSaveCell : chmResultEditEnd,
					imgpath : 'themes/basic/images',
					// 사용안되고있음
					/* ondblClickRow : function(rowId) {
						var rowData = jQuery(this).getRowData(rowId);
						var sd_code = rowData['sd_code'];
						var sd_desc = rowData['sd_desc'];
	
						var returnValue = new Array();
						returnValue[0] = sd_code;
						returnValue[1] = sd_desc;
						window.returnValue = returnValue;
						self.close();
					}, */
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
	
				$('#btnfind').click(function() {
					var sUrl = "popUpCodeMaster.do";
					jQuery("#codeMasterPopUp").jqGrid('setGridParam', {
						url : sUrl,
						page : 1,
						postData : $("#application_form").serialize()
					}).trigger("reloadGrid");
				});
	
// 				$('#btncheck').click(function() {
// 					var ret = jQuery("#codeMasterPopUp").getRowData(row_selected);
// 					if (ret.sd_code == null) {
// 						alert('Please row select');
// 					}
// 					var returnValue = new Array();
// 					returnValue[0] = ret.sd_code;
// 					returnValue[1] = ret.sd_desc;
// 					window.returnValue = returnValue;
	
// 					self.close();
// 				});


				
				//afterSaveCell oper 값 지정
				function chmResultEditEnd( irow, cellName ) {
					var item = $('#ecrEcoCodeMappingPopUp').jqGrid( 'getRowData',irow );
					if ( item.oper != 'I' )
						item.oper = 'U';
					
					$('#ecrEcoCodeMappingPopUp').jqGrid( "setRowData", irow, item );
					$("input.editable,select.editable", this).attr( "editable", "0" );
				}
				 
			});
			
			function getChangedChmResultData( callback ) {
				var changedData = $.grep( $("#ecrEcoCodeMappingPopUp").jqGrid( 'getRowData' ), function( obj ) {
					//return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
					return obj.enable_flag == 'Y';
				} );
				
				callback.apply( this, [ changedData.concat(resultData) ] );
			}
			
			//폼데이터를 Json Arry로 직렬화
			function getFormData( form ) {
				var unindexed_array = $( form ).serializeArray();
				var indexed_array = {};
	
				$.map( unindexed_array, function( n, i ) {
					indexed_array[n['name']] = n['value'];
				} );
	
				return indexed_array;
			}
			
			function formatOpt1(cellvalue, options, rowObject){
				
				var rowid = options.rowId;
				var str ="<input type='radio' name='checkbox' id="+rowid+"_chkBoxOV value=" + cellvalue + " onclick='fn_checkRadio("+rowid+")' />";
				if(rowObject.eco_auth_y == "Y") {
					if($("#eco_author_yn").val() != "Y"){
						return "";
					}
				}
		   		return str;
				
				var locker_by = rowObject.locker_by;
				var states_desc = rowObject.states_desc;
				var personId = $("#loginid").val();
				
				var str_EcoType = rowObject.states_type;
				var categoryName = rowObject.states_code;
				 /************************************************************************************
				   2007/06/08 by 강선중  
				   사용자 부서가 기술기획-기술전략P일 때만 ECO Type A,B를 등록할 수 있도록 수정
				 *************************************************************************************/
				var disabledStr = "";
				   
			   if(!("207069" == personId
                  || "207309" == personId
                  || "208462" == personId
                  || "209452" == personId
                  || "207026" == personId
                  || "209495" == personId
                  || "203043" == personId
                  || "204082" == personId
                  || "205022" == personId
                  || "M076105" == personId
                  || "M081122" == personId 
                  || "206233" == personId
                  || "209508" == personId
                  || "209694" == personId
                  || "211386" == personId
				  || "211524" == personId
				  || "203037" == personId
				  || "212142" == personId
				  || "208368" == personId
				  || "208427" == personId
				  || "208057" == personId
				  || "O122101" == personId
				  || "208454" == personId
				  || "208343" == personId
				  || "212645" == personId
				  || "213356" == personId
				  || "211055" == personId
                    ) 
                      && (str_EcoType =="A"|| str_EcoType == "B"))
                  { disabledStr = "disabled"; }
                  
                 // Kang seonjung 2009-07-03 : 사용자 부서가 기술기획-기술전략P, 기술기획-기술표준P일 때만 ECO Type K 활성화,  2013-11-18 : F15추가
                if(!("207069" == personId
                  || "207309" == personId
                  || "209452" == personId
                  || "207026" == personId
                  || "209495" == personId
				  || "211386" == personId
				  || "212142" == personId
				  || "211055" == personId
                  || "211524" == personId) 
                  && (str_EcoType == "K" || categoryName == "F15")) 
                { disabledStr = "disabled"; }

				// Kang seonjung 2011-09-28 : D5(Material Loss) disable
				if(categoryName == "D5")
				{
					disabledStr = "disabled";
				}                
				
				if(disabledStr == "disabled"){ 
					return "";
				}else{
					return str;
				}
		
				return str;
		
			}
			
			function fn_checkRadio(rowid){
	
				var item = $('#ecrEcoCodeMappingPopUp').jqGrid('getRowData',rowid);

				var returnValue = new Array();
				returnValue[0] = item.states_code;
				returnValue[1] = item.states_var1;
				returnValue[2] = item.states_name;
				
				window.returnValue = returnValue;
	
				self.close();
	
			}
		</script>
	</body>
</html>
