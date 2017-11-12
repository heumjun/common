<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>ECR</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<style type="text/css">
		    .ui-jqgrid tr.jqgrow td {
		        word-wrap: break-word; /* IE 5.5+ and CSS3 */
		    }
		</style>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<%
					String sEcrName = request.getParameter( "ecr_name" ) == null ? "" : request.getParameter( "ecr_name" ).toString();
					String isEcrName = request.getParameter( "ecr_name" ) == null ? "false" : "true";
					String popupDiv = request.getParameter("popupDiv") == null ? "" : request.getParameter("popupDiv").toString();
					String popup_type = request.getParameter("popup_type") == null ? "" : request.getParameter("popup_type").toString();
					String checkPopup = request.getParameter("checkPopup") == null ? "" : request.getParameter("checkPopup").toString();
					String ecr_if_flag = request.getParameter("ecr_if_flag") == null ? "" : request.getParameter("ecr_if_flag").toString();
				%>
				<input type="hidden" name="main_code" id="main_code" />
				<input type="hidden" name="states_code" id="states_code" />
				<input type="hidden" name="states_type" id="states_type" value="ECR" />
				<input type="hidden" name="states_main_category" id="states_main_category" value="STATES" />
				<input type="hidden" name="states_desc" id="states_desc" />
				<input type="hidden" name="ref_main_code" id="ref_main_code" />
				<input type="hidden" name="ref_main_name" id="ref_main_name" />
				<input type="hidden" name="eng_change_based_on" id="eng_change_based_on" />
				<input type="hidden" name="mode" id="mode" />
				<input type="hidden" name="searchType" id="searchType" value="True" />
				<input type="hidden" name="sTypeName" id="sTypeName" />
				<input type="hidden" name="promote" id="promote" />
				<input type="hidden" name="locker_by" id="locker_by" />
				<input type="hidden" name="design_engineer_reg" id="design_engineer_reg" />
				<input type="hidden" name="design_engineer_name_reg" id="design_engineer_name_reg" />
				<input type="hidden" name="manufacturing_engineer_reg" id="manufacturing_engineer_reg" />
				<input type="hidden" name="manufacturing_engineer_name_reg" id="manufacturing_engineer_name_reg" />
				<input type="hidden" name="isEcrName" id="isEcrName" value="<%=isEcrName %>" />
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />				
				<input type="hidden" value="${main_appr}" id="main_appr" name="main_appr" />
				<input type="hidden" name="popupDiv" id="popupDiv" value="<%=popupDiv%>" />
				<input type="hidden" name="checkPopup" id="checkPopup" value="<%=checkPopup %>" />
				<input type="hidden" name="popup_type" id="popup_type" value="<%=popup_type%>" />
				<input type="hidden" id="p_locker_by" name="p_locker_by" />
				<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>
				
				<input type="hidden" id="admin_yn" name="admin_yn" value="${loginUser.admin_yn}" />
				
				<!-- ECR Interface 화면에서 ECR 화면 OPEN 여부 -->
				<input type="hidden" name="ecr_if_flag" id="ecr_if_flag" value="<%=ecr_if_flag%>" />				
				
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="subtitle">
					ECR
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
 				</div>

				
