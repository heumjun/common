<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>dwgComplete</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	<style>
		.fontType {color:#324877;
				font-weight:bold; 
				 }
		input[type=text] {text-transform: uppercase;}
	</style>
</head>
<body>
<div class="mainDiv" id="mainDiv" >
	<form id="application_form">
	
	<input type="hidden" id="p_is_excel" name="p_is_excel" value="" />
	<input type="hidden" id="p_col_name" name="p_col_name" value="" />
	<input type="hidden" id="p_data_name" name="p_data_name" value="" />
	<input type="hidden" id="page" name="page" value="" />
	<input type="hidden" id="rows" name="rows" value="" />
	
	<input type="hidden" name="pageYn" id="pageYn" value="N">
	<input type="hidden" name="p_userId"	id="p_userId" value="${loginUser.user_id}"	/>
	<input type="hidden" name="P_FILE_NAME" id = "P_FILE_NAME" value="" />
	<input type="hidden" name="permissionFlag" id="permissionFlag"		/>
	<input type="hidden" id="GrCode" name="GrCode" value="${loginUser.gr_code}"/>
	<div class= "subtitle">
		DTS APPROVAL SYSTEM
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="./images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
	<div id="top" >


		<table class="searchArea conSearch">
					<col width="930">
					<col width="*">
					<tr>
					<td class="fontType" style="border-right:none;">
