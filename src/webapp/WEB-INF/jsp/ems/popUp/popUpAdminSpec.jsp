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
			.headerBD {position:relative; width:1100px; height:25px; margin:0 0 27px 4px;}			
			.searchDetail1 {float:left; font-weight:bold; margin:2px;}
			.uniqInput {width:85px; margin-right:2px;}
			.buttonInput{float:right; width:60px; margin:2px;}
			
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}
		</style>
	</head>

	<title>
		EMS(Equipment Management System) Purchasing Spec Rev.
	</title>

	<body oncontextmenu="return false">
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="pageYn" id="pageYn" value="N">
			<input type="hidden" name="p_userId" id="p_userId" value="${UserId}">
			<input type="hidden" name="p_daoName"   id="p_daoName" value=/>
			<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
			<input type="hidden" name="p_process"   id="p_process" value=""/>
			<input type="hidden" name="p_master"   id="p_master" value="${p_master}"/>
			<input type="hidden" name="p_dwg_no"   id="p_dwg_no" value="${p_dwg_no}"/>

			<div class="headerBD">
			<table>
				<tr>
					<td width="95%">&nbsp;</td>
					<td width="5%">			
						<div class="buttonArea">							
							<input type="button" class="btn_blue" value="닫기" id="btnClose"/>						
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

			$(document).ready(function(){
				
				$("#itemTransList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpAdminSpecList.do',
		             postData : getFormData('#application_form'),
		             colNames:['MASTER','PROJECT','DWG No.','MODEL','업체명','REV.','첨부','접수일','첨부','회신일','FLAG','COMMENT','file1','file2','file3','file4','file5','file6','file7','file8','file9','file10','file11','file12','file13','file14','file15','file16','file17','file18','file19','file20','NO'],
	                 colModel:[
	                	{name:'master'			, index:'master'		,width:50	,align:'center', sortable:false},
	                	{name:'project'			, index:'project'		,width:50	,align:'center', sortable:false},
	                	{name:'dwg_no'			, index:'dwg_no'		,width:50	,align:'center', sortable:false},
	                    {name:'model'			, index:'model'			,width:140	,align:'left', sortable:false},
	                    {name:'corp_name'		, index:'corp_name'		,width:140	,align:'left', sortable:false},
	                    {name:'rev'				, index:'rev'			,width:30	,align:'center', formatter:formatOpt1, sortable:false},
	                    {name:'receipt_file'	, index:'receipt_file'	,width:40	,align:'left', formatter:formatOpt3, sortable:false},
	                    {name:'receipt_date'	, index:'receipt_date'	,width:60	,align:'center', sortable:false},
	                    {name:'answer_file'		, index:'answer_file'	,width:40	,align:'left', formatter:formatOpt4, sortable:false},
	                    {name:'answer_date'		, index:'answer_date'	,width:60	,align:'center', sortable:false},
	                    {name:'flag2'			, index:'flag2'			,width:50	,align:'center', sortable:false},
	                    {name:'comments2'		, index:'comments2'		,width:100	,align:'left', sortable:false},
	                    {name:'file1'			, index:'file1'			,width:50	,align:'center', hidden:true},
	                    {name:'file2'			, index:'file2'			,width:50	,align:'center', hidden:true},
	                    {name:'file3'			, index:'file3'			,width:50	,align:'center', hidden:true},
	                    {name:'file4'			, index:'file4'			,width:50	,align:'center', hidden:true},
	                    {name:'file5'			, index:'file5'			,width:50	,align:'center', hidden:true},
	                    {name:'file6'			, index:'file6'			,width:50	,align:'center', hidden:true},
	                    {name:'file7'			, index:'file7'			,width:50	,align:'center', hidden:true},
	                    {name:'file8'			, index:'file8'			,width:50	,align:'center', hidden:true},
	                    {name:'file9'			, index:'file9'			,width:50	,align:'center', hidden:true},
	                    {name:'file10'			, index:'file10'		,width:50	,align:'center', hidden:true},
	                    {name:'file11'			, index:'file11'		,width:50	,align:'center', hidden:true},
	                    {name:'file12'			, index:'file12'		,width:50	,align:'center', hidden:true},
	                    {name:'file13'			, index:'file13'		,width:50	,align:'center', hidden:true},
	                    {name:'file14'			, index:'file14'		,width:50	,align:'center', hidden:true},
	                    {name:'file15'			, index:'file15'		,width:50	,align:'center', hidden:true},
	                    {name:'file16'			, index:'file16'		,width:50	,align:'center', hidden:true},
	                    {name:'file17'			, index:'file17'		,width:50	,align:'center', hidden:true},
	                    {name:'file18'			, index:'file18'		,width:50	,align:'center', hidden:true},
	                    {name:'file19'			, index:'file19'		,width:50	,align:'center', hidden:true},
	                    {name:'file20'			, index:'file20'		,width:50	,align:'center', hidden:true},
	                    {name:'spec_review_id'	, index:'spec_review_id',width:50	,align:'center', hidden:true}
	                  ],
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 0,
		             height: 265,
		             pager: jQuery('#btnitemTransList'),
		             rowList:[100,500,1000],
			         rowNum:100,
			         useColSpanStyle: true, 
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
					        
					        $this.jqGrid('setGroupHeaders', {
					            useColSpanStyle: true,
					            groupHeaders : [
		             				{startColumnName:'receipt_file',numberOfColumns:2,titleText:'설계 접수'},
		             				{startColumnName:'answer_file',numberOfColumns:2,titleText:'설계 회신'}
		             			]
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
			
			//######## Apply 버튼 클릭 시 ########//
			$("#btnApply").click(function(){
				alert("작업중");
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
				str = Math.floor(cellvalue);		   		
		   		return str;
		 	 
			}	
			
			function formatOpt3(cellvalue, options, rowObject){
				var str = "";
				var file1 = Math.floor(rowObject.file1);
				var file2 = Math.floor(rowObject.file2);
				var file3 = Math.floor(rowObject.file3);
				var file4 = Math.floor(rowObject.file4);
				var file5 = Math.floor(rowObject.file5);
				var file6 = Math.floor(rowObject.file6);
				var file7 = Math.floor(rowObject.file7);
				var file8 = Math.floor(rowObject.file8);
				var file9 = Math.floor(rowObject.file9);
				var file10 = Math.floor(rowObject.file10);
				var receipt_date = rowObject.receipt_date;
				
				if(file1 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file1+"');\"/>"
				}
				if(file2 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file2+"');\"/>"
				}
				if(file3 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file3+"');\"/>"
				}
				if(file4 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file4+"');\"/>"
				}
				if(file5 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file5+"');\"/>"
				}
				if(file6 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file6+"');\"/>"
				}
				if(file7 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file7+"');\"/>"
				}
				if(file8 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file8+"');\"/>"
				}
				if(file9 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file9+"');\"/>"
				}
				if(file10 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file10+"');\"/>"
				}
				//str += receipt_date;
		   		
		   		return str;
		 	 
			}
			
			function formatOpt4(cellvalue, options, rowObject){
				var str = "";
				var file1 = Math.floor(rowObject.file11);
				var file2 = Math.floor(rowObject.file12);
				var file3 = Math.floor(rowObject.file13);
				var file4 = Math.floor(rowObject.file14);
				var file5 = Math.floor(rowObject.file15);
				var file6 = Math.floor(rowObject.file16);
				var file7 = Math.floor(rowObject.file17);
				var file8 = Math.floor(rowObject.file18);
				var file9 = Math.floor(rowObject.file19);
				var file10 = Math.floor(rowObject.file20);
				var answer_date = rowObject.answer_date;
				
				if(file1 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file1+"');\"/>"
				}
				if(file2 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file2+"');\"/>"
				}
				if(file3 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file3+"');\"/>"
				}
				if(file4 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file4+"');\"/>"
				}
				if(file5 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file5+"');\"/>"
				}
				if(file6 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file6+"');\"/>"
				}
				if(file7 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file7+"');\"/>"
				}
				if(file8 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file8+"');\"/>"
				}
				if(file9 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file9+"');\"/>"
				}
				if(file10 > 0) {
					str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file10+"');\"/>"
				}
				//str += answer_date;
		   		
		   		return str;
		 	 
			}
			
			function fileView(file_id) {
				
				url = "popUpAdminSpecDownloadFile.do?p_file_id="+file_id;				
			
				var nwidth = 800;
				var nheight = 700;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
				window.open(url,"",sProperties);
			}			

		</script>
	</body>
</html>