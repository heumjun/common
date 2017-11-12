<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>수신문서_등록</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.totalEaArea {
		position: relative;
		margin-right: 40px;
		padding: 4px 0 6px 2px;
		font-weight: bold;
		border: 1px solid #ccc;
		background-color: #D7E4BC;
		vertical-align: middle;
	}
	
	input[type=text] {
		text-transform: uppercase;
	}
	
	td {
		text-transform: uppercase;
	}
	
	.header .searchArea .buttonArea #btnForm {
		float: left;
	}
	
	.required_cell {
		background-color: #F7FC96
	}	
</style>
</head>
<body> 
<form id="application_form" name="application_form" method="post">
<input type="hidden" id="stepState" name="stepState" value="1" />
<input type="hidden" id="p_work_key" name="p_work_key" value="" />
<input type="hidden" id="importFlag" name="importFlag" value="N" />
<input type="hidden" id="filePath" name="filePath" value=""/>
<input type="hidden" name="p_dept_type" id="p_dept_type" value="${loginUser.dwgabbr_eng}" />
<input type="hidden" name="admin_yn" id="admin_yn" value="${loginUser.admin_yn}" />

	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			수신문서_등록
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<table>
			<col width="300"/>
			<col width="*"/>
			<tr>
				<td class="bdl_no" style="border-right:none;">
					<c:if test="${loginUser.admin_yn == 'Y'}">
						<input type="button" class="btn_red2" value="FORM" id="btnForm" />
						<input type="button" class="btn_red2" value="IMPORT" id="btnExlImp"/>
					</c:if>
				</td>
				<td class="bdl_no" style="border-left:none;">
					<div class="button endbox">	
						<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						<input type="button" class="btn_blue2" value="DELETE" id="btnDel"/>
						<input type="button" class="btn_blue2" value="BACK" id="btnBack" style="display:none;"/>
						<input type="button" class="btn_blue2" value="NEXT" id="btnNext"/>
						<input type="button" class="btn_blue2" value="CLOSE" id="btnClose"/>
					</div>
				</td>
			</tr>
		</table>			
		<div class="content">
			<table id="jqGridAddMainList"></table>
			<div id="bottomJqGridAddMainList"></div>
		</div>
		<!-- loadingbox -->
	</div>
