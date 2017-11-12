<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A/F Volume Control</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:4px;
    padding-top:2px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
</style>
</head>
<body>
<div id="mainDiv" class="mainDiv" >
<form name="listForm" id="listForm"  method="get"> 
	<div class= "subtitle">
	A/F Volume Control
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
	
	<input type="hidden"  name="pageYn" 	 value="N"/>
	<input type="hidden"  name="src" 	     value=""/>
	<input type="hidden"  name="param" 	     value=""/>
	
	<input type="hidden"  name="projectNo"   value=<%=session.getAttribute("paint_project_no")%>  />
	<input type="hidden"  name="p_code_gbn"  value="blockCode" />
	
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	

		
		<table class="searchArea conSearch" >
			<col width="110">
			<col width="210">
			<col width="110">
			<col width="100">
			<col width="*" style="min-width:160px;"/>

		<tr>
			<th>PROJECT NO</th>
			<td>
				<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
				<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
				<input type="button" id="btnProjNo"  value="검색"  class="btn_gray2">						
			</td>

			<th>담당자</th>
			<td style="border-right:none;">
			<input type="text" id="txtUserName" name="user_name" style="text-align:center; width:80px;" value="${loginUser.user_name}"/>
			</td>

		<td style="border-left:none;" colspan="2">
		<div class="button endbox">
		<c:if test="${userRole.attribute1 == 'Y'}">
				<input type="button" value="조회" 	  id="btnSearch"  	class="btn_blue"	/>
			</c:if>
			
			<c:if test="${userRole.attribute4 == 'Y'}">	
				<input type="button" value="저장" 	  disabled id="btnSave"      class="btn_gray" 	/>
			</c:if>
			
			<c:if test="${userRole.attribute5 == 'Y'}">
				<input type="button" value="출력"  id="btnExcelExport"  class="btn_blue"/>
			</c:if>
			
			
		</div>
		</td>
		</tr>
		</table>
		
		
		
		<!--
		<div class = "topMain" style="line-height:45px">
			<div class = "conSearch">
				<span class = "spanMargin">
					PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:120px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
								<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
								<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
				</span>
			</div>
			<div class = "conSearch">
				<span class = "spanMargin">
				담당자
				<input type="text" id="txtUserName" name="user_name" style="width:80px;" value="${loginUser.user_name}"/>
				</span>
			</div>
			
			<div class = "button">
				<input type="button" value="조  회" 	  id="btnSearch"  		/>
				<input type="button" value="저 장" 	  disabled id="btnSave"       	/>
				<input type="button" value="Excel출력"  id="btnExcelExport"  />	
			</div>
		</div>
		-->
		
		<div id="afvDiv" class="content" style="">
		
			<table id = "afvolumeGrid"></table>
			<div   id = "p_afvolumeGrid"></div>
		<!--  	<div   id = "afvolumeImage" style="height:250px; margin-top:5px; border: 1px solid white"> -->
			
			<div style="position: relative; top: 0%">
				<img alt="" src="/images/af_volume_control.jpg" style="width:100%">
				
				<div   id = "divAft" style="position: absolute; left: 15%; top: 40%;">FR.  <input type="text" id="txtAft" name="aft_quantity" style="text-align:center;width:80px;"/> </div>	
				<div   id = "divMid" style="position: absolute; left: 50%; top: 40%;">FR.  <input type="text" id="txtMid" name="mid_quantity" style="text-align:center;width:80px;"/> </div>
				<div   id = "divFwd" style="position: absolute; left: 87%; top: 40%;">FR.  <input type="text" id="txtFwd" name="fwd_quantity" style="text-align:center;width:80px;"/> </div>
			</div>
		</div>
	
	</div>	

</form>

<script type="text/javascript">

var change_afvolume_row 	= 0;
var change_afvolume_row_num = 0;
var change_afvolume_col  	= 0;

var tableId	   			 	= "#afvolumeGrid";
var deleteData 			 	= [];

var searchIndex 		 	= 0;
var lodingBox; 
var win;	

var isLastRev			 	= "N";
var isExistProjNo		 	= "N";					
var sState					= "";	
var search_flag				= "N";
var preProject_no;
var preRevision;
var cnt = 1;

