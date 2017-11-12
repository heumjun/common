<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Paint Zone</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv" class="mainDiv">
<form name="listForm" id="listForm"  method="get">
<div class= "subtitle">
Paint Zone
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden"  name="projectNo"  value=<%=session.getAttribute("paint_project_no")%>  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

	
	<table class="searchArea conSearch">
			<col width="110">
			<col width="210">
			<col width="110">
			<col width="100">
			<col width="110">
			<col width="100">
			<col width=""  style="min-width:200px;">

			<tr>
				<th>PROJECT NO</th>
				<td>
					<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
					<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
					<input type="button" id="btnProjNo"  value="검색" class="btn_gray2">
				</td>

				<th>ZONE CODE</th>
				<td>
					<input type="text" id="zoneCode" name="zoneCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>

				<th>QUAY</th>
				<td>
					<input type="text" id="quayCode" name="quayCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>


				
			<td style="border-left:none;" colspan="2">
			<div class="button endbox">
				<c:if test="${userRole.attribute1 == 'Y'}">
					<input type="button" value="조회" id="btnSearch"  class="btn_blue"/>
				</c:if>
				<c:if test="${userRole.attribute6 == 'Y'}">
				<!--<input type="button" value="Excel등록" disabled id="btnExcelImport"/>-->
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">		
					<input type="button" value="저장" id="btnSave" class="btn_gray" disabled />
				</c:if>
				<c:if test="${userRole.attribute5 == 'Y'}">
					<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
				</c:if>
				
				
			</div>
			</td>

			</tr>
	</table>
	
		
		
		
	<!--	<div class = "conSearch">
			<span class = "spanMargin">
				PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:120px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
							<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" />
							<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
			</span>
		</div>
		<div class="conSearch">
			<span class="spanMargin">
			ZONE CODE
			<input type="text" id="zoneCode" name="zoneCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			QUAY
			<input type="text" id="quayCode" name="quayCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			</span>
		</div>
		<div class="button">
			<input type="button" value="조  회" id="btnSearch"  />
			<input type="button" value="저  장" disabled id="btnSave"  />
			<input type="button" value="Excel등록" disabled id="btnExcelImport"/>
			<input type="button" value="Excel출력" id="btnExcelExport"  />		
	</div>-->




		<div class="content"  >
			<div id = "zoneGridDiv" style="float:left; width:58%;">
				<div class="ct_sc alingR">
					<input type="button" id="btnGroupAllApply" value="일괄적용" class="btn_blue mgb10"/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</div>			
				<table id="zoneGrid"></table> 
				<div id="p_zoneGrid"></div>
			</div>
			<div id = "areaCodeListDiv" style="float:right; width:40%">
				<div class="ct_sc">
					<strong class="pop_tit mgl10">Area Code</strong>
					<input type="text"   id="txtAreaCode"  name="area_code" style="width:100px;"/>
					<input type="button" id="btnAreaSearch" value="조  회" class="btn_blue mgb10" />
				</div>
				<table id = "areaCodeList"></table>
				<div   id = "p_areaCodeList"></div>
			</div>
		</div>	
</form>
</div>	

<script type="text/javascript">

var change_zone_row 	 = 0;
var change_zone_row_num  = 0;
var change_zone_row  	 = 0;

