<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.specTitle{width:100px; float:left; font-size:16pt; font-weight:bold; margin-left:10px;}
			.headerBD {position:relative; width:800px; height:25px; margin:0 0 10px 4px; text-align:right}	
			.warningArea{float:right; font-weight:bold; color:red; display:none; font-family:맑은 고딕;}
			.uniqInput {width:85px; margin-right:2px;}
			.buttonInput{margin:2px;}
			.content {position:relative; margin-left:6px; width:820px; height:265px; text-align:center; overflow-x:auto; }
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}
			.ui-jqgrid .ui-jqgrid-hdiv {position: relative; margin: 0;padding: 0; overflow-x: hidden; border-left: 0 none !important; border-top : 0 none !important; border-right : 0 none !important;}
			.ui-jqgrid .ui-jqgrid-hbox {float: left; padding-right: 20px;}
			.ui-jqgrid .ui-jqgrid-htable {table-layout:fixed;margin:0;}
			.ui-jqgrid .ui-jqgrid-htable th {height:25px;padding: 3px 2px 0 2px;}
		</style>		
		<title>
			EMS(Equipment Management System) Purchasing Spec.
		</title>
	</head>

	<body>
		<form id="application_form" name="application_form" >
			<input type="hidden" name="pageYn" id="pageYn" value="N" />
			<input type="hidden" name="p_userId" id="p_userId" value="${UserId}" />
			<input type="hidden" name="p_daoName"   id="p_daoName" value=""/>
			<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
			<input type="hidden" name="p_process"   id="p_process" value=""/>
			<input type="hidden" name="p_rowCnt"   id="p_rowCnt" value=""/>
			<input type="hidden" name="p_spec_no"   id="p_spec_no" value=""/>
		
			<input type="hidden" name="p_master"   id="p_master" value="${p_master}"/>
			<input type="hidden" name="p_dwg_no"   id="p_dwg_no" value="${p_dwg_no}"/>
			
			<input type="hidden" name="p_file_id_list"   id="p_file_id_list" value=""/>
			<input type="hidden" name="p_row_id"   id="p_row_id" value=""/>
			
			
			
			<div id="hiddenArea"></div>
			<div class="headerBD"></div>
			<div class="specTitle">조달 접수</div>
			
			<div class="headerBD">
				<div class="button endbox" style="height:40px">
<!-- 					<input type="button" class="btn_blue" value="닫기" id="btnClose"/> -->
				</div>
			</div>
			<div class="content">
				<table id="jqGridOptainSpecList"></table>
			</div>
			<div class="specTitle">설계 회신</div>
			<div class="button endbox" style="height:40px">
