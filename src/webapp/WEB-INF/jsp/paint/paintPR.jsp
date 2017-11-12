<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Quantity</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm"  	 method="get">
	<div id="mainDiv" class="mainDiv">		
	
	<div class= "subtitle">
	Paint PR
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>

		<input type="hidden"  name="pageYn"  	 	  value="N"/>
		<input type="hidden"  name="block_code"  	  value=""/>
		<input type="hidden"  name="area_code" 	 	  value=""/>
		<input type="hidden"  name="group_code" 	  value="1"/>
		<input type="hidden"  name="in_ex_gbn" id="in_ex_gbn" />
		<input type="hidden"  id="chk_create_date"    name="chk_create_date"  value=""/>
		<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
		

			
			<table class="searchArea conSearch">
				<col width="110">
				<col width="210">
				<col width="*">
				<col width="*"  style="min-width:260px">
	
				<tr>
					<th>PROJECT NO</th>
					<td>
						<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
						<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
						<input type="hidden" id="p_project_no"  name="p_project_no"/>
						<input type="hidden" id="p_revision"  name="p_revision" />
						<input type="button" id="btnProjNo"  value="검색" class="btn_gray2">
					</td>
					<td style="border-right:none;" >
						<div id="divSeries"  style="border:none;"></div>
					</td>
					<td style="border-left:none;">
						<div class="button endbox">
						<c:if test="${userRole.attribute6 == 'Y'}">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" 	value="조회" 	    id="btnSearch"  class="btn_blue"		/>
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">	
						<input type="button" 	value="저장" 		id="btnSave"  	  	 disabled	class="btn_gray"/>
						</c:if>
						<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" 	value="Excel출력"   	id="btnExcelExport"  	class="btn_blue"/>
						</c:if>
						<input type="button" 	value="Excel등록"   	id="btnExcelImport"	 class="btn_blue"/>
						</c:if>
						</div>
					</td>
				</tr>
			</table>					
		
		
		
		<!--<div class = "topMain" style="line-height:45px">
			<div class = "conSearch">
				<span class = "spanMargin">
					PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:120px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
								<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" />
								<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
				</span>
			</div>
			
			<div class = "button">
				<input type="button" 	value="조  회" 	    id="btnSearch"  				/>
				<input type="button" 	value="저 장" 		id="btnSave"  	  	 disabled	/>
				<input type="button" 	value="Excel등록"   	id="btnExcelImport"	 disabled	/>
				<input type="button" 	value="Excel출력"   	id="btnExcelExport"  			/>	
			</div>
			
			
		</div>
		-->
		<div style="float:left; width: 70%;">
			<div style="width: 100%;" id="divGroup">
				<fieldset style="border:none;">
					<legend class="sc_tit mgt10 sc_tit2">PR Group List</legend>
					<div>
						<table id ="prGroupList" ></table>
						<div   id ="p_prGroupList"></div>
					</div>
				</fieldset>
			</div>
			
			<div style="margin-top:5px;width: 100%;" id="divItemGroup">
				<fieldset style="border:none;">
					<legend class="sc_tit sc_tit2">Edit Group</legend>
					<div style="height: 30px; margin-top:5px">
						<input type="button" id="btnFormDown"  value="FORM-DOWN" class="btn_blue"/>
						<input type="button" id="btnItemExcelImport"  value="UP-LOAD" disabled class="btn_gray" />
						<div style="float: right;">
							PR Desc
							<input type="text" id="texPrDesc" class="h20Input" name="pr_desc" style="background-color: #FFFFA2;text-transform: uppercase; width:300px;"/>	
							Date 
							<input type="text"   id="created_date" name="created_date" class="datepicker h20Input" style="width: 80px;"/>
							<c:if test="${userRole.attribute4 == 'Y'}">	
							<input type="button" id="btnCreatePR"  value="Create PR" disabled  class="btn_gray" />
							</c:if>
						</div>
						<div>
						</div>
					</div>
					<div style="margin-top:4px">
						<table id ="prGroupItemList" ></table>
						<div   id ="p_prGroupItemList"></div>
					</div>
				</fieldset>
			</div>
		</div>
		
		<div style="float:right; width: 29%;">
			
			<fieldset style="border:none;">
				<legend class="sc_tit mgt10 sc_tit2">Block & Stage Code list</legend>
				
					<div style="margin-top:5px">
						<select name="sel_condition" id="sel_condition">
							<option value="ALL" selected="selected">ALL</option>
							<option value="BLOCK">BLOCK</option>
							<option value="PE">PE</option>
							<option value="HULL">HULL</option>
							<option value="QUAY">QUAY</option>
							<option value="OUTFITTING">OUTFITING</option>
							<option value="COSMETIC">COSMETIC</option>
						</select>
						<input type="text"   id="txtCondition" name="txtCondition" class="h20Input" style="text-transform: uppercase; width: 100px;" />
						<input type="button" id="btnFilter"    value="필터"  class="btn_gray2"/>
						<div class="button endbox">
							<input type="button" id="btnBlockSave"  value="Block 저장" disabled class="btn_gray"/>
						</div>
					</div>
					
					<div id="divFromList" style="margin-top:5px;">
						<table	id="grdFromList"></table>
						<div	id="p_grdFromList"></div>
					</div>
					
					<div style="margin-top:5px; text-align: center;">					
						<input type="button" id="btnEntryAdd" value="▲" title="추가"  disabled class="btn_gray wid60" />
						&nbsp;&nbsp;
						<input type="button" id="btnEntryDel" value="▼" title="제외"  disabled class="btn_gray wid60" />
					</div>
					<div style="margin-top:5px;">
						<select name="sel_condition2" id="sel_condition2">
							<option value="ALL" selected="selected">ALL</option>
							<option value="BLOCK">BLOCK</option>
							<option value="PE">PE</option>
							<option value="HULL">HULL</option>
							<option value="QUAY">QUAY</option>
							<option value="OUTFITTING">OUTFITING</option>
							<option value="COSMETIC">COSMETIC</option>
						</select>
						<input type="text" 	 id="txtCondition2" name="txtCondition2" class="h20Input" style="text-transform: uppercase; width: 100px;" />
						<input type="button" id="btnFilter2"    value="필터"  class="btn_gray2" />
					</div>
					
					<div id="divToList" style="margin-top:5px;">
						<table	id="grdToList"></table>
						<div	id="p_grdToList"></div>
					</div>
						
				
			</fieldset>
			
		</div>
	</div>
		
