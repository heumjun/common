<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Pattern 등록/수정</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

<form name="listForm" id="listForm"  method="get">

<input type="hidden"  name="pageYn" 	value="N"  		  		/>
<input type="hidden"  name="mod"		value=""	  			/>
<input type="hidden"  name="project_no" value="${project_no}"   />
<input type="hidden"  name="revision"   value="${revision}"   	/>
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>


<div id="mainDiv"  class="mainDiv" style="float: left; margin-left: 5px;">
	<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
			<span class="pop_tit">Pattern Code</span>
			<input type="text" id="txtPatternCode" class = "required" name="pattern_code" value="${pattern_code}" style="width:100px; height:25px;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">
			<span class="pop_tit">Copy Pattern Code</span>
			<input type="text" id="txtCopyPatternCode" name="copy_pattern_code" value="" style="width:100px;  height:25px;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			<input type="button" value="복사" id="btnCopy" 	class="btn_blue"  />
			</span>
		</div>
		
		<!--  
		<div class = "conSearch">
			<span class = "spanMargin">
			구획명
			<input type="text" id="txtLossDesc" name="lossDesc" style="width:200px;" />
			</span>
		</div>
		-->
		
		<div class = "button">
			<c:if test="${userRole.attribute4 == 'Y'}">
			<input type="button" value="저 장" id="btnSave"  	class="btn_blue"/>
			</c:if>
			<input type="button" value="닫 기" id="btnClose" 	  	class="btn_blue"/>
		</div>
	</div>
	<div class="content" style="position:relative; float: left; width: 100%;">
		<fieldset id="paintCodeGridDiv" style="border:none;">
			<!-- <legend class="sc_tit sc_tit2">PAINT SCHEME</legend> -->
			<table id = "paintCodeGrid"></table>
			<div   id = "p_paintCodeGrid"></div>
		</fieldset>
				
		<div style="position:relative; float: left;width:49%; ">
			<fieldset id="areaGridDiv" style="position:relative; float:left; border:none; width:100%; margin-top:5px;">
				<!-- <legend class="sc_tit sc_tit2">PAINT PATTERN</legend> -->
				<table id = "areaGrid"></table>
				<div   id = "p_areaGrid"></div>
			</fieldset>
			<div style="position:relative; float:left; margin-top:10px;">
				<span class="pop_tit">Area</span>
				<input type="text"   id="txtAreaCode" 	 name="area_code"  style="width:100px; height:25px;"/>
				&nbsp;
				<span class="pop_tit">Loss</span>
				<input type="text"   id="txtLossCode" 	 name="loss_code"  style="width:50px; height:25px;"/>
				
				<input type="button" id="btnAreaSearch"  value="조회" class="btn_gray2" />
			</div>
			<fieldset  id="searchAreaGridDiv" style="position:relative; width:100%; float:left; border:none;  margin-top: 10px;">	
				<table id = "searchAreaGrid"></table>
				<!--  <div   id = "p_searchAreaGrid"></div> -->
			</fieldset>		
		</div>
		<fieldset  id="lossSetGridDiv" style="position:relative; float: right; border:none; width:49%; margin-top:5px;">
		<!--<legend class="sc_tit sc_tit2">LOSS CODE</legend> -->
			<table id = "lossSetGrid"></table>
			<div   id = "p_lossSetGrid"></div>
		</fieldset>				
	</div>		
</div>	
</form>

<script type="text/javascript">

var change_paint_row = 0,change_paint_row_num = 0,change_paint_col = 0;
var change_area_row  = 0,change_area_row_num  = 0,change_area_col  = 0;
var deletePaintData	 = [], deleteAreatData = [];
var tableId			 = "#paintCodeGrid";

var searchIndex 	 = 0;
var lodingBox; 
var win;	

var mod				= $.jgrid.isEmpty("${pattern_code}") ? "I" : "U";
var isConfirm		= "N";
var undefineFlag	= "${is_confirm}";
var paintDesc		= "";
var prevCellVal1	= { cellId: undefined, value: undefined };
var prevCellVal2	= { cellId: undefined, value: undefined };

