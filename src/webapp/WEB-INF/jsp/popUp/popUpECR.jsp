<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ECR</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap">
			<form id="application_form" name="application_form">
				<%
					String sSave = request.getParameter("save") == null ? "" : request.getParameter("save").toString();
					String sMaincode = request.getParameter("main_code") == null ? "" : request.getParameter("main_code").toString();
					String sTypeName = request.getParameter("sTypeName") == null ? "" : request.getParameter("sTypeName").toString();
					String sStates_code = request.getParameter("states_code") == null ? "" : request.getParameter("states_code").toString();
					String sEco_cause = request.getParameter("eco_cause") == null ? "" : request.getParameter("eco_cause").toString();
				%>
				<div class="topMain" style="margin-top: 0px; line-height: 45px;">
					<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
					<input type="hidden" id="save" name="save" value="<%=sSave%>" />
					<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink" />
					<input type="hidden" name="main_code" id="main_code" value="<%=sMaincode%>" />
					<input type="hidden" name="sTypeName" id="sTypeName" value="<%=sTypeName%>" />
					<input type="hidden" name="states_code" id="states_code" value="<%=sStates_code%>" />
					<input type="hidden" name="eco_cause" id=eco_cause value="<%=sEco_cause%>" />
					<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="ecr" />
					<div class="conSearch">
						<span class="hidden_ecr pop_tit">ECR Name</span>
						<input type="text" class="hidden_ecr" id="main_name" name="main_name" maxlength="10" style="text-transform: uppercase; width: 80px;" />
						<span class="hidden_ecr">&nbsp;</span> <span class="hidden_ecr pop_tit">작성자</span>
						<input type="text" class="hidden_ecr" id="created_by" name="created_by" style="width: 50px;" maxlength="6" onkeyup="fn_clear();" />
						<input type="text" class="notdisabled hidden_ecr" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
<!-- 						<input type="button" class="hidden_ecr" id="btnEmpNo" name="btnEmpNo" value=".." /> -->
						<input type="button" class="hidden_ecr btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
						<span class="hidden_ecr">&nbsp;</span> <span class="hidden_ecr pop_tit">부서</span>
						<input type="text" class="hidden_ecr" id="user_group" name="user_group" style="width: 50px;" maxlength="6" onkeyup="fn_clear2();" />
						<input type="text" class="notdisabled hidden_ecr" id="user_group_name" name="user_group_name" readonly="readonly" style="margin-left: -5px;" />
