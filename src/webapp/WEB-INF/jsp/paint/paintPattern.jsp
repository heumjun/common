<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Pattern</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<style>
 .ui-jqgrid .ui-jqgrid-htable th div {
    height:30px;
} 
</style>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<div class= "subtitle">
Paint Pattern
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
			<col width="100">
			<col width="110">
			<col width="100">
			<col width="">
			<col width="" style="min-width:400px;">

			<tr>
				<th>PROJECT NO</th>
				<td>
				<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
				<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
				<input type="button" id="btnProjNo" value="검색" class="btn_gray2">
				</td>

				<th>PATTERN CODE</th>
				<td>
				<input type="text" id="txtPatternCode" name="pattern_code" style="width:80px;"/>
				</td>

				<th>SEASON CODE</th>
				<td>
				<select style="width: 80px;" name="season_code" id="listSeason"></select> 
				</td>

			<td style="border-right:none;">
		 		<input type="checkbox" id="chkAll" name="chkAll" value="Y" />	전체일괄
			</td>	
			
			<td style="border-left:none;" colspan="2">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" id="btnSearch"			value="조회"			class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute2 == 'Y'}">
			<input type="button" id="btnNew"			value="신규"			class="btn_gray" disabled />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">
			<input type="button" id="btnMod"			value="수정"			class="btn_gray" disabled />
			</c:if>
			<c:if test="${userRole.attribute3 == 'Y'}">
			<input type="button" id="btnDelete"			value="삭제"			class="btn_gray" disabled />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">
			<input type="button" id="btnConfirm"		value="확정"			class="btn_gray" disabled />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">
			<input type="button" id="btnUndefined"		value="확정해제"		class="btn_gray" disabled />
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" id="btnExcelExport"	value="Excel출력"	class="btn_blue" />
			</c:if>
			
			
			
			
			
			
			</div>
			</td>

			</tr>
	</table>
		
	
	
	
	
	
	<!--
	<div class = "topMain" style="line-height:45px">
		
		<div class = "conSearch">
			<span class = "spanMargin">
				PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
							<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:30px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" />
							<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">
			Pattern Code
			<input type="text" id="txtPatternCode" name="pattern_code" style="width:80px;"/>
			</span>
		</div>
		
		<div class = "conSearch" >
			<span class = "spanMargin"> 
				Season Code
				<select style="width: 80px;" name="season_code" id="listSeason"></select> 
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">		
		 		<input type="checkbox" id="chkAll" name="chkAll" style="vertical-align: -2px;" value="Y">
		 		전체 일괄
			</span>	
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" 	  id="btnSearch"  			 	/>
			<input type="button" value="신 규" 	  disabled id="btnNew"       	/>
			<input type="button" value="삭 제" 	  disabled id="btnDelete"      	/>
			<input type="button" value="수 정" 	  disabled id="btnMod"  	 	/>
			<input type="button" value="확  정"      disabled id="btnConfirm"   	/>
			<input type="button" value="확정해제"    disabled id="btnUndefined"  	/>
			<input type="button" value="Excel출력"  id="btnExcelExport"  />		
		</div>
	</div>
	-->
	<div class="content">
		<table id = "patternGrid"></table>
		<div   id = "p_patternGrid"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

var change_pattern_row 	  	= 0;
var change_pattern_row_num 	= 0;
var change_pattern_col  	= 0;

var tableId	   			 = "#patternGrid";
var deleteData 			 = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

var isLastRev			 = "N";
var isExistProjNo		 = "N";					
var sState				 = "";	

var preProject_no;
var preRevision;

var prevCellVal1 = { cellId: undefined, value: undefined };
var prevCellVal2 = { cellId: undefined, value: undefined };
var cnt = 1;

