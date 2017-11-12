<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	<title>Admin - SPEC</title>
	<style type="text/css">
		.pointer {
			cursor: pointer;
		}
	</style>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" 	name="user_name" 		id="user_name"  	value="${loginUser.user_name}" />
		<input type="hidden" 	name="user_id" 			id="user_id"  		value="${loginUser.user_id}" />
		<input type="hidden" 	name="p_master"    		id="p_master" 		value="${p_master}"/>
		<input type="hidden" 	name="p_dwg_no"    		id="p_dwg_no" 		value="${p_dwg_no}"/>
		<input type="hidden" 	name="p_callback"    	id="p_callback" 	value="${p_callback}"/>
		
		<div id="mainDiv" class="mainDiv">
			<div class= "subtitle" style="width: 96.5%;">
				Admin Spec
				<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
			<table class="searchArea conSearch">
				<colgroup>
					<col width="65%">
					<col width="*">
				</colgroup>
				<tr>
					<td >
						<div class="button endbox">
						</div>
					</td>						
				</tr>
			</table>
			<div class="content" id="gridSpecListDiv">
				<table id="gridSpecList"></table>
				<div id="bottomSpecList"></div>
			</div>
			
		</div>
	</form>
<script type="text/javascript">
var idRow;
var idCol;
var kRow;
var kCol;
var lastSelection;
var flagDataChange;
var resultData = [];
var gridObj = $("#gridSpecList");

