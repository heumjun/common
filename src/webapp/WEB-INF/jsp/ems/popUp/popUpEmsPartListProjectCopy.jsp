<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>EMS Part List Project Copy</title>
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
	<input type="hidden" name="p_is_excel" value="N" />
	<input type="hidden" name="pageYn" value="Y" />
	<input type="hidden" name="p_partlist_id" value="${partlistInfo.partlist_id}" />
	<input type="hidden" name="p_project_no" value="${partlistInfo.project_no}" />
	
	
	<div class="mainDiv" id="mainDiv">	
		<div class="subtitle">
			Project Copy
		</div>
		<div class="popupHeader">
			<div class="buttonArea">
				<input type="button" class="btn_blue" value="다음" id="btnNext"/>
				<input type="button" class="btn_blue" value="저장" id="btnSave" style="display:none"/>
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
		
		<table class="searchArea2">
			<tr>
				<td>
					<div id="SeriesCheckBox"></div>
				</td>
			</tr>
		</table>
		
		<div class="content">
			<table id="jqGridPartListProjectCoypList"></table>
			<div id="bottomJqGridPartListSProjectCoypList"></div>
		</div>
	</div>
</form>	

<script type="text/javascript" >
	var idRow;
	var idCol;
	var kRow;
	var kCol;

	var jqGridObj = $("#jqGridPartListProjectCoypList");
	var requiredColName = new Array("ea_plan", "drawing_no", "plm_block_no", "plm_stage_no", "plm_str_flag", "plm_str_key", "plm_mother_code");
	
	$(document).ready(function(){
		//시리즈 호선 받기		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y&p_self_view=N", null);
		
		var gridColModel = [ {label:'partlist_id', name:'partlist_id', index:'partlist_id', width:60, align:'center', sortable:false, hidden:true},
		                     {label:'bom_id', name:'bom_id', index:'bom_id', width:60, align:'center', sortable:false, hidden:true},
		                     {label:'PROJECT', name:'project_no', width:100, align:'center', sortable:true, title:false},
							 {label:'ITEM CODE', name:'plm_item_code', width:100, align:'center', sortable:true, title:false},
							 {label:'EA', name:'bom_quantity', width:50, align:'center', sortable:true, title:false, editable:true},
							 {label:'DWG NO', name:'drawing_no', width:80, align:'center', sortable:true, title:false, editable:true},
							 {label:'BLOCK', name:'plm_block_no', index:'plm_block_no', width:60, align:'center', sortable:true, title:false},
							 {label:'STAGE', name:'plm_stage_no', index:'plm_stage_no', width:80, align:'center', sortable:false, editable:true},
							 {label:'STR', name:'plm_str_flag', index:'plm_str_flag', width:60, align:'center', sortable:true, title:false},
							 {label:'KEY', name:'plm_str_key', width:60, align:'center', sortable:true, title:false, editable:true} ,
							 {label:'MOTHER', name:'plm_mother_code', width:120, align:'center', sortable:true, title:false, editable:true} ,
							 {label:'JOB', name:'primary_item_code', index:'primary_item_code', width:160, align:'center', sortable:false, title:false},
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
            cellEdit : false,
            cellsubmit : 'clientArray', // grid edit mode 2
            multiselect: false,
            shrinkToFit: true,
            height: 460,
            pager: '#bottomJqGridPartListSProjectCoypList',
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

		// 다음 버튼
		$("#btnNext").click(function(){
			
			jqGridObj.saveCell( kRow, idCol );

			if ($("input[name=p_series]:checked").size() == 0) {
				alert("시리즈를 선택하십시오.");
				return;
			}
			
			//체크 된 시리즈 받아옴.
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({}, {rows:100, page:1, sord:'asc'}, formData);
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ));
			
			$.post( 'emsPartListProjectCopyNextList.do?p_chk_series='+ar_series, parameters, function( data ) {
				
				jqGridObj.jqGrid( "clearGridData" );
				
				var item = {};
				var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
				
				for ( var i in colModel ){
					item[colModel[i].name] = '';
				}
					
				for ( var i in data.rows ){
					item.partlist_id = data.rows[i].partlist_id;
					item.project_no = data.rows[i].project_no;
					item.plm_item_code = data.rows[i].plm_item_code;
					item.bom_quantity = data.rows[i].bom_quantity;
					item.drawing_no = data.rows[i].drawing_no;
					item.bom_quantity = data.rows[i].bom_quantity;
					item.plm_block_no = data.rows[i].plm_block_no;
					item.plm_stage_no = data.rows[i].plm_stage_no;
					item.plm_str_flag = data.rows[i].plm_str_flag;
					item.plm_str_key = data.rows[i].plm_str_key;
					item.plm_mother_code = data.rows[i].plm_mother_code;
					item.primary_item_code = data.rows[i].primary_item_code;
					
					item.oper = 'I';
					
					jqGridObj.resetSelection();
					jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
					
				
				}
				
				$("#btnNext").hide();
				$("#btnSave").show();
				
			}, "json").error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				loadingBox.remove();
			} );
				
		});
		
		// 저장 버튼
		$("#btnSave").click(function(){
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ));
			
			var formData = fn_getFormData('#application_form');
			
			getGridChangedData(jqGridObj,function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				if(confirm('저장하시겠습니까?')){
					
					$.post("emsPartListProjectCopySave.do",parameters ,function(data){
						alert(data.resultMsg);
						$("#btnSearch").click();
					},"json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				}
			});
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