var lossCodeOnOffFlag;
$(document).ready(function(){
		
	$("input[name=mod]").val(mod);
		
	// Cell - Merge
	rowspaner = function (rowId, val, rawObject, cm, rdata) {
                var result;

                if (prevCellVal1.value == val) {
                	result = ' style="display: none" rowspanid="' + prevCellVal1.cellId + '"';
                } else {
                    var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                    result = ' rowspan="1" id="' + cellId + '"';
                    prevCellVal1 = { cellId: cellId, value: val };
                }
				
                return result;
    };
    rowspaner2 = function (rowId, val, rawObject, cm, rdata) {
        var result;

        if (rdata.set_name == prevCellVal2.value) {
        	result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
        } else {
            var cellId = this.id + '_row_' + rowId + '_' + cm.name;

            result = ' rowspan="1" id="' + cellId + '"';
            prevCellVal2 = { cellId: cellId, value: rdata.set_name };
        }
		
        return result;
};
    // 상단 paint code 부분
	$("#paintCodeGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'searchPatternPaintItem.do',
             postData   : getFormData("#listForm"),
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', '회차', 'Paint Code', 'Paint Desc', 'DFT', 'STAGE', 'SVR', 'SEASON', '선행 LOSS', '후행 LOSS','',''],
                colModel:[
                	{name:'chk', 		 index:'chk', 			width:12,  sortable:false, align:'center', formatter: formatOpt1},
                	{name:'paint_count', index:'paint_count', 	width:20,  editable:true,  align:'right',  sortable:false, editrules:{required:true,number:true}},
                	{name:'paint_item',	 index:'paint_item', 	width:50,  editable:true,  sortable:false, editoptions: {maxlength : 25, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                	{name:'paint_desc',	 index:'paint_desc', 	width:110, sortable:false, align:'left', editrules:{required:true}},
                	{name:'paint_dft',	 index:'paint_dft', 	width:30,  editable:true,  align:'right', sortable:false, editrules:{required:true,number:true}},
                	{name:'paint_stage', index:'paint_stage', 	width:30,  editable:true, align:'center', sortable:false, editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},							
                	{name:'paint_svr',	 index:'painat_svr', 	width:30,  sortable:false, align:'right', editrules:{required:true}},
                	{name:'season_code', index:'season_code', 	width:30,  editoptions: { dataInit: function(elem) {$(elem).width(40);}}  // set the width which you need
                    ,align :'center', sortable : false, edittype : 'select',  editrules : { required:true } },
                	
                	{name:'pre_loss',	 index:'pre_loss', 		width:40,  editable:true,  align:'right', sortable:false, editrules:{number:true}},
                	{name:'post_loss',	 index:'post_loss', 	width:40,  editable:true,  align:'right', sortable:false, editrules:{number:true}},
                	
                    {name:'pattern_rowid',index:'pattern_rowid', width:25, hidden:true},                   
                    {name:'oper',index:'oper', width:25, hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
			 caption : 'PAINT SCHEME',
			 hidegrid : false,
             autowidth : true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: $(window).height()/3-115,
             pager		: jQuery('#p_paintCodeGrid'),
             pgbuttons  : false,
			 pgtext     : false,
			 pginput    : false,
			 viewrecords: false, 
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         rowNum		: 9999, 
	         
	         beforeSaveCell : changePaintCodeEditEnd, 
	         imgpath		: 'themes/basic/images',
	         
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {	
             	if (name == "paint_item" || name == "paint_stage") {
             		setUpperCase('#paintCodeGrid', rowid, name);
             	}
             	if (name == "paint_item"){
             		searchItemCode("#paintCodeGrid", rowid);	
             	}
             	
             	if (name == "paint_stage"){
             		searchStageCode("#paintCodeGrid",'paint_stage', rowid);
             	}
             	
                
             	fn_jqGridChangedCell('#paintCodeGrid', rowid, 'chk', {background:'pink'});	
             	
             	
	         },
	         
			 gridComplete : function () {
		 	 	var rows = $("#paintCodeGrid").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++) {	
			    	if (isConfirm == "Y") {
			    		$("#paintCodeGrid").jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#cfefcf'});
			   		} else{
			   			var oper = $( "#paintCodeGrid" ).getCell( rows[i], "oper" );
						if( oper == "I" ) {
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 't_desc','', {background : '#DADADA' } );
						}else {
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 't_desc','', {background : '#DADADA' } );
						}
						if(oper != 'D') {
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 'paint_item', '', { cursor : 'pointer', background : 'pink' } );
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 'paint_stage', '', { cursor : 'pointer', background : 'pink' } );
							
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 'paint_desc','', {background : '#DADADA' } );
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 'paint_svr','', {background : '#DADADA' } );
							$( "#paintCodeGrid" ).jqGrid( 'setCell', rows[i], 'season_code','', {background : '#DADADA' } );
						}
			   		}
				}
			 },
			 
	         loadComplete : function (data) {
	        	 deleteArrayClear();
	        	 if (mod == "U") {
				       	$("#txtPatternCode").attr("readonly",true);
				 } else {
				 		$("#txtPatternCode").removeAttr("readonly");
				 }
			 },	
			          
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_paint_row 	 =	rowid;
             	change_paint_row_num =	iRow;
             	change_paint_col 	 =	iCol;
   			 },
			   	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },  
                      
            
             onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret	= $("#paintCodeGrid").getRowData(row_id);
                	    
                	if (isConfirm == "Y") {
                		
                		var colModel = $('#paintCodeGrid').jqGrid('getGridParam', 'colModel');
						
						for(var i in colModel) $("#paintCodeGrid").jqGrid('setCell', row_id, colModel[i].name, '', 'not-editable-cell');
                	
                	} else {
                		if (colId == 2 && ret.oper != "I") $("#paintCodeGrid").jqGrid('setCell', row_id, 'paint_count', '', 'not-editable-cell');
                	}
                	
                	//if (colId == 3 && ret.oper != "I") jQuery("#paintCodeGrid").jqGrid('setCell', row_id, 'paint_item', '', 'not-editable-cell');
                } 
             }
    }); 
	
	// 그리드 버튼 설정
	$("#paintCodeGrid").jqGrid('navGrid',"#p_paintCodeGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	// 그리드 초기화 함수 설정
	$("#paintCodeGrid").navButtonAdd("#p_paintCodeGrid",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_searchPaintItem();
				},
				position:"first",
				title:"",
				cursor:"pointer"
			}
	);
	// Pattern 미확정인경움 버튼 설정
	if (isConfirm == "N") {
		
		<c:if test="${userRole.attribute3 == 'Y'}">
		// 그리드 Row 삭제 함수 설정
		$("#paintCodeGrid").navButtonAdd('#p_paintCodeGrid',
				{ 	caption:"", 
					buttonicon:"ui-icon-minus", 
					onClickButton: fn_deletePaintCode,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} 
		);
		</c:if>
		
		<c:if test="${userRole.attribute2 == 'Y'}">		
		// 그리드 Row 추가 함수 설정
	 	$("#paintCodeGrid").navButtonAdd('#p_paintCodeGrid',
				{ 	caption:"", 
					buttonicon:"ui-icon-plus", 
					onClickButton: fn_addPaintCode,
					position: "first", 
					title:"Add", 
					cursor: "pointer"
				} 
		);
	 	</c:if>
	}
	
	$("#areaGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'searchPatternPaintArea.do',
             postData   : getFormData("#listForm"),
             colNames:['<input type="checkbox" id = "chkHeader2" onclick="checkBoxHeader2(event)" />', 'Pattern Code', 'Area Code', 'Area Desc', 'Loss Code','','',''],
                colModel:[
                	{name:'chk', 		  index:'chk', 				width:12,  sortable:false, align:'center',formatter: formatOpt2},
                	{name:'pattern_code', index:'pattern_code', 	width:40,  sortable:false, align:'center'},
                	{name:'area_code',	  index:'area_code', 		width:40,  sortable:false, align:'left', editable:true, editrules:{required:true}, editoptions: {maxlength : 25, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                	{name:'area_desc',	  index:'area_desc', 		width:100, sortable:false, align:'left'},
                	{name:'loss_code',	  index:'loss_code', 		width:40,  sortable:false, align:'left'},
                	                	
                    {name:'pattern_rowid',index:'pattern_rowid', 	width:25, 	hidden:true},                   
                    {name:'add_gbn', 	  index:'add_gbn',   		width:25,   hidden:true},     
                    {name:'oper',		  index:'oper', 			width:25, 	hidden:true}
                ],
             caption : 'PAINT PATTERN',
   			 hidegrid : false,   
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],           
             autowidth : true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: $(window).height()/3-130,
			 pager		: jQuery('#p_areaGrid'),
             pgbuttons  : false,
			 pgtext     : false,
			 pginput    : false,
			 viewrecords: false, 
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         rowNum		: 9999, 
	        
	         beforeSaveCell : changeAreaCodeEditEnd, 
	         imgpath		: 'themes/basic/images',
	         
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {	
             	if (name == "area_code") {
             		setUpperCase('#areaGrid',rowid,name);
                    searchAreaCode("#areaGrid",'area_code','area_desc','loss_code',rowid);
             	}   
             	
             	fn_jqGridChangedCell('#areaGrid', rowid, 'chk', {background:'pink'});		
	         },
	         
			 gridComplete : function () {
		 	 	var rows = $("#areaGrid").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++) {	
			    	if (isConfirm == "Y") {
			    		$("#areaGrid").jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#cfefcf'});
			    	} else {
			    		var oper = $( "#areaGrid" ).getCell( rows[i], "oper" );
						
						if(oper != 'D') {
							if( oper == "I" ) {
								$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { cursor : 'pointer', background : 'pink' } );
							}else {
								$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', {background : '#DADADA' } );
							}
							$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'pattern_code','', {background : '#DADADA' } );
							$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'area_desc','', {background : '#DADADA' } );
							$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'loss_code','', { cursor : 'pointer', background : 'pink' } );
							
						}
			    	}
				}
			 },
			 
			 loadComplete : function (data) {
			    deleteArrayClear();
			 },	 
			         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_area_row 	=	rowid;
             	change_area_row_num =	iRow;
             	change_area_col 	=	iCol;
   			 },
			   	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },  
                  
             onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#areaGrid").getRowData(row_id);
                	
                	if (isConfirm == "Y") {
                		
                		var colModel = $('#areaGrid').jqGrid('getGridParam', 'colModel');
						
						for(var i in colModel) $("#areaGrid").jqGrid('setCell', row_id, colModel[i].name, '', 'not-editable-cell');
                	
                	} else {
                		if (colId == 4) fn_searchLossCodeSetName(ret.loss_code);
                		
                		if (ret.oper != "I") {
                			$("#areaGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');                	
                		} else {
                			if (ret.add_gbn == "grid") $("#areaGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');
                		}
                	
                	}        	
                	           	
                } 
             }
    }); 
	
	// 그리드 버튼 설정
	$("#areaGrid").jqGrid('navGrid',"#p_areaGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	// 그리드 초기화 함수 설정
	$("#areaGrid").navButtonAdd("#p_areaGrid",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_searchPaintArea();
				},
				position:"first",
				title:"",
				cursor:"pointer"
			}
	);
	// Pattern 미확정인경우 버튼 설정
	if (isConfirm == "N") {
		
		<c:if test="${userRole.attribute3 == 'Y'}">
		// 그리드 Row 삭제 함수 설정
		$("#areaGrid").navButtonAdd('#p_areaGrid',
				{ 	caption:"", 
					buttonicon:"ui-icon-minus", 
					onClickButton: fn_deleteAreaCode,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} 
		);
		</c:if>
		
		/* <c:if test="${userRole.attribute2 == 'Y'}">
		// 그리드 Row 추가 함수 설정
	 	$("#areaGrid").navButtonAdd('#p_areaGrid',
				{ 	caption:"", 
					buttonicon:"ui-icon-plus", 
					onClickButton: fn_addAreaCode,
					position: "first", 
					title:"Add", 
					cursor: "pointer"
				} 
		);
	 	</c:if> */
	}
	
	$("#lossSetGrid").jqGrid({ 
             datatype	: 'json', 
             url		: '',
             mtype		: '',
             postData   : getFormData("#listForm"),
             colNames:['Set', '회차', '도료Type', 'Stage','Remark', '', '', '', ''],
                colModel:[
                	{name:'set_name',	  		index:'set_name', 			width:10,  cellattr: rowspaner},
                	{name:'paint_count_desc',	index:'paint_count_desc', 	width:10},
                	{name:'paint_type',	  		index:'paint_type', 		width:20},
                	{name:'stage_desc',	  		index:'stage_desc', 		width:10, 	align:'center'},
                	{name:'remark',	  			index:'remark', 			width:40,  cellattr: rowspaner2},
                	{name:'paint_count',		index:'paint_count', 		width:25, 	hidden:true},
                	{name:'pre_loss',		  	index:'pre_loss', 			width:25, 	hidden:true},
                	{name:'post_loss',		  	index:'post_loss', 			width:25, 	hidden:true},
                	{name:'oper',		  		index:'oper', 				width:25, 	hidden:true}
                ],
             caption : 'LOSS CODE',
      		 hidegrid : false,      
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],      
             autowidth : true,                    //사용자 화면 크기에 맞게 자동 조절
             height		: $(window).height()/3*2-128,
			 rowNum		: 9999, 			
				
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         imgpath	: 'themes/basic/images',
	         
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {	
             
	         },
	         
			 gridComplete : function () {
		 		
			    var grid = this;

		        $('td[rowspan="1"]', grid).each(function () {
		            var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;

		            if (spans > 1) {
		                $(this).attr('rowspan', spans);
		            }
		        });
		        
		        		        
		        var rows = $("#lossSetGrid").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++) {	
			    	$( "#lossSetGrid" ).jqGrid( 'setCell', rows[i], 'set_name', '', { cursor : 'pointer', background : 'pink' } );
				}
			    
			 },
			 
			 loadComplete : function (data) {
			  	
			 },	 
			    
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root		 : "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page		 : "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total		 : "total",                  // 총 페이지 수
                 records	 : "records",
                 repeatitems : false,
             },
             
             onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#lossSetGrid").getRowData(row_id);
                	
                	var $lossSetGrid   = $("#lossSetGrid");
                	var $paintCodeGrid = $("#paintCodeGrid");
                	
                	if (colId == 0 && isConfirm == "N") {
                		if(lossCodeOnOffFlag == 'N'){
                			alert("LOSE CODE 가 OFF 설정 되어있습니다.");
                			return;
                		}
                 		//grid 저장 처리
						fn_applyData("#paintCodeGrid",change_paint_row_num,change_paint_col);
	
                		var ids1 = $lossSetGrid.jqGrid('getDataIDs');
                		var ids2 = $paintCodeGrid.jqGrid('getDataIDs');
                		
                		for(var i=0; i<ids1.length; i++) {		
 							var item1 =  $lossSetGrid.jqGrid('getRowData', ids1[i]);
 							if (ret.set_name == item1.set_name) {	
 								
 								for(var j=0; j<ids2.length; j++) {
 									var item2 = $paintCodeGrid.jqGrid('getRowData', ids2[j]);
 									if (item1.paint_count == item2.paint_count) {
 									
 										$paintCodeGrid.setCell(ids2[j],'pre_loss',$lossSetGrid.getCell(ids1[i],'pre_loss'), { 'background' : '#6DFF6D' });
										$paintCodeGrid.setCell(ids2[j],'post_loss',$lossSetGrid.getCell(ids1[i],'post_loss'), { 'background' : '#6DFF6D' });
										if (item2.oper != "I")  $paintCodeGrid.setCell(ids2[j],"oper","U"); 
										//break; 									
 									}
 								}
 							}              		
                		}
                	}
                } 
             } 
            
     }); 
	
	$("#searchAreaGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'searchAreaCodeFromBlock.do',
             postData   : getFormData("#listForm"),
             colNames:['Area Code', 'Area Desc', 'Loss Code',''],
                colModel:[
                	{name:'area_code',	  index:'area_code', 		width:50,  editrules:{required:true}},
                	{name:'area_desc',	  index:'area_desc', 		width:100, editrules:{required:true}},
                	{name:'loss_code',	  index:'paint_dft', 		width:35,  editrules:{required:true}},
                	{name:'oper',		  index:'oper', 			width:25, 	hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],      
             autowidth : true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: $(window).height()/3-105,
             rowNum		: 9999, 
			 imgpath	: 'themes/basic/images',
	         loadonce	: true,
	         
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {	
             
	         },
	       
			 gridComplete : function () {
		 		
			 },
			 
	         loadComplete : function (data) {
	          
			 },	      
			 
			 onSelectRow : function(rowid, colId) {
			 	
			 	var ret = $("#searchAreaGrid").getRowData(rowid);
 		 	
	 		 	if (!isAreaCodeDuplication("#areaGrid",ret.area_code)) {
	 		 	 	// 행추가
		 		 	addAreaCodeAreaGrid("grid", ret.area_code, ret.area_desc, ret.loss_code);	
		 		 	
		 		 	// 행삭제
		 		 	$('#searchAreaGrid').jqGrid('delRowData', rowid);
		 		} else {
		 		
		 		}		 
			 	/*
			 	var $togrid   = $("#searchAreaGrid");
			 	var $fromgrid = $("#areaGrid");
			 	var formRowid = $fromgrid.jqGrid('getGridParam','selrow');  
			 	var oper	  = $fromgrid.getCell(formRowid,'oper');	 
			 	
			 	if (formRowid != null && isConfirm == "N"
			 		&& fn_isExistArea($togrid.getCell(rowid,'area_code'))) 
			 	{
			 		
			 		fn_applyData("#areaGrid",change_area_row_num,change_area_col);
			 		
			 		$fromgrid.setCell(formRowid,'area_code',$togrid.getCell(rowid,'area_code'));
			 		$fromgrid.setCell(formRowid,'area_desc',$togrid.getCell(rowid,'area_desc'));	
			 		$fromgrid.setCell(formRowid,'loss_code',$togrid.getCell(rowid,'loss_code'));	
			 		
			 		if(oper != 'I') $fromgrid.setCell(formRowid,"oper","U"); 	
			 	} */
			 },   
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root		 : "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page		 : "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total		 : "total",                  // 총 페이지 수
                 records	 : "records",
                 repeatitems : false,
             } 
            
     }); 
	
	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	// 닫기	
	$("#btnClose").click(function() {
		self.close();
	});
	
	//조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});
	
	// Area 조회 버튼
	$("#btnAreaSearch").click(function() {
		fn_searchAreaCodeFromBlock();
	});
	
	// 복사 버튼
	$("#btnCopy").click(function() {
		
		var val1 = $("input[name=copy_pattern_code]").val();
		
		if ( $.jgrid.isEmpty(val1) ) {
			alert("Copy Pattern Code을 입력해주세요.");
		} else {
			fn_searchCopyItemListFromPattern();
		}
	});
		
	// 확인인 경우 저장,복사 버튼 비활성화
	if (isConfirm == "Y") {
		$( "#btnSave" ).attr( "disabled", true );
		$( "#btnSave" ).removeClass( "btn_blue" );
		$( "#btnSave" ).addClass( "btn_gray" );
		
		$( "#btnCopy" ).attr( "disabled", true );
		$( "#btnCopy" ).removeClass( "btn_blue" );
		$( "#btnCopy" ).addClass( "btn_gray" );
	}
	
	$.post( "selectLoseCodeOnOff.do", "", function( data ) {
		lossCodeOnOffFlag = data.attribute2;
	}, "json" );
	
	fn_insideGridresize($(window),$("#paintCodeGridDiv"),$("#paintCodeGrid"),-100,1/3);
	fn_insideGridresize($(window),$("#areaGridDiv"),$("#areaGrid"),-100,1/3);
	fn_insideGridresize($(window),$("#lossSetGridDiv"),$("#lossSetGrid"),-100,2/3);
	fn_insideGridresize($(window),$("#searchAreaGridDiv"),$("#searchAreaGrid"),-110,1/3);
	
	
});  //end of ready Function 
	
