<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>DB Master</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
<body>
<form name="listForm" id="listForm"  method="get">

<input type="hidden" id="p_item_code" name="p_item_code" value="" />

<div id="mainDiv" class="mainDiv">

<input type="hidden" id="p_col_name" name="p_col_name" value="" />
<input type="hidden" id="p_data_name" name="p_data_name" value="" />
<input type="hidden" id="page" name="page" value="" />
<input type="hidden" id="rows" name="rows" value="" />

<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
<input type="hidden" id="etc" name="etc" value="${etc}"/>
<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
<input type="hidden" id="loginGubun" value="">

<input type="hidden" id="is_manager" value="N">

<div class= "subtitle">
DB Master
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
	<c:if test="${etc == 'Y'}">
		<table class="searchArea conSearch">
			<tr>
				<td>
					<div class="button endbox">
						<input type="button" class="btn_blue" name="searchMode" value="기준정보 등록요청" onclick="location.href='standardInfoTrans.do'">
						<input type="button" class="btn_blue" name="searchMode" value="품목분류표" onclick="location.href='itemCategoryView.do'">
						<input type="button" class="btn_blue" name="searchMode" value="부품표준서" onclick="location.href='itemStandardView.do'">
					</div>
				</td>
			</tr>
		</table>
	</c:if>
	<table class="searchArea conSearch">
		<col width="50">
		<col width="100">
		<col width="60">
		<col width="125">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">

		<tr>
			<th>선종</th>
			<td>
				<input type="text" id="p_Ship_kind" maxlength="10" name="p_Ship_kind" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>기자재명</th>
			<td>
				<input type="text" id="p_Equipment_name" maxlength="10" name="p_Equipment_name" style="width:100px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>구매자</th>
			<td>
				<input type="text" id="p_Ship_charge" maxlength="10" name="p_Ship_charge" style="width:75px;"/>
			</td>
			 
			<th>OPTION</th>
			<td>
				<input type="text" id="p_Ems_option" maxlength="10" name="p_Ems_option" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>JOB</th>
			<td>
				<input type="text" id="p_Ems_job" maxlength="10" name="p_Ems_job" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>중분류</th>
			<td>
				<input type="text" id="p_Middle_code" maxlength="10" name="p_Middle_code" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>

			<td style="border-left:none;">
				<div class="button endbox">					
						<input type="button" value="EXPORT" id="btnExport"  class="btn_blue2" />					
						<input type="button" value="SAVE" id="btnSave"  class="btn_blue2" />					
						<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />					
				</div>
			</td>						
		</tr>
		
	</table>

	<table class="searchArea2">
		<col width="50">
		<col width="100">
		<col width="60">
		<col width="125">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="100">
		<col width="70">
		<col width="100">
		<col width="">

		<tr>
			<th>선형</th>
			<td style="height:30px;">
				<input type="text" id="p_Ship_face" maxlength="10" name="p_Ship_face" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>DWG NO.</th>
			<td>
				<input type="text" id="p_Dwg_no" maxlength="10" name="p_Dwg_no" style="width:100px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>CATALOG</th>
			<td>
				<input type="text" id="p_Catalog_code" maxlength="10" name="p_Catalog_code" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			 
			<th>설계부서</th>
			<td>
				<input type="text" id="p_Plan_part" maxlength="10" name="p_Plan_part" style="width:75px;"/>
			</td>
			
			<th>ZONE</th>
			<td>
				<input type="text" id="p_Ems_zone" maxlength="10" name="p_Ems_zone" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>GROUP</th>
			<td>
				<input type="text" id="p_Ems_group" maxlength="10" name="p_Ems_group" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>ACTIVITY</th>
			<td>
				<input type="text" id="p_Activity" maxlength="10" name="p_Activity" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			<td>
				<div class="button endbox">
					<input type="button" value="ITEM관리" id="btnMaster" class="btn_blue2"/>
					<input type="button" value="납기관리자" id="btnMan" class="btn_blue2"/>
					<input type="button" value="도움말" id="btnHelp" class="btn_blue2"/>	
				</div>
			</td>
		</tr>

	</table>
			
	<table class="searchArea2">
		<col width="50">
		<col width="130">
		<col width="">
		
		<tr>
			<th>권한</th>
			<td style="height:30px;">
				
				<fieldset style="border:none;width: 130px; display: inline;  height:20px; line-height:20px">		
					<input id="r_plan" type="radio" name="loginGubun" value="plan" onclick="loginGubun_changed(this.value)"><label id="l_plan" for="plan">설계</label>&nbsp;					
					<input id="r_obtain" type="radio" name="loginGubun" value="obtain" onclick="loginGubun_changed(this.value)"><label id="l_obtain" for="obtain">구매</label>&nbsp;
					<input id="r_product" type="radio" name="loginGubun" value="product" onclick="loginGubun_changed(this.value)"><label id="l_product" for="product">생산</label>
				</fieldset>
			</td>
			<td style="border-left:none;">
				
			</td>
		</tr>

	</table>		
	<div class="content">
		<table id = "dbMasterGrid"></table>
		<div   id = "btnitemTransList"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

