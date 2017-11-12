<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Cosmetic</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm"  method="get">
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
<div id="mainDiv" class="mainDiv">
	<div class= "subtitle">
	Paint Cosmetic
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>

		
		<input type="hidden"  name="pageYn"  	 	value="N"/>
		<input type="hidden"  name="selected_tab"  	value="#tabs-1"/>
		<input type="hidden"  name="block_code"  	value=""/>
		<input type="hidden"  name="area_code" 	 	value=""/>
		<input type="hidden"  name="paint_gbn"   	value=""/>
		<input type="hidden"  name="area"   		value=""/>
		<input type="hidden"  name="searchGbn"   	value=""/>
		
		<input type="hidden"  name="team_count" 	 	value=""/>
		<input type="hidden"  name="group_item" 	value=""/>
		

		<table class="searchArea conSearch" >
		<col width="110">
		<col width="210">

		<tr>
			<th>PROJECT NO</th>
			<td>
			<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
			<input type="button" id="btnProjNo"  value="검색"  class="btn_gray2">						
			</td>

		<td style="border-left:none;" colspan="2">
		<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회"  id="btnSearch"  class="btn_blue"/>
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">	
			<!--<input type="button" value="저 장" 	  disabled id="btnSave"       	/>  -->
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" value="Excel출력"  id="btnExcelExport"  class="btn_blue"/>
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
			
			<div class = "button">
				<input type="button" value="조  회" 	  id="btnSearch"  				/>
				//<input type="button" value="저 장" 	  disabled id="btnSave"       	/> //
				<input type="button" value="Excel출력"  id="btnExcelExport"  			/> 
			</div>
			
			
		</div>
		-->
		<div id = "center" style="min-width: 1100px;  margin-top:10px;">
			<div id="tabs">
				<ul class="tabmenu">
					<c:forEach var="team" items="${teamList}" varStatus="status">
							<li><a href="#teamIframe" id="tab${status.count}" onclick="changeTab(${team.teamCode})">${team.teamDesc}</a></li>
					</c:forEach>
				</ul>
				<div>   
					<iframe id="teamIframe" name="teamIframe" 	src="" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width=100% height=280 style="border-width:0px;  border-color:white;"></iframe>
				</div>
			</div>
		</div>
		<div class="content"  style="position:relative; float: left; width: 64.5%;">
			<div id="divList">
		  		<table id ="itemGroupList"></table>
					<div   id ="p_itemGroupList"></div>
			</div>
		</div>
		<div class="content"  style="position:relative; float: right; width: 34.5%;">
			<div id="divSearch">
				<table id = "itemGroupDetail"></table>
			</div>
		</div>
	</div>
</form>	

</body>

<script type="text/javascript">
var selected_tab_name 	 = "#tabs-1";
var tableId	   			 = "#";
var deleteData 			 = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

var isLastRev			 = "N";
var isExistProjNo		 = "N";					
var sState				 = "";	

var preProject_no		 = "";
var preRevision			 = "";

var change_item_row 	 = 0;
var change_item_row_num  = 0;
var change_item_col  	 = 0;

var objHeight = $(window).height()/2-190;
var selectGbn;