/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// paintCode 삭제
function fn_deletePaintCode(){
	
	//grid 저장 처리
	fn_applyData("#paintCodeGrid",change_paint_row_num,change_paint_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#paintCodeGrid').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#paintCodeGrid').jqGrid("setRowData", selrow, item);
			var colModel = $( '#paintCodeGrid' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#paintCodeGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
			//deleteData.push(item);
		} else if(item.oper == 'I') {
			$('#paintCodeGrid').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		}
		
		
		/* if(item.oper != 'I') {
			item.oper = 'D';
			deletePaintData.push(item);
		}
		
		$('#paintCodeGrid').jqGrid('delRowData', selrow); */
	}
	
	$('#paintCodeGrid').resetSelection();
}

// paintCode 추가
function fn_addPaintCode(item){
	
	//grid 저장 처리
	fn_applyData("#paintCodeGrid",change_paint_row_num,change_paint_col);
	
	var item = {};
	var colModel = $('#paintCodeGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 		= 'I';
	item.season_code 	= 'S';
	
	var nRandId = $.jgrid.randId();
	$('#paintCodeGrid').resetSelection();
	$('#paintCodeGrid').jqGrid('addRowData', nRandId, item, 'last');
		
	fn_jqGridChangedCell('#paintCodeGrid', nRandId, 'chk', {background:'pink'});
	
	tableId = '#paintCodeGrid';
		
}

//Del 버튼
function fn_deleteAreaCode(){
	
	//grid 저장 처리
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox2']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#areaGrid').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#areaGrid').jqGrid("setRowData", selrow, item);
			var colModel = $( '#areaGrid' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#areaGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
			//deleteData.push(item);
		} else if(item.oper == 'I') {
			$('#areaGrid').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		}
		
		
		/* if(item.oper != 'I') {
			item.oper = 'D';
			deleteAreatData.push(item);
		} */
		
		if (!isAreaCodeDuplication("#searchAreaGrid",item.area_code) && !$.jgrid.isEmpty(item.area_code)
				&& (item.oper != 'I' || (item.oper == 'I' && item.add_gbn == "grid")))
		{
			addAreaCodeSearchAreaGrid(null,item.area_code,item.area_desc,item.loss_code);
		}
	
		//$('#areaGrid').jqGrid('delRowData', selrow);
	}
	
	$('#areaGrid').resetSelection();
}