<!-- 					<select id="p_deptGubun" name="p_deptGubun" > -->
<!-- 						<option value="S">상선</option> -->
<!-- 						<option value="N">특수선</option> -->
<!-- 					</select> -->
<!-- 					&nbsp; -->
					부서
					<input type="text" id="dept" 	name="dept" readonly	value="${loginUser.dwg_dept_code}"  style="width: 40px;background: #dddddd;color: black; " />
					<input type="text" class = "required" id="deptName" readonly name="deptName" value="${loginUser.dwg_dept_name}"	style="margin-left: -5px;width: 70px;background: #dddddd;color: black;"> 
					&nbsp;
					호선
					<input type="text"   id="shipNo" name="shipNo" style="width: 40px;  text-transform: uppercase;" onchange="onlyUpperCase(this);">
					<input type="button" id="btnmain" name="btnmain" value="검색"  class="btn_gray2"/> 
					&nbsp;
					DWG
					<input type="text" class = "textBox" id="dwgNo" name="dwgNo" style="width: 40px;  text-transform: uppercase;" maxlength="5" onchange="onlyUpperCase(this);" />
					<input type="text" class = "textBox wid60" id="blockNo" name="blockNo" value="" style="margin-left: -5px; width: 25px;" maxlength="3" onchange="onlyUpperCase(this);" />&nbsp;
					<input type="button" id="btndwgNo" name="btndwgNo" value="검색" class="btn_gray2" style="margin-left: -5px;"/>								
					&nbsp;
					의뢰기간
					<input type="text" class = "textBox" id="fromDate" name="fromDate" value = "" style="width: 80px;">
					~
					<input type="text" class = "textBox" id="ToDate" name="ToDate" value = "" style="width: 80px;">
					&nbsp;
					<fieldset style="width: 100px; height:20px; display: inline;  line-height: 0px; vertical-align: 1px;">
						<input type="radio" name="btnRadio" id="" value="0" checked />승인대상&nbsp;&nbsp;
						<input type="radio" name="btnRadio" id="" value="1" 		/>전체
					</fieldset>
					&nbsp;
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="EXPORT" id="btnExport"  class="btn_blue" />
					</c:if>
					</td>
					<td style="border-left:none;">
						<div class="button endbox">
							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" class="btn btn_blue"	id="btnSearch" name="btnSearch" value="조회" >
							</c:if>
							<c:if test="${userRole.attribute7 == 'Y'}">
								<input type="button" class="btn btn_blue"	id="btnPreView" name="btnPreView" value="미리보기" >
							</c:if>
							<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" class="btn btn_blue"	id="btnReturn" name="btnReturn" value="반려" >
								<input type="button" class="btn btn_blue"	id="btnApprove" name="btnApprove" value="승인" >
							</c:if>
						</div>
					</td>
					</tr>
		</table>


			<!--<div class = "conSearch" >
				<span class = "spanMargin"> 부서     	<input type="text" id="dept" 	name="dept" readonly	value="${loginUser.dwgdeptcode}"  		style="width: 50px;background: #dddddd;color: black; " />
													<input type="text" class = "required" id="deptName" readonly name="deptName" value="${loginUser.dwgdeptnm}"		style="margin-left: -5px;width: 150px;background: #dddddd;color: black;"> 
				</span>
			</div>
			<div class = "conSearch" >
				<span class = "spanMargin"> 호선 <input type="text"   id="shipNo" name="shipNo" style="width: 50px;  text-transform: uppercase;" onchange="onlyUpperCase(this);">
												<input type="button" id="btnmain" name="btnmain" value=".."  style="margin-left: -5px;"/> 
				</span>
			</div>
			
			<div class = "conSearch" >
				<span class = "spanMargin">
					DWG 
					<input type="text" class = "textBox" id="dwgNo" name="dwgNo" style="width: 50px;  text-transform: uppercase;" onchange="onlyUpperCase(this);">
					<input type="text" class = "textBox" id="blockNo" name="blockNo" value=""  style="margin-left: -5px;width: 25px;  text-transform: uppercase;" onchange="onlyUpperCase(this);">
					<input type="button" id="btndwgNo" name="btndwgNo" value=".."  style="margin-left: -5px;"/>
				</span>
			</div>
			<div class = "conSearch" >
				<span class = "spanMargin"> 
					의뢰기간 
					<input type="text" class = "textBox" id="fromDate" name="fromDate" value = "" style="width: 70px;">
					~
					<input type="text" class = "textBox" id="ToDate" name="ToDate" value = "" style="width: 70px;">
				 </span>
			</div>
			<div class = "conSearch" >
				<fieldset style="width: 130px;height:14px; display: inline; margin-left: 15px; line-height: 0px; vertical-align: 1px">
				<span class = "spanMargin"> 
					<input type="radio" name="btnRadio" id="" value="0" checked style="vertical-align: -4px;">승인대상
					<input type="radio" name="btnRadio" id="" value="1" 		style="vertical-align: -4px;">전체
 				</span>
 				</fieldset>
 				<input type="button" id="btnSearch" name="btnSearch" value="조회" >
			</div>
			
			<div class = "button">
				<input type="button" class="btn"	id="btnPreView" name="btnPreView" value="미리보기" >
				<input type="button" class="btn"	id="btnReturn" name="btnReturn" value="반려" >
				<input type="button" class="btn"	id="btnApprove" name="btnApprove" value="승인" >
			</div>-->
		
	</div>
	<div class="content">
		<table id = "dwgCompleteList"></table>
		<div id="btndwgCompleteList"></div>
	</div>
	<input type="hidden" id="sUrl" name="sUrl" value="${sUrl}">
	</form>
