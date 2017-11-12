<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수정된 QUANTITY</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:4px;
    padding-top:2px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
</style>

</head>
<body>
<div id="wrap1">
<form id="list_form1" name="list_form1">
	<input type="hidden"  name="pageYn"  value="N"/>
	
	<div id="content" class="content">
		<table id ="quantityEditList" ></table>
		<div   id ="p_quantityEditList"></div>
	</div>
	
</form>
</div>
<script type="text/javascript">
var row_selected;
   
$(document).ready(function(){
	$("#quantityEditList").jqGrid({ 
             datatype	: 'json', 
             url		: '',
             postData   : '',
             colNames:['Project','Block','PE','Pre PE','Area Code','Area Desc','Count','Paint Code','Paint Desc'
             			,'DFT','Stage','TSR','Pre Loss','Post Loss','Pre Loss(%)','Post Loss(%)'
             			,'Block Area','Pre PE Area','PE Area','Hull Area','Quay Area'
             			,'Block Qty','Pre PE Qty','PE Qty','Hull Qty','Quay Qty','','',''],
                colModel:[
                      {name:'project_no',		index:'project_no', 	width:50, 	sortable:false, frozen : true},
                	{name:'block_code',		index:'block_code', 	width:40, 	sortable:false, frozen : true},
                   	{name:'pe_code',		index:'pe_code', 		width:25, 	sortable:false, frozen : true},
                   	{name:'pre_pe', 		index:'pre_pe',  		width:42, 	sortable:false, frozen : true},
                   	{name:'area_code',		index:'area_code', 		width:70, 	sortable:false, frozen : true},
                	{name:'area_desc',		index:'area_desc', 		width:160, 	sortable:false, frozen : true},
                   	{name:'paint_count',	index:'paint_count', 	width:40, 	sortable:false},
                   	{name:'paint_item', 	index:'paint_item',  	width:80, 	sortable:false},
                   	{name:'item_desc',		index:'item_desc', 		width:180, 	sortable:false},
                	{name:'paint_dft',		index:'paint_dft', 		width:40, 	sortable:false},
                   	{name:'paint_stage',	index:'paint_stage', 	width:42, 	sortable:false},
                   	{name:'tsr', 	 		index:'tsr',  	   		width:42, 	sortable:false},
                   	{name:'pre_loss',		index:'pre_loss', 		width:60, 	sortable:false},
                	{name:'post_loss',		index:'post_loss', 		width:70, 	sortable:false},
                   	{name:'pre_loss_rate',	index:'pre_loss_rate', 	width:90, 	sortable:false},
                   	{name:'post_loss_rate', index:'post_loss_rate', width:90, 	sortable:false},
                   	{name:'block_area',		index:'block_area', 	width:80, 	sortable:false},
                	{name:'pre_pre_area',	index:'pre_pre_area', 	width:80, 	sortable:false},
                   	{name:'pe_area',		index:'pe_area', 		width:60, 	sortable:false},
                   	{name:'hull_area', 		index:'hull_area',  	width:70, 	sortable:false},
                   	{name:'quay_area',		index:'quay_area', 		width:70, 	sortable:false},
                	{name:'block_quantity',	index:'block_quantity', width:80, 	sortable:false},
                   	{name:'pre_pe_quantity',index:'pre_pe_quantity',width:80, 	sortable:false},
                   	{name:'pe_quantity', 	index:'pe_quantity',  	width:60, 	sortable:false},
                   	{name:'hull_quantity', 	index:'hull_quantity',  width:60, 	sortable:false},
                   	{name:'quay_quantity', 	index:'quay_quantity',  width:70, 	sortable:false},
                                     	
                   	{name:'revision',	index:'revision', 			width:25, 	hidden:true},
                   	{name:'season_code',index:'season_code', 		width:25, 	hidden:true},
                    {name:'oper',		index:'oper', 				width:25, 	hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             autowith    : true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: parent.objectHeight-70,
             
             pager		: jQuery('#p_quantityEditList'),
             //shrinkToFit:false,
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	        // rownumbers : true,          	// 리스트 순번
	        // beforeSaveCell : changeAreaEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	
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
             	
   			 },
			 onCellSelect: function(row_id, colId) {
             	
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
	// 그리드 헤드 고정     
	$("#quantityEditList").jqGrid('setFrozenColumns');

	fn_gridresize(parent.objectWindow,$( "#quantityEditList" ));
});  //end of ready Function 	    
    
function fn_search(){
	//alert("b");
}

function resetGrid(){
	$("#quantityList").clearGridData();
}

</script>
</body>
</html>