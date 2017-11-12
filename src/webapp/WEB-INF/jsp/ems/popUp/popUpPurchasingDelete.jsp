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
			.headerBD {position:relative; width:1500px; text-align:right; height:30px; }
		</style>
		<title>
			EMS(Equipment Management System) Purchasing Delete.
		</title>
	</head>

	
	<body oncontextmenu="return false">
		<form id="application_form" name="application_form">
		
			<input type="hidden" name="p_daoName" value="" />
			<input type="hidden" name="p_queryType" value="" />
			<input type="hidden" name="p_process" value="" />
			<input type="hidden" name="p_Reason"   id="p_Reason" value=""/>
			<input type="hidden" name="p_flag"   id="p_flag" value=""/>
			<input type="hidden" name="p_pr_state"   id="p_pr_state" value=""/>
			<input type="hidden" name="p_pos_flag"   id="p_pos_flag" value=""/>
			<input type="hidden" name="p_ems_pur_no" id="p_ems_pur_no" value="${p_ems_pur_no}" />
			<input type="hidden" id="p_pd_cnt" name="p_pd_cnt" value="${listSize}" />
			<input type="hidden" name="busi_type" id="busi_type" value="D" />
			
			
			
			
			<div id="hiddenArea"></div>
			<div id="cntPos"></div>
			<div style="margin: 15px 10px">
				<div class="endbox" >
					사유 : <input type="text" name="p_remark" size="20"/>
					<input type="button" class="btn_blue" value="POS" id="btnPos" style="size: 60px;"/>
					<input type="button" class="btn_blue" value="DELETE" id="btnDelete" style="size: 60px;"/>
					<input type="button" class="btn_blue" value="CLOSE" id="btnClose" style="size: 60px;"/>				
				
				</div>
			</div>
			<div class="content">
				<table id="itemTransList"></table>
				<div id="btnitemTransList"></div>
			</div>
		</form>
		
		<%-- <jsp:include page="popUpPurchasingPos.jsp" flush="false"></jsp:include> --%>
		
		<script type="text/javascript" >

			$(document).ready(function(){
				$("#itemTransList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpPurchasingDeleteList.do',
		             postData : getFormData('#application_form'),
		             colNames:['STATE','MASTER','PROJECT','DWG NO.','DWG DESCRIPTION','ITEM CODE','ITEM DESCRIPTION','EA','부서','작업자','조달담당자','결재자','PR','PR_NO','사양','PO','BOM','DATE','사유','FILEID', 'ems_pur_no'],
	                 colModel:[
	                	{name:'status'			, index:'status'				,width:40	,align:'center', sortable:false},
	                	{name:'master'			, index:'master'				,width:50	,align:'center', sortable:false},
	                    {name:'project'			, index:'project'				,width:50	,align:'center', sortable:false},
	                    {name:'dwg_no'			, index:'dwg_no'				,width:60	,align:'center', sortable:false},
	                    {name:'dwg_desc'		, index:'dwg_desc'				,width:300	,align:'left', sortable:false},
	                    {name:'item_code'		, index:'item_code'				,width:100	,align:'center', sortable:false},
	                    {name:'item_desc'		, index:'item_desc'				,width:300	,align:'left', sortable:false},
	                    {name:'ea'				, index:'ea'					,width:20	,align:'center', formatter:'integer', sortable:false},
	                    {name:'dept_name'		, index:'dept_name'				,width:110	,align:'center', sortable:false},
	                    {name:'created_by'		, index:'created_by'			,width:70	,align:'center', sortable:false},
	                    {name:'obtain_by'		, index:'obtain_by'				,width:90	,align:'center', sortable:false},
	                    {name:'approved_by'		, index:'approved_by'			,width:70	,align:'center', sortable:false},
	                    {name:'pr_state'		, index:'pr_state'				,width:110	,align:'center', formatter:formatOpt3, sortable:false},
	                    {name:'pr_no'			, index:'pr_no'					,width:10	,align:'center', sortable:false, hidden:true},
	                    {name:'spec_state'		, index:'spec_state'			,width:25	,align:'center', sortable:false},
	                    {name:'po_state'		, index:'po_state'				,width:20	,align:'center', sortable:false},
	                    {name:'bom_state'		, index:'bom_state'				,width:30	,align:'center', sortable:false},
	                    {name:'creation_date'	, index:'creation_date'			,width:80	,align:'center', sortable:false},
	                    //{name:'pos'				, index:'pos'					,width:150	,align:'left', formatter:formatOpt2, sortable:false,  hidden:true},
	                    {name:'remark'			, index:'remark'				,width:80	,align:'center', editable:true, edittype:"text",  hidden:true},
	                    {name:'file_id'			, index:'file_id'				,width:80	,align:'center', sortable:false, hidden:true},
	                    {name:'ems_pur_no'		, index:'ems_pur_no'			,width:80	,align:'center', sortable:false, hidden:true},
	                 ],
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 0,
		             shrinkToFit:false,
		             height: 570,
		             pager: jQuery('#btnitemTransList'),
		             cellEdit: true,
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
						$(this).jqGrid("clearGridData");
			 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
					 },
					 onCellSelect: function(row_id,icol,cellcontent,e) {
					 	if(row_id != null) {
					 		if(icol = 19) {
								$(this).editRow(row_id, true);
							}  
                        }
					 },		
		   			 loadComplete: function (data) {
					    var $this = $(this);
					    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
					        $this.jqGrid('setGridParam', {
					            datatype: 'local',
					            data: data.rows,
					            pageServer: data.page,
					            recordsServer: data.records,
					            lastpageServer: data.total
					        });
					        this.refreshIndex();					
					        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
			
			//########  POS 버튼 ########//
			//POS 개정 이후 DELETE 작업 진행 가능
			$("#btnPos").click(function(){
				
				var mst = "";
				var dwgno = "";
				var master = "";
				var dwg_no = "'";
				
				//jqGrid의 rowData를 받아옴.					
				var listData = $.grep( $( "#itemTransList" ).jqGrid( 'getRowData' ), function( obj ) {
					return true;
				} );

				var vHtmlStr = "";
				var pur_no = "";
				for(var i=0; i<listData.length; i++){
 				   		
 					
					//아이템 코드는 ',' 이용해서 붙임.
					if(i > 0){
						pur_no += ",";
					}
					pur_no += Math.floor(listData[i].ems_pur_no);
				}
				
				vHtmlStr += "<input type='hidden' name='master' value='"+listData[0].master+"'/>";
				vHtmlStr += "<input type='hidden' name='p_dwg_no' value='"+listData[0].dwg_no+"'/>";		
				vHtmlStr += "<input type='hidden' name='p_pur_no' value='"+pur_no+"'/>";
				//Form에 만들어준 hidden 태그들을 추가.

				$("#hiddenArea").html(vHtmlStr);
				
				/* $("#gridPosList").jqGrid("clearGridData"); */
				
				var sUrl = "popUpPurchasingPos.do";
				
				var nwidth = 1020;
				var nheight = 290;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
			
				form = $('#application_form');			
				form.attr("action", sUrl);		
					
				var popWin = window.open("","posPopup",sProperties);
				
				$("input[name=p_daoName]").val("");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("");
				
					
				form.attr("target","posPopup");
				form.attr("method", "post");	
		
				popWin.focus();
				form.submit();
				
				/* jQuery("#gridPosList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData: getFormData('#application_form')}).trigger("reloadGrid"); */
		
	
			});
			
			//########  Delete 버튼 ########//
			$("#btnDelete").click(function(){
				var ems_pur_no = $("input[name=p_ems_pur_no]").val();
				var del_no = $("input[name=p_pd_cnt]").val();
				var del_reason = "";
				
				if($("#p_pos_flag").val() == ""){
					alert("POS 개정이력 등록 이후 진행할 수 있습니다.");
					return false;
				}
				
				//for(var i = 0; i < del_no.length; i++) {
				//	del_reason = $('#'+(i+1)+'_remark').val();
				//	if(del_reason == "") {
				//		alert("삭제 사유를 입력하여 주십시오.");
				//		return;
				//	}
				//}
				
				
				if($("input[name=p_remark]").val() == ""){
					alert("사유를 입력해주십시오.");
					return;
				}
				
				if(confirm("삭제하시겠습니까?")) {
					//필수 파라미터 S
					$("input[name=p_daoName]").val("EMS_PURCHASING");
					$("input[name=p_queryType]").val("update");
					$("input[name=p_process]").val("mod_flag_d");
					
					$("input[name=p_ems_pur_no]").val(ems_pur_no);
					$("input[name=p_flag]").val("D");
					$("input[name=p_pr_state]").val("");
					
					var sUrl="emsPurchasingDeleteS.do";

					var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
					$.post(sUrl,$("#application_form").serialize(),function(json)
					{
						afterDBTran(json);
						loadingBox.remove();
					},"json");
				}
			});
				
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				window.close();					
			});

			//######## 메시지 Call ########//
			var afterDBTran = function(json){
				$(".loadingBoxArea").hide();
			 	var msg = "";

				alert(json.resultMsg);
				
				if(msg.indexOf('정상적') > -1) {					
					search();
				}
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
			
// 			function formatOpt2(cellvalue, options, rowObject){
				
// 				var master = rowObject.master;
// 				var dwg_no = rowObject.dwg_no;
// 				var file_id = rowObject.file_id;
// 		   		//var str = "<img src=\"TBC/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+dwg_no+"','"+rev+"');\"/>&nbsp;&nbsp"+txt;
// 		   		var str = "<img src=\"TBC/images/pdf_icon.gif\" border=\"0\" />&nbsp;&nbsp;<a href=\"javascript:fileView("+file_id+")\">"+cellvalue+"</a>";
// 		   		return str;		 	 
// 			}
			
			function formatOpt3(cellvalue, options, rowObject){
				
				var str = "";
				if(cellvalue == 'R') {
					str = "승인 요청";
				} else if(cellvalue == 'C') {
					str = "승인 완료("+Math.floor(rowObject.pr_no)+")";
				}
		   		
		   		return str;		 	 
			}
			
// 			function fileView(file_id) {
// 				//alert(dwgno+"___"+rev);
// 				url = "/ematrix/emsPurchasingDownload.tbc?file_id="+file_id;				
			
// 				var nwidth = 800;
// 				var nheight = 700;
// 				var LeftPosition = (screen.availWidth-nwidth)/2;
// 				var TopPosition = (screen.availHeight-nheight)/2;
			
// 				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
// 				window.open(url,"",sProperties);
// 			}
			

		</script>
	</body>
</html>