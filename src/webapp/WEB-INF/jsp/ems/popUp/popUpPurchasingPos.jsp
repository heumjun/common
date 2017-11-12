<%--*************************************
@DESCRIPTION				: Ems Db(Main)
@AUTHOR (MODIFIER)			: Hwang Sung Jun
@FILENAME					: tbc_EmsDbMain.jsp
@CREATE DATE				: 2015-02-12
*************************************--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>
			EMS(Equipment Management System) Purchasing POS Rev.
		</title>		
		<style>
			.topBD {position:relative; width:1000px; height:20px;}
			.headerBD {position:relative; width:1000px; height:10px; margin:0 0 27px 0;}			
			.searchDetail1 {float:left; font-weight:bold; margin:2px;}
			.uniqInput {width:85px; margin-right:2px;}
			.buttonInput{float:right; width:70px; margin:2px;}
			.warningArea{float:left; font-weight:bold; color:red; display:none; padding-left: 20px;}
 			.content {position:relative; margin-left:10px; width:1005px; text-align:center; }	
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}
			.ui-jqgrid .ui-jqgrid-hdiv {position: relative; margin: 0;padding: 0; overflow-x: hidden; border-left: 0 none !important; border-top : 0 none !important; border-right : 0 none !important;}
			.ui-jqgrid .ui-jqgrid-hbox {float: left; padding-right: 20px;}
			.ui-jqgrid .ui-jqgrid-htable {table-layout:fixed;margin:0; }
			.ui-jqgrid .ui-jqgrid-htable th {height:25px;padding: 3px 2px 0 2px;}
		</style>
	</head>

	<body>
		
		<form id="application_form" name="application_form" >
		
			<div class="topBD"></div>
			
			<input type="hidden" name="pageYn"      id="pageYn" value="N" />
			<input type="hidden" name="p_userId"    id="p_userId" value="${UserId}" />
			<input type="hidden" name="p_daoName"   id="p_daoName" value="" />
			<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
			<input type="hidden" name="p_process"   id="p_process"/>
			<input type="hidden" name="p_master"    id="p_master" value="${master}"/>
			<input type="hidden" name="p_dwg_no"    id="p_dwg_no" value="${p_dwg_no}"/>
			<input type="hidden" name="p_pur_no"    id="p_pur_no" value="${p_ems_pur_no}"/>
			<input type="hidden" name="p_busi_type"    id="p_busi_type" value="${busi_type}"/>
			<input type="hidden" name="p_file_id" 	id="p_file_id" value=""/>
			<input type="hidden" name="s_master" id="s_master" value="${master}" />
			<input type="hidden" name="s_dwg_no" id="s_dwg_no" value="${p_dwg_no}" />
			
			<input type="hidden" name="p_l_item_code" 	id="p_l_item_code" 	value="${p_l_item_code}" />
			<input type="hidden" name="p_l_ea" 			id="p_l_ea" 		value="${p_l_ea}" />
			<input type="hidden" name="p_l_dwg_no" 		id="p_l_dwg_no" 	value="${p_l_dwg_no}" />
			<input type="hidden" name="p_project" 		id="p_project" 	value="${p_project}" />
			
			
			<div id="hiddenArea"></div>
			<div class="headerBD">			
				<div class="warningArea">※업로드 한 파일이 있습니다. 창을 닫거나 새로고침하면 사라집니다.</div>
				<div class="button endbox">
					<input type="button" class="btn_blue" value="UPLOAD" id="btnUpload"/>
					<input type="button" class="btn_blue" value="POS승인" id="btnPosApp"/>
					<input type="button" class="btn_blue" value="APPLY" id="btnApply"/>