$(document).ready(function(){
	$(window).bind('resize', function() {
		$("#center").css({'height':  $(window).height()/2-100});
		$("#teamIframe").css({'height':  $(window).height()/2-150});
	}).trigger('resize');
	$("#itemGroupList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','PAINT CODE','PAINT DESC','QUANTITY','THEORY QUANTITY',''],
                colModel:[
                   	{name:'chk', 			index:'chk', 			 width:20,		sortable:false, hidden:true, align:'center',formatter: formatOpt1},
                   	{name:'paint_item', 	index:'paint_item',  	 width:150, 	sortable:false},
                   	{name:'item_desc',		index:'item_desc', 		 width:320, 	sortable:false},
                	{name:'quantity', 		index:'quantity',  		 width:100, 	sortable:false, align:'right'},
                   	{name:'theory_quantity',index:'theory_quantity', width:100, 	sortable:false, align:'right'},  
                    {name:'oper',			index:'oper', 			 width:25, 	    hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //width		: 1340,                     //사용자 화면 크기에 맞게 자동 조절
             autowidth	: true,
             height : $(window).height()/2 - 200,
             caption : 'ITEM GROUP',
             hidegrid : false,
             pager		: $('#p_itemGroupList'),
             cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         	         
	         rowList	: [100,500,1000],
			 rowNum		: 100, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changeItemQuantityEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
             	fn_jqGridChangedCell('#itemGroupList', rowid, 'chk', {background:'pink'});		
	         },
	         onPaging: function(pgButton) {

			 },
	         loadComplete : function (data) {
	         	//fn_searchCosmeticArea();	
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_item_row 	=	rowid;
             	change_item_row_num =	iRow;
             	change_item_row 	=	iCol;	
   			 },
			 onCellSelect: function(row_id, colId) {
				 var ret 	= jQuery("#itemGroupList").getRowData(row_id);
				 fn_searchGroupDetail(ret.paint_item, ret.item_desc);
             },  	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images'
            
    });
	$("#itemGroupDetail").jqGrid({ 
        datatype	: 'json', 
        mtype		: 'POST', 
        url		: '',
        postData   : '',
        colNames:['구분','GBN', 'PAINT CODE','QUANTITY','THEORY QUANTITY',''],
           colModel:[
              	{name:'name', 	index:'name',  	 width:150, 	sortable:false},
              	{name:'gbn', 	index:'gbn',  	 width:150, 	sortable:false, hidden:true},
              	{name:'paint_item', 	index:'paint_item',  	 width:150, 	sortable:false,hidden:true},
           		{name:'quantity', 		index:'quantity',  		 width:100, 	sortable:false, editrules:{number:true}, align:"right"},
              	{name:'theory_quantity',index:'theory_quantity', width:100, 	sortable:false, align:'right'},
               	{name:'oper',			index:'oper', 			 width:25, 	    hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 200,
       
        caption : 'ITEM 구분 LIST',
        hidegrid : false,
        //pager		: $('#p_itemGroupList'),
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        	         
        rowList	: [100,500,1000],
		rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
        
        onPaging: function(pgButton) {

		 },
        loadComplete : function (data) {
        	//if ("#tabs-6" == selected_tab_name) {
        		/* fn_searchOutfittingArea(); */
        	//}	
		 },	         
		 gridComplete : function () {
				
			var rows = $( "#itemGroupDetail" ).getDataIDs();

			for ( var i = 0; i < rows.length; i++ ) {
				var gbn = $( "#itemGroupDetail" ).getCell( rows[i], "gbn" );
				if (gbn == selectGbn) {
					$( "#itemGroupDetail" ).jqGrid( 'editCell',rows[i], 1, false );
				}
				
			}
		 },	  
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#itemGroupDetail").getRowData(row_id);
			 document.getElementById('teamIframe').contentWindow.selectGbn(ret.gbn,ret.paint_item);
        },  	         
        // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
        jsonReader : {
            root: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
            page: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
            total: "total",                  // 총 페이지 수
            records: "records",
            repeatitems: false,
           },        
        imgpath: 'themes/basic/images'
       
	});	
	//grid resize
	fn_insideGridresize($(window),$("#divList"),$("#itemGroupList"),-60, 0.5);
    fn_insideGridresize($(window),$("#divSearch"),$("#itemGroupDetail"),-85, 0.5);
		
	$("#itemGroupList").jqGrid('navGrid',"#p_itemGroupList",{refresh:false,search:false,edit:false,add:false,del:false});
	
	/*	
	$("#itemGroupList").navButtonAdd('#p_itemGroupList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);*/
	
	//탭이동시 호출되는 이벤트
	$(function() {    $( "#tabs" ).tabs();  });
	/* $( "#tabs" ).tabs( {
		activate : function( event, ui ) {
			//selected_tab_name = ui.newPanel.selector;
			
			//$("input[name=selected_tab]").val(selected_tab_name);
			
			//var ifraId = fn_searchIfraId();
			//fn_ifraSetButtionEnable(ifraId);
			
			//fn_search();
		}
	} ); */
			
	/* 
	 그리드 데이터 저장
	 
	$("#btnSave").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_save();
		}
	}); */
	
	//조회 버튼
	$("#btnSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_search();
		}
	});

	// 엑셀Exoport 버튼 이벤트 
	$("#btnExcelExport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_excelDownload();	
		}
	});
	
	// 프로적트조회 버튼 이벤트 
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
		
	fn_searchLastRevision("INIT");
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
function changeTab(teamCode) {
	$("input[name=team_count]").val(teamCode);
	$("#teamIframe").attr("src","paintCosmeticTab.do?teamCode="+teamCode+"&menu_id=${menu_id}");
	//var ifraId = fn_searchIfraId();
	//fn_ifraSetButtionEnable(ifraId);
	fn_search();
}
// revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
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