$(document).ready(function(){
	/* $(window).bind('resize', function() {
		$("#afvDiv").css({'height':  $(window).height()/3});
	}).trigger('resize'); */
	fn_searchLastRevision();
	
	$("#afvolumeGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['구역', '회차','Paint Code','Paint Desc','DFT','Af End~ <br> FR.','FR. ~<br>FR.','FR. ~<br>FR.','FR. ~<br>Fw End','물량','캔수','','',''],
                colModel:[
                	{name:'states_name',	index:'states_name', 	width:100, 	sortable:false,		editrules:{required:true}},
                	{name:'paint_count', 	index:'paint_count', 	width:60, 	sortable:false,		editrules:{required:true},	align:'center'},
                	{name:'paint_item',	 	index:'paint_item', 	width:160, 	sortable:false,		editrules:{required:true}},
                	{name:'item_desc',	 	index:'item_desc', 		width:400, 	sortable:false,		editrules:{required:true}},
                	{name:'paint_dft', 	 	index:'paint_dft', 		width:60, 	sortable:false,		editrules:{required:true}, 	align:'center'},
                	{name:'aft_quantity',	index:'aft_quantity', 	width:100, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	{name:'mid_a_quantity',	index:'mid_a_quantity', width:100, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	{name:'mid_f_quantity',	index:'mid_f_quantity', width:100, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	{name:'fwd_quantity',	index:'fwd_quantity', 	width:100, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	{name:'total_quantity', index:'total_quantity',	width:80, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	{name:'can_quantity',	index:'can_quantity', 	width:60, 	sortable:false,		editrules:{required:true}, 	align:'right'},
                	                
                    {name:'project_no',		index:'project_no', width:25, hidden:true},
                    {name:'revision',		index:'revision',   width:25, hidden:true},
                    {name:'oper',index:'oper', width:25, hidden:true}
                ],
             cmTemplate: { title: false },
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: $(window).height() * 0.35,
             pager		: jQuery('#p_afvolumeGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	        
	         beforeSaveCell : changeAfVolumeEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            		
	         },
	         onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
				
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
	         loadComplete : function (data) {
			  	
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
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_afvolume_row 	=	rowid;
             	change_afvolume_row_num =	iRow;
             	change_afvolume_col 	=	iCol;
   			 },
			 gridComplete : function () {
		 		
			 },  	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             onCellSelect: function(row_id, colId,b1,b2,b3) {
             
             }
    }); 
   
	//grid header colspan
	$( "#afvolumeGrid" ).jqGrid( 'setGroupHeaders', {
		
		useColSpanStyle : true, 
		groupHeaders : [
							{ startColumnName : 'aft_quantity',  	numberOfColumns : 1, titleText : 'AFT' },
							{ startColumnName : 'mid_a_quantity', 	numberOfColumns : 1, titleText : 'MID(A)'},
							{ startColumnName : 'mid_f_quantity', 	numberOfColumns : 1, titleText : 'MID(F)'},
							{ startColumnName : 'fwd_quantity',  	numberOfColumns : 1, titleText : 'FWD' },
							{ startColumnName : 'total_quantity',	numberOfColumns : 2, titleText : 'TOTAL' }
		  				]
	} );
	
	$("#afvolumeGrid").jqGrid('navGrid',"#p_afvolumeGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	$("#afvolumeGrid").navButtonAdd("#p_afvolumeGrid",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_search();
				},
				position:"first",
				title:"",
				cursor:"pointer"
			}
	);
	</c:if>
		
	//그리드 데이터 저장
	$("#btnSave").click(function() {
		fn_save();	
	});
	
	//조회 버튼
	$("#btnSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_search();
		}
	});
	
	//엑셀 출력
	$("#btnExcelExport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_excelDownload();	
		}
	});
	
	//프로젝트 조회	
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	if($("#txtProjectNo").val() != ""){
		searchProjectNo();
	}
	
	//grid resize
	fn_insideGridresize($(window),$("#afvDiv"),$("#afvolumeGrid"), 300);
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Grid와 AfVolume Text Box에 값 설정한다.
function fn_destoryHeaderGrid(aftVal, midVal, fwdVal) {
	
	$('#afvolumeGrid').jqGrid('destroyGroupHeader');
	
	$('#afvolumeGrid').jqGrid('setLabel', "aft_quantity", 	'Af End~ <br> FR.' + aftVal);
	$('#afvolumeGrid').jqGrid('setLabel', "mid_a_quantity", 'FR.'+aftVal+' ~<br>FR.'+midVal);
	$('#afvolumeGrid').jqGrid('setLabel', "mid_f_quantity", 'FR.'+midVal+' ~<br>FR.'+fwdVal);
	$('#afvolumeGrid').jqGrid('setLabel', "fwd_quantity", 	'FR.'+fwdVal+' ~<br>Fw End');
	
	// Text box값 설정
	$("#txtAft").val(aftVal);
	$("#txtMid").val(midVal);
	$("#txtFwd").val(fwdVal);
		
	// grid header colspan
	$( "#afvolumeGrid" ).jqGrid( 'setGroupHeaders', {
		
		useColSpanStyle : true, 
		groupHeaders : [
							{ startColumnName : 'aft_quantity',   numberOfColumns : 1, titleText : 'AFT' },
							{ startColumnName : 'mid_a_quantity', numberOfColumns : 1, titleText : 'MID(A)'},
							{ startColumnName : 'mid_f_quantity', numberOfColumns : 1, titleText : 'MID(F)'},
							{ startColumnName : 'fwd_quantity',   numberOfColumns : 1, titleText : 'FWD' },
							{ startColumnName : 'total_quantity', numberOfColumns : 2, titleText : 'TOTAL' }
		  				]
	} );
}

