<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>항목관리</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div id="mainDiv" class="mainDiv">
<form name="listForm" id="listForm"  method="get">
	
	
		<div class= "subtitle">
		항목관리
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<input type="hidden"  name="pageYn" value="N"/>
		<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
		<input type="hidden" id="supply_admin" name="supply_admin" value=""/>
		
		<input type="hidden" id="h_supplyId" name="h_supplyId" value=""/>
		
		
		<table class="searchArea conSearch" >
		<col width="40">
		<col width="100">
		<col width="40">
		<col width="100">
		<col width="60">
		<col width="110">
		<col width="60">
		<col width="110">
		<col width="90">
		<col width="155">
		<col width="50">
		<col width="145">
		<col width="50">
		<col width="130">
		<col width="*">

		<tr>
			<th>항목</th>
			<td>
				<input type="text" id="i_supplyId" maxlength="5" name="i_supplyId" style="width:70px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>

			<th>구분</th>
			<td>
				<select name="i_gubun" class="readonlyInput" id="i_gubun" style="width:70px;" >
					<option value=""></option>
				</select>
			</td>
			
			<th>GROUP</th>
			<td>
				<input type="text" id="i_group1" name="i_group1" style="width:80px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>직 종</th>
			<td>
				<input type="text" id="i_group2" name="i_group2" style="width:80px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>DESCRIPTION</th>
			<td>
				<input type="text" id="i_description" name="i_description" style="width:130px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>견적항목</th>
			<td>
				<select name="i_sel_join_data" id="i_sel_join_data" style="width:120px;" onchange="javascript:joinDataOnChange(this);" >
				</select>
				<input type="hidden" name="p_join_data" value=""  />
			</td>
			
			<th>DEPT</th>
			<td>
				<input type="text" id="i_dept" name="i_dept" style="width:100px; text-align:center; text-transform: uppercase;" />
			</td>

			<td class="bdl_no" colspan="2">
				<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="조 회"  id="btnSearch"  class="btn_blue"/>
					</c:if>
					<!-- c:if test="${userRole.attribute4 == 'Y'}"-->
						<input type="button" value="저 장" 	 id="btnSave"  class="btn_blue"/>
					<!-- /c:if -->	
					<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" value="Excel출력"  id="btnExcelExport"  class="btn_blue"/>
					</c:if>
				</div>
			</td>
		</tr>
		</table>
					
			<div class="content" >
				<div id="divMain">
			  		<table id ="supplyManageList"></table>
					<div id ="p_supplyManageList"></div>
				</div>
			</div>
			
			<fieldset style="margin-top:10px; padding-right:0.5%; border:none; position:relative; float:left; width:59.9%; ">
				<legend  class="sc_tit sc_tit2">DWG INFO</legend>
			</fieldset>

			<fieldset style="margin-top:10px; border:none; position:relative; float:left; width:39.5%;">
				<legend  class="sc_tit sc_tit2">ITEM INFO</legend>
			</fieldset>
			
			<div class="content"  style="position:relative; float: left; width: 15%;">
				<div id="divList1">
			  		<table id ="supplyDwgList"></table>
			  		<div id ="p_supplyDwgList"></div>
				</div>
			</div>
			
			<div class="content"  style="position:relative; float: left; width: 15%;">
				<div id="divList2">
			  		<table id ="supplyBlockList"></table>
			  		<div id ="p_supplyBlockList"></div>
				</div>
			</div>
			
			<div class="content"  style="position:relative; float: left; width: 15%;">
				<div id="divList3">
			  		<table id ="supplyStageList"></table>
			  		<div id ="p_supplyStageList"></div>
				</div>
			</div>
			
			<div class="content"  style="position:relative; float: left; width: 15%;">
				<div id="divList4">
			  		<table id ="supplyStrList"></table>
			  		<div id ="p_supplyStrList"></div>
				</div>
			</div>
			
			<div class="content"  style="position:relative; float: right; width: 39.5%;">
				<div id="divList5">
					<table id = "supplyCatalogList"></table>
					<div id ="p_supplyCatalogList"></div>
				</div>
			</div>
	</div>
</form>

</body>

<script type="text/javascript">
var initManageSearch	 = "N"; //메인   그리드 최초 조회시 "Y"로변경되며 "Y"일때만 행을 추가할 수 있음
var initDetailSearch	 = "N"; //디테일 그리드 최초 조회시 "Y"로변경되며 "Y"일때만 행을 추가할 수 있음

var manageChangedCnt	 = 0;  //메인 그리드 저장시 변경된 ROW 수 임시저장
var dwgChangedCnt	 	 = 0;  //DWG 그리드 저장시 변경된 ROW 수 임시저장
var catalogChangedCnt	 = 0;  //CATALOG 그리드 저장시 변경된 ROW 수 임시저장

var selectManageRowId	 = "";  //가장 마지막에 선택한 ROW ID

var idRow;
var idCol;
var kRow;
var kCol;
var tableId	   			 = "#";
var resultData 			 = [];

var idRow1;
var idCol1;
var kRow1;
var kCol1;

var idRow2;
var idCol2;
var kRow2;
var kCol2;

var idRow3;
var idCol3;
var kRow3;
var kCol3;

var idRow4;
var idCol4;
var kRow4;
var kCol4;

var idRow5;
var idCol5;
var kRow5;
var kCol5;

//삭제 데이터
var manageDeleteData = [];
var dwgDeleteData = [];
var catalogDeleteData = [];

var lodingBox; 
var win;	

var isExistProjNo		 = "N";					
var sState				 = "";	

var preProject_no		 = "";
var preRevision			 = "";

var change_item_row 	 = 0;
var change_item_row_num  = 0;
var change_item_col  	 = 0;
var objHeight = $(window).height()/2-190;
var selectGbn;

var dwgCategory;

//견적항목 조회조건 SELECT BOX
getAjaxHtml($("#i_sel_join_data"),"commonSelectBoxDataList.do?sb_type=sel&sd_type=SUPPLY_PLAN_TRACK&p_query=getSupplyChartJoinDataList", null, null);