//Add 버튼 
function addRow(addGbn, sPaintCode, sPaintDesc, nQty, nTheoryQty) {
	
	//fn_applyData("#itemGroupList",change_item_row_num,change_item_col);
	
	var rowid = fn_searchEqualPaintCode(sPaintCode);
	var item  = {};
	
	if (rowid == null) {
		
		var colModel = $('#itemGroupList').jqGrid('getGridParam', 'colModel');
		for(var i in colModel) item[colModel[i].name] = '';
		
		item.oper 	 		 = 'I';
		item.paint_item 	 = sPaintCode;
		item.item_desc  	 = sPaintDesc;
		item.quantity 		 = Math.round(Number(nQty)*100) / 100;
		item.theory_quantity = Math.round(nQty / 3 * 100) / 100;
		
		rowid = $.jgrid.randId();
		$('#itemGroupList').resetSelection();
		$('#itemGroupList').jqGrid('addRowData', rowid, item, 'first');
	
	} else {
	
		item = $('#itemGroupList').jqGrid('getRowData', rowid);
		
		var nQtySum = Math.round((parseFloat(item.quantity) + parseFloat(nQty)) * 100) / 100; 
		var nThQty  = Math.round(nQtySum / 3 * 100) / 100 ;
		
		if (item.oper != 'I')
			item.oper = 'U';
		
		item.quantity 		 = nQtySum;
		item.theory_quantity = nThQty;
		
		// apply the data which was entered.
		$('#itemGroupList').jqGrid("setRowData", rowid, item);
		
		// turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	
	}
	
	fn_jqGridChangedCell('#itemGroupList', rowid, 'chk', {background:'pink'});	
	tableId = '#itemGroupList';	
}

//Del 버튼
function deleteRow(){
	
	fn_applyData("#itemGroupList",change_item_row_num,change_item_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#itemGroupList').jqGrid('getRowData',selrow);
		
		if(item.oper != 'I') {
			item.oper = 'D';
			deleteData.push(item);
		}

		$('#itemGroupList').jqGrid('delRowData', selrow);
	}
	
	$('#itemGroupList').resetSelection();
}