var tableId	   			 = "#zoneGrid";
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
	// Listen for Click Events on the 'Process' check box column
    
	$("#zoneGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames	: ['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Project No','Revision', 'Zone Code','Quay', 'Area Code', 'Area Desc', '대표구역', 'GROUP','대표구역명','','','','',''],
             colModel	: [
                	{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
                	{name:'project_no',index:'project_no',align:"center", width:35},
                    {name:'revision',index:'revision',align:"center", width:25},
                	{name:'zone_code',index:'zone_code', width:40,align:"center", editable:true, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'quay', index:'quay', width:20,align:"right" , editable:true},
                    {name:'area_code',index:'area_code', editable:true, width:35, editoptions:{dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }/* ,dataEvents: [{
																																	                        	type: 'keydown', 
																																	                            fn: function(e){
																																		                                var key = e.charCode || e.keyCode;
																																		                                if(key == 13 || key == 9){//enter,tab
																																		                                    searchAreaCode(this,'area_code','area_desc','01');
																																	                                	}
																																	                            	}
																																	                        	}] */
																				            }
                    },
                    {name:'area_desc',index:'area_desc', width:120},
                    {name:'area_master', index:'area_master', width:30,align:'center',editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
                    {name:'area_group',index:'area_group',align:"center", width:25, editable:true, editoptions:{dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'master_area_desc',index:'master_area_desc', width:120, editable:true},
                    {name:'loss_code',index:'loss_code', hidden:true},
                    {name:'add_gbn',  index:'add_gbn',   hidden:true},
                    {name:'area_master_changed_flag', index : 'area_master_changed_flag', hidden : true},
                    {name:'oper',	  index:'oper', 	 hidden:true},
                  
                    {name:'main_rowid',index:'main_rowid', hidden:true}
                    
                    
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             //autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             width		: $(window).width() * 0.56,
            				
             height		: objectHeight,
             pager		: $('#p_zoneGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changeBlockEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "zone_code" || name == "area_code" || name == "area_group") setUpperCase("#zoneGrid",rowid,name);	
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
			    fn_searchArea();
			    
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
				 var rows = $( "#zoneGrid" ).getDataIDs();

				 var changeFlag = true;
				 var pre_zone_code;
			 	 var zone_code;
					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var oper = $( "#zoneGrid" ).getCell( rows[i], "oper" );
						zone_code = $("#zoneGrid").getCell(rows[i],"zone_code");
						if(zone_code != pre_zone_code) {
				    		if(changeFlag) {
				    			changeFlag = false;
				    		} else {
				    			changeFlag = true;
				    		}
				    		pre_zone_code = $("#zoneGrid").getCell(rows[i],"zone_code");
				    	} 
						if(changeFlag) {
				    		$("#zoneGrid").jqGrid('setRowData',rows[i], false, {  background:'#eeeeee'});
				    		if(oper != "D"){
				    			$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#DADADA' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { color : 'black', background : '#DADADA' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'area_desc', '', { color : 'black', background : '#DADADA' } );
				    		}
				    	}else{
				    		$("#zoneGrid").jqGrid('setRowData',rows[i], false, {  background:'white'});
				    		if(oper != "D"){
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#eeeeee' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#eeeeee' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { color : 'black', background : '#eeeeee' } );
								$( "#zoneGrid" ).jqGrid( 'setCell', rows[i], 'area_desc', '', { color : 'black', background : '#eeeeee' } );
							}
				    	}
					}
			 },
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_zone_row 	=	rowid;
             	change_zone_row_num =	iRow;
             	change_zone_row 	=	iCol;
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
             	
             	if(row_id != null) {
                	var ret 	= jQuery("#zoneGrid").getRowData(row_id); 
                	if (ret.oper != "I") {	
	                	switch(colId) {
	                		/* case 4:
	                			$("#zoneGrid").jqGrid('setCell', row_id, 'zone_code', '', 'not-editable-cell');
	                			break;	 */
	                		case 6:
	                			$("#zoneGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');
	                			break;
	                		default :
	                			break;
	                	}	
                	} else {
                		if (ret.add_gbn == "grid") $("#zoneGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');                	
                	}
                } 
             }
             
     }); 
	
	//grid resize
	fn_insideGridresize($(window),$("#zoneGridDiv"),$("#zoneGrid"),40);
	fn_insideGridresize($(window),$("#areaCodeListDiv"),$("#areaCodeList"),40);
	
	// 그리드 버튼 설정
	$("#zoneGrid").jqGrid('navGrid',"#p_zoneGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정
	$("#zoneGrid").navButtonAdd("#p_zoneGrid",
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
	$("#zoneGrid").navButtonAdd('#p_zoneGrid',
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
 	$("#zoneGrid").navButtonAdd('#p_zoneGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if> */
	
	$("#areaCodeList").jqGrid({ 
            datatype	: 'json', 
            mtype		: '', 
            url			: '',
            postData 	: getFormData("#listForm"),
            editUrl  	: 'clientArray',
       	 	colNames 	: ['AREA CODE','AREA NAME','LOSS CODE',''],
            colModel	: [
	            {name:'area_code',index:'area_code', width:80,  sortable:false, editoptions:{size:11}},
	            {name:'area_desc',index:'area_desc', width:120, sortable:false, editoptions:{size:11}},
	            {name:'loss_code',index:'loss_code', width:50, sortable:false, editoptions:{size:11}},
	            {name:'oper',index:'oper', width:25, hidden:true}
            ],
            gridview	: true,
            cmTemplate: { title: false },
            toolbar		: [false, "bottom"],
            viewrecords : true,   
            autowidth:true,
            width		: $(window).width()  * 0.25,
            height		: $(window).height()-250,
            rowNum		: 99999,
            cellEdit	: true,             // grid edit mode 1
            pager		: $('#p_areaCodeList'),
             
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
		 	if(rowid != null) {
		 	
               	var ret = $("#areaCodeList").getRowData(rowid);
	 		 	
	 		 	if (!isAreaDuplication("#zoneGrid",ret.area_code)) {
	 		 	 	// 행추가
		 		 	addAreaCodeZoneGrid("grid", ret.area_code, ret.area_desc, ret.loss_code);	
		 		 	
		 		 	// 행삭제
		 		 	$('#areaCodeList').jqGrid('delRowData', rowid);
		 		} else {
		 		
		 		}		 	
		 	}
		 }
    });
	
	/* //AF CODE
	$.post( "selectPaintCode.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
		var data2 = $.parseJSON( data );
		
		$( '#zoneGrid' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data2 } );
	} ); */
	
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
	
	//Area 조회 버튼
	$("#btnAreaSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_searchArea();
		}
	});	
	
	//일괄적용 버튼
	$("#btnGroupAllApply").click(function() {		
		fn_groupAllApply();		
	});
	
	/* //엑셀 import 버튼
	$("#btnExcelImport").click(function() {
		if (fn_ProjectNoCheck(true)) {
			fn_excelUpload();	
		}
	}); */
	
	//엑셀 export 버튼
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
		
	//프로젝트 조회 버튼
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	

	fn_searchLastRevision();
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// Del 버튼
function deleteRow() {
	
	fn_applyData("#zoneGrid",change_zone_row_num,change_zone_row);
		
	//가져온 배열중에서 필요한 배열만 골라내기 
	if (fn_ProjectNoCheck(true)) {
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		for(var i=0;i<selarrrow.length-1;i++){
			var selrow = selarrrow[i];	
			var item   = $('#zoneGrid').jqGrid('getRowData',selrow);
			
			if(item.oper =='') {
				item.oper = 'D';
				$('#zoneGrid').jqGrid("setRowData", selrow, item);
				var colModel = $( '#zoneGrid' ).jqGrid( 'getGridParam', 'colModel' );
				for( var j in colModel ) {
					$( '#zoneGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
				}
				//deleteData.push(item);
			} else if(item.oper == 'I') {			
				if (!isAreaDuplication("#areaCodeList",item.area_code) && !$.jgrid.isEmpty(item.area_code)
					&& (item.oper != 'I' || (item.oper == 'I' && item.add_gbn == "grid"))) 
				{
					addAreaCodeAreaGrid(null,item.area_code,item.area_desc,item.loss_code);
				}
				
				$('#zoneGrid').jqGrid('delRowData', selrow);
			} else if(item.oper == 'U') {
				alert("수정된 내용은 삭제 할수 없습니다.");
			}
		}
	}
	
	$('#zoneGrid').resetSelection();
}

/* // Add 버튼 
function addRow(item) {

	addAreaCodeZoneGrid(null,'','','');
	
	tableId = '#zoneGrid';	
} */

// Area 그리드 Row 추가
function addAreaCodeAreaGrid(addGbn, sAreaCode, sAreaDesc, sLossCode) {
	var item = {};
	var colModel = $('#areaCodeList').jqGrid('getGridParam', 'colModel');
	
	// 초기화 한다.
	for(var i in colModel) item[colModel[i].name] = '';
	
	item.area_code  = sAreaCode;
	item.area_desc  = sAreaDesc;
	item.loss_code  = sLossCode;
			
	$('#areaCodeList').resetSelection();
	$('#areaCodeList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
}

// afterSaveCell oper 값 지정
function changeBlockEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#zoneGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#zoneGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#zoneGrid').jqGrid("setRowData", irowId, item);
	
	// turn off editing.
	fn_jqGridChangedCell(tableId, irowId, 'chk', {background:'pink'});
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

// Revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 동일한 area_code가 존재하느지 체크
function isAreaDuplication(gridId,sAreaCode) {

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

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "block_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

// Zone 그리드 Row 추가
function addAreaCodeZoneGrid(sAddGbn, sAreaCode, sAreaDesc, sLossCode) {
	
	fn_applyData("#zoneGrid",change_zone_row_num,change_zone_row);
	
	if (fn_ProjectNoCheck(true)) {
		var item = {};
		var colModel = $('#zoneGrid').jqGrid('getGridParam', 'colModel');
		
		// 초기화 한다.
		for(var i in colModel) item[colModel[i].name] = '';
		
		// 기본값 설정한다.
		item.oper 	    = 'I';
		
		item.revision   = $('input[name=revision]').val();
		item.project_no = $('input[name=project_no]').val();
		item.zone_code  = $('input[name=zoneCode]').val();
		item.quay  		= $('input[name=quayCode]').val();
		
		if (sAddGbn == "grid") {
			item.area_code  = sAreaCode;
			item.area_desc  = sAreaDesc;
			item.loss_code  = sLossCode;
			item.add_gbn    = sAddGbn;
		}
		
		var nRandId = $.jgrid.randId();
				
		$('#zoneGrid').resetSelection();
		$('#zoneGrid').jqGrid('addRowData', nRandId, item, 'first');
		
		fn_jqGridChangedCell('#zoneGrid', nRandId, 'chk', {background:'pink'});	
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
function fn_checkZoneValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
	
	//if ($.jgrid.isEmpty($("input[name=projectNo]").val())) {
	//	result  = false;
	//	message = "호선이 선택되지 않았습니다.";	
	//}
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	// 이부분이 조회된 row가 많으면 시간 오래 걸림... area code 중복 체크 제거. ZONE AREA연계가 KEY IN이 아닌 미연계 AREA 선택 연계이며, DB 저장 시 체크되기에..		
	/***
	if (result && arr1.length > 0) {
		ids = $("#zoneGrid").jqGrid('getDataIDs');
		
		for(var i=0; i < ids.length; i++) {
		
			var iRow = $('#zoneGrid').jqGrid('getRowData', ids[i]);
									
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $('#zoneGrid').jqGrid('getRowData', ids[j]);
				
				if (iRow.area_code == jRow.area_code) {
					result  = false;
					message = (i+1)+"ROW, "+(j+1)+"ROW의 Area Code가  중복됩니다.";	
					
					break;	
				}
			}
			
			if (result == false) break;
		
		}
	}
	***/

	if (result && arr1.length > 0) {
		ids = $("#zoneGrid").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#zoneGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#zoneGrid").jqGrid('getCell', ids[i], 'zone_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Zone Code Field is required";
					
					setErrorFocus("#zoneGrid",ids[i],4,'zone_code');
					break;
				}
				
				val1 = $("#zoneGrid").jqGrid('getCell', ids[i], 'area_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Area Code Field is required";
					
					setErrorFocus("#zoneGrid",ids[i],6,'area_code');
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
    win.resizeTo(550, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 프로젝트 리비젼에 따라 버튼 enable설정하는 함수
function fn_setButtionEnable() {
	
	if ("Y" == isLastRev && sState != "D") {
		$( "#btnSave" ).removeAttr( "disabled" );
		$( "#btnSave" ).removeClass("btn_gray");
		$( "#btnSave" ).addClass("btn_blue");
		
// 		$( "#btnExcelImport" ).removeAttr( "disabled" );
// 		$( "#btnExcelImport" ).removeClass("btn_gray");
// 		$( "#btnExcelImport" ).addClass("btn_blue");
		//$( "#btnExcelExport").removeAttr( "disabled" );
	} else {
		$( "#btnSave" ).attr( "disabled", true );
		$( "#btnSave" ).removeClass( "btn_blue" );
		$( "#btnSave" ).addClass( "btn_gray" );
		
// 		$( "#btnExcelImport" ).attr( "disabled", true );
// 		$( "#btnExcelImport" ).removeClass( "btn_blue" );
// 		$( "#btnExcelImport" ).addClass( "btn_gray" );
		//$( "#btnExcelExport" ).attr( "disabled", true );
	}
}

//그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	fn_applyData("#zoneGrid",change_zone_row_num,change_zone_row);

	var gridData = $("#zoneGrid").jqGrid('getRowData');

	// 변경된 체크 박스가 있는지 체크한다.
	for (var i = 1; i < gridData.length + 1; i++) {
		var item = $('#zoneGrid').jqGrid('getRowData', i);

		// area_master(대표구역)의 변경여부 확인하여 변경 시 업데이트 대상으로 변경
		if (item.oper != 'I' && item.oper != 'U') {
			if (item.area_master_changed_flag != item.area_master) {
				item.oper = 'U';
			}

			if (item.oper == 'U') {
				$('#zoneGrid').jqGrid("setRowData", i, item);
			}
		}
	}	
	
	var changeZoneResultRows =  getChangedGridInfo("#zoneGrid");;

	if (!fn_checkZoneValidate(changeZoneResultRows)) { 
		return;	
	}

	// ERROR표시를 위한 ROWID 저장
	var ids = $("#zoneGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#zoneGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintZone.do";
	var dataList    = {chmResultList:JSON.stringify(changeZoneResultRows)};
	var formData 	= getFormData('#listForm');
	
	var parameters = $.extend({},dataList,formData);
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
	$.post(url, parameters, function(data) {
		
			alert(data.resultMsg);
			
			if (data.result == "success") fn_search();
		
	}, "json" ).error( function () {
		alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
	} ).always( function() {
    	lodingBox.remove();	
	});
}

// Zone Code와 Area Code 맵핑 정보 조회
function fn_search() {
				
	var sUrl = "searchPaintZone.do";
	$("#zoneGrid").jqGrid('setGridParam',{url		: sUrl
										 ,mtype	: 'POST'
										 ,page		: 1
										 ,datatype	: 'json'
										 ,postData  : getFormData("#listForm")}).trigger("reloadGrid");
} 

/* // 엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "./blockExcelUpload.do?gbn=paintBlockExcelUpload";
	sUrl += "&project_no="+$("input[name=project_no]").val();
	sUrl += "&revision="+$("input[name=revision]").val();	
			   									
	win = window.open(sUrl,"listForm","height=260,width=650,top=200,left=200");
} */

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	var sUrl = "./zoneExcelExport.do?";
	sUrl += "&zoneCode="+$("input[name=zoneCode]").val();
	sUrl += "&project_no="+$("input[name=project_no]").val();
	sUrl += "&revision="+$("input[name=revision]").val();	
	
	location.href=sUrl;
}

/* // Paint Area 조회하는 화면 호출
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#zoneGrid",change_zone_row_num,change_zone_row);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	var args = {
				p_code_find : item.area_code,
				project_no	: item.project_no,
				revision	: item.revision
	};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupZoneAreaCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
		
		//fn_jqGridChangedCell(tableId, nRandId, 'chk', {background:'pink'});
	}
} */

// 프로젝트 Area Code List 조회
function fn_searchArea() {
	
	var sUrl = "selectZoneAreaCodeList.do";
	jQuery("#areaCodeList").jqGrid('setGridParam',{url		: sUrl
												  ,mtype	: 'POST'
												  ,page		: 1
												  ,datatype	: 'json'
												  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
}

// Block Code 조회하는 화면 호출
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
	  		$("#zoneGrid").clearGridData(true);
	  		$("#areaCodeList").clearGridData(true);
	  		deleteArrayClear();
	  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	  	
	  	fn_setButtionEnable();
	});  	

}

//ZONE 별 GROUP 일괄 설정(유효한 하나의 ZONE CODE일 경우만 수행)
function fn_groupAllApply() {
	
	if ($.jgrid.isEmpty( $("input[name=zoneCode]").val())) {
		$("input[name=zoneCode]").focus();
		alert("ZONE CODE is required");
		return false;
	}	
				
	var url		   = "checkExistPaintZone.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()
 	                 ,zoneCode   : $("input[name=zoneCode]").val()};
						
	$.post(url, parameters, function(data) {
	  
		if (data != null) {
			alert(data.exist_paint_zone);
			
	  		if (data.exist_paint_zone == "Y") 
	  		{
	  			fn_setGroupAllApply();
	  		} else {
	  			alert("일괄 적용할 ZONE CODE가 유효하지 않습니다.");
	  			return;	  			
	  		}
	  	} else {
	  		return;
	  	}

	}); 
} 


// ZONE이 유효한 경우 GROUP을 'A'로 일괄 셋업 
function fn_setGroupAllApply() {
	
	var gridData = $("#zoneGrid").jqGrid('getRowData');
	
	// GROUP을 'A'로 일괄 셋업, UPDATE 대상으로 설정
	for (var i = 1; i < gridData.length + 1; i++) {
		var item = $('#zoneGrid').jqGrid('getRowData', i);
		
		if( item.oper != 'I' ){
			item.area_group = 'A';			
			item.oper = 'U';
			$('#zoneGrid').jqGrid("setRowData", i, item);
			$('#zoneGrid').jqGrid('setCell', i, 'area_group', '', { 'background' : '#6DFF6D' } );
		}		
	}	
} 


</script>
</body>
</html>