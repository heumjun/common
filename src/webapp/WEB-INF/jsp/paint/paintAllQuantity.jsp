<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>전체 QUANTITY</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
.ui-jqgrid tr.jqgrow td {
        white-space: normal !important;
    }
 .ui-jqgrid .ui-jqgrid-htable th div {
    height:45px;
    /* overflow:hidden;
    padding-right:4px;
    padding-top:2px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important; */
} 
</style>

</head>
<body>
<form id="list_form" name="list_form">
	<input type="hidden"  name="pageYn"  value="N"/>
	
<!-- 	<div style="width: 100%;margin-top: 10px;  border: 1px solid white"> -->
	<div id="content" class="content">
		<table id ="quantityList" ></table>
		<div   id ="p_quantityList"></div>
	</div>
	
</form>
<script type="text/javascript">

var row_selected;

$(document).ready(function(){
	var objectHeight = gridObjectHeight(1);
	
	var objectWidth = gridObjectWidth();
	$("#quantityList").jqGrid({ 
            datatype	: 'json', 
            url		: '',
            postData   : '',
            colNames:['Project','Quay','Zone','PE','Pre PE','Block','Area<br>Code','Area Desc','Count','Paint<br>Code','Paint Desc'
             			,'DFT','Stage','SVR','TSR','Pre<br>Loss','Post<br>Loss','Pre<br>Loss<br>(%)','Post<br>Loss<br>(%)'
             			,'Block<br>Area','Pre PE<br>Area','PE<br>Area','Hull<br>Area','Quay<br>Area'
             			,'Block<br>Qty','Pre PE<br>Qty','PE<br>Qty','Hull<br>Qty','Quay<br>Qty','','','','','','','',''],
            colModel:[
                {name:'project_no',		index:'project_no', 	width:50, 	sortable:false, frozen : true},
                {name:'quay',			index:'quay', 			width:40, 	sortable:false, frozen : true},
            	{name:'zone_code',		index:'zone_code', 		width:40, 	sortable:false, frozen : true},
                {name:'pe_code',		index:'pe_code', 		width:40, 	sortable:false, frozen : true},
               	{name:'pre_pe_code', 	index:'pre_pe_code',  	width:50, 	sortable:false, frozen : true},
            	{name:'block_code',		index:'block_code', 	width:40, 	sortable:false, frozen : true},
               	{name:'area_code',		index:'area_code', 		width:70, 	sortable:false, frozen : true},
            	{name:'area_desc',		index:'area_desc', 		width:130, 	sortable:false, frozen : true},
               	{name:'paint_count',	index:'paint_count', 	width:40, 	sortable:false, frozen : true, align:'right'},
               	{name:'paint_item', 	index:'paint_item',  	width:140, 	sortable:false},
               	{name:'item_desc',		index:'item_desc', 		width:200, 	sortable:false},
            	{name:'paint_dft',		index:'paint_dft', 		width:40, 	sortable:false, align:'right'},
               	{name:'paint_stage',	index:'paint_stage', 	width:40, 	sortable:false, align:'center'},
               	{name:'svr', 	 		index:'svr',  	   		width:40, 	sortable:false, align:'right'},
               	{name:'tsr', 	 		index:'tsr',  	   		width:45, 	sortable:false, align:'right'},
               	{name:'pre_loss',		index:'pre_loss', 		width:40, 	sortable:false, align:'right', formatter : 'integer', formatoptions : { thousandsSeparator : " ", defaultValue : '-' } },
            	{name:'post_loss',		index:'post_loss', 		width:40, 	sortable:false, align:'right'},
               	{name:'pre_loss_rate',	index:'pre_loss_rate', 	width:40, 	sortable:false, align:'right'},
               	{name:'post_loss_rate', index:'post_loss_rate', width:40, 	sortable:false, align:'right'},
               	{name:'block_area',		index:'block_area', 	width:70, 	sortable:false, align:'right'},
            	{name:'pre_pe_area',	index:'pre_pe_area', 	width:70, 	sortable:false, align:'right'},
               	{name:'pe_area',		index:'pe_area', 		width:70, 	sortable:false, align:'right'},
               	{name:'hull_area', 		index:'hull_area',  	width:70, 	sortable:false, align:'right'},
               	{name:'quay_area',		index:'quay_area', 		width:70, 	sortable:false, align:'right'},
            	{name:'block_quantity',	index:'block_quantity', width:70, 	sortable:false, align:'right'},
               	{name:'pre_pe_quantity',index:'pre_pe_quantity',width:70, 	sortable:false, align:'right'},
               	{name:'pe_quantity', 	index:'pe_quantity',  	width:70, 	sortable:false, align:'right'},
               	{name:'hull_quantity', 	index:'hull_quantity',  width:70, 	sortable:false, align:'right'},
               	{name:'quay_quantity', 	index:'quay_quantity',  width:70, 	sortable:false, align:'right'},
               
               	{name:'block_define_flag',	index:'block_define_flag', 	width:25, 	hidden:true},
               	{name:'pe_define_flag',		index:'season_code', 		width:25, 	hidden:true},
             	{name:'pre_pe_define_flag',	index:'revision', 			width:25, 	hidden:true},
               	{name:'hull_define_flag',	index:'season_code', 		width:25, 	hidden:true},
             	{name:'quay_define_flag',	index:'revision', 			width:25, 	hidden:true},                 	
               	{name:'revision',			index:'revision', 			width:25, 	hidden:true},
               	{name:'season_code',		index:'season_code', 		width:25, 	hidden:true},
               	
                {name:'oper',		index:'oper', 				width:25, 	hidden:true}
            ],
            cmTemplate: { title: false },
         	gridview	: true,
         	toolbar		: [false, "bottom"],
	        viewrecords : true,                		//하단 레코드 수 표시 유무
	        //width		: objectWidth,                     //사용자 화면 크기에 맞게 자동 조절
 	        autowith    : true,
	        height		: parent.objectHeight-70,
	        
	        pager		: $('#p_quantityList'),
	        //shrinkToFit : false, 
			//cellEdit	: true,             // grid edit mode 1
	      	cellsubmit	: 'clientArray',  	// grid edit mode 2
	      	         
	      	rowList		: [1000,5000,10000],
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
			gridComplete : function () {
			 	//미입력 영역 회색 표시
				var ids = $("#quantityList").jqGrid('getDataIDs');
				
				for(var i=0; i<ids.length; i++) {
					var iData = $("#quantityList").jqGrid('getRowData', ids[i]);
					
					if (iData.block_define_flag == "Y") {
						
						$("#quantityList").jqGrid('setCell',ids[i],"block_quantity","",{'background-color':'#cfefcf',
				                                     '						   			   			 background-image':'none'});
					}
					
					if (iData.pe_define_flag == "Y") {
						$("#quantityList").jqGrid('setCell',ids[i],"pe_quantity","",{'background-color':'#cfefcf',
				                                     '						   			   		  background-image':'none'});
					}
					
					if (iData.pre_pe_define_flag == "Y") {
						$("#quantityList").jqGrid('setCell',ids[i],"pre_pe_quantity","",{'background-color':'#cfefcf',
				                                     '						   			   			  background-image':'none'});
					}
					
					if (iData.hull_define_flag == "Y") {
						$("#quantityList").jqGrid('setCell',ids[i],"hull_quantity","",{'background-color':'#cfefcf',
				                                     '						   			   		    background-image':'none'});
					}
					
					if (iData.quay_define_flag == "Y") {
						$("#quantityList").jqGrid('setCell',ids[i],"quay_quantity","",{'background-color':'#cfefcf',
				                                     '						   			   			background-image':'none'});
					}
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
	//$("#quantityList").jqGrid('setFrozenColumns');
	
	//grid resize
    
	fn_insideGridresize(parent.objectWindow,$( "#content" ),$( "#quantityList" ),70);
	//$( "#quantityList" ).setGridWidth($( "#content" ).width());   
});  //end of ready Function 	    

// Quantity 조회하는   함수
function fn_search(){
	var sUrl = "searchPaintAllQuantity.do";
	$("#quantityList").jqGrid('setGridParam',{url	  : sUrl
		                                    ,mtype	  : 'POST' 
											,page	  : 1
											,datatype : 'json'
											,postData : parent.fn_getParam()}).trigger("reloadGrid");
}

// 그리드 초기화하는 함수
function resetGrid(){
	$("#quantityList").clearGridData();
}

// 그리드 총 레코드 갯수를 반환하는 함수
function getReccount() {
	return $("#quantityList").getGridParam("reccount");
}

</script>
</body>
</html>