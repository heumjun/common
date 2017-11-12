<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Block</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv" class="mainDiv">
<form name="listForm" id="listForm"  method="get">
<div class= "subtitle">
Paint Block
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>

<input type="hidden"  name="pageYn" 	value="N"/>
<input type="hidden"  name="projectNo"  value=<%=session.getAttribute("paint_project_no")%>  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

	
	
	<table class="searchArea conSearch">
			<col width="110">
			<col width="210">
			<col width="110">
			<col width="210">
			<col width="110">
			<col width="100">
			<col width="" style="min-width:260px;">

			<tr>
				<th>PROJECT NO</th>
				<td>
					<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
					<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
					<input type="button" id="btnProjNo"  value="검색" class="btn_gray2">
				</td>

				<th>BLOCK CODE</th>
				<td>
				<input type="text" id="txtBlockCodeFrom" name="blockCodeForm" style="width:80px;"/>
				&nbsp;-&nbsp;
				<input type="text" id="txtBlockCodeTo" name="blockCodeTo" style="width:80px;"/>
				</td>

				<th>AREA CODE</th>
				<td>
				<input type="text" id="txtAreaCode" name="areaCode" style="width:80px;"/>
				</td>


				
			<td style="border-left:none;" colspan="2">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회" id="btnSearch"  class="btn_blue"/>
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">		
			<input type="button" value="저장" disabled id="btnSave"   class="btn_gray"/>
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" value="Excel출력" 		   id="btnExcelExport"   class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute6 == 'Y'}">
			<input type="button" value="Excel등록" disabled id="btnExcelImport" class="btn_gray" />
			</c:if>
			
			
			</div>
			</td>

			</tr>
	</table>
	
	
	<!--<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
				PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
							<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
							<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
			</span>
		</div>
		<div class = "conSearch">
			<span class = "spanMargin">
			Block Code
			<input type="text" id="txtBlockCodeFrom" name="blockCodeForm" style="width:80px;"/>
			&nbsp;~&nbsp;
			<input type="text" id="txtBlockCodeTo" name="blockCodeTo" style="width:80px;"/>
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">
			Area Code
			<input type="text" id="txtAreaCode" name="areaCode" style="width:80px;"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" id="btnSearch"  />
			<input type="button" value="저  장" disabled id="btnSave"  />
			<input type="button" value="Excel등록" disabled id="btnExcelImport"  />
			<input type="button" value="Excel출력" 		   id="btnExcelExport"  />		
		</div>
	</div>
	-->
	<div class="content">
		<table id = "blockGrid"></table>
		<div   id = "p_blockGrid"></div>
	</div>	
</div>	
</form>


<script type="text/javascript">

var change_block_row 	 = 0;
var change_block_row_num = 0;
var change_block_col  	 = 0;