</form>

</body>

<script type="text/javascript">
var selected_tab_name 	 = "#tabs-1";
var tableId	   			 = "#";
var deleteGroupData 	 = [];
var deleteGroupItemData  = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

var isLastRev			 = "N";
var isExistProjNo		 = "N";					
var sState				 = "";	

var preProject_no;
var preRevision;

var prgroup_row			 = -1;

var change_group_row 	 = 0;
var change_group_row_num = 0;
var change_group_col  	 = 0;

var change_groupitem_row 	 = 0;
var change_groupitem_row_num = 0;
var change_groupitem_col  	 = 0;

var create_date          = 0;

$(document).ready(function(){
	
	$("#prGroupList").jqGrid({ 
            datatype   : 'json', 
            mtype	   : '', 
            url		   : '',
            postData   : '',
            colNames   : ['Description','PR NO','',''],
            colModel   : [
		               	{name:'group_desc',		index:'group_desc',  width:400, 	align:'left',	sortable:false, editable:true, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
		               	{name:'pr_no',			index:'pr_no', 		 width:150, 	align:'right',	sortable:false},
		               	{name:'group_code',		index:'group_code',  hidden:true},
		               	{name:'oper',			index:'oper', 		 hidden:true},
		           	   ],
 
            gridview	 : true,
            cmTemplate: { title: false },
            toolbar	     : [false, "bottom"],
            viewrecords  : true,                	//하단 레코드 수 표시 유무
            
            pager		 : $('#p_prGroupList'),
            autoWidth	 : true,                     //사용자 화면 크기에 맞게 자동 조절
           
	        height		 : $(window).height()*0.4 - 165,      
	        rowNum		 : -1, 
	        rownumbers 	 : true,
	        pgbuttons 	 : false,
			pgtext 		 : false,
			pginput 	 : false,
			   
			cellEdit	 : true,             // grid edit mode 1
	        cellsubmit	 : 'clientArray',  	// grid edit mode 2
	             
	        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "group_desc") setUpperCase("#prGroupList",rowid,name);		
	        },
	        onPaging: function(pgButton) {
							
			},
			loadComplete: function (data) {
							 
			},
			gridComplete : function () {
				$("input[name=pr_desc]").val("");
				fn_buttonDisabled( [ "#btnEntryAdd", "#btnEntryDel" ] );
				fn_searchUnregisteredBlock();
			},	         
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_group_row 	=	rowid;
             	change_group_row_num =	iRow;
             	change_group_col 	=	iCol;   			
   			},
			onCellSelect: function(rowid, colId) {
				
				if(rowid != null) {
                	
                	var ret 	= $("#prGroupList").getRowData(rowid);
	    		      
	    		    if (colId == 1 && ret.oper != "I") $("#prGroupList").jqGrid('setCell', rowid, 'group_desc', '', 'not-editable-cell');            
	                
	                		                	
                	prgroup_row = rowid;
                	
                	$("input[name=group_code]").val(ret.group_code);
                	$("input[name=pr_desc]").val($("input[name=p_project_no]").val()+" "+ret.group_desc);
                	fn_buttonEnable( [ "#btnEntryAdd", "#btnEntryDel" ] );
                	fn_searchBlockStageCode();
                	
                	if(ret.group_code <= 2){
                		fn_buttonEnable( [ "#btnBlockSave"] );
                	} else {
                		fn_buttonDisabled( [ "#btnBlockSave"] );
                	}
                	if(ret.group_code >= 6){
                		fn_buttonEnable( [ "#btnItemExcelImport"] );
                	} else {
                		fn_buttonDisabled( [ "#btnItemExcelImport"] );
                	}
                	if(ret.group_code >= 3){
                		$("#grdToList").clearGridData(true);
                		$("#grdFromList").clearGridData(true);
                		$("#prGroupItemList").clearGridData(true);
                		
                	} else {
                		fn_searchUnregisteredBlock();	
                	}
                	if(ret.group_code == 1){
                		$("#in_ex_gbn").val("사내");	
                	} else if(ret.group_code == 2){
                		$("#in_ex_gbn").val("사외");	
                	} else {
                		$("#in_ex_gbn").val("");
                	}
                	if(ret.group_code >= 5){
                		fn_searchGroupItemList();
                	}
                } 
            },  	         
	        jsonReader : {
               root		: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
               page		: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
               total	: "total",                  // 총 페이지 수
               records 	: "records",
               repeatitems: false,
                },        
            imgpath: 'themes/basic/images'
            
    });
    
    // 그리드 버튼 설정
    $("#prGroupList").jqGrid('navGrid',"#p_prGroupList",{refresh:false,search:false,edit:false,add:false,del:false});
	
    <c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정		
	$("#prGroupList").navButtonAdd("#p_prGroupList",
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
	$("#prGroupList").navButtonAdd('#p_prGroupList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deletePRGroup,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">
	// 그리드 Row 추가 함수 설정
 	$("#prGroupList").navButtonAdd('#p_prGroupList',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addPRGroup,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
    	
	$("#prGroupItemList").jqGrid({ 
            datatype   : 'json', 
            mtype	   : '', 
            url		   : '',
            postData   : '',
            colNames   : ['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Paint Code','Paint Desc',
            			'Can Size', 'Data', 'Quantity', 'Can Base',''],
            colModel   : [
            			{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
		               	{name:'paint_item',	 index:'paint_item', 	width:100,  editable:true,  sortable:false, editoptions: {maxlength : 25, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                		{name:'item_desc',	 		index:'item_desc',  	 	width:220,      align:'left',   sortable:false, editrules:{required:true}},
		               	{name:'can_size',			index:'can_size', 		 	width:50, 		align:'right',	sortable:false},
		               	{name:'pr_date',			index:'pr_date', 		 	width:50, 		align:'right',	sortable:false, hidden:true},
		               	{name:'quantity',			index:'quantity', 		 	width:50, 		align:'right',	sortable:false, editable:true,  editrules:{number:true}},
		               	{name:'can_quantity',		index:'can_quantity', 		width:50, 		align:'right',	sortable:false},
		               	{name:'oper',				index:'oper', 		 		hidden:true},
		           	   ],
 
            gridview	 : true,
            cmTemplate: { title: false },
            toolbar	     : [false, "bottom"],
            viewrecords  : true,                	//하단 레코드 수 표시 유무
            
            pager		 : $('#p_prGroupItemList'),
            autowidth	 : true,                     //사용자 화면 크기에 맞게 자동 조절
            height		 : $(window).height()*0.6 -165, 
	        rowNum		 : -1, 
	        
	        pgbuttons 	 : false,
			pgtext 		 : false,
			pginput 	 : false,
			
			cellEdit	 : true,             // grid edit mode 1
	        cellsubmit	 : 'clientArray',  	// grid edit mode 2
	        
	        /* beforeSaveCell : changeGroupItemEditEnd, */ 
	        afterSaveCell  : function(rowid,name,val,iRow,iCol) {
	        	if (name == "quantity"){
	        		quantityCanBase(rowid);
	        	}
         		
         		if (name == "paint_item"){
                    searchItemCode('paint_item','item_desc','can_size',rowid);
             	}
         		
	        },
	        onPaging: function(pgButton) {
							
			},
			loadComplete: function (data) {
							 
			},
			gridComplete : function () {
				var rows = $("#prGroupItemList").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++) {	
			    	var oper = $( "#prGroupItemList" ).getCell( rows[i], "oper" );
			    	if( oper == 'I' ){
			    		$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'paint_item', '', { cursor : 'pointer', background : 'pink' } );
			    	}else{
						$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'paint_item','', {background : '#DADADA' } );
						$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'paint_item','', 'not-editable-cell' );
			    	}
					
					$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'item_desc','', {background : '#DADADA' } );
					$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'can_size','', {background : '#DADADA' } );
					$( "#prGroupItemList" ).jqGrid( 'setCell', rows[i], 'can_quantity','', {background : '#DADADA' } );
				}
			},	         
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_groupitem_row 	 =	rowid;
             	change_groupitem_row_num =	iRow;
             	change_groupitem_col 	 =	iCol;   		   			
   			},
			onCellSelect: function(rowid, colId) {

            },  	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
            jsonReader : {
               root		: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
               page		: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
               total	: "total",                  // 총 페이지 수
               records 	: "records",
               repeatitems: false,
                },        
            imgpath: 'themes/basic/images'
            
    });
    
    // 그리드 버튼 설정 
    $("#prGroupItemList").jqGrid('navGrid',"#p_prGroupItemList",{refresh:false,search:false,edit:false,add:false,del:false});
	
    <c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정	
	$("#prGroupItemList").navButtonAdd("#p_prGroupItemList",
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
	$("#prGroupItemList").navButtonAdd('#p_prGroupItemList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deletePRGroupItem,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">
	// 그리드 Row 추가 함수 설정
 	$("#prGroupItemList").navButtonAdd('#p_prGroupItemList',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addPRGroupItem,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
     
		 
	 $("#grdFromList").jqGrid( {
					datatype : 'json',
					mtype 	 : '',
					url 	 : '',
					editUrl  : 'clientArray',
					//cellSubmit: 'clientArray',
					colNames : ['구분','Stage Code','<input type="checkbox" id = "chkHeader2" onclick="checkBoxHeader2(event)" />','','',''],
					colModel : [
						
		            	{ name : 'gbn',    		index : 'gbn',  width : 25, editable : true, sortable : false, align : "center", editrules : { required : true }, editoptions : { size : 5 } },
		            	{ name : 'code',   		index : 'code', width : 40, editable : true, sortable : false, align : "center", editoptions : { size : 11 } },
		            	{ name : 'chk',    		index : 'chk',  width : 12, align:'center',  sortable : false, formatter: formatOpt2},
		            	{ name : 'team_count',  index : 'team_count', width : 25, hidden:true},
		            	{ name : 'auto_flag',  index : 'auto_flag', width : 25, hidden:true},
		            	{ name : 'oper',   		index : 'oper', 	  width : 25, hidden:true} ],
					
					gridview 	: true,
					cmTemplate: { title: false },
					toolbar 	: [ false, "bottom" ],
					viewrecords : true,
					
					autowidth 	: true,
					height		 : $(window).height()*0.7 -280, 
					pager 		: $('#p_grdFromList'),
					rowNum		: 1000,
					
					pgbuttons 	: false,
					pgtext 		: false,
					pginput 	: false,
									
					jsonReader : {
						root : "rows",
						page : "page",
						total : "total",
						records : "records",
						repeatitems : false,
					},
					imgpath 	 : 'themes/basic/images',
					gridComplete : function () {
						
						
						var rows = $("#grdFromList").getDataIDs(); 
					    for (var i = 0; i < rows.length; i++) {	
					    	var auto_flag = $( "#grdFromList" ).getCell( rows[i], "auto_flag" );
					    	if( auto_flag == 'Y' ){
					    		$( "#grdFromList" ).jqGrid( 'setCell', rows[i], 'gbn','', {background : '#DADADA' } );
					    		/* $( "#"+rows[i]+"_chkBoxOV2").attr( "disabled",true ); */
					    	}
						}
						
						
						/* var rowCnt = $("#grdFromList").getGridParam("reccount");
						
						if (rowCnt == 0) {
							$("#prGroupItemList").clearGridData(true);
						} else {
							fn_searchGroupItemList();	
						} */
					},
					onSelectRow : function( row_id ) {
						if ( row_id != null ) {
							//row_selected = row_id;
						}
					},
					onPaging: function(pgButton) {
												
						/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
						* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
						* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
						*/ 
						$(this).jqGrid("clearGridData");

						/* this is to make the grid to fetch data from server on page click*/
						$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y',filters:""}}).triggerHandler("reloadGrid");  
					},
					loadComplete: function (data) {
						fn_searchGroupItemList();
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
							} );
							this.updatepager(false, true);
						}
					}
				} 
		);
		 
		$("#grdToList").jqGrid( {
					datatype : 'json',
					mtype 	 : '',
					url 	 : '',
					editUrl  : 'clientArray',
					//cellSubmit: 'clientArray',
					colNames : ['구분','Stage Code','<input type="checkbox" id = "chkHeader3" onclick="checkBoxHeader3(event)" />','','',''],
					colModel : [
						
		            	{ name : 'gbn',    		index : 'gbn',  	  width : 25, editable : true, sortable : false, align : "center", editrules : { required : true }, editoptions : { size : 5 } },
		            	{ name : 'code',   		index : 'code', 	  width : 40, editable : true, sortable : false, align : "center", editoptions : { size : 11 } },
		            	{ name : 'chk',    		index : 'chk',  	  width : 12, align:'center',  sortable : false, formatter: formatOpt3},
		            	{ name : 'team_count',  index : 'team_count', width : 25, hidden:true},
		            	{ name : 'auto_flag',  index : 'auto_flag', width : 25, hidden:true},
		            	{ name : 'oper',   		index : 'oper', 	  width : 25, hidden:true} ],
					
					gridview 	: true,
					cmTemplate: { title: false },
					toolbar 	: [ false, "bottom" ],
					viewrecords : true,
					//multiselect : true,
					
					autowidth 	: true,
					height		 : $(window).height()*0.3-72, 
					//rowList		: [10,1000,5000],
					pager 		: $('#p_grdToList'),
					rowNum		: 1000,
					
					pgbuttons 	: false,
					pgtext 		: false,
					pginput 	: false,
										
					imgpath : 'themes/basic/images',
					ondblClickRow : function( rowId ) {
	
					},
					onSelectRow : function( row_id ) {
						if ( row_id != null ) {
							row_selected = row_id;
						}
					},
					onPaging: function(pgButton) {
												
						/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
						* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
						* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
						*/ 
						$(this).jqGrid("clearGridData");

						/* this is to make the grid to fetch data from server on page click*/
						$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y',filters:""}}).triggerHandler("reloadGrid");  
					},
					gridComplete : function () {
						
						
						var rows = $("#grdToList").getDataIDs(); 
					    for (var i = 0; i < rows.length; i++) {	
					    	var auto_flag = $( "#grdToList" ).getCell( rows[i], "auto_flag" );
					    	if( auto_flag == 'Y' ){
					    		$( "#grdToList" ).jqGrid( 'setCell', rows[i], 'gbn','', {background : '#DADADA' } );
					    		/* $( "#"+rows[i]+"_chkBoxOV2").attr( "disabled",true ); */
					    	}
						}
					},
					loadComplete: function (data) {
						
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
							} );
							this.updatepager(false, true);
						}
					}
				} 
	);
	
	// 오늘기준 +7일 설정
	fn_addDate( "created_date", "chk_create_date", "7" );
	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_save();
		}	
	});
		
	/* 
	 그리드 데이터 저장
	 */
	$("#btnCreatePR").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_createPR();
		}	
	});
		
	//조회 버튼
	$("#btnSearch").click(function() {
		
		if (fn_ProjectNoCheck(false)) {
			fn_search();
		}
	});
	
	//엑셀 import	버튼
	$("#btnExcelImport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_excelUpload();	
		}	
	});
	
	//엑셀 ITEM import	버튼
	$("#btnItemExcelImport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_excelItemUpload();	
		}	
	});
	
	//엑셀 ITEM DOWN	버튼
	$("#btnFormDown").click(function() {
		window.open("downloadFormFile.do?form_file_code=2","listForm","height=260,width=680,top=200,left=200");
	});
	
	//엑셀 export 버튼
	$("#btnExcelExport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_excelDownload();	
		}
	});
	
	//프로젝트 조회 버튼
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	//Block 추가 버튼
	$("#btnEntryAdd").click(function() {	
		fn_addCode($("#grdToList"), $("#grdFromList"));
	});
	
	//Block 삭제 버튼
	$("#btnEntryDel").click(function() {
		fn_addCode($("#grdFromList"), $("#grdToList"));	
	});
	
	// 위 그리드 필터 버튼
	$("#btnFilter").click( function() {
				
		var $grid = $("#grdFromList");
		
		var groups = [], groups2 = [], groups3 = [];
		var val	   = $("input[name=txtCondition]").val();
		
		if (!$.jgrid.isEmpty(val)) {					
			
			var arrVal = val.split(",");					
			
			for(var i=0; i<arrVal.length; i++) {
			
				var arrBetween = arrVal[i].split("-");		
				
				if (arrBetween.length == 2) {	
					groups2.push({field:"code",op: "ge", data: arrBetween[0] });
					groups2.push({field:"code",op: "le", data: arrBetween[1] });
				} else {
					groups.push({field:"code",op: "bw", data: arrVal[i] });
				}
			}
		}
		
		if ( $("#sel_condition").val() != "ALL") groups3.push({field:"gbn",op: "eq", data: $("#sel_condition").val() });
										
		$.extend($grid.jqGrid("getGridParam", "postData"), {
		    filters: JSON.stringify({
		       "groupOp": "",
			   "rules" : [],
			   "groups": [
			        {
			            "groupOp": "OR",
			            "rules"  : groups
			        }
			        ,
			        {
			        	 "groupOp": "AND",
			             "rules"  : groups2
			        }
			        ,
			        {
			            "groupOp": "AND",
			            "rules"  : groups3
			        }
			       
			    ]
		     })
		});
		
		
		$grid.jqGrid("setGridParam", {search: true})
		     .trigger('reloadGrid', [{current: true, page: 1}]);
	
	} );
	$("#btnBlockSave").click( function() {
		if (confirm('저장 하시겠습니까?') == 0 ) {
			return;
		}
		
		lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
			
		var url			= "saveBlockList.do";
		var dataList    = {prBlockList:JSON.stringify($("#grdFromList").jqGrid('getRowData'))};
		var formData 	= fn_getFormData('#listForm');
		var parameters  = $.extend({},dataList,formData);
		
		$.post(url, parameters, function(data) {
				
			alert(data.resultMsg);
				
			}).fail(function(){
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			}).always(function() {
		    	lodingBox.remove();	
			});
	});
	// 아래 그리드 필터 버튼
	$("#btnFilter2").click( function() {
			
		var $grid = $("#grdToList");
		
		var groups = [], groups2 = [], groups3 = [];
		var val	   = $("input[name=txtCondition2]").val();
		
		if (!$.jgrid.isEmpty(val)) {					
			
			var arrVal = val.split(",");					
			
			for(var i=0; i<arrVal.length; i++) {
			
				var arrBetween = arrVal[i].split("-");		
				
				if (arrBetween.length == 2) {	
					groups2.push({field:"code",op: "ge", data: arrBetween[0] });
					groups2.push({field:"code",op: "le", data: arrBetween[1] });
				} else {
					groups.push({field:"code",op: "bw", data: arrVal[i] });
				}
			}
		}
		
		if ( $("#sel_condition2").val() != "ALL") groups3.push({field:"gbn",op: "eq", data: $("#sel_condition2").val() });
										
		$.extend($grid.jqGrid("getGridParam", "postData"), {
		    filters: JSON.stringify({
		       "groupOp": "",
			   "rules" : [],
			   "groups": [
			        {
			            "groupOp": "OR",
			            "rules"  : groups
			        }
			        ,
			        {
			        	 "groupOp": "AND",
			             "rules"  : groups2
			        }
			        ,
			        {
			            "groupOp": "AND",
			            "rules"  : groups3
			        }
			       
			    ]
		     })
		});
		
		$grid.jqGrid("setGridParam", {search: true})
		     .trigger('reloadGrid', [{current: true, page: 1}]);
	
	} );
	
	fn_searchLastRevision();

	//grid resize
	fn_insideGridresize($(window),$("#divFromList"),$("#grdFromList"),5,0.65);
	// grid resize
	fn_insideGridresize($(window),$("#divToList"),$("#grdToList"),-40,0.35);	
	
	//grid resize
	fn_insideGridresize($(window),$("#divGroup"),$("#prGroupList"),-25, 0.4);
	//grid resize
	fn_insideGridresize($(window),$("#divItemGroup"),$("#prGroupItemList"),-40, 0.6);
	
	//fn_toDate( "created_date" );
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// PR Gropu Row 추가
function addPRGroup() {

	fn_applyData("#prGroupList",change_group_row_num,change_group_col);
	
	var $grid	 = $("#prGroupList"); 
	var item 	 = {};
	var colModel = $grid.jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
	
	var nRandId = $.jgrid.randId();
	$grid.resetSelection();
	$grid.jqGrid('addRowData', nRandId, item, 'last');
	
	fn_jqGridChangedCell('#prGroupList', nRandId, 'chk', {background:'pink'});
		
}