<!-- 				<input type="button" class="btn_blue2" value="행 추가" id="btnAdd"/> -->
<!-- 				<input type="button" class="btn_blue2" value="행 삭제" id="btnDel"/> -->
				<input type="button" class="btn_blue2" value="UPLOAD" id="btnUpload"/>
				<input type="button" class="btn_blue2" value="DELETE" id="btnFileDel"/>
				<input type="button" class="btn_blue2" value="APPLY" id="btnApply"/>
			</div>
			<div class="content">
				<table id="jqGridPlanSpecList"></table>
				<div id="bottomJqGridPlanSpecList"></div>
			</div>
			<div class="warningArea">※업로드 한 파일이 있습니다. 창을 닫거나 새로고침하면 사라집니다.</div>
		</form>

		<script type="text/javascript" >
			var idRow;
			var idCol;
			var kRow;
			var kCol;
			var lastSelection;
			
			var applyList = [];
			
			$(document).ready(function(){
				//조달에서 넘어온 그리드	
				$("#jqGridOptainSpecList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpPurchasingSpecObtainList.do',
		             postData : getFormData('#application_form'),		             
	                 colModel:[
	                 	{label:'SPEC_REVIEW_ID', 	name:'spec_review_id'		,width:1	,align:'center', hidden:true, sortable:false, title:false},
	                	{label:'MASTER', 			name:'project_no'			,width:80	,align:'center', sortable:false, title:false},
	                	{label:'DWG No.', 			name:'dwg_no'				,width:80	,align:'center', sortable:false, title:false},
	                    {label:'MODEL', 			name:'model'				,width:1	,align:'left', sortable:false, hidden:true, title:false},
	                    {label:'업체ID', 			name:'vendor_site_id'		,width:1	,align:'left', hidden:true, sortable:false, title:false},
	                    {label:'업체명', 			name:'vendor_site_name'	,width:120	,align:'left', sortable:false, title:false },
	                    {label:'파일', 				name:'file_ids'			,width:100	,align:'left', formatter:formatOpt3, sortable:false, title:false},
	                    {label:'접수일', 			name:'creation_date'		,width:80	,align:'center', sortable:false, title:false},
	                    {label:'접수 COMMENT',		name:'act_comment'		,width:140	,align:'left', title:false}
	                  ],
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             cellEdit : true,
		             cellsubmit : 'clientArray', // grid edit mode 2		     
		             scrollOffset : 18,
		             multiselect: false,
		             height: 205,
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
					 onCellSelect: function(row_id,icol,cellcontent,e) {
					 	
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
					 }
				}); //end of jqGrid
				
				//설계 회신 그리드
				$("#jqGridPlanSpecList").jqGrid({ 
		            datatype: 'json', 
		            mtype: 'POST', 
		            url:'popUpPurchasingSpecPlanList.do',
		            postData : getFormData('#application_form'),		             
	                colModel:[
	                 	{label:'SPEC_REVIEW_ID', 	name:'spec_review_id'		,width:1	,align:'center', hidden:true, sortable:false, title:false},
	                	{label:'MASTER', 			name:'project_no'			,width:60	,align:'center', sortable:false, title:false},
	                	{label:'DWG No.', 			name:'dwg_no'				,width:80	,align:'center', sortable:false, title:false},
	                    {label:'MODEL', 			name:'model'				,width:1	,align:'left', sortable:false, hidden:true, title:false},
	                    {label:'업체ID', 			name:'vendor_site_id'		,width:1	,align:'left', hidden:true, sortable:false, title:false},
	                    {label:'업체명', 			name:'vendor_site_name'	,width:120	,align:'left', sortable:false, title:false, editable:true, 
                   		    edittype : "select", 
                   		    formatter : 'select', 
                   		    editrules : { required : false },
	            		},
	                    {label:'파일', 				name:'file_ids'			,width:100	,align:'left', formatter:formatOpt3, sortable:false, title:false},
	                    {label:'회신일', 			name:'act_date'			,width:80	,align:'center', sortable:false, title:false},
	                    {label:'회신 COMMENT',		name:'act_comment'		,width:100	,align:'left', editable:true, edittype:"text", title:false},
	                    {label:'FLAG', 				name:'complete_flag'		,width:40	,align:'center', sortable:false, title:false, editable:true,
	                     edittype:'select', //SELECT BOX 옵션
              			 formatter:'select',
              			 editoptions:{
              			 	value:' : ;10:진행;20:마감;30:불가'              			 	
              			 },
              			},
	                    {label:'is_edit', 			name:'is_edit'			,width:50	,align:'center', hidden:true, title:false},
	                    {label:'files', 			name:'files'				,width:50	,align:'center', hidden:true, title:false}
	                ],
		            gridview: true,
		            toolbar: [false, "bottom"],
		            viewrecords: true,
		            autowidth: true,
		            cellEdit : true,
		            pager 		: $('#bottomJqGridPlanSpecList'),
		            cellsubmit : 'clientArray', // grid edit mode 2		     
		            scrollOffset : 18,
		            multiselect: true,
					pgbuttons 	: false,
					pgtext 		: false,
					pginput 	: false,
		            height: 205,
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
					onCellSelect: function(row_id,icol,cellcontent,e) {
					 	if(row_id != null) {
						 	var ret = $(this).getRowData( row_id );
						 	
							//항목이 설계 개정만 원인부서를 입력 할  수 있다						
							//승인 된 데이터는 수정할 수 없음.
							if ( ret.is_edit == "N" ) {
								$(this).jqGrid( 'setCell', row_id, 'act_comment', '', 'not-editable-cell' );
								$(this).jqGrid( 'setCell', row_id, 'vendor_site_name', '', 'not-editable-cell' );
								$(this).jqGrid( 'setCell', row_id, 'complete_flag', '', 'not-editable-cell' );
							}
                        }
					},	
					
					 beforeRequest : function(){
						 $.ajaxSetup({async: false});
							//그리드 내 콤보박스 바인딩
							$.post("getSelectBoxVenderName.do?p_master=" + $("#p_master").val() + "&p_dwg_no=" + $("#p_dwg_no").val(), "", function( data ) {
								$( '#jqGridPlanSpecList' ).setObject( {
									value : 'value',
									text : 'text',
									name : 'vendor_site_name',
									data : data
								} );
							}, "json" );						 
						 $.ajaxSetup({async: true});
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
					    
					    //check box 숨김.
						$(".cbox").hide();
					},
					
				}); //end of jqGrid
				
				// 그리드 아래 버튼 설정
				$("#jqGridPlanSpecList").jqGrid('navGrid', "#bottomJqGridPlanSpecList", {
					search : false,
					edit : false,
					add : false,
					del : false,
					refresh:false
				});

				// 그리드 삭제하는 함수 설정
				$("#jqGridPlanSpecList").navButtonAdd('#bottomJqGridPlanSpecList', {
					caption : "",
					buttonicon : "ui-icon-minus",
					onClickButton : deleteRow,
					position : "first",
					title : "",
					cursor : "pointer"
				});

				// 그리드 추가하는 함수 설정
				$("#jqGridPlanSpecList").navButtonAdd('#bottomJqGridPlanSpecList', {
					caption : "",
					buttonicon : "ui-icon-plus",
					onClickButton : addItemRow,
					position : "first",
					title : "",
					cursor : "pointer"
				});
				
				//######## 적용 버튼 클릭 시 ########//
				$("#btnApply").click(function(){
				
					$("#jqGridPlanSpecList").saveCell(kRow, idCol );
					
					var spec_no = "";
					var spec_id = "";
					var selRows = $("#jqGridPlanSpecList").getDataIDs().length;
					
					var changePlanResultRows =  getChangedGridInfo("#jqGridPlanSpecList");;
					
					for(var i=0; i<changePlanResultRows.length; i++){				
						
					    if(changePlanResultRows[i].files == ""){
							alert("회신 첨부파일을 등록 해주십시오.");
				    		return false;
					    }
					    
					    if(changePlanResultRows[i].complete_flag == "0" || changePlanResultRows[i].complete_flag == ""){
							alert("FLAG를 선택해주십시오.");
				    		return false;
					    }
					    
					    if(changePlanResultRows[i].vendor_site_name == ""){
							alert("업체를 선택해주십시오.");
				    		return false;
					    }
					}
				    
					
					if(!confirm("회신 하시겠습니까?")){
						return false;
					}
					
					var url = "popUpPurchasingSpecApply.do";
					var dataList    = {chmResultList:JSON.stringify(changePlanResultRows)};
					var formData 	= getFormData('#application_form');
					
					lodingBox = new ajaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
					
					var parameters = $.extend({},dataList,formData);
							
					$.post(url, parameters, function(data) {
						alert(data.resultMsg);
						if(data.result == "success") {
							$('#jqGridPlanSpecList').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
							$(".warningArea").hide();
						}
		
						}, 'json' ).error( function() {
							alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
						} ).always( function() {
							lodingBox.remove();			
					});
				});
				
				// 그리드의 변경된 row만 가져오는 함수
				function getChangedGridInfo(gridId) {
					var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
						return obj.is_edit == 'Y';
					});
					
					changedData = changedData.concat(applyList);	
						
					return changedData;
				}
				
				$("#btnUpload").click(function(){
				
					//체크한 row_id를 확인해서	
					//jqGrid의 rowData를 받아옴.					
					var row_id = jQuery("#jqGridPlanSpecList").jqGrid('getGridParam', 'selarrrow');
					if(row_id == ""){
						alert("행을 선택해 주십시오.");
						return false;
					}
					if(row_id.length > 1){
						alert("하나의 행만 선택할 수 있습니다.");
						return false;
					}
	            	var item = $('#jqGridPlanSpecList').jqGrid('getRowData',row_id);
					var master = $("#p_master").val();
	              	var dwg_no = $("#p_dwg_no").val();
	              	var vendor_site_name = item.vendor_site_name;
	              	var spec_review_id = item.spec_review_id;
											
					var url = "popUpPurchasingSpecUpload.do?p_master=" + master + "&p_dwg_no=" + dwg_no + "&p_row_id=" + row_id;
					
					var nwidth = 300;
					var nheight = 300;
					var LeftPosition = (screen.availWidth-nwidth)/2;
					var TopPosition = (screen.availHeight-nheight)/2;
				
					var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
				
					window.open(url,"",sProperties);  
				});

				//########  File Delete 버튼 ########//
				$("#btnFileDel").click(function(){
					var row_id = jQuery("#jqGridPlanSpecList").jqGrid('getGridParam', 'selarrrow');
					
					if(row_id == ""){
						alert("행을 선택하십시오.");
						return false;
					}
					for(var i=0; i<row_id.length; i++){
						$('#jqGridPlanSpecList').jqGrid('setRowData',row_id[i], {file_ids:'', files:'' });
					}
					
					$(".warningArea").hide();
				});	
				//######## 닫기버튼  ########//
				$("#btnClose").click(function(){
					window.close();					
				});	
				
				//######## 행 추가 버튼  ########//
				function addItemRow() {
					var newData = [{    project_no:$("#p_master").val()
						              , dwg_no:$("#p_dwg_no").val()
						              , model:''
						              , vendor_site_id:''
						              , vendor_site_name:''
						              , file_ids:''
						              , act_date:''
						              , act_comment:''
						              , complete_flag:''				
						              , is_edit:'Y'
		              				  , files:''
					 			  }]
					//제일 큰 row를 받음.
					var maxRow = $("#jqGridPlanSpecList").getDataIDs().length;
					$("#jqGridPlanSpecList").jqGrid('addRowData', Number(maxRow)+1 , newData[0], "first");
					
				}
				
				//######## 행 삭제 버튼  ########//
				function deleteRow() {			        
									
					var row_id = jQuery("#jqGridPlanSpecList").jqGrid('getGridParam', 'selarrrow');

					if(row_id == ""){
						alert("행을 선택하십시오.");
						return false;
					}
					
					//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
					//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
					var row_len = row_id.length;					
					
					for(var i=0; i<row_len; i++){
						$('#jqGridPlanSpecList').jqGrid('delRowData',row_id[0]);
					}
					
				}
			});
			
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
			
			function f_bgc_restore(obj){
				$(obj).css("background-color","#FFFFFF");
			}
			
			function formatOpt3(cellvalue, options, rowObject){
				var str = "";
				if (cellvalue != null){
					var file_ids = cellvalue;
					
					var fileArray = file_ids.split(',');

					for(var i=0; i<fileArray.length; i++){
						if(fileArray[i] != ""){
							str += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+fileArray[i]+"');\" />"
						}
					}
				}
			
		   		return str;
			}
			
			//파일 업로드 이후 부모 List에 파일 Bind
			function fileUpload(file_ids, rowId) {
				/* var file_spt = file_ids.split(",");
				var file_ids_text = "";
				
				for(var i=0; i<file_spt.length; i++ ){
					file_ids_text += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView("+file_spt[i]+");\" />";
				} */
				
				$('#jqGridPlanSpecList').jqGrid('setRowData',rowId, {file_ids:file_ids, files:file_ids });
				$(".warningArea").show();
			}
			
			function fileView(file_id) {
				
				url = "popUpPurchasingPosDownloadFile.do?p_file_id="+file_id;				
			
				var nwidth = 800;
				var nheight = 700;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
				window.open(url,"",sProperties);
			}
			
			function jqGridReload (){
				$(".warningArea").hide();
				$('#jqGridPlanSpecList').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
			}

		</script>
	</body>
</html>