</form>
<script type="text/javascript" >

	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var selectAttr = '';
	var backList = '';
	var resultData = [];
	var admin_yn = $("#admin_yn").val();
	
	var arr_project_no = "";
	
	var jqGridObj = $("#jqGridAddMainList");
	
	$(function() {
		var form = fn_getFormData('#application_form');
		
		getAjaxTextPost(null, "commentReceiptProjectNoList.do", form, commentReceiptProjectNoCallback);
	});
	
	//도면번호 받아온 후
	var commentReceiptProjectNoCallback = function(txt){
		arr_project_no = txt.split("|");
	}
	
	function getMainGridColModel(){

		var gridColModel = new Array();
		
		gridColModel.push({label:'수신 No', name:'receipt_no' , index:'receipt_no' ,width:70 ,align:'center', sortable:false});
		gridColModel.push({label:'Project', name:'project_no' , index:'project_no' ,width:30, title:false,align:'center', sortable:false, editable:true,
			edittype : "text",
	  		editrules : { required : false },
	  		cellattr: function (){return 'class="required_cell"';},
			editoptions: { 
				dataInit: function(elem) {
					setTimeout(function(){ 
						$(elem).autocomplete({
							source: arr_project_no,
							minLength: 1,
			    			matchContains: true, 
			    			autosearch: true,
			    			autoFocus: true,
			    			selectFirst: true
						});
					}, 10);
				} 
			}
		});
		gridColModel.push({label:'문서',	name:'doc_type' , index:'doc_type', width:30, title:false, align:'center', sortable:false, editable:true, formatter : 'select', edittype : 'select', editoptions : { value : "E:E-MAIL;L:LETTER;F:FAX" }, cellattr: function (){return 'class="required_cell"';} });
		gridColModel.push({label:'Issuer',	name:'issuer' , index:'issuer' ,width:30, title:false, align:'center', sortable:false, editable:true, formatter : 'select', edittype : 'select', editoptions : { value : "O:OWNER;C:CLASS" }, cellattr: function (){return 'class="required_cell"';} });
		gridColModel.push({label:'Subject',	name:'subject' , index:'subject' ,width:200, title:false, align:'left', sortable:false, editable:true, cellattr: function (){return 'class="required_cell"';}});
		gridColModel.push({label:'Issue Date',	name:'issue_date', index:'issue_date',width:45, title:false, align:'center', sortable:false, editable:true,
			cellattr: function (){
				return 'class="required_cell"';
			},
			editoptions: { 
				dataInit: function(el) { 
					$(el).datepicker({
				    	dateFormat: 'yy-mm-dd',
				    	prevText: '이전 달',
					    nextText: '다음 달',
					    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
					    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
					    dayNames: ['일','월','화','수','목','금','토'],
					    dayNamesShort: ['일','월','화','수','목','금','토'],
					    dayNamesMin: ['일','월','화','수','목','금','토'],
					    showMonthAfterYear: true,
					    yearSuffix: '년'
					    /* onSelect: function () {
	                        $("#dataList").jqGrid("saveCell", idRow, idCol);
	                    } */
		  			}); 
				} 
			}
		});
		gridColModel.push({label:'Com No.' ,name:'com_no' , index:'com_no' ,width:70, title:false, align:'center', sortable:false, editable:true, cellattr: function (){return 'class="required_cell"';}});
		gridColModel.push({label:'담당팀CODE' ,name:'receipt_team_code' , index:'receipt_team_code' ,width:60 ,align:'center', sortable:false, hidden:true});
		gridColModel.push({label:'담당팀' ,name:'receipt_team_name' , index:'receipt_team_name', width:80, title:false, align:'center', sortable:false, editable:true,
			edittype : "select",
	  		editrules : { required : false },
	  		cellattr: function () {
	  			if(admin_yn != 'Y') {
	  				return 'disabled="disabled"';
	  			} else {
		  			return 'class="required_cell"';
	  			}
	  		},
	  		editoptions: {
				dataUrl: function(){
	        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
	   				var url = "commentReceiptGridTeamList.do?sb_type=all&p_dept_code=${loginUser.upper_dwg_dept_code}";
					return url;
				},
	  			buildSelect: function(data){

	  				data = $.parseJSON(data);
	  				
	 				var rtSlt = '<select id="selectReceiptTeam" name="selectReceiptTeam" >';
	   				for ( var idx = 0 ; idx < data.length ; idx++) {
						rtSlt +='<option value="' + data[idx].sb_name + '(' + data[idx].sb_value + ')' + '" >' + data[idx].sb_name + '(' + data[idx].sb_value + ')</option>';	
	 				}
					rtSlt +='</select>';
					return rtSlt;
	  		 	},
	  		 	dataEvents: [{
	            	type: 'change'
	            	, fn: function(e, data) {
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	                    //문자열 잘라서 히든에 입력
	                    changeCombo(rowId, 'receipt_team_code', e.target.value);
	                }
	            },{ type : 'keydown'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	                    
	                    var key = e.charCode || e.keyCode; 
	            		if( key == 13 || key == 9) {
	            			//문자열 잘라서 히든에 입력
		                    changeCombo(rowId, 'receipt_team_code', e.target.value);
	            		}
	                    
	            	}
	            },{ type : 'blur'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	           		    //문자열 잘라서 히든에 입력
	                    changeCombo(rowId, 'receipt_team_code', e.target.value);
	            	}
	            }]
	  		 }
		});
		gridColModel.push({label:'담당파트code' ,name:'receipt_dept_code' , index:'receipt_dept_code' ,width:80 ,align:'center', sortable:false, hidden:true});
		gridColModel.push({label:'담당파트' ,name:'receipt_dept_name' , index:'receipt_dept_name', width:80, title:false, align:'center', sortable:false, editable:true,
			edittype : "select",
			cellattr: function () {
	  			if(admin_yn != 'Y') {
	  				return 'disabled="disabled"';
	  			} else {
		  			return '';
	  			}
	  		},
	  		editoptions: {
				dataUrl: function(){
	        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
	   				var url = "commentReceiptGridDeptList.do?sb_type=all&p_dept_code=" + item.receipt_team_code;
					return url;
				},
	  			buildSelect: function(data){

	  				data = $.parseJSON(data);
	  				
	 				var rtSlt = '<select id="selectReceiptDept" name="selectReceiptDept" >';
	   				for ( var idx = 0 ; idx < data.length ; idx++) {
						rtSlt +='<option value="' + data[idx].sb_name + '(' + data[idx].sb_value + ')' + '" >' + data[idx].sb_name + '(' + data[idx].sb_value + ')</option>';	
	 				}
					rtSlt +='</select>';
					return rtSlt;
	  		 	},
	  		 	dataEvents: [{
	            	type: 'change'
	            	, fn: function(e, data) {
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
						//문자열 잘라서 히든에 입력
	                    changeCombo(rowId, 'receipt_dept_code', e.target.value);
	                }
	            },{ type : 'keydown'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	                    
	                    var key = e.charCode || e.keyCode; 
	            		if( key == 13 || key == 9) {
	            			//문자열 잘라서 히든에 입력
		                    changeCombo(rowId, 'receipt_dept_code', e.target.value);
	            		}
	                    
	            	}
	            },{ type : 'blur'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
						//문자열 잘라서 히든에 입력
	                    changeCombo(rowId, 'receipt_dept_code', e.target.value);
	            	}
	            }]
	  		 }
		});
		gridColModel.push({label:'담당자code' ,name:'receipt_user_id' , index:'receipt_user_id' ,width:50 ,align:'center', sortable:false, hidden:true});
		gridColModel.push({label:'담당자' ,name:'receipt_user_name' , index:'receipt_user_name' ,width:50, title:false, align:'center', sortable:false, editable:true,
			edittype : "select",
	  		editrules : { required : false },
	  		cellattr: function () {
		  			return '';
	  		},
	  		editoptions: {
				dataUrl: function(){
	        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
	   				var url = "commentReceiptGridUserList.do?sb_type=all&p_dept_code=" + item.receipt_dept_code;
					return url;
				},
	  			buildSelect: function(data){

	  				data = $.parseJSON(data);
	  				
	 				var rtSlt = '<select id="selectReceiptUser" name="selectReceiptUser" >';
	   				for ( var idx = 0 ; idx < data.length ; idx++) {
						rtSlt +='<option value="' + data[idx].sb_name + '" >' + data[idx].sb_name + '</option>';	
	 				}
					rtSlt +='</select>';
					return rtSlt;
	  		 	},
	  		 	dataEvents: [{
	            	type: 'change'
	            	, fn: function(e, data) {
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	                    
	                    var key = e.charCode || e.keyCode; 
	            		if( key == 13 || key == 9) {
	            			//문자열 잘라서 히든에 입력
		                    changeCombo(rowId, 'receipt_user_id', e.target.value);
	            		}
	                    
	                }
	            },{ type : 'keydown'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
	                    
	                    var key = e.charCode || e.keyCode; 
	            		if( key == 13 || key == 9) {
	            			//문자열 잘라서 히든에 입력
		                    changeCombo(rowId, 'receipt_user_id', e.target.value);
	            		}
	                    
	            	}
	            },{ type : 'blur'
	            	, fn : function( e) { 
	            		var row = $(e.target).closest('tr.jqgrow');
	                    var rowId = row.attr('id');
						//문자열 잘라서 히든에 입력
	                    changeCombo(rowId, 'receipt_user_id', e.target.value);
	            	}
	            }]
	  		 }
		});
		gridColModel.push({label:'DWG NO.' ,name:'dwg_no' , index:'dwg_no', width:60, title:false, align:'center', sortable:false, editable:true,
			edittype : "select",
	  		editrules : { required : false },
	  		cellattr: function (){
	  			if(admin_yn != 'Y') {
	  				return 'class="required_cell"';
	  			} else {
		  			return '';
	  			}
	  		},
	  		editoptions: {
				dataUrl: function(){
	        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
	   				var url = "commentReceiptDwgNoList.do?p_dept_code=" + item.receipt_dept_code + "&p_dept_type=" + $("#p_dept_type").val() + "&p_project_no=" + item.project_no.toUpperCase();
					return url;
				},
	  			buildSelect: function(data){
	  				if(typeof(data)=='string'){
	     				data = $.parseJSON(data);
	    			}
	 				var rtSlt = '<select id="selectDwgNo" name="selectDwgNo" >';
	   				for ( var idx = 0 ; idx < data.length ; idx++) {
						rtSlt +='<option value="'+data[idx].object+'" name="'+data[idx].object+'">'+data[idx].object+'</option>';	
	 				}
					rtSlt +='</select>';
					return rtSlt;
	  		 	}
	  		 }
		});
		gridColModel.push({label:'첨부' ,name:'document_name' , index:'document_name' ,width:60 ,align:'center', sortable:false, cellattr: function (){return 'class="required_cell"';} });
		gridColModel.push({label:'복호화' ,name:'dec_document_name' , index:'dec_document_name' ,width:60 ,align:'center', sortable:false, hidden: true});
		gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
		
		return gridColModel;
	}

	// 담당팀, 담당파트, 담장자 변경하였을때 문자열 자르기를 이용하여 칼럼에 값 넣어줌
	var changeCombo = function(rowId, cellName, cellValue){
		jqGridObj.saveCell(kRow, idCol);
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		var leftPos = cellValue.indexOf('(')+1;
		var rightPos = cellValue.indexOf(')');
		var value = cellValue.substring(leftPos, rightPos);
		jqGridObj.jqGrid( "setCell", rowId, cellName, value );
	}
	
	var gridColModel = getMainGridColModel();
	
	$(document).ready(function(){
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit : true,
            height: 560,
            pager: $("#bottomJqGridAddMainList"),
	        rowNum: 100, 
            rowList:[100,500,1000],
            recordtext: '내용 {0} - {1}, 전체 {2}',
       	 	emptyrecords:'조회 내역 없음',
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
 				//$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
 	 			//$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");
		    	
            	var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt($("#jqGridAddMainList").getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt($("#jqGridAddMainList").getGridParam("lastpage"));  
 	   			var pages = 1;
 	   			var rowNum 			  = 100;

 	   			/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
 	   			* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
 	   			* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
 	   			*/ 
 	   			/* this is to make the grid to fetch data from server on page click*/
 	   			if (pgButton == "user") {
 	   				if (pageIndex > lastPageX) {
 	   			    	pages = lastPageX
 	   			    } else pages = pageIndex;
 	   				
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'next_bottomJqGridAddMainList'){
 	   				pages = currentPageIndex+1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			} 
 	   			else if(pgButton == 'last_bottomJqGridAddMainList'){
 	   				pages = lastPageX;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'prev_bottomJqGridAddMainList'){
 	   				pages = currentPageIndex-1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'first_bottomJqGridAddMainList'){
 	   				pages = 1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
 	   			//$(this).jqGrid("clearGridData");
 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");
			},
  			loadComplete: function (data) {
  				
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
					
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total,
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;

				var cm = jqGridObj.jqGrid( "getGridParam", "colModel" );
				var colName = cm[iCol];
				
				if ( colName['index'] == "document_name" ) {
					
					var sURL = "popUpCommentAttachFile.do?row_selected="+row_selected;
					var popOptions = "dialogWidth:450px; dialogHeight: 100px; center: yes; resizable: no; status: no; scroll: no;"; 
					window.showModalDialog(sURL, window, popOptions);
					
				}
				
			},
			afterSaveCell : chmResultEditEnd
    	}); //end of jqGrid
    	
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 36 );
    	
  
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
			history.go(-1);
		});
		
		//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
		$("#btnAdd").click(function(){
			
			var date = new Date();
		    
	        var year  = date.getFullYear();
	        var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
	        var day   = date.getDate();
	     
	        if (("" + month).length == 1) { month = "0" + month; }
	        if (("" + day).length   == 1) { day   = "0" + day;   }
			
	        var today = year + "-" + month + "-" + day;
			
			jqGridObj.saveCell(kRow, idCol );
			
			var item = {};
			var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			var ids = jqGridObj.jqGrid('getDataIDs');
			
			// 1순위 - 하나만 체크인 상태에서 ADD할 경우, 체크된 ROW복사
			if(row_id.length == 1){
				var rowData = jqGridObj.getRowData(row_id[0]);
				item.receipt_no = rowData['receipt_no'];
				item.project_no = rowData['project_no'];
				item.doc_type = rowData['doc_type'];
				item.issuer = rowData['issuer'];
				item.subject = rowData['subject'];
				item.issue_date = rowData['issue_date'];
				item.com_no = rowData['com_no'];
				item.receipt_team_code = rowData['receipt_team_code'];
				item.receipt_team_name = rowData['receipt_team_name'];
				item.receipt_dept_code = rowData['receipt_dept_code'];
				item.receipt_dept_name = rowData['receipt_dept_name'];
				item.receipt_user_id = rowData['receipt_user_id'];
				item.receipt_user_name = rowData['receipt_user_name'];
			} else if(row_id.length > 1) {
				// 2순위 - 체크가 없는 상태에서 ADD할 경우, 바로 위의 ROW를 복사
				var cl = ids[ids.length-1];
		        var rowData = jqGridObj.getRowData(cl);
		        item.receipt_no = rowData['receipt_no'];
				item.project_no = rowData['project_no'];
				item.doc_type = rowData['doc_type'];
				item.issuer = rowData['issuer'];
				item.subject = rowData['subject'];
				item.issue_date = rowData['issue_date'];
				item.com_no = rowData['com_no'];
				item.receipt_team_code = rowData['receipt_team_code'];
				item.receipt_team_name = rowData['receipt_team_name'];
				item.receipt_dept_code = rowData['receipt_dept_code'];
				item.receipt_dept_name = rowData['receipt_dept_name'];
				item.receipt_user_id = rowData['receipt_user_id'];
				item.receipt_user_name = rowData['receipt_user_name'];
			} else {
				// 3순위 - 최초로 ADD할 경우
				for ( var i in colModel ) {
					item[colModel[i].name] = '';
				}
				
				if(admin_yn != 'Y') {
					item.receipt_team_code = "${loginUser.upper_dwg_dept_code}";
					item.receipt_team_name = "${loginUser.upper_dwg_dept_name}";
					item.receipt_dept_code = "${loginUser.dwg_dept_code}";
					item.receipt_dept_name = "${loginUser.dwg_dept_name}";
					item.receipt_user_id = "${loginUser.user_id}";
					item.receipt_user_name = "${loginUser.user_name}";
				}  
				
			}
			
			item.issue_date = today;
			item.oper = 'I';
			
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
		});
		
		//del 버튼  클릭
		$("#btnDel").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			
			var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			var ids = jqGridObj.getDataIDs();
			
				
			for(var i=selarrrow.length-1; i>=0; i--) {
				
				var item = jqGridObj.jqGrid("getRowData", selarrrow[i]);
				
				if( item.oper == 'I' ) {
					jqGridObj.jqGrid('delRowData', selarrrow[i]);	
				} else {
					/* //삭제 하면 안되는 조건
					if(item.status == 'C') {
						alert("승인완료되어 삭제가 불가 합니다. " + item.list_no + "-" + item.sub_no + "줄");
						return false;
					} else if(item.confirm_user_name != '') {
						alert("승인 요청중이므로 삭제가 불가 합니다." + item.list_no + "-" + item.sub_no + "줄");
						return false;
					} */
					
					jqGridObj.setCell (selarrrow[i], 'oper','D', '');
					jqGridObj.setRowData(selarrrow[i], false, {background: '#FFFFA2'});
				}
				
			}
			
		});
		
		//Next 클릭
		$("#btnNext").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
			var formData = fn_getFormData('#application_form');
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			if($("#stepState").val() == "1") {
				var changeRows = [];
				var rtn = true;
				
				getChangedChmResultData(function(data) {
					
					changeRows = data;
					if (changeRows.length == 0) {
						alert("내용이 없습니다.");
						return;
					}
					
					for(i=0; i<changeRows.length; i++) {
						if(changeRows[i].dwg_no == 'N/A' && changeRows[i].receipt_dept_name == '') {
							alert("도면 채번시 담당파트은 필수 입니다.");
							rtn = false;
							return false;
						}
					}
					
					$(".required_cell").each(function(){
						if($(this).text().trim() == ""){
							alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
							$(this).context.style.backgroundColor = "#ff9999";
							rtn = false;
							return false;
						}
						else{
							$(this).context.style.backgroundColor = "#F7FC96";
						}
					});
					
					if(!rtn){
						return false;
					}
					
					//back버튼 클릭시 필요한 리스트
					backList = changeRows;
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var parameters = $.extend({}, dataList, formData);

					$(".loadingBoxArea").show();
					$("input[name=p_isPaging]").val("Y");
				
					//검색 시 스크롤 깨짐현상 해결
					jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
					getJsonAjaxFrom("commentReceiptAddValidationCheck.do", parameters, null, callback_next);
					
				});
				
			} else if($("#stepState").val() == "2") {
				//승인 로직
				if(confirm('적용하시겠습니까?')){
					$(".loadingBoxArea").show();
					$.post("commentReceiptAddApplyAction.do",formData ,function(data){
	 							$(".loadingBoxArea").hide();
	 							alert(data.resultMsg);
	 							$("#btnClose").click();
	 						},"json");
				}
			}
			
			
		});
		
		//Back 기능
		$("#btnBack").click(function(){
			
			var jsonGridData = new Array();
			
			if(confirm('뒤로 돌아가시겠습니까?')){	
				$( jqGridObj).jqGrid( "clearGridData" );
				
				for ( var i = 0; i < backList.length; i++ ) {
					jsonGridData.push({ receipt_no : ''
			             , project_no : backList[i].project_no
			             , doc_type : backList[i].doc_type
			             , issuer : backList[i].issuer
			             , subject : backList[i].subject
			             , issue_date : backList[i].issue_date
			             , com_no : backList[i].com_no
			             , receipt_team_code : backList[i].receipt_team_code
			             , receipt_team_name : backList[i].receipt_team_name
			             , receipt_dept_code : backList[i].receipt_dept_code
			             , receipt_dept_name : backList[i].receipt_dept_name
			             , receipt_user_id : backList[i].receipt_user_id
			             , receipt_user_name : backList[i].receipt_user_name
			             , dwg_no : backList[i].dwg_no
			             , document_name : backList[i].document_name
			             , dec_document_name : backList[i].dec_document_name
			             , oper : backList[i].oper});
				}
					
				jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
				callback_back();
			}
			//검색 시 스크롤 깨짐현상 해결
			jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
		});
		
		//Excel Import 클릭
		$("#btnExlImp").click(function(){

			var sURL = "popUpCommentAttachExcel.do";
			var popOptions = "dialogWidth: 400px; dialogHeight: 380px; center: yes; resizable: no; status: no; scroll: no;"; 
			window.showModalDialog(sURL, window, popOptions);
			
			
			/* var rs = window.open("popUpCommentAttachExcel.do", "", "height=400,width=400,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
			jqGridObj.saveCell(kRow, idCol ); */
			
		});
		
		//Excel Form 클릭 다운로드	
		$("#btnForm").click(function(){
			$.download('fileDownload.do?fileName=CommentReceiptAdd.xlsx', null, 'post');
		});
	
		
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		if(val == null) val = "";
		//입력 후 대문자로 변환
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
		
	}
	
	
	//CallBack Next 이후 버튼 상태 변경
	var callback_next = function(json) {
		$("#btnBack").show();
		//Work Key 넘겨줌 
		$("input[name=p_work_key]").val(json.p_work_key);
		//그리드 초기화
		$( jqGridObj).jqGrid( "clearGridData" );
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : 'commentReceiptWorkValidationList.do',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			rowNum : $('.ui-pg-selbox option:selected').val(),
			postData : fn_getFormData('#application_form'),
			cellEdit : false
		} ).trigger( "reloadGrid" );
		
		//그리드 초기화 이후 Select Box 해제 
		$("#btnFolder").hide();
		$("#btnExlImp").hide();	
		$("#btnAdd").hide();		
		$("#btnDel").hide();		
		$("#btnClose").attr("disabled", "disabled");
		
		if($("#stepState").val() == "1"){
			$("#stepState").val("2");
			$("#btnNext").attr("value", "APPLY");
		}
		
		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
		$(".loadingBoxArea").hide();
	}
	
	var callback_back = function(){
		$(".loadingBoxArea").hide();
		
		$("#btnFolder").show();
		$("#btnExlImp").show();	
		$("#btnAdd").show();		
		$("#btnDel").show();		
		$("#btnClose").removeAttr("disabled");
		$("#btnBack").hide();
		$("#stepState").val("1");
		
		$("#AddPagingArea").text("");
		$("#btnNext").attr("value", "NEXT");
		
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : '',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData('#application_form'),
			cellEdit : true
		} ).trigger( "reloadGrid" );
		
		//검색 시 스크롤 효과 없애기
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
	}
	
	
	//그리드 변경된 내용을 가져온다.
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( jqGridObj.jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		} );
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
</script>
</body>

</html>