//Add 버튼 
function fn_addAreaCode(item) {
	
	/*
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	var item = {};
	var colModel = $('#areaGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	
	item.oper 	 = 'I';
	if (mod == "U") item.pattern_code = $("#txtPatternCode").val();
	
	var nRandId = $.jgrid.randId(); 		
	$('#areaGrid').resetSelection();
	$('#areaGrid').jqGrid('addRowData', nRandId, item, 'last');
	fn_jqGridChangedCell('#areaGrid', nRandId, 'chk', {background:'pink'});*/
	
	//grid 저장 처리
	addAreaCodeAreaGrid('',null);
	tableId = '#areaGrid';
	
}

// afterSaveCell oper 값 지정
function changePaintCodeEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#paintCodeGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I'){
		item.oper = 'U';
		$( '#paintCodeGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
		
	// apply the data which was entered.
	$('#paintCodeGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	

// afterSaveCell oper 값 지정
function changeAreaCodeEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#areaGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I'){
		item.oper = 'U';
		$( '#areaGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#areaGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
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

// header checkbox action 
function checkBoxHeader2(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader2").is(":checked"))){
		$(".chkboxItem2").prop("checked", true);
	}else{
		$("input.chkboxItem2").prop("checked", false);
	}
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Area Grid 추가
function addAreaCodeSearchAreaGrid(addGbn, sAreaCode, sAreaDesc, sLossCode) {
	var item 	 = {};
	var colModel = $('#searchAreaGrid').jqGrid('getGridParam', 'colModel');
	
	// 초기화 한다.
	for(var i in colModel) item[colModel[i].name] = '';
	item.area_code  = sAreaCode;
	item.area_desc  = sAreaDesc;
	item.loss_code  = sLossCode;
				
	$('#searchAreaGrid').resetSelection();
	$('#searchAreaGrid').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
}

// Area Grid 삭제
function addAreaCodeAreaGrid(sAddGbn, sAreaCode, sAreaDesc, sLossCode) {
	
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	var item 	 = {};
	var colModel = $('#areaGrid').jqGrid('getGridParam', 'colModel');
	
	// 초기화 한다.
	for(var i in colModel) item[colModel[i].name] = '';
	
	// 기본값 설정한다.
	item.oper 	    = 'I';
	if (mod == "U") item.pattern_code = $("#txtPatternCode").val();
		
	if (sAddGbn == "grid") {
		item.area_code  = sAreaCode;
		item.area_desc  = sAreaDesc;
		item.loss_code  = sLossCode;
		item.add_gbn  	= sAddGbn;
	}
	
	var nRandId = $.jgrid.randId();		
	
	$('#areaGrid').resetSelection();
	$('#areaGrid').jqGrid('addRowData', nRandId, item, 'first');
	
	fn_jqGridChangedCell('#areaGrid', nRandId, 'chk', {background:'pink'});	
}

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 동일한 area_code가 존재하느지 체크
function isAreaCodeDuplication(gridId,sAreaCode) {

	var ids = $(gridId).jqGrid('getDataIDs');
	var bRs = false;
	for (var i=0; i<ids.length; i++) {

		if (sAreaCode == $(gridId).getCell(ids[i],'area_code')) {
			bRs = true;
			break;
		}
	}
	
	return bRs;
}

// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드에 변경된 데이터Validation체크하는 함수	
function fn_checkPaintCodeValidate(arr1, arr2) {
	var result   = true;
	var message  = "";
	var ids ;
		
	if ($.jgrid.isEmpty($("#txtPatternCode").val())) {
		result  = false;
		message = "Pattern Code is required";	
	
		setTimeout('$("#txtPatternCode").focus()',200);	
	}
		
	if (result && arr1.length == 0 && arr2.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";		
	}
	
	if (result && arr1.length > 0) {
		ids = $("#paintCodeGrid").jqGrid('getDataIDs');
		for(var  i = 0; i < ids.length; i++) {
			var item =  $("#paintCodeGrid").jqGrid('getRowData', ids[i]);
			
			if (item.oper == 'I' || item.oper == 'U') {
				
				if ($.jgrid.isEmpty(item.paint_count)) {
					result  = false;
					message = "회차 Field is required";
					
					setErrorFocus("#paintCodeGrid",ids[i],1,'paint_count');
					break;
				}
				
				if ($.jgrid.isEmpty(item.paint_item)) {
					result  = false;
					message = "Paint Code Field is required";
					
					setErrorFocus("#paintCodeGrid",ids[i],2,'paint_item');
					break;
				}
				
					
				if ($.jgrid.isEmpty(item.paint_stage)) {
					result  = false;
					message = "Stage Field is required";
					
					setErrorFocus("#paintCodeGrid",ids[i],5,'paint_stage');
					break;
				}
				
				
				if ($.jgrid.isEmpty(item.season_code)) {
					result  = false;
					message = "Season Field is required";
					
					setErrorFocus("#paintCodeGrid",ids[i],6,'season_code');
					break;
				}
			
			}
		}
	}
	
	if (result && arr2.length > 0) {
		ids = $("#areaGrid").jqGrid('getDataIDs');
		for(var  i = 0; i < ids.length; i++) {
			var item =  $("#areaGrid").jqGrid('getRowData', ids[i]);
			
			if (item.oper == 'I' || item.oper == 'U') {
				
				if ($.jgrid.isEmpty(item.area_code)) {
					result  = false;
					message = "Area Field is required";
					
					setErrorFocus("#areaGrid",ids[i],2,'paint_count');
					break;
				}
			}
		}
	}
	
	if (result && arr1.length > 0) {
		ids = $("#paintCodeGrid").jqGrid('getDataIDs');
		for(var i=0; i < ids.length; i++) {
			var iRow = $('#paintCodeGrid').jqGrid('getRowData', ids[i]);									
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $('#paintCodeGrid').jqGrid('getRowData', ids[j]);	
				if (iRow.paint_count == jRow.paint_count && iRow.season_code == jRow.season_code ) {
					result  = false;
					message = "Paint Code의 "+ (i+1)+"ROW, "+(j+1)+"ROW는 중복됩니다.";	
					break;	
				}
			}
			if (result == false) break;
		}
	}
	
	if (result && arr2.length > 0) {
		ids = $("#areaGrid").jqGrid('getDataIDs');
		for(var i=0; i < ids.length; i++) {
			var iRow = $('#areaGrid').jqGrid('getRowData', ids[i]);									
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $('#areaGrid').jqGrid('getRowData', ids[j]);	
				if (iRow.area_code == jRow.area_code ) {
					result  = false;
					message = "Area Code의 "+ (i+1)+"ROW, "+(j+1)+"ROW는 중복됩니다.";	
					break;	
				}
			}
			if (result == false) break;
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

// 그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	
	/* if (gridId == "#paintCodeGrid") {
		changedData = changedData.concat(deletePaintData);	
	} else if (gridId == "#areaGrid") {
		changedData = changedData.concat(deleteAreatData);
	} */ 
			
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}
	
// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.resizeTo(550, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// PaintItem 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// AreaCode 값에 따라서 checkbox 생성
function formatOpt2(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox2' id='"+rowid+"_chkBoxOV2' class='chkboxItem2' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deletePaintData.length > 0) 	deletePaintData.splice(0, 	 deletePaintData.length);
	if (deleteAreatData.length > 0)		deleteAreatData.splice(0,    deleteAreatData.length);
}

// Area Grid에 동일한 area code 여부 리턴한다.
function fn_isExistArea(sAreaCode) {
	var ids = $("#areaGrid").jqGrid('getDataIDs');	
	
	for(var  i = 0; i < ids.length; i++) {
		var formVal = $("#areaGrid").jqGrid('getCell', ids[i], 'area_code');
		
		if (sAreaCode == formVal) return false;
	}
	
	return true;
}

// Cell - Merge변수 초기화
function fn_initPrevCellVal() {
	
	prevCellVal1 = { cellId: undefined, value: undefined };
 	//prevCellVal2 = { cellId: undefined, value: undefined, loss_code: undefined };
 	//prevCellVal3 = { cellId: undefined, value: undefined, loss_code: undefined, loss_desc: undefined };

}

// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
}
	
/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {

	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	fn_applyData("#paintCodeGrid",change_paint_row_num,change_paint_col);
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	var changePaintCodeResultRows   =  getChangedGridInfo("#paintCodeGrid");
	var changeAreaResultRows 		=  getChangedGridInfo("#areaGrid");
	
	if (!fn_checkPaintCodeValidate(changePaintCodeResultRows, changeAreaResultRows)) { 
		lodingBox.remove();
		return;	
	}
		
	var url			= "savePaintPattern.do";
	var dataList    = {paintCodeList:JSON.stringify(changePaintCodeResultRows)
					  ,areaCodeList:JSON.stringify(changeAreaResultRows)};
	var formData 	= getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);

	if(mod == 'U') {
		var undefineDataList = []; 
		undefineDataList[0] = {  project_no  :$("input[name=project_no]").val()
			    ,revision    :$("input[name=revision]").val()
			    ,pattern_code:$("input[name=pattern_code]").val()
			    ,define_flag :undefineFlag}
		var undefineUrl			= "savePatternUndefine.do";
		var undefineList    = {patternCodeList:JSON.stringify(undefineDataList)};
		
		$.post(undefineUrl, undefineList, function(data) {
			if (data.result == "success") {	 	
				$.post(url, parameters, function(data) {

					alert(data.resultMsg);
					
					if (data.result == "success") {
					 	$("input[name=mod]").val("U");
					 	
					 	opener.fn_search();
					 	
					 	self.close();
					}
				}).fail(function(){
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				}).always(function() {
			    	lodingBox.remove();	
				});
			} else {
				alert("확정 해제 처리에 실패했습니다.");
				lodingBox.remove();	
			}
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			lodingBox.remove();	
		}).always(function() {
		});
	} else {
		$.post(url, parameters, function(data) {

			alert(data.resultMsg);
			
			if (data.result == "success") {
			 	$("input[name=mod]").val("U");
			 	
			 	opener.fn_search();
			 	
			 	self.close();
			}
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
	}
}

// 선택한 Pattern의 Item List를 조회한다. 
function fn_searchPaintItem() {
				
	var sUrl = "searchPatternPaintItem.do";
	$("#paintCodeGrid").jqGrid('setGridParam',{url		: sUrl
										      ,page		: 1
										      ,datatype	: 'json'
										      ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 

// 선택한 Pattern의 Area List를 조회한다.
function fn_searchPaintArea() {
	var sUrl = "searchPatternPaintArea.do";
	$("#areaGrid").jqGrid('setGridParam',{url		: sUrl
									    ,page		: 1
									    ,datatype	: 'json'
									    ,postData   : getFormData("#listForm")}).trigger("reloadGrid");
}

// Block에 등록된 Area List를 조회한다.
function fn_searchAreaCodeFromBlock() {
	var sUrl = "searchAreaCodeFromBlock.do";
	$("#searchAreaGrid").jqGrid('setGridParam',{url			: sUrl
											   ,page		: 1
											   ,datatype	: 'json'
											   ,postData   	: getFormData("#listForm")}).trigger("reloadGrid");
}

// Loss Code에 해당하는 Set Name을 조회한다.
function fn_searchLossCodeSetName(sLossCode) {
	
	fn_initPrevCellVal();
	
	var sUrl = "searchLossCodeSetName.do";
	$("#lossSetGrid").jqGrid('setGridParam',{url		: sUrl
		                                   ,mtype		: 'POST' 
		                                   ,page		: 1
										   ,datatype	: 'json'
										   ,postData   	: {loss_code:sLossCode}}).trigger("reloadGrid");
}

// 복사입력창 입력된 Patten의 Paint Item 조회한다. 
function fn_searchCopyItemListFromPattern() {
	
	var url		   = "searchCopyItemListFromPattern.do";
 	var parameters = {project_no 	: $("input[name=project_no]").val()
			   		 ,revision   	: $("input[name=revision]").val()
			   		 ,pattern_code  : $("input[name=copy_pattern_code]").val()};
						
	$.post(url, parameters, function(data) {

		var obj = data.rows;

	  	if (obj.length > 0) {
	  		
	  		var $paintCodeGrid   = $("#paintCodeGrid");
	  		
	  		// 원래 Pattern Item 삭제
	  		var ids = $paintCodeGrid.jqGrid('getDataIDs');
	  		
	  		for(var i=0; i<ids.length; i++) {
	  			
	  			var item   = $paintCodeGrid.jqGrid('getRowData',ids[i]);
	  			
	  			if(item.oper != 'I') {
					item.oper = 'D';
					deletePaintData.push(item);
				}
				
				$paintCodeGrid.jqGrid('delRowData', ids[i]);
	  		}
	  		
	  		$paintCodeGrid.resetSelection();
	  		
	  		for (var i=0; i<obj.length; i++) {
	  			
	  			var item = {};
				var colModel = $paintCodeGrid.jqGrid('getGridParam', 'colModel');
				for(var k in colModel) item[colModel[k].name] = '';
				
				item.oper 	 		= 'I';
				item.paint_count 	= obj[i].paint_count;
				item.paint_item 	= obj[i].paint_item;
				item.paint_desc 	= obj[i].paint_desc;
				item.paint_dft 	 	= obj[i].paint_dft;
				item.paint_stage 	= obj[i].paint_stage;
				item.paint_svr 	 	= obj[i].paint_svr;
				item.pre_loss 	 	= obj[i].pre_loss;
				item.post_loss 	 	= obj[i].post_loss;
				item.pattern_rowid 	= obj[i].pattern_rowid;
				item.season_code 	= 'S';
	  			
	  			var nRandId = $.jgrid.randId();
				
				$paintCodeGrid.resetSelection();
				$paintCodeGrid.jqGrid('addRowData', nRandId, item, 'last');
					
				fn_jqGridChangedCell('#paintCodeGrid', nRandId, 'chk', {background:'pink'});
			}
	  		  		
	  		tableId = '#paintCodeGrid';	  
	  				
	  	} else {
	  		alert("Paint Item이 존재하지 않습니다.");	
	  	}
	  	
	});  	
}


// Paint Area 조회하는 화면 호출 
function searchAreaCode(sTableId, sCode, sDesc, opt1, rowid, nCol) {
		
	/* var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData(tableId,nRow,nCol); */
		
	var item = $(sTableId).jqGrid('getRowData',searchIndex);		
	
	var args = {project_no  : $("input[name=project_no]").val(),
				revision	: $("input[name=revision]").val(),
				area_code   : item.area_code};
		
	var rs = window.showModalDialog("popupAreaCodeFromBlock.do",args,"dialogWidth:550px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(sTableId).setCell(rowid,sCode,rs[0]);
		$(sTableId).setCell(rowid,sDesc,rs[1]);
		$(sTableId).setCell(rowid,opt1,rs[2]);
		
	} else {
		$(sTableId).setCell(rowid,sCode,null);
		$(sTableId).setCell(rowid,sDesc,null);
		$(sTableId).setCell(rowid,opt1,null);
	}
}

// Paint Item 조회하는 화면 호출
function searchItemCode(sTableId,rowid) {
	
	//var searchIndex = $(obj).closest('tr').get(0).id;
	
	//fn_applyData(tableId,nRow,nCol);
	
	var item = $(sTableId).jqGrid('getRowData',rowid);		
	var args = {item_code : item.paint_item};
	
	var rs = window.showModalDialog("popupPaintCode.do",args,"dialogWidth:600px; dialogHeight:550px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		item.paint_item = rs[0];
		item.paint_desc = rs[1];
		item.paint_svr = rs[2];
	} else {
		item.paint_item = '';
		item.paint_desc = '';
		item.paint_svr = '';
	}
	$(sTableId).jqGrid("setRowData", rowid, item);
}

// Paint Stage 조회하는 화면 호출
function searchStageCode(sTableId, sCode, rowid) {
	
	/* var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData(tableId,nRow,nCol); */
	
	var item = $(sTableId).jqGrid('getRowData',rowid);		
	var args = {stage_code  : item.paint_stage};
	
	var rs = window.showModalDialog("popupStageCode.do",args,"dialogWidth:520px; dialogHeight:550px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(sTableId).setCell(rowid,sCode,rs[0]);
	} else {
		$(sTableId).setCell(rowid,sCode,null);
	}
}


</script>
</body>
</html>