// 그리드의 cell이 변경된 경우 호출되는 함수
function changeItemQuantityEditEnd(irowId, cellName, value, irow, iCol) {
	
	var item = $('#itemGroupList').jqGrid('getRowData', irowId);
	
	if (item.oper != 'I') item.oper = 'U';

	// apply the data which was entered.
	$('#itemGroupList').jqGrid("setRowData", irowId, item);
	
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//iframe Height 설정
function resizeIframe(obj) {
	 var iframeHeight=(obj).contentWindow.document.body.scrollHeight;
    (obj).height=iframeHeight+21;
}

// Text 입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// 그리드에 변경되 데이터validation체크 함수
function fn_checkCosmeticQuantityValidate(arr1) {
	var result   = true;
	var message  = "";
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드의 변경된 row를 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 프로젝트 수정여부 리턴하는 함수
function fn_isEditable() {
	
	if ("Y" == isLastRev && sState != "D") {
		return true;
	} else {
		return false;
	}
}

// iframe화면의 Grid 초기화하는 함수
function fn_tabGridClear() {
		
	var ifra = document.getElementById('machinaryTeam').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('paintingTeamCHold').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('paintingTeamHCover').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('paintingTeamEtc').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('paintingTeamFWTK').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('accommodationTeam').contentWindow;
	ifra.resetGrid();
	
	ifra = document.getElementById('accTeamOutfitting').contentWindow;
	ifra.resetGrid();

}

// 선택되어있는  iframe객체 리턴하는 함수
function fn_tabSearch(){
	
	var ifraId = fn_searchIfraId();
	return document.getElementById(ifraId).contentWindow;
	//ifra.fn_search();
}

// 선택되어있는  iframe객체 id를 리턴하는 함수
function fn_searchIfraId(){
	
	var ifraId="";
	switch(selected_tab_name) {
		case "#tabs-1":
			ifraId = "machinaryTeam";
			break;
		case "#tabs-2":
			ifraId = "paintingTeamCHold";
			break;
		case "#tabs-3":
			ifraId = "paintingTeamHCover";
			break;
		case "#tabs-4":
			ifraId = "paintingTeamEtc";
			break;
		case "#tabs-5":
			ifraId = "paintingTeamFWTK";
			break;
		case "#tabs-6":
			ifraId = "accommodationTeam";
			break;
		case "#tabs-7":
			ifraId = "accTeamOutfitting";
			break;					
	}
	
	return ifraId;
}

// 프로젝트의 revsion과상태에 따라 버튼 disable설정
function fn_setButtionEnable(sInit) {
	
	if ("Y" == isLastRev && sState != "D") {
		$( "#btnSave" ).removeAttr( "disabled" );
		$( "#btnSend").removeAttr( "disabled" );
		$( "#btnTransfer").removeAttr( "disabled" );
		
	} else {
		$( "#btnSave" ).attr( "disabled", true );
		$( "#btnSend" ).attr( "disabled", true );
		$( "#btnTransfer" ).attr( "disabled", true );
	}
	
	if (sInit != "INIT") {
		var ifraId = fn_searchIfraId();
		fn_ifraSetButtionEnable(ifraId);
	}
}

// iframe화면의 저장버튼 disabled설정
function fn_ifraSetButtionEnable(ifraId) {
	
	var ifra = document.getElementById(ifraId).contentWindow;
	
	if ("Y" == isLastRev && sState != "D") {
		ifra.fn_saveButtionEnable();
	} else {
		ifra.fn_saveButtionDisable();
	}
}

// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		alert("Project No is required");
		setTimeout('$("input[name=project_no]").focus()',200);		
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		alert("Revision is required");
		setTimeout('$("input[name=revision]").focus()',200);
		return false;
	}
	
	if (isExistProjNo == "N" && isLastCheck == true) {
		alert("Project No does not exist");
		return false;
	}
	
	if (sState == "D" && isLastCheck == true) {
		alert("State of the revision is released");
		return false;
	}
	
	if ( isLastRev == "N" && isLastCheck == true) {
		alert("PaintPlan Revision is not the end");
		return false;
	}
	
	return true;
}

//폼데이터를 Json Arry로 직렬화
function fn_getParam() {
	return fn_getFormData("#listForm");
}