var idRow = 0;
var idCol = 0;
var nRow = 0;
var kRow = 0;
var row_selected = 0;

var change_plan_row 	= 0;
var change_plan_row_num = 0;
var change_plan_col  	= 0;

var tableId	   			= "#dbMasterGrid";
var deleteData 			= [];

var resultData = [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'선종', name:'ship_type', index:'ship_type', width:30, align:'center', sortable:false, frozen : true});
	gridColModel.push({label:'선형', name:'ship_size', index:'ship_size', width:30, align:'center', sortable:false, frozen : true});
	gridColModel.push({label:'기자재명', name:'equip_name', index:'equip_name', width:220, align:'left', sortable:false, frozen : true});
	gridColModel.push({label:'DWG No.', name:'dwg_code', index:'dwg_code', width:70, align:'center', sortable:false, frozen : true});
	gridColModel.push({label:'Item Code', name:'item_code', index:'item_code', width:110, align:'center', sortable:false, frozen : true});
	gridColModel.push({label:'ITEM DESCRIPTION', name:'item_desc', index:'item_desc', width:300, align:'left', sortable:false, frozen : true});
	gridColModel.push({label:'항차', name:'voyage_no', index:'voyage_no', width:30, align:'center', formatter:formatOpt2, sortable:false});
	gridColModel.push({label:'설치위치', name:'bom_stage', index:'bom_stage', width:55, editoptions:{size:3, maxlength: 3}, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'설치시점', name:'bom_level', index:'bom_level', width:55, editoptions:{size:3, maxlength: 3}, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'EVENT', name:'dock_event_f', index:'dock_event_f', width:45, align:'center', sortable:false, editable:true, edittype:"select", editoptions:{value:":; SC:SC; KL:KL; LC:LC; DL:DL"}});
	gridColModel.push({label:'LAG', name:'dock_lag_f', index:'dock_lag_f', width:45, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'EVENT', name:'dock_event_t', index:'dock_event_t', width:45, align:'center', sortable:false, editable:true, edittype:"select", editoptions:{value:":; SC:SC; KL:KL; LC:LC; FO:FO; DL:DL"}});
	gridColModel.push({label:'LAG', name:'dock_lag_t', index:'dock_lag_t', width:45, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'EVENT', name:'skid_event_f', index:'skid_event_f', width:45, align:'center', sortable:false, editable:true, edittype:"select", editoptions:{value:":; SC:SC; KL:KL; LO:LO; LC:LC; DL:DL"}});
	gridColModel.push({label:'LAG', name:'skid_lag_f', index:'skid_lag_f', width:45, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'EVENT', name:'skid_event_t', index:'skid_event_t', width:45, align:'center', sortable:false, editable:true, edittype:"select", editoptions:{value:":; SC:SC; KL:KL; SD:SD; LO:LO; LC:LC; DL:DL"}});
	gridColModel.push({label:'LAG', name:'skid_lag_t', index:'skid_lag_t', width:45, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'EVENT', name:'fdock_event_f', index:'fdock_event_f', width:45, align:'center', sortable:false, editable:true, edittype:"select", editoptions:{value:":; SC:SC; KL:KL; LC:LC; DL:DL"}});
	gridColModel.push({label:'LAG', name:'fdock_lag_f', index:'fdock_lag_f', width:45, align:'center', sortable:false, editable:true});
	gridColModel.push({label:'REV.', name:'rev', index:'rev', width:30, align:'center', sortable:false});
	gridColModel.push({label:'M/A', name:'main_accessaries', index:'main_accessaries' ,width:50 ,align:'center', sortable:false, title:false});
	gridColModel.push({label:'납기기준', name:'equip', index:'equip', width:55, align:'center', sortable:false});
	gridColModel.push({label:'조달 L/T', name:'obtain_lt' , index:'obtain_lt' ,width:50 ,align:'center', formatter:formatOpt2, sortable:false, title:false});
	gridColModel.push({label:'직투', name:'is_direct_input', index:'is_direct_input', width:30, align:'center', sortable:false});
	gridColModel.push({label:'중요도', name:'importance', index:'importance', width:40, align:'center', sortable:false});
	gridColModel.push({label:'구매담당자', name:'buyer', index:'buyer', width:70, align:'center', sortable:false});
	gridColModel.push({label:'설계파트', name:'plan_part', index:'plan_part', width:120, align:'center', sortable:false});
	gridColModel.push({label:'요청사유', name:'require_reason', index:'require_reason', width:80, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'승인/거부사유', name:'app_rej_reason', index:'app_rej_reason', width:80, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'중분류', name:'middle_code', index:'middle_code', width:60, align:'center', sortable:false});
	gridColModel.push({label:'중분류명', name:'middle_name', index:'middle_name', width:200, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'Catalog', name:'catalog_code', index:'catalog_code', width:50, align:'center', sortable:false});
	gridColModel.push({label:'Catalog명', name:'catalog_name', index:'catalog_name', width:200, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'OPTION', name:'ems_option', index:'ems_option', width:50, align:'center', sortable:false});
	gridColModel.push({label:'BLOCK', name:'ems_block', index:'ems_block', width:50, align:'center', sortable:false});
	gridColModel.push({label:'JOB', name:'ems_job', index:'ems_job', width:50, align:'center', sortable:false});
	gridColModel.push({label:'ZONE', name:'ems_zone', index:'ems_zone', width:50, align:'center', sortable:false});
	gridColModel.push({label:'ACTIVITY', name:'ems_activity', index:'ems_activity', width:50, align:'center', sortable:false});
	gridColModel.push({label:'GROUP', name:'ems_group', index:'ems_group', width:50, align:'center', sortable:false});
	gridColModel.push({label:'최초등록자', name:'created_by', index:'created_by', width:70, align:'center', sortable:false});
	gridColModel.push({label:'최초등록일', name:'creation_date', index:'creation_date', width:70, align:'center', sortable:false});
	gridColModel.push({label:'Mother Buy', name:'mother_buy', index:'mother_buy', width:100, align:'center', sortable:false});
	gridColModel.push({label:'Mother Buy명', name:'mother_buy_desc', index:'mother_buy_desc', width:200, align:'left', sortable:false});
	gridColModel.push({name:'oper', index:'oper', hidden:true});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	
	fn_buttonDisabled2([ "#btnMan" ]); // 초기 화면 '납기관리자' 버튼 비활성화

	// 접속권한에 따른 설정 
	$.post( "emsDbMasterLoginGubun.do", "", function( data ) {

		// ●납기관리자 일때
		if(data.ems_manager == 'product'){
			$("#is_manager").val("Y");
			fn_buttonEnable2([ "#btnMan" ]); // '납기관리자' 버튼 활성화
			
			if(data.emp_no == '211055'){ // 설계,생산,구매 권한
				$("input:radio[name='loginGubun']:radio[value='plan']").attr("checked",true);
				$("#loginGubun").val("plan");
			} else if(data.ems_gubun == 'plan'){ // 설계,생산 권한
				$('#r_obtain').hide();
				$('#l_obtain').hide();
				$("input:radio[name='loginGubun']:radio[value='plan']").attr("checked",true);
				$("#loginGubun").val("plan");
			} else { // 생산,구매 권한
				$('#r_plan').hide();
				$('#l_plan').hide();
				$("input:radio[name='loginGubun']:radio[value='obtain']").attr("checked",true);
				$("#loginGubun").val("obtain");
			}
		}
		// ●납기관리자 아닐때
		else {
			$('#r_plan').hide();
			$('#l_plan').hide();
			$('#r_product').hide();
			$('#l_product').hide();
			$('#r_obtain').hide();
			$('#l_obtain').hide();
			if(data.ems_gubun == 'plan'){ // 설계 권한
				$("#loginGubun").val(data.ems_gubun);
			}
		}
		
	}, "json" );
	

	$("#dbMasterGrid").jqGrid({ 
             datatype	: 'json',              
             url		: '',
             mtype		: '', 
             postData : fn_getFormData( "#listForm" ),
             colModel: gridColModel,
	                 gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 0,
		             shrinkToFit:false,
		             cellEdit	: true,             // grid edit mode 1
			         cellsubmit	: 'clientArray',  	// grid edit mode 2
		             pager: jQuery('#btnitemTransList'),
		             rowList:[100,500,1000],
			         rowNum:100,
			         beforeSaveCell : chmResultEditEnd,
					 beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
		             	idRow=rowid;
		             	idCol=iCol;
		             	kRow = iRow;
		             	kCol = iCol;
		   			 },
					 jsonReader : {
		                 root: "rows",
		                 page: "page",
		                 total: "total",
		                 records: "records",  
		                 repeatitems: false,
		                },        
		             imgpath: 'themes/basic/images',
		             onPaging: function(pgButton) {
						$(this).jqGrid("clearGridData");
			 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
					 },
		   			 loadComplete: function (data) {
		   				var rows = $( "#dbMasterGrid" ).getDataIDs();

		   				/******* 그리드 색깔 변경 *******/
		   				for (var i = 0; i < rows.length; i++) {
		   					//그리드 색깔 초기화
		   					$( "#dbMasterGrid" ).jqGrid( 'setCell', rows[i], false, { background : '#FFFFFF' } );
			   				//권한 : 설계 선택 시 색깔 변경
			   				if($("#loginGubun").val() == "plan"){
								$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'bom_stage', '', { background : '#FFFFCC' } );
								$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'bom_level', '', { background : '#FFFFCC' } );
			   				}
			   				//권한 : 납기관리자 권한 있을시 색깔 변경
			   				if($("#is_manager").val() == "Y"){
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'dock_event_f', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'dock_lag_f', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'dock_event_t', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'dock_lag_t', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'skid_event_f', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'skid_lag_f', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'skid_event_t', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'skid_lag_t', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'fdock_event_f', '', { background : '#FFFFCC' } );
			   					$("#dbMasterGrid").jqGrid( 'setCell', rows[i], 'fdock_lag_f', '', { background : '#FFFFCC' } );
			   				}
		   				
		   				}
		   				
		   				/******* 그리드 편집 활성화, 비활성화 *******/
		   				//그리드 편집 권한 모두 비활성화
		   				changeEditableByContain($("#dbMasterGrid"), 'bom_stage','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'bom_level','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'dock_event_f','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'dock_lag_f','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'dock_event_t','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'dock_lag_t','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'skid_event_f','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'skid_lag_f','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'skid_event_t','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'skid_lag_t','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'fdock_event_f','', true);
					    changeEditableByContain($("#dbMasterGrid"), 'fdock_lag_f','', true);
		   				//권한 : 설계 선택 시 편집 활성화
		   				if($("#loginGubun").val() == "plan"){
		   					changeEditableByContain($("#dbMasterGrid"), 'bom_stage','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'bom_level','', false);	
		   				}
		   				//권한 : 납기관리자 권한 있을시 그리드 편집 설정
		   				if($("#is_manager").val() == "Y"){
		   					changeEditableByContain($("#dbMasterGrid"), 'dock_event_f','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'dock_lag_f','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'dock_event_t','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'dock_lag_t','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'skid_event_f','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'skid_lag_f','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'skid_event_t','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'skid_lag_t','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'fdock_event_f','', false);
						    changeEditableByContain($("#dbMasterGrid"), 'fdock_lag_f','', false);
		   				}
		   				
		   				
					    var $this = $(this);
					    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
					        $this.jqGrid('setGridParam', {
					            datatype: 'local',
					            data: data.rows,
					            pageServer: data.page,
					            recordsServer: data.records,
					            lastpageServer: data.total
					        });
					        this.refreshIndex();					
					        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
					            $this.triggerHandler('reloadGrid');
					        }
					    } else {
					        $this.jqGrid('setGridParam', {
					            page: $this.jqGrid('getGridParam', 'pageServer'),
					            records: $this.jqGrid('getGridParam', 'recordsServer'),
					            lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
					        });
					        this.updatepager(false, true);
					    }					    

					 },
					 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
			            	if (name == "bom_stage" || name == "bom_level") setUpperCase('#dbMasterGrid',rowid,name);
					 }
						
     });
	
	//jqGrid 크기 동적화
	if($("#etc").val() == 'Y'){
		fn_gridresize( $(window), $( "#dbMasterGrid" ), 120 );
	}else{
		fn_gridresize( $(window), $( "#dbMasterGrid" ), 90 );
	}
 	
	
	jQuery("#dbMasterGrid").jqGrid('setGroupHeaders', {
		  useColSpanStyle: true, 
		  groupHeaders:[
			{startColumnName: 'dock_event_f', numberOfColumns: 2, titleText: 'DRY DOCK_F'},
			{startColumnName: 'dock_event_t', numberOfColumns: 2, titleText: 'DRY DOCK_T'},
			{startColumnName: 'skid_event_f', numberOfColumns: 2, titleText: 'SKID BERTH_F'},
			{startColumnName: 'skid_event_t', numberOfColumns: 2, titleText: 'SKID BERTH_T'},
			{startColumnName: 'fdock_event_f', numberOfColumns: 2, titleText: 'FLOATING'}
		  ]	
		});

	


});  //end of ready Function 	

