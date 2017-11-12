<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>eco</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<%
					String sItemMainCode = request.getParameter("item_main_code") == null ? "" : request.getParameter("item_main_code").toString();
					String sEcoName = request.getParameter("ecoName") == null ? "" : request.getParameter("ecoName").toString();
					String popupDiv = request.getParameter("popupDiv") == null ? "" : request.getParameter("popupDiv").toString();
					
					//bom에서 eco 연결시 잠정일때 프로젝트 넣어주기
// 					String eng_eco_project = request.getParameter("eng_eco_project") == null ? "" : request.getParameter("eng_eco_project").toString();
// 					String eng_eco_project_Code = request.getParameter("eng_eco_project_Code") == null ? "" : request.getParameter("eng_eco_project_Code").toString();
					String popup_type = request.getParameter("popup_type") == null ? "" : request.getParameter("popup_type").toString();
					String checkPopup = request.getParameter("checkPopup") == null ? "" : request.getParameter("checkPopup").toString();
				%>
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" name="mode" id="mode" />
				<input type="hidden" name="states_code" id="states_code" />
				<input type="hidden" name="states_desc" id="states_desc" />
				<input type="hidden" name="searchType" value="True" />
				<input type="hidden" name="main_code" id="main_code" value="<%=sItemMainCode%>" />
				<input type="hidden" name="sTypeName" id="sTypeName" />
				<input type="hidden" name="promote" id="promote" />
				<input type="hidden" name="states_main_category" id="states_main_category" value="STATES" />
				<input type="hidden" name="states_type" id="states_type" value="ECO" />
				<input type="hidden" name="locker_by" id="locker_by" />
				<input type="hidden" name="design_engineer_reg" id="design_engineer_reg" />
				<input type="hidden" name="manufacturing_engineer_reg" id="manufacturing_engineer_reg" />
				<input type="hidden" name="design_engineer_name_reg" id="design_engineer_name_reg" />
				<input type="hidden" name="manufacturing_engineer_name_reg" id="manufacturing_engineer_name_reg" />
				<input type="hidden" name="design_engineer_mail" id="design_engineer_mail" />
				<input type="hidden" name="eco_cause" id="eco_cause" />
				<input type="hidden" name="checkPopup" id="checkPopup" value="<%=checkPopup %>" />
				
				<input type="hidden" name="manufacturing_engineer_mail" id="manufacturing_engineer_mail" />
				<input type="hidden" name="mail_main_name" id="mail_main_name" value="<%=sEcoName%>" />
				<input type="hidden" name="mail_eco_cause" id="mail_eco_cause" />
				<input type="hidden" name="mail_main_desc" id="mail_main_desc" value="<%=sEcoName%>" />
				<input type="hidden" name="notify_msg" id="notify_msg" />
				<input type="hidden" name="ref_main_name" id="ref_main_name" value="<%=sEcoName%>" />
				<input type="hidden" name="promoteyn" id="promoteyn" />
				<input type="hidden" name="rowid" id="rowid" />
				<!-- eco 하나만 저장 되도록 체크 -->
				<input type="hidden" name="checkinsert" id="checkinsert" value="" />
				<input type="hidden" name="item_main_code" id="item_main_code" value="<%=sItemMainCode%>" />
				<input type="hidden" name="popupDiv" id="popupDiv" value="<%=popupDiv%>" />
				<input type="hidden" name="popup_type" id="popup_type" value="<%=popup_type%>" />
				<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />
				<input type="hidden" value="${main_appr}" id="main_appr" name="main_appr" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<input type="hidden" id="admin_yn" name="admin_yn" value="${loginUser.admin_yn}" />
				<input type="hidden" id="p_locker_by" name="p_locker_by" />				
				<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>				
				<div class="subtitle">ECO
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				
				
				<table class="searchArea conSearch">
				<col width="80" class="only_eco">
				<col width="100" class="only_eco">
				<col width="40" class="only_eco">
				<col width="160" class="only_eco">
				<col width="40" class="only_eco">
				<col width="300" class="only_eco">
				<!--<col width="40">
				<col width="150">-->
				<col width="80" class="only_eco"/>
				<col width="170" class="only_eco"/>
				<col width="80" class="only_eco"/>
				<col width="110" class="only_eco"/>
				<col width="*" style="min-width:280px">
				<tr>
					<th class="only_eco">ECO Name</th>
					<td class="only_eco">
						<input type="text" class="only_eco" id="main_name" name="main_name" maxlength="10" style="width:80px;text-transform: uppercase; margin-right:10px;" value="<%=sEcoName%>" />
					</td>

					<th class="only_eco">생성자</th>
					<td class="only_eco">
						<input type="text" class="only_eco" id="created_by" name="created_by" maxlength="20" style="width: 50px;" onkeyup="fn_clear();" />
						<input type="text" class="notdisabled only_eco" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
						<input type="button" class="only_eco btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
					</td>

					<th class="only_eco">부서</th>
					<td class="only_eco">
						<input type="text" class="only_eco" id="user_group" name="user_group" value="${loginUser.insa_dept_code}" maxlength="15" style="width: 50px;" onkeyup="fn_clear2();" />
						<input type="text" class="notdisabled only_eco" id="user_group_name" name="user_group_name" value="${loginUser.insa_dept_name}" readonly="readonly" style="width: 180px; margin-left: -5px;" />
						<input type="button" class="only_eco btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색" />
					</td>

					<th class="only_eco">ECO 생성일</th>
					<td class="only_eco">
						<input type="text" id="created_date_start" name="created_date_start" maxlength="10" class="datepicker only_eco" style="width: 65px;" />
						<span class="only_eco">~</span>
						<input type="text" id="created_date_end" name="created_date_end" maxlength="10" class="datepicker only_eco" style="width: 65px;" />
					</td>
					<!--<th class="only_eco">TYPE</th>
					<td>
						<select  class="only_eco" id="permanent_temporary_flag" name="permanent_temporary_flag">
 						<option value=''>선택</option>
 						<option value='5'>영구</option>
 						<option value='7'>잠정</option>
 						</select>
					</td>-->
					<th class="only_eco">ECO Cause</th>
					<td class="only_eco">
					<input type="text" class="only_eco" id="s_eco_cause" name="s_eco_cause" maxlength="15" style="width: 50px;"/>
					<input type="button" class="only_eco btn_gray2" id="ecoCauseSearch" name="ecoCauseSearch" value="검색" />
					</td>
					
					<!-- <th class="only_eco">작업자</th>
					<td  class="only_eco" style="border-right:none;">
						<input type="text" class="only_eco" id="p_locker_by" name="p_locker_by" maxlength="20" style="width: 50px;" onkeyup="fn_clear3();" />
						<input type="text" class="notdisabled only_eco" id="p_locker_by_name" name="p_locker_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
						<input type="button" class="only_eco btn_gray2" id="btnEmpNo2" name="btnEmpNo2" value="검색" />
					</td> -->
					
					<td style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" class="only_eco btn_blue" id="btnSelect" name="btnSelect" value="Search" />
						</c:if>
						<c:if test="${userRole.attribute2 == 'Y'}">
						<input type="button" class="only_eco btn_blue" id="btnCreate" name="btnCreate" value="Create" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
						<!-- <input type="button" class="only_eco btn_blue" id="btnSave" name="btnSave" value="Save" /> -->
						</c:if>
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" class="only_eco btn_blue" id="btnSummaryReport" name="btnSummaryReport" value="Report" />
						</c:if>
						<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" class="only_eco btn_blue" id="btnExcelDownload" name="btnExcelDownload" value="Excel　▽" />
						</c:if>
						
						
						<input type="button" class="only_popup btn_blue" id="btncancle" value="Close" />
					</div>
					</td>
				</tr>
				</table>
				<%-- <table class="searchArea2 conSearch only_eco">
					<col width="80"/>
					<col width="180"/>
					<col width="40"/>
					<!--<col width="180"/>
					<col width="40"/>-->
					<col width="*"/>
							<tr>
						<th class="only_eco">ECO 생성일</th>
						<td>
							<input type="text" id="created_date_start" name="created_date_start" maxlength="10" class="datepicker only_eco" style="width: 65px;" />
							<span class="only_eco">~</span>
							<input type="text" id="created_date_end" name="created_date_end" maxlength="10" class="datepicker only_eco" style="width: 65px;" />
						</td>
						<!--<th class="only_eco">TYPE</th>
						<td>
							<select  class="only_eco" id="permanent_temporary_flag" name="permanent_temporary_flag">
	 						<option value=''>선택</option>
	 						<option value='5'>영구</option>
	 						<option value='7'>잠정</option>
	 						</select>
						</td>-->
						<th class="only_eco">ECO<br>Cause</th>
						<td style="border-right:none;">
						<input type="text" class="only_eco" id="s_eco_cause" name="s_eco_cause" maxlength="15" style="width: 50px;"/>
						<input type="button" class="only_eco btn_gray2" id="ecoCauseSearch" name="ecoCauseSearch" value="검색" />
						</td>
						</tr>
				</table> --%>
				<div class="content">
					<table id="ecoList"></table>
					<div id="pecoList"></div>
				</div>
				<div id="tabs" style="border:0;overflow:hidden;width:100%">
					<ul>
						<li><a href="#tabs-1">History</a></li>
						<li><a href="#tabs-2">LifeCycle</a></li>
						<li><a href="#tabs-3">Item</a></li>
						<li><a href="#tabs-5">Re_ECRs</a></li>
						<li><a href="#tabs-7">Supporting Documents</a></li>
						<li><a href="#tabs-9">Re_Projects</a></li>
						<li><a href="#tabs-10">확정통보 담당자</a></li>
						<li><a href="#tabs-11">Related Eco</a></li>
					</ul>
					<div id="tabs-1">
					<iframe name="history" id="history" 
							src="ecrHistory.do" frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
				</div>
					<div id="tabs-2">
						<iframe name="ecoLifeCycleList" id="ecoLifeCycleList"
							src="ecoLifeCycle.do" frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-3">
						<iframe name="ecoNewpartList1" id="ecoNewpartList1"
							src="ecoNewParts.do?tabName=newpart&tabNo=1"  
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-5">
						<iframe name="ecrList" id="ecrList" src="ecoSearchECRResults.do"
							 frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-7">
						<iframe name="docList" id="docList" src="doc.do" 
						frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-9">
						<iframe name="ecoRelatedProjectsList" id="ecoRelatedProjectsList"
							src="ecoRelatedProjects.do" 
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-10">
						<iframe name="ecoNotifiList" id="ecoNotifiList"
							src="ecoReleaseNotificationResults.do" 
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-11">
						<iframe name="relatedEco" id="relatedEco"
							src="relatedEco.do" 
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
				</div>
				<input type="hidden" id="sUrl" name="sUrl" value="${sUrl}">
			</form>
		</div>
		<script>
		
		var selected_tab_name = '#tabs-1';
		var lastSelectedRowId = '';
		
		$( function() {
			//탭이동
			$( "#tabs" ).tabs( {
				activate : function( event, ui ) {
					selected_tab_name = ui.newPanel.selector;
					fn_tab_link( selected_tab_name );
				}
			} );
			
		} );
		</script>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var fv_catalog_code = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var loginId = $( "#loginid" ).val();
		var maincode = $( "#main_code" ).val();
		var s_row_id;
		var divCloseFlag = false;
		var row_selected = 0;
		var lodingBox;
		var popupDiv = $( "#popupDiv" ).val();
		var objectWindow = $(window);
		var objectHeight =  $(window).height()*0.5;
		$(document).ready( function() {
			$(window).bind('resize', function() {
				$("#tabs").css({'height': $(window).height()*0.5 + 2});
				$("#history").css({'height': $(window).height()*0.5-15});
				$("#ecoLifeCycleList").css({'height': $(window).height()*0.5-15});
				$("#ecoNewpartList1").css({'height': $(window).height()*0.5-15});
				$("#ecrList").css({'height': $(window).height()*0.5-15});
				$("#docList").css({'height': $(window).height()*0.5-15});
				$("#ecoRelatedProjectsList").css({'height': $(window).height()*0.5-15});
				$("#ecoNotifiList").css({'height': $(window).height()*0.5-15});
				$("#relatedEco").css({'height': $(window).height()*0.5-15});
			}).trigger('resize');
			
			fn_all_text_upper();
			
			if( $( "#main_appr" ).val() == "Y" ) {
				$( "#p_locker_by" ).val( "${loginUser.user_id}" );
				//$( "#p_locker_by_name" ).val( "${loginUser.user_name}" );
			}
			
			//엔터 버튼 클릭
			$(":text").keypress(function(event) {
			  if (event.which == 13) {
			        event.preventDefault();
			        $('#btnSelect').click();
			    }
			});

			var sUrl = $("#sUrl").val();
			var sMtype = "";
			
			if($("#checkPopup").val() == 'Y') {			
				fn_checkRadio('1');
			}
			
			$( "#ecoList" ).jqGrid( {
				datatype : 'json',
				mtype : sMtype,
				url : sUrl,
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', 'MAIN CODE', 'Name', 'Related ECR', 'Related ECR Code', '', 'ECO Cause', 'ECO Cause code', '', '생성자', '기술변경 담당자_no', '', '결재자', '결재자_no', '부서', '', '', '상태', 'states_code', 'ECO Description', 'crud', '작업자', 'design_engineer_mail', 'manufacturing_engineer_mail', 'created_by_mail', 'promoteyn', 'created_by' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', width : 30, align : "center", editable : "radio", formatter : formatOpt1, edittype : "radio" }, 
				             { name : 'main_code', index : 'main_code', width : 52, hidden : true, editrules : { required : true }, editoptions : { size : 5 } }, 
				             { name : 'main_name', index : 'main_name', classes : 'disables', width : 70, editable : false, align : "center" }, 
				             { name : 'eng_change_name', index : 'eng_change_name', width : 100, editable : false, align : "center" }, 
				             { name : 'eng_change_req_code', index : 'eng_change_req_code', width : 0, hidden : true }, 
				             { name : 'eng_change_cause', index : 'eng_change_cause', width : 20, align : 'center' , hidden : true }, 
				             //{ name : 'permanent_temporary_flag', index : 'permanent_temporary_flag', width : 40, align : "center", editable : false, edittype : "select", editoptions : { value : "5:영구;7:잠정", defaultValue : '7:잠정', }}, 
				             { name : 'couse_desc', index : 'couse_desc', width : 310, editable : false }, 
				             { name : 'eco_cause', index : 'eco_cause', width : 20, hidden : true }, 
				             { name : 'popup_couse_desc', index : 'popup_couse_desc', width : 20, editable : false, align : 'center' , hidden : true }, 
				             { name : 'design_engineer', index : 'design_engineer', width : 60 }, 
				             { name : 'design_engineer_emp_no', index : 'design_engineer_emp_no', width : 0, hidden : true, editoptions : { size : 30 } }, 
				             { name : 'popup_design_engineer', index : 'popup_design_engineer', width : 20, hidden : true }, 
				             { name : 'manufacturing_engineer', index : 'manufacturing_engineer', width : 60 }, 
				             { name : 'manufacturing_engineer_emp_no', index : 'manufacturing_engineer_emp_no', width : 0, hidden : true, editoptions : { size : 30 } },
				             { name : 'user_group_name', index : 'user_group_name', width : 220 }, 
				             { name : 'user_group', index : 'user_group', width : 0, hidden : true, editoptions : { size : 30 } },
				             { name : 'popup_manufacturing_engineer', index : 'popup_manufacturing_engineer', width : 20, align : 'center' , hidden : true }, 
				             { name : 'states_desc', index : 'states_desc', classes : 'disables', width : 50 }, 
				             { name : 'states_code', index : 'states_code', width : 0, hidden : true }, 
				             { name : 'main_description', index : 'main_description', width : 490, editable : false, edittype : "textarea", editoptions : { rows : "2", cols : "48" } }, 
				             { name : 'oper', index : 'oper', width : 0, hidden : true }, 
				             { name : 'locker_by', index : 'locker_by', width : 0, hidden : true }, 
				             { name : 'design_engineer_mail', index : 'design_engineer_mail', width : 25, hidden : true }, 
				             { name : 'manufacturing_engineer_mail', index : 'manufacturing_engineer_mail', width : 25, hidden : true }, 
				             { name : 'created_by_mail', index : 'created_by_mail', width : 25, hidden : true }, 
				             { name : 'promoteyn', index : 'promoteyn', width : 0, hidden : true }, 
				             { name : 'created_by', index : 'created_by', width : 0, hidden : true } ],
				rowNum : 100,
				cmTemplate: { title: false },
				rowList : [ 100, 500, 1000 ],
				pager : $( '#pecoList' ),
				gridview : true,
				rownumbers : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				//caption : "ECO LIST",
// 				shrinkToFit:false,
				autowidth : true,
				height : $(window).height() * 0.5-200,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				afterSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onPaging : function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
				},
				loadComplete : function( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype : 'local',
							data : data.rows,
							pageServer : data.page,
							recordsServer : data.records,
							lastpageServer : data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page : $this.jqGrid( 'getGridParam', 'pageServer' ),
							records : $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage : $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
// 					$( '#ecoList' ).saveCell( kRow, idCol );
					
// 					var cm = $( this ).jqGrid( "getGridParam", "colModel" );
// 					var colName = cm[iCol];
// 					var item = $( this ).jqGrid( 'getRowData', rowid );
					
// 					row_selected = rowid;

// 					if( rowid != null ) {
// 						var created_by = item.created_by;
// 						var locker_by = item.locker_by;
// 						var states_desc = item.states_desc;
// 						var insert_states = item.oper;

// 						var main_code = item.main_code;
// 						var states_code = item.states_code;
// 						var main_name = item.main_name;
// 						var promoteyn = item.promoteyn;
// 						var eco_cause = item.eco_cause;

// 						s_row_id = rowid;
// 						// 작성자 는 Create, 결제자는 Review, 추가된 Row, 관리자 이외는 수정불가
// 						if( !(  ( created_by 			== loginId	&&  states_desc == "Create" )	|| 
// 								( locker_by  			== loginId	&&  states_desc == "Review" )	||
// 								(insert_states 			== "I")										||
// 								($("#admin_yn").val() 	== 'Y'		&&  states_desc != "Release"))) {
// 						//if ( !( locker_by == loginId && !( states_desc == "Release" ) ) && !( insert_states == "I" ) ) {
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_code', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_name', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'eng_change_name', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'permanent_temporary_flag', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'couse_desc', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'design_engineer', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'manufacturing_engineer', '', 'not-editable-cell' );
// // 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'eng_eco_project', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_description', '', 'not-editable-cell' );
// 						} else {
// 							if ( colName['index'] == "couse_desc" ) {
// 								if (item.oper != 'I') {
// 									if(item.eng_change_name.indexOf("|") != -1){
// 										alert("연계된 ECR이 복수 존재하는 경우 원인코드 수정이 불가합니다.");
// 										return;										
// 									}
// 								}
// 								//원인코드 팝업(ECR Based on)
// 								var eng_change_cause = item.eng_change_cause;

// 								var rs = window.showModalDialog( "popUpCause.do?loginid=" + loginId + "&statesCode=" + eng_change_cause,
// 										window,
// 										"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
								
// 								if( rs != null ) {
// 									$( "#ecoList" ).setRowData( rowid, { couse_desc : rs[1] } );
// 									$( "#ecoList" ).setRowData( rowid, { eco_cause : rs[0] } );
									
// 									if( insert_states != "I" )
// 										$( "#ecoList" ).setRowData( rowid, { oper : "U" } );
// 								}
// 							} 
							
// 							/* if ( colName['index'] == "popup_design_engineer" ) {
// 								//기슬변경담당자 팝업
// 								var rs = window.showModalDialog( "popUpEmpNoAndRegiter.do?register_type=RDE&main_type=ECO&loginid=" + $( "#loginid" ).val(),
// 										window,
// 										"dialogWidth:600px; dialogHeight:470px; center:on; scroll:off; status:off" );
								
// 								if( rs != null ) {
// 									$( "#ecoList" ).setRowData( rowid, { design_engineer : rs[1] } );
// 									$( "#ecoList" ).setRowData( rowid, { design_engineer_emp_no : rs[0] } );
									
// 									if( insert_states != "I" ) {
// 										$( "#ecoList" ).setRowData( rowid, { oper : "U" } );
// 									}
									
// 									$( "#design_engineer_reg").val( rs[1] );
// 								}
// 							}  */
							
// 							if ( colName['index'] == "manufacturing_engineer" ) {
// 								//결재자 팝업
// 								var rs = window.showModalDialog( "popUpEmpNoAndRegiter.do?register_type=RME&main_type=ECO&loginid=" + $( "#loginid" ).val(),
// 										window,
// 										"dialogWidth:600px; dialogHeight:470px; center:on; scroll:off; status:off" );
								
// 								if( rs != null ) {
// 									$( "#ecoList" ).setRowData( rowid, { manufacturing_engineer : rs[1] } );
// 									$( "#ecoList" ).setRowData( rowid, { manufacturing_engineer_emp_no : rs[0] } );
// 									if( insert_states != "I" ) {
// 										$( "#ecoList" ).setRowData( rowid, { oper : "U" } );
// 									}
									
// 									$( "#manufacturing_engineer_reg" ).val( rs[0] );
// 									$( "#manufacturing_engineer_name_reg" ).val( rs[1] );
// 								}
// 							} 
// 						}

// 						if( !( insert_states == "I" ) ) {
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'permanent_temporary_flag', '', 'not-editable-cell' );
// 						}