//선택된 Team 설정
function fn_setSearchGbn(sGbn,sPaintGbn) {
	
	$("input[name=searchGbn]").val(sGbn);
	$("input[name=paint_gbn]").val(sPaintGbn);
	
	
	/* var sPaintGbn;
	
	switch(sGbn) {
		case "eRoomCosmetic":	
			sPaintGbn = "ERC";
			break;
		case "antiRustOil":	
			sPaintGbn = "ARO";
			break;
		case "cHoldCosmetic":	
			sPaintGbn = "CHL";
			break;
		case "hCoverCosmetic":	
			sPaintGbn = "HCV";
			break;
		case "sideLitterCosmetic":	
			sPaintGbn = "SLT";
			break;
		case "snapBackZoneCosmetic":	
			sPaintGbn = "SBZ";
			break;
		case "fwdwTkCosmetic":		
			sPaintGbn = "FDT";
			break;
		case "funnelMarking":	
			sPaintGbn = "FUM";
			break;
		case "mastPostDavitMaintenance":	
			sPaintGbn = "MPD";
			break;
		case "fireFoamLine":	
			sPaintGbn = "FFL";
			break;	
		case "noSmokingMark":	
			sPaintGbn = "SPT";
			break;	
		case "jointLine":	
			sPaintGbn = "JTL";
			break;
		case "insideMaintenance":	
			sPaintGbn = "IMP";
			break;
		case "accCosmetic":	
			sPaintGbn = "ACC";
			break;
		case "freeFallTypeDavit":	
			sPaintGbn = "FFD";
			break;					
		default:	
			sPaintGbn = "ETC";
			break;																			
	}
	
	$("input[name=paint_gbn]").val(sPaintGbn); */
}

//그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

//그리드에 동일한 Paint Item의 rowid를 찾는다
function fn_searchEqualPaintCode(sPaintCode) {
	
	var ids   = $("#itemGroupList").jqGrid('getDataIDs');
	
	for(var i=0; i<ids.length; i++) {
		
		var item =  $("#itemGroupList").jqGrid('getRowData', ids[i]);
		
		if (item.paint_item == sPaintCode) {
			
			return ids[i];
		}
	}
	
	return null;
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 프로젝트번호 조회하는 화면 호출
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()};
			   //,revision   : $("input[name=revision]").val()};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
	}
	
	fn_searchLastRevision();
}

// 프로젝트번호의 최종 REVSION상태 조회
function fn_searchLastRevision(sInit) {
	
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
	  			  			  		
	  		/* if (sInit != "INIT") fn_tabGridClear(); */
	  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	}).always(function() {
	   
	  	$("input[name=isLastRev]").val(isLastRev);
	    $("input[name=revStates]").val(sState);
	    
	  	/* fn_setButtionEnable(sInit); */
	  	// 처음 tab을 클릭시킨다.
		$( "#tab1" ).click();
	  	fn_search();
	
	}); 	 	

}

