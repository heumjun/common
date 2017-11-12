<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>wbs crate</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form" >
				<input type="hidden" name="main_code" id="main_code" />
				<input type="hidden" name="maxProrev_no" id="maxProrev_no" />
				
				<input type="hidden" name="locker_by" id="locker_by" />
				<input type="hidden" name="wbsstates" id="wbsstates" />
				<input type="hidden" name="projectChange" id="projectChange" />
				<input type="hidden" name="eco_main_code" id="eco_main_code" />
				<input type="hidden" name="eco_no" id="eco_no" />
				
				<input type="hidden" name="maxprojectrev" id="maxprojectrev" />
				<input type="hidden" name="maxwbsrev" id="maxwbsrev" />
				<input type="hidden" name="checkworkhistory" id="checkworkhistory" />
				<input type="hidden" name="checkprorevision" id="checkprorevision" />
				<input type="hidden" name="eng_eco_project" id="eng_eco_project" />
				<input type="hidden" name="eng_eco_project_Code" id="eng_eco_project_Code" />
				<input type="hidden" name="ship_type" id="ship_type" />
				<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />
				<input type="hidden" name="p_history_id" id="p_history_id" />
				
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				
				<div class="subtitle">
					WBS 구조 생성
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				 <table class="searchArea conSearch">
					<tr>
						<th>대표호선</th>
						<td>
							<input type="text" id="p_delegate_project_no" name="p_delegate_project_no" class="required w50h25" style="width: 50px;" />
							<input type="button" id="btn_delegate_project_no" name="btn_delegate_project_no" class="btn_gray2" value="검색" />
<!-- 						   <select id="p_master_project_no" name="p_master_project_no" class="required" onChange="projectFun(this.value)" style="width: 65px;"> -->
<!-- 								<option value=''>선택</option> -->
<!-- 							</select> -->
						</td>

						<th>PROJECT</th>
						<td>
							<input type="text" id="p_project_no" name="p_project_no" class="required w50h25" style="width: 50px;" />
							<input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" />
						</td>

						<th>PRO REV</th>
						<td>
						<select id="p_revision_no" name="p_revision_no" onChange="rivisionStateFun(this.value)" style="text-transform: uppercase; width: 50px;"> 
								<option value=''>선택</option>
							</select> 
						</td>

						<th>ECO No.</th>
						<td>
						<input type="text" name="eco_main_name" id="eco_main_name" class="notdisabled" style="text-transform: uppercase; width: 80px;" readonly/>
						</td>

						<th>상태</th>
						<td>
							<input type="hidden" name="eco_states_desc" id="eco_states_desc" />
							<input type="text" name="states_desc" id="states_desc" class="notdisabled" style="width: 65px;" readonly/>
						</td>

						<th>생성일</th>
						<td>
							<input type="text" name="eco_states_date" id="eco_states_date" class="notdisabled" style="width: 75px;" readonly/>
						</td>

						<th>생성자</th>
						<td >
							<input type="text" name="p_eco_created_by" id="p_eco_created_by" class="notdisabled" style="width: 75px;" readonly/>
						</td>

						<td >
						<div class="button endbox">
							<!--  ECO NO -->
							<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" class="only_bom btn_gray" value="ECO 추가" id="btnEcoAdd"/>
							</c:if>
							<c:if test="${userRole.attribute3 == 'Y'}">
							<input type="button" class="only_bom btn_gray" value="ECO 삭제" id="btnEcoDel"/>
							</c:if>
							<!--  ECO NO -->
						</div>
						</td>
					</tr>

					<tr>
					<th>WBS CD</th>
					<td>
					<input type="text" class="only_max" id="p_item_code" name="p_item_code" style="text-transform: uppercase; width: 100px;" />
					</td>

					<th>ATTR.1</th>
					<td>
					<input type="text" class="only_max wid80" id="p_attr1" name="p_attr1" class="wid80" style="text-transform: uppercase;" />
					</td>

					<th>ATTR.2</th>
					<td style="border-right:none;" >
					<input type="text" class="only_max wid80" id="p_attr2" name="p_attr2" style="text-transformuppercase;" />
					</td>

						
					<td class="bdl_no"style="border-left:none;" colspan="9">
					<div class="button endbox">
						<c:if test="${userRole.attribute2 == 'Y'}">
						<input type="button" class="only_bom btn_gray" value="하위구조 생성" id="btnSubLevelCreate" name="btnSubLevelCreate" />
						</c:if>
						<c:if test="${userRole.attribute2 == 'Y'}">
						<input type="button" class="only_bom btn_gray" value="Project Revision" id="btnRevision" name="btnRevision" />
						</c:if>
						<c:if test="${userRole.attribute2 == 'Y'}"> 
						<input type="button" class="only_bom btn_gray" value="ADD" id="btnCreate" name="btnCreate" />
						</c:if>
						<c:if test="${userRole.attribute3 == 'Y'}">
						<input type="button" class="only_bom btn_gray" value="DEL"  id="btnDelSave"  name="btnDelSave"/>
						</c:if>
						<c:if test="${userRole.attribute3 == 'Y'}">
						<input type="button" class="only_bom btn_gray" value="Revision DEL" id="btnCancle" name="btnCancle" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
						<!-- <input type="button" class="only_bom btn_gray" value="BOM 저장"  id="btnBomSave" name="btnBomSave" /> -->
						</c:if>
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="조회" id="btnSearch" name="btnSearch" class=" btn_blue"/>
						</c:if>
					</div>
					</td>

					</tr>
					</table>
				
				
				

				<div class="content">
					<table id="itemSearchList"></table>
					<div id="btn_itemSearchList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var divCloseFlag = false;
		var kRow=0;
		var resultData = [];
		var loadingBox;
		