// 						if( insert_states == null || insert_states == '' ) {
// 							insert_states = "False";
// 						}

// 						if( insert_states == "I" ) {

// 							if ( colName['index'] == "eng_change_name" ) {
// 								//ecr 팝업

// 								var rs = window.showModalDialog( "popUpECR.do?save=create&eco_cause=" + eco_cause,
// 										window,
// 										"dialogWidth:1200px; dialogHeight:440px; center:on; scroll:off; status:off" );
								
// 								if( rs != null ) {
// 									$( "#ecoList" ).setRowData( rowid, { eng_change_name : rs[1] } );
// 									$( "#ecoList" ).setRowData( rowid, { eng_change_req_code : rs[0] } );
// 									$( "#ecoList" ).setRowData( rowid, { eng_change_cause : rs[2] } );
// 									if( insert_states != "I" ) {
// 										$( "#ecoList" ).setRowData( rowid, { oper : "U" } );
// 									}
// 								}
// 							} 
// 						}
// 					}						
				},
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					if ( rowid != null ) {
						var item = $( "#ecoList" ).jqGrid( 'getRowData', rowid );
						
						var created_by = item.created_by;
						var locker_by = item.locker_by;
						var manufacturing_engineer_emp_no = item.manufacturing_engineer_emp_no;
						var states_desc = item.states_desc;
						var insert_states = item.oper;

						var main_code = item.main_code;
						var states_code = item.states_code;
						var main_name = item.main_name;
						var promoteyn = item.promoteyn;
						var eco_cause = item.eco_cause;

						s_row_id = rowid;
						// 작성자 는 Create, 결제자는 Review, 추가된 Row, 관리자 이외는 수정불가
						if( !(  ( created_by == loginId	&& states_desc == "Create" ) 
								|| ( locker_by == loginId && manufacturing_engineer_emp_no == loginId && states_desc == "Review" )
								|| ($("#admin_yn").val() 	== 'Y'		&&  states_desc != "Release" &&  states_desc != "Cancel")
								)) {
						//if ( !( locker_by == loginId && !( states_desc == "Release" ) ) && !( insert_states == "I" ) ) {
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_code', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_name', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'eng_change_name', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'permanent_temporary_flag', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'couse_desc', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'design_engineer', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'manufacturing_engineer', '', 'not-editable-cell' );
// 							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'eng_eco_project', '', 'not-editable-cell' );
							$( "#ecoList" ).jqGrid( 'setCell', rowid, 'main_description', '', 'not-editable-cell' );
						} else {
							var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=Y&mainType=ECO&eng_change_name="+item.eng_change_name+
									"&eng_change_req_code="+item.eng_change_req_code+"&eng_change_cause="+item.eng_change_cause+
									"&couse_desc="+item.couse_desc+"&eco_cause="+item.eco_cause+
									"&manufacturing_engineer="+item.manufacturing_engineer+"&manufacturing_engineer_emp_no="+item.manufacturing_engineer_emp_no+
									"&main_description="+escape(encodeURIComponent(item.main_description)),
									"ECONO",
									"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
							
							if( rs != null ) {
								$( '#ecoList' ).saveCell( kRow, idCol );
									
								item.oper = 'U';
								item.eng_change_name = rs[0];
								item.eng_change_req_code = rs[1];
								item.eng_change_cause = rs[2];
								item.couse_desc = rs[3];
								item.eco_cause = rs[4];
								item.manufacturing_engineer = rs[7];
								item.manufacturing_engineer_emp_no = rs[8];
								item.main_description = rs[11];

								$('#ecoList').jqGrid("setRowData", rowid, item);
								
								fn_save();
							}
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#ecoList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var created_by = $( "#ecoList" ).getCell( rows[i], "created_by" );
						var locker_by = $( "#ecoList" ).getCell( rows[i], "locker_by" );
						var design_engineer_emp_no = $( "#ecoList").getCell( rows[i], "design_engineer_emp_no" );
						var states_desc = $( "#ecoList" ).getCell( rows[i], "states_desc" );
						var oper = $( "#ecoList" ).getCell( rows[i], "oper" );

						var login_id = $( "#loginid" ).val();
						var editFlag = false;
						if( states_desc == "Create" ) {
							//작성자
							if( created_by == login_id ) {
								editFlag = true;
							}
						} else if( states_desc == "Review" ) {
							//평가자
							if( locker_by == login_id ) {
								editFlag = true;
							}
						}
						if(editFlag){
							$( "#ecoList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#E8DB6B' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'couse_desc', '', { background : 'pink' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'manufacturing_engineer', '', { background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'main_name', '', { background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'states_desc', '', {  background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'permanent_temporary_flag', '', {background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'design_engineer', '', {  background : '#DADADA' } );
						}
						if( oper == "I" ) {
							
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'enable_flag', '', { hidden : 'true' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'main_name', '', { background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'states_desc', '', {  background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'design_engineer', '', {  background : '#DADADA' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'eng_change_name', '', { background : 'pink' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'couse_desc', '', { background : 'pink' } );
							$( "#ecoList" ).jqGrid( 'setCell', rows[i], 'manufacturing_engineer', '', { background : '#DADADA' } );
						}
					}

					//미입력 영역 회색 표시
					//$( "#ecoList .disables" ).css( "background", "#DADADA" );
					$( "#ecoList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					
					// 마지막에 선택된 row를 선택하도록
					if(lastSelectedRowId != ''){
						$( "#"+lastSelectedRowId +"_chkBoxOV").click();
					}

					if(tabNStr != undefined) {
						fn_tab_link(tabNStr);
					} else {
						if($("#checkPopup").val() == 'Y') {
							//fn_tab_link();
						}
					}
				}
			} );

			//grid resize
			//fn_gridresize( $(window), $( "#ecoList" )  ,10,0.5);
			if( popupDiv == 'Y' ) {
				
				$( "#user_group" ).val("");
				$( "#user_group_name" ).val("");
				
				$( "#created_date_start" ).attr( "disabled", true );
				$( "#created_date_end" ).attr( "disabled", true );
				$( "#created_date_start" ).hide();
				$( "#created_date_end" ).hide();

				$( ".only_eco" ).hide();
				$("#btnSummaryReport").show();
			
				if( $( "#item_main_code" ).val() != "" ) {
					sMtype : 'POST',
					sUrl = "";
				} else {
					$( "#btnSave" ).hide();
					var main_name = $( "#main_name" ).val();
					sMtype : 'POST',
					sUrl = 'ecoList.do?main_name=' + main_name;
				}
				$("#ecoList").setGridHeight(170);
			} else if( popupDiv == 'bomAddEco' ) {
				//bom 일때 실행

				$( "#created_date_start" ).attr( "disabled", true );
				$( "#created_date_end" ).attr( "disabled", true );
				$( "#created_date_start" ).hide();
				$( "#created_date_end" ).hide();

				$( ".only_eco" ).hide();
				lodingBox = new ajaxLoader($('#tabs'), {bgColor : '#000', opacity : '0.1' } );
				$( "#btnSummaryReport" ).hide();
				$( "#btnExcelDownLoad" ).hide();

				$( "#btnSave" ).show();
				$("#ecoList").setGridHeight(170);
			} else {
				$(".only_popup" ).hide();
				fn_gridresize( $(window), $( "#ecoList" )  ,5,0.5);
			}
			/* //caption 우측 버튼 클릭시 height 조정
			var afHeight = screen.height * 0.63;
			var reHeight = screen.height * 0.1;

			$( ".ui-jqgrid-titlebar-close" ).click( function() {
				var iframeId = $( selected_tab_name + " iframe" ).attr( 'id' );
				
				var ifra = document.getElementById( iframeId ).contentWindow;
				
				if( divCloseFlag ) {
					$( "#tabs" ).css( { "height" : "250px" } );
					$(  selected_tab_name + " iframe" ).attr( 'height', '200' );
					reHeight = 70;
					ifra.fn_setHeight( iframeId, reHeight );
					divCloseFlag = false;
				} else {
					$( "#tabs" ).css( { "height" : "578px" } );
					$( selected_tab_name + " iframe" ).attr( 'height', '500' );
					reHeight = 370;
					ifra.fn_setHeight( iframeId, reHeight );
					divCloseFlag = true;
				}

				ifra.$( "#divCloseFlag" ).val( divCloseFlag );

				$( ".ui-jqgrid-titlebar-close", this ).click();
			} ); */

			//닫기
			$( '#btncancle' ).click( function() {
				self.close();
			});

			//Summary Report
			$( "#btnSummaryReport" ).click( function() {
				var eco_main_name = $( "#ref_main_name" ).val();

				if( eco_main_name == "" ) {
					alert("ECO을 선택해주세요.");
					return;
				}

				fn_PopupReportCall( "ecoSummaryReport_1.mrd", eco_main_name );
			});

			//excel Download
			$( "#btnExcelDownload" ).click( function() {
				var sUrl = "ecoExcelExport.do";
				var f = document.application_form;

				f.action = sUrl;
				f.method = "post";
				f.submit();
			} );

			//그리드 하단 버튼 일괄 제거
			$( "#ecoList" ).jqGrid( 'navGrid', "#pecoList", {
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			//조회 버튼
			$( "#btnSelect" ).click( function() {
				fn_search();
			} );

			//eco 생성 버튼
			$( "#btnCreate" ).click( function() {
				//addChmResultRow();
				var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=Y&mainType=ECO",
						"ECONO",
						"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( '#ecoList' ).saveCell( kRow, idCol );
					
					// 한줄만 로우됨
					var checkinsert = $("#checkinsert").val();

					//if( checkinsert == "" ) {
						var item = {};
						var colModel = $( '#ecoList' ).jqGrid( 'getGridParam', 'colModel' );
						
						for( var i in colModel )
							item[colModel[i].name] = '';
						
						item.oper = 'I';
						item.eng_change_name = rs[0];
						item.eng_change_req_code = rs[1];
						item.eng_change_cause = rs[2];
						item.couse_desc = rs[3];
						item.eco_cause = rs[4];
						item.design_engineer = rs[5];
						item.design_engineer_emp_no = rs[6];
						item.manufacturing_engineer = rs[7];
						item.manufacturing_engineer_emp_no = rs[8];
						item.user_group = rs[9];
						item.user_group_name = rs[10];
						item.main_description = rs[11];
						item.permanent_temporary_flag = '잠정';
						item.states_desc = 'Create';

						item.popup_eng_change_name = '...';
						item.popup_couse_desc = '...';
						item.popup_design_engineer = '...';
						item.popup_manufacturing_engineer = '...';
//		 				item.popup_eng_eco_project = '...';

						$( '#ecoList' ).resetSelection();
						$( '#ecoList' ).jqGrid( 'addRowData', "new", item, 'first' );
						
						tableId = '#ecoList';

						$( "#checkinsert" ).val( "I" );
					//} else {
					//	alert( "저장 후 생성해주세요." );
					//	return;
					//}
				
					$( "#created_by" ).val(rs[6]);
					$( "#created_by_name" ).val( rs[5] );
					$( "#user_group" ).val( rs[9] );
					$( "#user_group_name" ).val( rs[10] );
					
					fn_save();
				}
				
			} );

			//eco 삭제 버튼
			$( "#btnDel" ).click( function() {
				deleteRow();
			} );

			$( "#btnSave" ).click( function() {
				fn_save();
			} );

			//사번 조회 팝업... 버튼
			$( "#btnEmpNo" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do",
						"ECO",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#created_by" ).val(rs[0]);
					$( "#created_by_name" ).val( rs[1] );
					$( "#user_group" ).val( rs[2] );
					$( "#user_group_name" ).val( rs[3] );
				}
			} );
			
			//사번 조회 팝업... 버튼
			$( "#btnEmpNo2" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do",
						window,
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_locker_by" ).val(rs[0]);
					//$( "#p_locker_by_name" ).val( rs[1] );
				}
			} );

			//부서조회 팝업... 버튼
			$( "#btnGroupNo" ).click( function() {
				var rs = window.showModalDialog( "popUpGroup.do",
						"ECO",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );

				if( rs != null ) {
					$( "#user_group" ).val( rs[0] );
					$( "#user_group_name" ).val( rs[1] );
				}
			} );
			$( "#ecoCauseSearch" ).click( function() {
				var rs = window.showModalDialog( "popUpCause.do",
						window,
						"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#s_eco_cause" ).val( rs[0] );
				}
			} );
			
			
			$( function() {
				var dates = $( "#created_date_start, #created_date_end" ).datepicker( {
					prevText : '이전 달',
					nextText : '다음 달',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
					dateFormat : 'yy-mm-dd',
					showMonthAfterYear : true,
					yearSuffix : '년',
					changeYear: true,
					changeMonth : true,
					onSelect : function( selectedDate ) {
						var option = this.id == "created_date_start" ? "minDate" : "maxDate", 
								instance = $( this ).data( "datepicker" ), 
								date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
						dates.not(this).datepicker( "option", option, date );
					}
				} );
			} );

			//기술변경담당자,결재자 가져오기
			fn_register();

			
			if( popupDiv == 'Y' || $( "#main_appr" ).val() == 'Y') {
				fn_search();
			}
			
			
			//일주일 단위로 가져오기
			fn_weekDate( "created_date_start", "created_date_end" );
			
		}); //end of ready Function

		function setErrorFocus( gridId, rowId, colId, colName ) {
			$( "#" + rowId + "_" + colName ).focus();
			$(gridId).jqGrid( 'editCell', rowId, colId, true );
		}

		//Del 버튼
		function deleteRow() {
			if ( row_selected == 0 ) {
				return;
			}
			
			$( '#ecoList' ).saveCell( kRow, idCol );

			var selrow = $( '#ecoList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#ecoList' ).jqGrid( 'getRowData', selrow );
			if( item.oper == 'I' ) {
				$( '#ecoList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert( '저장된 데이터는 삭제할 수 없습니다.' );
			}
			$( '#ecoList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {
			$( '#ecoList' ).saveCell( kRow, idCol );
			
			// 한줄만 로우됨
			var checkinsert = $("#checkinsert").val();

			if( checkinsert == "" ) {
				var item = {};
				var colModel = $( '#ecoList' ).jqGrid( 'getGridParam', 'colModel' );
				
				for( var i in colModel )
					item[colModel[i].name] = '';
				
				item.oper = 'I';
				item.design_engineer = $( "#design_engineer_name_reg" ).val();
				item.design_engineer_emp_no = $( "#design_engineer_reg" ).val();
				item.manufacturing_engineer = $( "#manufacturing_engineer_name_reg" ).val();
				item.manufacturing_engineer_emp_no = $( "#manufacturing_engineer_reg" ).val();
				item.permanent_temporary_flag = '잠정';
				item.states_desc = 'Create';

				item.popup_eng_change_name = '...';
				item.popup_couse_desc = '...';
				item.popup_design_engineer = '...';
				item.popup_manufacturing_engineer = '...';
// 				item.popup_eng_eco_project = '...';

				$( '#ecoList' ).resetSelection();
				$( '#ecoList' ).jqGrid( 'addRowData', "new", item, 'first' );
				
				tableId = '#ecoList';

				$( "#checkinsert" ).val( "I" );
			} else {
				alert( "저장 후 생성해주세요." );
				return;
			}
		}

		//design engineer 등 가져오기
		function fn_register() {
			var url = 'infoEmpNoRegisterList.do';
			var formData = fn_getFormData( '#application_form' );
			$.post( url, formData, function( data ) {
				for( var i = 0; data.length > i; i++ ) {
					if( data[i].register_type == "RDE" ) {
						$( "#design_engineer_reg" ).val( data[i].sub_emp_no );
						$( "#design_engineer_name_reg" ).val( data[i].user_name );
					}
					if( data[i].register_type == "RME" ) {
						$( "#manufacturing_engineer_reg" ).val( data[i].sub_emp_no );
						$( "#manufacturing_engineer_name_reg" ).val( data[i].user_name );
					}
				}

				//item_main_code가 있는 경우 상단 조회조건 숨김
				if( $( "#item_main_code" ).val() != "" ) {
					$( ".only_eco" ).hide();
					addChmResultRow();
				}

				//bom 일때 실행
				if ( popupDiv == 'bomAddEco' ) {
					addChmResultRow();
				}
			}, "json" );
		}

		//가져온 배열중에서 필요한 배열만 골라내기
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#ecoList" ).jqGrid( 'getRowData' ), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );

			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmCheckResultData( callback ) {
			var changedData = $.grep( $( "#ecoList" ).jqGrid( 'getRowData' ), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == 'P';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		}
		var tabNStr = undefined;
		function fn_search(tabNStrP) {
			
		    if(tabNStrP != undefined) tabNStr = tabNStrP;
			// 한줄만 저장 초기화
			$("#checkinsert").val( "" );

			var created_by_name = $( "#created_by_name" ).val();
			var user_group_name = $( "#user_group_name" ).val();

			if( created_by_name == null || created_by_name == "" ) {
				$( "#created_by" ).val( "" );
			}

			if( user_group_name == null || user_group_name == "" ) {
				$( "#user_group" ).val( "" );
			}

			var sUrl = "ecoList.do";

			$( "#ecoList" ).jqGrid( "clearGridData" );
			$( '#ecoList' ).jqGrid( 'setGridParam', {postData : null});
			$( "#ecoList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );

			$( "#mail_main_name" ).val( "" );
			$( "#ref_main_name" ).val( "" );
			$( "#locker_by" ).val( "" );
			$( "#main_code" ).val( "" );
			$( "#sTypeName" ).val( "ECO" );
			$( "#states_code" ).val( "" );
			$( "#states_desc" ).val( "" );

			//황경호 fn_tab_link( selected_tab_name );
		}

		function fn_checkRadio( rowid ) {
			
			lastSelectedRowId = rowid;
			var item = $( '#ecoList' ).jqGrid( 'getRowData', rowid );
			var main_code = item.main_code;
			var locker_by = item.locker_by;
			var states_code = item.states_code;
			var states_desc = item.states_desc;
			var design_engineer_mail = item.design_engineer_mail;
			var manufacturing_engineer_mail = item.manufacturing_engineer_mail;
			var mail_main_name = item.main_name;
			var created_by_mail = item.created_by_mail;
			var mail_eco_cause = item.couse_desc;
			var mail_main_desc = item.main_description;
			var created_by_name = item.created_by_name;
			
			var loginId = $( "#loginid" ).val();
			var main_name = item.main_name;
			var promoteyn = item.promoteyn;

			$("#ref_main_name").val(main_name);
			$("#eco_cause").val(item.eco_cause);
			$("#locker_by").val(locker_by);
			$("#main_code").val(main_code);
			$("#states_desc").val(states_desc);
			$("#design_engineer_mail").val(design_engineer_mail);
			$("#manufacturing_engineer_mail").val(manufacturing_engineer_mail);
			$("#sTypeName").val("ECO");
			$("#states_code").val(states_code);
			$("#mail_main_name").val(mail_main_name);
			$("#created_by_mail").val(created_by_mail);
			$("#mail_eco_cause").val(mail_eco_cause);
			$("#mail_main_desc").val(mail_main_desc);
			$("#created_by_name").val(created_by_name);
			$("#promoteyn").val(promoteyn);
			$("#rowid").val(rowid);

			if($("#checkPopup").val() != 'Y') {
				fn_tab_link(selected_tab_name);
			}

			var changedData = $( "#ecoList" ).jqGrid( 'getRowData' );
			
			for( var i = 1; i < changedData.length + 1; i++ ) {
				var items = $( '#ecoList' ).jqGrid( 'getRowData', i );

				if( items.oper == 'P' ) {
					$( "#ecoList" ).setRowData( rowid, { oper : '' } );
				}
			}

			$( "#ecoList" ).setRowData( rowid, { oper : 'P' } );
		}

		//tab change event
		function fn_tab_link( tab_name ) {
			
			switch ( tab_name ) {
			case "#tabs-1":
				document.getElementById('history').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			case "#tabs-2":
				document.getElementById('ecoLifeCycleList').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			case "#tabs-3":
				document.getElementById('ecoNewpartList1').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			case "#tabs-5":
				document.getElementById('ecrList').contentWindow.fn_search();
				//fn_divCloseFalg(divCloseFlag, $(selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			case "#tabs-7":
				document.getElementById('docList').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
 			case "#tabs-9":
 				document.getElementById('ecoRelatedProjectsList').contentWindow.fn_search();
 				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
 				break;
			case "#tabs-10":
				document.getElementById('ecoNotifiList').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			case "#tabs-11":
				document.getElementById('relatedEco').contentWindow.fn_search();
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			default:
				$( "#history" ).attr( "src", "ecrHistory.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
				break;
			} 
		}

		//작성자 조회조건 삭제 시 작성자명 초기화
		function fn_clear() {
			if( $( "#created_by" ).val() == "" ) {
				$( "#created_by_name" ).val( "" );
			}
		}
		
		//부서 조회조건 삭제 시 부서명 초기화
		function fn_clear2() {
			if( $( "#user_group" ).val() == "" ) {
				$( "#user_group_name" ).val( "" );
			}
		}

		//저장
		function fn_save() {
			$( '#ecoList' ).saveCell( kRow, idCol );

			//필수입력 체크
			if( !fn_require_chk() ) {
				return;
			}

			var chmResultRows = [];
			if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				getChangedChmResultData( function( data ) {
					chmResultRows = data;

					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

					var url = 'saveEco.do';
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend({}, dataList, formData);
					
					lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					$.post( url, parameters, function( data2 ) {
						alert(data2.resultMsg);
						if ( data2.result == 'success' ) {
						
							if( popupDiv == "Y" ) {
								$( "#main_name" ).val( data2.main_name );

								if( typeof (parent.opener) != undefined ) {
									parent.opener.fn_search();
								}
							} else if( popupDiv == "bomAddEco" ) {
								//bom에서 eco연결
								//$( "#main_name" ).val( data2.main_name );
								//window.dialogArguments.$( "#eco_main_name" ).val( data2.main_name );
								//if( $( "#popup_type" ).val() != "PAINT" ) {
									var rows = $( "#ecoList" ).getDataIDs();
									var returnValue = new Array();
									returnValue[0] = data2.main_name;
									returnValue[2] = $( "#ecoList" ).getCell( rows[0], "design_engineer" );;
									window.returnValue = returnValue;
									self.close();
									/* window.dialogArguments.$( "#eco_no" ).val( data2.main_name );
									window.dialogArguments.addEcoRow( $( "#popup_type" ).val() ); */
								//}
							} else {
								fn_search();	
							}
							
						}
					}, "json" ).error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						lodingBox.remove();
					} );
				} );
			}
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irow, cellName ) {
			var item = $( '#ecoList' ).jqGrid( 'getRowData', irow );
			if( item.oper != 'I' )
				item.oper = 'U';
			$( '#ecoList' ).jqGrid( "setRowData", irow, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}

		function fn_require_chk() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#ecoList" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {

				var oper = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' || oper == 'D' ) {
					nChangedCnt++;
					
					//var val1 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'permanent_temporary_flag' );
					var val2 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'eco_cause' );
					var val3 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'manufacturing_engineer_emp_no' );
					var val4 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'design_engineer_emp_no' );
					var val5 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'main_description' );
