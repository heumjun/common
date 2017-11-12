<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint PE</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<div class= "subtitle">
Paint PE
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>

<input type="hidden"  name="pageYn" 	 value="N"/>
<input type="hidden"  name="projectNo"   value=<%=session.getAttribute("paint_project_no")%>  />
<input type="hidden"  name="p_code_gbn"  value="blockCode" />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

<table class="searchArea conSearch">
			<col width="110">
			<col width="210">
			<col width="110">
			<col width="120">
			<col width="" style="min-width:260px;">

			<tr>
				<th>PROJECT NO</th>
				<td>
					<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
					<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
					<input type="button" id="btnProjNo"  value="검색" class="btn_gray2">	
				</td>

				<th>P.E Code</th>
				<td>
				<input type="text" id="txtPECode" name="pe_code" style="width:100px;"/>
				</td>

				
			<td style="border-left:none;" colspan="2">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회" id="btnSearch"  class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">		
			<input type="button" value="저장" disabled id="btnSave"    class="btn_gray"/>
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" value="Excel출력"  		   id="btnExcelExport"   class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute6 == 'Y'}">
			<input type="button" value="Excel등록" disabled id="btnExcelImport"    class="btn_gray"/>
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
							<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" />
							<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
			</span>
		</div>
		<div class = "conSearch">
			<span class = "spanMargin">
			P.E Code
			<input type="text" id="txtPECode" name="pe_code" style="width:100px;"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" id="btnSearch"  />
			<input type="button" value="저  장" disabled id="btnSave"  />
			<input type="button" value="Excel등록" disabled id="btnExcelImport"  />
			<input type="button" value="Excel출력"  		   id="btnExcelExport"  />		
		</div>
	</div>
	
	-->
	
	

	<div class="content">
		<div id="peGridDiv" style="float:left; width:58%;">
			<table id = "peGrid"></table>
			<div   id = "p_peGrid"></div>
		</div>
		<div id="blockCodeListDiv" style="float:right;width:40%;">
			<div class="ct_sc">
				<strong class="pop_tit mgl10">Block Code</strong>
				<input type="text" id="txtBlockCodeFrom" name="blockCodeForm" style="width:70px;"/>
				&nbsp;~&nbsp;
				<input type="text" id="txtBlockCodeTo" name="blockCodeTo" style="width:70px;"/>
				<input type="button" value="조  회" id="btnBlockSearch"  class="btn_blue" />
			</div>
			<table id = "blockCodeList"></table>
			<div   id = "p_blockCodeList"></div> 
		</div>

	</div>	
	
	<!--
	<div style="min-width: 1200px; margin-top:4px">
		<div class="content" style="float: left;">
			<table id = "peGrid"></table>
			<div   id = "p_peGrid"></div>
		</div>	
		<div class="content" style="float: left; margin-left: 30px;">
			<div style="border: 1px solid white">
				Block Code
				<input type="text" id="txtBlockCodeFrom" name="blockCodeForm" style="width:70px;"/>
				&nbsp;~&nbsp;
				<input type="text" id="txtBlockCodeTo" name="blockCodeTo" style="width:70px;"/>
				<input type="button" value="조  회" id="btnBlockSearch"  style="float: right;"/>
			</div>
			<div style="margin-top: 15px;">
				<table id = "blockCodeList"></table>
				<div   id = "p_blockCodeList"></div> 
			</div>
		</div>	
	</div>
	-->
</div>	
</form>


<script type="text/javascript">

var change_pe_row 	  = 0;
var change_pe_row_num = 0;
var change_pe_col  	  = 0;

var tableId	   			 = "#peGrid";
var deleteData 			 = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

var isLastRev			 = "N";
var isExistProjNo		 = "N";					
var sState				 = "";	

var preProject_no;
var preRevision;

