<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ITEM 부가 속성 등록</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<div id="mainDiv">
		<div  class = "topMain" style="margin: 0px;line-height: 45px;">
				
					<div class = "conSearch" >
						<span class = "spanMargin">
							<span class="pop_tit" >등록Catalog</span>				<input type="text" name="catalog_code" readonly value="" style="width:80px; height:25px;"/>
						</span>
					</div>
					<div class = "button" >
						<input type="button" value="저장" id="btnSave" class="btn_blue"/>
					</div>	
				
		</div>
		
		
			<fieldset style="height:380px;margin-top: 10px;">
			<legend class="sc_tit sc_tit2 mgb5">ITEM 부가속성</legend>
				<div style="height:300px; display: inline; margin: 5px; float: left;  width: 72%;">
					<table id="itemAddAttributeBase"></table>
					<div id="pitemAddAttributeBase"></div>
				</div>
				<div style="height:300px; display: inline;   float: left; margin: 5px; ">
				  	<table id="itemAddValue"></table>
				  	<div id="pitemAddValue"></div>
				
				</div>
			</fieldset>
			
	</div>
</form>
<script type="text/javascript">
	
	//삭제 데이터
	var itemAttributeDeleteData	= [];
	var itemValueDeleteData 	= [];
	
	var tableId    				= "";
	var fv_sd_type 				= "";
		
	var item_attr_row     		= 0;			// item속성 선택한 row_id
	var item_attr_row_num 		= 0;			// item속성 선택한 row			
	var item_attr_col     		= 0;			// item속성 선택한 col

	var item_value_row    		= 0;			// itmeValue 선택한 row_id
	var item_value_row_num 		= 0;
	var item_value_col    		= 0;
	
	var fv_attribute_code		= "";
	var lodingBox;			

	$(document).ready(function() {
		$("input[name=catalog_code]").val(window.dialogArguments["p_catalog_code"]);
		
		$("#itemAddAttributeBase").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'infoItemAddAttribute.do',
             postData	: {catalog_code : $("input[name=catalog_code]").val() },
             colNames:['물성치','항목','Data Type','Desc','MIN','MAX','상위','필수유무','','oper'],
                 colModel:[
	                    {name:'attribute_code',index:'attribute_code', width:60, editable:false, sortable : false, editoptions:{dataEvents: [{
																								                         type: 'keydown', 
																								                         fn: function(e){
																									                                var key = e.charCode || e.keyCode;
																									                                if(key == 13 || key == 9){//enter,tab
																									                                	tableId 	= '#itemAddAttributeBase';
																									                                    
																									                                    fv_sd_type 	= "CATALOG_ADDATTR_CODE";
																									                                    searchItem(this,0,-1,item_attr_row_num,item_attr_col);
																								                                	}
																								                            	}
																								                         }]
						}},
	                    {name:'attribute_name',index:'attribute_name', width:100, editable:false, sortable : false, editrules:{required:true}, editoptions:{dataEvents: [{
																														                        	type: 'keydown', 
																														                            fn: function(e){
																															                                var key = e.charCode || e.keyCode;
																															                                if(key == 13 || key == 9){//enter,tab
																															                                	tableId 	= '#itemAddAttributeBase';
																															                                    
																															                                    fv_sd_type 	= "CATALOG_ATTRIBUTE_NAME";
																															                                    searchAttrItem(this,1,-1,item_attr_row_num,item_attr_col);
																														                                	}
																														                            	}
																														                        	}]	
	                    
	                    }},
	                    {name:'attribute_data_type',index:'attribute_data_type', width:50, editable:false, sortable : false, editrules:{required:true}, editoptions:{maxlength:"100",
	                    																																dataEvents: [{
																															                        	type: 'keydown', 
																															                            fn: function(e){
																																                                var key = e.charCode || e.keyCode;
																																                                if(key == 13 || key == 9){//enter,tab
																																                                	tableId 	= '#itemAddAttributeBase';
																																                                    
																																                                    fv_sd_type 	= "CATALOG_DATA_TYPE";
																																                                    searchItem(this,2,3,item_attr_row_num,item_attr_col);
																															                                	}
																															                            	}
																															                        	}]
						}},
	                    {name:'attribute_data_type_desc',index:'attribute_data_type_desc', width:100, editable:false, sortable : false, editoptions:{maxlength:"60"}},
	                	{name:'attribute_data_min',index:'attribute_data_min', width:30, editable:true, sortable : false, editoptions:{}, editrules:{custom:true, number:true, maxValue:30, custom_func:minMaxCheck}},
	                	{name:'attribute_data_max',index:'attribute_data_max', width:30, editable:true, sortable : false, editoptions:{}, editrules:{custom:true, number:true, maxValue:30, custom_func:minMaxCheck}},
	                	{name:'assy_attribute_code',index:'assy_attribute_code',hidden:true},
	                	{ name : 'attribute_required_flag', index : 'attribute_required_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
						{ name : 'attribute_rf_changed', index : 'attribute_rf_changed', hidden : true },
	                	{name:'oper',index:'oper',hidden:true}
	                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: false,
             autowidth 	: true,
             
             altRows	: false, 
             height		: 300,
             pager		: jQuery('#pitemAddAttributeBase'),
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
			 cellEdit	: true,
	         cellsubmit : 'clientArray',
	         
	         beforeSaveCell : itemAddAttributeBaseEditEnd, 
	         beforeEditCell : function(row_id,colId,val,iRow,iCol){
			 	if(row_id != null) 
                {
               
                	var ret 	= jQuery("#itemAddAttributeBase").getRowData(row_id);
	                
	                item_attr_col 	   = iCol;
	                item_attr_row_num  = iRow;
	                
	                //서택한 attribute
                    fv_attribute_code  = ret.attribute_code;
                    
	                if (item_attr_row != row_id)
	                {
	                	item_attr_row = row_id;
	                	fn_searchItemAddValue();
	                }
                  
                }  
        	 },  
	         loadComplete: function() {
	             
	             if (jQuery("#itemAddAttributeBase").getGridParam("reccount") > 0) {
	             	var ret = jQuery("#itemAddAttributeBase").getRowData(1);
	             	item_attr_row 	  = 1;
	             	fv_attribute_code = ret.attribute_code;    	
				 } else {
				 	item_attr_row	  = 0;
				 	fv_attribute_code = "";
				 }  
				 
				 fn_searchItemAddValue();	
			 },
             gridComplete : function() {
            	 var rows = $( "#itemAddAttributeBase" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#itemAddAttributeBase" ).getCell( rows[i], "oper" );
						if( oper != "D" ) {
							if( oper == "I" ) {
								$( "#itemAddAttributeBase" ).jqGrid( 'setCell', rows[i], 'attribute_code', '', { cursor : 'pointer', background : 'pink' } );
								
							}
							$( "#itemAddAttributeBase" ).jqGrid( 'setCell', rows[i], 'attribute_name', '', {background : '#DADADA' } );
							$( "#itemAddAttributeBase" ).jqGrid( 'setCell', rows[i], 'attribute_data_type', '', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAddAttributeBase" ).jqGrid( 'setCell', rows[i], 'attribute_data_type_desc','', {background : '#DADADA' } );
							
						}
					}
             },
             onCellSelect: function(row_id, colId) {
	           	var cm = $("#itemAddAttributeBase").jqGrid("getGridParam", "colModel");
				var colName = cm[colId];
				var item = $('#itemAddAttributeBase').jqGrid( 'getRowData', row_id );
				if ( colName['index'] == "attribute_code" ) {
					if(item.oper == "I" ){
						var sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=CATALOG_ADDATTR_CODE&catalog_code="+$("input[name=catalog_code]").val();
						var rs   = window.showModalDialog(sUrl,window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off; location=no");
						if (rs != null) {
											
							$('#itemAddAttributeBase').setCell(row_id,'attribute_code',rs[0]); 
							$('#itemAddAttributeBase').setCell(row_id,'attribute_name',rs[1]); 
							
							var item = $('#itemAddAttributeBase').jqGrid('getRowData',row_id);
							if(item.oper != 'I') $($('#itemAddAttributeBase')).setCell(row_id,"oper","U"); 
						}
					}
				}
				if ( colName['index'] == "attribute_name" ) {
                    //searchAttrItem("#itemAddAttributeBase","CATALOG_ATTRIBUTE_NAME", 1,-1,row_id,colId);
				}
				if ( colName['index'] == "attribute_data_type" ) {
					searchItem( "#itemAddAttributeBase", "CATALOG_DATA_TYPE",2,3,row_id, colId);
				}
					
             	if(row_id != null) 
                {
                	var ret = jQuery("#itemAddAttributeBase").getRowData(row_id);
	                            
                    //서택한 attribute
                    fv_attribute_code = ret.attribute_code;
	                
	                if (colId == 0 && ret.oper != "I") jQuery("#itemAddAttributeBase").jqGrid('setCell', row_id, 'attribute_code', '', 'not-editable-cell');
	                
	                if (item_attr_row != row_id)
	                {
	                	item_attr_row = row_id;
	                	fn_searchItemAddValue();	 
	                }
                }
             },
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images'
            
     	}); 
     	
     	$("#itemAddAttributeBase").jqGrid('navGrid',"#pitemAddAttributeBase",{refresh:false,search:false,edit:false,add:false,del:false});
		    
	    $("#itemAddAttributeBase").navButtonAdd('#pitemAddAttributeBase',
			
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteItemAddAttributeBaseRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
		  );
	 	
		 $("#itemAddAttributeBase").navButtonAdd('#pitemAddAttributeBase',
	
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 		
				onClickButton: addItemAddAttributeBaseRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
		 );
     	
     	$("#itemAddValue").jqGrid({ 
	             datatype	: 'json', 
	             mtype		: 'POST', 
	             url		: '',
	             editurl	: '',
	             colNames:['VALUE','사용유무','VALUE1','ENABLE_FLAG','oper'],
	                colModel:[
	                    {name:'value_code',index:'value_code', width:84, sortable : false, editable:true, editrules:{required:true}, editoptions:{}},
	                    {name:'enable_flag',index:'enable_flag', width:40, editable:true, align:"center", sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions: {disabled : false}},
          		        {name:'org_value_code',index:'org_value_code', hidden:true},
          		        {name:'enable_flag_changed',index:'enable_flag_changed',hidden:true},
	                    {name:'oper', index:'oper', hidden:true},
	                ],
	             gridview	: true,
	             cmTemplate: { title: false },
	             toolbar	: [false, "bottom"],
	            
	             viewrecords: true,
	             altRows	: false,
	             height		: 300, 
	             rowNum		: 9999,
	             pager		: '#pitemAddValue',
	             pgbuttons	: false,
				 pgtext		: false,
				 pginput	: false,
				 viewrecords: false,  
				 cellEdit	: true,
	        	 cellsubmit : 'clientArray',
	        	 beforeSaveCell : itemAddValueEditEnd,  
				 beforeEditCell : function(row_id,colId,val,iRow,iCol){
				 	if(row_id != null) 
	                {	                
		                item_value_col 	   = iCol;
		                item_value_row_num = iRow;
	                }  
	        	 }, 
				 
	             jsonReader : {
	                 root: "rows",
	                 page: "page",
	                 total: "total",
	                 records: "records",  
	                 repeatitems: false,
	                },        
	             imgpath: 'themes/basic/images'
	     });
	     
	    $("#itemAddValue").jqGrid('navGrid',"#pitemAddValue",{refresh:false,search:false,edit:false,add:false,del:false});
		    
	    $("#itemAddValue").navButtonAdd('#pitemAddValue',
			
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteItemAddValueRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
		  );
	 	
		 $("#itemAddValue").navButtonAdd('#pitemAddValue',
	
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 		
				onClickButton: addItemAddValueRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
		 );
		 
		$("#btnSave").click(function(){	
			fn_save();
		});
	
	});
	
	function fn_applyData(gridId,nRow,nCol) {
		$(gridId).saveCell(nRow, nCol);
	}
		
	function minMaxCheck(value, colname) {
	
		var id   = jQuery("#itemAddAttributeBase").jqGrid('getGridParam','selrow');
		var item = jQuery("#itemAddAttributeBase").jqGrid('getRowData',id); 
		
		if (colname == "MIN") {
			
			if(item.attribute_data_max != '' && typeof item.attribute_data_max != "undefined"
			   && value != '' && typeof value != "undefined") 
			{
				if ( Number(value) > Number(item.attribute_data_max) ) {
					return [false,"Min value can't be < tha Max value"]; 		 	
				} else {
					return [true,""];
				}
			} else {
				return [true,""];
			} 
		} else if (colname == "MAX") {
	
			if(item.attribute_data_min != '' && typeof item.attribute_data_min != "undefined"
			  && value != '' && typeof value != "undefined") 
			{
				if ( Number(value) < Number(item.attribute_data_min) ) {
					return [false,"Min value can't be < tha Max value"]; 		 	
				} else {
					return [true,""];
				}
			} else {
				return [true,""];
			} 
		}
	}	
	
	function addItemAddAttributeBaseRow(item) {
		fn_applyData("#itemAddAttributeBase",item_attr_row_num,item_attr_col);
		fn_addRow("#itemAddAttributeBase",item);
	}
	
	function deleteItemAddAttributeBaseRow() {
		fn_applyData("#itemAddAttributeBase",item_attr_row_num,item_attr_col);
		fn_deleteRow("#itemAddAttributeBase");
	}
	
	function addItemAddValueRow(item) {
		fn_applyData("#itemAddValue",item_value_row_num,item_value_col);
		fn_addRow("#itemAddValue",item);
	}
	
	function deleteItemAddValueRow() {
		fn_applyData("#itemAddValue",item_value_row_num,item_value_col);
		fn_deleteRow("#itemAddValue");
	}
	
	function fn_addRow(gridId, item) {
		var item = {};
		var colModel = $(gridId).jqGrid('getGridParam', 'colModel');
		for(var i in colModel) item[colModel[i].name] = '';
		
		item.oper = 'I';
		if (gridId == "#itemAddValue") {
			item.enable_flag = 'Y';
		}	
			
		$(gridId).resetSelection();
		$(gridId).jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		
		tableId = gridId;	
	}

	function fn_deleteRow(gridId) {
			
		var selrow = $(gridId).jqGrid('getGridParam', 'selrow');
		var item   = $(gridId).jqGrid('getRowData',selrow);
		
		if(item.oper != 'I') {
			
			item.oper = 'D';
			
			if (gridId == "#itemAddAttributeBase") {
				itemAttributeDeleteData.push(item);
			} else if (gridId == "#itemAddValue") {
				itemValueDeleteData.push(item);
			} 
		}
		
		$(gridId).jqGrid('delRowData', selrow);
		$(gridId).resetSelection();
	}
	
	function getChangedGridInfo(gridId)
	{
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U';
		});
		
		if (gridId == "#itemAddAttributeBase") {
			changedData = changedData.concat(itemAttributeDeleteData);	
		} else if (gridId == "#itemAddValue") {
			changedData = changedData.concat(itemValueDeleteData);
		}
		
		return changedData;
	}
	
	function itemAddAttributeBaseEditEnd(irowId, cellName, value, irow, iCol) {
		
		var item = $('#itemAddAttributeBase').jqGrid('getRowData',irowId);
		if(item.oper != 'I') item.oper = 'U';
		
		// apply the data which was entered.
		$('#itemAddAttributeBase').jqGrid("setRowData", irowId, item);
		// turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");	
	}
	
	function itemAddValueEditEnd(irowId, cellName, value, irow, iCol) {
			
		var item = $('#itemAddValue').jqGrid('getRowData',irowId);
		if(item.oper != 'I') item.oper = 'U';
		
		// apply the data which was entered.
		$('#itemAddValue').jqGrid("setRowData", irowId, item);
		// turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}
	
	function fn_search()
	{
		jQuery("#itemAddAttributeBase").jqGrid('setGridParam',{url:"infoItemAddAttribute.do"
															  ,page:1
															  ,postData : {
																			gbn			    : '11',
																			catalog_code    : $("input[name=catalog_code]").val(),
																		  }
		}).trigger("reloadGrid");
		
		deleteArrayClear("all");	
	}
	
	function fn_searchItemAddValue()
	{
		
		jQuery("#itemAddValue").jqGrid('setGridParam',{url:"infoItemAddValue.do"
													  ,page:1
													  ,postData : {
													 			    gbn			    : '12',
																	catalog_code    : $("input[name=catalog_code]").val(),
																	attribute_code  : fv_attribute_code,
																	value_code		: ''
																  }
		}).trigger("reloadGrid");
		
		deleteArrayClear("itemAddValue");		
	}
	
	function deleteArrayClear(gbn)
	{
		// 전부 삭제한다.
		if (gbn == "all") {
			if (itemAttributeDeleteData.length  > 0) 	itemAttributeDeleteData.splice(0, 	 itemAttributeDeleteData.length);
		}
		
		if (gbn == "all" || gbn == "itemAddValue") {
			if (itemValueDeleteData.length      > 0) 	itemValueDeleteData.splice(0, 	 itemValueDeleteData.length);
		}
	}
	
	//물성치 조회
	function searchItem( p_tableId, p_sdType, nCode,nData,nRow,nCol){
	    
	    //searchIndex = $(obj).closest('tr').get(0).id;
	  	
	  	//fn_applyData(tableId,nRow,nCol);
		
		var sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type="+p_sdType+"&catalog_code="+$("input[name=catalog_code]").val();
		
		if (fv_sd_type == "CATALOG_ADDATTR_CODE") {
			sUrl = sUrl + "&table_id=itemAddAttributeBase";
		}		
		
		var rs   = window.showModalDialog(sUrl,window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off; location=no");
	
		if (rs != null) {
							
			$(p_tableId).setCell(nRow,nCode,rs[0]); 
			$(p_tableId).setCell(nRow,nData,rs[1]); 
			
			var item = $(p_tableId).jqGrid('getRowData',nRow);
			if(item.oper != 'I') $(p_tableId).setCell(nRow,"oper","U"); 
		}
		
	}
	
	//항목 조회
	function searchAttrItem( p_tableId, p_sdType,nCode,nData,nRow,nCol){
	    
	    //searchIndex = $(obj).closest('tr').get(0).id;
	  
	  	//fn_applyData(tableId,nRow,nCol);
	  	
	  	var sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type="+p_sdType+"&table_id=additem";
	  
		var rs  = window.showModalDialog(sUrl,window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");
	
		if (rs != null) {
							
			$(p_tableId).setCell(nRow,nCode,rs[0]); 
		
			var item = $(p_tableId).jqGrid('getRowData',nRow);
			if(item.oper != 'I') $(p_tableId).setCell(nRow,"oper","U"); 
		}
	}
	
	function fn_save()
	{
		
		//$('#catalogMain').saveCell(2, catalog_col);
		fn_applyData("#itemAddAttributeBase",item_attr_row_num,item_attr_col);
		fn_applyData("#itemAddValue",item_value_row_num,item_value_col);
				
		var changedDataBase = $("#itemAddAttributeBase").jqGrid('getDataIDs');
		var changedData = $("#itemAddValue").jqGrid('getDataIDs');
		
		// 변경된 체크 박스가 있는지 체크한다.
		for(var i=0; i<changedDataBase.length; i++)
		{
			var item = $('#itemAddAttributeBase').jqGrid('getRowData', changedDataBase[i]);	
			
			if ( item.oper != 'I' && item.oper != 'U' ) {
			
				if(item.attribute_required_flag != item.attribute_rf_changed){
					item.oper = 'U';
				} else {
					item.oper = '';
				}
				// apply the data which was entered.
				$('#itemAddAttributeBase').jqGrid("setRowData", changedDataBase[i], item);
				//turn off editing.
				$("input.editable,select.editable", this).attr("editable", "0");
			}	
		}
		
		// 변경된 체크 박스가 있는지 체크한다.
		for(var i=0; i<changedData.length+1; i++)
		{
			var item = $('#itemAddValue').jqGrid('getRowData', changedData[i]);	
			
			if ( item.oper != 'I' && item.oper != 'U' ) {
			
				if(item.enable_flag_changed != item.enable_flag){
					item.oper = 'U';
				}
								
				if (item.oper == 'U') {
					// apply the data which was entered.
					$('#itemAddValue').jqGrid("setRowData", changedData[i], item);
					//turn off editing.
					$("input.editable,select.editable", this).attr("editable", "0");
				}
			}	
		}
				
		var itemAddAttributeBaseResultRows = getChangedGridInfo("#itemAddAttributeBase");
		var itemAddValueResultRows 		   = getChangedGridInfo("#itemAddValue");
		
		if (!fn_checkCatalogValidate(itemAddAttributeBaseResultRows,itemAddValueResultRows)) 
		{ 
			//lodingBox.remove();
			return;	
		}
		
		var url			= "saveItemAddAttribute.do";
		var dataList    = {itemAttributeBaseList:JSON.stringify(itemAddAttributeBaseResultRows),
			               itemValueList:JSON.stringify(itemAddValueResultRows),
			               catalog_code:$("input[name=catalog_code]").val()};
		
		var sertData = fn_getSelectRowData();
		
		lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
		var parameters = $.extend({},dataList,sertData);
				
		$.post(url, parameters, function(data) {
				
				lodingBox.remove();
				alert(data.resultMsg);
				fn_search();
			
			});
				
		/*	
		getChangedCatalogResultData(function(data){
						
			var dataList  = {
			                 itemAttributeBaseList:JSON.stringify(itemAttributeBaseResultRows),
			                 itemValueList:JSON.stringify(itemValueResultRows),
						    };
		
			var sertData = fn_getSelectRowData();
			
			
			var url = 'saveCatalogMgnt.do';
			
			var formData = getFormData('#listForm');
			
			var parameters = $.extend({},dataList,formData);
			parameters = $.extend({},parameters,sertData);
			
			$.post(url, parameters, function(data) {
				
				lodingBox.remove();
				
				var msg 	= "";
				var result	= "";
				
				for(var keys in data)
				{
					for(var key in data[keys])
					{
						if(key=='Result_Msg')
						{
							msg=data[keys][key];
						}
						
						if(key=='result')
						{
							result=data[keys][key];
						}
					}
				}
				
				//NProgress.done(); 
				alert(msg);
				
				if (result == "success") {
					// 삭제 데이터 클리어
					//deleteArrayClear("all");
					
					// 재조회
					fn_search();
				}	
			}, 'json');
		});*/
	}
	
	function fn_checkCatalogValidate(arr1, arr2)
	{
		var result   = true;
		var message  = "";
		var ids ;
		
		var sertData = fn_getSelectRowData();		
		
		if (arr1.length > 0 || arr2.length > 0 )
		{
			
			if ( typeof sertData.catalog_code == 'undefined' || $.jgrid.isEmpty(sertData.catalog_code) ) {
				result  = false;
				message = "Catalog Code is selected";
			}
			
		} else {
			result  = false;
			message = "변경된 내용이 없습니다.";	
		}
	
		if (arr2.length > 0) {
			if ( typeof sertData.attribute_code == 'undefined' || $.jgrid.isEmpty(sertData.attribute_code) ) {
				result  = false;
				message = "Item부가속성 물성치 is selected";
			}
		}
		
		if (result && arr1.length > 0) {
			
			ids = $("#itemAddAttributeBase").jqGrid('getDataIDs');
		
			for(var  i = 0; i < ids.length; i++) {
				
				var oper = $("#itemAddAttributeBase").jqGrid('getCell', ids[i], 'oper');
			
				if (oper == 'I' || oper == 'U') {
					
					var val1 = $("#itemAddAttributeBase").jqGrid('getCell', ids[i], 'attribute_code');
					
					if ($.jgrid.isEmpty(val1)) {
						result  = false;
						message = "Item부가속성의 물성치 Field is required";
						
						setErrorFocus("#itemAddAttributeBase",ids[i],0,'attribute_code');
						break;
					}
				}
				/*
				if ($.jgrid.isEmpty(arr4[i].item_attribute_code)) {
					result  = false;
					message = "Item속성의 물성치 Field is required";
					break;
				}*/
			}
		}
		
		if (result && arr2.length > 0) {
			
			ids = $("#itemAddValue").jqGrid('getDataIDs');
			
			for(var  i = 0; i < ids.length; i++) {
				
				var oper = $("#itemAddValue").jqGrid('getCell', ids[i], 'oper');
			
				if (oper == 'I' || oper == 'U') {
					
					var val1 = $("#itemAddValue").jqGrid('getCell', ids[i], 'value_code');
					
					if ($.jgrid.isEmpty(val1)) {
						result  = false;
						message = "Item부가속성의 Value Field is required";
						
						setErrorFocus("#itemAddValue",ids[i],0,'value_code');
						break;
					}
				}
				
				/*
				if ($.jgrid.isEmpty(arr5[i].item_value_code)) {
					result  = false;
					message = "Item속성의 Value Field is required";
					break;
				}*/
			}
		}
		
		if (!result) {
			alert(message);
		}
		
		return result;	
	}
	
	// 포커스 이동
	function setErrorFocus(gridId, rowId, colId, colName)
	{
		$("#" + rowId + "_"+colName).focus();
		$(gridId).jqGrid('editCell', rowId, colId, true);
	}
		
	function fn_getSelectRowData()
	{
	
		var ret 		  = jQuery("#itemAddAttributeBase").getRowData(item_attr_row);
		fv_attribute_code = ret.attribute_code;
				
		var selectData = { catalog_code	   : $("input[name=catalog_code]").val(),
						   attribute_code  : fv_attribute_code };
						  			  
		return selectData;
	}
		
</script>
</body>
</html>