var tableId	   			 = "#blockGrid";
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
	var objectHeight = gridObjectHeight(1)-22;
	
	fn_searchLastRevision();
	
	$("#blockGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', 'Project No','Rev', 'Block Desc', 'Block Code','Area Code','Area Name','Area','Loss Code',''],
                colModel:[
                	{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
                	{name:'project_no',index:'project_no', width:50,align:"center", title: false },
                    {name:'revision', index:'revision', width:20,align:"right"},
                	{name:'block_desc',index:'block_desc', width:120},
                    {name:'block_code',index:'block_code', width:50, editable:true,editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'area_code',index:'area_code', width:60, editable:true,editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'area_desc',index:'area_desc', width:120},
                    {name:'area',index:'area', width:100, editable:true,editrules:{number:true},align:"right"},
                    {name:'loss_code',index:'loss_code', width:50, align:"center"},
                    //{name:'post_loss',index:'post_loss', width:100, editable:true,editrules:{number:true},align:"right"},
                    
                    {name:'oper',index:'oper', width:25, hidden:true}
                ],
             cmTemplate: { title: false },
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_blockGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         footerrow  : true,
	         userDataOnFooter:true,
	         
	         beforeSaveCell : changeBlockEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "block_code" || name == "area_code") setUpperCase("#blockGrid",rowid,name);
            	fn_jqGridChangedCell('#blockGrid', rowid, 'chk', {background:'pink'});
            	
            	var item = $('#blockGrid').jqGrid('getRowData', rowid);
            	if( item.oper == "I" ) {
            		if ( name == "area_code" ) {
            			var args = {p_code_find : item.area_code};
            			var rs = window.showModalDialog("popUpAreaCode.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
            			if (rs != null) {
            				item.area_code = rs[0];
            				item.area_desc = rs[1];
            				item.loss_code = rs[2];
                		}else {
                			item.area_code = '';
            				item.area_desc = '';
            				item.loss_code = '';
                		}
            			// apply the data which was entered.
                    	$('#blockGrid').jqGrid("setRowData", rowid, item);
            		}
            	}

            	
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
        		
        		$('table.ui-jqgrid-ftable tr:first').children("td").css("background-color",'#dfeffc');
        		//$('table.ui-jqgrid-ftable td:eq(0)').hide();
        		
        		$('table.ui-jqgrid-ftable tr:first td:eq(7)').css("text-align", "center");
        		
        		//$('table.ui-jqgrid-ftable td:eq(9)').hide();
        		
        		var grid = jQuery('#blockGrid');
		        grid.jqGrid('footerData','set',{
		            area_desc: 'Total',
		            area: parseFloat(grid.jqGrid('getCol','area',false,'sum')).toFixed(2)
		        });
		        
		        var rows = $( "#blockGrid" ).getDataIDs();

		        var changeFlag = true;
				var pre_block_code;
			 	var block_code;
			 	 
				for ( var i = 0; i < rows.length; i++ ) {
					//수정 및 결재 가능한 리스트 색상 변경
					var oper = $( "#blockGrid" ).getCell( rows[i], "oper" );
					block_code = $("#blockGrid").getCell(rows[i],"block_code");
					if(block_code != pre_block_code) {
			    		if(changeFlag) {
			    			changeFlag = false;
			    		} else {
			    			changeFlag = true;
			    		}
			    		pre_block_code = $("#blockGrid").getCell(rows[i],"block_code");
			    	} 
					if(changeFlag) {
						$("#blockGrid").jqGrid('setRowData',rows[i], false, {  background:'#eeeeee'});
						if(oper != "D"){
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#DADADA' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'block_desc', '', { color : 'black', background : '#DADADA' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'loss_code', '', { color : 'black', background : '#DADADA' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_desc', '', { color : 'black', background : '#DADADA' } );
							if (oper == "I"){
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { cursor : 'pointer', background : 'pink' } );
							} else {
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { color : 'black', background : '#DADADA' } );
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'block_code', '', { color : 'black', background : '#DADADA' } );
								$("#blockGrid").jqGrid('setCell', rows[i], 'area_code', '', 'not-editable-cell');
								$("#blockGrid").jqGrid('setCell', rows[i], 'block_code', '', 'not-editable-cell');
							}
						}
					} else {
						$("#blockGrids").jqGrid('setRowData',rows[i], false, {  background:'white'})
						if(oper != "D"){
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#eeeeee' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { color : 'black', background : '#eeeeee' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'block_desc', '', { color : 'black', background : '#eeeeee' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'loss_code', '', { color : 'black', background : '#eeeeee' } );
							$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_desc', '', { color : 'black', background : '#eeeeee' } );
							if (oper == "I"){
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { cursor : 'pointer', background : 'pink' } );
							} else {
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { color : 'black', background : '#eeeeee' } );
								$( "#blockGrid" ).jqGrid( 'setCell', rows[i], 'block_code', '', { color : 'black', background : '#eeeeee' } );
								$("#blockGrid").jqGrid('setCell', rows[i], 'area_code', '', 'not-editable-cell');
								$("#blockGrid").jqGrid('setCell', rows[i], 'block_code', '', 'not-editable-cell');
							}
						}
					}
				}
		    },
			 
			 	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_block_row 	=	rowid;
             	change_block_row_num =	iRow;
             	change_block_col 	=	iCol;
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
            	 
            	 	/* var ret = $( "#blockGrid" ).getRowData( row_id );
					var oper = ret.oper;
					if( oper == "I" ) {
						var cm = $( "#blockGrid" ).jqGrid( "getGridParam", "colModel" );
						var colName = cm[colId];
						var item = $("#blockGrid").jqGrid( "getRowData", row_id );
						if ( colName['index'] == "area_code" ) {
							var args = {p_code_find : item.area_code};
							var rs = window.showModalDialog("popUpAreaCode.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
							if (rs != null) {
								item.area_code = rs[0];
								item.area_desc = rs[1];
								item.loss_code = rs[2];
								if(item.oper != "I"){
									item.oper = "U"
								}
								$('#blockGrid').jqGrid("setRowData", row_id, item);
		            		}
						}
					} */
             	/* if(row_id != null) 
                {
                	var ret 	= jQuery("#blockGrid").getRowData(row_id);
                	
                	if (ret.oper != "I") {
	                	switch(colId) {
	                		case 5:
	                			jQuery("#blockGrid").jqGrid('setCell', row_id, 'block_code', '', 'not-editable-cell');	
	                		case 6:
	                			jQuery("#blockGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');
	                		default :
	                			break;
	                	}
                	}
                }  */
             }
     }); 
	
	//grid resize
	fn_gridresize($(window),$("#blockGrid"),23);
	
	//그리드 버튼 설정
	$("#blockGrid").jqGrid('navGrid',"#p_blockGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	$("#blockGrid").navButtonAdd("#p_blockGrid",
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
	$("#blockGrid").navButtonAdd('#p_blockGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">
 	$("#blockGrid").navButtonAdd('#p_blockGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
	
	/* //AF CODE
	$.post( "selectPaintCode.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
		var data2 = $.parseJSON( data );
		
		$( '#blockGrid' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data2 } );
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
	
	//엑셀import버튼
	$("#btnExcelImport").click(function() {
		if (fn_ProjectNoCheck(true)) {
			fn_excelUpload();	
		}
	});
	
	//엑셀export 버튼
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	
	//프로젝트 조회 버튼	
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//Del 버튼
function deleteRow(){
	
	fn_applyData("#blockGrid",change_block_row_num,change_block_col);
		
	//가져온 배열중에서 필요한 배열만 골라내기 
	if (fn_ProjectNoCheck(true)) {
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		
		for(var i=0;i<selarrrow.length-1;i++){
			var selrow = selarrrow[i];	
			var item   = $('#blockGrid').jqGrid('getRowData',selrow);
			
			if(item.oper == '') {
				item.oper = 'D';
				$('#blockGrid').jqGrid("setRowData", selrow, item);
				var colModel = $( '#blockGrid' ).jqGrid( 'getGridParam', 'colModel' );
				
				for( var j in colModel ) {
					$( '#blockGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
				}
				//deleteData.push(item);
			} else if(item.oper == 'I') {
				$('#blockGrid').jqGrid('delRowData', selrow);	
			} else if(item.oper == 'U') {
				alert("수정된 내용은 삭제 할수 없습니다.");
			}
		}
	}
	
	$('#blockGrid').resetSelection();
}

//Add 버튼 
function addRow(item) {

	fn_applyData("#blockGrid",change_block_row_num,change_block_col);
	
	if (fn_ProjectNoCheck(true)) {
		var item = {};
		var colModel = $('#blockGrid').jqGrid('getGridParam', 'colModel');
		for(var i in colModel) item[colModel[i].name] = '';
		item.oper 	    = 'I';
		item.revision   = $('input[name=revision]').val();
		item.project_no = $('input[name=project_no]').val();
		item.block_desc = $('input[name=project_no]').val()+"_";
		
		var nRandId = $.jgrid.randId();
		$('#blockGrid').resetSelection();
		$('#blockGrid').jqGrid('addRowData', nRandId, item, 'first');
		
		fn_jqGridChangedCell('#blockGrid', nRandId, 'chk', {background:'pink'});
	}
	
	tableId = '#blockGrid';	
}

// 그리드의 cell이 변경된 경우 호출되는 함수
function changeBlockEditEnd(irowId, cellName, value, irow, iCol) {
		
	
	var item = $('#blockGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#blockGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
	
	// apply the data which was entered.
	$('#blockGrid').jqGrid("setRowData", irowId, item);
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
//그리드 cell편집시 대분자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "block_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

//프로젝트 필수여부, 최종revision, 상태 체크하는 함수
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

// 그리드에 변경된 데이터validation체크하는 함수
function fn_checkBlockValidate(arr1) {
	var result   = true;
	var message  = "";
	var $grid	 = $("#blockGrid");
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
		
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $grid.jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {			
				
				var val1 = $grid.jqGrid('getCell', ids[i], 'block_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Block Code Field is required";
					
					setErrorFocus("#blockGrid",ids[i],5,'block_code');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'area_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Area Code Field is required";
					
					setErrorFocus("#blockGrid",ids[i],6,'area_code');
					break;
				}
			}
		}
	}
	
	
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
		
		for(var i=0; i < ids.length; i++) {
			var oper = $grid.jqGrid('getCell', ids[i], 'oper');					
			if (oper == 'I') {
			
				var iRow = $grid.jqGrid('getRowData', ids[i]);
										
				for (var j = i+1; j <ids.length; j++) {
					
					var jRow = $grid.jqGrid('getRowData', ids[j]);
					
					if (iRow.block_code == jRow.block_code 
						&& iRow.area_code == jRow.area_code) 
					{
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW, "+$grid.jqGrid('getInd',ids[j])+"ROW는 Block의 Area Code가 중복됩니다.";	
						break;	
					}
				}
				
				if (result == false) break;
			}
		}
	}
	
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

//그리드의 변경중인 cell저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

//프로젝트 리비젼에 따라 버튼 enable설정하는 함수
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

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// 그리드의 변경된 row를 가져오는 함수
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

//팝업 화면 resize
function resizeWin() {
    win.moveTo(200,0);
    win.resizeTo(700, 780);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
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

// revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
}

// Text 입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
//그리드의 변경되 내용 저장 호출 함수
function fn_save() {
	
	fn_applyData("#blockGrid",change_block_row_num,change_block_col);
	
	var changeBlockResultRows =  getChangedGridInfo("#blockGrid");;
	
	if (!fn_checkBlockValidate(changeBlockResultRows)) { 
		return;	
	}
	
	// ERROR표시를 위한 ROWID 저장
	//var ids = $("#blockGrid").jqGrid('getDataIDs');
	//for(var  j = 0; j < ids.length; j++) {	
		//$('#blockGrid').setCell(ids[j],'operId',ids[j]);
	//}
	
	var url			= "savePaintBlock.do";
	var dataList    = {chmResultList:JSON.stringify(changeBlockResultRows)};
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

// paint block List조회하는 함수
function fn_search() {
				
	var sUrl = "searchPaintBlock.do";
	$("#blockGrid").jqGrid('setGridParam',{url		: sUrl
										  ,mtype		: 'POST'
										  ,page		: 1
										  ,datatype	: 'json'
										  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "popUpExcelUpload.do?gbn=blockExcelImport.do";
	sUrl += "&project_no="+$("input[name=project_no]").val();
	sUrl += "&revision="+$("input[name=revision]").val();	
			   									
	win = window.open(sUrl,"listForm","height=260,width=680,top=200,left=200");
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	var sUrl = "blockExcelExport.do?";
	sUrl += "&blockCodeForm="+$("input[name=blockCodeForm]").val();
	sUrl += "&blockCodeTo="+$("input[name=blockCodeTo]").val();	
	sUrl += "&project_no="+$("input[name=project_no]").val();
	sUrl += "&revision="+$("input[name=revision]").val();	
	
	location.href=sUrl;
}

//Paint Area 조회하는 화면 호출하는 함수
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#blockGrid",change_block_row_num,change_block_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.area_code};
		
	var rs = window.showModalDialog("popUpAreaCode.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
		$(tableId).setCell(searchIndex,'loss_code',rs[2]);
	}
}

// 프로젝트번호 조회하는 화면 호출
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()};
			 //  ,revision   : $("input[name=revision]").val()};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
	}
	
	fn_searchLastRevision();
}

// 프로젝트번호의 최종 REVSION상태 조회
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
	  		$("#blockGrid").clearGridData(true);
	  		deleteArrayClear();
	  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	  	
	  	fn_setButtionEnable();
	});  	

}

</script>
</body>
</html>