// afvolume_desc값 대문자 설정
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "afvolume_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

// 저장중인 row 저장한다.
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 변경된 Data의 validation 체크한다.
function fn_checkAfVolumeValidate()
{
	var result   = true;
	var message  = "";
		
	if (!result) {
		alert(message);
	}
	
	return result;	
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

//Grid 변경된 데이터 반환한다.
function getChangedGridInfo(gridId)
{
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

//Grid의 row가 변경될 경우 호출한다.
function changeAfVolumeEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#afvolumeGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I')
		item.oper = 'U';

	// apply the data which was entered.
	$('#afvolumeGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	

//header checkbox action 
function checkBoxHeader(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

// chkeckBox click 이벤트 설정
function chkClick(obj,sAfVolume) {
	
	if (obj.checked) {
		$("."+sAfVolume).prop("checked", true);
		//$("input[value*="+sAfVolume).prop("checked", true);
	} else {
		$("."+sAfVolume).prop("checked", false);
		//$("input[value*="+sAfVolume).prop("checked", false);
	}
}

// Revision변경된 경우 호출
function changedRevistion(obj) {
	searchProjectNo();
	//fn_searchLastRevision();	
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//프로젝트에 대한 항목 체크한다.
function fn_ProjectNoCheck(isLastCheck) {
	
	// 프로젝트 필수체크
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		alert("Project No is required");
		setTimeout('$("input[name=project_no]").focus()',200);	
		return false;
	}
	
	// Revision 필수 체크
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		alert("Revision is required");
		setTimeout('$("input[name=revision]").focus()',200);
		return false;
	}
	
	// 존재하는 프로젝트인지 체크한다.
	if (isExistProjNo == "N" && isLastCheck == true) {
		alert("Project No does not exist");
		return false;
	}
	
	// 프로젝트의 상태를 체크한다.
	if (sState == "D" && isLastCheck == true) {
		alert("State of the revision is released");
		return false;
	}
	
	// 프로젝트 최종 revision체크한다.
	if ( isLastRev == "N" && isLastCheck == true) {
		alert("PaintPlan Revision is not the end");
		return false;
	}
	
	return true;
}

// Grid chkeckBox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem "+rowObject.afvolume_code+"' value="+rowid+" onclick='chkClick(this,\""+rowObject.afvolume_code+"\")'/>";
}

// 버튼 enable 설정
function fn_setButtionEnable() {
	if(sState == "D" || search_flag =='Y') {
		fn_buttonEnable(["#btnSearch","#btnExcelExport"]);		
	} else {
		fn_buttonDisabled(["#btnSearch","#btnExcelExport"]);		
	}
	if ("Y" == isLastRev && sState != "D") {
		fn_buttonEnable(["#btnSave"]);
		/* $( "#btnSave" ).removeAttr( "disabled" );
		$( "#btnSave" ).removeClass("btn_gray");
		$( "#btnSave" ).addClass("btn_blue"); */
	} else {
		fn_buttonEnable(["#btnSave"]);
		/* $( "#btnSave" ).attr( "disabled", true );
		$( "#btnSave" ).removeClass( "btn_blue" );
		$( "#btnSave" ).addClass( "btn_gray" ); */
	}
}

// 조회시 삭제된  array의 내용을 지운다.
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

// 대문자만 입력 가능하도록 한다.
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// 화면 사이즈 변경한다.
function resizeWin() {
    win.resizeTo(720, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
//엑셀 업로드 화면 호출
/* 사용안함 function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "./afvolumeExcelUpload.do?gbn=paintAfVolumeExcelUpload";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();	
			   									
	win = window.open(sUrl,"listForm","height=260,width=680,top=200,left=200");
} */

// 엑셀 다운로드시 RD파일 호출한다.
function fn_excelDownload()
{
	
	var param  = $("input[name=project_no]").val()+":::";
		param += $("input[name=revision]").val()+":::";
		param += $("input[name=aft_quantity]").val()+":::";
		param += $("input[name=mid_quantity]").val()+":::";
		param += $("input[name=fwd_quantity]").val()+":::";
		param += "${loginUser.user_id}";

	
	fn_PopupReportCall( "STXPISAFVOLUME.mrd", param );
	
	/* var urlStr = "http://172.16.2.13:7777/j2ee/STXDIS/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDIS/mrd/" + mrdFileName + "&param=" + params;
	
	var mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISAFVOLUME.mrd";
	$("input[name=src]").val(mrdNm);
	
	var sUrl  = "http://172.16.2.13:7777/j2ee/STXDIS/WebReport.jsp";
	
	var f = document.listForm;

	f.action = sUrl;
	f.method = "post";
	f.submit();*/
	
}

/* 사용안되고 있음 // Area Code 조회한다.
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#afvolumeGrid",change_afvolume_row_num,change_afvolume_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.area_code};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupBlockCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
		$(tableId).setCell(searchIndex,'loss_code',rs[2]);
	}
} */

// Project No 조회한다.
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()
			,revision : $("input[name=revision]").val()
			,viewType   : "MFC_VIEW"};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
		search_flag = rs[2];
	}
	
	fn_searchLastRevision();
}

// 변경된 Data를 저장한다.
function fn_save() {
	
	if (confirm('저장 하시겠습니까?') == 0 ) {
		return;
	}
	
	if (!fn_ProjectNoCheck(false)) {
		return;
	}
		
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	var url			= "savePaintAfvolume.do";
	var parameters 	= getFormData('#listForm');
			
	$.post(url, parameters, function(data) {
			
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
			 fn_searchSeparatedValue();			
		}
		
	}).fail(function(){
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
    	lodingBox.remove();	
	});
}