$(document).ready(function(){
	
	var joinDataOnChange = function(obj) {
		$("input[name=p_join_data]").val($(obj).find("option:selected").val());
		//$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
	}
	
	// 접속권한에 따른 설정 
	$.post( "supplyManageLoginGubun.do", "", function( data ) {
		$("#supply_admin").val(data.supply_admin);
		if(data.supply_admin == 'N'){ 
			fn_buttonDisabled([ "#btnSave" ]); 
		}
	}, "json" );
	
	//Dept. 조회조건 SelectBox 리스트를 불러옴
	$.post( "infoComboCodeMaster.do?sd_type=SUPPLY_GBN", "", function( data ) {
		for(var i =0; i < data.length; i++){
			 $("#i_gubun").append("<option value='"+data[i].value+"'>"+data[i].text+"</option>");
		}
		
	}, "json" );
	
	//dwgCategory = getAjaxTextPost(null, ".tbc", form.serialize(), getdwgnoCallback);
	
	$(window).bind('resize', function() {
		$("#center").css({'height':  $(window).height()/2-100});
		$("#teamIframe").css({'height':  $(window).height()/2-150});
	}).trigger('resize');
	
	$("#supplyManageList").jqGrid({ 
        datatype	: 'json', 
        mtype		: '', 
        url		: '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader1" onclick="checkBoxHeader(event, this.id)" />','항목','구분', 'GROUP','직종','DESCRIPTION','UOM1', 'UOM2', 'RANK', '견적항목', 'DEPTCODE', 'DEPT', 'RESULT', 'RESULT_TEMP', '견적', 'REMARK', 'OPER'],
           colModel:[
				{name:'chk', index:'chk', width:15,align:'center',formatter: formatOpt1},
              	{name:'supply_id', index:'supply_id', width:50, align:'center'},
              	{name:'gbn', index:'gbn', width:50, align:'center', editable : true, edittype : "select", formatter : 'select'},
              	{name:'group1', index:'group1', width:100, align:'center', editable : true, sortable:true},
           		{name:'group2', index:'group2', width:100, align:'center', editable : true, sortable:true},
              	{name:'description', index:'description', width:200, editable : true, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
              	{name:'uom1', index:'uom1', width:50, align:'center', editable : true, edittype : "select", formatter : 'select'},
              	{name:'uom2', index:'uom2', width:50, align:'center', editable : true, edittype : "select", editoptions:{value:"BASE:BASE;ATTR1:ATTR1;ATTR2:ATTR2;ATTR3:ATTR3;ATTR4:ATTR4;ATTR5:ATTR5;ATTR6:ATTR6;ATTR7:ATTR7;ATTR8:ATTR8;ATTR9:ATTR9;ATTR10:ATTR10;ATTR11:ATTR11;ATTR12:ATTR12;ATTR13:ATTR13;ATTR14:ATTR14;ATTR15:ATTR15;TEXT:TEXT;ALL:ALL"}},
              	{name:'rank', index:'rank', width:50, align:'center', editable : true, editrules:{number:true}},
              	{name:'join_data', index:'join_data', width:120, align:'center', editable : true, edittype : "select", formatter : 'select'},
              	{name:'dept_code', index:'dept_code', width:100, align:'center', hidden:true},
              	{name:'dept_code_desc', index:'dept_code_desc', width:100, align:'center'},
              	{name:'result_yn', index:'result_yn', width:50, align:'center', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
              	{name:'result_yn_temp', index:'result_yn_temp', hidden:true},
              	{name:'unit_yn', index:'unit_yn', width:50, align:'center', editable : true, edittype : "select", editoptions:{value:"Y:Y;N:N"}},
              	{name:'remark', index:'remark', width:150, editable : true, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
               	{name:'oper', index:'oper', width:25, hidden:true}
           ],
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
        //width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 100,
        hidegrid : false,
        pager		: $('#p_supplyManageList'),
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
		beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			idRow = rowid;
			idCol = iCol;
			kRow = iRow;
			kCol = iCol;		
		},
        beforeSaveCell : changeManageEditEnd,
		 afterSaveCell  : function(rowid,cellname,value,iRow,iCol) {
         	if (cellname == "description" || cellname == "remark") setUpperCase('#supplyManageList',rowid,cellname);
		 },
        rowList	: [100,500,1000],
		rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
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
			  	
			  	$("#chkHeader1").prop("checked", false);	
			    deleteArrayClear();
			  
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
		 gridComplete : function () {
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				
				var ret = $( this ).getRowData( rows[i] );
				$(this).jqGrid( 'setCell', rows[i], 'supply_id', '', { background : '#DADADA' } );
				
				if ( $("#supply_admin").val() == "Y" ){
					$(this).jqGrid( 'setCell', rows[i], 'gbn', '', { background : '#FFFF99' } );
				 	if(ret.uom2 == "TEXT"){
				 		$(this).jqGrid( 'setCell', rows[i], 'uom1', '', { background : '#DADADA' } );	
				 	} else {
				 		$(this).jqGrid( 'setCell', rows[i], 'uom1', '', { background : '#FFFF99' } );
				 	}
				 	$(this).jqGrid( 'setCell', rows[i], 'uom2', '', { background : '#FFFF99' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'rank', '', { background : '#FFFF99' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'join_data', '', { background : '#FFFF99' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'dept_code_desc', '', { background : '#FFFF99' } );
				}
				else {
					$(this).jqGrid( 'setCell', rows[i], 'gbn', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'group1', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'group2', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'description', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'uom1', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'uom2', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'rank', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'join_data', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'dept_code_desc', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'unit_yn', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'remark', '', 'not-editable-cell' );
				}
			}
		 },	  
		 onCellSelect: function(row_id, colId) {
			$( '#supplyManageList' ).saveCell( kRow, idCol );
			$( '#supplyDwgList' ).saveCell( kRow1, idCol1 );
			$( '#supplyBlockList' ).saveCell( kRow2, idCol2 );
			$( '#supplyStageList' ).saveCell( kRow3, idCol3 );
			$( '#supplyStrList' ).saveCell( kRow4, idCol4 );
			$( '#supplyCatalogList' ).saveCell( kRow5, idCol5 );
			
			var changedCnt = 0;
			var ret = $( "#supplyManageList" ).getRowData( row_id );
			$("#h_supplyId").val(ret.supply_id);
			
			var cm = $(this).jqGrid( "getGridParam", "colModel" );
			var colName = cm[colId];
			
			fn_dwgSearch();
			fn_catalogSearch();
			selectManageRowId = row_id;
			
			if ( colName['index'] == "dept_code_desc" && $("#supply_admin").val() == "Y" ) {
				
				var rs = window.showModalDialog( "popUpSupplyDeptCode.do",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );

				if ( rs != null ) {
					$(this).setRowData( row_id, { dept_code : rs[0] } );
					$(this).setRowData( row_id, { dept_code_desc : rs[1] } );

					if ( ret.oper != 'I' ) {
						$(this).setRowData( row_id, { oper : "U" } );
					}
				}	
			}
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
	
	$("#supplyDwgList").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader2" onclick="checkBoxHeader(event, this.id)" />','SUPPLY_ID','SUPPLY_TYPE','DWG CATEGORY','OLD_VALUE','OPER'],
                colModel:[
                   	{name:'chk', index:'chk', width:19,align:'center',formatter: formatOpt2},
                   	{name:'supply_id', dex:'supply_id', sortable:false, hidden:true},
                   	{name:'supply_type', dex:'supply_type', sortable:false, hidden:true},
                   	{name:'value', index:'value', width:150, editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                   	{name:'old_value', index:'old_value', editable:false, hidden:true},
                    {name:'oper', index:'oper', width:25, hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
	         pgbuttons : false,
             pgtext : false,
             pginput : false,
             viewrecords: true,                		//하단 레코드 수 표시 유무
            // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
             autowidth	: true,
             height : $(window).height()/2 - 200,
             hidegrid : false,
             pager		: $('#p_supplyDwgList'),
             cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         beforeSaveCell : changeDwgEditEnd,
// 	         rowList	: [100,500,1000],
// 			 rowNum		: 100, 
	         rownumbers : true,          	// 리스트 순번
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
	        	 if (name == "value") setUpperCase('#supplyDwgList',rowid,name);
	         },
	         onPaging: function(pgButton) {

			 },
			 gridComplete : function (data) {
	        	var rows = $(this).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					if ( $("#supply_admin").val() == "Y" ){
				 		$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
					}
					else{
						$(this).jqGrid( 'setCell', rows[i], 'value', '', 'not-editable-cell' );
					}
				 }
			 },	         
			 beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
		 		idRow1 = rowid;
	 			idCol1 = iCol;
				kRow1 = iRow;
				kCol1 = iCol;
  			 },
			 onCellSelect: function(row_id, colId) {
				 var ret 	= jQuery("#supplyDwgList").getRowData(row_id);
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
	
	
	$("#supplyBlockList").jqGrid({ 
        datatype	: 'json', 
        mtype		: '', 
        url		: '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader3" onclick="checkBoxHeader(event, this.id)" />','SUPPLY_ID','SUPPLY_TYPE','BLOCK','OLD_VALUE','OPER'],
           colModel:[
				{name:'chk', index:'chk', width:19,align:'center',formatter: formatOpt3},
				{name:'supply_id', dex:'supply_id', sortable:false, hidden:true},
				{name:'supply_type', dex:'supply_type', sortable:false, hidden:true},
				{name:'value', index:'value', width:150, editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
				{name:'old_value', index:'old_value', editable:false, hidden:true},
				{name:'oper', index:'oper', width:25, hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 200,
        hidegrid : false,
        pager		: $('#p_supplyBlockList'),
        pgbuttons : false,
        pgtext : false,
        pginput : false,
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        beforeSaveCell : changeBlockEditEnd,
//         rowList	: [100,500,1000],
// 		 rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
       		if (name == "value") setUpperCase('#supplyBlockList',rowid,name);
        },
        onPaging: function(pgButton) {

		 },
		 gridComplete : function (data) {
       	var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				if ( $("#supply_admin").val() == "Y" ){
			 		$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
				}
				else{
					$(this).jqGrid( 'setCell', rows[i], 'value', '', 'not-editable-cell' );
				}
			 }
		 },	         
		 beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
	 		idRow2 = rowid;
			idCol2 = iCol;
			kRow2 = iRow;
			kCol2 = iCol;
			 },
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#supplyBlockList").getRowData(row_id);
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
	
	$("#supplyStageList").jqGrid({ 
        datatype	: 'json', 
        mtype		: '', 
        url		: '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader4" onclick="checkBoxHeader(event, this.id)" />','SUPPLY_ID','SUPPLY_TYPE','STAGE','OLD_VALUE','OPER'],
           colModel:[
				{name:'chk', index:'chk', width:19,align:'center',formatter: formatOpt4},
				{name:'supply_id', dex:'supply_id', sortable:false, hidden:true},
				{name:'supply_type', dex:'supply_type', sortable:false, hidden:true},
				{name:'value', index:'value', width:150, editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
				{name:'old_value', index:'old_value', editable:false, hidden:true},
				{name:'oper', index:'oper', width:25, hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 200,
        hidegrid : false,
        pager		: $('#p_supplyStageList'),
        pgbuttons : false,
        pgtext : false,
        pginput : false,
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        beforeSaveCell : changeStageEditEnd,
//         rowList	: [100,500,1000],
// 		 rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
       		if (name == "value") setUpperCase('#supplyStageList',rowid,name);
        },
        onPaging: function(pgButton) {

		 },
		 gridComplete : function (data) {
       	var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				if ( $("#supply_admin").val() == "Y" ){
			 		$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
				}
				else{
					$(this).jqGrid( 'setCell', rows[i], 'value', '', 'not-editable-cell' );
				}
			 }
		 },	         
		 beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
	 		idRow3 = rowid;
			idCol3 = iCol;
			kRow3 = iRow;
			kCol3 = iCol;
			 },
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#supplyStageList").getRowData(row_id);
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
	
	$("#supplyStrList").jqGrid({ 
        datatype	: 'json', 
        mtype		: '', 
        url		: '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader5" onclick="checkBoxHeader(event, this.id)" />','SUPPLY_ID','SUPPLY_TYPE','STR','OLD_VALUE','OPER'],
           colModel:[
     				{name:'chk', index:'chk', width:19,align:'center',formatter: formatOpt5},
    				{name:'supply_id', dex:'supply_id', sortable:false, hidden:true},
    				{name:'supply_type', dex:'supply_type', sortable:false, hidden:true},
    				{name:'value', index:'value', width:150, editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
    				{name:'old_value', index:'old_value', editable:false, hidden:true},
    				{name:'oper', index:'oper', width:25, hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 200,
        hidegrid : false,
        pager		: $('#p_supplyStrList'),
        pgbuttons : false,
        pgtext : false,
        pginput : false,
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        beforeSaveCell : changeStrEditEnd,
//         rowList	: [100,500,1000],
// 		 rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
       		if (name == "value") setUpperCase('#supplyStrList',rowid,name);
        },
        onPaging: function(pgButton) {

		 },
		 gridComplete : function (data) {
       	var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				if ( $("#supply_admin").val() == "Y" ){
			 		$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
				}
				else{
					$(this).jqGrid( 'setCell', rows[i], 'value', '', 'not-editable-cell' );
				}
			 }
		 },	         
		 beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
	 		idRow4 = rowid;
			idCol4 = iCol;
			kRow4 = iRow;
			kCol4 = iCol;
			 },
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#supplyStrList").getRowData(row_id);
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
	
	$("#supplyCatalogList").jqGrid({ 
        datatype	: 'json', 
        mtype		: '', 
        url		: '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader6" onclick="checkBoxHeader(event, this.id)" />','SEQ','CATALOG','CATALOG DESCRIPTION', 'ATTR','VALUE','OPER'],
           colModel:[
				{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt6},
				{name:'seq', index:'seq', sortable:false, hidden:true},
              	{name:'catalog', index:'catalog', width:50,	editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
              	{name:'catalog_desc', index:'catalog_desc',	width:150, sortable:false, hidden:true},
              	{name:'attr', index:'attr', width:50, editable:true, align:'center',edittype : "select", editoptions:{value:"ALL:ALL;ATTR1:ATTR1;ATTR2:ATTR2;ATTR3:ATTR3;ATTR4:ATTR4;ATTR5:ATTR5;ATTR6:ATTR6;ATTR7:ATTR7;ATTR8:ATTR8;ATTR9:ATTR9;ATTR10:ATTR10;ATTR11:ATTR11;ATTR12:ATTR12;ATTR13:ATTR13;ATTR14:ATTR14;ATTR15:ATTR15", dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}, sortable:false},
           		{name:'value', index:'value', width:50,	editable:true, align:'center', sortable:false, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
               	{name:'oper', index:'oper', width:25, hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 200,
        hidegrid : false,
        pager		: $('#p_supplyCatalogList'),
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        beforeSaveCell : changeCatalogEditEnd,	         
        rowList	: [100,500,1000],
		rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
		beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			idRow5 = rowid;
			idCol5 = iCol;
			kRow5 = iRow;
			kCol5 = iCol;
		},
        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
       		if (name == "value" || name == "catalog") setUpperCase('#supplyCatalogList',rowid,name);
        },
        onPaging: function(pgButton) {

		 },
        loadComplete : function (data) {
        	//if ("#tabs-6" == selected_tab_name) {
        		/* fn_searchOutfittingArea(); */
        	//}	
		 },	         
		 gridComplete : function () {
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				if ( $("#supply_admin").val() == "Y" ){
					$(this).jqGrid( 'setCell', rows[i], 'catalog', '', { background : '#FFFF99' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'catalog_desc', '', { background : '#DADADA' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'attr', '', { background : '#FFFF99' } );
				 	$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
				}
				else {
					$(this).jqGrid( 'setCell', rows[i], 'catalog', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'attr', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'value', '', 'not-editable-cell' );
				}
			}
		 },	  
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#supplyCatalogList").getRowData(row_id);
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
	fn_insideGridresize($(window),$("#divMain"),$("#supplyManageList"),-97, 0.5);
    fn_insideGridresize($(window),$("#divList1"),$("#supplyDwgList"),-22, 0.5);
    fn_insideGridresize($(window),$("#divList2"),$("#supplyBlockList"),-22, 0.5);
    fn_insideGridresize($(window),$("#divList3"),$("#supplyStageList"),-22, 0.5);
    fn_insideGridresize($(window),$("#divList4"),$("#supplyStrList"),-22, 0.5);
    fn_insideGridresize($(window),$("#divList5"),$("#supplyCatalogList"),-22, 0.5);

	//그리드 툴바 버튼 세팅 	
	$("#supplyManageList").jqGrid('navGrid',"#p_supplyManageList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyDwgList").jqGrid('navGrid',"#p_supplyDwgList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyBlockList").jqGrid('navGrid',"#p_supplyBlockList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyStageList").jqGrid('navGrid',"#p_supplyStageList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyStrList").jqGrid('navGrid',"#p_supplyStrList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyCatalogList").jqGrid('navGrid',"#p_supplyCatalogList",{refresh:false,search:false,edit:false,add:false,del:false});
	
	//메인 그리드 툴바 Refresh 생성
	$( "#supplyManageList" ).navButtonAdd( '#p_supplyManageList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_manageSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//메인 그리드 툴바 Del 버튼 생성
	$( "#supplyManageList" ).navButtonAdd( '#p_supplyManageList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : deleteRow,
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//메인 그리드 툴바 Add 버튼 생성
	$( "#supplyManageList" ).navButtonAdd( '#p_supplyManageList', {
		caption : "",
		buttonicon : "ui-icon-plus",
		onClickButton : addChmResultRow,
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	//DWG 그리드 툴바 Refresh 생성
	$( "#supplyDwgList" ).navButtonAdd( '#p_supplyDwgList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_dwgSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//DWG 그리드 툴바 Del 버튼 생성
	$( "#supplyDwgList" ).navButtonAdd( '#p_supplyDwgList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : function(){
			dwg_deleteRow("#supplyDwgList", idRow1, idCol1, "checkbox2");
		},
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//DWG 그리드 툴바 Add 버튼 생성
	$( "#supplyDwgList" ).navButtonAdd( '#p_supplyDwgList', {
		caption : "",
		buttonicon : "ui-icon-plus",
		onClickButton : function(){
			dwg_addChmResultRow("#supplyDwgList", kRow1, idCol1);
		},
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	
	//Block 그리드 툴바 Refresh 생성
	$( "#supplyBlockList" ).navButtonAdd( '#p_supplyBlockList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_dwgSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//Block 그리드 툴바 Del 버튼 생성
	$( "#supplyBlockList" ).navButtonAdd( '#p_supplyBlockList', {
		caption : "",
		buttonicon : "ui-icon-minus",
 		onClickButton : function(){
 			dwg_deleteRow("#supplyBlockList", idRow2, idCol2, "checkbox3");
 		},
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//Block 그리드 툴바 Add 버튼 생성
	$( "#supplyBlockList" ).navButtonAdd( '#p_supplyBlockList', {
		caption : "",
		buttonicon : "ui-icon-plus",
 		onClickButton : function(){
 			dwg_addChmResultRow("#supplyBlockList", kRow2, idCol2);
 		},
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	
	//Stage 그리드 툴바 Refresh 생성
	$( "#supplyStageList" ).navButtonAdd( '#p_supplyStageList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_dwgSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//Stage 그리드 툴바 Del 버튼 생성
	$( "#supplyStageList" ).navButtonAdd( '#p_supplyStageList', {
		caption : "",
		buttonicon : "ui-icon-minus",
 		onClickButton : function(){
 			dwg_deleteRow("#supplyStageList", idRow3, idCol3, "checkbox4");
 		},
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//Stage 그리드 툴바 Add 버튼 생성
	$( "#supplyStageList" ).navButtonAdd( '#p_supplyStageList', {
		caption : "",
		buttonicon : "ui-icon-plus",
 		onClickButton : function(){
 			dwg_addChmResultRow("#supplyStageList", kRow3, idCol3);
 		},
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
		
	//Str 그리드 툴바 Refresh 생성
	$( "#supplyStrList" ).navButtonAdd( '#p_supplyStrList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_dwgSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//Str 그리드 툴바 Del 버튼 생성
	$( "#supplyStrList" ).navButtonAdd( '#p_supplyStrList', {
		caption : "",
		buttonicon : "ui-icon-minus",
 		onClickButton : function(){
 			dwg_deleteRow("#supplyStrList", idRow4, idCol4, "checkbox5");
 		},
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//Str 그리드 툴바 Add 버튼 생성
	$( "#supplyStrList" ).navButtonAdd( '#p_supplyStrList', {
		caption : "",
		buttonicon : "ui-icon-plus",
 		onClickButton : function(){
 			dwg_addChmResultRow("#supplyStrList", kRow4, idCol4);
 		},
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	//CATALOG 그리드 툴바 Refresh 생성
	$( "#supplyCatalogList" ).navButtonAdd( '#p_supplyCatalogList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
 			fn_dwgSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//CATALOG 그리드 툴바 Del 버튼 생성
	$( "#supplyCatalogList" ).navButtonAdd( '#p_supplyCatalogList', {
		caption : "",
		buttonicon : "ui-icon-minus",
 		onClickButton : catalog_deleteRow,
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//CATALOG 그리드 툴바 Add 버튼 생성
	$( "#supplyDwgList" ).navButtonAdd( '#p_supplyCatalogList', {
		caption : "",
		buttonicon : "ui-icon-plus",
 		onClickButton : catalog_addChmResultRow,
		position : "first",
		title : "Add",
		cursor : "pointer"
	});

	//그리드 내 콤보박스 바인딩
	$.post( "infoComboCodeMaster.do?sd_type=SUPPLY_GBN", "", function( data ) {
		$( '#supplyManageList' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'gbn',
			data : data
		} );
	}, "json" );
	
	//그리드 내 콤보박스 바인딩
	$.post( "infoComboCodeMaster.do?sd_type=UOM_CODE", "", function( data ) {
		$( '#supplyManageList' ).setObject( {
			value : 'value',
			text : 'value',
			name : 'uom1',
			data : data
		} );
	}, "json" );
	
	//그리드 내 콤보박스 바인딩
	$.post( "infoComboCodeMaster.do?sd_type=SUPPLY_PLAN_TRACK", "", function( data ) {
		$( '#supplyManageList' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'join_data',
			data : data
		} );
	}, "json" );
	
	// 엑셀 export
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	
});  //end of ready Function 	

/***********************************************************************************************																
* 그리드 툴바 버튼 이벤트
*
************************************************************************************************/

//Del 버튼
function deleteRow() {
	
	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	fn_applyData("#supplyManageList",idRow,idCol);
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox1']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	var selarrrow = chked_val.split(',');
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#supplyManageList').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#supplyManageList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyManageList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyManageList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		} else if(item.oper == 'D') {
			item.oper = '';
			$('#supplyManageList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyManageList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyManageList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FFFFFF' } );
			}
		} else if(item.oper == 'I') {
			$('#supplyManageList').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		} 
	}
	$( '#supplyManageList' ).resetSelection();
}
//Add 버튼 이벤트
function addChmResultRow() {
	
	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	if ( initManageSearch == 'N' ) {
		alert( '조회 후 입력해주세요' );
		return;
	}
	
	$( '#supplyManageList' ).saveCell( kRow, idCol );

	var item = {};
	var colModel = $( '#supplyManageList' ).jqGrid( 'getGridParam', 'colModel' );

	for( var i in colModel )
		item[colModel[i].name] = '';
	
	item.oper = 'I';
	
	$( '#supplyManageList' ).resetSelection();
	$( '#supplyManageList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
	tableId = '#supplyManageList';
}

//Del 버튼
function dwg_deleteRow(grid, idRow, idCol, checkbox) {

	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	$( grid ).saveCell( kRow, idCol );
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='" + checkbox + "']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	var selarrrow = chked_val.split(',');
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $(grid).jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$(grid).jqGrid("setRowData", selrow, item);
			var colModel = $( grid ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( grid ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		} else if(item.oper == 'D') {
			item.oper = '';
			$(grid).jqGrid("setRowData", selrow, item);
			var colModel = $( grid ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( grid ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FFFFFF' } );
			}
		} else if(item.oper == 'I') {
			$(grid).jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		} 
	}
	$( grid ).resetSelection();
	fn_applyData(grid,idRow,idCol);
}
//Add 버튼 이벤트
function dwg_addChmResultRow(grid, kRow, idCol) {
	
	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	$( grid ).saveCell( kRow, idCol );
	
	if ( selectManageRowId.substr(0,3) == "jqg"){
		alert( '저장버튼을 눌러 항목번호가 채번된 후에 추가해 주세요.' );
		return;
	}
	else if ( $("#h_supplyId").val() == "" ) {
		alert( '메인 그리드를 선택한 후 행을 추가해주세요.' );
		return;
	}
	
	var item = {};
	var colModel = $( grid ).jqGrid( 'getGridParam', 'colModel' );

	for( var i in colModel )
		item[colModel[i].name] = '';
	
	item.oper = 'I';
	
	$( grid ).resetSelection();
	$( grid ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
	$( grid ).saveCell( kRow, idCol );
}

//Del 버튼
function catalog_deleteRow() {
	
	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	fn_applyData("#supplyCatalogList",idRow2,idCol2);
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox6']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	var selarrrow = chked_val.split(',');
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#supplyCatalogList').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#supplyCatalogList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyCatalogList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyCatalogList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		} else if(item.oper == 'D') {
			item.oper = '';
			$('#supplyCatalogList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyCatalogList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyCatalogList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FFFFFF' } );
			}
		} else if(item.oper == 'I') {
			$('#supplyCatalogList').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		} 
	}
	$( '#supplyCatalogList' ).resetSelection();
}
//Add 버튼 이벤트
function catalog_addChmResultRow() {
	
	if ( $("#supply_admin").val() == "N" ){
		return;	
	}
	
	if ( selectManageRowId.substr(0,3) == "jqg"){
		alert( '저장버튼을 눌러 항목번호가 채번된 후에 추가해 주세요.' );
		return;
	}
	else if ( $("#h_supplyId").val() == "" ) {
		alert( '메인 그리드를 선택한 후 행을 추가해주세요.' );
		return;
	}
	
	$( '#supplyCatalogList' ).saveCell( kRow5, idCol5 );

	var item = {};
	var colModel = $( '#supplyCatalogList' ).jqGrid( 'getGridParam', 'colModel' );

	for( var i in colModel )
		item[colModel[i].name] = '';
	
	item.oper = 'I';
	
	$( '#supplyCatalogList' ).resetSelection();
	$( '#supplyCatalogList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
	tableId = '#supplyCatalogList';
}

/***********************************************************************************************																
* 버튼 이벤트 함수	
*
************************************************************************************************/

//조회 버튼
$("#btnSearch").click(function() {
	$("#h_supplyId").val("");
	$( "#supplyManageList" ).jqGrid( "clearGridData" );
	$( "#supplyDwgList" ).jqGrid( "clearGridData" );
	$( "#supplyBlockList" ).jqGrid( "clearGridData" );
	$( "#supplyStageList" ).jqGrid( "clearGridData" );
	$( "#supplyStrList" ).jqGrid( "clearGridData" );
	$( "#supplyCatalogList" ).jqGrid( "clearGridData" );
	fn_manageSearch();
	selectManageRowId = "";
});

//저장 버튼
$("#btnSave").click(function() {
	fn_save();
});

function fn_save() {
	$( '#supplyManageList' ).saveCell( kRow, idCol );
	$( '#supplyDwgList' ).saveCell( kRow1, idCol1 );
	$( '#supplyBlockList' ).saveCell( kRow2, idCol2 );
	$( '#supplyStageList' ).saveCell( kRow3, idCol3 );
	$( '#supplyStrList' ).saveCell( kRow4, idCol4 );
	$( '#supplyCatalogList' ).saveCell( kRow5, idCol5 );
	
	//변경된 체크 박스가 있는지 체크한다.
	var changedData = $( "#supplyManageList" ).jqGrid( 'getRowData' );
	for( var i = 1; i < changedData.length + 1; i++ ) {
		var item = $( '#supplyManageList' ).jqGrid( 'getRowData', i );
		//if( item.oper != 'I' && item.oper != 'U' ) {
			if( item.result_yn != item.result_yn_temp ) {
				item.oper = 'U';
			}
			if( item.uom2 == 'TEXT') {
				item.uom1 = '';
			}
			if (item.oper == 'U') {
				// apply the data which was entered.
				$( '#supplyManageList' ).jqGrid( "setRowData", i, item );
			}
		//}
	}
	
	//메인 그리드 중복된 RANK 가 있는지 확인
	var changedManageRank = $( "#supplyManageList" ).jqGrid( 'getRowData' );
	for( var i=0; i < changedManageRank.length; i++ ) {
		var item1 = changedManageRank[i];
		for( var j=0; j < changedManageRank.length; j++ ) {
			var item2 = changedManageRank[j];
			if( item2.oper == 'I' || item2.oper == 'U' ) {
				if(i!=j && item1.rank==item2.rank){
					alert("메인 그리드 RANK 속성에 중복된 값 '" + item1.rank + "' 가 존재합니다.");
					return;
				}
			}
		}
	}
	
	//DWG 그리드 중복된 VALUE 가 있는지 확인
	var changedDwgValue = $( "#supplyDwgList" ).jqGrid( 'getRowData' );
	for( var i=0; i < changedDwgValue.length; i++ ) {
		var item1 = changedDwgValue[i];
		for( var j=0; j < changedDwgValue.length; j++ ) {
			var item2 = changedDwgValue[j];
			if( item2.oper == 'I' || item2.oper == 'U' ) {
				if(i!=j && item1.value==item2.value){
					alert("DWG CATEGORY 그리드에 중복된 값 '" + item1.value + "' 이 존재합니다.");
					return;
				}
			}
		}
	}

	//BLOCK 그리드 중복된 VALUE 가 있는지 확인
	var changedBlockValue = $( "#supplyBlockList" ).jqGrid( 'getRowData' );
	for( var i=0; i < changedBlockValue.length; i++ ) {
		var item1 = changedBlockValue[i];
		for( var j=0; j < changedBlockValue.length; j++ ) {
			var item2 = changedBlockValue[j];
			if( item2.oper == 'I' || item2.oper == 'U' ) {
				if(i!=j && item1.value==item2.value){
					alert("BLOCK 그리드에 중복된 값 '" + item1.value + "' 이 존재합니다.");
					return;
				}
			}
		}
	}
	
	//STAGE 그리드 중복된 VALUE 가 있는지 확인
	var changedStageValue = $( "#supplyStageList" ).jqGrid( 'getRowData' );
	for( var i=0; i < changedStageValue.length; i++ ) {
		var item1 = changedStageValue[i];
		for( var j=0; j < changedStageValue.length; j++ ) {
			var item2 = changedStageValue[j];
			if( item2.oper == 'I' || item2.oper == 'U' ) {
				if(i!=j && item1.value==item2.value){
					alert("STAGE 그리드에 중복된 값 '" + item1.value + "' 이 존재합니다.");
					return;
				}
			}
		}
	}
	
	//STR 그리드 중복된 VALUE 가 있는지 확인
	var changedStrValue = $( "#supplyStrList" ).jqGrid( 'getRowData' );
	for( var i=0; i < changedStrValue.length; i++ ) {
		var item1 = changedStrValue[i];
		for( var j=0; j < changedStrValue.length; j++ ) {
			var item2 = changedStrValue[j];
			if( item2.oper == 'I' || item2.oper == 'U' ) {
				if(i!=j && item1.value==item2.value){
					alert("STR 그리드에 중복된 값 '" + item1.value + "' 이 존재합니다.");
					return;
				}
			}
		}
	}
	
	//변경 사항 Validation
	if( !fn_checkValidate() ) {
		return;
	}
	
	if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
		var supplyResultRows = getChangedGridInfo( "#supplyManageList" );
		var dwgInfoResultRows = getChangedGridInfo( "#supplyDwgList" );
		var blockInfoResultRows = getChangedGridInfo( "#supplyBlockList" );
		var stageInfoResultRows = getChangedGridInfo( "#supplyStageList" );
		var strInfoResultRows = getChangedGridInfo( "#supplyStrList" );
		var catalogInfoResultRows = getChangedGridInfo( "#supplyCatalogList" );

			var dataList = {
				manageList : JSON.stringify( supplyResultRows ),
				dwgList : JSON.stringify( dwgInfoResultRows ),
				blockList : JSON.stringify( blockInfoResultRows ),
				stageList : JSON.stringify( stageInfoResultRows ),
				strList   : JSON.stringify( strInfoResultRows ),
				catalogList : JSON.stringify( catalogInfoResultRows ),

			};

			var url = 'saveSupplyManageList.do';
			var formData = fn_getFormData('#listForm');
			var parameters = $.extend( {}, dataList, formData );
			
			parameters = $.extend( {}, parameters );

			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, parameters, function( data ) {
				if ( data.result == 'success' ) {
					$("#h_supplyId").val("");
					$( "#supplyManageList" ).jqGrid( "clearGridData" );
					$( "#supplyDwgList" ).jqGrid( "clearGridData" );
					$( "#supplyBlockList" ).jqGrid( "clearGridData" );
					$( "#supplyStageList" ).jqGrid( "clearGridData" );
					$( "#supplyStrList" ).jqGrid( "clearGridData" );
					$( "#supplyCatalogList" ).jqGrid( "clearGridData" );
					fn_manageSearch();
					selectManageRowId = "";
				}

			}, 'json' ).error( function() {
				alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
			} ).always( function() {
				loadingBox.remove();
			} );

	}
}

/***********************************************************************************************																
* 기능 함수 호출 	
*
************************************************************************************************/

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox1' id='"+rowid+"_chkBoxOV' class='chkHeader1_item' value="+rowid+" />";
}
function formatOpt2(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox2' id='"+rowid+"_chkBoxOV' class='chkHeader2_item' value="+rowid+" />";
}
function formatOpt3(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox3' id='"+rowid+"_chkBoxOV' class='chkHeader3_item' value="+rowid+" />";
}
function formatOpt4(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox4' id='"+rowid+"_chkBoxOV' class='chkHeader4_item' value="+rowid+" />";
}
function formatOpt5(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox5' id='"+rowid+"_chkBoxOV' class='chkHeader5_item' value="+rowid+" />";
}
function formatOpt6(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox6' id='"+rowid+"_chkBoxOV' class='chkHeader6_item' value="+rowid+" />";
}

//메인 그리드 조회 함수
function fn_manageSearch() {
	initManageSearch = "Y";
	var sUrl = "supplyManageList.do";
	
	$( "#supplyManageList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : sUrl,
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
}

//DWG 디테일 그리드 조회 함수
function fn_dwgSearch() {
	initDetailSearch = "Y";
	
	$( "#supplyDwgList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : "supplyDwgList.do?h_supplyType=DWG_CATEGORY",
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
	
	$( "#supplyBlockList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : "supplyDwgList.do?h_supplyType=BLOCK",
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
	
	$( "#supplyStageList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : "supplyDwgList.do?h_supplyType=STAGE",
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
	
	$( "#supplyStrList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : "supplyDwgList.do?h_supplyType=STR",
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
	
}

//CATALOG 디테일 그리드 조회 함수
function fn_catalogSearch() {
	var sUrl = "supplyCatalogList.do";
	
	$( "#supplyCatalogList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : sUrl,
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
}

//메인 그리드의 cell이 변경된 경우 호출되는 함수
function changeManageEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyManageList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';

	if ($("#" + irowId + "_uom2").val() == 'TEXT' || item.uom2 == 'TEXT') {
		$(this).jqGrid( 'setCell', irowId, 'uom1', '', { background : '#DADADA' } );
	} else {
		$(this).jqGrid( 'setCell', irowId, 'uom1', '', { background : '#FFFF99' } );
	}
	
	// apply the data which was entered.
	$('#supplyManageList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}

//Dwg 그리드의 cell이 변경된 경우 호출되는 함수
function changeDwgEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyDwgList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyDwgList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	
//Block 그리드의 cell이 변경된 경우 호출되는 함수
function changeBlockEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyBlockList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyBlockList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}
//Stage 그리드의 cell이 변경된 경우 호출되는 함수
function changeStageEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyStageList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyStageList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}
//Str 그리드의 cell이 변경된 경우 호출되는 함수
function changeStrEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyStrList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyStrList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}

//CATALOG 그리드의 cell이 변경된 경우 호출되는 함수
function changeCatalogEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyCatalogList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyCatalogList').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	

//변경 사항 Validation 
function fn_checkValidate() {
	var result = true;
	var message = "";
	var nChangedCnt = 0;
	
	//메인 그리드 체크
	var ids = $( "#supplyManageList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			manageChangedCnt++;
			//필수항목 체크 : gbn
			var val1 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'gbn' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : dept_code_desc
			var val2 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'dept_code_desc' );
			if ( $.jgrid.isEmpty( val2 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : uom2
			var val4 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'uom2' );
			if ( $.jgrid.isEmpty( val4 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : uom1
			var val3 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'uom1' );
			if ( $.jgrid.isEmpty( val3 ) && val4 != 'TEXT') {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : join_data
			var val5 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'join_data' );
			if ( $.jgrid.isEmpty( val5 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : rank
			var val6 = $( "#supplyManageList" ).jqGrid( 'getCell', ids[i], 'rank' );
			if ( $.jgrid.isEmpty( val6 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}
	
	//DWG 그리드 체크
	ids = $( "#supplyDwgList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyDwgList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			dwgChangedCnt++;
			//필수항목 체크 : supplyDwgList
			var val1 = $( "#supplyDwgList" ).jqGrid( 'getCell', ids[i], 'value' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}
	
	//Block 그리드 체크
	ids = $( "#supplyBlockList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyBlockList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			dwgChangedCnt++;
			//필수항목 체크 : supplyBlockList
			var val1 = $( "#supplyBlockList" ).jqGrid( 'getCell', ids[i], 'value' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}
	
	//Stage 그리드 체크
	ids = $( "#supplyStageList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyStageList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			dwgChangedCnt++;
			//필수항목 체크 : supplyStageList
			var val1 = $( "#supplyStageList" ).jqGrid( 'getCell', ids[i], 'value' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}
	
	//Str 그리드 체크
	ids = $( "#supplyStrList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyStrList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			dwgChangedCnt++;
			//필수항목 체크 : supplyStrList
			var val1 = $( "#supplyStrList" ).jqGrid( 'getCell', ids[i], 'value' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}
	
	//CATALOG 그리드 체크
	ids = $( "#supplyCatalogList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyCatalogList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			catalogChangedCnt++;
			//필수항목 체크 : catalog
			var val1 = $( "#supplyCatalogList" ).jqGrid( 'getCell', ids[i], 'catalog' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : attr
			var val2 = $( "#supplyCatalogList" ).jqGrid( 'getCell', ids[i], 'attr' );
			if ( $.jgrid.isEmpty( val2 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
			//필수항목 체크 : value
			var val3 = $( "#supplyCatalogList" ).jqGrid( 'getCell', ids[i], 'value' );
			if ( $.jgrid.isEmpty( val3 ) ) {
				alert( "필수항목을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D' ) {
			dwgChangedCnt++;
		}
	}

	if ( manageChangedCnt + dwgChangedCnt + catalogChangedCnt == 0 ) {
		result = false;
		alert( "변경된 내용이 없습니다." );
	}
	return result;
}

//그리드 변경된 내용을 가져온다.
function getChangedGridInfo( gridId ) {
	var changedData = $.grep( $( gridId ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );

	if( gridId == "#supplyManageList" ) {
		changedData = changedData.concat( manageDeleteData );
	} else if( gridId == "#supplyDwgList" ) {
		changedData = changedData.concat( dwgDeleteData );
	} else if( gridId == "#supplyCatalogList" ) {
		changedData = changedData.concat( catalogDeleteData );
	}
	
	return changedData;
}

//그리드 내 입력시 대문자 자동 변환 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	
	var sUrl  = "./supplyManageExcelExport.do?";
		sUrl += "&i_supplyId="+$("#i_supplyId").val();
		sUrl += "&i_gubun="+$("#i_gubun").val();	
		sUrl += "&i_group1="+$("#i_group1").val();
		sUrl += "&i_group2="+$("#i_group2").val();
		sUrl += "&i_description="+$("#i_description").val();
		sUrl += "&i_dept="+$("#i_dept").val();
	
	location.href=sUrl;
}

//삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (manageDeleteData.length  > 0) 	manageDeleteData.splice(0, 	 manageDeleteData.length);
}

//header checkbox action 
function checkBoxHeader(e, object) {
		e = e||event;/* get IE event ( not passed ) */
		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#" + object).is(":checked"))){
		$("." + object + "_item").prop("checked", true);
	}else{
		$("input." + object + "_item").prop("checked", false);
	}
}

</script>
</html>