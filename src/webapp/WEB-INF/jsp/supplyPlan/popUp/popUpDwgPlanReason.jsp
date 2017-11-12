<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>REASON 관리</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div id="mainDiv" class="mainDiv">
<form name="listForm" id="listForm"  method="get">
	
		<div class= "subtitle">
		REASON 관리
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<input type="hidden"  name="pageYn" value="N"/>
		<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
		
		<input type="hidden" id="h_supplyGubun" name="h_supplyGubun" value=""/>
		<input type="hidden" id="h_group1" name="h_group1" value=""/>
		<input type="hidden" id="h_group2" name="h_group2" value=""/>
		<input type="hidden" id="h_description" name="h_description" value=""/>
		<input type="hidden" id="h_uom" name="h_uom" value=""/>
		<input type="hidden" id="h_deptName" name="h_deptName" value=""/>
		<input type="hidden" id="h_joinData" name="h_joinData" value=""/>
		<input type="hidden" id="h_purposeSupply" name="h_purposeSupply" value=""/>
		<input type="hidden" id="h_correspondSupply" name="h_correspondSupply" value=""/>
		<input type="hidden" id="h_resultSupply" name="h_resultSupply" value=""/>
		
		<input type="hidden" id="sel_seq" name="sel_seq" />
		<input type="hidden" id="sel_fileCode" name="sel_fileCode" />
		
		<table class="searchArea conSearch" >
		<col width="60">
		<col width="100">
		<col width="40">
		<col width="100">
		<col width="40">
		<col width="180">
		<col width="40">
		<col width="100">
		<col width="50">
		<col width="130">
		<col width="50">
		<col width="130">

		<tr>
			<th>PROJECT</th>
			<td>
				<input type="text" id="i_project" name="i_project" readonly="readonly" value="${h_project}" style="background-color:#DADADA; width:70px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>
		
			<th>항목</th>
			<td>
				<input type="text" id="i_supplyId" maxlength="5" name="i_supplyId" readonly="readonly" value="${h_supplyId}" style="background-color:#DADADA; width:70px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>

			<th>TITLE</th>
			<td>
				<input type="text" id="i_title" name="i_title" style="width:150px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>

			<th>구분</th>
			<td>
				<input type="text" id="i_reasonGubun" maxlength="10" name="i_reasonGubun" style="width:70px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>
			
			<th>DEPT</th>
			<td>
				<input type="text" id="i_dept" name="i_dept" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>
			
			<th>USER</th>
			<td>
				<input type="text" id="i_user" name="i_user" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</td>
			

			<td class="bdl_no" colspan="2">
				<div class="button endbox">
						<input type="button" value="조 회"  id="btnSearch"  class="btn_blue"/>
						<input type="button" value="저 장"  id="btnSave"    class="btn_blue"/>
				</div>
			</td>
		</tr>
		</table>
								
			<div class="content" >
				<div id="divMain">
			  		<table id ="supplyReasonList"></table>
					<div id ="p_supplyReasonList"></div>
				</div>
			</div>
			
		<table class="searchArea conSearch" >
		<tr>
			<td class="bdl_no" colspan="2">
				<div class="button endbox">
					<input type="button" value="저 장"  id="btnSave1"    class="btn_blue"/>
				</div>
			</td>
		</tr>
		</table>
		
			<div class="content"  style="position:relative; float: left; width: 59.5%;">
				
				<table class="searchArea2">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
			
					<tr>
						<th>항 목</th>
						<td style="height:30px;">
							<input type="text" id="d_supplyId" maxlength="10" name="d_supplyId" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<th>구 분</th>
						<td>
							<input type="text" id="d_supplyGubun" maxlength="10" name="d_supplyGubun" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<th>GROUP1</th>
						<td>
							<input type="text" id="d_group1" maxlength="10" name="d_group1" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						 
						<th>GROUP2</th>
						<td>
							<input type="text" id="d_group2" maxlength="10" name="d_group2" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>		
						<td></td>		
					</tr>
					
				</table>

				<table class="searchArea2">
					<col width="90">
					<col width="310">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
			
					<tr>
						<th>DESCRIPTION</th>
						<td style="height:30px;">
							<input type="text" id="d_description" name="d_description" readonly="readonly" style="background-color:#DADADA; width:286px;"/>
						</td>
						
						<th>UOM</th>
						<td>
							<input type="text" id="d_uom" name="d_uom" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						 
						<th>DEPT</th>
						<td>
							<input type="text" id="d_deptName" name="d_deptName" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<td></td>
					</tr>
				</table>
				
				<table class="searchArea2">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
					<col width="90">
					<col width="110">
			
					<tr>
						<th>품목군</th>
						<td style="height:30px;">
							<input type="text" id="d_joinData" name="d_joinData" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<th>목표물량</th>
						<td>
							<input type="text" id="d_purposeSupply" name="d_purposeSupply" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<th>상응물량</th>
						<td>
							<input type="text" id="d_correspondSupply" name="d_correspondSupply" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						 
						<th>실적물량</th>
						<td>
							<input type="text" id="d_resultSupply" name="d_resultSupply" readonly="readonly" style="background-color:#DADADA; width:86px;"/>
						</td>
						
						<td></td>
					</tr>
				</table>
				
				<table class="searchArea2">
					<col width="90">
					<col width="510">
					<col width="90">
					<col width="110">
			
					<tr>
						<th>TITLE</th>
						<td style="height:30px;">
							<input type="text" id="d_title" name="d_title" readonly="readonly" style="background-color:#DADADA; width:486px;"/>
						</td>
						 
						<th>구 분</th>
						<td>
							<select id="d_reasonGubun" name="d_reasonGubun" disabled="disabled" style="width:86px"></select>
						</td>
						
						<td></td>
					</tr>
				</table>
				
				<textarea id="d_reasonComment" name="d_reasonComment" rows="10" style="width:816px"></textarea>
				
				<div id="divList1">
				</div>
			</div>
			<div class="content"  style="position:relative; float: right; width: 40%;">
				<div id="divList2">
					<table id = "supplyReasonFileList"></table>
					<div id ="p_supplyReasonFileList"></div>
				</div>
			</div>
	</div>