var loginGubun = $("#loginGubun").val();
var str001 = "";var str002 = "";var str003 = "";var str004 = "";var str005 = "";var str006 = "";
var str007 = "";var str008 = "";var str009 = "";var str010 = "";var str011 = "";var str012 = "";

//그리드 내 입력시 대문자 자동 변환 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

$(document).ready(function(){

	//key evant 
	$("input[type=text]").keypress(function(event) {
	  if (event.which == 13) {
	        event.preventDefault();
	        $('#btnSearch').click();
	    }
	});	


});

//afterSaveCell oper 값 지정
function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $( '#dbMasterGrid' ).jqGrid( 'getRowData', irowId );

	item.oper = 'U';
	$('#dbMasterGrid').jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	
	$( '#dbMasterGrid' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
}

/* 라디오 버튼 변경 이벤트 */
function loginGubun_changed(value){
	
	var rows = $("#dbMasterGrid").getDataIDs();
	var jqGridObj = $("#dbMasterGrid");
	
	search();

	//권한 : 설계 선택 시
	if(value == "plan"){
		$("#loginGubun").val("plan");
		//fn_buttonEnable([ "#btnMaster" ]); // 'Master Item 관리' 버튼 활성화
	}
	//권한 : 생산 선택 시 
	else if(value == "product"){
		$("#loginGubun").val("product");
		//fn_buttonDisabled([ "#btnMaster" ]); // 'Master Item 관리' 버튼 활성화
	}
	//권한 : 구매 선택 시
	else if(value == "obtain"){
		$("#loginGubun").val("obtain");
		//fn_buttonEnable([ "#btnMaster" ]); // 'Master Item 관리' 버튼 활성화
	}
}