//프로젝트의 최종상태를 조회한다.
function fn_searchLastRevision() {
	
	var url		   = "paintPlanProjectNoCheck.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()};
						
	$.post(url, parameters, function(data) {
	  
		if (data != null) {
	  		isExistProjNo  = "Y";
	  		sState		   = data.state;
	  		
	  		if (data.last_revision_yn == "Y") isLastRev = "Y";
	  		else isLastRev = "N";
	  	} else {
	  		isExistProjNo = "N";
	  		isLastRev 	  = "N";  
	  		sState		  = "";	
	  	}
	  	
	  	if (preProject_no != $("input[name=project_no]").val() 
	  		|| preRevision !=  $("input[name=revision]").val()) 
	  	{
	  		//$("#afvolumeGrid").clearGridData(true);
	  		$("#afvolumeGrid").clearGridData(true);
	  		deleteArrayClear();
	  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	  	
	  	fn_setButtionEnable();
	  	
	}).always(function() {
	   	
	   	$("input[name=isLastRev]").val(isLastRev);
	    $("input[name=revStates]").val(sState);
	    
	  	fn_setButtionEnable();
	  	fn_searchSeparatedValue();
	}); 	  	

}

// 호선 구역별 AF Volume리스트 조회한다.
function fn_search() {

	var sUrl = "searchPaintAfvolume.do";
	$("#afvolumeGrid").jqGrid('setGridParam',{url		: sUrl
											 ,mtype		: 'POST'
											 ,page		: 1
											 ,datatype	: 'json'
											 ,postData 	: getFormData("#listForm")}).trigger("reloadGrid");
} 

// 호선의 구역정보를 조회한다. 
function fn_searchSeparatedValue() {
	
	var url		   = "searchPaintSeparatedValue.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()};
						
	$.post(url, parameters, function(data) {
	  
		var obj = data;

	  	if (obj.length > 0) {
	  		
	  		var aftVal="", midVal="", fwdVal="";
	  		
	  		for(var i=0; i<obj.length; i++) {
	  			
	  			if ("AFT" == obj[i].section_cls) {
	  				aftVal = obj[i].separated_val;
	  			} else if ("MID" == obj[i].section_cls) {
	  				midVal = obj[i].separated_val;
	  			} else if ("FWD" == obj[i].section_cls) {
	  				fwdVal = obj[i].separated_val;
	  			}
	  		}
	  		
	  		fn_destoryHeaderGrid(aftVal, midVal, fwdVal);	
	  		
	  	} else {	  	
	  		fn_destoryHeaderGrid("","","");		
	  	}
	  	
	});
}

</script>
</body>
</html>