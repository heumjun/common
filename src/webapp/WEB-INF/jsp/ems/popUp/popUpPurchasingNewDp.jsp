<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>
			EMS(Equipment Management System) Purchasing DP.
		</title>
	</head>
	
	<body>
		<form id="application_form" name="application_form" >
			
			<input type="hidden" name="pageYn" id="pageYn" value="N"/>
			<input type="hidden" name="p_userId" id="p_userId" value="${UserId}"/>
			<input type="hidden" name="p_master"   id="p_master" value="${p_master}"/>
			<input type="hidden" name="p_dwg_nos"   id="p_dwg_nos" value="${p_dwg_nos}"/>
			<input type="hidden" name="p_projects"   id="p_projects" value="${p_projects}"/>
			<input type="hidden" id="p_col_name" name="p_col_name" value="" />
			<input type="hidden" id="p_data_name" name="p_data_name" value="" />
			<input type="hidden" id="page" name="page" value="" />
			<input type="hidden" id="rows" name="rows" value="" />
			<input type="hidden" name="p_project" value="${p_projects}"/>			
			<input type="hidden" name="p_dwg_no" value="${p_dwg_nos}"/>

			<div style="text-align: right;">
				<input type="button" class="btn_blue2" value="CLOSE" id="btnClose"/>
			</div>

			<div class="content" id="itemTransListDiv">
				<table id="itemTransList"></table>
				<div id="btnitemTransList"></div>
			</div>
		</form>
		<script type="text/javascript" >

			function getMainGridColModel(){
	
				var gridColModel = new Array();
				
				gridColModel.push({label:'PROJECT',				name:'project'			, index:'project'			,width:50	,align:'center', sortable:false});
            	gridColModel.push({label:'DWG No.',				name:'dwg_no'			, index:'dwg_no'			,width:50	,align:'center', sortable:false});
            	gridColModel.push({label:'부서',				name:'dept_name'		, index:'dept_name'			,width:120	,align:'center', sortable:false});
                gridColModel.push({label:'작업자',				name:'created_by'		, index:'created_by'		,width:80	,align:'center', sortable:false});
                gridColModel.push({label:'업체명',				name:'corp_name'		, index:'corp_name'			,width:120	,align:'left', sortable:false});
                gridColModel.push({label:'조달담당자',			name:'obtain_by'		, index:'obtain_by'			,width:80	,align:'center', sortable:false});
                gridColModel.push({label:'PR NO.',				name:'pr_no'			, index:'pr_no'				,width:60	,align:'center', sortable:false});
                gridColModel.push({label:'PO NO.',				name:'po_no'			, index:'po_no'				,width:60	,align:'center', sortable:false});
                gridColModel.push({label:'PR발행계획일자',		name:'pr_plan_date'	, index:'pr_plan_date'		,width:110	,align:'center', sortable:false});
                gridColModel.push({label:'PR승인일자',			name:'pr_ap_date'		, index:'pr_ap_date'		,width:110	,align:'center', sortable:false});
                gridColModel.push({label:'PO발행계획일자',		name:'po_plan_date'	, index:'po_plan_date'		,width:110	,align:'center', sortable:false});
                gridColModel.push({label:'PO승인일자',			name:'po_ap_date'		, index:'po_ap_date'		,width:110	,align:'center', sortable:false});
                gridColModel.push({label:'승인도 접수일자',		name:'receive_act_date', index:'receive_act_date'	,width:110	,align:'center', sortable:false});
                gridColModel.push({label:'승인도 승인일자',		name:'approve_date'	, index:'approve_date'		,width:110	,align:'center', sortable:false, hidden:true});
	
				return gridColModel;
			}
		
			var gridColModel = getMainGridColModel();
			
			$(document).ready(function(){
				var objectHeight = gridObjectHeight(1);	
				$("#itemTransList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpPurchasingNewDpList.do',
		             postData : getFormData('#application_form'),
		             colModel:gridColModel,
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             height: objectHeight,
		             pager: jQuery('#btnitemTransList'),
		             rowNum : -1,
		             pgbuttons: false,
		             pgtext: null,
					 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		             	idRow=rowid;
		             	idCol=iCol;
		             	kRow = iRow;
		             	kCol = iCol;
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
					 },
		     	}); //end of jqGrid
				//jqGrid 크기 동적화
				resizeJqGridWidth( $(window), $( "#itemTransList" ), $( "#itemTransListDiv" ), 0.7);
				//########  닫기버튼 ########//
				$("#btnClose").click(function(){
					window.close();					
				});	
			});
			
			

			//######## 메시지 Call ########//
			var afterDBTran = function(json){

			 	var msg = "";
				for(var keys in json)
				{
					for(var key in json[keys])
					{
						if(key=='Result_Msg')
						{
							msg=json[keys][key];
						}
					}
				}
				alert(msg);
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
		</script>
	</body>
</html>