//######## 조회 버튼 클릭 시 ########//
$("#btnSearch").click(function(){			
	search();					
});	

//######## 도움말 버튼 클릭 시 ########//
$("#btnHelp").click(function(){							
	$.download('/download/doc_equip_standard_r0.pdf',null,'post','_blank' ); //새창에서 열기
	//$.download('fileDownload.do?fileName=doc_equip_standard_r0.pdf',null,'post'); //다운로드
});	

//######## Export 버튼 클릭 시 ########//
$("#btnExport").click(function(){				
	//그리드의 label과 name을 받는다.
	//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
	var colName = new Array();
	var dataName = new Array();
	
	for(var i=0; i<gridColModel.length; i++ ){
		if(gridColModel[i].hidden){
			continue;
		}
		colName.push(gridColModel[i].label);
		dataName.push(gridColModel[i].name);
	}
	
	form = $('#listForm');

	$("input[name=p_is_excel]").val("Y");
	//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
	
	$("#p_col_name").val(colName);
	$("#p_data_name").val(dataName);
	$("#rows").val($("#dbMasterGrid").getGridParam("rowNum"));
	$("#page").val($("#dbMasterGrid").getGridParam("page"));
	
	fn_downloadStart();
	form.attr("action", "emsDbMasterExcelExport.do?");
	
	form.attr("target", "_self");	
	form.attr("method", "post");	
	form.submit();
});	