$(document).ready(function(){
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(2);
	
	// Cell - Merge
	rowspaner = function (rowId, val, rawObject, cm, rdata) {
               	var result; 			
            
                if (prevCellVal1.value == rawObject.pattern_code) {
                    result = ' style="display: none" rowspanid="' + prevCellVal1.cellId + '"';
                }
                else {
                    var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                    result = ' rowspan="1" id="' + cellId + '"';
                    prevCellVal1 = { cellId: cellId, value: rawObject.pattern_code };
                }

                return result;
    };
    
    rowspaner2 = function (rowId, val, rawObject, cm, rdata) {
                var result;
				
                if (prevCellVal2.value == val) {
                    result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
                }
                else {
                    var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                    result = ' rowspan="1" id="' + cellId + '"';
                    prevCellVal2 = { cellId: cellId, value: val };
                }

                return result;
    };
	
	$("#patternGrid").jqGrid({ 
             datatype	: 'json', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', 'Pattern<br>Code', 'Area Code','Area Desc','회차','Paint Code','Paint Desc','Season','DFT','SVR','Stage','Pre','Post','','','','',''],
                colModel:[
                	{name:'chk', index:'chk', width:12,align:'center', sortable:false, formatter: formatOpt1, cellattr: rowspaner},
                	{name:'pattern_code',index:'pattern_code',  width:20, sortable:false, editrules:{required:true}, cellattr: rowspaner2, align:'center'},
                	{name:'area_code',	 index:'area_code', 	width:30, sortable:false, editrules:{required:true}},
                	{name:'area_desc',	 index:'area_desc', 	width:100, sortable:false, editrules:{required:true}},
                	{name:'paint_count', index:'paint_count', 	width:20, sortable:false, editrules:{required:true}, align:'center'},
                	{name:'paint_item',	 index:'paint_item', 	width:60, sortable:false, editrules:{required:true}},
                	{name:'item_desc',	 index:'item_desc', 	width:150, sortable:false, editrules:{required:true}},
                	{name:'season_code', index:'season_code', 	width:20, sortable:false, editrules:{required:true}, align:'center'},
                	{name:'paint_dft',	 index:'paint_dft', 	width:20, sortable:false, editrules:{required:true}, align:'right'},
                	{name:'stxsvr',	 	 index:'stxsvr', 		width:20, sortable:false, editrules:{required:true}, align:'right'},
                	{name:'paint_stage', index:'paint_stage', 	width:20, sortable:false, editrules:{required:true}, align:'left'},
                	{name:'pre_loss',	 index:'pre_loss', 		width:20, sortable:false, editrules:{required:true}, align:'right'},
                	{name:'post_loss',	 index:'post_loss', 	width:20, sortable:false, editrules:{required:true}, align:'right'},
                	
                    {name:'pattern_rowid',index:'pattern_rowid', width:25, hidden:true},                   
                    {name:'define_flag',index:'define_flag', width:25, hidden:true},
                    {name:'project_no',index:'project_no', width:25, hidden:true},
                    {name:'revision',index:'revision', width:25, hidden:true},
                    {name:'oper',index:'oper', width:25, hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_patternGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changePatternEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "pattern_code" || name == "block_code" || name == "pre_pattern_code") setUpperCase("#patternGrid",rowid,name);	
	         },
	         onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
				
				fn_initPrevCellVal();
				
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
	         loadComplete : function (data) {
			  	
			  	$("#chkHeader").prop("checked", false);	
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
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_pattern_row 	=	rowid;
             	change_pattern_row_num =	iRow;
             	change_pattern_col 	=	iCol;
   			 },
			 gridComplete : function () {
		 		
		 		var rows = $("#patternGrid").getDataIDs(); 
		 		var pre_pattern_code;
		 		var pattern_code;
		 		var changeFlag = true;
			    for (var i = 0; i < rows.length; i++) {
			    	pattern_code = $("#patternGrid").getCell(rows[i],"pattern_code");
			    	if(pattern_code != pre_pattern_code) {
			    		if(changeFlag) {
			    			changeFlag = false;
			    		} else {
			    			changeFlag = true;
			    		}
			    		pre_pattern_code = $("#patternGrid").getCell(rows[i],"pattern_code");
			    	} 
			    	
			    	if(changeFlag) {
			    		$("#patternGrid").jqGrid('setRowData',rows[i], false, {  background:'#eeeeee'});			    		
			    	}
			    	
			    	var define_flag = $("#patternGrid").getCell(rows[i],"define_flag");
			    	if ( define_flag == "Y" ) {
			    		$("#patternGrid").jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#cfefcf'});
			    	}
			    
			    }
		 				 		
			    var grid = this;
		        $('td[rowspan="1"]', grid).each(function () {
		            var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;

		            if (spans > 1) {
		                $(this).attr('rowspan', spans);
		            }
		        });
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
	
	//grid resize
	fn_gridresize($(window),$("#patternGrid"),5);

	$("#patternGrid").jqGrid('navGrid',"#p_patternGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	$("#patternGrid").navButtonAdd("#p_patternGrid",
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
		
	// 엑셀 import
	$("#btnExcelImport").click(function() {
		if (fn_ProjectNoCheck(true)) {
			fn_excelUpload();	
		}
	});
	
	// 엑셀 export
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	
	// 신규 버튼	
	$("#btnNew").click(function() {
		fn_new();
	});
	
	// 삭제 버튼
	$("#btnDelete").click(function() {
		fn_delete();
	});
	
	// 수정 버튼
	$("#btnMod").click(function() {
		fn_modify();
	});
	
	// 프로젝트 조회
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	// 확정 버튼
	$("#btnConfirm").click(function() {
		fn_patternCofirm();
	});
	
	// 확정해제 버튼 
	$("#btnUndefined").click(function() {
		fn_patternUndefined();
	});
		
	//Season List 가져오기
	var target  = $("#listSeason");
	var sUrl 	= "searchPaintSeasonCodeList.do?listCode=seasonCode";
	getAjaxHtmlPost(target,sUrl,$("#listForm").serialize(),null,null,fn_callBack); 
	
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow(){
	
	fn_applyData("#patternGrid",change_pattern_row_num,change_pattern_col);
		
	//가져온 배열중에서 필요한 배열만 골라내기 
	if (fn_ProjectNoCheck(true)) {
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		
		for(var i=0;i<selarrrow.length-1;i++){
			var selrow = selarrrow[i];	
			var item   = $('#patternGrid').jqGrid('getRowData',selrow);
			
			if(item.oper != 'I') {
				item.oper = 'D';
				deleteData.push(item);
			}
			
			$('#patternGrid').jqGrid('delRowData', selrow);
		}
	}
	
	$('#patternGrid').resetSelection();
}

// Add 버튼 
function addRow(item) {

	fn_applyData("#patternGrid",change_pattern_row_num,change_pattern_col);
	
	if (fn_ProjectNoCheck(true)) {
		var item = {};
		var colModel = $('#patternGrid').jqGrid('getGridParam', 'colModel');
		for(var i in colModel) item[colModel[i].name] = '';
		item.oper 	    = 'I';
		item.revision   = $('input[name=revision]').val();
		item.project_no = $('input[name=project_no]').val();
		item.pe_desc = $('input[name=project_no]').val()+"_";
		
		$('#patternGrid').resetSelection();
		$('#patternGrid').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
	}
	
	tableId = '#patternGrid';	
}

// afterSaveCell oper 값 지정s
function changePatternEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#patternGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I')
		item.oper = 'U';

	// apply the data which was entered.
	$('#patternGrid').jqGrid("setRowData", irowId, item);
	
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

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Paint Pattern 수정 url 리턴하는 함수
function getPatternEditUrl(sPatternCode,sConfirmYn) {
	//$("input[name=pattern_code]").val("sPatternCode");
	var sUrl  = "paintPatternEdit.do?gbn=paintPatternEdit";
	    sUrl += "&project_no="+ $("input[name=project_no]").val();
		sUrl += "&revision="+ $("input[name=revision]").val();
		sUrl += "&pattern_code="+sPatternCode;
		sUrl += "&is_confirm="+(sConfirmYn == "Y" ? "Y" : "N");
		sUrl += "&menu_id=${menu_id}";
		
	return sUrl;
}

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "pattern_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		setTimeout('$("input[name=project_no]").focus()',200);
		alert("Project No is required");
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		setTimeout('$("input[name=revision]").focus()',200);
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

// 그리드의 선택된 데이터 Validation체크하는 함수
function fn_confrimDataCheck(arr1, sGbn) {
	
	var result   = true;
	var message  = "";
	
	if (arr1.length == 0) {
		if (sGbn != "D" && $("#chkAll").is(":checked")) result  = true;
		else result  = false;
		message = "Data is not checked.";	
	}
	
	for(var i=0; i < arr1.length; i++) {
		
		if (sGbn == "D") {
			
			if ( arr1[i].define_flag == "Y" ) {
				result  = false;
				message = "Check has been confirmed data.";	
				
				break;
			}
				
		}/*else {
			
			if ( $.jgrid.isEmpty(arr1[i].define_flag) ) {
				result  = false;
				message = "Check has been uncommitted data.";
					
				break;
			}
		}*/	
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드에 변경된 데이터Validation체크하는 함수	
function fn_checkPatternValidate(arr1) {
	var result   = true;
	var message  = "";
	var $grid	 = $("#patternGrid");
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
		
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
		
		for(var i=0; i < ids.length; i++) {
		
			var iRow = $grid.jqGrid('getRowData', ids[i]);
									
			for (var j = i+1; j <ids.length; j++) {
				
				var jRow = $grid.jqGrid('getRowData', ids[j]);
				
				if (iRow.block_code == jRow.block_code) {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW, "+$grid.jqGrid('getInd',ids[j])+"ROW는 Area Code가 중복됩니다.";	
					break;	
				}
			}
			
			if (result == false) break;
		}
	}	
		
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $grid.jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $grid.jqGrid('getCell', ids[i], 'pe_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Pattern Code Field is required";
					
					setErrorFocus("#patternGrid",ids[i],4,'pe_code');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'block_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Block Code Field is required";
					
					setErrorFocus("#patternGrid",ids[i],6,'block_code');
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

// 그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	


// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.resizeTo(720, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 그리드에  checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem "+rowObject.pattern_code+"' value="+rowid+" onclick='chkClick(this,\""+rowObject.pattern_code+"\")'/>";
}

// 선택한 Check Box의 Pattern Code 동일한 Check Box 전부 선택하는 함수
function chkClick(obj,sPattern) {
	
	if (obj.checked) {
		$("."+sPattern).prop("checked", true);
		//$("input[value*="+sPattern).prop("checked", true);
	} else {
		$("."+sPattern).prop("checked", false);
		//$("input[value*="+sPattern).prop("checked", false);
	}
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
		$( "#btnNew" ).removeAttr( "disabled" );
		$( "#btnNew" ).removeClass("btn_gray");
		$( "#btnNew" ).addClass("btn_blue");
		
		$( "#btnDelete").removeAttr( "disabled" );
		$( "#btnDelete" ).removeClass("btn_gray");
		$( "#btnDelete" ).addClass("btn_blue");
		
		$( "#btnMod").removeAttr( "disabled" );
		$( "#btnMod" ).removeClass("btn_gray");
		$( "#btnMod" ).addClass("btn_blue");
		
		$( "#btnConfirm" ).removeAttr( "disabled" );
		$( "#btnConfirm" ).removeClass("btn_gray");
		$( "#btnConfirm" ).addClass("btn_blue");
		
		$( "#btnUndefined").removeAttr( "disabled" );
		$( "#btnUndefined" ).removeClass("btn_gray");
		$( "#btnUndefined" ).addClass("btn_blue");
		
		//$( "#btnExcelExport").removeAttr( "disabled" );
		} else {
		$( "#btnNew" ).attr( "disabled", true );
		$( "#btnNew" ).removeClass( "btn_blue" );
		$( "#btnNew" ).addClass( "btn_gray" );
		
		$( "#btnDelete" ).attr( "disabled", true );
		$( "#btnDelete" ).removeClass( "btn_blue" );
		$( "#btnDelete" ).addClass( "btn_gray" );
		
		$( "#btnMod").attr( "disabled", true );
		$( "#btnMod" ).removeClass( "btn_blue" );
		$( "#btnMod" ).addClass( "btn_gray" );
		
		$( "#btnConfirm" ).attr( "disabled", true );
		$( "#btnConfirm" ).removeClass( "btn_blue" );
		$( "#btnConfirm" ).addClass( "btn_gray" );
		
		$( "#btnUndefined" ).attr( "disabled", true );
		$( "#btnUndefined" ).removeClass( "btn_blue" );
		$( "#btnUndefined" ).addClass( "btn_gray" );
		//$( "#btnExcelExport" ).attr( "disabled", true );
	}
}

// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		alert("Project No is required");
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
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

// Cell - Merge변수 초기화
function fn_initPrevCellVal() {	
	prevCellVal1 = { cellId: undefined, value: undefined };
 	prevCellVal2 = { cellId: undefined, value: undefined };
}

// Season코드 조회한 다름 호출하는 call_back함수
function fn_callBack(data) {
	
	$("select[name=season_code]").val('0');	
		
	fn_searchLastRevision();
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Paint Pattern 신규등록 화면 호출
function fn_new() {
	
	if (win != null){
   		win.close();
   	}
	
	if (fn_ProjectNoCheck(false)) {	
		win = window.open(getPatternEditUrl("",""),"listForm","height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");
	}	
}

// Paint Pattern 수정 화면 호출
function fn_modify() {

	var rowId 	= jQuery("#patternGrid").jqGrid('getGridParam','selrow');  
	
	if (rowId == null) {
		alert("Pattern Code를 선택 바랍니다.");
		return;
	}
	
	var rowData = jQuery("#patternGrid").getRowData(rowId);
	if (win != null){
   		win.close();
   	}
   	
   	if (fn_ProjectNoCheck(false)) {	
		win = window.open(getPatternEditUrl(rowData.pattern_code,rowData.define_flag),"listForm","height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");
	}	
}

// 선택한 Paint Pattern 삭제 한다.
function fn_delete() {
	
	if (confirm('삭제 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "", deletePattenData = [];
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	for(var i=0;i<selarrrow.length-1;i++){		
		deletePattenData.push($('#patternGrid').jqGrid('getRowData',selarrrow[i]));	
	}
	
	if (!fn_confrimDataCheck(deletePattenData, "D")) {
		lodingBox.remove();
		return;
	}

	var url			= "deletePatternList.do";
	var dataList    = {patternCodeList:JSON.stringify(deletePattenData)};
	
	$.post(url, dataList, function(data) {

			alert(data.resultMsg);
			
			if (data.result == "success") { 		 	
			 	fn_search();
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
	});
}

// 그리의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#patternGrid",change_pattern_row_num,change_pattern_col);
	
	var changePatternResultRows =  getChangedGridInfo("#patternGrid");;
	
	if (!fn_checkPatternValidate(changePatternResultRows)) { 
		return;	
	}
	
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#patternGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#patternGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintPattern.do";
	var dataList    = {peList:JSON.stringify(changePatternResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
		
		lodingBox.remove();
		alert(data.resultMsg);
		
		if (data.result == "success") { 		 	
		 	fn_search();
		}
		
	}).fail(function(){
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
    	lodingBox.remove();	
});	
}

// 그리드의 선택한 Paint Pattern 확정한다.
function fn_patternCofirm() {
	
	if (confirm('확정 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "", confirmData = [];
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){		
		confirmData.push($('#patternGrid').jqGrid('getRowData',selarrrow[i]));	
	}
	
	if (!fn_confrimDataCheck(confirmData, "C")) {
		lodingBox.remove();
		return;
	}
		
	var url			= "savePatternConfirm.do";
	var dataList    = {patternCodeList:JSON.stringify(confirmData)};
	var formData 	= getFormData('#listForm');
	
	var parameters  = $.extend({},dataList,formData);
		
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
		
	
}

// 그리드의 선택한 Paint Pattern 확정해제한다.
function fn_patternUndefined() {
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "", undefinedData = [];
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){		
		undefinedData.push($('#patternGrid').jqGrid('getRowData',selarrrow[i]));	
	}
	
	if (!fn_confrimDataCheck(undefinedData, "")) {
		lodingBox.remove();
		return;
	}
	
	if (confirm('확정해제 하시겠습니까?') !=0 ) {
		
		var url			= "savePatternUndefine.do";
		var dataList    = {patternCodeList:JSON.stringify(undefinedData)};
		var formData 	= getFormData('#listForm');
	
		var parameters = $.extend({},dataList,formData);
		
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
		
	} else {
		lodingBox.remove();
	}	
}

// 프로젝트의 Paint Pattern 조회
function fn_search() {
	
	fn_initPrevCellVal();	
				
	var sUrl = "paintPatternList.do";
	$("#patternGrid").jqGrid('setGridParam',{url			: sUrl
		                                   ,mtype    : 'POST' 
										   ,page		: 1
										   ,datatype	: 'json'
										   ,postData 	: getFormData("#listForm")}).trigger("reloadGrid");
} 

// 프로젝트 최종 리비젼 조회하는 함수
function fn_searchLastRevision() {
	
	var url		   = "paintPlanProjectNoCheck.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()};
						
	$.post(url, parameters, function(data) {		
		if(data !=null && data != ""){
			isExistProjNo  = "Y";
	  		if(data.state != null && data.state != 'undefined') sState = data.state;
	  		else sState = "";
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
	  		$("#patternGrid").clearGridData(true);
	  		deleteArrayClear();
	  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	  	
	  	fn_setButtionEnable();
	});  	

}

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "./patternExcelUpload.do?gbn=paintPatternExcelUpload";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();	
			   									
	win = window.open(sUrl,"listForm","height=260,width=680,top=200,left=200");
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	
	var sUrl  = "./patternExcelExport.do?";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();	
		sUrl += "&pattern_code="+$("input[name=pattern_code]").val();
		sUrl += "&season_code="+$("select[name=season_code]").val();	
	
	location.href=sUrl;
}

// Paint Area 조회하는 화면 호출
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#patternGrid",change_pattern_row_num,change_pattern_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.area_code};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupBlockCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
		$(tableId).setCell(searchIndex,'loss_code',rs[2]);
	}
}

// 프로젝트번호 조회하는 화면 호출
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()};
			   //,revision   : $("input[name=revision]").val()};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do?",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
	}
	
	fn_searchLastRevision();
}

</script>
</body>
</html>