// PR Gropu Row 삭제
function deletePRGroup() {
	
	fn_applyData("#prGroupList",change_group_row_num,change_group_col);
	
	var selrow 	= $('#prGroupList').jqGrid('getGridParam', 'selrow');
	var item 	= $('#prGroupList').jqGrid('getRowData',selrow);
	
	if (fn_ProjectNoCheck(true)) {
		if(item.group_code == 1 || item.group_code == 2
			|| item.group_code == 3 || item.group_code == 4 || item.group_code == 5)
		{
			alert("Default PRGroup은 삭제 불가합니다.");
			return; 
		}
		
		if(item.pr_no) {
			alert("PR NO가 발행된 PRGroup은 삭제 불가합니다.");
			return; 
		}	
		
		if(item.oper != 'I') {
			item.oper = 'D';
			$('#prGroupList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#prGroupList' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#prGroupList' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		} else {
			$('#prGroupList').jqGrid('delRowData', selrow);	
		}
		
		
		$('#prGroupList').resetSelection();
	}
}

// PR Gropu Item Row 추가
function addPRGroupItem(obj, paint_item, item_desc, can_size, quantity) {

	fn_applyData("#prGroupItemList",change_groupitem_row_num,change_groupitem_col);
	
	var selrow = $('#prGroupList').jqGrid('getGridParam', 'selrow');
	if (selrow == null) {
		alert("Not Exist Selected Group. Please select Group.");
		return;
	}
	
	var val1 = $('#prGroupList').jqGrid('getCell', selrow, 'oper');
	if (val1 == "I") {
		alert("선택한 Group 저장 후 Item추가 바랍니다.");
		return;
	}
	
	
	var $grid	 = $("#prGroupItemList"); 
	var item 	 = {};
	var colModel = $grid.jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
	if(paint_item != null && paint_item != "" ) {
		item.paint_item  = paint_item;
		item.item_desc  = item_desc;
		item.can_size  = can_size;
		item.quantity 	 = quantity;	
	}
	var nRandId = $.jgrid.randId();
	$grid.resetSelection();
	$grid.jqGrid('addRowData', nRandId, item, 'first');
	
	fn_jqGridChangedCell('#prGroupItemList', nRandId, 'chk', {background:'pink'});
	return nRandId;
}

// PR Gropu Item Row 삭제
function deletePRGroupItem() {
	
	fn_applyData("#prGroupItemList",change_group_row_num,change_group_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	if (fn_ProjectNoCheck(true)) {
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		
		for(var i=0;i<selarrrow.length-1;i++){
			var selrow = selarrrow[i];	
			var item   = $('#prGroupItemList').jqGrid('getRowData',selrow);
			
			if(item.oper != 'I') {
				item.oper = 'D';
				deleteGroupItemData.push(item);
			}
			
			$('#prGroupItemList').jqGrid('delRowData', selrow);
		}
	}
	
	$('#prGroupItemList').resetSelection();
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

//header checkbox action 
function checkBoxHeader2(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader2").is(":checked"))){
		$(".chkboxItem2").prop("checked", true);
	}else{
		$("input.chkboxItem2").prop("checked", false);
	}
}

//header checkbox action 
function checkBoxHeader3(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader3").is(":checked"))){
		$(".chkboxItem3").prop("checked", true);
	}else{
		$("input.chkboxItem3").prop("checked", false);
	}
}

// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// header checkbox action 
function fn_checkBox(obj, e) {
	
	var chkBox = $("#"+obj.id);
	
	var isChecked = false;
	if(chkBox.is(":checked")){
		isChecked = true;
	}
	
	$(".check1").prop("checked", false);
	chkBox.prop("checked", isChecked);
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//그리드  checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox'  id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

//그리드  checkbox 생성
function formatOpt2(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox2' id='"+rowid+"_chkBoxOV2' class='chkboxItem2' value="+rowid+" />";
}

//그리드  checkbox 생성
function formatOpt3(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox3' id='"+rowid+"_chkBoxOV3' class='chkboxItem3' value="+rowid+" />";
}

// window에 resize 이벤트를 바인딩 한다.
function resizeIframe(obj) {
	 var iframeHeight=(obj).contentWindow.document.body.scrollHeight;
    (obj).height=iframeHeight+21;
}

// Revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
}

// 프로젝트 리비젼에 따라 버튼 enable설정하는 함수
function fn_setButtionEnable() {
	
	if ("Y" == isLastRev && sState != "D") {
		fn_buttonEnable(["#btnSave", "#btnCreatePR"]);
// 		$( "#btnSave" ).removeAttr( "disabled" );
// 		$( "#btnExcelImport").removeAttr( "disabled" );
// 		$( "#btnCreatePR").removeAttr( "disabled" );
		
	} else {
		fn_buttonEnable(["#btnSave", "#btnCreatePR"]);
		/* fn_buttonDisabled(["#btnSave", "#btnCreatePR"]); */
// 		$( "#btnSave" ).attr( "disabled", true );
// 		$( "#btnExcelImport" ).attr( "disabled", true );
// 		$( "#btnCreatePR" ).attr( "disabled", true );
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

// 폼데이터를 Json Arry로 직렬화
function fn_getParam() {
	return fn_getFormData("#listForm");
}

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.moveTo(200,0);
    win.resizeTo(720, 780);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 그리드의 모든 Row 가져오는 함수
function getAllGridInfo(gridId) {
	var allData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return true;
	});
			
	return allData;
}

// 그리드의 변경된 Row만 가져오는 함수
function getChangedGridInfo(gridId) {
	
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	
	if (gridId == "#prGroupList") {
		changedData = changedData.concat(deleteGroupData);	
	} else if (gridId == "#prGroupItemList") {
		changedData = changedData.concat(deleteGroupItemData);
	} 
	
	changedData = changedData.concat(deleteGroupData);	
	
	return changedData;
}

// From Grid에 Row추가, To Grid에 Row삭제
function fn_addCode($grdFrom, $grdTo) {
			
	var chked_val = "";
	
	if ($grdFrom.selector == "#grdFromList") {
		
		$(":checkbox[name='checkbox2']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
	
	} else {
		
		$(":checkbox[name='checkbox3']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
	}
		
	var selarrrow = chked_val.split(',');
	var desData   = $grdTo.jqGrid('getDataIDs');
	var lastId	  = -1;
	
	for(var i=0;i<selarrrow.length-1;i++){
		
		var selrow 	  = selarrrow[i];	
		var isExist   = false;
		
		var item   	  = $grdFrom.jqGrid('getRowData',selrow);
		var item2 	  = null;
				
		for( var j = 0; j < desData.length; j++ ) {
			item2 = $grdTo.jqGrid('getRowData',desData[j]);
			
			if(item2.gbn == item.gbn && item2.code == item.code ) {
				isExist   = true;
				break;
			}	
		}	
			
		if( isExist ) {
		
		} else {
			if ($grdTo.getDataIDs().length > 0) {
				lastId = $.jgrid.randId();
			}
			$grdFrom.jqGrid('delRowData', selrow);
			
			var selId = fn_searchGbn(item.gbn,$grdTo);
			
			if (selId == null) {
				$grdTo.jqGrid("addRowData", lastId, item, "last");
			} else {
				$grdTo.jqGrid("addRowData", lastId, item, "after",selId);
			}
		}
	
	}

	$grdFrom.resetSelection();
	$grdTo.resetSelection();
	fn_searchGroupItemList();
}

// 구분의 처음값을 찾는 함수
function fn_searchGbn(gbn, $grdSearch) {
	
	var selId = null;
	
	var desData   = $grdSearch.jqGrid('getDataIDs');
	
	for( var i = 0; i < desData.length; i++ ) {
		
		var item  = $grdSearch.jqGrid('getRowData',desData[i]);
		
		if (item.gbn == gbn) selId = desData[i];
	}
	
	return selId;
}

// 그리드에 변경된 데이터Validation체크하는 함수
function fn_checkPaintPRGroupValidate(arr1) {
	var result   = true;
	var message  = "";
	
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";				
	}
	
	if (result && arr1.length > 0) {
		
		ids = $("#prGroupList").jqGrid('getDataIDs');
		
		for(var  i = 0; i < ids.length; i++) {
			
			var oper = $("#prGroupList").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#prGroupList").jqGrid('getCell', ids[i], 'group_desc');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Description Field is required";
					
					setErrorFocus("#prGroupList",ids[i],1,'group_desc');
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

// PR생성 데이터 Validation체크하는 함수
function fn_checkPaintPRGroupItemValidate(arr1) {
	
	var result   = true;
	var message  = "";
	
	if (arr1.length == 0) {
		result  = false;
		message = "Not Exist Checked Item. Please check Item.";				
	}
	
	var selrow 	= $('#prGroupList').jqGrid('getGridParam', 'selrow');
	if (result && selrow < 0) {
		result  = false;
		message = "Not Exist Selected Group. Please select Group.";	
	}
	
	if (result && $.jgrid.isEmpty($("input[name=pr_desc]").val())) {		
		result  = false;
		message = "Please input the Description.";	
		
		setTimeout('$("input[name=pr_desc]").focus()',200);	
	}
	
	if (result && $.jgrid.isEmpty($("input[name=created_date]").val())) {
		result  = false;
		message = "PR Date is null. Please input the PR Date";				
		
		setTimeout('$("input[name=created_date]").focus()',200);
	}
	
	var pr_date  = $("input[name=created_date]").val();
	var chk_date = $("input[name=chk_create_date]").val();
	
	if (result && (Number(pr_date.replace(/-/gi, ""))-Number(chk_date.replace(/-/gi, ""))) < 0) {
		result  = false;
		message = "PR Date is possible + 7 days after today. (ex)today : 2015-01-10, possible day : 2015-01-17~";				
		
		setTimeout('$("input[name=created_date]").focus()',200);
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드 초기화하는 함수
function fn_gridClear(gbn) {
	
	if (gbn == 1) {
		$("#grdFromList").clearGridData(true);
		$("#prGroupItemList").clearGridData(true);	
	} else if (gbn == 2) {
		$("#grdFromList").clearGridData(true);
		$("#grdToList").clearGridData(true);	
		$("#prGroupItemList").clearGridData(true);	
		$("#prGroupList").clearGridData(true);	
	}
	
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
	  			  			  		
	  		fn_gridClear(2);	
	  		  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  	
	  	fn_setButtionEnable();
	  	fn_setSeriesProject( $( "input[name=project_no]" ).val(),$("input[name=revision]").val() );
	});  	

}

function fn_setSeriesProject(project_no, revision) {
	$( "#divSeries" ).text( "" );

	$.post( "selectSeriesProjectNo.do", { project_no : project_no }, function( data ) {
		var checked = "checked";
		var revi = revision;
		for( var i = 0; i < data.length; i++ ) {
			var val = data[i].project_no;
			var plan = data[i].planflag;
			if(plan == "PLAN"){
				$( "#divSeries" ).append( "<input id='chk_" + i + "' type='radio' style='margin-left:10px;background: #999;padding: 2px 5px 2px 5px;' class='' value='" + val + "'" + " disabled  />" + val + "" );
			} else {
				$( "#divSeries" ).append( "<input onclick='fn_checkBox(this,event,"+ revi +")' id='chk_" + i + "' type='radio' style='margin-left:10px' class='check1' value='" + val + "'" + checked +" />" + val + "" );
				if(checked == "checked"){
					$("input[name=p_project_no]").val(val);
					$("input[name=p_revision]").val(revi);
				}
				checked = "";
			}
			
		}
		if(data.length ==0 ) {
			$("input[name=p_project_no]").val("");
			$("input[name=p_revision]").val("");
		}
	}, "json" );	

}

function fn_checkBox(obj, e, revi) {
	var chkBox = $( "#" + obj.id );
	$("input[name=p_project_no]").val(obj.value);
	$("input[name=p_revision]").val(revi);
	

	var isChecked = false;
	if( chkBox.is( ":checked" ) ) {
		isChecked = true;
	}

	$( ".check1" ).prop( "checked", false );
	chkBox.prop( "checked", isChecked );
	
	$( "#prGroupList" ).clearGridData( true );
	$( "#prGroupItemList" ).clearGridData( true );
	$( "#grdFromList" ).clearGridData( true );
	$( "#grdToList" ).clearGridData( true );
}

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "popUpExcelUpload.do?gbn=prBlockExcelImport.do";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&p_project_no="+$("input[name=p_project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();
		
			   	
	win = window.open(sUrl,"listForm","height=260,width=680,top=200,left=200");
}

//엑셀 업로드 화면 호출
function fn_excelItemUpload() {
	if (win != null){
		win.close();
	}
	
	var sUrl = "popUpExcelUploadPrItem.do?gbn=prItemExcelImport.do";
		sUrl += "&project_no="+$("input[name=project_no]").val();
		sUrl += "&p_project_no="+$("input[name=p_project_no]").val();
		sUrl += "&revision="+$("input[name=revision]").val();
		
		//addPRGroupItem();		 
	//var rs = window.showModalDialog(sUrl,window,"dialogWidth:680px; dialogHeight:260px; center:on; scroll:off; status:off; location:no");
	win = window.open(sUrl,"","height=260,width=680,top=200,left=200");
}


// afterSaveCell oper 값 지정
/* function changeGroupItemEditEnd(irowId, cellName, value, irow, iCol) {
	
	var item = $('#prGroupItemList').jqGrid('getRowData', irowId);
	if (item.oper != 'I') {
		item.oper = 'U';
		$( '#prGroupItemList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
		

	// apply the data which was entered.
	$('#prGroupItemList').jqGrid("setRowData", irowId, item);
	
	// turn off editing.
	fn_jqGridChangedCell('#prGroupItemList', irowId, 'chk', {background:'pink'});
	
	$("input.editable,select.editable", this).attr("editable", "0");
} */

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}

// Paint Item 조회하는 화면 호출 
function searchItemCode(sCode, sDesc, opt1, rowid) {
	
	var item = $("#prGroupItemList").jqGrid('getRowData',rowid);		
	var args = {item_code : item.paint_item};
	
	var rs = window.showModalDialog("popupPaintCode.do",args,"dialogWidth:600px; dialogHeight:550px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$("#prGroupItemList").setCell(rowid,sCode,rs[0]);
		$("#prGroupItemList").setCell(rowid,sDesc,rs[1]);
		$("#prGroupItemList").setCell(rowid,opt1,rs[3]);
	}
}
//Paint Can Base계산 
function quantityCanBase(rowid) {
	var  ret  	 = $("#prGroupItemList").getRowData(rowid); 
	var  nCanQty = Math.ceil(Number(ret.quantity) / Number(ret.can_size)) * Number(ret.can_size);
	
	if ( isNaN(nCanQty) ) {
		$("#prGroupItemList").jqGrid("setCell", rowid, 'can_quantity', 0);
		$( '#prGroupItemList' ).jqGrid('setCell', rowid, 'can_quantity', '', { 'background' : '#6DFF6D' } );
	} else {
		$("#prGroupItemList").jqGrid("setCell", rowid, 'can_quantity', nCanQty);
		$( '#prGroupItemList' ).jqGrid('setCell', rowid, 'can_quantity', '', { 'background' : '#6DFF6D' } );
	}
}
// PR Group Item 리스트 조회 
function fn_searchGroupItemList() {
						
	var sUrl 				 = "infoGroupItemList.do";
	var allCodeResultRows 	 =  getAllGridInfo("#grdFromList");;
	
	var dataList    		 = {codeList:JSON.stringify(allCodeResultRows)};
	var formData 			 = fn_getFormData('#listForm');
	var parameters 			 = $.extend({},dataList,formData);
	
	$("#prGroupItemList").jqGrid('setGridParam',{url		: sUrl
												,mtype	   : 'POST' 
												,page		: 1
												,datatype	: 'json'
												,postData   : parameters}).trigger("reloadGrid");
}

// PR Group에 등록 되지 않은 Block 리스트 조회
function fn_searchUnregisteredBlock() {
	
	var sUrl = "infoUnregisteredBlockList.do";
	$("#grdToList").jqGrid('setGridParam',{url		: sUrl
										  ,mtype 	 : 'POST'
										  ,page		: 1
										  ,datatype	: 'json'
										  ,postData : fn_getFormData("#listForm")}).trigger("reloadGrid");
}

// PR Group에 등록된 Block, Stage 리스트 조회
function fn_searchBlockStageCode() {
	
	var sUrl = "infoBlockStageCodeList.do";
	
	var groupCode = $("input[name=group_code]").val();
	
	if (groupCode == "1" || groupCode == "2" 
		|| groupCode == "3" || groupCode == "4")
	{	
		$("#grdFromList").jqGrid('setGridParam',{url		: sUrl
												,mtype 	 : 'POST'
											    ,page		: 1
											    ,datatype	: 'json'
											    ,postData   : fn_getFormData("#listForm")}).trigger("reloadGrid");
	} else {
		$("#grdFromList").clearGridData(true);
	}										    
}

// PR Group 리스트 조회
function fn_search() {
	
	var sUrl = "infoPaintPRGroupList.do";
	$("#prGroupList").jqGrid('setGridParam',{url		: sUrl
											,mtype	   : 'POST'
										    ,page		: 1
										    ,datatype	: 'json'
										    ,postData   : fn_getFormData("#listForm")}).trigger("reloadGrid");
}

// 엑셀다운로드 화면 호출
function fn_excelDownload() {
		
	var f    = document.listForm;
	
	f.action = "prBlockExcelExport.do";
	f.method = "post";
	f.submit();
	
}

// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#prGroupList",change_group_row_num,change_group_col);
	
	if (confirm('저장 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	var changePrGroupListResultRows =  getChangedGridInfo("#prGroupList");
		
	if (!fn_checkPaintPRGroupValidate(changePrGroupListResultRows)) { 
		lodingBox.remove();
		return;	
	}
		
	var url			= "savePaintPRGruop.do";
	var dataList    = {prGroupList:JSON.stringify(changePrGroupListResultRows)};
	var formData 	= fn_getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);
	
	$.post(url, parameters, function(data) {
			
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
			 	fn_search(); 
			 	fn_gridClear(1);
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}

// 선택한 PR Group의 Item 리스트 ERP PR생성
function fn_createPR() {

	fn_applyData("#prGroupItemList",change_groupitem_row_num,change_groupitem_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
		
	var selarrrow 		= chked_val.split(',');
	var selectedData	= new Array();
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#prGroupItemList').jqGrid('getRowData',selrow);
		
		selectedData.push(item);
	}
	if(selectedData.length == 0) {
		selectedData = getAllGridInfo("#prGroupItemList");
	}
	if (!fn_checkPaintPRGroupItemValidate(selectedData)) { 
		return;	
	}
	
	if (confirm('PR 생성 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	var url			= "saveCreatePaintPR.do";
	var dataList    = {prGroupItemList:JSON.stringify(selectedData)};
	var formData 	= fn_getFormData('#listForm');
	var parameters  = $.extend({},dataList,formData);
	
	$.post(url, parameters, function(data) {
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
			 	fn_search(); 
			 	fn_gridClear(1);
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}

// 달력 초기화 설정
$(function() { 
	  $("#created_date").datepicker({
		dateFormat		: 'yy-mm-dd',
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNamesMin	: ['일','월','화','수','목','금','토'],

		changeMonth		  : true, //월변경가능
	    changeYear		  : true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
	  });
});

</script>
</html>