$(document).ready(function(){
	var objectHeight = gridObjectHeight(1);	
	gridObj.jqGrid({ 
        datatype: 'json', 
        mtype: 'POST', 
        url:'popUpAdminNewSpecList.do',
        postData : fn_getFormData('#application_form'),
        colModel:[
					{label:'MASTER'		,				name:'project_no'		, index:'project_no'			,width:25	,align:'center', sortable:false},
					{label:'DWG No.'	,				name:'dwg_no'			, index:'dwg_no'			,width:25	,align:'center', sortable:false},
					{label:'업체명'		,				name:'vendor_site_name'	, index:'vendor_site_name'	,width:60	,align:'center', sortable:false},
					{label:'파일'		,				name:'po_files_exists_flag', index:'po_files_exists_flag'		,width:15	,align:'center', sortable:false,	classes: 'pointer'},
					{label:'접수일'		,				name:'creation_date'	, index:'creation_date'		,width:25	,align:'center', sortable:false},
					{label:'COMMENT'	,				name:'act_comment'		, index:'act_comment'		,width:90	,align:'center', sortable:false},
					{label:'FLAG'		,				name:'complete_meaning'	, index:'complete_meaning'			,width:15	,align:'center', sortable:false , title:false, editable:true,
	                     edittype:'select', //SELECT BOX 옵션
              			 formatter:'select',
              			 editoptions:{
              			 	value:' : ;10:진행;20:마감;30:불가;999:결과'
              			 }
              		},
					{label:'파일'		,				name:'ds_files_exists_flag'	, index:'ds_files_exists_flag'		,width:15	,align:'center', sortable:false,	classes: 'pointer'},
					{label:'회신일'		,				name:'ds_creation_date'	, index:'ds_creation_date'	,width:25	,align:'center', sortable:false},
					{label:'COMMENT'	,				name:'ds_act_comment'	, index:'ds_act_comment'	,width:90	,align:'center', sortable:false	,title:false,	editable:true,	edittype : "text"},
					{label:'SPEC_REVIEW_ID' 	,		name:'spec_review_id' 	, index:'spec_review_id' 	,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'DS_SPEC_REVIEW_ID' 	,		name:'ds_spec_review_id', index:'ds_spec_review_id'	,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'PROJECT_ID' 		,		name:'project_id' 		, index:'project_id' 		,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'EQUIPMENT_NAME'		,		name:'equipment_name' 	, index:'equipment_name'	,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'VENDOR_SITE_ID'		,		name:'vendor_site_id' 	, index:'vendor_site_id'	,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'FILE_IDS'			,		name:'file_ids' 		, index:'file_ids'			,width:60 ,align:'center', sortable:false, hidden:true},
					{label:'DS_FILE_IDS'		,		name:'ds_file_ids' 		, index:'ds_file_ids'		,width:60 ,align:'center', sortable:false, hidden:true}
				],
        gridview: true,
        toolbar: [false, "bottom"],
        viewrecords: true,
        autowidth: true,
        height: objectHeight,
        pager: jQuery('#bottomSpecList'),
        rowNum : -1,
        pgbuttons: false,
        multiselect: false,
        cellEdit : true,
        cellsubmit : 'clientArray', // grid edit mode 2
        pgtext: null,
		 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
        	idRow=rowid;
        	idCol=iCol;
        	kRow = iRow;
        	kCol = iCol;
			 },
		 afterEditCell: function(id,name,val,iRow,iCol){
			  //Modify event handler to save on blur.
			  $("#"+iRow+"_"+name).bind('blur',function(){
				$('#gridSpecList').saveCell(iRow,iCol);
			  });
		},
		 jsonReader : {
            root: "rows",
            page: "page",
            total: "total",
            records: "records",  
            repeatitems: false,
           },        
        imgpath: 'themes/basic/images',
        onPaging: function(pgButton) {
		
	    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
	    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
	     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
	     	 */ 
			$(this).jqGrid("clearGridData");
	
	    	/* this is to make the grid to fetch data from server on page click*/
			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

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
		        });
		        this.updatepager(false, true);
		    }
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				//수정 및 결재 가능한 리스트 색상 변경
				var ds_spec_review_id = $(this).getCell( rows[i], "ds_spec_review_id" );
				if( $.trim(ds_spec_review_id) == "" ) {
					$(this).jqGrid( 'setCell', rows[i], 'complete_meaning', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'ds_act_comment', '', { color : 'black', background : '#FFFFCC' } );
					var ary = ['project_no','dwg_no','vendor_site_name','po_files_exists_flag','creation_date','act_comment',
					           'ds_files_exists_flag','ds_creation_date'];
					disableRow($(this),rows[i],ary);
				} else {
					var ary = ['project_no','dwg_no','vendor_site_name','po_files_exists_flag','creation_date','act_comment','complete_meaning',
					           'ds_files_exists_flag','ds_creation_date','ds_act_comment'];
					disableRow($(this),rows[i],ary);
					gridObj.find("tr[id="+rows[i]+"]").find("input[class=cbox]").attr("disabled",true);
				}
			}
	 	},
	 	gridComplete : function(){
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				var ds_spec_review_id = $(this).getCell( rows[i], "ds_spec_review_id" );
				if( $.trim(ds_spec_review_id) == "" ) {
					$(this).jqGrid( 'setCell', rows[i], 'complete_meaning', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'ds_act_comment', '', { color : 'black', background : '#FFFFCC' } );
					var ary = ['project_no','dwg_no','vendor_site_name','po_files_exists_flag','creation_date','act_comment',
					           'ds_files_exists_flag','ds_creation_date'];
					disableRow($(this),rows[i],ary);
				} else {
					var ary = ['project_no','dwg_no','vendor_site_name','po_files_exists_flag','creation_date','act_comment','complete_meaning',
					           'ds_files_exists_flag','ds_creation_date','ds_act_comment'];
					disableRow($(this),rows[i],ary);
				}
			}
	 	},
	 	beforeSelectRow: function(rowid, e) {
	        var cbsdis = $("tr#"+rowid+".jqgrow > td > input.cbox:disabled", gridObj[0]);
	        if (cbsdis.length === 0) {
	            return true;    // allow select the row
	        } else if(e.target.getAttribute("aria-describedby") != null){
	        	return true; //multicheckbox 선택안되게 처리 및 기타 cell에 대한 기능을 살리기 위한 처리
	        } 
	        else {
	            return false;   // not allow select the row
	        }
	    },
	    onSelectAll: function(aRowids,status) {
	        if (status) {
	            // uncheck "protected" rows
	            var cbs = $("tr.jqgrow > td > input.cbox:disabled", gridObj[0]);
	            cbs.removeAttr("checked");

	            //modify the selarrrow parameter
	            gridObj[0].p.selarrrow = gridObj.find("tr.jqgrow:has(td > input.cbox:checked)")
	                .map(function() {return this.id; }) // convert to set of ids
	                .get(); // convert to instance of Array
	        }
	    },
	 	onCellSelect: function(row_id, colId) {
		 	var cm = gridObj.jqGrid("getGridParam", "colModel");
			var colName = cm[colId];
			var item = gridObj.jqGrid( 'getRowData', row_id );
			
			if(colName['index'] == "po_files_exists_flag" && item.po_files_exists_flag == "Y")
			{
				downFileList(item.file_ids);
			}
			else if(colName['index'] == "ds_files_exists_flag" && item.ds_files_exists_flag == "Y")
			{
				downFileList(item.ds_file_ids);
			}
	 	}
	}); //end of jqGrid
	gridObj.jqGrid('setGroupHeaders',{
		useColSpanStyle: false,
		groupHeaders : [
		                	{startColumnName: 'project_no'	, numberOfColumns: 6, titleText: '- 조달 접수 -'},
		                	{startColumnName: 'complete_meaning'	, numberOfColumns: 4, titleText: '- 설계 회신 -'}
		                ]
	});
	//jqGrid 크기 동적화
	resizeJqGridWidth( $(window), $( "#gridSpecList" ), undefined, 0.75);
});

function downFileList(file_ids){
	var url = "popUpPurchasingNewSpecDownload.do?p_file_ids=" + file_ids;
	var nwidth = 800;
	var nheight = 300;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";

	window.open(url,"",sProperties);  
}

function disableRow(jqGridObj,rowId,cellNameAry,disableClr){
	for(var i = 0; i < cellNameAry.length; i++){
		jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', 'not-editable-cell' );
		if(disableClr == undefined)jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', { color : 'black', background : '#dadada' } );
	}
}

</script>
</body>
</html>