</div>
<script type="text/javascript">
var lodingBox;
$(document).ready(function(){
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(1);
	$("#dwgCompleteList").jqGrid({ 
             datatype: 'json', 
             mtype: '', 
             url:'',
             postData : getFormData('#application_form'),
             colNames:['상태','호선','도면번호','DESCRIPTION','REV','요청자명','사번','부서명','요청일자','승인자명','사번','부서명','승인&반려일자','요청번호','ep_mail','mail_receiver'],
                colModel:[
                	{name:'trans_plm', index:'trans_plm'		,width:30	,align:'center'},
                    {name:'shp_no', index:'shp_no'				,width:30	,align:'center'},
                    {name:'dwg_no', index:'dwg_no'				,width:30	,align:'center'},
                    {name:'text_des', index:'text_des'			,width:150	,align:'center'},
                    {name:'dwg_rev', index:'dwg_rev'			,width:20	,align:'center'},
                    {name:'user_name', index:'user_name'		,width:30	,align:'center'},
                    {name:'req_sabun', index:'req_sabun'		,width:30	,align:'center'},
                    {name:'dept_name', index:'dept_name'		,width:100	,align:'center'},
                    {name:'req_date', index:'req_date'			,width:50	,align:'center'},
                    {name:'res_user_name', index:'res_user_name',width:30	,align:'center'},
                    {name:'res_sabun', index:'res_sabun'		,width:30	,align:'center'},
                    {name:'res_dept_name', index:'res_dept_name',width:100	,align:'center'},
                    {name:'res_date', index:'res_date'			,width:50	,align:'center'},
                    {name:'req_seq', index:'req_seq'			,width:40	,align:'center' , hidden:false},
                    {name:'ep_mail', index:'ep_mail',hidden:true },
                    {name:'mail_receiver', index:'mail_receiver', hidden:true },
                    
                ],
             multiselect: true,
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             //width: 1408,
             height: objectHeight, 
             pager: jQuery('#btndwgCompleteList'),
             rowList:[100,500,1000],
	         rowNum:100, 
			 //cellEdit: true,             // grid edit mode 1
	         //cellsubmit: 'clientArray',  // grid edit mode 2
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
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
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },

   			 loadComplete: function (data) {
             	var chkRadio 		= $(':radio[name="btnRadio"]:checked').val();
             	var	permissionFlag	= $("#permissionFlag").val();
             	if(chkRadio==1){
             		$("#dwgCompleteList").jqGrid({}).hideCol('cb');
             		fn_buttonDisabled(["#btnPreView", "#btnReturn", "#btnApprove"]);
//              		$("#btnPreView").attr("disabled",true);
//              		$("#btnReturn").attr("disabled",true);
//              		$("#btnApprove").attr("disabled",true);
             	}else{
             		$("#dwgCompleteList").jqGrid({}).showCol('cb');
             		if(permissionFlag=='Y'){
             			fn_buttonEnable(["#btnPreView", "#btnReturn", "#btnApprove"]);
// 	             		$("#btnPreView").attr("disabled",false);
// 	             		$("#btnReturn").attr("disabled",false);
// 	             		$("#btnApprove").attr("disabled",false);
             		}else{
             			
             		}
             	}
             	//$("#dwgCompleteList").jqGrid('setGridWidth',$(window).width()-20);
             	
			    var $this = $(this);
			    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			        // because one use repeatitems: false option and uses no
			        // jsonmap in the colModel the setting of data parameter
			        // is very easy. We can set data parameter to data.rows:
			        $this.jqGrid('setGridParam', {
			            datatype: 'local',
			            data: data.rows,
			            pageServer: data.page,
			            recordsServer: data.records,
			            lastpageServer: data.total
			        });
		
			        // because we changed the value of the data parameter
			        // we need update internal _index parameter:
			        this.refreshIndex();
			
			        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
			            // we need reload grid only if we use sortname parameter,
			            // but the server return unsorted data
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
			    
			    var rows = $("#dwgCompleteList").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++)
			    {
			        var trans_plm = $("#dwgCompleteList").getCell(rows[i],"trans_plm");
			        
			        if(trans_plm=='Release')
			        {
			            $("#dwgCompleteList").jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#dddddd'});            
			        }
			    }
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
	                             var item = $('#dwgCompleteList').jqGrid('getRowData',row_id);
	                             //$("#dwgCompleteList").jqGrid({}).hideCol('cb');
	                             //alert(item.trans_plm);
	                             if(item.trans_plm!='Request'){
	                             		$('#dwgCompleteList').resetSelection();
	                             }
                             }
                          }
           
     });
	//grid resize
    fn_gridresize( $(window), $( "#dwgCompleteList" ), -30 );
    
    if( "${main_appr}" == 'Y') {
		fn_search();
	}
    
	//$(window).bind('resize', function() {
	//	var gridWidth = $(window).width()-20;
	//	if(gridWidth>1160){
	//		$( "#dwgCompleteList" ).setGridWidth(gridWidth);
	//	}else{
	//		$("#dwgCompleteList").jqGrid('gridResize', { minWidth: 1100, minHeight: 100 });
	//	}
	//	//gridId.setGridWidth(winObj.width()-204);
	//}).trigger('resize');
	
    //jquery 달력
    //fn_weekDate( "fromDate", "ToDate" );
	
   	
   	
	/* 
	 * 2017-10-12 양동협 대리 요청으로 하드코딩 
	 * HSE 팀이 도면부서 등록 안되어있기때문에 양대리만 강제로 사용할수 있도록
	 */
	if( $("#p_userId").val() == "211055" ){
		$("#dept").val("000002");
		$("#deptName").val("설계운영P");
		$("#permissionFlag").val("Y");
	}else{
		getPermission();
	}
});  //end of ready Function

	$("#btnSearch").click(function(){
		
		//세션처리 필요
		var dept = $("#dept").val();
		if(dept=="" || dept==null){	
			alert('부서를 입력해주세요');
		}
		fn_search();		
	});
	
	//미리보기 클릭 시
	$("#btnPreView").click(function(){
		var vEmpNo	  = $("#p_userId").val();
		var selrow = $('#dwgCompleteList').jqGrid('getGridParam', 'selarrrow');
		for(var i=0;i<selrow.length;i++){
			
			var selDatas = $("#dwgCompleteList").jqGrid('getRowData', selrow[i]);
			var parameters ={
							req_seq	: selDatas.req_seq
							};
			$.post('dwgPreViewFileList.do', parameters,function(data) {
					$("#P_FILE_NAME").val("");
					for(var i=0;i<data.length;i++){
						$("#P_FILE_NAME").val($("#P_FILE_NAME").val() + data[i].file_name + "|");
					}
					var sURL = "popUpDWGView.do?mode=dwgChkView&vEmpNo="+vEmpNo;
					form = $('#application_form');		
					form.attr("action", sURL);
					var myWindow = window.open("", "popForm"+i, "toolbar=no, width=540, height=467, directories=no, status=no,    scrollorbars=no, resizable=no");
						    
					form.attr("target","popForm"+i);
					form.attr("method", "post");	
							
					myWindow.focus();
					form.submit();
				},"json"
			);
		}
		
	});
	$("#btnReturn").click(function(){
		
		var selRowIds = jQuery('#dwgCompleteList').jqGrid('getGridParam', 'selarrrow');
		if(selRowIds.length==0){
			alert("반려할 도면을 선택해주세요");
			return;
		}
		if (confirm('선택한 도면을 반려하시겠습니까?')!=0) {
			var chmResultRows=[];
			getChangedChmResultData(function(data){ //변경된 row만 가져 오기 위한 함수
				lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
				chmResultRows = data;
				var dataList = {chmResultList:JSON.stringify(chmResultRows)};
				var url = 'dwgReturn.do';
				var formData = getFormData('#application_form');
				var parameters = $.extend({},dataList,formData); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
				$.post(url, parameters, function(data) {
						alert(data.resultMsg);
						if (data.result == "success") { 		 	
						 	fn_search();
						}
					}).fail(function(){
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
				    	lodingBox.remove();	
					});
				});
		}
	});
	
	$("input[name=btnRadio]").click(function(){
	
		fn_search();
		
		
		
	});
	$("#btnApprove").click(function(){
		
		
		var selRowIds = jQuery('#dwgCompleteList').jqGrid('getGridParam', 'selarrrow');
		if(selRowIds.length==0){
			alert("승인할 도면을 선택해주세요");
			return;
		}
		if (confirm('선택한 도면을 승인하시겠습니까?')!=0) {
			var chmResultRows=[];
			getChangedChmResultData(function(data){ //변경된 row만 가져 오기 위한 함수
				lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
				chmResultRows = data;
				var dataList = {chmResultList:JSON.stringify(chmResultRows)};
				var url = 'dwgApprove.do';
				var formData = getFormData('#application_form');
				var parameters = $.extend({},dataList,formData); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
				$.post(url, parameters, function(data) {
					alert(data.resultMsg);
					if (data.result == "success") { 		 	
					 	fn_search();
					}
					}).fail(function(){
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
				    	lodingBox.remove();	
				});
			});
		}
		
	});
	
	
	//폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	function getChangedChmResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var item=new Array();
		
		var selectedIDs = jQuery('#dwgCompleteList').jqGrid('getGridParam', 'selarrrow');
		
		for(var i=0;i<selectedIDs.length;i++){
			item.push($("#dwgCompleteList").jqGrid('getRowData', selectedIDs[i]));
		}
		callback.apply(this, [item]);
	};
	
	$( function() {
		var dates = $( "#fromDate, #ToDate" ).datepicker( {
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
				var option = this.id == "fromDate" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		} );
	} );
	 
	 
	//dpList 호선 팝업
	$("#btnmain").click(function(){
		var rs = window.showModalDialog( "popUpDPShipList.do",
				window,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
		
// 		var dept = $("#dept").val();
// 		var shipNo = $("#shipNo").val();
		
// 		var args = {
// 					dept 	: dept,
// 					shipNo	: shipNo
// 					};
		
// 		var rs=window.showModalDialog("popUpBaseInfo.do?cmd=popupDPShipList&dept="+dept+"&shipNo="+shipNo,window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");
		
		if(rs!=null){
			$("#shipNo").val(rs[0]);
		}
		
	});
	
	//dpList 도면 팝업
	$("#btndwgNo").click(function(){
	
		var dept = $("#dept").val();
		var shipNo = $("#shipNo").val();
		var dwgNo = $("#dwgNo").val();
		var blockNo = $("#blockNo").val();
		var dwg_no = dwgNo+blockNo;
		
		var args = {
					dept 	: dept,
					shipNo	: shipNo,
					dwgNo	: dwgNo,
					blockNo : blockNo,
					dwg_no	: dwg_no
					};
		
		//var rs=window.showModalDialog("popUpBaseInfo.do?cmd=popupDPDwgList&dept="+dept+"&shipNo="+shipNo+"&dwg_no="+dwg_no,"view","dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");
// 		var rs=window.showModalDialog("popUpBaseInfo.do?cmd=popupDPDwgList",args,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");

			var rs = window.showModalDialog( "popUpDPDwgList.do",
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
			
		if(rs!=null){
			$("#dwgNo").val(rs[0]);
			$("#blockNo").val(rs[1]);
		}
	});
	
	$("#btnExport").click(function(){		
		
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		var cn = $('#dwgCompleteList').jqGrid( "getGridParam", "colNames" );
		var cm = $('#dwgCompleteList').jqGrid( "getGridParam", "colModel" );
		for(var i=1; i<cm.length; i++ ){
			if(cm[i]['hidden'] == false) {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
		}
		form = $('#application_form');

		$("#p_is_excel").val("Y");
		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
		
		$("#p_col_name").val(colName);
		$("#p_data_name").val(dataName);
		$("#rows").val($('#dwgCompleteList').getGridParam("rowNum"));
		$("#page").val($('#dwgCompleteList').getGridParam("page"));
	
		form.attr("action", "dwgApproveExcelExport.do?");
		
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	});	
	
	
function fn_search()
{
	$("#dwgCompleteList").jqGrid("clearGridData");
	
	
	
	var sUrl = "dwgCompleteList.do";
	jQuery("#dwgCompleteList").jqGrid('setGridParam',{url:sUrl
													 ,mtype: 'POST'
													 ,datatype:'json'
													 ,page:1
													 ,postData: getFormData('#application_form')}).trigger("reloadGrid");  
}
function getPermission(){
		var url = 'selectPermission.do';
		var formData = getFormData('#application_form');
		$.post(url, formData, function(data) {
			var p_flag = 'N' ;
			if(data!=''){
				var emp_no = data.emp_no;
				
				if(emp_no == '' || emp_no == null){
					p_flag = 'N';
				}else{
					p_flag = 'Y';
				}
			}
			$("#permissionFlag").val(p_flag);
			if(p_flag=='N'){
				$( ".btn" ).prop( "disabled", true );
			}
		});
}

function fn_main_getFormData() {
	return fn_getFormData( '#application_form' );
}


function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();	
}
</script>
</body>
</html>