// 선택된 Team의 Paint Item합계를  조회하는 함수
function fn_search() {
	
	var sUrl = "infoCosmeticItemGroupList.do";
	
	$("#itemGroupList").jqGrid('setGridParam',{url			: sUrl
											   ,page		: 1
											   ,datatype	: 'json'
											   ,postData 	: fn_getFormData("#listForm")}).trigger("reloadGrid");
	fn_searchGroupDetail('','');
}
function fn_setArea(sArea){
	$("input[name=area]").val(sArea);
}
// Team의 Area저장하는 함수
function fn_saveArea(nArea) {
	
	if (!fn_ProjectNoCheck(false)) {
		return;
	}
	
	$("input[name=area]").val(nArea);
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var url			= "saveCosmeticArea.do";
	var parameters  = fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			if ( data.result == 'success' ) {
					
			 	// 여기서 조회한다.
			 	//fn_search();
			 	//fn_tabSearch();
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}

/* // Team의 Area조회하는 함수
function fn_searchCosmeticArea() {
	
	var url		    = "infoCosmeticArea.do";
 	var parameters  = fn_getFormData('#listForm');
						
	$.post(url, parameters, function(data) {
// 		var obj  = jQuery.parseJSON(data);
		var ifra = fn_tabSearch();
					
	  	if (obj.length > 0) {
	  		ifra.fn_setCosmeticArea(obj[0].area);
	  		//return  obj[0].area;
	  	} else {
	  		ifra.fn_setCosmeticArea("");
	  		//return "";
	  	}
	 
	});  	

} */
	


// Team Group에 Item추가 저장하는 함수
function fn_save() {
	
	var changePaintItemResultRows =  getChangedGridInfo("#itemGroupList");
	
	if (changePaintItemResultRows.length == 0) {
		alert("변경된 내용이 없습니다.");
		return;	
	}
	
	if (confirm('저장 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
			
	if (!fn_checkCosmeticQuantityValidate(changePaintItemResultRows)) { 
		lodingBox.remove();
		return;	
	}
	
	var url			= "saveCosmetic.do";
	var dataList    = {cosmeticList:JSON.stringify(changePaintItemResultRows)};
	var formData 	= fn_getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);

	$.post(url, parameters, function(data) {
			
			var obj = jQuery.parseJSON(data);
			
			alert(obj[0].Result_Msg);
			
			if (obj[0].result == "success") {
			 	// 여기서 조회한다.
			 	fn_search();
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
	});
}


// 조회 조건에 따른 내용을 엑셀 Export
function fn_excelDownload() {
		
	var f    = document.listForm;
	
	f.action = "cosmeticExcelExport.do";
	f.method = "post";
	f.submit();
	
}

//Add 버튼 
function plusPaintItem(addGbn, sPaintCode, sPaintDesc, nQty, nTheoryQty) {
	
	if (!fn_ProjectNoCheck(false)) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var addPaintItemResultRows =[{paint_item : sPaintCode, quantity:nQty, quantity:nQty}];
		
	var url			= "saveAddCosmetic.do";
	var dataList    = {chmResultList:JSON.stringify(addPaintItemResultRows)};
	var formData 	= fn_getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);
	
	
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			if ( data.result == 'success' ) {
			 	// 여기서 조회한다.
			 	fn_search();
			 	document.getElementById('teamIframe').contentWindow.fn_search();
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
	});
}

//Add 버튼 
function minusPaintItem(addGbn, sPaintCode, sPaintDesc, nQty, nTheoryQty) {
	
	if (!fn_ProjectNoCheck(false)) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var addPaintItemResultRows =[{paint_item : sPaintCode, quantity:nQty, quantity:nQty}];
		
	var url			= "saveMinusCosmetic.do";
	var dataList    = {chmResultList:JSON.stringify(addPaintItemResultRows)};
	var formData 	= fn_getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);
	
	
	$.post(url, parameters, function(data) {
			
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
		 	// 여기서 조회한다.
		 	fn_search();
		 	document.getElementById('teamIframe').contentWindow.fn_search();
		}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
	});
}
function fn_searchGroupDetail(sItemCode, sItemDesc) {
	$("#itemGroupDetail").jqGrid("setCaption", 'ITEM 구분 LIST - ' + sItemDesc);
	 $("input[name=group_item]").val(sItemCode);
	var sUrl = "infoCosmeticItemGroupDetail.do";
	$("#itemGroupDetail").jqGrid('setGridParam',{url		: sUrl
		                                   ,mtype		: 'POST' 
		                                   ,page		: 1
										   ,datatype	: 'json'
										   ,postData 	: fn_getFormData("#listForm")}).trigger("reloadGrid");
}
function selectItem(id, item){
	
	selectGbn = id;
	var rows = $( "#itemGroupList" ).getDataIDs();
	for ( var i = 0; i < rows.length; i++ ) {
		var item_desc = $( "#itemGroupList" ).getCell( rows[i], "item_desc" );
		var paint_item = $( "#itemGroupList" ).getCell( rows[i], "paint_item" );
		if (paint_item == item) {
			$( "#itemGroupList" ).jqGrid( 'editCell',rows[i], 2, true );
			fn_searchGroupDetail(paint_item, item_desc);
			return;
		}
		
	}
	$( "#itemGroupList" ).jqGrid( 'editCell',0, 1, false );
	fn_searchGroupDetail('','');
}
</script>
</html>