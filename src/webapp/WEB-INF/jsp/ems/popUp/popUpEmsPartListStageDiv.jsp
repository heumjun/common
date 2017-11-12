<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>EMS Part List Stage Div</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	body{overflow-x:hidden; width:100%; }
	.popupHeader{position:relative; width:98%; height:30px; margin-top:10px; }
	.popupHeader .searchArea{width:45%; float:left; height:25px;}	
	.popupHeader .buttonArea{width:55%; float:right; text-align:right}
	.popupHeader .buttonArea input{height:24px;}
	.popupHeader .seriesArea .appProject{color:#376091; font-weight:bold;}
	
	input[type=button] {width:70px;}
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.disableInput {background-color:#dedede}
	.required_cell{background-color:#F7FC96}
	.disabled_cell{background-color:#CDCDCD}

</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" name="pageYn" value="" />
	<input type="hidden" name="p_partlist_id" value="${partlistInfo.partlist_id}" />
	<input type="hidden" name="p_project_no" value="${partlistInfo.project_no}" />
	
	
	<div class="mainDiv" id="mainDiv">	
		<div class="subtitle">
			Stage Div
		</div>
		<div class="popupHeader">
			<div class="buttonArea">
				<input type="button" class="btn_blue" value="저장" id="btnSave"/>
				<input type="button" class="btn_blue" value="닫기" id="btnClose"/>
			</div>
		</div>
		<table id="item_detail" class="detailArea conSearch">
			<tr>
				<th>Project</th>					
				<th>Tag No</th>
				<th>Maker</th>
				<th>Description</th>
				<th>EA</th>
				<th>Equip Name</th>
			</tr>
			<tr>
				<td>${partlistInfo.project_no}</td>
				<td>${partlistInfo.tag_no}</td>
				<td>${partlistInfo.maker}</td>
				<td>${partlistInfo.equip_description}</td>
				<td>${partlistInfo.ea_obtain}</td>
				<td>${partlistInfo.equipment_name}</td>
			</tr>
		</table>
		
		<div class="popupHeader">
			<div class="buttonArea">
				<input type="button" class="btn_blue" value="ADD" id="btnAdd"/>
				<input type="button" class="btn_blue" value="DELETE" id="btnDel"/>
			</div>
		</div>
		
		<div class="content">
			<table id="jqGridPartListStageDivList"></table>
			<div id="bottomJqGridPartListStageDivList"></div>
		</div>
	</div>
</form>	

<script type="text/javascript" >
	var idRow;
	var idCol;
	var kRow;
	var kCol;

	var jqGridObj = $("#jqGridPartListStageDivList");
	var requiredColName = new Array("ea_plan", "drawing_no", "plm_block_no", "plm_stage_no", "plm_str_flag", "plm_str_key", "plm_mother_code");
	
	$(document).ready(function(){
		
		var gridColModel = [ {label:'bom_id', name:'bom_id', index:'bom_id', width:60, align:'center', sortable:false},
							 {label:'ITEM CODE', name:'plm_item_code', width:100, align:'center', sortable:true, title:false, editable:false} ,
							 {label:'EA', name:'ea_plan', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';},} ,
							 {label:'BLOCK', name:'plm_block_no', index:'plm_block_no', width:60, align:'center', sortable:true, title:false, editable:true,
									editoptions: { 
							            dataEvents: [{
							            	type: 'change'
							            	, fn: function(e) {
							            		var row = $(e.target).closest('tr.jqgrow');
							                    var rowId = row.attr('id');
							                    //job code 셋팅
							                    setJobCode(rowId);
							                }
							            }]
									 }
								},
							 {label:'STAGE', name:'plm_stage_no', index:'plm_stage_no', width:80, align:'center', sortable:false, editable:true},
							 {label:'STR', name:'plm_str_flag', index:'plm_str_flag', width:60, align:'center', sortable:true, title:false, editable:true,
									 editoptions: { 
							            dataEvents: [{
							            	type: 'change'
							            	, fn: function(e) {
							            		var row = $(e.target).closest('tr.jqgrow');
							                    var rowId = row.attr('id');
							                    //job code 셋팅
							                    setJobCode(rowId);
							                }
							            }]
									 }
							 },
							 {label:'KEY', name:'plm_str_key', width:60, align:'center', sortable:true, title:false, editable:true} ,
							 {label:'DWG NO', name:'drawing_no', width:80, align:'center', sortable:true, title:false, editable:true, hidden:true} ,
							 {label:'MOTHER', name:'plm_mother_code', width:120, align:'center', sortable:true, title:false, editable:true, hidden:true} ,
							 {label:'JOB', name:'primary_item_code', index:'primary_item_code', width:160, align:'center', sortable:false, title:false, editable:true,
								 edittype : "select",
						   		 editrules : { required : false },
						   		 cellattr: function (){return 'class="required_cell"';},
						   		 editoptions: {
						   			dataUrl: function(){
						             	var item = jqGridObj.jqGrid( 'getRowData', idRow );
						             	var url = "";
						             	if(item.plm_block_no != ""){
						 					url = "emsPartListJobList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_block_no="+item.plm_block_no.toUpperCase()+"&p_str_flag="+item.plm_str_flag.toUpperCase();
								 		}
						 				return url;
								 	},
						   		 	buildSelect: function(data){
						      		 	if(typeof(data)=='string'){
						      		 		data = $.parseJSON(data);
						      		 	}
						       		 	var rtSlt = '<select name="deptid">';
						       		 	
						       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
											if(data.length == 2 && data[idx].value != " "){
												rtSlt +='<option value="'+data[idx].value+'">'+data[idx].text+'</option>';	
							       		 	}else{
							       		 		rtSlt +='<option value="'+data[idx].value+'">'+data[idx].text+'</option>';
							       		 	}
						       		 	}
							       		rtSlt +='</select>';
							       		
							       		return rtSlt;
						   		 	}
						   		 }
						   	 },
							 {label:'oper', name:'oper', width:40, align:'center', sortable:true, title:false, hidden:true} ];
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            mtype : 'POST',
            url:'emsPartListBomDetail.do',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
            multiselect: true,
            shrinkToFit: true,
            height: 460,
            pager: '#bottomJqGridPartListStageDivList',
            rowList:[100,500,1000],
	        rowNum:100, 
	        recordtext: '내용 {0} - {1}, 전체 {2}',
       	    emptyrecords:'조회 내역 없음',
       	    afterSaveCell : chmResultEditEnd,
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol);
				
				if (rowid != null) {
					var ret = jqGridObj.getRowData(rowid);
					if (ret.oper != "I") {
						jqGridObj.jqGrid('setCell',rowid, 'type_abbr','','not-editable-cell');
					}
				}
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 60 );

		//Close 버튼 클릭.
		$("#btnClose").click(function(){
			self.close();
		});
		
		//Search 클릭
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			//Paging Setting
			$("input[name=p_is_excel]").val("N");
			$("input[name=pageYn]").val("N");
			
			var sUrl = "sscCableTypeMainList.do";
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		});


		//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
		$("#btnAdd").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
			
			var item = {};
			var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
			
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.plm_item_code = 'YARD';

			jqGridObj.resetSelection();
			
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			
		});
		

		//del 버튼  클릭
		$("#btnDel").click(function(){
		
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
			//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
			var row_len = row_id.length;					
			//I 인것들은 바로 없앰
			for(var i=0; i<row_len; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[0]);
				if (item.oper == 'I'){		
					jqGridObj.jqGrid('delRowData',row_id[0]);	
				}
			}
			//I가 아닌 것들을 다시 row_id 구해서 'D' 값 처리
			row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				if (item.oper != 'I'){
					item.oper = 'D';
					jqGridObj.jqGrid( "setRowData", row_id[i], item );
					jQuery("#"+row_id[i]).css("background", "#F4B5A9");
				}
			}
			
			//전체 체크 해제
			jqGridObj.resetSelection();
			
		});

		// 저장버튼
		$("#btnSave").click(function(){
			
			var logingubun = $('#loginGubun').val();

			var itemcodes = "";
			var item_codes = "'";
			var rtn = true;
			
			jqGridObj.saveCell( kRow, idCol );
			
			$(".required_cell").each(function(){	
				if($(this).text().trim() == ""){
					alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
					rtn = false;
					return false;
				}
			});
			

			if(!rtn){
				return false;
			}
			
			
			if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
				var changeRows = [];
				
				
				getGridChangedData(jqGridObj,function(data) {				
					changeRows = data;

					if (changeRows.length == 0) {
						alert("저장할 내역이 없습니다.");
						return;
					}
					
					
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var url = 'emsPartListSaveAction.do';
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend( {}, dataList, formData );
					
					loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						
						jqGridObj.jqGrid( "clearGridData");
						jqGridObj.jqGrid( 'setGridParam').trigger( "reloadGrid" );
						
					}, "json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				} );
			}
				
		});
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
		
	}


	function setJobCode(rowId){
			
		jqGridObj.saveCell(kRow, idCol );
		
		//초기화
		jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', "&nbsp;");
		
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		//속도 문제로 block No가 들어왔을 때만 실행.
		if(item.plm_block_no != ""){
		    $.ajax({
				url : "emsPartListJobList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_block_no="+item.plm_block_no.toUpperCase()+"&p_str_flag="+item.plm_str_flag.toUpperCase(),
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length == 1){
						jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', data[0].value);
					}else{
						jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', '&nbsp;');
					}
				}
			});
		}
	}
	

	function cellItemCodeChangeAction(irow, cellName, cellValue, rowIdx){
		
		jqGridObj.saveCell(kRow, idCol );
		//선택한 행의 rowIdx 구함
		if(typeof(rowIdx) == "undefined" && kRow > 0){
			rowIdx = kRow-1;
		}
		
		//MARKER이면 수정 불가능
		if(cellValue != "YARD"){
			//컬럼 색상 변경 
			//jQuery(jqGridObj).setCell (irow, 'item_code','', noUniqCellBgColor);
			for (var i=0; i<requiredColName.length; i++){
				jQuery(jqGridObj).setCell (irow, requiredColName[i],'&nbsp;', '');
				syncClassByContainRow(jqGridObj, rowIdx, requiredColName[i],'', false,'required_cell');
				//컬럼 editable 설정
				changeEditableByContainRow(jqGridObj, rowIdx, requiredColName[i],'',true);
			}
		}else{
			//컬럼 색상 변경 (필수값)
			//jQuery(jqGridObj).setCell (irow, 'item_code','', uniqCellBgColor);		
			for (var i=0; i<requiredColName.length; i++){
				syncClassByContainRow(jqGridObj, rowIdx, requiredColName[i],'', true,'required_cell');
				//컬럼 editavle 설정 해제
				changeEditableByContainRow(jqGridObj, rowIdx, requiredColName[i],'',false);
			}
		}
	}

	
	
	
</script>
</body>

</html>