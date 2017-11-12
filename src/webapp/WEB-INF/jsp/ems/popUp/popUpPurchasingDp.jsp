<%--*************************************
@DESCRIPTION				: Ems Db(Main)
@AUTHOR (MODIFIER)			: Hwang Sung Jun
@FILENAME					: tbc_EmsDbMain.jsp
@CREATE DATE				: 2015-02-12
*************************************--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.headerBD {position:relative; width:1500px; height:25px; margin:0 0 27px 4px;}			
			.searchDetail1 {float:left; font-weight:bold; margin:2px;}
			.uniqInput1 {width:200px; margin-right:2px;}
			.uniqInput2 {width:450px; margin-right:2px;}
			.buttonInput{float:right; width:60px; margin:2px;}
			.content {position:relative; margin-left:4px; width:1500px; height:395px; text-align:center; overflow-x:auto; }
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}
			.ui-jqgrid .ui-jqgrid-hdiv {position: relative; margin: 0;padding: 0; overflow-x: hidden; border-left: 0 none !important; border-top : 0 none !important; border-right : 0 none !important;}
			.ui-jqgrid .ui-jqgrid-hbox {float: left; padding-right: 20px;}
			.ui-jqgrid .ui-jqgrid-htable {table-layout:fixed;margin:0;}
			.ui-jqgrid .ui-jqgrid-htable th {height:25px;padding: 3px 2px 0 2px;}
		</style>
	</head>

	<title>
		EMS(Equipment Management System) Purchasing DP.
	</title>

	<body oncontextmenu="return false">
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="pageYn" id="pageYn" value="N">
			<input type="hidden" name="p_userId" id="p_userId" value="${UserId}">
			<input type="hidden" name="p_master"   id="p_master" value="${p_master}"/>
			<input type="hidden" name="p_dwg_nos"   id="p_dwg_nos" value="${p_dwg_nos}"/>
			<input type="hidden" name="p_projects"   id="p_projects" value="${p_projects}"/>
			<input type="hidden" id="p_col_name" name="p_col_name" value="" />
			<input type="hidden" id="p_data_name" name="p_data_name" value="" />
			<input type="hidden" id="page" name="page" value="" />
			<input type="hidden" id="rows" name="rows" value="" />
						

			<div class="headerBD">
			<table>
				<tr>
					<td width="1300px">
						<div class="searchDetail1">
							<input type="text" class="disablefield" id="" name="" value="PROJECT" style="width:80px;text-align:center;font-weight:bold;" readonly="readonly" />
							<input type="text" class="uniqInput1" name="p_project" value="${p_projects}" style="width:40px;" onkeyup="fn_all_text_upper()" />
						</div>										
						<div class="searchDetail1">
							<input type="text" class="disablefield" id="" name="" value="DWG NO. " style="width:80px;text-align:center;font-weight:bold;" readonly="readonly" />
							<input type="text" class="uniqInput2" name="p_dwg_no" value="${p_dwg_nos}" style="width:70px;" onkeyup="fn_all_text_upper()" />
						</div>						
					</td>
					<td width="200px">			
						<div class="button endbox" style="height:40px">							
							<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/>
							<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
<!-- 							<input type="button" class="btn_blue" value="닫기" id="btnClose"/>							 -->
						</div>
					</td>
				</tr>
			</table>
			</div>

			<div class="content">
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
                gridColModel.push({label:'PR NO.',				name:'pr_no'			, index:'pr_no'				,width:60	,align:'center', formatter:formatOpt1, sortable:false});
                gridColModel.push({label:'PO NO.',				name:'po_no'			, index:'po_no'				,width:60	,align:'center', formatter:formatOpt1, sortable:false});
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
				
				$("#itemTransList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpPurchasingDpList.do',
		             postData : getFormData('#application_form'),
		             colModel:gridColModel,
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 0,
		             height: 325,
		             pager: jQuery('#btnitemTransList'),
		             rowList:[100,500,1000],
			         rowNum:100, 
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

			});
			
			//######## 조회 버튼 클릭 시 ########//
			$("#btnSearch").click(function(){
				
// 				$("#itemTransList").jqGrid("clearGridData");
								
				var sUrl = "popUpPurchasingDpList.do";

				$( "#itemTransList" ).jqGrid( 'setGridParam', {
					mtype : 'POST',
					url : sUrl,
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );

			});
			
			//########  Export버튼 ########//
			$("#btnExport").click(function(){
				
				//그리드의 label과 name을 받는다.
				//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
				var colName = new Array();
				var dataName = new Array();
				
				for(var i=0; i<gridColModel.length; i++ ){
					if(gridColModel[i].hidden){
						continue;
					}
					colName.push(gridColModel[i].label);
					dataName.push(gridColModel[i].name);
				}
				
				form = $('#application_form');

				$("input[name=p_is_excel]").val("Y");
				//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
				
				$("#p_col_name").val(colName);
				$("#p_data_name").val(dataName);
				$("#rows").val($("#itemTransList").getGridParam("rowNum"));
				$("#page").val($("#itemTransList").getGridParam("page"));
				
				fn_downloadStart();
				form.attr("action", "emsPurchasingDPExcelExport.do");
				
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			});
			
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				window.close();					
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
			
			//######## Input text 부분 숫자만 입력 ########//
			function onlyNumber(event) {
			    var key = window.event ? event.keyCode : event.which;    
			
			    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
			    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
			    || key  == 8  || key  == 46 ) // del, back space
			    ) {
			        return true;
			    }else {
			        return false;
			    }    
			};
			
			//폼데이터를 Json Arry로 직렬화
			function getFormData(form) {
			    var unindexed_array = $(form).serializeArray();
			    var indexed_array = {};
				
			    $.map(unindexed_array, function(n, i){
			        indexed_array[n['name']] = n['value'];
			    });
				
			    return indexed_array;
			}
			
			//STATE 값에 따라서 checkbox 생성
			function formatOpt1(cellvalue, options, rowObject){
				
				var str = "";
				if(Math.floor(cellvalue) != 0) {
					str = Math.floor(cellvalue);
				} 
		   		
		   		return str;
		 	 
			}			

		</script>
	</body>
</html>