</form>

</body>

<script type="text/javascript">
var initReasonSearch	 = "N"; //메인   그리드 최초 조회시 "Y"로변경되며 "Y"일때만 행을 추가할 수 있음

var idRow;
var idCol;
var kRow;
var kCol;
var resultData 			 = [];

var idRow2;
var idCol2;
var kRow2;
var kCol2;

//삭제 데이터
var reasonDeleteData = [];

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
$(document).ready(function(){
	
	$(window).bind('resize', function() {
		$("#center").css({'height':  $(window).height()/2-100});
		$("#teamIframe").css({'height':  $(window).height()/2-150});
	}).trigger('resize');
	
	$("#supplyReasonList").jqGrid({ 
        datatype	: 'json', 
        url      : '',
        mtype    : '',
        postData   : '',
        colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','SEQ','PROJECT','항목','구분','TITLE','목표물량','상응물량','실적물량','FILE','DEPT','USER','DATE','OPER'],
           colModel:[
				{name:'chk', index:'chk', width:15,align:'center',formatter: formatOpt1},
				{name:'seq', index:'seq', width:50, align:'center', editable:false, sortable:false, hidden:true},
				{name:'project', index:'project', width:50, align:'center', editable:false, sortable:false},
				{name:'supply_id', index:'supply_id', width:50, align:'center', editable:false, sortable:false},
              	{name:'reason_gubun', index:'reason_gubun', width:50, align:'center', editable:true, edittype : "select", formatter : 'select', sortable:false},
           		{name:'title', index:'title', width:300, editable:true, sortable:false},
              	{name:'purpose_supply', index:'purpose_supply', width:50, align:'center', editable:false, sortable:false},
              	{name:'correspond_supply', index:'correspond_supply', width:50, align:'center', editable:false, sortable:false},
              	{name:'result_supply', index:'result_supply', width:50, align:'center', editable:false, sortable:false},
              	{name:'file_yn', index:'file_yn', width:50, align:'center', editable:false, sortable:false},
              	{name:'dept_code', index:'dept_code', width:120, align:'center', editable:false, sortable:false},
              	{name:'user', index:'user', width:50, align:'center', sortable:false},
              	{name:'date', index:'date', width:50, align:'center', sortable:false},
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
        pager		: $('#p_supplyReasonList'),
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
		beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			idRow = rowid;
			idCol = iCol;
			kRow = iRow;
			kCol = iCol;
		},
        beforeSaveCell : chmResultEditEnd,
        rowList	: [100,500,1000],
		rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
        onPaging: function(pgButton) {

		 },
        loadComplete : function (data) {

		 },	         
		 gridComplete : function () {
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				$(this).jqGrid( 'setCell', rows[i], 'project', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'supply_id', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'correspond_supply', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'result_supply', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'file_yn', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'dept_code', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'user', '', { background : '#DADADA' } );
				$(this).jqGrid( 'setCell', rows[i], 'date', '', { background : '#DADADA' } );
			}
		 },	  
		 onCellSelect: function(row_id, colId) {
			
			var seq = $( "#supplyReasonList" ).jqGrid( 'getCell', row_id, 'seq' );
			var oper = $( "#supplyReasonList" ).jqGrid( 'getCell', row_id, 'oper' );
			$( "#sel_seq" ).val(seq);
			if(oper == "I"){
				$("#d_supplyId").val("");
				$("#d_supplyGubun").val("");
				$("#d_group1").val("");
				$("#d_group2").val("");
				$("#d_description").val("");
				$("#d_uom").val("");
				$("#d_deptName").val("");
				$("#d_joinData").val("");
				$("#d_purposeSupply").val("");
				$("#d_correspondSupply").val("");
				$("#d_resultSupply").val("");
				$("#d_title").val("");
				$("#d_reasonGubun").val("");
				$("#d_reasonComment").val("");
			} else {
				$("#d_supplyId").val($("#i_supplyId").val());
				$("#d_supplyGubun").val($("#h_supplyGubun").val());
				$("#d_group1").val($("#h_group1").val());
				$("#d_group2").val($("#h_group2").val());
				$("#d_description").val($("#h_description").val());
				$("#d_uom").val($("#h_uom").val());
				$("#d_deptName").val($("#h_deptName").val());
				$("#d_joinData").val($("#h_joinData").val());
				$("#d_purposeSupply").val($("#h_purposeSupply").val());
				$("#d_correspondSupply").val($("#h_correspondSupply").val());
				$("#d_resultSupply").val($("#h_resultSupply").val());	
				var ret = $( this ).getRowData( row_id );
				fn_ReasonDetailSearch2(ret.project, ret.supply_id, ret.reason_gubun);
			}
			fn_reasonFileSearch();
			
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
	
	$("#supplyReasonFileList").jqGrid({ 
        datatype	: 'json', 
        url      : '',
        mtype    : '',
        postData   : '',
        colNames:['선택','FILE_CODE','FILE NAME','COMMENT','OPER'],
           colModel:[
				{name:'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				{name:'file_code', index:'file_code', sortable:false, hidden:true},
              	{name:'file_name', index:'file_name', width:100, sortable:false},
              	{name:'file_comment', index:'file_comment', width:100, sortable:false},
               	{name:'oper', index:'oper', width:25, hidden:true}
           ],
           
        gridview	: true,
        cmTemplate: { title: false },
        toolbar	: [false, "bottom"],
        viewrecords: true,                		//하단 레코드 수 표시 유무
       // width		: 1350,                     //사용자 화면 크기에 맞게 자동 조절
        autowidth	: true,
        height : $(window).height()/2 - 100,
        hidegrid : false,
        pager		: $('#p_supplyReasonFileList'),
        cellEdit	: true,             // grid edit mode 1
        cellsubmit	: 'clientArray',  	// grid edit mode 2
        //beforeSaveCell : changeFileEditEnd,	         
        rowList	: [100,500,1000],
		rowNum		: 100, 
        rownumbers : true,          	// 리스트 순번
		beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			idRow2 = rowid;
			idCol2 = iCol;
			kRow2 = iRow;
			kCol2 = iCol;
		},
        onPaging: function(pgButton) {

		 },
        loadComplete : function (data) {
        	
		 },	         
		 gridComplete : function () {
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
			 	$(this).jqGrid( 'setCell', rows[i], 'catalog', '', { background : '#FFFF99' } );
			 	$(this).jqGrid( 'setCell', rows[i], 'catalog_desc', '', { background : '#DADADA' } );
			 	$(this).jqGrid( 'setCell', rows[i], 'attr', '', { background : '#FFFF99' } );
			 	$(this).jqGrid( 'setCell', rows[i], 'value', '', { background : '#FFFF99' } );
			}
		 },	  
		 onCellSelect: function(row_id, colId) {
			 var ret 	= jQuery("#supplyReasonFileList").getRowData(row_id);
        },  	       
		ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
			var item = $( this ).jqGrid( 'getRowData', rowid );
			var file_code = item.file_code;
			$( "#sel_fileCode" ).val( file_code );
			fn_downLoadFile();
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
	fn_insideGridresize($(window),$("#divMain"),$("#supplyReasonList"),-100, 0.5);
    fn_insideGridresize($(window),$("#divList2"),$("#supplyReasonFileList"),-35, 0.5);
    
	//그리드 툴바 버튼 세팅 	
	$("#supplyReasonList").jqGrid('navGrid',"#p_supplyReasonList",{refresh:false,search:false,edit:false,add:false,del:false});
	$("#supplyReasonFileList").jqGrid('navGrid',"#p_supplyReasonFileList",{refresh:false,search:false,edit:false,add:false,del:false});
	
	//메인 그리드 툴바 Refresh 생성
	$( "#supplyReasonList" ).navButtonAdd( '#p_supplyReasonList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_reasonSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//메인 그리드 툴바 Del 버튼 생성
	$( "#supplyReasonList" ).navButtonAdd( '#p_supplyReasonList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : deleteRow,
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//메인 그리드 툴바 Add 버튼 생성
	$( "#supplyReasonList" ).navButtonAdd( '#p_supplyReasonList', {
		caption : "",
		buttonicon : "ui-icon-plus",
		onClickButton : addChmResultRow,
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	//CATALOG 그리드 툴바 Refresh 생성
	$( "#supplyReasonFileList" ).navButtonAdd( '#p_supplyReasonFileList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_reasonFileSearch();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	} );
	//CATALOG 그리드 툴바 Del 버튼 생성
	$( "#supplyReasonFileList" ).navButtonAdd( '#p_supplyReasonFileList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : catalog_deleteRow,
		position : "first",
		title : "Del",
		cursor : "pointer"
	} );
	//CATALOG 그리드 툴바 Add 버튼 생성
	$( "#supplyReasonFileList" ).navButtonAdd( '#p_supplyReasonFileList', {
		caption : "",
		buttonicon : "ui-icon-plus",
		onClickButton : catalog_addChmResultRow,
		position : "first",
		title : "Add",
		cursor : "pointer"
	});
	
	//그리드 내 콤보박스 바인딩
	$.post( "infoComboCodeMaster.do?sd_type=REASON_GBN", "", function( data ) {
		$( '#supplyReasonList' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'reason_gubun',
			data : data
		} );
	}, "json" );
	
	$.post( "infoComboCodeMaster.do?sd_type=REASON_GBN", "", function( data ) {
		var sbReasonGubun = document.getElementById("d_reasonGubun");
		for(var i=0; i<data.length; i++){
			var newOpt = Option(data[i].text,data[i].value);
			sbReasonGubun.options[i] = newOpt;
		}
		$("#d_reasonGubun").val("");
	}, "json" );
	
	$.post( "popUpDwgPlanReasonDetail.do?p_project="+$("#i_project").val()+"&p_supplyId="+$("#i_supplyId").val(), "", function( data ) {
		$("#h_supplyGubun").val(data.supply_gbn);
		$("#h_supplyGubunCode").val(data.supply_gbn_code);
		$("#h_group1").val(data.group1);
		$("#h_group2").val(data.group2);
		$("#h_description").val(data.description);
		$("#h_uom").val(data.uom);
		$("#h_deptName").val(data.dept_name);
		$("#h_joinData").val(data.join_data);
		$("#h_purposeSupply").val(data.purpose_supply);
		$("#h_correspondSupply").val(data.correspond_supply);
		$("#h_resultSupply").val(data.result_supply);		
	}, "json" );
});  //end of ready Function 	

/***********************************************************************************************																
* 그리드 툴바 버튼 이벤트
*
************************************************************************************************/

//Del 버튼
function deleteRow() {
	fn_applyData("#supplyReasonList",idRow,idCol);
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox1']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	var selarrrow = chked_val.split(',');
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#supplyReasonList').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#supplyReasonList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyReasonList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyReasonList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		} else if(item.oper == 'D') {
			item.oper = '';
			$('#supplyReasonList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#supplyReasonList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#supplyReasonList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FFFFFF' } );
			}
		} else if(item.oper == 'I') {
			$('#supplyReasonList').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		} 
	}
	$( '#supplyReasonList' ).resetSelection();
	

}
//Add 버튼 이벤트
function addChmResultRow() {
	if ( initReasonSearch == 'N' ) {
		alert( '조회 후 입력해주세요.' );
		return;
	}
	$( '#supplyReasonList' ).saveCell( kRow, idCol );

	var item = {};
	var colModel = $( '#supplyReasonList' ).jqGrid( 'getGridParam', 'colModel' );

	for( var i in colModel )
		item[colModel[i].name] = '';
	
	item.oper = 'I';
	item.project = $("#i_project").val();
	item.supply_id = $("#i_supplyId").val();
	item.purpose_supply = $("#h_purposeSupply").val();
	item.correspond_supply = $("#h_correspondSupply").val();
	item.result_supply = $("#h_resultSupply").val();
	
	$( '#supplyReasonList' ).resetSelection();
	$( '#supplyReasonList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );	
}

//Del 버튼
function catalog_deleteRow() {
	if ( confirm('삭제 하시겠습니까?') ) {
		var chmResultRows = [];
		getDeleteFileResultData( function( data ) {
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'delReasonFile.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			$.post( url, parameters, function( data2 ) {
				alert( data2.resultMsg );
				if ( data2.result == 'success' ) {
					fn_reasonSearch();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				lodingBox.remove();			
				window.focus();
			} );
		} );
	}
}
//Add 버튼 이벤트
function catalog_addChmResultRow() {
	if( $("#sel_seq").val() == ""){
		alert("항목을 선택 후 파일업로드가 가능합니다.");
		return;
	}
	var rs = window.showModalDialog( "popUpAddReasonFile.do?menu_id=${menu_id}&seq="+$("#sel_seq").val(), 
			window,
			"dialogWidth:600px; dialogHeight:180px; center:on; scroll:off; status:off" );
	
	if ( rs != null ) {
		fn_reasonFileSearch();
	}
}

/***********************************************************************************************																
* 버튼 이벤트 함수	
*
************************************************************************************************/

//조회 버튼
$("#btnSearch").click(function() {
	fn_reasonSearch();
});

//저장 버튼
$("#btnSave").click(function() {
	fn_save();
});

function fn_save() {
	$( '#supplyReasonList' ).saveCell( kRow, idCol );
	$( '#supplyReasonFileList' ).saveCell( kRow2, idCol2 );

	//중복 project,항목,구분 이 있는지 확인
	var ids = $("#supplyReasonList").jqGrid('getDataIDs');
	var dataReasonGubun = "";
	var dataReasonGubunTemp = "";
	for(var i=0; i<ids.length; i++) {	
		dataReasonGubun = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[i], 'reason_gubun' );
		for(var j=0; j<ids.length; j++) {
			if(i!=j){
				var oper = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[j], 'oper' );
				dataReasonGubunTemp = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[j], 'reason_gubun' );
				//중복이 있는경우
				if(dataReasonGubun==dataReasonGubunTemp && oper!="D"){
					alert("동일한 구분은 여러개 존재할 수 없습니다.");
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
		var chmResultRows = [];
		
		getChangedChmResultData(function( data ) {
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'popUpDwgPlanSaveReason.do';
			var formData = fn_getFormData( '#listForm' );
			var parameters = $.extend( {}, dataList, formData );

			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_reasonSearch();
				}
			}, "json").error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				loadingBox.remove();
			} );
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
  	return "<input type='checkbox' name='checkbox1' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}
function formatOpt3(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox3' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

//메인 그리드 조회 함수
function fn_reasonSearch() {
	
	$("#supplyReasonFileList").jqGrid( "clearGridData" );
	
	$("#sel_seq").val("");
	
	$("#d_supplyId").val("");
	$("#d_supplyGubun").val("");
	$("#d_group1").val("");
	$("#d_group2").val("");
	$("#d_description").val("");
	$("#d_uom").val("");
	$("#d_deptName").val("");
	$("#d_joinData").val("");
	$("#d_purposeSupply").val("");
	$("#d_correspondSupply").val("");
	$("#d_resultSupply").val("");
	$("#d_title").val("");
	$("#d_reasonGubun").val("");
	$("#d_reasonComment").val("");
	
	initReasonSearch = "Y";

	var sUrl = "popUpDwgPlanReasonList.do";
	
	$( "#supplyReasonList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : sUrl,
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
}

//FILE 그리드 조회 함수
function fn_reasonFileSearch() {
		
	var sUrl = "reasonFile.do";
	
	$( "#supplyReasonFileList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : sUrl,
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
}

//상세내역 조회 함수
function fn_ReasonDetailSearch2(project,supply_id,reason_gubun) {
	$.post( "popUpDwgPlanReasonDetail2.do?p_project="+project+"&p_supplyId="+supply_id+"&p_reasonGubun="+reason_gubun, "", function( data ) {
		$("#d_title").val(data.title);
		$("#d_reasonGubun").val(data.reason_gubun);
		$("#d_reasonComment").val(data.reason_comment);
	}, "json" );
}

//메인 그리드의 cell이 변경된 경우 호출되는 함수
function changeReasonEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyReasonList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyReasonList').jqGrid("setRowData", irowId, item);
}

//CATALOG 그리드의 cell이 변경된 경우 호출되는 함수
function changeFileEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#supplyReasonFileList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') item.oper = 'U';
	// apply the data which was entered.
	$('#supplyReasonFileList').jqGrid("setRowData", irowId, item);
}	

//변경 사항 Validation 
function fn_checkValidate() {
	var result = true;
	var reasonChangedCnt = 0;
	
	//메인 그리드 체크
	var ids = $( "#supplyReasonList" ).jqGrid( 'getDataIDs' );
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'I' || oper == 'U') {
			reasonChangedCnt++;
			//필수항목 체크 : reason_gubun
			var val1 = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[i], 'reason_gubun' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "구분을 선택하십시오." );
				return;
			}
			//필수항목 체크 : title
			var val2 = $( "#supplyReasonList" ).jqGrid( 'getCell', ids[i], 'title' );
			if ( $.jgrid.isEmpty( val2 ) ) {
				alert( "TITLE을 입력하십시오." );
				return;
			}
		}
		if( oper == 'D') {
			reasonChangedCnt++;
		}
	}

	if ( reasonChangedCnt == 0 ) {
		result = false;
		alert( "변경된 내용이 없습니다." );
	}
	return result;
}

//afterSaveCell oper 값 지정
function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $( '#supplyReasonList' ).jqGrid( 'getRowData', irowId );
	
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#supplyReasonList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
		
	
	$( '#supplyReasonList' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
}

//메인 그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#supplyReasonList" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );
	
	callback.apply(this, [ changedData.concat(resultData) ]);
};

//FILE 그리드의 변경된 내용을 가져온다.
function getDeleteFileResultData( callback ) {
	var changedData = $.grep( $( "#supplyReasonFileList" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.enable_flag == 'Y';
	} );

	callback.apply(this, [ changedData.concat(resultData) ]);
};

function fn_downLoadFile() {
	var sUrl = "downloadReasonFile.do";
	var f = document.listForm;

	f.action = sUrl;
	f.method = "post";
	f.submit();
}

</script>
</html>