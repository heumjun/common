<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DB MASTER - ADD</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

<style type="text/css">

</style>

</head>

<body oncontextmenu="return false">
	<form id="application_form" name="application_form">

		<input type="hidden" name="p_daoName" id="p_daoName" value= />
		<input type="hidden" name="p_queryType" id="p_queryType" value="" />
		<input type="hidden" name="p_process" id="p_process" value="" />
		<input type="hidden" name="p_filename" id="p_filename" value="" />
		<input type="hidden" name="list_type" id="list_type" />
		<input type="hidden" name="list_type_desc" id="list_type_desc" />
		<input type="hidden" name="userId" id="userId" value="<c:out value="${loginId}" />" />
		<input type="hidden" name="userId" id="userId" value="<c:out value="${loginId}" />" />
		<!-- <input type="hidden" id="p_item_seq" name="p_item_seq" value="<c:out value="${ItemSeq}" />" /> -->
		<input type="hidden" name="loginGubun" id="loginGubun"  value="${loginGubun}" />
		<input type="hidden" name="p_spec_seq" id="p_spec_seq" />
		<input type="hidden" name="p_item_seq" id="p_item_seq" />
		<input type="hidden" name="p_itemseq" id="p_itemseq" />
		<input type="hidden" name="p_specseq" id="p_specseq" />
		<input type="hidden" name="catalog_code" id="catalog_code" />
		<div id="hiddenArea"></div>

		<div class="headerBD">
			<table>
				<tr>
					<td width="600">&nbsp;</td>
					<td width="180" style="padding-top:10px;">
						<input type="button" class="btn_blue" value="조회" id="btnSearch" />
						<input type="button" class="btn_blue" value="등록" id="btnSave" />
						<input type="button" class="btn_blue" value="닫기" id="btnClose" />
					</td>
				</tr>
			</table>
		</div>

		<div id="tabs" class="content">
			<ul class="tab">
				<li class="active"><a href="#tab1">품목</a></li>
				<li><a href="#tab2">사양</a></li>
			</ul>
			<div class="tab_container">
				<div style="display: block;" id="tab1" class="tab_content">
					<table>
						<tr>
							<td width="650">
								<div class="searchDetail1">
									<input type="text" class="disablefield" id="" name="" value="Catalog" style="width: 70px; text-align: center; font-weight: bold;" readonly="readonly" />
									<input type="text" class="required" id="p_catalog_code" name="p_catalog_code" value="<c:out value="${p_catalog_code}" />" style="background-color: #FFFFA2; text-transform: uppercase; width: 50px; text-align: center;" onkeydown="javascript:this.value=this.value.toUpperCase();" />
									<input type="text" id="p_catalog_name" name="p_catalog_name" value="<c:out value="${p_catalog_name}" />" style="width: 440px; text-align: left; font-weight: bold; background-color: #F3F3F3;" readonly="readonly" />
								</div>
							</td>
							<td width="130">
								<input type="button" class="btn_blue" value="추가" id="btnAdd" />
								<input type="button" class="btn_blue" value="삭제" id="btnDel" />
							</td>
						</tr>
					</table>
					<table id="itemTransList"></table>
					<div id="btnitemTransList"></div>
				</div>
				<div style="display: none;" id="tab2" class="tab_content">
					<table>
						<tr>
							<td width="650">
								<div class="searchDetail1">
									<input type="text" class="disablefield" id="" name="" value="Catalog" style="width: 70px; text-align: center; font-weight: bold;" readonly="readonly" /> 
									<input type="text" class="required" id="p_catalog_code1" name="p_catalog_code1" value="<c:out value="${p_catalog_code}" />" style="background-color: #FFFFA2; text-transform: uppercase; width: 50px; text-align: cen alog_name1')); $('#btnSearch').click(); " onkeydown="javascript:this.value=this.value.toUpperCase();" />
									<input type="text" id="p_catalog_name1" name="p_catalog_name1" value="<c:out value="${p_catalog_name}" />" style="width: 340px; text-align: left; font-weight: bold; background-color: #F3F3F3;" readonly="readonly" /> 
									<input type="text" class="disablefield" id="" name="" value="품목코드" style="width: 60px; text-align: center; font-weight: bold;" readonly="readonly" /> 
									<input type="text" id="p_itemcode" name="p_itemcode" value="<c:out value="${p_itemcode}" />" style="background-color: #FFFFA2; width: 50px; text-align: center; font-weight: bold;" onkeyup="fn_all_text_upper(); getItemCd(this.value); $('#btnSearch').click();" />
									<input type="hidden" id="p_itemname" name="p_itemname" value="" style="width: 350px; text-align: left; font-weight: bold;" readonly="readonly" />
								</div>
							</td>
							<td width="130">
								<input type="button" class="btn_blue" value="추가" id="btnAdd1" />
								<input type="button" class="btn_blue" value="삭제" id="btnDel1" />
							</td>
						</tr>
					</table>
					<table id="itemTransList1"></table>
					<div id="btnitemTransList1"></div>
				</div>
			</div>

		</div>

	</form>
	<script type="text/javascript">
		var item_seq = $("#p_item_seq").val();
		var spec_seq = $("#p_spec_seq").val();
		var catalog = $("#p_catalog_code").val();
		var item_code = $("#p_itemcode").val();
		var item_cnt = $("#p_item_seq").val();
		var spec_cnt = $("#p_spec_seq").val();

		var idRow;
		var idCol;
		var kRow;
		var kCol;
		
		var resultData = [];

		$( "#tabs" ).tabs( {
				activate : function( event, ui ) {
			
				}
		} );
		
		$(document).ready(function() {
			
			$(".tab_content").hide();
			$("ul.tab li:first").addClass("active").show();
			$(".tab_content:first").show();
			$("ul.tab li").click(function() {
				$("ul.tab li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).find("a").attr("href");
				$(activeTab).show();
				return false;
			});

			if ($("#p_catalog_code").val() != '') {
				fn_search();
				fn_search1();
			} else {
				fn_search2();
			}

			//key evant 
			$("#p_catalog_code").keypress(function(event) {
				if (event.which == 13) {
					event.preventDefault();
					$('#btnSearch').click();
				}
			});

			//key evant 
			$("#p_catalog_code1").keypress(function(event) {
				if (event.which == 13) {
					event.preventDefault();
					$('#btnSearch').click();
				}
			});

			//key evant 
			$("#p_itemcode").keypress(function(event) {
				if (event.which == 13) {
					event.preventDefault();
					$('#btnSearch').click();
				}
			});

			window.focus();
			
		});

		function getCatalog(catalog_code, str) {
			var sUrl = "popUpEmsDbMasterAddGetCatalogName.do?p_catalog_code=" + catalog_code;
			var vRtnSpecSeq = "";

			//동기 호출
			if (str == 'item') getAjaxJson(sUrl, callbackGetCatalogCode1);
			else if (str == 'spec') getAjaxJson(sUrl, callbackGetCatalogCode2);
				
			return vRtnSpecSeq;

		}
		
		var callbackGetCatalogCode1 = function(json) {
			var msg = "";
			if (json != null) {
				msg = json.description
				$("input[name=p_catalog_name]").val(msg);	
			}
			else {
				$("input[name=p_catalog_name]").val("");
			}
		}
		
		var callbackGetCatalogCode2 = function(json) {
			var msg = "";
			if (json != null) {
				msg = json.description
				$("input[name=p_catalog_name1]").val(msg);	
			}
			else {
				$("input[name=p_catalog_name1]").val("");
			}
		}

		var aftersearch1 = function(json) {
			var msg = "";
			var catalog_name = "";
			for ( var keys in json) {
				for ( var key in json[keys]) {
					msg = json[keys][key];

					if (key == 'description') {
						catalog_name = msg;
					}
				}
			}
			$(".loadingBoxArea").hide();
			return catalog_name;
		}

		//가장 큰 spec code를 가져온다.
		function getLastSpecSeq() {
			var sUrl = "popUpEmsDbMasterAddSpecLastNum.do?p_catalog_code1="
					+ $("input[name=p_catalog_code1]").val()
					+ "&p_itemcode="
					+ $("input[name=p_itemcode]").val();
			var vRtnSpecSeq = "";

			//동기 호출
			getAjaxJson(sUrl, callbackGetLastSpecSeq);

			return vRtnSpecSeq;
		}

		var callbackGetLastSpecSeq = function(json) {
			var msg = "";
			$("input[name=p_spec_seq]").val(json.spec_seq);
		}

		//다음 ITEM Seq를 가져온다.
		function getLastItemSeq() {

			var sUrl = "popUpEmsDbMasterAddItemLastNum.do?p_catalog_code="
					+ $("input[name=p_catalog_code]").val() + "&p_itemcode="
					+ $("input[name=p_itemcode]").val();
			var vRtnSpecSeq = "";

			//동기 호출
			getAjaxJson(sUrl, callbackGetLastItemSeq);

			// 		var formData = $('#application_form');
			// 		getJsonAjaxFrom("popUpEmsDbMasterAddLastNum.do",formData.serialize(),null,callbackGetLastItemSeq);

			return vRtnSpecSeq;
		}

		var callbackGetLastItemSeq = function(json) {
			var msg = "";
			$("input[name=p_item_seq]").val(json.item_seq);
		}

		function getItemCd(value) {

			$("input[name=p_daoName]").val("EMS_DBMASTER");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("getItemSp");
			var sUrl = "/ematrix/emsDbMasterMain.tbc";

			$("input[name=p_itemcode]").val(value);

			$.post(sUrl, $("#application_form").serialize(), function(json) {
				aftersearch3(json);
			}, "json");
		}

		var aftersearch2 = function(json) {
			var msg = "";

			for ( var keys in json) {
				for ( var key in json[keys]) {
					msg = json[keys][key];

					if (key == 'd_description') {
						$("#p_catalog_name1").val(msg);
					}
				}
			}
			$(".loadingBoxArea").hide();
		}

		var aftersearch3 = function(json) {
			var msg = "";

			for ( var keys in json) {
				for ( var key in json[keys]) {
					msg = json[keys][key];

					if (key == 'd_item_desc') {
						$("#p_itemname").val(msg);
					}
				}
			}
			$(".loadingBoxArea").hide();
		}

		//######## 조회 버튼 클릭 시 ########//
		$("#btnSearch").click(function() {
			if ($("#tab1").css("display") == "block") {
				if ($("#p_catalog_code").val() == '') {
					alert("Catalog코드를 입력하여 주십시오.");
					return;
				} else {
					fn_search();
					$("#p_item_seq").val("");
				}
			} else if ($("#tab2").css("display") == "block") {
				if ($("#p_catalog_code1").val() == '') {
					alert("Catalog코드를 입력하여 주십시오.");
					return;
				} else if ($("#p_itemcode").val() == '') {
					$("#p_itemcode").focus();
					alert("품목코드를 입력하여 주십시오.");
					return;
				} else {
					fn_search1();
					$("#p_spec_seq").val("");
				}
			}
		});

		//########  등록버튼 ########//
		$("#btnSave")
				.click(
						function() {

							$("#itemTransList").saveCell(kRow, idCol);
							$("#itemTransList1").saveCell(kRow, idCol);

							var selRows = $("#itemTransList").getDataIDs().length;

							$("input[name=p_daoName]").val("EMS_DBMASTER");
							$("input[name=p_queryType]").val("insert");
							if ($("#tab1").css("display") == "block") {
								
								//변경 사항 Validation
								if( !fn_checkValidate() ) {
									return;
								}
								
								if ($("#p_catalog_code").val() == '') {
									alert("Catalog코드를 입력하여 주십시오.");
									return;
								} else {
									
									//jqGrid의 rowData를 받아옴.					
									var changedData = $.grep( $( "#itemTransList" ).jqGrid( 'getRowData' ), function( obj ) {
										return obj.oper == 'I' || obj.oper == 'U' ;
									} );
									
									//중복된 품목이나 입력하지 않은 항목이 있는지 확인한다.
									var allRowDatas = $("#itemTransList").getRowData();
									for(var i=0; i<changedData.length; i++){
										//품목을 입력하지 않은 곳이 있는지 확인
										if(changedData[i].i_item_desc == ""){
											alert("Code번호 " + changedData[i].i_item_code + "의 품목을 입력하여 주세요.")
											return;
										}
										//이름이 동일한 품목이 있는지 체크
										for(var j=0; j<allRowDatas.length; j++){
											if(changedData[i].i_item_code != allRowDatas[j].i_item_code){
												if(changedData[i].i_item_desc == allRowDatas[j].i_item_desc){
													alert("Code번호 " + changedData[i].i_item_code + "의 품목은 이미 존재하는 품목명 입니다.")
													return;
												}
											}
										}
									}
									
									$("input[name=p_process]").val("add_item");
									
									if (confirm("등록하시겠습니까?")) {
										var chmResultRows = [];
										
										getChangedChmResultData(function( data ) {
											chmResultRows = data;
											var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
											var url = 'popUpEmsDbMasterAddSave.do';
											var formData = fn_getFormData( '#application_form' );
											var parameters = $.extend( {}, dataList, formData );

											loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
											
											$.post( url, parameters, function( json ) {
												alert(json.resultMsg);
												if ( json.result == 'success' ) {
													fn_search();
													$("#p_item_seq").val("");
												}
											}, "json").error( function() {
												alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
											} ).always( function() {
												loadingBox.remove();
											} );
										} );
									}
									
								}
								
							} else if ($("#tab2").css("display") == "block") {
								
								//변경 사항 Validation
								if( !fn_checkValidate1() ) {
									return;
								}
								
								if ($("#p_catalog_code1").val() == '') {
									alert("Catalog코드를 입력하여 주십시오.");
									return;
								} else if ($("#p_itemcode").val() == '') {
									alert("품목코드를 입력하여 주십시오.");
									return;
								} else {
									$("input[name=p_process]").val("add_spec");
									
									if (confirm("등록하시겠습니까?")) {
										var chmResultRows = [];

										getChangedChmResultData1(function( data ) {
											chmResultRows = data;
											var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
											var url = 'popUpEmsDbMasterAddSave.do';
											var formData = fn_getFormData( '#application_form' );
											var parameters = $.extend( {}, dataList, formData );

											loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
											
											$.post( url, parameters, function( json ) {
												alert(json.resultMsg);
												if ( json.result == 'success' ) {
													fn_search1();
													$("#p_spec_seq").val("");
												}
											}, "json").error( function() {
												alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
											} ).always( function() {
												loadingBox.remove();
											} );
										} );
									}
								}
							}

							
						});
		
		//품목 그리드 변경된 내용을 가져온다.
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#itemTransList" ).jqGrid( 'getRowData' ), function( obj ) {
				return  obj.oper == 'I';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//사양 그리드 변경된 내용을 가져온다.
		function getChangedChmResultData1( callback ) {
			var changedData = $.grep( $( "#itemTransList1" ).jqGrid( 'getRowData' ), function( obj ) {
				return  obj.oper == 'I';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		};
		
		//########  추가버튼 ########//
		$("#btnAdd").click(
				function() {
					$("#itemTransList").saveCell(kRow, idCol);

					if ($("#p_catalog_name").val() == '') {
						alert("Catalog가 잘못되었습니다.");
						return false;
					}

					//spec No를 받아옴.
					var item_code = $("#p_itemcode").val();
					if ($("input[name=p_item_seq]").val() == "") {
						//DB에서 다음 ITEM SEQ를 받아옴.
						getLastItemSeq();
					} else {
						var itemseq = $("input[name=p_item_seq]").val();
						itemseq++;
						itemseq = LPAD("" + itemseq, '0', 4);
						$("input[name=p_item_seq]").val(itemseq);
					}

					var item_seq = $("input[name=p_item_seq]").val();
					if (item_seq == "") {
						item_seq = "0001";
					}
					$("input[name=p_item_seq]").val(item_seq);
					catalog = $("#p_catalog_code").val();

					var newData = [ {
						catalog_code : catalog,
						i_item_code : item_seq,
						i_item_desc : '',
						oper : 'I'
					} ]
					$("#itemTransList").jqGrid('addRowData', item_seq,
							newData[0], "first");

					$("#btnDel").attr("disabled", false);

				});
		//사양 화면 추가버튼
		$("#btnAdd1").click(
				function() {	
					$("#itemTransList1").saveCell(kRow, idCol);

					if ($("#p_catalog_name1").val() == '') {
						alert("Catalog가 잘못되었습니다.");
						return false;
					}
					if ($("#p_itemcode").val() == '') {
						alert("품목코드를 입력해 주십시오.");
						return false;
					}

					//var specSeq = LPAD(""+spec_seq,'0',5);
					//spec No를 받아옴.
					var item_code = $("#p_itemcode").val();
					if ($("input[name=p_spec_seq]").val() == "") {
						//DB에서 가장 큰 Spec_Seq를 받아옴.
						getLastSpecSeq();
					} else {
						var spsq = $("input[name=p_spec_seq]").val();
						spsq++;
						spsq = LPAD("" + spsq, '0', 5);
						$("input[name=p_spec_seq]").val(spsq);
					}

					var specSeq = $("input[name=p_spec_seq]").val();
					if (specSeq == "") {
						specSeq = "0001";
					}

					//그리드의 00001을 받아와 품목명을 셋팅한다.
					var arr_date = $.grep($("#itemTransList1").jqGrid(
							'getRowData'), function(obj) {
						return obj.spec_code == '00001';
					});
					var item_desc = arr_date[0].item_desc;

					//Item Description 에도 입력
					$("#p_itemname").val(item_desc);

					//var rowid= jQuery("#itemTransList1").jqGrid('getGridParam','selrow');

					catalog = $("#p_catalog_code1").val();

					var newData = [ {
						catalog : catalog,
						item_code : item_code,
						spec_code : specSeq,
						item_desc : item_desc,
						spec_name1 : '',
						spec_name2 : '',
						spec_name3 : '',
						oper : 'I'
					} ]
					$("#itemTransList1").jqGrid('addRowData', specSeq,
							newData[0], "first");

					$("#btnDel").attr("disabled", false);
				});

		//########  삭제버튼 ########//
		$("#btnDel").click(
				function() {
					$("#itemTransList").saveCell(kRow, idCol);

					var rowId = $("#itemTransList").jqGrid('getGridParam',
							"selrow");
					
					var isOper = $("#itemTransList")
							.jqGrid('getRowData', rowId).oper;
					if (rowId == null) {
						alert("행을 선택하십시오.");
						return;
					}
					if (isOper == "I") {
						$("#itemTransList").jqGrid('delRowData', rowId);
					} else {
						alert("삭제할 수 없습니다.");
					}
				});

		$("#btnDel1").click(
				function() {

					$("#itemTransList1").saveCell(kRow, idCol);

					var rowId = $("#itemTransList1").jqGrid('getGridParam',
							"selrow");
					var isOper = $("#itemTransList1").jqGrid('getRowData',
							rowId).oper;
					if (rowId == null) {
						alert("행을 선택하십시오.");
						return;
					}
					if (isOper == "I") {
						$("#itemTransList1").jqGrid('delRowData', rowId);
					} else {
						alert("삭제할 수 없습니다.");
					}
				});

		//########  닫기버튼 ########//
		$("#btnClose").click(function() {
			window.close();
		});

		//######## 메시지 Call ########//

		var afterDBTran = function(json) {
			$(".loadingBoxArea").hide();
			var msg = "";
			for ( var keys in json) {
				for ( var key in json[keys]) {
					if (key == 'Result_Msg') {
						msg = json[keys][key];
					}
				}
			}
			alert(msg);

			if (msg.indexOf('정상적') > -1) {
				opener.$("#btnSearch").click();
				fn_search();
				fn_search1();
			}
		}

		function fn_search() {
			if ($("#p_catalog_code").val() != '') {
				$("#itemTransList").jqGrid("clearGridData");
				getCatalog( $("input[name=p_catalog_code]").val(), "item" );
				var sUrl = "popUpEmsDbMasterAddList_Item.do";
				jQuery("#itemTransList").jqGrid("GridUnload");
				loadDatas(sUrl);
			}
		}

		function fn_search1() {
			if ($("#p_catalog_code1").val() != '') {
				$("#itemTransList1").jqGrid("clearGridData");
				getCatalog( $("input[name=p_catalog_code1]").val(), "spec" );
				var sUrl = "popUpEmsDbMasterAddList_Spec.do";
				jQuery("#itemTransList1").jqGrid("GridUnload");
				loadDatas1(sUrl);
			}
		}

		function fn_search2() {
			//$("#itemTransList").jqGrid("clearGridData");								
			jQuery("#itemTransList").jqGrid("GridUnload");
			loadDatas('');

			//$("#itemTransList1").jqGrid("clearGridData");								
			jQuery("#itemTransList1").jqGrid("GridUnload");
			loadDatas1('');
		}

		//######## Input text 부분 숫자만 입력 ########//
		function onlyNumber(event) {
			var key = window.event ? event.keyCode : event.which;

			if ((event.shiftKey == false)
					&& ((key > 47 && key < 58) || (key > 95 && key < 106)
							|| key == 35 || key == 36 || key == 37 || key == 39 // 방향키 좌우,home,end  
							|| key == 8 || key == 46) // del, back space
			) {
				return true;
			} else {
				return false;
			}
		};

		//폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}

		//header checkbox action 
		function checkBoxHeader(e) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if (($("#chkHeader").is(":checked"))) {
				$(".chkboxItem").prop("checked", true);
			} else {
				$("input.chkboxItem").prop("checked", false);
			}
		}

		// 왼쪽에서부터 채운다는 의미
		function LPAD(s, c, n) {
			if (!s || !c || s.length >= n) {
				return s;
			}
			var max = (n - s.length) / c.length;
			for (var i = 0; i < max; i++) {
				s = c + s;
			}
			return s;
		}

		function loadDatas(url) {

			$("#itemTransList")
					.jqGrid(
							{
								datatype : 'json',
								mtype : 'post',
								url : url,
								postData : getFormData('#application_form'),
								colNames : [ 'Catalog', 'Code', '품목', 'oper' ],
								colModel : [ {name : 'catalog_code', index : 'catalog_code', width : 110, align : 'center', sortable : false }, 
								             {name : 'i_item_code', index : 'i_item_code', width : 110, align : 'center'}, 
								             {name : 'i_item_desc', index : 'i_item_desc', width : 500, align : 'left', editable : true, edittype : "text" }, 
								             {name : 'oper', index : 'oper', hidden : true } ],
								gridview : true,
								toolbar : [ false, "bottom" ],
								viewrecords : true,
								autowidth : true,
								
								cellEdit : true,
								cellsubmit : 'clientArray', // grid edit mode 2
								shrinkToFit : true,
								
								pager : jQuery('#btnitemTransList'),
								rowList : [ 100, 500, 1000 ],
								rowNum : 100,
								beforeSaveCell : chmResultEditEnd,
								beforeEditCell : function(rowid, cellname,
										value, iRow, iCol) {
									idRow = rowid;
									idCol = iCol;
									kRow = iRow;
									kCol = iCol;
								},
								jsonReader : {
									root : "rows",
									page : "page",
									total : "total",
									records : "records",
									repeatitems : false,
								},
								imgpath : 'themes/basic/images',
								onPaging : function(pgButton) {
									$(this).jqGrid("clearGridData");
									$(this).setGridParam({
										datatype : 'json',
										postData : {
											pageYn : 'Y'
										}
									}).triggerHandler("reloadGrid");
								},
								onCellSelect : function(row_id, icol,
										cellcontent, e) {
									var ret = $(this).getRowData(row_id);

									if (ret.oper == "") {
										$(this).jqGrid('setCell', row_id,
												'i_item_code', '',
												'not-editable-cell');
										$(this).jqGrid('setCell', row_id,
												'i_item_desc', '',
												'not-editable-cell');
									}
								},
								loadComplete : function(data) {
									var $this = $(this);
									if ($this
											.jqGrid('getGridParam', 'datatype') === 'json') {
										$this.jqGrid('setGridParam', {
											datatype : 'local',
											data : data.rows,
											pageServer : data.page,
											recordsServer : data.records,
											lastpageServer : data.total
										});
										this.refreshIndex();
										if ($this.jqGrid('getGridParam',
												'sortname') !== '') {
											$this.triggerHandler('reloadGrid');
										}
									} else {
										$this.jqGrid('setGridParam', {
											page : $this.jqGrid('getGridParam',
													'pageServer'),
											records : $this.jqGrid(
													'getGridParam',
													'recordsServer'),
											lastpage : $this.jqGrid(
													'getGridParam',
													'lastpageServer')
										});
										this.updatepager(false, true);
									}
									item_cnt = $("#itemTransList").getDataIDs().length;
									item_seq = $("#itemTransList").getDataIDs().length;
								},
								afterSaveCell  : function(rowid,name,val,iRow,iCol) {
					            	if (name == "i_item_desc") setUpperCase('#itemTransList',rowid,name);
							 	}
							}); //end of jqGrid
			//jqGrid 크기 동적화
		 	fn_gridresize( $(window), $( "#itemTransList" ), -40 );
		}

		//품목 탭 그리드 수정시 oper 변경
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $( '#itemTransList' ).jqGrid( 'getRowData', irowId );
			if (item.oper != 'I') item.oper = 'U';
			$('#itemTransList').jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			$( '#itemTransList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}
		
		//품목 탭 그리드의 변경사항,필수입력 여부 
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#itemTransList" ).jqGrid( 'getDataIDs' );
			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#itemTransList" ).jqGrid( 'getCell', ids[i], 'oper' );
				if( oper == 'I') {
					nChangedCnt++;
					
					//품목 미입력 여부 확인
					var val1 = $( "#itemTransList" ).jqGrid( 'getCell', ids[i], 'i_item_desc' );
					if ( $.jgrid.isEmpty( val1 ) ) {
						alert( "품목을 입력하십시오." );
						result = false;
						message = "Field is required";
							setErrorFocus( "#itemTransList", ids[i], 0, 'i_item_desc' );
						break;
					}
					
				}
			}
			if ( nChangedCnt == 0 ) {
				result = false;
				alert( "변경된 내용이 없습니다." );
			}
			return result;
		}

		function loadDatas1(url) {
			$("#itemTransList1")
					.jqGrid(
							{
								datatype : 'json',
								mtype : 'post',
								url : url,
								postData : getFormData('#application_form'),
								colNames : [ 'Catalog', '품목Code', '품목Description', '사양Code', '사양1', '사양2', '사양3', 'oper' ],
								colModel : [ {name : 'catalog', index : 'catalog', width : 50, align : 'center', sortable : false }, 
								             {name : 'item_code', index : 'item_code', width : 70, align : 'center', sortable : false },
								             {name : 'item_desc', index : 'item_desc', width : 270, align : 'left', sortable : false }, 
								             {name : 'spec_code', index : 'spec_code', width : 70, align : 'center', sortable : false }, 
								             {name : 'spec_name1', index : 'spec_name1', width : 103, align : 'left', editable : true, edittype : "text" }, 
								             {name : 'spec_name2', index : 'spec_name2', width : 103, align : 'left', editable : true, edittype : "text" }, 
								             {name : 'spec_name3', index : 'spec_name3', width : 103, align : 'left', editable : true, edittype : "text" }, 
								             {name : 'oper', index : 'oper', hidden : true } ],
								gridview : true,
								toolbar : [ false, "bottom" ],
								viewrecords : true,
								autowidth : true,
								cellEdit : true,
								cellsubmit : 'clientArray', // grid edit mode 2
								shrinkToFit : true,
								pager : jQuery('#btnitemTransList1'),
								beforeSaveCell : chmResultEditEnd1,
								rowList : [ 100, 500, 1000 ],
								rowNum : 100,
								beforeEditCell : function(rowid, cellname,
										value, iRow, iCol) {
									idRow = rowid;
									idCol = iCol;
									kRow = iRow;
									kCol = iCol;
								},
								onCellSelect : function(row_id, icol,
										cellcontent, e) {
									var ret = $(this).getRowData(row_id);

									if (ret.oper == "") {
										$(this).jqGrid('setCell', row_id,
												'spec_code', '',
												'not-editable-cell');
										$(this).jqGrid('setCell', row_id,
												'spec_name1', '',
												'not-editable-cell');
										$(this).jqGrid('setCell', row_id,
												'spec_name2', '',
												'not-editable-cell');
										$(this).jqGrid('setCell', row_id,
												'spec_name3', '',
												'not-editable-cell');
									}
								},
								jsonReader : {
									root : "rows",
									page : "page",
									total : "total",
									records : "records",
									repeatitems : false,
								},
								imgpath : 'themes/basic/images',
								onPaging : function(pgButton) {
									$(this).jqGrid("clearGridData");
									$(this).setGridParam({
										datatype : 'json',
										postData : {
											pageYn : 'Y'
										}
									}).triggerHandler("reloadGrid");
								},
								loadComplete : function(data) {
									var $this = $(this);
									if ($this
											.jqGrid('getGridParam', 'datatype') === 'json') {
										$this.jqGrid('setGridParam', {
											datatype : 'local',
											data : data.rows,
											pageServer : data.page,
											recordsServer : data.records,
											lastpageServer : data.total
										});
										this.refreshIndex();
										if ($this.jqGrid('getGridParam',
												'sortname') !== '') {
											$this.triggerHandler('reloadGrid');
										}
									} else {
										$this.jqGrid('setGridParam', {
											page : $this.jqGrid('getGridParam',
													'pageServer'),
											records : $this.jqGrid(
													'getGridParam',
													'recordsServer'),
											lastpage : $this.jqGrid(
													'getGridParam',
													'lastpageServer')
										});
										this.updatepager(false, true);
									}
									spec_cnt = $("#itemTransList1")
											.getDataIDs().length;
									spec_seq = $("#itemTransList1")
											.getDataIDs().length;
								},
								afterSaveCell  : function(rowid,name,val,iRow,iCol) {
					            	if (name == "spec_name1" || name == "spec_name2" || name == "spec_name3") setUpperCase('#itemTransList1',rowid,name);
							 	}
							}); //end of jqGrid
			//jqGrid 크기 동적화
		 	fn_gridresize( $(window), $( "#itemTransList1" ), -40 );
		}

		//사양 탭 그리드 수정시 oper 변경
		function chmResultEditEnd1(irowId, cellName, value, irow, iCol) {
			var item = $( '#itemTransList1' ).jqGrid( 'getRowData', irowId );
			if (item.oper != 'I') item.oper = 'U';
			$('#itemTransList1').jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			$( '#itemTransList1' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
			
		}
		
		//품목 탭 그리드의 변경사항,필수입력 여부
		function fn_checkValidate1() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#itemTransList1" ).jqGrid( 'getDataIDs' );
			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#itemTransList1" ).jqGrid( 'getCell', ids[i], 'oper' );
				if( oper == 'I') {
					nChangedCnt++;
					
					//사양1 미입력 여부 확인
// 					var val1 = $( "#itemTransList1" ).jqGrid( 'getCell', ids[i], 'spec_name1' );
// 					if ( $.jgrid.isEmpty( val1 ) ) {
// 						alert( "사양1을 입력하십시오." );
// 						result = false;
// 						message = "Field is required";
// 							setErrorFocus( "#itemTransList1", ids[i], 0, 'spec_name1' );
// 						break;
// 					}
					
					//사양2 미입력 여부 확인
// 					var val2 = $( "#itemTransList1" ).jqGrid( 'getCell', ids[i], 'spec_name2' );
// 					if ( $.jgrid.isEmpty( val2 ) ) {
// 						alert( "사양2을 입력하십시오." );
// 						result = false;
// 						message = "Field is required";
// 							setErrorFocus( "#itemTransList1", ids[i], 0, 'spec_name2' );
// 						break;
// 					}
					
					//사양3 미입력 여부 확인
// 					var val2 = $( "#itemTransList1" ).jqGrid( 'getCell', ids[i], 'spec_name3' );
// 					if ( $.jgrid.isEmpty( val2 ) ) {
// 						alert( "사양2을 입력하십시오." );
// 						result = false;
// 						message = "Field is required";
// 							setErrorFocus( "#itemTransList1", ids[i], 0, 'spec_name3' );
// 						break;
// 					}
					
				}
			}
			if ( nChangedCnt == 0 ) {
				result = false;
				alert( "변경된 내용이 없습니다." );
			}
			return result;
		}
		
		//그리드 내 입력시 대문자 자동 변환 함수
		function setUpperCase(gridId, rowId, colNm) {
			
			if (rowId != 0 ) {
				
				var $grid = $(gridId);
				var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
						
				$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
			}
		}
	</script>
</body>
</html>