//					var val6 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'permanent_temporary_flag' );
// 					var val7 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'eng_eco_project_Code' );
					var val8 = $( "#ecoList" ).jqGrid( 'getCell', ids[i], 'eng_change_req_code' );

// 					if( $.jgrid.isEmpty( val1 ) ) {
// 						result = false;
// 						message = "ECO Type는 필수입력입니다.";
// 						setErrorFocus( "#ecoList", ids[i], 5, 'permanent_temporary_flag' );
// 						break;
// 					}

					if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "ECO_Cause은 필수입력입니다.";
						setErrorFocus( "#ecoList", ids[i], 9, 'eco_cause' );
						break;
					}

					if( $.jgrid.isEmpty( val3 ) ) {
						result = false;
						message = "결재자는 필수입력입니다.";
						setErrorFocus( "#ecoList", ids[i], 15, 'manufacturing_engineer_emp_no' );
						break;
					}

					if( $.jgrid.isEmpty( val4 ) ) {
						result = false;
						message = "기술변경담당자는 필수입력입니다.";
						setErrorFocus( "#ecoList", ids[i], 12, 'design_engineer_emp_no' );
						break;
					}

					if( $.jgrid.isEmpty( val5 ) ) {
						result = false;
						message = "Description는 필수입력입니다.";
						setErrorFocus( "#ecoList", ids[i], 20, 'main_description' );
						break;
					}

// 					if ( val6 == "잠정" && $.jgrid.isEmpty( val7 ) ) {
// 						result = false;
// 						message = "ECO Project는 필수입력입니다.";
// 						setErrorFocus( "#ecoList", ids[i], 18, 'eng_eco_project_Code' );
// 						break;
// 					}
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

		//STATE 값에 따라서 checkbox 생성
		function formatOpt1( cellvalue, options, rowObject ) {
			var rowid = options.rowId;
			var str = "<input type='radio' name='checkbox' id=" + rowid
					+ "_chkBoxOV value=" + cellvalue
					+ " onclick='fn_checkRadio(" + rowid + ")' />";
			if(rowid == "new") {
				str = "";
			}
			var locker_by = rowObject.locker_by;
			var states_desc = rowObject.states_desc;

			if ( rowObject.enable_flag == "" || rowObject.enable_flag == undefined ) {
				return str;
			}
		}
		</script>
	</body>
</html>