//######## Master Item 관리 버튼 클릭 시 ########//
$("#btnMaster").click(function(){
	fn_new();				
});			

//신규 생성 화면 호출
function fn_new() {
	
	if (win != null){
   		win.close();
   	}
	//win = window.showModalDialog("popUpEmsDbMasterItem.do?menu_id=${menu_id}&user_id=${loginUser.user_id}&user_name=${loginUser.user_name}&loginGubun=" + $("#loginGubun").val(), args,"dialogWidth:1400px; dialogHeight:830px; center:on; scroll:off; status:off; location:no");
	win = window.open("popUpDbMasterItem.do?menu_id=${menu_id}&user_id=${loginUser.user_id}&user_name=${loginUser.user_name}&loginGubun=" + $("#loginGubun").val(), "","width=1400px,height=830px,scrollbar=yes,status=no,location=no");
}

//########  저장버튼 ########//
$("#btnSave").click(function(){
	
	var logingubun = $('#loginGubun').val();

	var itemcodes = "";
	var item_codes = "'";
	
	$( '#dbMasterGrid' ).saveCell( kRow, idCol );
	
	//변경 사항 Validation
	if( !fn_checkValidate() ) {
		return;
	}
	
	if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
		var chmResultRows = [];
		
		getChangedChmResultData(function( data ) {
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'saveEmsDbMaster.do';
			var formData = fn_getFormData( '#listForm' );
			var parameters = $.extend( {}, dataList, formData );

			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, parameters, function(json) {
				alert(json.resultMsg);
				if ( json.result == 'success' ) {
					search();
				}
			}, "json").error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				loadingBox.remove();
			} );
		} );
	}
		
});

