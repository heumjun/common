<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>시수 적용률 Case 관리 </title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv" style="max-width: 500px; max-height: 410px;">
	<div class="subtitle">
		시수 적용률 Case 관리
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide" style="float: none;"><img src="/images/content/yellow.gif"/>필수입력사항</span>
	</div>
	<form id="application_form" name="application_form">
		<div id="searchDiv">
			<input type="hidden" value="" name="maxCase" id="maxCase">
			<table class="searchArea conSearch" style="table-layout: auto;">
				<col width="6%"/>
				<col width="8%"/>
				<col width="*%"/>
				<tr>
					<th>Case</th>
					<td>
						<select name="mhFactorCaseSelect" id="mhFactorCaseSelect" style="width:160px;" onchange="fn_mhFactorCaseSelChanged();">
                    		<option value="">&nbsp;</option>
                    		<c:forEach var="item" items="${mhFactorCaseList }">
                    			<c:if test="${item.active_case_yn eq 'Y' }">
                    				<c:set var="active_code" value="${item.case_no }" scope="page"/>
                    				<c:set var="displayStr" value="${item.case_no } (* default case)" scope="page"/>
                    				<option value="${item.case_no }" selected="selected">${displayStr}</option>
                    			</c:if>
                    			<c:if test="${item.active_case_yn eq 'N' }">
                    				<c:set var="displayStr" value="${item.case_no }" scope="page"/>
                    				<option value="${item.case_no }">${displayStr}</option>
                    			</c:if>
							</c:forEach>
                    	</select>
                    	<input type="button" class="btn_blue" name="addButton" value="추 가" onclick="fn_addMHFactorCase();" />
					</td>
				</tr>
				<tr>
					<td colspan="3" style="background-color: yellow;">
						<input type="checkbox" id="defaultCaseCheck" name="defaultCaseCheck" value="true">Default Case
					</td>
				</tr>
			</table>
		</div>
	</form>
	<form id="application_form1" name="application_form1">
		<div class="content"  id="dataListDiv">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
	<div align="right">
		<input type="button" class="btn_blue" value="적용" onclick="fn_saveGrid();"/>
		<input type="button" class="btn_blue" value="닫기" onclick="fn_close();"/>
	</div>
