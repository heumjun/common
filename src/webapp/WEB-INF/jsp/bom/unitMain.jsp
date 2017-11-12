<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Unit Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>	
	.onMs{background-color:#FFFA94;}
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >	
	<input type="hidden" name="p_nowpage" value="1" />	
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" name="p_bom_type" value="" />
	<input type="hidden" name="pageYn" value="" />	
	<!-- ALL BOM ECO 번호 -->
	<input type="hidden" name="p_input_eco_no" value="" />
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			Unit Management			
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="100"/>
		<col width="200"/>
		<col width="100"/>
		<col width="100"/>
		<col width="*"/>
	<tr>
		<th>Project</th>
		<td>
			<select name="p_ship" id="p_ship" >
				<option value="master" <c:if test="${p_ship=='master'}">selected="selected"</c:if> >Master</option>
				<option value="project" <c:if test="${p_ship=='project'}">selected="selected"</c:if> >Project</option>
			</select>
			<input type="text" class = "required"  name="p_project_no" alt="Project"  style="width:70px;" value="" onblur="javascript:getDwgNos();"  />
		</td>
		
		<th>DWG No.</th>
		<td style="border-right:none;">
		<input type="text" id="p_dwg_no" name="p_dwg_no" class = "required" style="width:80px;" value="${p_dwg_no}" alt="DWG NO." />
		</td>
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue" value="Search" id="btnSearch"/>
				<input type="button" class="btn_blue" value="Export" id="btnExcel"/>
				<input type="button" class="btn_blue" value="Save" id="btnSave"/>
				<input type="button" class="btn_blue" value="Restore" id="btnRestore"/>
				<input type="button" class="btn_blue" value="Add" id="btnAdd"/>
				<input type="button" class="btn_blue" value="Modify" id="btnModify"/>
				<input type="button" class="btn_blue" value="Delete" id="btnDelete"/>
				<input type="button" class="btn_blue" value="BOM" id="btnBom"/>
			</div>
		</td>	
		</tr>
		</table>
		<table class="searchArea2">
		<col width="100"/>
		<col width="200"/>
		<col width="100"/>
		<col width="200"/>
		<col width="100"/>
		<col width="200"/>
		<col width="100"/>
		<col width="*"/>
			<tr>
				<th>Block</th>
				<td>
				<input type="text" class="commonInput" name="p_block_no" value="" style="width:40px;" />
				</td>
					<th>Dept.</th><td>
						
						<c:choose>
							<c:when test="${loginUser.gr_code=='M1'}">
								<select name="p_sel_dept" id="p_sel_dept" style="width:110px;" onchange="javascript:DeptOnChange(this);" >
								</select>
								<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
								<input type="hidden" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
							</c:when>
							<c:otherwise>
								<input type="text" name="p_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:110px;" readonly="readonly" />
								<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
							</c:otherwise>
						</c:choose>
					</td>
					<th>User</th><td>
						 <input type="text" class="disableInput" name="p_user" style="margin-right:20px; width:55px;" value="<c:out value="${loginUser.user_name}" />" readonly="readonly"/>
					</td>
					<!-- Raw Material 정보 -->
				<c:choose>
						<c:when test="${p_item_type_cd == 'PI'}">
							<th>RAW MATERIAL</th><td>
								<label><input type="checkbox" name="p_rawmaterial" id="p_rawmaterial" value="Y"/>R/M</label>
							</td>
						</c:when>
					</c:choose>
					<th>State</th><td>
						<select name="p_state_flag" class="commonInput">
							<option value="ALL" selected="selected">ALL</option>
							<option value="A" >A</option>
							<option value="D" >D</option>
							<option value="C" >C</option>
							<option value="Act" >Act</option>
						</select>
					</td>
					
			</tr>
			</table>
			<table class="searchArea2">
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="*"/>
				<tr>
					<th>Pending Mother</th><td>
						 <input type="text" class="commonInput bigInput" name="p_mother_code" value=""  />
					</td>
					<th>Item Code</th><td>
						 <input type="text" class="commonInput bigInput" name="p_item_code" value="" />
					</td>
					<!-- 
					<div class="searchDetail">
						Description <input type="text" class="bigInput" name="p_description" value="" />
					</td>
					 -->
					 <th>ECO No.</th><td>
						 <input type="text" class="commonInput" name="p_eco_no" value="" style="width:70px;"  />
					</td>
					<th>Rev.</th><td>
						
						<input type="hidden" name="p_hd_selrev" value="<c:out value="${p_selrev}" />" />
						<select name="p_selrev" id="p_selrev" style="width:60px;" >
						</select>
					</td>
			</tr></table>
			<table class="searchArea2">
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="200"/>
			<col width="100"/>
			<col width="*"/>
				<tr>
					<th>ECO</th><td>
						<select name="p_is_eco" class="commonInput">
							<option value="ALL" selected="selected">ALL</option>
							<option value="Y" >Y</option>
							<option value="N" >N</option>
						</select>
					</td>			
					<th>Release</th><td>
						
						<select name="p_release" class="commonInput">
							<option value="ALL" selected="selected">ALL</option>
							<option value="Y" >Y</option>
							<option value="N" >N</option>
						</select>
					</td>
					<th>상위조치</th><td>
						
						<select name="p_upperaction" class="commonInput">
							<option value="ALL" selected="selected">ALL</option>
							<option value="Y" >Y</option>
							<option value="N" >N</option>
						</select>
					</td>
					<th>생성일자</th><td>
						
						<input type="text" name="p_start_date" id="p_start_date" class="commonInput" style="width:70px;" value=""/>
						~
						<input type="text" name="p_end_date" id="p_end_date" class="commonInput" style="width:70px;" value=""/>
					</td>
					<th>JOB 상태</th><td>
						
						<select name="p_job_status" class="commonInput" style="width:75px;" >
							<option value="ALL" selected="selected">ALL</option>
							<option value="릴리즈됨" >릴리즈됨</option>
							<option value="완료" >완료</option>
							<option value="마감" >마감</option>
						</select>
					</td>
			</tr>
		</table>
		<div class="content">
			<table id="jqGridUnitMainList"></table>
			<div id="bottomJqGridUnitMainList"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	
	var jqGridObj = $("#jqGridUnitMainList");
	
	//기술 기획일 경우 부서 선택 기능
	if(typeof($("#p_sel_dept").val()) !== 'undefined'){
		getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
	}
	
	//달력 셋팅
	$(function() {
	  	$( "#p_start_date, #p_end_date" ).datepicker({
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
	  	});
	});
	
	var getDwgNos = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
	
			getAjaxTextPost(null, "sscAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		}
	}
	//도면번호 받아온 후
	var getdwgnoCallback = function(txt){
		var arr_txt = txt.split("|");
	    $("#p_dwg_no").autocomplete({
			source: arr_txt,
			minLength:1,
			matchContains: true, 
			max: 30,
			autoFocus: true,
			selectFirst: true
		});
	}
	
	///프로젝트 클릭시 popup event실행
	var rowClick = function(count, dg_project,project_no,dwg_no,mother_code,item_code){
		var number = count;
		var	pv_dg_project = dg_project;
		var pv_project_no = project_no;
		var pv_dwg_no = dwg_no;
		var pv_mother_code = mother_code;
		var pv_item_code = item_code;
		var sURL = "/ematrix/tbcAftPopup.tbc";
		
		$("input[name=p_daoName]").val("");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("");
		$("input[name=p_dg_project]").val(pv_dg_project);
		$("input[name=p_project_no]").val(pv_project_no);
		$("input[name=p_dwg_no]").val(pv_dwg_no);
		$("input[name=p_mother_code]").val(pv_mother_code);
		$("input[name=p_item_code]").val(pv_item_code);

		form = $('#application_form');
		//form.attr("action", "/ematrix/tbctestsubbody.tbc");
		form.attr("action", sURL);

	    var popOptions = "width=980,height=768, scrollbars=yes, resizable=yes"; 
	    var popup = window.open("", "SUPopup", popOptions);
	    
		form.attr("target","SUPopup");
		form.attr("method", "post");	
		
	    popup.focus(); 
		form.submit();
	} 
	
	var vItemTypeCd = $("input[name=p_item_type_cd]").val();
	
	var gridColModel = [{label:'State', name:'state_no', index:'bom_id', width:60, align:'center', sortable:false, hidden:true},
	                    {label:'Master', name:'bom_id', index:'bom_id', width:60, align:'center', sortable:false, hidden:true},
	                    {label:'Project', name:'project_no', index:'project_no', width:60, align:'center', sortable:false},
	                    {label:'Block', name:'equipment_name', index:'equipment_name', width:330, align:'left', sortable:false},
						{label:'Act Code', name:'tag_no', index:'tag_no', width:100, align:'center', sortable:false}, 
						{label:'Act Desc', name:'equip_description', index:'equip_description', width:330, align:'left', sortable:false}, 
						{label:'Unit Code', name:'ea_obtain', index:'ea_obtain', width:40, align:'center', formatter:'integer', sortable:false},
						{label:'Unit Desc', name:'creation_date', index:'creation_date', width:120, align:'center', sortable:false}, 
						{label:'Unit Name', name:'dept_name', index:'dept_name', width:160, align:'center', sortable:false},
						{label:'STR', name:'dept_name', index:'dept_name', width:160, align:'center', sortable:false},
						{label:'P/Mother', name:'dept_name', index:'dept_name', width:160, align:'center', sortable:false},
						{label:'Depart', name:'dept_name', index:'dept_name', width:160, align:'center', sortable:false},
						{label:'USER', name:'user_name', index:'user_name', width:100, align:'center', sortable:false}, 
						{label:'Date', name:'plm_comment', index:'plm_comment', width:150, align:'center', sortable:false, editable:true},
						{label:'Eco', name:'plm_comment', index:'plm_comment', width:150, align:'center', sortable:false, editable:true},
						{label:'Release', name:'plm_comment', index:'plm_comment', width:150, align:'center', sortable:false, editable:true},
						{label:'oper', name:'oper', index:'oper', width:100, align:'center', sortable:false, hidden:true}
			            ];
	
	$(document).ready(function(){
		
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'sscMainList.do',
             mtype : 'POST',
             postData : fn_getFormData('#application_form'),
             colModel: gridColModel,
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: true,
             shrinkToFit: false,
             height: 460,
             pager: '#bottomJqGridUnitMainList',
             rowList:[100,500,1000],
	         rowNum:100, 
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
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 120 );

		
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			$("input[name=p_is_excel]").val("N");
			$("input[name=pageYn]").val("N");
			
			var sUrl = "sscMainList.do";
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
			
		});
		//처음 Search 
		//$("#btnSearch").click();
		
		
		
		//Add 버튼 클릭 시 
		$("#btnAdd").click(function(){
		
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			
			//도면 번호 체크
			var rtn = fn_dwg_validataion();
			
			if(!rtn){
				return false;
			}
			
			if(uniqeValidation()){
				form = $('#application_form');
				
				form.attr("action", "sscAddMain.do");
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			}
		});
		
		//Bom 버튼 클릭 시 
		$("#btnBom").click(function(){			
			
			var rtn = true;
			
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
		
			//행을 읽어서 키를 뽑아낸다.
			var ssc_sub_id = new Array();
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				if(item.eco_no != ""){
					alert("이미 ECO가 연계되어 있는 대상이 있습니다.");			
					rtn = false;
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			if(!rtn){
				return false;
			}
			
			form = $('#application_form');
			form.attr("action", "sscBomMain.do?p_ssc_sub_id="+ssc_sub_id);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			
			
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "D"){
					alert("선택한 Data는 Delete 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			form = $('#application_form');
			form.attr("action", "sscDeleteMain.do?p_ssc_sub_id="+ssc_sub_id);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		
		//공지사항 보기 클릭 시 
		$("#btnNotice").click(function(){
			var sURL = "/ematrix/tbcBoardMainUser.tbc";
			var popOptions = "width=1200, height=800, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions);
		});		
		//Move 버튼 클릭 시 
		$("#btnModify").click(function(){


			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "D"){
					alert("선택한 Data는 Modify 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			form = $('#application_form');
			form.attr("action", "sscModifyMain.do?p_ssc_sub_id="+ssc_sub_id);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		//Pending 버틀 클릭 시
		$("#btnPending").click(function(){
			//팝업으로 대체!
			var sURL = "/ematrix/tbcPendingManagerMain.tbc?p_project="+$("input[name=p_project]").val()+"&p_ship="+$("input[name=p_ship]").val();
			var popOptions = "width=1410, height=700, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		
		
		//Buy Buy 클릭시 
		$("#btnBuyBuy").click(function(){
			
			var inputChecked = $("input[name=p_chkItem]:checked");
	
			if(inputChecked.length > 1){
				alert("하나의 행만 체크하십시오.");
				return; 
			}
			var vItemCode = inputChecked.parent().parent().find(".txtItemCode").text();
			var vMasterCode = inputChecked.parent().parent().find(".txtMasterCode").text();
			var vDwgNo = inputChecked.parent().parent().find(".txtDwgNo").text();
			var vDesc = inputChecked.parent().parent().find(".txtDesc").text();

			var sURL = "sscBuyBuyMain.do?p_item_code="+vItemCode+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_master_no="+vMasterCode+"&p_dwg_no="+vDwgNo+"&p_desc="+vDesc;
			var popOptions = "width=1200, height=600, resizable=yes, status=no, menubar=no, toolbar=no, scrollbars=yes, location=no"
			window.open(sURL, "disPopupBuyBuy", popOptions).focus();
			
		});
		
		//Buy Buy 클릭시 
		$("#btnValveItem").click(function(){		
			var sURL = "/ematrix/TBC/tbc_ValveItemMain.jsp?p_master="+$("input[name=p_project]").val();
			var popOptions = "width=1320, height=600, resizable=yes, status=no, menubar=no, toolbar=no, scrollbars=yes, location=no"
			window.open(sURL, "popupBuyBuy", popOptions).focus();			
		});
		
		
		//Restore 버튼 클릭 시 
		$("#btnRestore").click(function(){

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			var rtn = true;
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				

				//아이템 체크 Validation				
				if(item.state_flag == "A" && item.eco_no == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			if(!rtn){
				return false;
			}
			
			if(confirm("Restore 하시겠습니까?")){
				var form = $('#application_form');
				$(".loadingBoxArea").show();
				$.post("sscRestoreAction.do?p_ssc_sub_id="+ssc_sub_id,form.serialize(),function(json)
				{	
					alert(json.resultMsg);
					$(".loadingBoxArea").hide();
					fn_search();
				},"json");
			}
		});
		
		
		$("#btnEcoCancel").click(function(){

			var vEcoNo = "";
			$("input[name=p_chkItem]").each(function(){
				if($(this).is(":checked")){
					vEcoNo = $(this).parent().parent().find(".td_eco").text();
					return false;
				}
			});
			
			var sURL = "/ematrix/tbcBomCancelMain.tbc?p_item_type_cd="+$("input[name=p_item_type_cd]").val() + "&p_eco_no="+vEcoNo;
			var popOptions = "width=1200, height=730, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions).focus();
		});
		
		//All BOM 버튼 클릭 시 
		$("#btnAllBom").click(function(){	
			if(confirm("검색된 모든 ITEM을 일괄 BOM연계 하시겠습니까?")){
			/*
				form = $('#application_form');
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("");
				$("input[name=p_queryType]").val("");
				$("input[name=p_process]").val("");
				$("input[name=p_bom_type]").val("all");
				//필수 파라미터 E		
				
				var sURL = "/ematrix/tbcAllBom.tbc";
				
			    var popOptions = "width=600, height=200, scrollbars=no"; 
			    var popup = window.open("", "allbomPop", popOptions);
			    form.attr("action", sURL);
	 			form.attr("target","allbomPop");
				form.attr("method", "post");	
				popup.focus(); 
				form.submit();
			*/
				var sURL = "/ematrix/tbcAllBom.tbc?p_item_type_cd="+$("input[name=p_item_type_cd]").val();
				var popOptions = "dialogWidth: 600px; dialogHeight: 200px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
				
				
			    
			}
		});
		
		
		//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			if(confirm("Save 하시겠습니까?")){
				var formData = fn_getFormData('#application_form');
				$(".loadingBoxArea").show();

				$.post("sscMainSaveAction.do",formData,function(json)
				{	
					$(".loadingBoxArea").hide();
					alert(data.resultMsg);
					$("#btnSearch").click();
				},"json");

			}
		});
		
		//Excel 버튼 클릭 시 
		$("#btnExcel").click(function(){
			//if($("#listSize").val() > 0){
				
				//그리드의 label과 name을 받는다.
				//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
				var colName = new Array();
				var dataName = new Array();
				
				for(var i=0; i<gridColModel.length; i++ ){
					if(gridColModel[i].hidden != true){
						colName.push(gridColModel[i].label);
						dataName.push(gridColModel[i].name);
					}
				}
				
				form = $('#application_form');

				$("input[name=p_is_excel]").val("Y");
				//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
				form.attr("action", "sscMainExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName);
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			//}else{
			//	alert("검색결과가 없습니다.");
			//}
		});
		
		
		$("#btnBuyBuyModify").click(function(){

			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			//아이템 체크 Validation
			if(!isChecked()){
				return;
			}			
			var rtn = isNotProcessState("AC", "선택한 Data는 Modify 대상이 아닙니다.");
			if(!rtn){
				return false;
			}
			
			form = $('#application_form');	
			var item_type_cd = $("input[name=p_item_type_cd]").val();

			//필수 파라미터 S				
			$("input[name=p_daoName]").val("TBCITEMMODIFYDAO");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("modifyList");		
			//필수 파라미터 E			
			form.attr("action", "/ematrix/tbcBuyBuyModify.tbc");
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
		});
		
		
		
		//Cable Type Manager
		$("#btnCableType").click(function(){
			var sURL = "sscCableTypeMain.do";
			var popOptions = "width=1410, height=700, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//Structure Name
		$("#btnStructure").click(function(){
			var sURL = "sscStructureMain.do";
			var popOptions = "width=800, height=730, resizable=yes, scrollbars=no, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		
		//Row Material 정보 출력
		$("#p_rawmaterial").click(function(){
			$("#btnSearch").click();
		});
		
		//window resize시 테이블 사이즈 조정.
		$( window ).resize(function() {
			fnTableResize();
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
	

	function fn_search() {
		
		$("input[name=p_is_excel]").val("N");
		$("input[name=pageYn]").val("N");
		
		var sUrl = "sscMainList.do";
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		printCheckSelectCnt();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		printCheckSelectCnt();
	}
	
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}


	//메시지 Call
	var afterDBTran = function(json)
	{
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
		$("#btnSearch").click();
	}

	// 상태에 따른 진행 Validation 
	// stateval : 허용 상태. 
	// msg : 실패시 메시지.
	var isNotProcessState = function(stateval, msg){
		var rtn = true;
		$("input[name=p_chkItem]").each(function(){
			if($(this).is(":checked")){
				if(stateval.indexOf($(this).parent().parent().find("td").eq(1).text()) < 0){
					alert(msg);
					rtn = false;
					return false;
				}	
			}
		})	
		return rtn;
	}
	
	
	
	//상태에 따라서 Display 조정
	var onLoadDisplayState  = function(){
		if($("input[name=p_hd_selrev]").val() == "Final" || $("input[name=p_hd_selrev]").val() == "" ){
			ActionDisplayOk();
		}else{
			ActionDisplayNone();			
		}
	}
	
	//Display 일괄 적용
	var ActionDisplayNone = function(){
		$("#btnDelete").attr("disabled", "disabled");
		$("#btnModify").attr("disabled", "disabled");
		$("#btnAdd").attr("disabled", "disabled");
		$("#btnBom").attr("disabled", "disabled");
		$("#btnSave").attr("disabled", "disabled");
		$("#btnRestore").attr("disabled", "disabled");		
	}
	
	var ActionDisplayOk = function(){
		$(".buttonArea input").attr("disabled", false);
	}
	
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
	
	
	//rev_no Check Event
	var RevNoCheck = function(obj){
		var obj_val = $(obj).val();
		if(obj_val.length == 1){
			$(obj).val("0"+obj_val);
		}
	}
		
	//After Info 버튼 클릭 시 		
	var afterInfoClick = function (p_ssc_sub_id, level, buyItemCode){
		
		var sURL = "sscAfterInfoMain.do?p_ssc_sub_id="+p_ssc_sub_id+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_level="+level+"&p_buy_item_code="+buyItemCode;
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		
		var popupWin = window.open(sURL, "afterInfoPopup", popOptions).focus();
		//popupWin.blur();
		//setTimeout(popupWin.focus, 0);
	    
	}
	
	//Search 이후 페이징 기능 호출
	var SearchCallback = function(){
		//페이징 기능  Laoding 		
		$("#SSCMainPagingArea").load("./TBC/tbc_CommonPaging.jsp",{
		    printrow: $("input[name=p_printrow]").val(),
		    rowcnt: $("input[name=p_pd_cnt]").val(),
		    nowpage : $("input[name=p_nowpage]").val()
		}, function( response, status, xhr ) {
			if(typeof($("input[name=p_pd_cnt]").val()) != 'undefined'){
				$("#tCnt").text(Number($("input[name=p_pd_cnt]").val().toString()));
			}else{
				$("#tCnt").text("0");
			}
		});
		
		//테이블 사이즈 조정	
		if($('#MainArea').html() != ""){
		    fnTableResize();
	    }
	}
	
	var fnTableResize = function(){
		 var Cheight = $(window).height()-244;
	    $('.commonListBody').css({'height':Cheight+'px'});
	}

	//Page Click
	var go_page = function(pageno, printrow){

		$("input[name=p_nowpage]").val(pageno);
	
		//Uniqe Validation
		if(uniqeValidation()){
			form = $('#application_form');
			//모두 대문자로 변환
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			//필수 파라미터 S	
			$("input[name=p_daoName]").val("TBC_MAIN");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("mainList");
			$("input[name=p_is_excel]").val("N");
			//필수 파라미터 E	
			getAjaxHtmlPost($("#MainArea"),"/bom/sscMainTotalList.do",form.serialize(),null, null, SearchCallback);
		}
	}
	
	var printCheckSelectCnt = function(){
		$("#tSelCnt").text(Number($("input[name=p_chkItem]:checked").length));
	}
	
	//Plm Item 정보 Popup
	var fn_item_popup = function(vItemCode){	
		getAjaxHtml(null,"/ematrix/tbcGetPlmItemId.tbc?&p_item_code="+vItemCode, null, getPlmItemCallback);
	}
	
	//Plm Eco 정보 Popup
	var fn_eco_popup = function(vEcoNo){	
		getAjaxHtml(null,"/ematrix/tbcGetPlmEcoId.tbc?&p_eco_no="+vEcoNo, null, getPlmItemCallback);
	}
	
	var getPlmItemCallback = function(p_id){	
		if(p_id == ""){
			alert("[PLM]해당 Object가  존재하지 않습니다.");
			return false;
		}
		var popOptions = "width=980,height=768, scrollbars=yes, resizable=yes"; 
		var url = '/ematrix/common/emxTree.jsp?emxSuiteDirectory=engineeringcentral&relId=null&parentOID=null&jsTreeID=null&suiteKey=EngineeringCentral&objectId='+p_id;
		var popup = window.open(url, "PlmItemInfoPopup", popOptions);
	}
	//도면 뷰어
	
	var dwgView = function(file_name){	
		$("input[name=p_daoName]").val("");
 		$("input[name=p_queryType]").val("");
   	    $("input[name=p_process]").val("");
   		var sURL = "tbcDwgPopupView.tbc?mode=dwgChkView&P_FILE_NAME="+file_name;
		form = $('#application_form');
		form.attr("action", sURL);
		var myWindow = window.open(sURL,"listForm","height=500,width=1200,top=150,left=200,location=no");
			    
		form.attr("target","listForm");
		form.attr("method", "post");	
				
		myWindow.focus();
		form.submit();
    }
    
    var DeptOnChange = function(obj){
    	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
    	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
    }
    
    //도면번호 바르게 입력하였는지 판단
    var fn_dwg_validataion = function(){
    	if($("#p_dwg_no").val().indexOf("*") > 0){
    		alert("도면 번호를 '*'를 제외한 정확한 번호로 입력하십시오.");
    		$("#p_dwg_no").focus();
    		return false;
    	}
    	return true;
    }
    
	//공지사항 팝업 관련 시작 -----------------------------
	// 해당이름의 쿠키를 가져온다.
    function getCookie(cookie_name) {
        var isCookie = false;
        var start, end;
        var i = 0;

        // cookie 문자열 전체를 검색
        while(i <= document.cookie.length) {
             start = i;
             end = start + cookie_name.length;
             // cookie_name과 동일한 문자가 있다면
             if(document.cookie.substring(start, end) == cookie_name) {
                 isCookie = true;
                 break;
             }
             i++;
        }

        // cookie_name 문자열을 cookie에서 찾았다면
        if(isCookie) {
            start = end + 1;
            end = document.cookie.indexOf(";", start);
            // 마지막 부분이라는 것을 의미(마지막에는 ";"가 없다)
            if(end < start)
                end = document.cookie.length;
            // cookie_name에 해당하는 value값을 추출하여 리턴한다.
            return document.cookie.substring(start, end);
        }
        // 찾지 못했다면
        return "";
    }


	function openMsgBox(board_id)
	{
        var eventCookie=getCookie("notice_op_"+board_id);
        // 쿠키가 없을 경우에만 (다시 보지 않기를 선택하지 않았을 경우.)
        
        var nwidth = 450;
        var nheight = 550;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;
		
        if (eventCookie != "no" && board_id > 0){
            window.open('/ematrix/tbcMainNoticePopup.tbc?p_daoName=TBC_BOARD_DAO&p_queryType=select&p_process=selectDetail&p_board_id='+board_id,'_blank','width='+nwidth+',height='+nheight+',top='+TopPosition+',left='+LeftPosition);
        }
	}
	
	//공지사항이 있는지 확인.
	$.post('/ematrix/tbcCommonAction.tbc?p_daoName=TBC_BOARD_DAO&p_queryType=select&p_process=selectIsNoticePopup&p_board_type=TBC&p_item_type_cd='+$("input[name=p_item_type_cd]").val(), null, function(json)
	{
		if(json.rows.length > 0){
			openMsgBox(json.rows[0].d_board_id);
		}
	},"json");	
	//공지사항 팝업 관련 끝 -----------------------------
	
	
</script>
</body>

</html>