<!-- 						<input type="button" class="hidden_ecr" id="btnGroupNo" name="btnGroupNo" value=".." /> -->
						<input type="button" class="hidden_ecr btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색" />
						<span class="hidden_ecr">&nbsp;</span>
						<span class="hidden_ecr pop_tit">ECR 생성일</span>
						<input type="text" id="created_date_start" name="created_date_start" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;" />
						<span class="hidden_ecr">~</span>
						<input type="text" id="created_date_end" name="created_date_end" class="datepicker hidden_ecr" maxlength="10" style="width: 70px;" />
						<span class="hidden_ecr">&nbsp;&nbsp;</span>
						<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />
					</div>
					<div class="button">
						<input type="button" id="btnSave" value="확인" class="btn_blue"/>
						<input type="button" class="hidden_ecr btn_blue" id="btnSelect" name="btnSelect" value="조회"/>
						<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
					</div>
				</div>
				<div class="content">
					<table id="ecrList" style="width: 50%; height: 10%"></table>
					<div id="pecrList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var enable_flag = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var kCol = 0;
		var jqgHeight = $(window).height() * 0.6;

		var eco_main_code = $("#main_code").val();

		$(document).ready( function() {
			$( "#ecrList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : '',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', '', 'ECR Name', '상태', 'Related Project', '기술변경내용', '관련자', '기술변경원인', '평가자', '', '결재자', '', '작업자', '', '작성자', '', '', 'stx_dis_eng_change_req' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, width : 50 }, 
				             { hidden : true, name : 'main_code', index : 'main_code' }, 
				             { hidden : false, name : 'main_name', index : 'main_name', classes : 'disables', editable : false, align : 'center', width : 120 }, 
				             { hidden : false, name : 'states_code', index : 'states_code' , classes : 'disables', editable : false, align : 'center', width : 120 },
				             { hidden : false, name : 'eng_change_related_project', index : 'eng_change_related_project', editable : false, align : "left", width : 150 }, 
				             { hidden : false, name : 'eng_change_description', index : 'eng_change_description', editable : false, edittype : "textarea", editoptions : { rows : "3", cols : "40", dataEvents : [ { type : 'blur', fn : function( e) { $( "#desc_layer") .hide(); } }, { type : 'focus', fn : function( e) { $( "#desc_layer") .show(); } }, { type : 'keydown', fn : function( e) { var keyCode = e.keyCode || e.which; if (keyCode == 9) { $( "#desc_layer") .hide(); } } } ] }, width : 310 }, 
				             { hidden : false, name : 'related_person_emp_name', index : 'related_person_emp_name', align : 'left', width : 220 }, 
				             { hidden : false, name : 'eng_change_based_on', index : 'eng_change_based_on', editable : false, align : 'left', sortable : false, width : 235 }, 
				             { hidden : false, name : 'user_code', index : 'user_code', editable : false, align : 'left', sortable : false, width : 225 }, 
				             { hidden : true, name : 'evaluator_emp_no', index : 'evaluator_emp_no', editoptions : { size : 30 } }, 
				             { hidden : false, name : 'design_engineer', index : 'design_engineer', align : "left", width : 220 }, 
				             { hidden : true, name : 'design_engineer_emp_no', index : 'design_engineer_emp_no', editoptions : { size : 30 } }, 
				             { hidden : false, name : 'locker_by_name', index : 'locker_by_name', classes : 'disables', editable : false, align : "left", width : 220 }, 
				             { hidden : true, name : 'locker_by', index : 'locker_by', classes : 'disables', editable : false, align : 'center' }, 
				             { hidden : false, name : 'created_by_name', index : 'created_by_name', classes : 'disables', editable : false, align : 'left', width : 220 }, 
				             { hidden : true, name : 'created_by', index : 'created_by' },
				             { hidden : true, name : 'oper', index : 'oper' }, 
				             { name : 'stx_dis_eng_change_req', index : 'stx_dis_eng_change_req', width : 25, hidden : true } ],

				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : 300,
				pager : $('#pecrList'),
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowNum : 100000000,
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				gridComplete : function() {
					var rows = $( "#ecrList" ).getDataIDs();
					for( var i = 0; i < rows.length; i++ ) {
						var states_code = $( "#ecrList" ).getCell( rows[i], "states_code" );
						if(states_code != 'PLAN_ECO'){
							
							$( "#ecrList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#DADADA' } );
						}
					}
					
					
					var changedData = $( "#ecrList" ).jqGrid( 'getRowData' );
					var eco_cause = $( "#eco_cause" ).val();
					
					// 데이타가 있는지 체크한다.
					if ( changedData.length == 0 && eco_cause != "" ) {
						alert( "원인코드와 같은 ECR 번호가 없습니다." );
					}
				}
			} );

			//일주일 단위로 가져오기
			fn_weekDate( "created_date_start", "created_date_end" );
			
			/* //ECR 평가자
			$.post( "ecrEvaluatorList.do", "", function( data ) {
				$('#ecrList').setObject( {
					value : 'value',
					text : 'text',
					name : 'user_code',
					data : data
				} );
			}, "json" );

			//ECR Based on
			$.post( "ecrBasedList.do", "", function( data ) {
				$( '#ecrList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'eng_change_based_on',
					data : data
				} );
			}, "json" ); */

			$( "#ecrList" ).jqGrid( 'navGrid', "#pecrList", {
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			//조회 버튼
			$( "#btnSelect" ).click( function() {
				fn_search();
			} );
			
			//저장버튼
			$( "#btnSave" ).click( function() {
				fn_save();
			} );

			/* //... 버튼
			$( "#btnmain" ).click( function() {
				var rs = window.showModalDialog( "popUpBaseInfo.do?cmd=popupBaseInfo",
						window,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#cmtype" ).val( rs[0] );
					$( "#cmtypedesc" ).val( rs[1] );
				}
			} ); */
			
			$( '#btncancle' ).click( function() {
				self.close();
			} );
			
			//부서 조회 팝업... 버튼
			$( "#btnGroupNo" ).click( function() {
				var rs = window.showModalDialog( "popUpGroup.do",
						"ECR",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );

				if( rs != null ) {
					$( "#user_group" ).val( rs[0] );
					$( "#user_group_name" ).val( rs[1] );
				}
			} );
			
			//사번 조회 팝업... 버튼
			$( "#btnEmpNo" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do",
						"ECR",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
	
				if ( rs != null ) {
					$( "#created_by" ).val( rs[0] );
					$( "#created_by_name" ).val( rs[1] );
					$( "#user_group" ).val( rs[2] );
					$( "#user_group_name" ).val( rs[3] );
				}
			} );
			
			$( function() {
				var dates = $( "#created_date_start, #created_date_end" ).datepicker( {
					prevText : '이전 달',
					nextText : '다음 달',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
					dateFormat : 'yy-mm-dd',
					showMonthAfterYear : true,
					yearSuffix : '년',
					changeYear: true,
					changeMonth : true,
					onSelect : function( selectedDate ) {
						var option = this.id == "created_date_start" ? "minDate" : "maxDate", 
								instance = $(this).data("datepicker"), 
								date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
						dates.not(this).datepicker( "option", option, date );
					}
				} );
			} );

		} ); //end of ready Function 
						
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#ecrList' ).jqGrid( 'getRowData', irowId );
			if( item.oper != 'I' )
				item.oper = 'U';
			$( '#ecrList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}
		
		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep( $( "#ecrList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'U';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		}
		
		//조회
		function fn_search() {
			var sUrl = 'infoEcoAddEcrRinkPopupList.do';
			
			$( "#ecrList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//저장
		function fn_save() {
			//$( '#ecrList' ).saveCell( kRow, idCol );
			
			var main_code = '';
			var main_name = '';
			var checkCouseTemp = 'default';
			var checkCouseTempDesc = '';
			var count = 0;
			//var changedData = $( "#ecrList" ).jqGrid( 'getRowData' );
			var rows = $( "#ecrList" ).getDataIDs();
			// 변경된 체크 박스가 있는지 체크한다.
			for( var i = 0; i < rows.length; i++ ) {
				var item = $( '#ecrList' ).jqGrid( 'getRowData', rows[i] );
				
				// ecr이 선택되어진것을 넣기
				if (item.enable_flag == 'Y') {
					if(item.states_code != 'PLAN_ECO'){
						alert("[PLAN_ECO]상태만 선택 가능합니다.");
						return;
					}
					main_code = ' ' + item['main_code'] + ',' + main_code;
					main_name = ' ' + item['main_name'] + '|' + main_name;

					if ( item.stx_dis_eng_change_req != checkCouseTemp ) {
						count = count + 1;
					}
					
					checkCouseTemp = item.stx_dis_eng_change_req;
					checkCouseTempDesc = item.eng_change_based_on;
					item.oper = 'U';
				} else {
					item.oper = '';
				}
				$( '#ecrList' ).jqGrid( "setRowData", rows[i], item );
			}

			if ( count > 1 ) {
				alert( "같은 원인코드를 선택바랍니다." );
				return;
			}

			var iSave = $( "#save" ).val();

			if (iSave == 'create' ) {
				//eco 에서 추가할때 사용
				
				var returnValue = new Array();
				returnValue[0] = main_code.substring( 1, main_code.length - 1 );
				returnValue[1] = main_name.substring( 1, main_name.length - 1 );
				returnValue[2] = checkCouseTemp;
				window.returnValue = returnValue;
				self.close();
			} else if (iSave == 'reEcr') {
				// eco에서 ecr을 추가할때 사용
				
				var chmResultRows = [];
				
				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					chmResultRows = data;

					if (chmResultRows.length == 0) {
						alert( "연계할 ECR을 선택해주세요." );
						return;
					}

					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveEcrResult.do?saveDel=save';
					var formData = fn_getFormData( '#application_form' );

					//객체를 합치기. dataList를 기준으로 formData를 합친다. 
					var parameters = $.extend( {}, dataList, formData);
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							var returnValue = 'ok';
							window.returnValue = returnValue;
							self.close();
						}
					}, "json" ).error( function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					} ).always( function() {
						//lodingBox.remove();
					} );
				} );
			}
		}

		//작성자 조회조건 삭제 시 작성자명 초기화
		function fn_clear() {
			if( $( "#created_by" ).val() == "" ) {
				$( "#created_by_name" ).val( "" );
			}
		}

		//부서 조회조건 삭제 시 부서명 초기화
		function fn_clear2() {
			if( $( "#user_group" ).val() == "" ) {
				$( "#user_group_name" ).val( "" );
			}
		}
		</script>
	</body>
</html>