</div>
<script type="text/javascript">
	var kRow = 0;
	var idCol = 0;
	$(document).ready(function(){
		var defaultActive = '${active_code}';
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			url:'factorCaseMainGrid.do',
			datatype: "json",
			postData : fn_getFormData( '#application_form' ),
			colNames : ['개월 이상','개월 이하','Factor','oper','Factor_no'],
			colModel : [{name : 'month_from', index : 'month_from', width: 10, align : "center", editable:true, edittype:"text",
						editoptions:{
							dataEvents : [ //숫자외 기타 입력 방지
							              {type:'keyup', fn:function(e) {
							            	 					if(!numCheck(this.value)){
							            	 						e.preventDefault();
							            	 						$(e.target).val($(e.target).val().substr(0,$(e.target).val().length-1));
							            		 				}
							            					}
							              },//int로 변경
							              {type:'focusout', fn:function(e) {
						            	  				e.preventDefault();
						            	  				if(this.value != ''){
						            	  					$(e.target).val(parseInt($(e.target).val()));
						            	  				}
			            					}
			              				  }
							              ] 
						}},
			            {name : 'month_to', index : 'month_to', width: 10, align : "center", editable:true, edittype:"text",
			            	editoptions:{
								dataEvents : [//숫자외 기타 입력 방지
								              {type:'keyup', fn:function(e) {
								            	 					if(!numCheck(this.value)){
								            	 						e.preventDefault();
								            	 						$(e.target).val($(e.target).val().substr(0,$(e.target).val().length-1));
								            		 				}
								            					}
								              },//int로 변경
								              {type:'focusout', fn:function(e) {
								            	  				e.preventDefault();
								            	  				if(this.value != ''){
								            	  					$(e.target).val(parseInt($(e.target).val()));
								            	  				}
					            					}
					              				  }
								              ] 
							}},
			            {name : 'factor', index : 'factor', width: 10, align : "center", editable:true, edittype:"text",
								editoptions:{
									dataEvents : [//숫자외 기타 입력 방지 x.x 소수점 1자리 까지 허용 처리
									              {type:'keyup', fn:function(e) {
									            	 					if(!floatCheck(this.value)){
									            	 						e.preventDefault();
									            	 						$(e.target).val($(e.target).val().substr(0,$(e.target).val().length-1));
									            		 				}
									            					}
									              },//float형태 x.x 소수점 1자리 까지 허용 처리
									              {type:'focusout', fn:function(e) {
									            	  				e.preventDefault();
									            	  				if(this.value != ''){
									            	  					$(e.target).val(parseFloat($(e.target).val()));
									            	  				}
					            					}
					              				  }
									              ] 
								}},
			            {name : 'oper', index : 'oper', width: 10, align : "center", hidden:true},
			            {name : 'factor_no', index : 'factor_no', width: 10, align : "center", hidden:true}
			           ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			hidegrid: false,
			altRows:false,
			viewrecords : true,
			autowidth : true, //autowidth: true,
			height : objectHeight,
			pager: "#jqGridPager",
			rowNum : -1,
			rownumbers: true,
			emptyrecords : '데이터가 존재하지 않습니다. ',
			pager : jQuery('#pDataList'),
			cellEdit : true, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
				kRow = iRow;
				idCol = iCol;
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records"
			},
			ondblClickRow : function(rowId,iRow,colId) {
			},
			onCellSelect : function( rowId, colId, content, event) {
			},
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
			 	var color = '#77dd77';
			 	
				for( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#dataList" ).getCell( rows[i], "oper" );
					if(oper == "R"){ //기존 입력되어 있는 cell 색깔 처리
        		    	$('#dataList').jqGrid('setCell',rows[i],'month_from','',{background:color});
        		    	$('#dataList').jqGrid('setCell',rows[i],'month_to','',{background:color});
        		    	$('#dataList').jqGrid('setCell',rows[i],'factor','',{background:color});
        		    	$('#dataList').jqGrid('setCell',rows[i],'month_from','','not-editable-cell');
        		    	$('#dataList').jqGrid('setCell',rows[i],'month_to','','not-editable-cell');
        		    	$('#dataList').jqGrid('setCell',rows[i],'factor','','not-editable-cell');
        		    }
				}//default checkbox 활성화/비활성화 처리
		    	if($("#mhFactorCaseSelect").val() == defaultActive){
		    		$("#defaultCaseCheck").prop("checked",true);
		    		$("#defaultCaseCheck").attr("disabled","disabled");
		    	} else if($("#mhFactorCaseSelect").val() != '' && $("#mhFactorCaseSelect").val() != defaultActive){
		    		$("#defaultCaseCheck").prop("checked",false);
		    		$("#defaultCaseCheck").removeAttr("disabled");
		    	}
			},
		});
		//그룹헤더 처리
		$("#dataList").jqGrid('setGroupHeaders', {
			  useColSpanStyle: true, 
			  groupHeaders:[
			 	 {startColumnName: 'month_from', numberOfColumns: 2, titleText: '설계경력(개월)'}
			  ]
		});
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.17);
	});
	//상단 case_no변경시 그리드 갱신 및 데이터 변경
	function fn_mhFactorCaseSelChanged(){
		if($("#mhFactorCaseSelect").val() == ''){
			$("#defaultCaseCheck").attr("disabled","disabled");
			//그리드 갱신을 위한 작업
			$( '#dataList' ).jqGrid( 'clearGridData' );
			//그리드 postdata 초기화 후 그리드 로드 
			$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
			return;
		}
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="factorCaseMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( '#application_form' )
		} ).trigger( 'reloadGrid' );
	}
	//적용율 case 추가 버튼 클릭 처리
	function fn_addMHFactorCase(){
		$("#mhFactorCaseSelect").val("&nbsp;");
		$("#defaultCaseCheck").prop("checked",false);
		$("#defaultCaseCheck").removeAttr("disabled");
		
		$( '#dataList' ).jqGrid( 'clearGridData' );
		
		var item = {};
		var colModel = $('#dataList').jqGrid('getGridParam', 'colModel');
	
		for ( var i in colModel)
			item[colModel[i].name] = '';
	
		item.oper = 'I';
		
		for(var i = 0; i < 3; i++){
			var rowId = $.jgrid.randId();
			var color = "#ffffe0";
			$('#dataList').jqGrid('addRowData', rowId, item, 'last');
			if(i == 0){
				$('#dataList').jqGrid('setCell',rowId, 'month_from', i+1, {background : '#77dd77' });
				$('#dataList').jqGrid('setCell',rowId, 'month_from', '', 'not-editable-cell');
				$('#dataList').jqGrid('setCell',rowId, 'month_to', '', {background : color });
				$('#dataList').jqGrid('setCell',rowId, 'factor', '', {background : color });
			} else {
				$('#dataList').jqGrid('setCell',rowId, 'month_from', '', {background : color });
				$('#dataList').jqGrid('setCell',rowId, 'month_to', '', {background : color });
				$('#dataList').jqGrid('setCell',rowId, 'factor', '', {background : color });
			}
			$('#dataList').jqGrid('setCell',rowId, 'factor_no', i+1, {background : color });
		}
		
	}
	//그리드 저장
	function fn_saveGrid(){
		var checkboxStatus = $("#defaultCaseCheck").attr("disabled");
		var gridCheck = false;
		if($("#mhFactorCaseSelect").val() == ''){
			return;
		}
		
		
		$('#dataList').saveCell(kRow, idCol);
		$('#dataList').resetSelection();
		
		if(fn_checkGridModifyNoAlt($("#dataList"))){
			gridCheck = true;
		}
		
		if(gridCheck){
			if(fn_checkInputs()){//추가 case_no 처리 및 데이터 추가 /검증
				var caseStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var mhFactorCaseSelectObj = $("#mhFactorCaseSelect");
				var maxCase = mhFactorCaseSelectObj.find("option:last").val();
				var maxCaseIdx = caseStr.indexOf(maxCase);
				if(maxCase == "Z"){
					alert("더이상 생성 불가입니다. 관리자에게 문의하세요");
					return;
				}
				$("#maxCase").val(caseStr.charAt(maxCaseIdx + 1));
				fn_saveGridCall();
			}
		} else { //기존 입력된 자료 default 설정 처리
				if(checkboxStatus != "disabled"){
					if($("#defaultCaseCheck").is(":checked")){
						$("#maxCase").val($("#mhFactorCaseSelect").val());
					}
				}
				fn_saveGridCall();
		}
	}
	//반복적 그리드 호출 방식 변경
	function fn_saveGridCall(){
		var savedGrid = $("#dataList").jqGrid( 'getRowData' );
		var resultData = [];
		var savedRows = savedGrid.concat(resultData);
		var url = 'factorCaseMainGridSave.do';
		var dataList = { chmResultList : JSON.stringify( savedRows ) };
		var formData = fn_getFormData( '#application_form' );
		var parameters = $.extend( {}, dataList, formData );
		
		lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post( url, parameters, function( data ) {
			alert(data.resultMsg);
			if ( data.result == 'success' ) {
				 location.reload();
			}
		}, 'json' ).error( function() {
			alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
		} ).always( function() {
			lodingBox.remove();
		} );
	}
	// 입력사항 유효성 체크
    function fn_checkInputs()
    {
    	var ids = $("#dataList").jqGrid('getDataIDs');
    	
    	var monthTo1 = $("#dataList").jqGrid('getCell', ids[0], 'month_to').trim();
        if (monthTo1.length != 0 &&  Number(monthTo1) < 1) {
            alert("1 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo1.focus();
            return false;
        }
        var factorValue1 = $("#dataList").jqGrid('getCell', ids[0], 'factor').trim();
        if (factorValue1.length == 0 ||  eval(factorValue1) < 0 || eval(factorValue1) > 1) {
            alert("1 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue1.focus();
            return false;
        }

        var monthFrom2 = $("#dataList").jqGrid('getCell', ids[1], 'month_from').trim();
        if (monthFrom2.length != 0 && ( Number(monthTo1) + 1 != Number(monthFrom2))) {
            alert("2 번째 항의 From 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthFrom2.focus();
            return false;
        }
        var monthTo2 = $("#dataList").jqGrid('getCell', ids[1], 'month_to').trim();
        if ((monthFrom2.length == 0 && monthTo2.length != 0) ||
            (monthTo2.length != 0 && ( Number(monthTo2) < Number(monthFrom2)))
           ) 
        {
            alert("2 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo2.focus();
            return false;
        }
        var factorValue2 = $("#dataList").jqGrid('getCell', ids[1], 'factor').trim();
        if ((monthFrom2.length == 0 && factorValue2.length != 0) ||
            (monthFrom2.length != 0 && factorValue2.length == 0) ||
            (eval(factorValue2) < 0 || eval(factorValue2) > 1)
           ) 
        {
            alert("2 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue2.focus();
            return false;
        }

        var monthFrom3 = $("#dataList").jqGrid('getCell', ids[2], 'month_from').trim();
        if (monthFrom3.length != 0 && ( Number(monthTo2) + 1 != Number(monthFrom3))) {
            alert("3 번째 항의 From 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthFrom3.focus();
            return false;
        }
        var monthTo3 = $("#dataList").jqGrid('getCell', ids[2], 'month_to').trim();
        if ((monthFrom3.length == 0 && monthTo3.length != 0) ||
            (monthTo3.length != 0 && ( Number(monthTo3) < Number(monthFrom3)))
           ) 
        {
            alert("3 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo3.focus();
            return false;
        }
        var factorValue3 = $("#dataList").jqGrid('getCell', ids[2], 'factor').trim();
        if ((monthFrom3.length == 0 && factorValue3.length != 0) ||
            (monthFrom3.length != 0 && factorValue3.length == 0) ||
            ( eval(factorValue3) < 0 || eval(factorValue3) > 1)
           ) 
        {
            alert("3 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue3.focus();
            return false;
        }
        if (!((monthTo1.length == 0) || 
                (monthFrom2.length != 0 && monthTo2.length == 0) ||
                (monthFrom3.length != 0 && monthTo3.length == 0)
               )) 
          {
              alert("적어도 하나의 To 개월 값은 빈(Empty) 값이어야 합니다.!");
              return false;
          }
    	
    	return true;
    }
	//팝업 닫는 기능
	function fn_close(){
		var checkboxStatus = $("#defaultCaseCheck").attr("disabled");
		var exchange = false;
		var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 작업을 종료하시겠습니까?";
		if(checkboxStatus != "disabled"){
			if($("#defaultCaseCheck").is(":checked")){
				exchange = true;
			}
		}
		if(fn_checkGridModifyNoAlt($("#dataList"))){
			exchange = true;
		}
		
		if(exchange){
			if (!confirm(msg)) return false;
		}
		window.close();
	}
	//숫자 정수 체크
	function numCheck(obj){
		 var num_check=/^[0-9]*$/;
			if(!num_check.test(obj)){
			return false;
 		}
		return true;
	}
	//소수점 체크
	function floatCheck(obj){
		 var num_check=/^([0-9]*)[\.]?([0-9])?$/;
			if(!num_check.test(obj)){
			return false;
		}
		return true;
	}
</script>
</body> 
</html>