$(document).ready(function(){
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(1);
	
	$("#peGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', 'Project No','Rev', 'P.E Code', 'PRE PE','BLOCK', '이관블록', '', '','',''],
                colModel:[
                	{name:'chk', index:'chk', width:12,align:'center', sortable:false, formatter: formatOpt1},
                	{name:'project_no',index:'project_no', width:40,align:"center"},
                    {name:'revision', index:'revision', width:20,align:"right"},
                	{name:'pe_code',index:'pe_code', width:60, editable:true,editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                	{name:'pre_pe_code',index:'pre_pe_code', width:60, editable:true, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'block_code',index:'block_code', width:60, editable:true, editoptions:{maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'trans_block_flag', index:'trans_block_flag', width:30,align:'center',editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
                    {name:'trans_block_flag_changed', index : 'trans_block_flag_changed', hidden : true},
                    {name:'pe_rowid',index:'pe_rowid', width:25, hidden:true},   
                    {name:'add_gbn', index:'add_gbn',   hidden:true},                
                    {name:'oper',	 index:'oper', width:25, hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             width		: $(window).width() * 0.56,
            
             height		: objectHeight,
             pager		: $('#p_peGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changePEEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "pe_code" || name == "block_code" || name == "pre_pe_code") setUpperCase("#peGrid",rowid,name);	
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
			  	
			  	$("#chkHeader").prop("checked", false);	
			    deleteArrayClear();
			    fn_searchBlock();
			    
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
			 gridComplete: function(data){
				fn_selectPaintNewRuleFlag();
				 
				var rows = $( "#peGrid" ).getDataIDs();
			 	var changeFlag = true;
				var pre_pe_code;
			 	var pe_code;
				for ( var i = 0; i < rows.length; i++ ) {
					//수정 및 결재 가능한 리스트 색상 변경
					var oper = $( "#peGrid" ).getCell( rows[i], "oper" );
					pe_code = $("#peGrid").getCell(rows[i],"pe_code");
					if(pe_code != pre_pe_code) {
			    		if(changeFlag) {
			    			changeFlag = false;
			    		} else {
			    			changeFlag = true;
			    		}
			    		pre_pe_code = $("#peGrid").getCell(rows[i],"pe_code");
			    	} 
					if(changeFlag) {
						$("#peGrid").jqGrid('setRowData',rows[i], false, {  background:'#eeeeee'});
						if(oper != "D"){
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#DADADA' } );
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'block_code', '', { color : 'black', background : '#DADADA' } );
						}
					}else{
						$("#peGrid").jqGrid('setRowData',rows[i], false, {  background:'white'});
						if(oper != "D"){
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#eeeeee' } );
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#eeeeee' } );
							$( "#peGrid" ).jqGrid( 'setCell', rows[i], 'block_code', '', { color : 'black', background : '#eeeeee' } );
						}
					}
					
				}
			 },
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_pe_row 	=	rowid;
             	change_pe_row_num =	iRow;
             	change_pe_col 	=	iCol;
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
             	
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#peGrid").getRowData(row_id);
                	
                	if (ret.oper != "I") {
	                	switch(colId) {
	                		/* case 4:
	                			jQuery("#peGrid").jqGrid('setCell', row_id, 'pe_code', '', 'not-editable-cell'); */	
	                		case 6:
	                			jQuery("#peGrid").jqGrid('setCell', row_id, 'block_code', '', 'not-editable-cell');
	                		default :
	                			break;
	                	}
                	} else {
                		if (ret.add_gbn == "grid") $("#peGrid").jqGrid('setCell', row_id, 'block_code', '', 'not-editable-cell');                	
                	}
                } 
             }
    }); 

	// 그리드 버튼 설정
	$("#peGrid").jqGrid('navGrid',"#p_peGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정
	$("#peGrid").navButtonAdd("#p_peGrid",
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
	
	<c:if test="${userRole.attribute3 == 'Y'}">
	// 그리드 Row 삭제 함수 설정
	$("#peGrid").navButtonAdd('#p_peGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	/* <c:if test="${userRole.attribute2 == 'Y'}">
	// 그리드 Row 추가 함수 설정
 	$("#peGrid").navButtonAdd('#p_peGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	); 
 	</c:if>
 	*/
	$("#blockCodeList").jqGrid({ 
            datatype	: 'json', 
            mtype		: '', 
            url			: '',
            postData 	: getFormData("#listForm"),
            editUrl  	: 'clientArray',
       	 	colNames :['BLOCK CODE',''],
               colModel:[
                   {name:'block_code',index:'block_code', width:100, sortable:false, editoptions:{size:11}},
                   {name:'oper',index:'oper', width:25, hidden:true}
               ],
            gridview	: true,
            cmTemplate: { title: false },
            toolbar		: [false, "bottom"],
            viewrecords : true,   
            autowidth:true,
            width		: $(window).width()  * 0.25,
            height		: objectHeight - 40,
            rowNum		: 99999,
            cellEdit	: true,             // grid edit mode 1
            pager		: $('#p_blockCodeList'),
             
            pgbuttons	: false,
		 	pgtext		: false,
		 	pginput		: false,
            jsonReader : {
                root: "rows",
                page: "page",
                total: "total",
                records: "records",  
                repeatitems: false,
               },        
            imgpath: 'themes/basic/images',
            ondblClickRow: function(rowId) {
   			
		 },
		 loadComplete: function() {
            
		 },
		 onCellSelect: function(rowid, colId) {
		 	
	 		var ret = $("#blockCodeList").getRowData(rowid);
 		 	
 		 	if (!isBlockDuplication("#peGrid",ret.block_code)) {
 		 	 	// 행추가
	 		 	addBlockCodePeGrid("grid", ret.block_code);	
	 		 	
	 		 	// 행삭제
	 		 	$('#blockCodeList').jqGrid('delRowData', rowid);
	 		} else {
	 		
	 		}		 	
		 	
		 	/*
		 	var $togrid   = $("#blockCodeList");
		 	var $fromgrid = $("#peGrid");
		 	var formRowid = $fromgrid.jqGrid('getGridParam','selrow');  
		 	
		 	if (formRowid != null && $fromgrid.getCell(formRowid,'oper') == "I"
		 		&& fn_isExistBlock($togrid.getCell(rowid,colId))) 
		 	{
		 		
		 		fn_applyData("#peGrid",change_pe_row_num,change_pe_col);
		 		
		 		$fromgrid.setCell(formRowid,"block_code",$togrid.getCell(rowid,colId));	
		 	}*/
		 }
    });
	//grid resize
	fn_insideGridresize($(window),$("#peGridDiv"),$("#peGrid"),5);
	fn_insideGridresize($(window),$("#blockCodeListDiv"),$("#blockCodeList"),40);
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	//조회 버튼
	$("#btnSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_search();
		}
	});
	
	//Block 조회 버튼
	$("#btnBlockSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_searchBlock();
		}
	});
	
	//엑셀 Import 버튼
	$("#btnExcelImport").click(function() {
		if (fn_ProjectNoCheck(true)) {
			fn_excelUpload();	
		}
	});
	
	//엑셀 Export 버튼
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
		
	// 프로젝트 조회 버튼	
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	fn_searchLastRevision();
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow(){
	
	fn_applyData("#peGrid",change_pe_row_num,change_pe_col);
		
	//가져온 배열중에서 필요한 배열만 골라내기 
	if (fn_ProjectNoCheck(true)) {
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		
		for(var i=0;i<selarrrow.length-1;i++){
			var selrow = selarrrow[i];	
			var item   = $('#peGrid').jqGrid('getRowData',selrow);
			
			if(item.oper =='') {
				item.oper = 'D';
				$('#peGrid').jqGrid("setRowData", selrow, item);
				var colModel = $( '#peGrid' ).jqGrid( 'getGridParam', 'colModel' );
				
				for( var j in colModel ) {
					$( '#peGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
				}
				
				//deleteData.push(item);
			} else if(item.oper == 'I') {
				if (!isBlockDuplication("#blockCodeList",item.block_code) && !$.jgrid.isEmpty(item.block_code)
						&& (item.oper != 'I' || (item.oper == 'I' && item.add_gbn == "grid")))
					{
						addBlockCodeBlockGrid(null,item.block_code);
					}
					
					$('#peGrid').jqGrid('delRowData', selrow);
			} else if(item.oper == 'U') {
				alert("수정된 내용은 삭제 할수 없습니다.");
			}
			
		}
	}
	
	$('#peGrid').resetSelection();
}

// Add 버튼 
function addRow(item) {

	addBlockCodePeGrid('',null);
	
	tableId = '#peGrid';	
}

// afterSaveCell oper 값 지정
function changePEEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#peGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#peGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#peGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	fn_jqGridChangedCell('#peGrid', irowId, 'chk', {background:'pink'});
	$("input.editable,select.editable", this).attr("editable", "0");
}	

// header checkbox action 
function checkBoxHeader(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 동일한 block_code가 존재하느지 체크
function isBlockDuplication(gridId,sBlockCode) {

	var ids = $(gridId).jqGrid('getDataIDs');
	var bRs = false;
	for (var i=0; i<ids.length; i++) {

		if (sBlockCode == $(gridId).getCell(ids[i],'block_code')) {
			bRs = true;
			break;
		}
	}
	
	return bRs;
}

// Block 그리드 Row 추가
function addBlockCodeBlockGrid(addGbn, sBlockCode) {
	var item = {};
	var colModel = $('#blockCodeList').jqGrid('getGridParam', 'colModel');
	
	// 초기화 한다.
	for(var i in colModel) item[colModel[i].name] = '';
	item.block_code  = sBlockCode;
				
	$('#blockCodeList').resetSelection();
	$('#blockCodeList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
}

// PE 그리드 Row 추가
function addBlockCodePeGrid(sAddGbn, sBlockCode) {
	
	fn_applyData("#peGrid",change_pe_row_num,change_pe_col);
	
	if (fn_ProjectNoCheck(true)) {
		var item = {};
		var colModel = $('#peGrid').jqGrid('getGridParam', 'colModel');
		
		// 초기화 한다.
		for(var i in colModel) item[colModel[i].name] = '';
		
		// 기본값 설정한다.
		item.oper 	    = 'I';
		item.revision   = $('input[name=revision]').val();
		item.project_no = $('input[name=project_no]').val();
		item.pe_code 	= $('input[name=pe_code]').val();
		//item.pe_desc    = $('input[name=project_no]').val()+"_";
		
		if (sAddGbn == "grid") {
			item.block_code  = sBlockCode;
			item.add_gbn  	 = sAddGbn;
		}
		
		var nRandId = $.jgrid.randId();		
		
		$('#peGrid').resetSelection();
		$('#peGrid').jqGrid('addRowData', nRandId, item, 'first');
		
		fn_jqGridChangedCell('#peGrid', nRandId, 'chk', {background:'pink'});
	}	
}

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "pe_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		$("input[name=project_no]").focus();
		alert("Project No is required");
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		$("input[name=revision]").focus();
		alert("Revision is required");
		//setTimeout('$("input[name=revision]").focus()',200);
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

// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드에 변경된 데이터Validation체크하는 함수	
function fn_checkPEValidate(arr1) {
	var result   = true;
	var message  = "";
	var $grid	 = $("#peGrid");
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	// 이부분이 조회된 row가 많으면 시간 오래 걸림... block code 중복 체크 제거. block code가  KEY IN이 아닌 미연계 BLOCK 선택 연계이기에 중복체크 필요없을듯
	/***
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
		
		for(var i=0; i < ids.length; i++) {
		
			var iRow = $grid.jqGrid('getRowData', ids[i]);
									
			for (var j = i+1; j <ids.length; j++) {
				
				var jRow = $grid.jqGrid('getRowData', ids[j]);
				
				if (iRow.block_code == jRow.block_code) {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW, "+$grid.jqGrid('getInd',ids[j])+"ROW는 Block Code가 중복됩니다.";	
					break;	
				}
			}
			
			if (result == false) break;
		}
	}
	***/
		
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $grid.jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $grid.jqGrid('getCell', ids[i], 'pe_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "PE Code Field is required";
					
					setErrorFocus("#peGrid",ids[i],4,'pe_code');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'block_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Block Code Field is required";
					
					setErrorFocus("#peGrid",ids[i],6,'block_code');
					break;
				}
			}
		}
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// 그리드의 변경된 Row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	
	//changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.moveTo(200,0);
    win.resizeTo(720, 760);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 그리드에  checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

// Revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
}

// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// 프로젝트 리비젼에 따라 버튼 enable설정하는 함수
function fn_setButtionEnable() {
	
	if ("Y" == isLastRev && sState != "D") {
		$( "#btnSave" ).removeAttr( "disabled" );
		$( "#btnSave" ).removeClass("btn_gray");
		$( "#btnSave" ).addClass("btn_blue");
		
		$( "#btnExcelImport" ).removeAttr( "disabled" );
		$( "#btnExcelImport" ).removeClass("btn_gray");
		$( "#btnExcelImport" ).addClass("btn_blue");
		//$( "#btnExcelExport").removeAttr( "disabled" );
	} else {
		$( "#btnSave" ).attr( "disabled", true );
		$( "#btnSave" ).removeClass( "btn_blue" );
		$( "#btnSave" ).addClass( "btn_gray" );
		
		$( "#btnExcelImport" ).attr( "disabled", true );
		$( "#btnExcelImport" ).removeClass( "btn_blue" );
		$( "#btnExcelImport" ).addClass( "btn_gray" );
		//$( "#btnExcelExport" ).attr( "disabled", true );
	}

}

// 동일한 area code가 존재하느지 체크
function fn_isExistBlock(sBlockCode) {
	var ids = $("#peGrid").jqGrid('getDataIDs');	
	for(var  i = 0; i < ids.length; i++) {
		var formVal = $("#peGrid").jqGrid('getCell', ids[i], 'block_code');
		
		if (sBlockCode == formVal) return false;
	}
	return true;
}
	
/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#peGrid",change_pe_row_num,change_pe_col);
	
	var gridData = $("#peGrid").jqGrid('getRowData');

	// 변경된 체크 박스가 있는지 체크한다.
	for (var i = 1; i < gridData.length + 1; i++) {
		var item = $('#peGrid').jqGrid('getRowData', i);

		// area_master(대표구역)의 변경여부 확인하여 변경 시 업데이트 대상으로 변경
		if (item.oper != 'I' && item.oper != 'U') {
			if (item.trans_block_flag_changed != item.trans_block_flag) {
				item.oper = 'U';
			}

			if (item.oper == 'U') {
				$('#peGrid').jqGrid("setRowData", i, item);
			}
		}
	}		
	
	var changePEResultRows =  getChangedGridInfo("#peGrid");;
	
	if (!fn_checkPEValidate(changePEResultRows)) { 
		return;	
	}
	
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#peGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#peGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintPE.do";
	var dataList    = {chmResultList:JSON.stringify(changePEResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			
			if (data.result == "success") fn_search();
		
		}, "json" ).error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
	    	lodingBox.remove();	
		});
}

// PE Code와 Block Code 맵핑 정보 조회
function fn_search() {
				
	var sUrl = "searchPaintPE.do";
	jQuery("#peGrid").jqGrid('setGridParam',{url		: sUrl
											  ,mtype	: 'POST'
											  ,page		: 1
											  ,datatype	: 'json'
											  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 

// 프로젝트 Block Code List 조회
function fn_searchBlock() {
	var sUrl = "selectPaintBlockList.do";
	jQuery("#blockCodeList").jqGrid('setGridParam',{url		: sUrl
												  ,mtype	: 'POST'
												  ,page		: 1
												  ,datatype	: 'json'
												  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
}

// 엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	var sUrl = "popUpExcelUpload.do?gbn=peExcelImport.do";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();	
			   									
	win = window.open(sUrl,"listForm","height=260,width=680,top=200,left=200");
}

// 엑셀 다운로드 화면 호출
function fn_excelDownload() {
	var sUrl = "peExcelExport.do?";
	sUrl += "&peCodeForm="+$("input[name=peCodeForm]").val();
	sUrl += "&peCodeTo="+$("input[name=peCodeTo]").val();	
	sUrl += "&project_no="+$("input[name=project_no]").val();
	sUrl += "&revision="+$("input[name=revision]").val();	
	
	location.href=sUrl;
}

// Block Code 조회하는 화면 호출
/* function searchBlockCode(obj,sCode,sDesc) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#peGrid",change_pe_row_num,change_pe_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {
				p_code_find : item.block_code,
				project_no	: item.project_no,
				revision	: item.revision
	};
		
	var rs = window.showModalDialog("popUpBlockCode.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	//var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupStageCode",args,"dialogWidth:500px; dialogHeight:600px; center:on; scroll:off; status:off; location:no");
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
	}	
} */

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

// 프로젝트 최종 리비젼 조회하는 함수
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
	  		$("#peGrid").clearGridData(true);
	  		$("#blockCodeList").clearGridData(true);
	  		deleteArrayClear();
	  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  		  	
	  	fn_setButtionEnable();
	});  	
}

// 해당호선이 DIS 적용 호선인지, PLM Mig 호선인지 판단
function fn_selectPaintNewRuleFlag() {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		//$("input[name=project_no]").focus();
		return false;
	}	
				
	var url		   = "selectPaintNewRuleFlag.do";
 	var parameters = {project_no : $("input[name=project_no]").val()};
						
	$.post(url, parameters, function(data) {
	  
		if (data != null) {
			
	  		if (data.paint_new_rule_flag == "Y") 
	  		{
	  			// DIS호선은 이관블럭 숨김  
	  			$( "#peGrid" ).hideCol( "trans_block_flag" );
	  		} else if(data.paint_new_rule_flag == "N"){	 
	  			// PLM Mig 호선인 경우만 이관블록 컬럼 보임
	  			$( "#peGrid" ).showCol( "trans_block_flag" ); 			
	  		}
	  	} else {
	  		return;
	  	}

	}); 
} 

</script>
</body>
</html>