//변경 사항 Validation 
function fn_checkValidate() {
	var result = true;
	var message = "";
	var nChangedCnt = 0;
	var ids = $( "#dbMasterGrid" ).jqGrid( 'getDataIDs' );

	var logingubun = $('#loginGubun').val(); //권한

	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'U') {
			nChangedCnt++;
			
			/******* 권한이 '설계' 일때 *******/
			if(logingubun == 'plan'){
				// 설치위치 미입력 여부 확인
				var val1 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'bom_stage' );
				if ( $.jgrid.isEmpty( val1 ) ) {
					alert( "설치위치를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'bom_stage' );
					break;
				}
				// 설치시점 미입력 여부 확인
				var val2 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'bom_level' );
				if ( $.jgrid.isEmpty( val2 ) ) {
					alert( "설치위치를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'bom_level' );
					break;
				}
			}
			
			/******* 권한이 '납기관리자' 일때 *******/
			if($("#is_manager").val() == "Y"){
				
				// DRY DOCK_F
				var DDF_E = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_event_f' );
				var DDF_L = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_lag_f' );
				if(DDF_E == '' && DDF_L != ''){
					alert( "DRY DOCK_F(EVENT)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_event_f' );
					break;
				}
				if(DDF_E != '' && DDF_L == ''){
					alert( "DRY DOCK_F(LAG)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_lag_f' );
					break;
				}
				
				// DRY DOCK_T
				var DDT_E = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_event_t' );
				var DDT_L = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_lag_t' );
				if(DDT_E == '' && DDT_L != ''){
					alert( "DRY DOCK_T(EVENT)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_event_t' );
					break;
				}
				if(DDT_E != '' && DDT_L == ''){
					alert( "DRY DOCK_T(LAG)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_lag_t' );
					break;
				}
				
				// SKID BERTH_F
				var SBF_E = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_event_f' );
				var SBF_L = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_lag_f' );
				if(SBF_E == '' && SBF_L != ''){
					alert( "SKID BERTH_F(EVENT)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_event_f' );
					break;
				}
				if(SBF_E != '' && SBF_L == ''){
					alert( "SKID BERTH_F(LAG)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_lag_f' );
					break;
				}
				
				// SKID BERTH_T
				var SBT_E = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_event_t' );
				var SBT_L = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_lag_t' );
				if(SBF_E == '' && SBF_L != ''){
					alert( "SKID BERTH_T(EVENT)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_event_t' );
					break;
				}
				if(SBF_E != '' && SBF_L == ''){
					alert( "SKID BERTH_T(LAG)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_lag_t' );
					break;
				}
				
				// FLOATING
				var F_E = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'fdock_event_f' );
				var F_L = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'fdock_lag_f' );
				if(F_E == '' && F_L != ''){
					alert( "FLOATING(EVENT)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'fdock_event_f' );
					break;
				}
				if(F_E != '' && F_L == ''){
					alert( "FLOATING(LAG)를 입력하십시오." );
					result = false;
					message = "Field is required";
						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'fdock_lag_f' );
					break;
				}
				
				
				
				
				
// 				// DRY DOCK_F(EVENT) 미입력 여부 확인
// 				var val3 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_event_f' );
// 				if ( $.jgrid.isEmpty( val3 ) ) {
// 					alert( "DRY DOCK_F(EVENT)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_event_f' );
// 					break;
// 				}
// 				// DRY DOCK_F(LAG) 미입력 여부 확인
// 				var val4 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_lag_f' );
// 				if ( $.jgrid.isEmpty( val4 ) ) {
// 					alert( "DRY DOCK_F(LAG)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_lag_f' );
// 					break;
// 				}
				
// 				// DRY DOCK_T(EVENT) 미입력 여부 확인
// 				var val5 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_event_t' );
// 				if ( $.jgrid.isEmpty( val5 ) ) {
// 					alert( "DRY DOCK_T(EVENT)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_event_t' );
// 					break;
// 				}
// 				// DRY DOCK_T(LAG) 미입력 여부 확인
// 				var val6 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'dock_lag_t' );
// 				if ( $.jgrid.isEmpty( val6 ) ) {
// 					alert( "DRY DOCK_T(LAG)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'dock_lag_t' );
// 					break;
// 				}
				
// 				// SKID BERTH_F(EVENT) 미입력 여부 확인
// 				var val7 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_event_f' );
// 				if ( $.jgrid.isEmpty( val7 ) ) {
// 					alert( "SKID BERTH_F(EVENT)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_event_f' );
// 					break;
// 				}
// 				// SKID BERTH_F(LAG) 미입력 여부 확인
// 				var val8 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_lag_f' );
// 				if ( $.jgrid.isEmpty( val8 ) ) {
// 					alert( "SKID BERTH_F(LAG)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_lag_f' );
// 					break;
// 				}
				
// 				// SKID BERTH_T(EVENT) 미입력 여부 확인
// 				var val9 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_event_t' );
// 				if ( $.jgrid.isEmpty( val9 ) ) {
// 					alert( "SKID BERTH_T(EVENT)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_event_t' );
// 					break;
// 				}
// 				// SKID BERTH_T(LAG) 미입력 여부 확인
// 				var val10 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'skid_lag_t' );
// 				if ( $.jgrid.isEmpty( val10 ) ) {
// 					alert( "SKID BERTH_T(LAG)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'skid_lag_t' );
// 					break;
// 				}
				
// 				// FLOATING(EVENT) 미입력 여부 확인
// 				var val11 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'fdock_event_f' );
// 				if ( $.jgrid.isEmpty( val11 ) ) {
// 					alert( "FLOATING(EVENT)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'fdock_event_f' );
// 					break;
// 				}
// 				// FLOATING(LAG) 미입력 여부 확인
// 				var val12 = $( "#dbMasterGrid" ).jqGrid( 'getCell', ids[i], 'fdock_lag_f' );
// 				if ( $.jgrid.isEmpty( val12 ) ) {
// 					alert( "FLOATING(LAG)를 입력하십시오." );
// 					result = false;
// 					message = "Field is required";
// 						setErrorFocus( "#dbMasterGrid", ids[i], 0, 'fdock_lag_f' );
// 					break;
// 				}
			}
		}
	}

	if ( nChangedCnt == 0 ) {
		result = false;
		alert( "변경된 내용이 없습니다." );
	}
	return result;
}


//그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#dbMasterGrid" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'U';
	} );
	
	callback.apply(this, [ changedData.concat(resultData) ]);
};

//########  납기관리자 버튼 ########//
$("#btnMan").click(function(){
	
	var url = "popUpDbMasterManager.do";

	var nwidth = 210;
	var nheight = 300;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no,resizable=no,directories=yes";
	
	window.open(url,"",sProperties);					
});				

function search() {
	
	$("#itemTransList").jqGrid("clearGridData");
	$("input[name=p_daoName]").val("EMS_DBMAIN");
	$("input[name=p_queryType]").val("select");
	$("input[name=p_process]").val("list");				
	$("input[name=p_isexcel]").val("");
	
	var sUrl = "emsDbMasterList.do";		
	jQuery("#itemTransList").jqGrid("GridUnload");
			
	jQuery("#dbMasterGrid").jqGrid('setGridParam',{url		: sUrl
		,mtype    : 'POST' 
		,page		: 1
		,datatype	: 'json'
		,postData : getFormData("#listForm")}).trigger("reloadGrid");
}

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

function formatOpt2(cellvalue, options, rowObject){
	
	var str = "";
	if(cellvalue > 0) {
		str = cellvalue;
	}
		
		return str;		 	 
}

</script>
</body>
</html>