<!-- 					<input type="button" class="btn_blue" value="닫기" id="btnClose"/> -->
				</div>
			</div>

			<div class="content">
				<table id="gridPosList"></table>
				<div id="bottomPosList"></div>
			</div>
		</form>
		<script type="text/javascript" >

			var idRow;
			var idCol;
			var kRow;
			var kCol;
			var lastSelection;
			var flagDataChange;
			
			$(document).ready(function(){
				
		     	//그리드 내 콤보박스 바인딩
		     	$.post( "popUpPurchasingFosSelectBoxCauseDept.do", "", function( data ) {
					$( '#gridPosList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'cause_dept',
						data : data
					} );
				}, "json" );
		     	
		     	$.post( "popUpPurchasingFosSelectBoxPosType.do", "", function( data ) {
					$( '#gridPosList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'pos_type',
						data : data
					} );
				}, "json" );
				
				
				//진입 시 기존 화면이 Add나 Del이면 POS 승인 버튼 동작불가.
				if($("#p_busi_type").val() == "A" || $("#p_busi_type").val() == "D"){
					fn_buttonDisabled([ "#btnPosApp" ]);
					$("#btnPosApp").attr("disabled","disabled");
				}
				
				$("#gridPosList").jqGrid({ 
		             datatype: 'json', 
		             mtype: 'POST', 
		             url:'popUpPurchasingPosList.do',
		             postData : getFormData('#application_form'),		             
	                 colModel:[
	                	{label:'Master', 	name:'master'			, width:40	,align:'center', sortable:false, title:false},
	                	{label:'DWG No.', 	name:'dwg_no'			, width:50	,align:'center', sortable:false, title:false},
	                    {label:'항목',		name:'pos_type'		, width:60	,align:'center', sortable:false, title:false, editable:true, 
						 edittype:'select', //SELECT BOX 옵션
						 formatter:'select',
						 editoptions:{
							 dataEvents : [ { type : 'change', 
		            			 			    fn : function( e ) {	
		            			 			    	flagDataChange = true; 			    	
		            			 			    	if($(this).val() == "A"){
		            			 			    		fn_buttonDisabled([ "#btnPosApp" ]);
		            			 						$("#btnPosApp").attr("disabled","disabled");
		            			 			    	}else{
		            			 			    		if($("#p_busi_type").val() != "A" && $("#p_busi_type").val() != "D"){
		            			 			    			$("#btnPosApp").attr("disabled",false);
		            			 							fn_buttonEnable([ "#btnPosApp" ]);
		            			 			    		}
		            			 			    	}
	            			 				   	}
	            			 				 }
	            		 				 ]  								                    														 
	            		  },
	            		  cellattr: function (){ 
	            		  	return 'title="POS 등록 사유"'; 
	            		  }
						},
	                    {label:'원인부서'	,	name:'cause_dept'		, width:80	,align:'center', sortable:false, title:false, editable : true, 
                   		 edittype : "select", 
                   		 formatter : 'select', 
                   		 editrules : { required : false }, 
                   		 cellattr: function (){ 
	            		  	return 'title="POS 등록 원인부서"'; 
	            		  }
	                    },
	                    {label:'비용발생',	name:'is_cost'		, width:50	,align:'center', sortable:false, title:false, editable:true, 
              			 edittype:'select', //SELECT BOX 옵션
              			 formatter:'select',
              			 editoptions:{
              			 	value:'Y:Y;N:N',
              			 	dataEvents : [ 
              			 					{ type : 'change', 
		            			 			    fn : function( e ) {
		            			 			    	flagDataChange = true;
		            			 			    	if($(this).val() == "Y"){
		            			 			    		$("#btnPosApp").attr("disabled","disabled");
		            			 			    		fn_buttonDisabled([ "#btnPosApp" ]);
		            			 			    	}else{
		            			 			    		if($("#p_busi_type").val() != "A" && $("#p_busi_type").val() != "D"){
		            			 			    			$("#btnPosApp").attr("disabled",false);    
		            			 							fn_buttonEnable([ "#btnPosApp" ]);
		            			 			    		}	    		
		            			 			    	}
	            			 				   	}
	            			 				 }
	            		 				 ] 
              			 },
              			 cellattr: function (){ 
	            		  	return 'title="기자재 사양 변경에 따른 비용 처리 유무 (수량은 증가하지 않고 비용만 증가)"'; 
	            		 }
	                    },
	                    {label:'Extra 비용(USD)'	,name:'extra_cost', width:80	,align:'center', formatter:'integer', title:false, sortable:false, editable:true,
	                     cellattr: function (){ 
	            		  	return 'title="필요 시 기입"'; 
	            		 }
	            		},
	                    {label:'Rev',		name:'pos_rev'		, width:35	,align:'center', sortable:false, title:false,
	                     cellattr: function (){ 
	            		  	return 'title="POS file을 프로그램에 등록한 순서 (실제 POS Rev.과 매치 안됨)"'; 
	            		 }
	            		},
	                    {label:'Date',		name:'creation_date'	, width:50	,align:'center', sortable:false, title:false},
	                    {label:'승인',		name:'is_approved'	, width:40	,align:'center', sortable:false, title:false,
	                     cellattr: function (){ 
	            		  	return 'title="POS file이 조달부서에 확정 전달 되었는지 유무"'; 
	            		 }
	                    }, 
	                    {label:'POS',		name:'is_pos'			, width:40	,align:'center', sortable:false, title:false, formatter:formatOpt1,
	                     cellattr: function (){ 
	            		  	return 'title="현재 임시 저장한 POS 파일의 유무"'; 
	            		 }
	            		},
	                    {label:'file_id',	name:'file_id'		, width:80	,align:'center', hidden:true},
	                    /* JQGRID EVENT 예제
	                    { name : 'eng_change_description', index : 'eng_change_description', editable : true, edittype : "textarea", 
				            	 editoptions : { 
				            		 rows : "3", 
				            		 cols : "40", 
				            		 dataEvents : [ { type : 'blur', 
				            			 				fn : function( e ) {
				            			 					$( "#desc_layer" ).hide();
			            			 					}
			            		 					}, 
				            		                { type : 'focus', 
		            		 							fn : function( e ) { 
		            		 								$( "#desc_layer" ).show();
	            		 								}
			            		 					}, 
				            		                { type : 'keydown', 
			            		 						fn : function( e ) { 
			            		 							var keyCode = e.keyCode || e.which; 
			            		 							
			            		 							if (keyCode == 9) { 
			            		 								$( "#desc_layer" ).hide();
		            		 								}
		            		 							}
			            		 					} ] }, 
         		 				 width : 310 },
         		 				 */
	                 ],
		             gridview: true,
		             viewrecords: true,
		             autowidth: true,
		             cellEdit : true,
		             cellsubmit : 'clientArray', // grid edit mode 2		             
		             scrollOffset : 18,
		             multiselect: false,
		             height: 170,
		             pager: jQuery('#bottomPosList'),
		             rowList:[100,500,1000],
			         rowNum:100, 
					 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		             	idRow = rowid;
		             	idCol = iCol;
		             	kRow  = iRow;
		             	kCol  = iCol;
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
					 
						//$(this).saveCell(kRow, idCol );
						
					 	var ret = $(this).getRowData( row_id );
					 	
						//항목이 설계 개정만 원인부서를 입력 할  수 있다						
						//승인 된 데이터는 수정할 수 없음.
						if ( ret.is_approved == "Y" ) {
							$(this).jqGrid( 'setCell', row_id, 'pos_type', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', row_id, 'cause_dept', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', row_id, 'is_cost', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', row_id, 'extra_cost', '', 'not-editable-cell' );
						}
						
						
						/*
						if ( ret.pos_type == "D"){
							$(this).jqGrid( 'setCell', row_id, 'cause_dept', '', 'editable-cell' );
						}else{
							$(this).jqGrid( 'setCell', row_id, 'cause_dept', '', 'not-editable-cell' );
						}
						
						if ( ret.is_cost == "Y"){
							$(this).jqGrid( 'setCell', row_id, 'extra_cost', '', 'editable-cell' );
						}else{
							$(this).jqGrid( 'setCell', row_id, 'extra_cost', '', 'not-editable-cell' );							
						}
						*/
						
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
						
						//jqGrid의 rowData를 받아옴.					
						var changedData = $.grep( $( "#gridPosList" ).jqGrid( 'getRowData' ), function( obj ) {
							return obj.is_approved == 'N';
						});
						
// 						$(".cbox").hide();
																		
						if(changedData.length == 0){
							/*로딩 시 입력 라인 추가*/
							var vMaster = $("#s_master").val();
							var vDwgNo = $("#s_dwg_no").val();
							var arrDwgNo = [];
							
							arrDwgNo = vDwgNo.split(",");
								
							for(var i=0; i < arrDwgNo.length; i++){
								if(arrDwgNo[i] != ""){
									var newData = [{master:vMaster
									               ,dwg_no:arrDwgNo[i]
									               ,is_approved:'N'
									               ,is_pos:'N'
									               }]
									$(this).jqGrid('addRowData', $.jgrid.randId(), newData[0], "first");
								}
// 								$(".cbox").find(":eq("+(i+1)+")").show();
							}
						}else{ //승인되지 않은 데이터가 있을 경우
							//체크박스 활성화
// 							for(var i=0; i<changedData.length; i++){
// 								$(".cbox").eq(i+1).show();
// 							}
						}
						
						//승인 안닌것만 색깔 처리
						var rows = $(this).getDataIDs();
						for ( var i = 0; i < rows.length; i++ ) {
							//수정 및 결재 가능한 리스트 색상 변경
							var is_approved = $(this).getCell( rows[i], "is_approved" );
							if( is_approved == "N" ) {
								$(this).jqGrid( 'setCell', rows[i], 'master', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'pos_type', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'cause_dept', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'is_cost', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'extra_cost', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'pos_rev', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'creation_date', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'is_approved', '', { color : 'black', background : '#FFFFCC' } );
								$(this).jqGrid( 'setCell', rows[i], 'is_pos', '', { color : 'black', background : '#FFFFCC' } );
							}
						}
						
						
						//데이터 받아온 이 후 pos_type이 A(본물량)이면 POS 승인 버튼 동작불가 처리.						
						for(var i=0; i<changedData.length; i++){						
					    	if(changedData[i].pos_type == "A" || changedData[i].is_cost == "Y"){
					    		$("#btnPosApp").attr("disabled","disabled");
					    		fn_buttonDisabled([ "#btnPosApp" ]);
					    	}
					    }
					
					},		
					
		     	}); //end of jqGrid

				//########  APPLY CLICK ########//
				$("#btnApply").click(function(){		
					$("#gridPosList").saveCell(kRow, idCol );
					
					if($("input[name=p_file_id]").val() == "" || $("input[name=p_file_id]").val() == "0"){
						alert("FILE UPLOAD 이 후 진행 가능 합니다.");
						return false;
					}
					
					//jqGrid의 rowData를 받아옴.					
					var changedData = $.grep( $( "#gridPosList" ).jqGrid( 'getRowData' ), function( obj ) {
						return obj.is_approved == 'N';
					});
					
					// 필요한 row 데이터들을 배열로 넘기기 위해 hidden 태그를 추가한다.
					var vHtmlStr = "";
					for(var i=0; i<changedData.length; i++){
						
						if(changedData[i].pos_type == "A" && changedData[i].is_cost == "Y"){
							alert("본물량이면 비용발생 여부 Y를 선택할 수 없습니다.");
							return false;
						}
						
					    vHtmlStr += "<input type='hidden' name='p_pos_type' value='"+changedData[i].pos_type+"'/>";
						vHtmlStr += "<input type='hidden' name='p_cause_dept' value='"+changedData[i].cause_dept+"'/>";
						vHtmlStr += "<input type='hidden' name='p_is_cost' value='"+changedData[i].is_cost+"'/>";
						vHtmlStr += "<input type='hidden' name='p_extra_cost' value='"+changedData[i].extra_cost+"'/>";							   
						vHtmlStr += "<input type='hidden' name='p_dwg_no_input' value='"+changedData[i].dwg_no+"'/>";
						
						if(changedData[i].pos_type == ""){
							alert("항목을 선택해주십시오.");
							return false;
						}
						
						if(changedData[i].cause_dept == ""){
							alert("원인부서를 선택해주십시오.");
							return false;							
						}
						if(changedData[i].is_cost == ""){
							alert("비용유무를 선택해주십시오.");
							return false;
						}
					}
					//Form에 만들어준 hidden 태그들을 추가.
					$("#hiddenArea").html(vHtmlStr);
						
					var vMaster = $("#p_master").val();
					var vDwgNo = $("#p_dwg_no").val();
					
					if(confirm("적용 하시겠습니까?")){
						form = $('#application_form');			
						//필수 파라미터 S	
						$("input[name=p_daoName]").val("EMS_PURCHASING");
						$("input[name=p_queryType]").val("insert");
						if($("input[name=p_pur_no]").val() == ""){
							$("input[name=p_process]").val("insertPosRevision");
						}else{
							$("input[name=p_process]").val("insertPosRevisionPurNo");
						}
						
						var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
						$.post("popUpPurchasingPosApplyFile.do",form.serialize(),function(json)
						{	
							afterDBTran(json);
							loadingBox.remove();
						},"json");
	
					}
				});		
				
				//########  Upload CLICK ########//
				$("#btnUpload").click(function(){		
					var myGrid = $("#gridPosList");
    				var rows = myGrid.getDataIDs();
					
					//row 수가 0일때
					if (myGrid.getGridParam("reccount") == "0"){
						alert("항목이 존재하지 않습니다.");
						return;
					}
					
					//열려 있는 Text Box를 그리드로 반영(저장) 시킴.
					myGrid.saveCell(kRow, idCol );
										
    				var vDwgNo = "";
    				var vMaster = "";
    				var vPosRev = "";
    				//그리드 첫번째 행 정보를 가져옴
	            	vDwgNo = myGrid.jqGrid ('getCell', rows[0], 'dwg_no');				        
	            	vMaster = myGrid.jqGrid ('getCell', rows[0], 'master'); 
	            	vPosRev = myGrid.jqGrid ('getCell', rows[0], 'pos_rev'); 

					url = "popUpPurchasingPosUpload.do?master="+vMaster+"&dwg_no="+vDwgNo+"&pos_rev="+vPosRev;

					var nwidth = 570;
					var nheight = 100;
					var LeftPosition = (screen.availWidth-nwidth)/2;
					var TopPosition = (screen.availHeight-nheight)/2;
				
					var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
					window.open(url,"winpop",sProperties);

				});				
				
				
				//Pos 저장 버튼
				$("#btnPosApp").click(function(){		
					$("#gridPosList").saveCell(kRow, idCol );
					
					if(flagDataChange == true){
						alert("데이터가 변경되었습니다. Apply 또는 새로고침[F5] 이후 진행하십시오.");
						return false;
					}
					
					//jqGrid의 rowData를 받아옴.					
					var changedData = $.grep( $( "#gridPosList" ).jqGrid( 'getRowData' ), function( obj ) {
						return obj.is_approved == 'N';
					});
					
					
					// 필요한 row 데이터들을 배열로 넘기기 위해 hidden 태그를 추가한다.
					var vHtmlStr = "";
					var vIsCost = "";
					var vPosRev = "";
					
					for(var i=0; i<changedData.length; i++){
					    vHtmlStr += "<input type='hidden' name='p_pos_rev' value='"+changedData[i].pos_rev+"'/>";
					    vIsCost = changedData[i].is_cost;
					    vPosRev = changedData[i].pos_rev;
					}
					//Form에 만들어준 hidden 태그들을 추가.						
					$("#hiddenArea").html(vHtmlStr);
					
					if(vPosRev == ""){
						alert("승인할 수 있는 데이터가 아닙니다. \n Apply 이후 승인 가능합니다.");
						return false;
					}
					if(vIsCost == "Y"){
						alert("비용발생이 되는 경우 POS승인할 수 없습니다.");
						return false;
					}
					
					if(confirm("승인 이후 수정이나 File Upload를 할 수 없습니다. \n진행하시겠습니까?")){					
						form = $('#application_form');			
						//필수 파라미터 S	
						$("input[name=p_daoName]").val("EMS_PURCHASING");
						$("input[name=p_queryType]").val("update");
						$("input[name=p_process]").val("updatePosApproved");
						
						
						//필수 파라미터 E	
						$(".loadingBoxArea").show();
	
						$.post("popUpPurchasingPosApprove.do",form.serialize(),function(json)
						{	
							afterDBTran(json);
							$(".loadingBoxArea").hide();
							//그리드 리로드
							jqGridReload();
							
						},"json");						
					};
				});
				
			});
			
			function editRow(id) {
                if (id && id !== lastSelection) {
                    var grid = $("#gridPosList");
                    grid.jqGrid('restoreRow',lastSelection);
                    grid.jqGrid('editRow',id, {keys:true});
                    lastSelection = id;
                }
            }
		
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				$(opener.document).find("#btnSearch").click();
				window.close();					
			});	
			
			//######## 메시지 Call ########//
			var afterDBTran = function(json){				
				var msg = json.resultMsg;			 	
			 	var result = json.result;
	
				alert(msg);
				
				if(result == "success"){
					$("#p_file_id").val("");
					$(".warningArea").hide();
					flagDataChange = false;
				}
				
				if($("#p_busi_type").val() == "D"){
					if($("input[name=p_pur_no]").val() != ""){
						if(result == "success"){
							//성공이면 pos 등록 flag를 부모창에 전달.
							$(opener.document).find("#p_pos_flag").val("Y");
							self.close();
							//jqGridReload();
						}
					}
				}else if($("#p_busi_type").val() == "A"){
					if(result == "success"){
						opener.close();
						opener.opener.search();
					}
					self.close();
					
				}else if($("#p_busi_type").val() == "M"){
					if(result == "success"){
						//성공이면 Main Gred Replace
						$(opener.document).find("#btnSearch").click();
					}
					
					//그리드 리로드
					//jqGridReload();
					
					fn_search();
					//window.opener.parentClose();
					//$(opener.document).find("#btnClose").click();					
					//self.close();
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
			
			//STATE 값에 따라서 checkbox 생성
			function formatOpt1(cellvalue, options, rowObject){
				
				var file_id = Math.floor(rowObject.file_id);
				var str = "";
				if(cellvalue == "Y"){
		   			str = "<a href=\"javascript:fileView("+file_id+")\">Y</a>";
				}else{
					str = "N";
				}	  	             
		   	 	return str;
		 	 
			}
			
			function fileUpload(mst, dwgno) {
				url = "/ematrix/emsPurchasingUploadPopup.tbc?master="+mst+"&dwg_no="+dwgno;				
			
				var nwidth = 570;
				var nheight = 100;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
			
				window.open(url,"",sProperties).focus();
			}
			
			function fileView(file_id) {
				//alert(dwgno+"___"+rev);
				url = "popUpPurchasingPosDownloadFile.do?p_file_id="+file_id;				
			
				var nwidth = 800;
				var nheight = 700;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
			
				var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			
				window.open(url,"",sProperties).focus();
			}	
			
			
			function jqGridReload (){
				$('#gridPosList').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
				//$("#gridPosList").jqGrid("GridUnload");
			}
			
			function fn_search(){			
				var sUrl = "popUpPurchasingPosList.do";
				$( "#gridPosList" ).jqGrid( 'setGridParam', {
					mtype : 'POST',
					url : sUrl,
					datatype : 'json',
					page : 1,
					postData : getFormData('#application_form')
				}).trigger( "reloadGrid" );
				
				
			}

		</script>
	</body>
</html>