<!--				
				<div class="searchbox">
				<div class="conSearch" >
				
				<label class="sc_tit">ECR Name</label>
				<input type="text" class="hidden_ecr only_num_input" id="p_main_name" name="p_main_name" maxlength="10" style="width: 80px;" value="<%=sEcrName %>" />
				
				<label class="sc_tit mgl20" >작성자</label>
				<input type="text" class="hidden_ecr" id="p_created_by" name="p_created_by" style="width: 50px;" maxlength="6" onkeyup="fn_clear();" />
				<input type="text" class="notdisabled hidden_ecr" id="p_created_by_name" name="p_created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
				<input type="button" class="hidden_ecr btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />	
				
				<label class="sc_tit mgl20" >부서</label>
				<input type="text" class="hidden_ecr" id="p_user_group" name="p_user_group" style="width: 50px;" maxlength="6" onkeyup="fn_clear2();" />
				<input type="text" class="notdisabled hidden_ecr" id="p_user_group_name" name="p_user_group_name" readonly="readonly" style="width: 100px; margin-left: -5px;" />
				<input type="button" class="hidden_ecr btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색" />


				<label class="sc_tit mgl20" >ECR생성일</label>
				<input type="text" id="p_created_date_start" name="p_created_date_start" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;"/>
				<span class="hidden_ecr">~</span>
				<input type="text" id="p_created_date_end" name="p_created_date_end" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;"/>

				<div class="button endbox">
				<input type="button" class="hidden_ecr btn_blue" id="btnCreateECR" name="btnCreateECR" value="생성"/>
				<input type="button" class=" btn_blue" id="btnSummaryReport" name="btnSummaryReport" value="Summary Report"/>
				<input type="button" class="hidden_ecr btn_blue" id="btnExcelDownload" name="btnExcelDownload" value="Excel ▽"/>
				<input type="button" class="hidden_ecr btn_blue" id="btnSave" name="btnSave" value="저장"/>
				<input type="button" class="hidden_ecr btn_blue" id="btnSelect" name="btnSelect" value="조회"/>
				</div>
	
				</div>
				</div>					
						
			-->
					

				
				<table class="searchArea conSearch">
					<col width="70" class="hidden_ecr">
					<col width="85" class="hidden_ecr">
					<col width="40" class="hidden_ecr">
					<col width="160" class="hidden_ecr">
					<col width="40" class="hidden_ecr">
					<col width="300" class="hidden_ecr">
					<col width="70" class="hidden_ecr">
					<col width="170" class="hidden_ecr">
					<%-- col width="40">
					<col width="150"> --%>
					<col width="*" style="min-width:350px">
	
					<tr>
						<th class="hidden_ecr">ECR Name</th>
						<td class="hidden_ecr">
							<input type="text" class="hidden_ecr only_num_input" id="p_main_name" name="p_main_name" maxlength="10" style="width: 60px; margin-right:10px;" value="<%=sEcrName %>" />
						</td>
	
						<th class="hidden_ecr">작성자</th>
						<td class="hidden_ecr">
							<input type="text" class="hidden_ecr" id="p_created_by" name="p_created_by" style="width: 50px;" maxlength="6" onkeyup="fn_clear();" />
							<input type="text" class="notdisabled hidden_ecr" id="p_created_by_name" name="p_created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
							<input type="button" class="hidden_ecr btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
						</td>
	
						<th class="hidden_ecr">부서</th>
						<td class="hidden_ecr">
							<input type="text" class="hidden_ecr" id="p_user_group" name="p_user_group" value="${loginUser.insa_dept_code}" style="width: 50px;" maxlength="6" onkeyup="fn_clear2();" />
							<input type="text" class="notdisabled hidden_ecr" id="p_user_group_name" name="p_user_group_name" value="${loginUser.insa_dept_name}" readonly="readonly" style="width: 180px; margin-left: -5px;" />
							<input type="button" class="hidden_ecr btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색" />
						</td>
	
						<th class="hidden_ecr">ECR생성일</th>
						<td class="hidden_ecr">
							<input type="text" id="p_created_date_start" name="p_created_date_start" class="datepicker hidden_ecr" maxlength="10" style="width: 65px;"/>
							<span class="hidden_ecr">~</span>
							<input type="text" id="p_created_date_end" name="p_created_date_end" class="datepicker hidden_ecr" maxlength="10" style="width: 65px;"/>
						</td>
						
						<!-- <th class="hidden_ecr">작업자</th>
						<td style="border-right:none;">
							<input type="text" class="hidden_ecr" id="p_locker_by" name="p_locker_by" maxlength="20" style="width: 50px;" onkeyup="fn_clear3();" />
							<input type="text" class="notdisabled hidden_ecr" id="p_locker_by_name" name="p_locker_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
							<input type="button" class="hidden_ecr btn_gray2" id="btnEmpNo2" name="btnEmpNo2" value="검색" />
						</td> -->
	
						<td style="border-left:none;" >
						<div class="button endbox">
							<!-- <input type="button" class="hidden_ecr btn_blue" id="btnTest" name="btnTest" value="TEST"/> -->
							<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" class="hidden_ecr btn_blue" id="btnSelect" name="btnSelect" value="Search"/>
							</c:if>
							<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" class="hidden_ecr btn_blue" id="btnCreateECR" name="btnCreateECR" value="Create"/>
							</c:if>
							<c:if test="${userRole.attribute4 == 'Y'}">
							<!-- <input type="button" class="hidden_ecr btn_blue" id="btnSave" name="btnSave" value="Save"/> -->
							</c:if>
							<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" class=" btn_blue" id="btnSummaryReport" name="btnSummaryReport" value="Report"/>
							</c:if>
							<c:if test="${userRole.attribute5 == 'Y'}">
							<input type="button" class="hidden_ecr btn_blue" id="btnExcelDownload" name="btnExcelDownload" value="Excel　▽"/>
							</c:if>		
							<input type="button" class="only_popup btn_blue" id="btncancle" value="닫기" />
						</div>
						</td>
					</tr>
				</table>




 
				<!--	<div class = "conSearch" >
						<span class="hidden_ecr">ECR Name</span>
						<input type="text" class="hidden_ecr only_num_input" id="p_main_name" name="p_main_name" maxlength="10" style="width: 80px;" value="<%=sEcrName %>" />
						<span class="hidden_ecr">&nbsp;</span>
						<span class="hidden_ecr">작성자</span>
						<input type="text" class="hidden_ecr" id="p_created_by" name="p_created_by" style="width: 50px;" maxlength="6" onkeyup="fn_clear();" />
						<input type="text" class="notdisabled hidden_ecr" id="p_created_by_name" name="p_created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
						<input type="button" class="hidden_ecr" id="btnEmpNo" name="btnEmpNo" value=".." />
						<span class="hidden_ecr">&nbsp;</span>
						<span class="hidden_ecr">부서</span>
						<input type="text" class="hidden_ecr" id="p_user_group" name="p_user_group" style="width: 50px;" maxlength="6" onkeyup="fn_clear2();" />
						<input type="text" class="notdisabled hidden_ecr" id="p_user_group_name" name="p_user_group_name" readonly="readonly" style="width: 100px; margin-left: -5px;" />
						<input type="button" class="hidden_ecr" id="btnGroupNo" name="btnGroupNo" value=".." />
						<span class="hidden_ecr">&nbsp;</span>
						<span class="hidden_ecr">ECR 생성일</span>
						<input type="text" id="p_created_date_start" name="p_created_date_start" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;"/>
						<span class="hidden_ecr">~</span>
						<input type="text" id="p_created_date_end" name="p_created_date_end" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;"/>
					</div>
					<div class="button">
						<input type="button" class="hidden_ecr" id="btnCreateECR" name="btnCreateECR" value="생성" />
						<input type="button" class="" id="btnSummaryReport" name="btnSummaryReport" value="Summary Report" />
						<input type="button" class="hidden_ecr" id="btnExcelDownload" name="btnExcelDownload" value="Excel ▽" />
						<input type="button" class="hidden_ecr" id="btnSave" name="btnSave" value="저장" />
						<input type="button" class="hidden_ecr" id="btnSelect" name="btnSelect" value="조회" />
					</div>
					-->
				
				<div class="content">
					<table id="ecrList"></table>
					<div id="pecrList"></div>
				</div>
				<div id="tabs" style="border:none;height:100%;width:100%">
					<ul>
						<li><a href="#tabs-1">History</a></li>
						<li><a href="#tabs-2">Life Cycle</a></li>
						<li><a href="#tabs-3">Route</a></li>
						<li><a href="#tabs-4">Supporting Documents</a></li>
						<li><a href="#tabs-5">Related ECOs</a></li>
					</ul>
					<div id="tabs-1">
						<iframe name="history" id="history" src="ecrHistory.do"
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-2">
						<iframe name="ecrLifeCycle" id="ecrLifeCycle" src="ecrLifeCycle.do"
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					 <div id="tabs-3">
						<iframe name="routeList" id="routeList" src="ecrRoute.do"
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-4">
						<iframe name="docList" id="docList" src="doc.do"
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
					<div id="tabs-5">
						<iframe name="relatedECOsList" id="relatedECOsList" src="ecrRelatedECOs.do"
							frameborder=0 scrolling=no 
							style="width:100%;height:100%; border-width:0px;  border-color:white;"></iframe>
					</div>
				</div>
				
				<div id="desc_layer" style="position: absolute; left: 730px; top: 180px; border: 1px solid blue; display: none; background-color: yellow; padding: 10px;">
					<font style="color: blue; font-weight: bold;">
						<br />
						* Standard of making ECR
						<br />
						&nbsp;&nbsp;
						(Description Guide)
						<br /><br />
						&nbsp;&nbsp;
						1. Master/Project &amp; Stage
						<br />
						&nbsp;&nbsp;
						2. Permanent/Deviation
						<br />
						&nbsp;&nbsp;
						3. Description of Change
						<br />
						&nbsp;&nbsp;
						4. Related Dept/Person
						<br />
						&nbsp;&nbsp;
						5. ECO TYPE CODE
						<br /><br />
					</font>
				</div>
				<input type="hidden" id="sUrl" name="sUrl" value="${sUrl}">
			</form>
		</div>
		<script type="text/javascript">
		var selected_tab_name = "#tabs-1";
		var tableId = '';
		var resultData = [];
		var fv_catalog_code = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var kRow = 0;
		var loginId = $( "#loginid" ).val();
		var maincode = $( "#p_main_name" ).val();
		var popupDiv = $( "#popupDiv" ).val();
		var jsonObj;
		var divCloseFlag = false;
		var sUrl = "ecrList.do";
		var lodingBox;
		var lastSelectedRowId = '';
		var objectWindow = $(window);
		var objectHeight =  $(window).height()*0.5;
		$(document).ready( function() {
			$(window).bind('resize', function() {
				$("#tabs-1").css({'height': $(window).height()*0.5-15});
				$("#tabs-2").css({'height': $(window).height()*0.5-15});
				$("#tabs-3").css({'height': $(window).height()*0.5-15});
				$("#tabs-4").css({'height': $(window).height()*0.5-15});
				$("#tabs-5").css({'height': $(window).height()*0.5-15});
			}).trigger('resize');
			//$("#history").css({'height':  $(window).height()*0.5-35});
			//$("#ecrLifeCycle").css({'height':  $(window).height()*0.5-35});
			//$("#routeList").css({'height':  $(window).height()*0.5-35});
			//$("#docList").css({'height':  $(window).height()*0.5-35});
			//$("#relatedECOsList").css({'height':  $(window).height()*0.5-35});
			//엔터 버튼 클릭
			$(":text").keypress(function(event) {
			  if (event.which == 13) {
			        event.preventDefault();
			        $('#btnSelect').click();
			    }
			});
			
			fn_all_text_upper();
			//fn_only_num_input();
			
			if( $( "#main_appr" ).val() == "Y" ) {
				$( "#p_locker_by" ).val( "${loginUser.user_id}" );
				//$( "#p_locker_by_name" ).val( "${loginUser.user_name}" );
			}
			
			//탭이동
			$( "#tabs" ).tabs( {
				activate : function( event, ui ) {
					selected_tab_name = ui.newPanel.selector;
					fn_tab_link( selected_tab_name );
				}
			} );
			
			if($("#checkPopup").val() == 'Y') {			
				fn_checkRadio('1');
			}
			
			var is_hidden = true;
			
			$( "#ecrList" ).jqGrid( {
				url : '',
				mtype : '',
				datatype : "json",
				postData : getFormData( "#application_form" ),
				colModel : [ { label :'선택', name : 'enable_flag', index : 'enable_flag', width : 30, align : "center", editable : formatOpt1, formatter : formatOpt1, edittype : "radio" },
				             { label :'main_code', hidden : is_hidden, name : 'main_code', index : 'main_code' },
				             { label :'ECR Name', name : 'main_name', index : 'main_name', classes : 'disables', editable : false, align : 'center', width : 90 }, 
				             { label :'상태', name : 'states_desc', index : 'states_desc', classes : 'disables', editable : false, align : "center", width : 60 },
				             { label :'상태_code', hidden : is_hidden, name : 'states_code', index : 'states_code', classes : 'disables', editable : false },
				             { label :'Related Project', name : 'eng_change_related_project', index : 'eng_change_related_project', editable : true, align : "left", width : 100, hidden : is_hidden },
				             { label :'기술변경내용', name : 'eng_change_description', index : 'eng_change_description', editable : false, edittype : "textarea", 
				            	 editoptions : { 
				            		 rows : "3", 
				            		 cols : "120", 
				            		 dataEvents : [ { type : 'blur', 
				            			 				fn : function( e ) {
				            			 					$( "#desc_layer" ).hide();
			            			 					}
			            		 					}, 
				            		                { type : 'focus', 
		            		 							fn : function( e ) { 
		            		 								$( "#desc_layer" ).show();
	            		 								}
			            		 					}, 
				            		                { type : 'keydown', 
			            		 						fn : function( e ) { 
			            		 							var keyCode = e.keyCode || e.which; 
			            		 							
			            		 							if (keyCode == 9) { 
			            		 								$( "#desc_layer" ).hide();
		            		 								}
		            		 							}
			            		 					} ] }, 
         		 				 width : 600 }, 
				             { label :'관련자', name : 'related_person_emp_name', index : 'related_person_emp_name', align : 'left', width : 220 },
				             { label :'관련자_empno', hidden : is_hidden, name : 'related_person_emp_no', index : 'related_person_emp_no' },
				             { label :'...', name : 'popup_related_person', index : 'popup_related_person', align : "center", width : 30 , hidden : is_hidden},
				             { label :'기술변경원인', name : 'couse_desc', index : 'couse_desc', editable : false, align : 'left', sortable : false, edittype : 'select', editrules : { required : true }, width : 235
				            	 , editoptions: { 
				            		dataEvents: [{				            	
						            	type: 'change'
						            	, fn: function(e) {
						            		var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    
						                    if(e.target.value != '' && e.target.value != null && e.target.value != "undefined") {
						                    	$("#ecrList").jqGrid( 'setCell', rowId, 'eng_change_based_on', e.target.value);
						                    } else {
						                    	$("#ecrList").jqGrid( 'setCell', rowId, 'eng_change_based_on', null);
						                    }
						                }}] 
							 }
				             },
				             { label :'기술변경원인', name : 'eng_change_based_on', index : 'eng_change_based_on', width : 310, editable : false, hidden : true }, 
				             //{ label :'...', name : 'eng_change_based_on', index : 'eng_change_based_on', width : 20, hidden : true }, 
				             //{ label :'평가자', name : 'user_code', index : 'user_code', editable : true, align : 'left', sortable : false, edittype : 'select', formatter : 'select', editrules : { required : true }, width : 225 },  
				             //{ label :'평가자_empno', hidden : is_hidden, name : 'evaluator_emp_no', index : 'evaluator_emp_no', editoptions : { size : 30 } }, 
				             { label :'결재자', name : 'design_engineer', index : 'design_engineer', align : "left", width : 60 }, 
				             { label :'결재자_empno', hidden : is_hidden, name : 'design_engineer_emp_no', index : 'design_engineer_emp_no', editoptions : { size : 30 } }, 
				             { label :'...', name : 'popup_design_engineer', index : 'popup_design_engineer', align : "center", width : 30 , hidden : is_hidden},
				             { label :'작업자', name : 'locker_by_name', index : 'locker_by_name', classes : 'disables', editable : false, align : "left", width : 220, hidden : is_hidden  }, 
				             { label :'작업자_empno', hidden : is_hidden, name : 'locker_by', index : 'locker_by', classes : 'disables', editable : false, align : 'center' }, 
				             { label :'작성자', name : 'created_by_name', index : 'created_by_name', classes : 'disables', editable : false, align : 'left', width : 60 }, 
				             { label :'작성자_empno', hidden : is_hidden, name : 'created_by', index : 'created_by' }, 
				             { label :'oper', hidden : is_hidden, name : 'oper', index : 'oper' } ],
				rowNum : 100,
				cmTemplate: { title: false },
				rowList : [ 100, 500, 1000 ],
				rownumbers:true,
				pager : '#pecrList',
				sortname : 'emp_no',
				viewrecords : true,
				sortorder : "desc",
				//caption : "ECR",
				//shrinkToFit : false,
				autowidth : true,
				height : $(window).height() * 0.5-200,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				//emptyrecords : '데이터가 존재하지 않습니다.',
				imgpath : 'themes/basic/images',
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				afterSaveCell : chmResultEditEnd,
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
					if ( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
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

						if ( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
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
// 					var cm = $( this ).jqGrid( "getGridParam", "colModel" );
// 					var colName = cm[iCol];
// 					if ( rowid != null ) {
// 						var ret = $( "#ecrList" ).jqGrid( 'getRowData', rowid );
						
// 						$( "#ref_main_code" ).val( ret.main_code );

// 						var created_by = $( "#ecrList" ).getCell( rowid, "created_by" );
// 						var locker_by = $( "#ecrList" ).getCell( rowid, "locker_by" );
// 						var evaluator_emp_no = $( "#ecrList" ).getCell( rowid, "evaluator_emp_no" );
// 						var design_engineer_emp_no = $( "#ecrList" ).getCell( rowid, "design_engineer_emp_no" );
// 						var states_desc = $( "#ecrList" ).getCell( rowid, "states_desc" );
// 						var main_code = $( "#ecrList" ).getCell( rowid, "main_code" );
// 						var login_id = $( "#loginid" ).val();
// 						var editFlag = false;
// 						//작성자 : 평가자 상태이더라도 결재전으므로 수정가능
// 						if ( states_desc == "Create" || states_desc == "Evaluate") {
// 							if ( created_by == login_id) {
// 								editFlag = true;
// 							}
// 						}
// 						//평가자
// 						if ( states_desc == "Evaluate" ) {
// 							if ( evaluator_emp_no == login_id && locker_by == login_id ) {
// 								editFlag = true;
// 							}
// 						}
// 						//결재자
// 						if ( states_desc == "Review" ) {
// 							if ( design_engineer_emp_no == login_id && locker_by == login_id ) {
// 								editFlag = true;
// 							}
// 						}
						
// 						if(editFlag || ret.oper == "I") {
// 							// 관련자
// 							if ( colName['index'] == "related_person_emp_name" ) {
// // 								window.open( "mainPopupSearch.do?cmd=popupApproveEmpNo" );
// 								var rs = window.showModalDialog( "popUpApproveEmpNo.do?maincode=" + main_code,
// 										window,
// 										"dialogWidth:830px; dialogHeight:460px; center:on; scroll:off; status:off" );

// 								if ( rs != null ) {
// 									$( "#ecrList" ).setRowData( rowid, { related_person_emp_no : rs[0] } );
// 									$( "#ecrList" ).setRowData( rowid, { related_person_emp_name : rs[1] } );

// 									var item = $( '#ecrList' ).jqGrid( 'getRowData', rowid );

// 									if ( item.oper != 'I' ) {
// 										$( "#ecrList" ).setRowData( rowid, { oper : "U" } );
// 									}
// 								}
// 							}
// 							if(ret.oper == "I"){
// 								// 결재자
// 								if ( colName['index'] == "design_engineer" ) {
// 									var rs = window.showModalDialog( "popUpEmpNoAndRegiter.do?register_type=RME&main_type=ECR",
// 											window,
// 											"dialogWidth:600px; dialogHeight:460px; center:on; scroll:off; status:off" );
									
// 									if ( rs != null ) {
// 										$( "#ecrList" ).setRowData( rowid, { design_engineer_emp_no : rs[0] } );
// 										$( "#ecrList" ).setRowData( rowid, { design_engineer : rs[1] } );
// 										$( "#manufacturing_engineer_reg" ).val( rs[0] );
// 										$( "#manufacturing_engineer_name_reg" ).val( rs[1] );
// 										var item = $( '#ecrList' ).jqGrid( 'getRowData', rowid );

// 										if ( item.oper != 'I' ) {
// 											$( "#ecrList" ).setRowData( rowid, { oper : "U" } );
// 										}
// 									}
// 								}
// 								if ( colName['index'] == "couse_desc" ) {
// 									/* //원인코드 팝업(ECR Based on)
// 									var item = $( '#ecrList' ).jqGrid( 'getRowData', rowid );
// 									var eng_change_cause = item.eng_change_based_on;

// 									var rs = window.showModalDialog( "popUpCause.do?loginid=" + loginId + "&statesCode=" + eng_change_cause,
// 											window,
// 											"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
									
// 									if( rs != null ) {
// 										$( "#ecoList" ).setRowData( rowid, { eng_change_based_on : rs[0] } );
// 										$( "#ecoList" ).setRowData( rowid, { couse_desc : rs[1] } );										
// 									} */
// 								} 
// 							} else {
// 								//$( "#ecrList" ).jqGrid( 'setCell', rowid, 'user_code', '', 'not-editable-cell' );
// 							}
							
// 						} else {
// 							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_related_project', '', 'not-editable-cell' );
// 							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_description', '', 'not-editable-cell' );
// 							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_based_on', '', 'not-editable-cell' );
// 							//$( "#ecrList" ).jqGrid( 'setCell', rowid, 'user_code', '', 'not-editable-cell' );
// 						}
// 					}
				},
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					var ret = $("#ecrList").jqGrid( "getRowData", rowid );
					if ( rowid != null ) {
						var item = $( "#ecrList" ).jqGrid( 'getRowData', rowid );
						
						$( "#ref_main_code" ).val( item.main_code );

						var created_by = item.created_by;
						var locker_by = item.locker_by;
						var design_engineer_emp_no = item.design_engineer_emp_no;
						var states_desc = item.states_desc;
						var main_code = item.main_code;
						var login_id = $( "#loginid" ).val();
						var editFlag = false;
						//작성자 : 평가자 상태이더라도 결재전으므로 수정가능
						if ( states_desc == "Create" || states_desc == "Evaluate") {
							if ( created_by == login_id) {
								editFlag = true;
							}
						}

						//결재자
						if ( states_desc == "Review" ) {
							if ( design_engineer_emp_no == login_id && locker_by == login_id ) {
								editFlag = true;
							}
						}
						
						//관리자
						if(states_desc != "Complete" && $("#admin_yn").val() == 'Y')
						{							
							editFlag = true;							
						}

						if(editFlag) {
							var rs = window.showModalDialog( "popUpEcrnoCreate.do?ecrYN=Y&mainType=ECR&maincode="+main_code+"&related_person_emp_no="+item.related_person_emp_no+
									"&related_person_emp_name="+escape(encodeURIComponent(item.related_person_emp_name))+"&eng_change_based_on="+item.eng_change_based_on+
									"&created_by_name="+item.created_by_name+"&created_by="+item.created_by+
									"&manufacturing_engineer="+item.design_engineer+"&manufacturing_engineer_emp_no="+item.design_engineer_emp_no+
									"&eng_change_description="+escape(encodeURIComponent(item.eng_change_description)),
									"ECRNO",
									"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
							if( rs != null ) {
								$( '#ecrList' ).saveCell( kRow, idCol );
								
								item.oper = 'U';
								item.related_person_emp_no = rs[0];					
								item.related_person_emp_name = rs[1];					
								item.eng_change_based_on = rs[3];
								item.couse_desc = rs[4];
								item.created_by_name = rs[5];
								item.created_by = rs[6];
								item.design_engineer = rs[7];
								item.design_engineer_emp_no = rs[8];
								item.eng_change_description = rs[11];
								
								$('#ecrList').jqGrid("setRowData", rowid, item);
								
								fn_save();
							}							
						} else {
							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_related_project', '', 'not-editable-cell' );
							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_description', '', 'not-editable-cell' );
							$( "#ecrList" ).jqGrid( 'setCell', rowid, 'eng_change_based_on', '', 'not-editable-cell' );
							//$( "#ecrList" ).jqGrid( 'setCell', rowid, 'user_code', '', 'not-editable-cell' );
						}
					}				
				},
				gridComplete : function() {
					var rows = $( "#ecrList" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var created_by = $( "#ecrList" ).getCell( rows[i], "created_by" );
						var locker_by = $( "#ecrList" ).getCell( rows[i], "locker_by" );
						var evaluator_emp_no = $( "#ecrList" ).getCell( rows[i], "evaluator_emp_no" );
						var design_engineer_emp_no = $( "#ecrList" ).getCell( rows[i], "design_engineer_emp_no" );
						var states_desc = $( "#ecrList" ).getCell( rows[i], "states_desc" );
						var oper = $( "#ecrList" ).getCell( rows[i], "oper" );
						var login_id = $( "#loginid" ).val();
						var editFlag = false;
						//작성자
						if ( states_desc == "Create"  || states_desc == "Evaluate") {
							if ( created_by == login_id) {
								editFlag = true;
							}
						}
						//평가자
						if ( states_desc == "Evaluate" ) {
							if ( evaluator_emp_no == login_id && locker_by == login_id ) {
								editFlag = true;
							}
						}
						//결재자
						if ( states_desc == "Review" ) {
							if ( design_engineer_emp_no == login_id && locker_by == login_id ) {
								editFlag = true;
							}
						}
						if(editFlag){
							$("#ecrList").jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#E8DB6B' } );
						}
						if(editFlag || oper =='I'){
							$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'related_person_emp_name', '', { background : 'pink' } );
							$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'main_name', '', {  background : '#DADADA' } );
							$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'states_desc', '', {  background : '#DADADA' } );
							$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'locker_by_name', '', {  background : '#DADADA' } );
							$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'created_by_name', '', {  background : '#DADADA' } );
							if ( oper =='I'){
								$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'design_engineer', '', { background : 'pink' } );	
							} else {
								$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'design_engineer', '', {  background : '#DADADA' } );
								//$( "#ecrList" ).jqGrid( 'setCell', rows[i], 'user_code', '', {  background : '#DADADA' } );
							}
						}						
					}
					
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
					//미입력 영역 회색 표시
					//$("#ecrList .disables").css( "background", "#DADADA" );
					
					//팝업버튼 표시
					//$("#ecrList td:contains('...')").css("background","pink").css("cursor","pointer");
				}
			});
			
			//grid resize
			if( popupDiv == "Y" ) {
				$("#ecrList").setGridHeight(170);
				$( "#p_user_group" ).val( "" );
				fn_search();
			}else{
				fn_gridresize( $(window), $( "#ecrList" ) ,0,0.5);
			}

			$("#ecrList").jqGrid('navGrid', "#pecrList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			//afterSaveCell oper 값 지정
			function chmResultEditEnd( irow, cellName ) {
				var item = $( '#ecrList' ).jqGrid( 'getRowData', irow );
				if (item.oper != 'I')
					item.oper = 'U';

				$( '#ecrList' ).jqGrid( "setRowData", irow, item );
				$( "input.editable,select.editable", this ).attr( "editable", "0" );
			}
			
			/* var afHeight = screen.height * 0.63;
			var reHeight = screen.height * 0.1;

			$( ".ui-jqgrid-titlebar-close" ).click( function() {
				var iframeId = $( selected_tab_name + " iframe" ).attr( 'id' );
				var ifra = document.getElementById( iframeId ).contentWindow;
				
				if ( divCloseFlag ) {
					$( "#tabs" ).css( { "height" : "250px" } );
					$( selected_tab_name + " iframe" ).attr( 'height','200' );
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

			//Del 버튼
			function deleteRow() {
				$( '#ecrList' ).saveCell( kRow, idCol );

				var ids = $( '#ecrList' ).jqGrid( 'getDataIDs' );

				for ( var k = 0; k < ids.length; k++ ) {
					var item = $( '#ecrList' ).jqGrid( 'getRowData', ids[k] );

					if ( item.oper == "D" ) {
						resultData.push( item );

						$( '#ecrList' ).jqGrid( 'delRowData', ids[k] );
					}
				}
			}

			//Add 버튼 
			function addChmResultRow() {
				$( '#ecrList' ).saveCell( kRow, idCol );
				
				var is_new_line = false;
				
				getNewChmResultData( function ( data ) {
					if( data.length == 1 ) {
						alert( "저장 후 생성해주세요." );
						is_new_line = true;
					}
				} );
				
				if( is_new_line ) {
					return;
				}

				var item = {};
				var colModel = $( '#ecrList' ).jqGrid( 'getGridParam', 'colModel' );
				for ( var i in colModel )
					item[colModel[i].name] = '';

				item.oper = 'I';
				item.design_engineer = $( "#manufacturing_engineer_name_reg" ).val();
				item.design_engineer_emp_no = $( "#manufacturing_engineer_reg" ).val();
				item.created_by_name = $( "#design_engineer_name_reg" ).val();
				item.created_by = $( "#design_engineer_reg" ).val();
				
				item.popup_related_person = '...';
				item.popup_design_engineer = '...';

				$( '#ecrList' ).resetSelection();
				$( '#ecrList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			}

			//조회 버튼
			$( "#btnSelect" ).click( function() {
				fn_search();
			} );

			//저장버튼
			$("#btnSave").click( function() {
				fn_save();
			} );
			
			
			/*
			$( "#btnTest" ).click( function() {
				
				var rs = window.showModalDialog( "popUpEcrnoCreate.do?ecrYN=Y&mainType=ECR",
				"ECRNO",
				"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
				if( rs != null ) {
					$( '#ecrList' ).saveCell( kRow, idCol );
					
					// 한줄만 로우됨
					var checkinsert = $("#checkinsert").val();
		
					var item = {};
					var colModel = $( '#ecrList' ).jqGrid( 'getGridParam', 'colModel' );
					
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
		
					$( '#ecrList' ).resetSelection();
					$( '#ecrList' ).jqGrid( 'addRowData', "new", item, 'first' );
					
					tableId = '#ecrList';
		
					$( "#checkinsert" ).val( "I" );
				
					$( "#created_by" ).val(rs[6]);
					$( "#created_by_name" ).val( rs[5] );
					$( "#user_group" ).val( rs[9] );
					$( "#user_group_name" ).val( rs[10] );
				}
			});
			*/
			//Create 버튼
			$( "#btnCreateECR" ).click( function() {
				//addChmResultRow();
				var rs = window.showModalDialog( "popUpEcrnoCreate.do?ecrYN=Y&mainType=ECR",
						"ECRNO",
						"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
				if( rs != null ) {
					$( '#ecrList' ).saveCell( kRow, idCol );
					
					// 한줄만 로우됨
					var checkinsert = $("#checkinsert").val();

					var item = {};
					var colModel = $( '#ecrList' ).jqGrid( 'getGridParam', 'colModel' );					
					
					for( var i in colModel )
						item[colModel[i].name] = '';
					
					item.oper = 'I';
					item.related_person_emp_no = rs[0];					
					item.related_person_emp_name = rs[1];					
					//item.eng_change_cause = rs[2];
					item.eng_change_based_on = rs[3];
					item.couse_desc = rs[4];
					item.created_by_name = rs[5];
					item.created_by = rs[6];
					item.design_engineer = rs[7];
					item.design_engineer_emp_no = rs[8];
					//item.user_group = rs[9];
					//item.user_group_name = rs[10];
					item.eng_change_description = rs[11];
					item.states_desc = 'Create';

					$( '#ecrList' ).resetSelection();
					$( '#ecrList' ).jqGrid( 'addRowData', "new", item, 'first' );
					
					tableId = '#ecrList';

					$( "#checkinsert" ).val( "I" );
					
					fn_save();
				
					//$( "#created_by" ).val(rs[6]);
					//$( "#created_by_name" ).val( rs[5] );
					//$( "#user_group" ).val( rs[9] );
					//$( "#user_group_name" ).val( rs[10] );
				}
			} );
			
			//그리드 내 콤보박스 바인딩
			//ECR 평가자
			/* $.post( "ecrEvaluatorList.do", "", function( data ) {
				$( '#ecrList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'user_code',
					data : data.rows
				} );
			}, "json" ); */

			//ECR Based on
			$.post( "ecrBasedList.do", "", function( data ) {
				$( '#ecrList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'couse_desc',
					data : data.rows
				} );
			}, "json" );
			
			//닫기
			$( '#btncancle' ).click( function() {
				self.close();
			});

			//Summary Report
			$( "#btnSummaryReport" ).click( function() {
				var maincode = $( "#ref_main_code" ).val();

				if (maincode == "") {
					alert( "ECR을 선택해주세요." );
					return;
				}
				
				//alert(maincode);

				fn_PopupReportCall( "STXDISECR.mrd", maincode );
			} );
			
			//사번 조회 팝업... 버튼
			$( "#btnEmpNo" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do", 
						"ECR",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_created_by" ).val( rs[0] );
					$( "#p_created_by_name" ).val( rs[1] );
					$( "#p_user_group" ).val( rs[2] );
					$( "#p_user_group_name" ).val( rs[3] );
				}
			} );
			
			//사번 조회 팝업... 버튼
			$( "#btnEmpNo2" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do?loginid=" + $( "#loginid" ).val(),
						"ECR",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_locker_by" ).val(rs[0]);
					$( "#p_locker_by_name" ).val( rs[1] );
				}
			} );
			
			//부서 조회 팝업... 버튼
			$( "#btnGroupNo" ).click( function() {
				var rs = window.showModalDialog( "popUpGroup.do", 
						"ECR",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_user_group" ).val( rs[0] );
					$( "#p_user_group_name" ).val( rs[1] );
				}
			} );
			
			$( "#btnExcelDownload" ).click( function() {
				fn_excelDownload();
			} );

			fn_weekDate( "p_created_date_start", "p_created_date_end" );
			
			fn_register();
			
			if( popupDiv == 'Y' || $( "#main_appr" ).val() == 'Y') {
				fn_search();
			}
			
		} ); //$(document).ready( function() {
			
		$( function() {
			var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
				prevText: '이전 달',
				nextText: '다음 달',
				monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				dayNames: ['일','월','화','수','목','금','토'],
				dayNamesShort: ['일','월','화','수','목','금','토'],
				dayNamesMin: ['일','월','화','수','목','금','토'],
				dateFormat: 'yy-mm-dd',
				showMonthAfterYear: true,
				yearSuffix: '년',
				onSelect: function( selectedDate ) {
					var option = this.id == "p_created_date_start" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
					dates.not( this ).datepicker( "option", option, date );
				}
			} );
		} );
	
		//design engineer 등 가져오기
		function fn_register() {
			if( popupDiv == "Y" ) {
				$(".hidden_ecr").hide();
			} else {
				$(".hidden_ecr").show();
				$(".only_popup").hide();
				
			}
		
			var url = 'infoEmpNoRegisterList.do';
			var formData = getFormData( '#application_form' );
	
			$.post( url, formData, function( data ) {
				for ( var i = 0; i < data.length; i++ ) {
					if ( data[i].register_type == "RDE" ) {
						$( "#design_engineer_reg" ).val( data[i].sub_emp_no );
						$( "#design_engineer_name_reg" ).val( data[i].user_name );
					}
					if( data[i].register_type == "RME" ) {
						$( "#manufacturing_engineer_reg" ).val( data[i].sub_emp_no );
						$( "#manufacturing_engineer_name_reg" ).val( data[i].user_name );
					}
				}
			}, "json" );
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
	
		//tab change event
		function fn_tab_link( tab_name ) {
			if( tab_name == "#tabs-1" ) {
				document.getElementById('history').contentWindow.fn_search();
				/* $( "#history" ).attr( "src", "ecrHistory.do?divCloseFlag=" + divCloseFlag ); */
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			} else if( tab_name == "#tabs-2" ) {
				document.getElementById('ecrLifeCycle').contentWindow.fn_search();
				//$( "#ecrLifeCycle" ).attr( "src", "ecrLifeCycle.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			} else if( tab_name == "#tabs-3" ) {
				document.getElementById('routeList').contentWindow.fn_search();
				//$( "#routeList" ).attr( "src", "ecrRoute.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			} else if( tab_name == "#tabs-4" ) {
				document.getElementById('docList').contentWindow.fn_search();
				//$( "#docList" ).attr( "src", "doc.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			} else if( tab_name == "#tabs-5" ) {
				document.getElementById('relatedECOsList').contentWindow.fn_search();
				//$( "#relatedECOsList" ).attr("src", "ecrRelatedECOs.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			} else {
				$( "#history" ).attr( "src", "ecrHistory.do?divCloseFlag=" + divCloseFlag );
				//fn_divCloseFalg( divCloseFlag, $( selected_tab_name + " iframe" ).attr( 'id' ) );
			}
		}
	
		//custom check event
		function fn_chkbox( obj ) {
			if ( obj.checked ) {
				$( "#ecrList" ).setRowData( obj.value, { oper : "D" } );
			} else {
				$( "#ecrList" ).setRowData( obj.value, { oper : "U" } );
			}
		}
	
		//require check
		function fn_require_chk( obj ) {
			for ( var b = 0; b < obj.length; b++ ) {
	
				if ( obj[b].oper == "D" ) {
					return true;
				}
	
				//필수요소 확인
				/* if ( obj[b].eng_change_related_project == "" ) {
					alert( "Related Project는 필수입력입니다." );
					return false;
				} */
				
				if ( obj[b].related_person_emp_name == "" ) {
					alert( "관련자는 필수입력입니다." );
					return false;
				}
	
				if ( obj[b].eng_change_description == "" ) {
					alert( "기술변경내용은 필수입력입니다." );
					return false;
				}
	
				if ( obj[b].eng_change_based_on == "" ) {
					alert( "기술변경원인은 필수입력입니다." );
					return false;
				}
	
				//필수요소 확인
				/* if ( obj[b].user_code == "" ) {
					alert( "ECR평가자는 필수입력입니다." );
					return false;
				} */
	
				if ( obj[b].design_engineer_emp_no == "" ) {
					alert( "결재자는 필수입력입니다." );
					return false;
				}
	
				return true;
			}
		}
	
		//재 조회시 호출
		var tabNStr = undefined;
		function fn_search(tabNStrP) {
			if(tabNStrP != undefined) tabNStr = tabNStrP;
		
			//var sUrl = "ecrList.do";
			$( "#ecrList" ).jqGrid( "clearGridData" );
			$( "#ecrList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
	
			$( "#locker_by" ).val( "" );
			$( "#main_code" ).val( "" );
			$( "#sTypeName" ).val( "" );
			$( "#states_code" ).val( "" );
			$( "#states_desc" ).val( "" );
			$( "#ref_main_name" ).val( "" );
			$( "#ref_main_code" ).val( "" );
	
			//fn_tab_link( selected_tab_name );
		}
		
		function fn_save() {
			$( '#ecrList' ).saveCell( kRow, idCol );
			
			var chmResultRows = [];
			getChangedChmResultData( function( data ) {
				chmResultRows = data;
				
				//수정 유무 체크
				if ( !fn_checkGridModify( "#ecrList" ) ) {
					return;
				}

				//필수입력 체크
				if ( !fn_require_chk( chmResultRows ) ) {
					return;
				}

				//저장 유무 체크
				if ( !confirm( "변경된 데이터를 저장하시겠습니까?" ) ) {
					return;
				}
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

				var url = 'saveEcr.do';
				var formData = getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

				$.post( url, parameters, function( data2 ) {
					lodingBox.remove();
					
					alert(data2.resultMsg);
					if ( data2.result == 'success' ) {					
						fn_search();
					}
					
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	lodingBox.remove();	
				} );
			} );
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep($("#ecrList").jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});

			callback.apply( this, [ changedData.concat( resultData ) ] );
		}
		
		function getNewChmResultData( callback ) {
			var changedData = $.grep($("#ecrList").jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I';
			});

			callback.apply( this, [ changedData.concat( resultData ) ] );
		}
		
		//작성자 조회조건 삭제 시 작성자명 초기화
		function fn_clear() {
			if ( $( "#p_created_by" ).val() == "" ) {
				$( "#p_created_by_name" ).val( "" );
			}
		}
		
		//부서 조회조건 삭제 시 부서명 초기화
		function fn_clear2() {
			if ( $( "#p_user_group" ).val() == "" ) {
				$( "#p_user_group_name" ).val( "" );
			}
		}
		
		function fn_excelDownload() {
			
			var rows = $( "#ecrList" ).getDataIDs();

			if( rows.length == 0 ) {
				alert( "조회된 데이터가 없습니다." );
				return;
			}
		
			var main_name = $( "#p_main_name" ).val();
			var created_by = $( "#p_created_by" ).val();
			var user_group = $( "#p_user_group" ).val();
			var created_date_start = $( "#p_created_date_start" ).val();
			var created_date_end = $( "#p_created_date_end" ).val();
	
			location.href = './ecrExcelExport.do?p_main_name=' + main_name + '&p_created_by=' + created_by + "&p_user_group=" + user_group + "&p_created_date_start=" + created_date_start + "&p_created_date_end=" + created_date_end;
		}
		
		//Radio 생성
		function formatOpt1( cellvalue, options, rowObject ) {
			if( rowObject.enable_flag == "" || rowObject.enable_flag == undefined ) {
				var rowid = options.rowId;
		   		var str ="<input type='radio' name='checkbox' id="+rowid+"_chkBoxOV value=" + cellvalue + " onclick='fn_checkRadio(\""+rowid+"\")' />";
				return str;
			}
		}
		
		//Radio 선택 시 하단 tab에 바인딩하기위한 hidden 값설정
		function fn_checkRadio( rowid ) {
			lastSelectedRowId = rowid;
			if ( rowid != null ) {
				var item = $( '#ecrList' ).jqGrid( 'getRowData', rowid );
				var main_code = item.main_code;
				var locker_by = item.locker_by;
				var states_code = item.states_code;
				var states_desc = item.states_desc;
				var ref_main_name = item.main_name;
				var eng_change_based_on = item.eng_change_based_on;
				
				$( "#locker_by ").val( locker_by );
				$( "#main_code ").val( main_code );
				$( "#sTypeName ").val( "ECR" );
				$( "#states_code ").val( states_code );
				$( "#states_desc ").val( states_desc );
				$( "#ref_main_name ").val( ref_main_name );
				$( "#ref_main_code" ).val( main_code );
				$( "#eng_change_based_on" ).val( eng_change_based_on );
				
				if($("#checkPopup").val() != 'Y') {
					fn_tab_link( selected_tab_name );
				}
			}
		}
		</script>
	</body>
</html>