// 		$( ".only_bom" ).prop('disabled', true );
		
		fn_buttonClassDisabled("only_bom");
		
		var is_hidden = true;
		
		$(document).ready( function() {
			fn_all_text_upper(); //입력값을 대문자로 변경하여 저장
			
			var objectHeight = gridObjectHeight(1);
						
			$( "#itemSearchList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : '',
				editUrl : 'clientArray',
				colNames : [ 'states', 'Action', 'Lv', 'Project No', '모품목', 
				             'WBS CD', 'Catalog Code', 'Catalog Type', 'Location Code', '도면 No', 
				             'ECO No', 'emp_no', 'QTY', 'Find Number', 'Top Item', 
				             'Top Catalog', 'project_no', 
				             'Attr1', 'Attr2', 'Attr3', 'Attr4', 'Attr5',
				             'Bom10', 
				             '생성자', '생성일자', '수정자', '수정일자', 
				             'oper' ],
				colModel : [ { name : 'states', index : 'states', width : 100, align : "left", hidden : is_hidden }, 
				             { name : 'states_desc', index : 'states_desc', width : 50, align : "center" }, 
				             { name : 'level_no', index : 'level_no', width : 25, align : "center" }, 
				             { name : 'connect_project_no', index : 'connect_project_no', width : 120, align : "left" }, 
				             { name : 'mother_code', index : 'mother_code', width : 100, align : "left" },
				             
				             { name : 'item_code', index : 'item_code', width : 100, align : "left" }, 
				             { name : 'item_catalog', index : 'item_catalog', width : 100, align : "center" }, 
				             { name : 'catalog_type', index : 'catalog_type', width : 100, align : "left" }, 
				             { name : 'location_code', index : 'location_code', width : 100, align : "left" }, 
				             { name : 'dwg_no', index : 'dwg_no', width : 100, align : "left" },
				             
				             { name : 'eco_no', index : 'eco_no', width : 100, align : "left" }, 
				             { name : 'emp_no', index : 'emp_no', width : 100, align : "left", hidden : is_hidden }, 
				             { name : 'qty', index : 'qty', width : 50, align : "right" }, 
				             { name : 'findnumber', index : 'findnumber', width : 80, align : "right" }, 
				             { name : 'top_item', index : 'top_item', width : 80, align : "right", hidden : is_hidden },
				             
				             { name : 'top_catalog', index : 'top_catalog', width : 80, align : "right", hidden : is_hidden }, 
				             { name : 'project_no', index : 'project_no', width : 80, align : "right", hidden : is_hidden },
				             
				             { name : 'attr1', index : 'attr1', width : 60, align : "left" },
				             { name : 'attr2', index : 'attr2', width : 60, align : "left" },
				             { name : 'attr3', index : 'attr3', width : 60, align : "left" },
				             { name : 'attr4', index : 'attr4', width : 60, align : "left" },
				             { name : 'attr5', index : 'attr5', width : 60, align : "left" },
				             
				             { name : 'bom10', index : 'bom10', width : 60, align : "left" }, 
				             
				             { name : 'create_by', index : 'create_by', width : 220, align : "left" }, 
				             { name : 'create_date', index : 'create_date', width : 80, align : "center" }, 
				             { name : 'modify_by', index : 'modify_by', width : 220, align : "left" }, 
				             { name : 'modify_date', index : 'modify_date', width : 80, align : "center" },
				             
				             { name : 'oper', index : 'oper', width : 50, align : "center", hidden : is_hidden }, ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "",
				height : objectHeight,
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				autowidth : true,
				rownumbers:true,
				multiselect: true,
				hidegrid: false,
				rowNum : -1,
				shrinkToFit : false,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : $( '#btn_itemSearchList' ),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				afterSaveCell : chmResultEditEnd,
				imgpath : 'themes/basic/images',
				onSelectRow: function( rowid, cellname, value, iRow, iCol ) {
					var ret 	= $("#itemSearchList").getRowData(rowid);
				  	var oper = ret.oper;
				  	var eng_eco_project = ret.project_no;
				  	var eng_eco_project_Code = ret.mother_id;
				  					  	
				  	if (oper == ""){
				  		$("#itemSearchList").setRowData(rowid,{oper:"U"}); 
				  		$("#eng_eco_project").val(eng_eco_project);
				  		$("#eng_eco_project_Code").val(eng_eco_project_Code);
					}else{
						$("#itemSearchList").setRowData(rowid,{oper:""}); 
					}
				},
				onSelectAll: function( rowid, cellname, value, iRow, iCol ) {
					// 체크버튼 모두 선택인 경우					
					var ids     	= $("#itemSearchList").jqGrid('getDataIDs');
					
// 					for (var i = 0; i < ids.length; i++) {
						
// 						//var rowOper = $("#itemSearchList").jqGrid('getCell', ids[i], 'oper');
						
// 						var ret 	= $("#itemSearchList").getRowData(ids[i]);
						
// 					  	var oper = ret.oper;
// 					  	var statesOper = ret.states;
// 					  	var eco_state = ret.eco_state;
					  	
// 					  	if(!(eco_state == "" || eco_state == "Create")){
					  		
// 					  		alert("ECO가 연결되어있어 진행할수 없습니다.");
// 					  		return;
// 					  	}
					  					  	
// 					  //	if(statesOper == 'Add' || statesOper =="Del"){
					  		
// 						  	if (oper == ""){
						  		
// 						  		$("#itemSearchList").setRowData(ids[i],{oper:"U"}); 
								
// 							}else{
// 								$("#itemSearchList").setRowData(ids[i],{oper:""}); 
// 							}
// 					 // 	}
					  	
// 					}
				},
				gridComplete : function() {
					var rows = $( "#itemSearchList" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var created_by = $( "#itemSearchList" ).getCell( rows[i], "created_by" );
						var locker_by = $( "#itemSearchList" ).getCell( rows[i], "locker_by" );
						var evaluator_emp_no = $( "#itemSearchList" ).getCell( rows[i], "evaluator_emp_no" );
						var design_engineer_emp_no = $( "#itemSearchList" ).getCell( rows[i], "design_engineer_emp_no" );
						var states_desc = $( "#itemSearchList" ).getCell( rows[i], "eco_state" );
						var oper = $( "#itemSearchList" ).getCell( rows[i], "oper" );
						var states = $( "#itemSearchList" ).getCell( rows[i], "states" );
						
						
						

						var login_id = $( "#loginid" ).val();

						//작성자
						if ( states_desc == "Create" ) {
							if ( created_by == login_id && locker_by == login_id ) {
								$( "#itemSearchList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#E8DB6B' } );
							    
							}
							
							if(oper != "I"){
								$("#itemSearchList").jqGrid('setCell', rows[i], 'permanent_temporary_flag', '', { color : 'black', background : '#DADADA' });
							}
							
						}
						
						if ( states_desc == "Create" ) {
							if ( created_by == login_id && locker_by == login_id ) {
								$( "#ecrList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#E8DB6B' } );
							}
						}
						
						

						//평가자
						if ( states_desc == "Review" || states_desc == "Release" ) {
							$("#itemSearchList").jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#DADADA' } );
							
							$("#itemSearchList").jqGrid('setCell',  rows[i], 'bom11', '', 'not-editable-cell');
							$("#itemSearchList").jqGrid('setCell',  rows[i], 'bom12', '', 'not-editable-cell');
							$("#itemSearchList").jqGrid('setCell',  rows[i], 'bom13', '', 'not-editable-cell');
							$("#itemSearchList").jqGrid('setCell',  rows[i], 'bom14', '', 'not-editable-cell');
				            
							
						}
						
						if ( states == "Add" ) {
								$( "#itemSearchList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#DADADA' } );
						}
						
						if ( states == "Del" ) {
								$( "#itemSearchList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#d3d3d3' } );
						}
					}
					
					$( "#itemSearchList .eco_column" ).css( "background", "#FFE6FF" );
					
					//미입력 영역 회색 표시
					$("#itemSearchList .disables").css( "background", "#DADADA" );
					$("#itemSearchList td:contains('...')").css("background","pink").css("cursor","pointer");
				}
			} );
			
			//grid resize
		    fn_gridresize( $(window), $( "#itemSearchList" ) );

// 			$( "#btn_itemSearchList_center" ).hide();
			
// 			fn_selDelegateProjectNosearch();
			
			//Item Type .. 버튼 클릭
			$( "#btnSearchCatalog" ).click( function() {
				popUpItemType();
			} );

			//조회 버튼
			$( "#btnSearch" ).click( function() {
// 				if( $( "#p_master_project_no option:selected" ).val() == "" ) {
// 					alert( "대표호선를 먼저 선택하세요." );
// 					$( "#p_master_project_no" ).focus();
// 					return;
// 				}
				
				if( $( "#p_delegate_project_no" ).val() == "" ) {
					alert( "대표호선를 먼저 선택하세요." );
					$( "#p_delegate_project_no" ).focus();
					return;
				}
				
// 				if( $( "#p_project_no option:selected" ).val() == "" ) {
// 					alert( "Project를 먼저 선택하세요." );
// 					$( "#p_project_no" ).focus();
// 					return;
// 				}
				
				if( $( "#p_project_no" ).val() == "" ) {
					alert( "Project를 먼저 선택하세요." );
					$( "#p_project_no" ).focus();
					return;
				}
				
				fn_search();
			} );
			
			
			
			$( "#btnSubLevelCreate" ).click( function () {
			
				var rowid = $( '#itemSearchList' ).jqGrid( 'getGridParam', 'selrow' );
				var item = $( '#itemSearchList' ).jqGrid( 'getRowData', rowid );
				var ship_type = $( "#ship_type" ).val();
				
				if( item.top_item == "" || item.top_item == undefined ) {
					alert( "하위구조를 생성할 WBS를 선택해 주세요." );
					return;
				}
			
// 				window.open( "mainPopupSearch.do?cmd=popupWbsSubLevelCreate&top_item=" + item.top_item + "&ship_type=" + ship_type + "&top_catalog=" + item.top_catalog );
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupWbsSubLevelCreate&top_item=" + item.top_item + "&ship_type=" + ship_type + "&top_catalog=" + item.top_catalog,
						window,
						"dialogWidth:1300px; dialogHeight:680px; center:on; scroll:off; states:off");
			} );
			
			
			
			$( "#p_project_no" ).change( function () {
				projectSelectFun( $(this).val() );
			} );
			
			
			$( "#p_delegate_project_no" ).change( function () {
				$( "#p_project_no" ).val( "" );
				$( "#maxprojectrev" ).val( "" );
				
				$( "#p_revision_no" ).append( "<option value=''>선택</option>" );
				
				$( "#itemSearchList" ).jqGrid( "clearGridData" );
			} );
			
			$( "#btn_delegate_project_no" ).click( function () {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupDelegateProjectNo",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_delegate_project_no" ).val( rs[0] );
					$( "#p_project_no" ).val( "" );
				}
			} );
			
			$( "#btn_project_no" ).click( function () {
				if( $( "#p_delegate_project_no" ).val() == "" ) {
					alert( "대표호선을 선택 후 조회해주세요." );
					$( "#btn_delegate_project_no" ).focus();
					return;
				}
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupProjectNo",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_project_no" ).val( rs[0] );
					projectSelectFun( rs[0] );
				}
			} );
			
			
			

		} ); //end of ready Function
		
		
		
		function popUpItemType() {
			var rs = window.showModalDialog( "popUpBaseInfo.do?cmd=popupPartFamilyInfo", 
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; states:off" );

			if ( rs != null ) {
				$( "#item_type" ).val( rs[1] );
			}
		}

		function fn_search() {
			rivisionStateFun();
			$( "#itemSearchList" ).jqGrid( "clearGridData" );
			var sUrl = "wbsbomSearchList.do";//?p_revision_noLast="+p_revision_noCheck;
			$( "#itemSearchList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		
		
		$( "#btnRevision" ).click( function() {
			if (confirm('프로젝트 리비젼을 올리시겠습니까?')!=0) {
				var url = 'insertProjectRevisionAdd.do';
				var formData = fn_getFormData( '#application_form' );
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				$.post( url, formData, function( data ) {
					var msg = "";
					var result = "";
					for( var keys in data ) {
						for( var key in data[keys] ) {
							if( key == 'Result_Msg' ) {
								msg=data[keys][key];
							}
							
							if (key == 'result') {
							result = data[keys][key];
							}
						}
					}
					
					alert( msg );
					if ( result == 'success' ) {
						projectRevisionWbsFun();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();	
			    	setTimeout( function() {
						fn_search();
					}, 2000 );
				} );
			}
		} );
		
		//wbs 추가 생성 버튼
		$("#btnCreate").click(function() {
			//ECO가 연결되어 있는지 확인
			if( !fn_eco_check() ) {
				return;
			}
			
			var stste=stateCheck('ADD');
			if(stste == 'fail'){
				return;
			}
			
// 			var iProject = $( '#p_project_no option:selected' ).text();
			var iProject = $( '#p_project_no' ).val();
			var iProRev = $("#p_revision_no option:selected").val();
			
			addWbsChmResultRow(iProject,iProRev);
		} );
		
		
		//eco 추가 생성 버튼
		$("#btnEcoAdd").click(function() {
			var stste=ecoCheck();
// 			$('#eco_main_name').val("");
			ecoAddStateFun();
		} );
		
		//eco 삭제 버튼
		$("#btnEcoDel").click(function() {
			wbsStateMessage = 'ECO를 삭제하시겠습니까?';
			if (confirm(wbsStateMessage)!=0) {
				addEcoDel('del');
			}
		} );
		
				
		//Save 버튼 클릭 시 
		$( "#btnDelSave" ).click( function() {
			//ECO가 연결되어 있는지 확인
			if( !fn_eco_check() ) {
				return;
			}
			
			var stste=stateCheck('SAVE');
			if(stste == 'fail'){
				return;
			}
			
			$("#wbsstates").val("D");	
			saveChanged();
		} );
		
		$( "#btnCancle" ).click( function() {
			//ECO가 연결되어 있는지 확인
			if( !fn_eco_check() ) {
				return;
			}
			
// 			$("#wbsstates").val("Cancel");
			wbs_revision_cancel();
// 			saveChanged();
		} );
		
		// BOM 수정후 저장
		$( "#btnBomSave" ).click( function() {
			$( '#itemSearchList' ).saveCell( kRow, idCol );
			
			//ECO가 연결되어 있는지 확인
			if( !fn_eco_check() ) {
				return;
			}
			
			var stste=stateCheck('BOMSAVE');
			if(stste == 'fail'){
				return;
			}
			wbsStateMessage = 'BOM 변경하시겠습니까?';
	
			if( !fn_require_chk('bomsave') ) {
				return;
			}
			
			var chmResultRows = [];
			if (confirm(wbsStateMessage)!=0) {
				addEcoRow('bomsave');
			}
		} );
		
		
		
		function wbs_revision_cancel() {
			$( '#itemSearchList' ).saveCell( kRow, idCol );
			
			var wbsStateMessage = '프로젝트를 Cancel 하시겠습니까?';

			var chmResultRows = [];
			if (confirm(wbsStateMessage)!=0) {
// 				getChangedChmResultData( function( data ) {
// 					chmResultRows = data;
// 					//필수입력 체크
// 					var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
					
// 					var project_no = $( "#p_project_no option:selected" ).val();
					var project_no = $( "#p_project_no" ).val();
					var project_rev = $( "#p_revision_no option:selected" ).val();
					
					
					
					var url = "wbsRevisionCancel.do";
// 					var formData = fn_getFormData( '#application_form' );
					var parameters = { p_project_no : project_no, p_project_rev : project_rev };
					
					loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					$.post( url, parameters, function( data2 ) {
						var msg = "";
						var result = "";
						var main_name = "";
						for ( var keys in data2) {
							for ( var key in data2[keys]) {
								if (key == 'Result_Msg') {
									msg = data2[keys][key];
								}
	
								if (key == 'result') {
									result = data2[keys][key];
								}
							}
						}
						
						alert( msg );
						if ( result == 'success' ) {
							// 최신리비젼으로 변경
							
// 							if ($("#wbsstates").val() == "Cancel"){
// 								$("#checkworkhistory").val('work');
// 							}
							
// 							var inputVal = $("select[name=p_project_no] option:selected").val();
							var inputVal = $("#p_project_no").val();
							projectSelectFun(inputVal);
							
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	loadingBox.remove();	
				    	setTimeout( function() {
							fn_search();
						}, 2000 );
					} );
// 				} );
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		function saveChanged() {
			$( '#itemSearchList' ).saveCell( kRow, idCol );
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			var wbsState = $( "#wbsstates").val();
			var wbsStateMessage = '정말로 삭제하시겠습니까?';

			var chmResultRows = [];
			if (confirm(wbsStateMessage)!=0) {
				
				
				
				var arrayData = [];
				var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

				if( selIDs.length == 0 ) {
					alert( "추가할 WBS를 선택해주세요." );
					return;
				}

				//선택된 row 추출
				$.each( selIDs, function( index, value ) {
					arrayData[index] = $( "#itemSearchList" ).jqGrid( 'getRowData', value );
				} );
				
				
				
				
				
				
				
				
// 				getChangedChmResultData( function( data ) {
					chmResultRows = arrayData;
					//필수입력 체크
					
					var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
					
					var url = 'deleteWbs.do';
					var formData = fn_getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
					
					$.post( url, parameters, function( data2 ) {
						var msg = "";
						var result = "";
						var main_name = "";
						for ( var keys in data2) {
							for ( var key in data2[keys]) {
								if (key == 'Result_Msg') {
									msg = data2[keys][key];
								}
	
								if (key == 'result') {
									result = data2[keys][key];
								}
								
								if( key == 'main_name' ) {
									main_name = data2[keys][key];
								}
							}
						}
						
						alert( msg );
						if ( result == 'success' ) {
							// 최신리비젼으로 변경
							
							if ($("#wbsstates").val() == "Cancel"){
								$("#checkworkhistory").val('work');
							}
							
// 							var inputVal = $("select[name=p_project_no] option:selected").val();
							var inputVal = $("#p_project_no").val();
							projectSelectFun(inputVal);
							
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	loadingBox.remove();
				    	setTimeout( function() {
							fn_search();
						}, 2000 );
					} );
// 				} );
			} else {
				loadingBox.remove();
			}
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $("#itemSearchList").jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		function fn_require_chk(stateEco) {
			var result  	= true;
			var message 	= "";
			var nChangedCnt = 0;
			var ids     	= $("#itemSearchList").jqGrid('getDataIDs');
			
			for (var i = 0; i < ids.length; i++) {
				
				var oper = $("#itemSearchList").jqGrid('getCell', ids[i], 'oper');
				
				if (oper == 'I' || oper == 'U' || oper == 'D' || oper == 'Y') {
					
					var eco_state = $("#itemSearchList").jqGrid('getCell', ids[i], 'eco_state');
					var eco_no = $("#itemSearchList").jqGrid('getCell', ids[i], 'eco_no');
					
					if(!(eco_state == undefined || eco_state == null || eco_state == '')){
						if( !(eco_state == "Create" || eco_no == "")){
							alert("ECO가 진행중입니다. ");
							return;
						}
					}
					nChangedCnt++;
				}
			}
		
			if (nChangedCnt == 0) {
				result  = false;
				message = "변경된 내용이 없습니다.";
			}	
			
			if (!result) {
				alert(message);
			}
			
			return result;	
		}
		
		
		//Del 버튼
		function deleteRow(){
		
			if(row_selected==0){
				return;
			}
			$('#itemSearchList').saveCell(kRow, idCol);
			
			var selrow = $('#itemSearchList').jqGrid('getGridParam', 'selrow');
			var item = $('#itemSearchList').jqGrid('getRowData',selrow);
			if(item.oper == 'I') {
				$('#itemSearchList').jqGrid('delRowData', selrow);
			}else{
				alert('저장된 데이터는 삭제할 수 없습니다.');
			}
			$('#itemSearchList').resetSelection();
			
		}
		
		//Dept Change 
		var DeptOnChange = function(){
			//기술 기획일 경우 유저 선택 기능				
			var vDeptCode = $("#p_selDept option:selected").val();
			getUserList(vDeptCode);
			$("input[name=p_deptcode]").val($("#p_selDept option:selected").val());
		};
		
		//Get User List
		var getUserList = function(vDeptCode){
			var url = 'managerUserList.do';
			var formData = fn_getFormData('#application_form');
			$.post( url, formData, function( data ) {
				for(var i = 0;data.length > i;i++) {
				   $("#p_selUser").append("<option value='"+data[i].sb_value+"' selected=\'"+data[i].sb_selected+"'\"'>"+data[i].sb_name+"</option>");
				}
			}, "json" );
		};
			
		//User Change 
		var UserOnChange = function(){
			$("input[name=p_userid]").val($("#p_selUser option:selected").val());
		};
		
		//wbs 보이기
		function projectSelectFun(val){
			$("#projectChange").val('change');
			$( "#itemSearchList" ).jqGrid( "clearGridData" );
			projectRevisionWbsFun(val);
		}
	   
		//wbs 보이기
		function wbsFun(val){
			var btnProjectrev = $("#maxprojectrev").val();
			var p_revision_no = $("#p_revision_no option:selected").val();//$("#p_revision_no").val();
		}
	   
		//project 보이기
		function projectRevisionWbsFun(val){
// 			var dataCheck = '00';
	     			
			$("#projectChange").val('');
			$("#p_revision_no option").remove();
		       
			var url = 'selectComboPRORevisionlist.do';
			var formData = fn_getFormData('#application_form');
			
			$.post( url, formData, function( data2 ) {
				if( data2.length == 0 ) {
					$("#p_revision_no").append("<option value=''>선택</option>");
				} else {
					for(var i = 0;data2.length > i;i++){
						if(i == 0){$("#maxprojectrev").val(data2[i].sb_value); } //버튼닫기귀해 넣음
						
					   $("#p_revision_no").append("<option value='"+data2[i].sb_value+"'>"+data2[i].sb_name+"</option>");
					   $("#maxProrev_no").val(data2[0].sb_value);
					   dataCheck = 'T';
					}
				}
				
				
// 				if(dataCheck == '00'){
// 					$("#maxProrev_no").val(dataCheck);
// 					$("#p_revision_no").append("<option value='"+dataCheck+"'>"+dataCheck+"</option>");
// 				}
				

				rivisionStateFun();
			}, "json" );
		}
	   
		//wbs 보이기  삭제요청으로 삭제
		function wbsRevisionFun(val){
			$("#p_wbsrevision_no option").remove();
		       
		    var url = 'selectComboWBSRevisionlist.do';
			var formData = fn_getFormData('#application_form');

			$.post( url, formData, function( data2 ) {
				for(var i = 0;data2.length > i;i++){
					$("#p_wbsrevision_no").append("<option value='"+data2[i].sb_value+"'>"+data2[i].sb_name+"</option>");
				}
			 }, "json" );
		}
		
		//리비젼 가능상태인지 확인
		function rivisionStateFun(){
			$( "#itemSearchList" ).jqGrid( "clearGridData" );
	    	var url = 'selectLastRivisionStateList.do';
			var formData = fn_getFormData('#application_form');
			var revisionState = "F";
			var eco_no = "";
			var eco_date = "";
			var max_pro_rev = "";
			var locker_by = "";
			var created_by = "";
	
			$.post( url, formData, function( data ) {
// 				for(var i = 0;data.length > i;i++){
				   revisionState = data[0].states_desc;
				   eco_no = data[0].eco_no;
				   max_pro_rev = data[0].max_pro_rev;
				   eco_date = data[0].modified_date;
				   created_by = data[0].created_by;
				   history_id = data[0].history_id;
				   
				   $("#states_desc").val(revisionState);	
				   $("#eco_main_name").val(eco_no);
				   $("#eco_states_date").val(eco_date);
				   $("#p_eco_created_by").val(created_by);
				   $("#p_history_id").val(history_id);
				   
				   if (($("#p_revision_no option:selected").val() == max_pro_rev) && ("Release" == revisionState)){ // 마지막 리비젼
// 					   $( ".only_bom" ).prop('disabled', false); //조회후 버튼 보여주기
					   fn_buttonClassEnable("only_bom");
				   }else if ("-" == revisionState){ // 마지막 리비젼
// 					   $( ".only_bom" ).prop('disabled', false); //조회후 버튼 보여주기
					   fn_buttonClassEnable("only_bom");
				   }else{
// 					   $( ".only_bom" ).prop('disabled', true); //조회후 버튼 숨기기
					   fn_buttonClassDisabled("only_bom");
				   }
// 				}
// 				alert( data[1].ship_type );

				
				if( data[1] == undefined ) {
					$( "#ship_type" ).val( data[0].ship_type );
				} else {
					$( "#ship_type" ).val( data[1].ship_type );
				}
				
				var selected_project_rev = $("#p_revision_no option:selected").val();
				
				if("Create" == revisionState && max_pro_rev == selected_project_rev ){
// 					$( ".only_bom" ).prop('disabled', false); //조회후 버튼 보여주기
					fn_buttonClassEnable("only_bom");
				   	$("#btnRevision").hide();
				   	$("#btnCreate").show();
				   	$("#btnSubLevelCreate").show();
				   	$("#btnDelSave").show();
				   	$("#btnCancle").show();
				   	$("#btnBomSave").show();
				   	$("#btnEcoAdd").show();
				   	$("#btnEcoDel").show();
				}else if(("Release" == revisionState && max_pro_rev != selected_project_rev) || "Review" == revisionState ){
				   	$("#btnRevision").hide();
				   	$("#btnCreate").hide();
				   	$("#btnSubLevelCreate").hide();
				   	$("#btnDelSave").hide();
				   	$("#btnCancle").hide();
				   	$("#btnBomSave").hide();
				   	$("#btnEcoAdd").hide();
				   	$("#btnEcoDel").hide();
				}else  if("Release" == revisionState || selected_project_rev == '-'){
					$("#btnRevision").show();
					$("#btnCreate").hide();
					$("#btnSubLevelCreate").hide();
				   	$("#btnDelSave").hide();
				   	$("#btnCancle").hide();
				   	$("#btnBomSave").hide();
				   	$("#btnEcoAdd").hide();
				   	$("#btnEcoDel").hide();
				}else  if("-" == revisionState){
					$("#btnRevision").hide();
					$("#btnCreate").show();
					$("#btnSubLevelCreate").show();
				   	$("#btnDelSave").show();
				   	$("#btnCancle").show();
				   	$("#btnBomSave").show();
				   	$("#btnEcoAdd").show();
				   	$("#btnEcoDel").show();
				}
			}, "json" );
	   }

	

	//Add 버튼 
	function addChmResultRow(item) {
		//$('#itemSearchList').saveCell(kRow, idCol);
		
		
		var item = {};
		var colModel = $('#itemSearchList').jqGrid('getGridParam', 'colModel');
		for(var i in colModel) item[colModel[i].name] = '';
		item.oper = 'I';
// 		item.master_project_no = $("#p_master_project_no").val();
		item.master_project_no = $("#p_delegate_project_no").val();
// 		item.project_no = $("#p_project_no option:selected").text();
	    item.project_no = $("#p_project_no").val();
	    item.action = 'Add';
                    
		$('#itemSearchList').resetSelection();
		$('#itemSearchList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		tableId = '#itemSearchList';	
	};
	
	
	//wbs item Add 버튼 
	function addWbsChmResultRow(iProject,iProRev) {
// 		window.open( "mainPopupSearch.do?cmd=popupSearchItem&sType=ItemSearch&sTypeName=BOM&bomName=WBS&project="+iProject+"&p_revision_no="+iProRev );
		
		var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupSearchItem&sType=ItemSearch&sTypeName=BOM&bomName=WBS&project="+iProject+"&p_revision_no="+iProRev,
				window,
				"dialogWidth:1300px; dialogHeight:680px; center:on; scroll:off; states:off");	
		if( rs != null ) {
			fn_search();
		}   
 	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd(irow, cellName) {
		var item = $('#itemSearchList').jqGrid('getRowData',irow);
		if(item.oper != 'I') item.oper = 'U';
		$('#itemSearchList').jqGrid("setRowData", irow, item);
		$("input.editable,select.editable", this).attr("editable", "0");	
	};
		 
	//진행가능 상태인지 체크
	function stateCheck(StateCheckVal) {
		var iProRev = $("#p_revision_no option:selected").val();
		var eco_check = 'True';
			
		if(iProRev == ""){
			alert("조회후 실행해주십시요.");
			return 'fail';
		}
	
		var allData = $("#itemSearchList").jqGrid('getGridParam', 'selarrrow');
		var ids = $("#itemSearchList").jqGrid('getDataIDs');			
		
		// 변경된 체크 박스가 있는지 체크한다.
		if(!(StateCheckVal == 'ADD' && allData.length == 0)){
			for( var i = 0; i < allData.length; i++ ) {
				if ($("#itemSearchList").getDataIDs().length > 0) {
					lastId = parseInt($("#itemSearchList").getDataIDs().length) + 1;
				}
				
				var item = $('#itemSearchList').jqGrid('getRowData',allData[i]);
				var eco_state = item.eco_state;
				var states = item.states;
				var oper = item.oper;

				if(StateCheckVal == 'ecoAdd' ){
				  	if(states == 'Add' || states =="Del"){
					 	$("#itemSearchList").setRowData(allData[i],{oper:"U"}); 
				  	}
				}
				
				if(StateCheckVal == 'ECODEL' && eco_state == '' ){
					alert(wbs_name+"는 ECO가 연결되어 있지 않습니다." );
					eco_check = 'False';
					break;
				}
			}
			
			if (!(StateCheckVal == 'ADD' || StateCheckVal == 'BOMSAVE' || StateCheckVal == 'Revision' || StateCheckVal == 'ecoAdd')){
				if(allData.length == 0){
					alert("먼저 선택후 실행시 주십시요." );
					return 'fail';
				}
			}
			
			if (StateCheckVal == 'Revision'){
				var checkprorevision = $("#checkprorevision").val();
				if(checkprorevision != 'Y'){
					alert("진행중인 WBS 가 존재합니다. \n 모두 완료후에 프로젝트리비젼이 올라갑니다." );
					return 'fail';
				}
			}

			if( eco_check == 'False' ){ return 'fail'; }
		}
	}
	
	
	//진행가능 상태인지 체크
	function ecoCheck() {
		var iProRev = $("#p_revision_no option:selected").val();
		var states_desc = $('#states_desc').val();
		var eco_check = 'True';
			
		if(iProRev == ""){
			alert("조회후 실행해주십시요.");
			return 'fail';
		}
		
		var allData =$("#itemSearchList").jqGrid('getGridParam', 'selarrrow');
		var ids = $("#itemSearchList").jqGrid('getDataIDs');			
		
		// 변경된 체크 박스가 있는지 체크한다.
		for( var i = 0; i < ids.length; i++ ) {
			if ($("#itemSearchList").getDataIDs().length > 0) {
				lastId = parseInt($("#itemSearchList").getDataIDs().length) + 1;
			}
			
			var item = $('#itemSearchList').jqGrid('getRowData',ids[i]);
			
			var eco_state = item.eco_state;
			var states = item.states;
			var oper = item.oper;
			
		  	if( states == 'A' || states =="D" ) {
			 	$( "#itemSearchList" ).setRowData( ids[i],{ oper:"U" } ); 
		  	}
		}
	}
	
	
	//ECO Add 버튼 
	function addEcoResultRow() {
		
		$( '#itemSearchList' ).saveCell( kRow, idCol );
		
		var wbsState = $( "#wbsstates").val();
		
		var eng_eco_project = $( "#eng_eco_project").val();
	  	var eng_eco_project_Code = $( "#eng_eco_project_Code").val();
	  	var eco_main_name = $( "#eco_main_name").val();
	  	
		var wbsStateMessage;
		
		wbsStateMessage = 'ECO를 생성하시겠습니까?';
		
		if( !fn_require_chk('ecoAdd') ) {
			return;
		}
		
		
			
		var chmResultRows = [];
		if (confirm(wbsStateMessage)!=0 && (eco_main_name == '-' || eco_main_name == '' || eco_main_name == null)) {
			getChangedChmResultData( function( data ) {
				chmResultRows = data;
				
				//필수입력 체크
				var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
				
				var sUrl = "./popupEco.do?popupDiv=bomAddEco&eng_eco_project="+eng_eco_project+"&eng_eco_project_Code="+eng_eco_project_Code + "&menu_id=${menu_id}";
				
				//window.open( sUrl, "Create_ECO", "width=1500 height=750 toolbar=no menubar=no location=no" );
				var rs = window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:750px; center:on; scroll:off; states:off" );
				
			} );
		};
				
		/*if ( rs != null ) {
			fn_search();
		}
		*/
	}
	
	//ECO Add 버튼 
	function addEcoRow(stateEco) {

		
		if('del'== stateEco){
			var url = 'saveWbsEcoAdd.do?stateEco=del';
		}else{
			var url = 'saveWbsEcoAdd.do?stateEco=save';
		}
		$( '#itemSearchList' ).saveCell( kRow, idCol );
	
		var chmResultRows = [];

		getChangedChmResultData( function( data ) {
			chmResultRows = data;
			
			//필수입력 체크
		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
		var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
			
			
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			
			$.post( url, parameters, function( data2 ) {

				var result = "";
				for ( var keys in data2) {
					for ( var key in data2[keys]) {
						if (key == 'result') {
							result = data2[keys][key];
						}
					}
				}
				
				alert(result);
				
				if ( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
			
		} );

		
	}
	
	
	//ECO Add 버튼 
	function addEcoDel(stateEco) {

	
			var url = 'saveWbsEcoAdd.do?stateEco=del';
		$( '#itemSearchList' ).saveCell( kRow, idCol );
	
		var chmResultRows = [];
		var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
			
			//필수입력 체크
		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			
			$.post( url, parameters, function( data2 ) {

				var result = "";
				for ( var keys in data2) {
					for ( var key in data2[keys]) {
						if (key == 'result') {
							result = data2[keys][key];
						}
					}
				}
				
				alert(result);
				
				if ( result == 'success' ) {
					fn_search();
					
					
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
			


		
	}
	
	/*
	 ECO가 있으면 넣고 없으면 팝업으로 보여준다.
	*/
	function ecoAddPopup() {
		
		if((event.keyCode<48)||(event.keyCode>57))event.returnValue=false;
		if(event.keyCode == 13){
			
			$("#eco_main_code").val("");
			$("#eco_main_name").val("");
			$("#eco_states_desc").val(""); 
			$("#p_eco_created_by").val("");
			   
			ecoAddStateFun();
			return;
		}
	
	}
	
	//eco 연결 가능 여부 판단 확인
	function ecoAddStateFun(){
       
					var dialog = $('<p>ECO를 연결합니다.</p>').dialog({
		            buttons: {
		                "조회": function() {
		                	
		                	var rs = window.showModalDialog("mainPopupSearch.do?cmd=popupECORelated&save=bomAddEco&ecotype=5",window,"dialogWidth:1300px; dialogHeight:460px; center:on; scroll:off; states:off");
		                	
		                	if(rs!=null){
		                	   $("#eco_main_code").val(rs[0]);
		         			   $("#eco_main_name").val(rs[1]);
		         			   $("#eco_no").val(rs[1]);
		          			   $("#eco_states_desc").val(rs[2]);
		          			   $("#p_eco_created_by").val(rs[3]);
		          			 	addEcoRow();// eco 저장
		                	}
		                	
		                	dialog.dialog('close');
		                	
		                },
		                "생성":  function() {
		                	ecoCheck();
		                	dialog.dialog('close');
		        			addEcoResultRow();
		                	
		                },
		                "Cancel":  function() {
		                    dialog.dialog('close');
		                }
		            }
				
		        });
			   	
	
   }
				
		function fn_eco_check() {
			if( "-" != $( "#eco_main_name" ).val() ) {
				alert( "ECO가 연결되어있습니다.\nECO를 Release 하거나 삭제 후 진행하세요." );
				return false;
			}
			return true;
		}
		</script>
	</body>
</html>
