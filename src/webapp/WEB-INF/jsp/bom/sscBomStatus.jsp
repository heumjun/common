<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BOM 상세 조회</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<!-- 탭 초기화 -->
<script>
	$(function() {
		$("#tabs").tabs();
	});
</script>
<body>
	<div id="mainDiv" class="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}" />
			<input type="hidden" id="p_ecr_no" name="p_ecr_no" /> 
			<input type="hidden" id="project_no" name="project_no" /> 
			<input type="hidden" id="nodeid" name="nodeid" /> 
			<input type="hidden" id="motherCode" name="motherCode" /> 
			<input type="hidden" id="item_catalog" name="item_catalog" /> 
			<input type="hidden" id="n_level" name="n_level" /> 
			<input type="hidden" name="p_job_dept_code" id="p_job_dept_code" value="${jobDeptMap.job_dept_code}" /> 
			<input type="hidden" name="p_job_type" id="p_job_type" /> 
			<input type="hidden" name="p_job_catalog" id="p_job_catalog" /> 
			<input type="hidden" name="p_bom10" id="p_bom10" /> 
			<input type="hidden" name="p_bom11" id="p_bom11" /> 
			<input type="hidden" name="item_bom_type" id="item_bom_type" /> 
			<input type="hidden" name="p_item_states_desc" id="p_item_states_desc" /> 
			<input type="hidden" id="p_selectMotherCode" name="p_selectMotherCode" /> 
			<input type="hidden" id="p_selectItemCode" name="p_selectItemCode" /> 
			<input type="hidden" id="p_selectDescription" name="p_selectDescription" />
			<input type="hidden" id="p_selectProjectNo" name="p_selectProjectNo" />
			<input type="hidden" id="p_selectBomType" name="p_selectBomType" /> 
			<input type="hidden" id="p_selectStatus" name="p_selectStatus" /> 
			<input type="hidden" id="p_selectCatalog" name="p_selectCatalog" /> 
			<input type="hidden" id="p_selectUom" name="p_selectUom" /> 
			<input type="hidden" id="p_selectQty" name="p_selectQty" /> 
			<input type="hidden" id="p_selectEcoNo" name="p_selectEcoNo" /> 
			<input type="hidden" id="p_selectEcoCreater" name="p_selectEcoCreater" /> 
			<input type="hidden" id="p_selectStatesFlag" name="p_selectStatesFlag" />

			<div class="subtitle">
				BOM 상세 조회
				<jsp:include page="../common/commonManualFileDownload.jsp"
					flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
			</div>
			<table>
				<tr>
					<td width="93%">
						<fieldset
							style="border: none; position: relative; float: left; width: 65%;">
							<legend class="sc_tit sc_tit2">ITEM</legend>
							<table class="searchArea2 conSearch">
								<tr>
									<th>PROJECT</th>
									<td><input type="text" id="p_project_no" name="p_project_no" alt="Project" class="required" style="width: 80px; text-align: center; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);getShipType();" value="${project_no}" /> 
									<input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" /></td>
									<th>ITEM CODE</th>
									<td><input type="text" class="toUpper wid180" id="p_item_code" name="p_item_code" style="width: 120px; text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" value="${item_code}" /></td>
									<%-- <th>MOTHER CODE</th>
									<td><input type="text" id="p_mother_code" name="p_mother_code"  class="toUpper wid180" style="width: 120px;text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" value="${mother_code}"/></td> --%>
									<th>ITEM DESC</th>
									<td style="border-right: none;"><input type="text" id="p_item_desc" name="p_item_desc" class="toUpper wid180" style="width: 120px; text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" value="" /></td>
								</tr>
								<tr>
									<th>CATALOG</th>
									<td><input type="text" class="toUpper wid180" id="p_item_catalog" name="p_item_catalog" style="width: 120px; text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
									<th>생성자</th>
									<td><input type="text" class="toUpper wid180" id="p_emp_no" name="p_emp_no" style="width: 120px; text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
								</tr>
								<!-- <tr>
									<th>ITEM ATTR1</th>
									<td><input type="text" class="toUpper wid180" id="p_item_attr1" name="p_item_attr1" style="width: 120px;text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
									<th>ITEM ATTR2</th>
									<td><input type="text" class="toUpper wid180" id="p_item_attr2" name="p_item_attr2" style="width: 120px;text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
									<th>ITEM ATTR3</th>
									<td style="border-right: none;"><input type="text" class="toUpper wid180" id="p_item_attr3" name="p_item_attr3" style="width: 120px;text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
								</tr> -->
							</table>
						</fieldset>
						<fieldset
							style="border: none; position: relative; float: left; width: 33%;">
							<legend class="sc_tit sc_tit2">ECO</legend>
							<table class="searchArea2 conSearch" style="padding-top: 15px">
								<tr>
									<th>ECO</th>
									<td><input type="text" name="p_eco_no" id="p_eco_no" style="width: 80px;" /> 
									<input type="button" id="btnEcoCode" name="btnEcoCode" value="검색" class="btn_gray2" /></td>
									<th>생성자</th>
									<td><input type="text" class="toUpper wid180" id="p_eco_emp_no" name="p_eco_emp_no" style="text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
								</tr>
							</table>
						</fieldset>
					</td>

					<td width="5%">
						<div class="button endbox">
							<p style="margin-top: -10px;">&nbsp;</p>
							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" class="btn_blue wid70" id="btnSelect" name="" value="조회" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<fieldset style="border: none; position: relative; float: left; width: 98.5%;">
							<legend class="sc_tit sc_tit2">SELECTED CODE</legend>
							<table class="searchArea2 conSearch">

								<tr>
									<th>ITEM CODE</th>
									<th>MOTHER CODE</th>
									<!-- <th>PROJECT</th> -->
									<th style="width: 300px;">DESCRIPTION</th>
									<th>현황</th>
									<th>BOM TYPE</th>
									<!-- <th>상태</th> -->
									<th>CATALOG</th>
									<th>UOM</th>
									<th>QTY</th>
									<th>ECO NO</th>
									<th>ECO 생성자</th>
								</tr>
								<tr>
									<td style="text-align: center;">
										<span id="selectItemCode"></span>
									</td>
									<td style="text-align: center;"><span
										id="selectMotherCode"></span></td>
									<!-- <td style="text-align: center;">
									<span id="selectProjectNo"></span>
								</td> -->
									<td style="text-align: center;"><span
										id="selectDescription"></span></td>
									<td style="text-align: center;"><span
										id="selectStatesFlag"></span></td>
									<td style="text-align: center;"><span id="selectBomType"></span>
									</td>
									<!-- <td style="text-align: center;">
									<span id="selectStatus"></span>
								</td> -->
									<td style="text-align: center;"><span id="selectCatalog"></span>
									</td>
									<td style="text-align: center;"><span id="selectUom"></span>
									</td>
									<td style="text-align: center;"><span id="selectQty"></span>
									</td>
									<td style="text-align: center;"><span id="selectEcoNo"></span>
									</td>
									<td style="text-align: center;"><span
										id="selectEcoCreater"></span></td>

								</tr>
							</table>
						</fieldset>
					</td>
					<td>
						<div class="button endbox">
							<p style="margin-top: -10px;">&nbsp;</p>
							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" class="btn_blue wid70" id="btnHistory" name="" value="HISTORY" />
								<!-- <input type="button" class="btn_blue wid70" id="btnaa" name="" value="aa" />
								<input type="button" class="btn_blue wid70" id="btnbb" name="" value="bb" /> -->
							</c:if>
						</div>
					</td>
				</tr>
			</table>

			<div id="tabs"
				style="position: absolute; border: none; float: left; width: 18%; margin: 9px 0 0 0;">
				<div id="slider" style="display: none;"></div>
				<ul>
					<li><a id="a_tab1" href="#tabs-1" onclick="changeTab(1)">정전개</a></li>
					<li><a id="a_tab2" href="#tabs-2" onclick="changeTab(2)">역전개</a></li>
					<li style="float: right; margin-top: 3px;"><img id="iconExpand" src="/images/tree/bom_plus1.png" /></li>
				</ul>
				<div id="tabs-1">
					<div id="content1">
						<table id="treegrid1"></table>
						<div id="ptreegrid1"></div>
					</div>
				</div>
				<div id="tabs-2">
					<div id="content2">
						<table id="treegrid2"></table>
						<div id="ptreegrid2"></div>
					</div>
				</div>
			</div>
			<div style="float: right; width: 81%; margin: 5px 0 0 0;"
				id="divBomList1">
				<table>
					<%-- <tr>
						<td>
						<c:if test="${userRole.attribute2 == 'Y'}">
						<input type="button" class="btn_blue wid80" id="btnAddItem" name="" value="ITEM 추가" />
						</c:if>
						<c:if test="${userRole.attribute3 == 'Y'}">
							<input type="button" class="btn_blue wid80" id="btnDelItem" name="" value="ITEM 삭제" />
						</c:if>
						<c:if test="${userRole.attribute3 == 'Y'}">
							<input type="button" class="btn_blue wid60" id="btnSave" name="" value="저장" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_blue wid123" id="btnCreateBOM" name="" value="채번 및 BOM 생성" />
						</c:if>
						<!-- <input type="button" class="btn_blue wid80" id="btnAddSSC" name="" value="SSC 추가" /> -->
						</td>
						<th width="80px">Ship Type</th>
						<td width="80px"><input type="text" id="p_ship_type" name="p_ship_type" style="width: 30px;" /> <c:if
							test="${userRole.attribute2 == 'Y'}">
							<input type="button" id="btnShipType" value="검색" style="" class="btn_blue2" />
						</c:if></td>
						<th width="80px">ECO NO.</th>
						<td width="180px"><input type="text" id="p_eng_change_order_code" name="p_eng_change_order_code" style="width: 100px;" /> <c:if
							test="${userRole.attribute2 == 'Y'}">
							<input type="button" id="btnCreateEco" value="ECO 추가" style="" class="btn_blue2" />
						</c:if></td> --%>
				</table>
				<div style="margin-top: 5px;">
					<table id="bomList1"></table>
					<div id="pbomList1"></div>
				</div>
			</div>
		</form>

	</div>

	<script type="text/javascript">
		// 선택Grid정보
		var idRow = 0;
		var idCol = 0;
		var kRow = 0;
		var kCol = 0;
		var resultData = [];
		var selectedTab = 1;
		var menuId = '';
		
		// Grid 높이
		function gridObjectHeight(divId, headerSize) {
			var sheight = null;
			var cheight = null;
			if (navigator.userAgent.indexOf("MSIE 5.5") != -1) {
				sheight = document.body.scrollHeight;
				cheight = document.body.clientHeight;
			} else {
				sheight = document.documentElement.scrollHeight;
				cheight = document.documentElement.clientHeight;
			}
			var positionTop = $('#' + divId).position().top;
			var objectHeight = sheight - positionTop - 85 - (32 * headerSize);
			return objectHeight;
		}
		// tree Grid 가로사이즈 조절기능
		$(function() {
			var firstSize = $("#tabs").width();
			var firstSize2 = $("#divBomList1").width();
			/* $( "#slider" ).slider({
				slide: function( event, ui ) {
					$("#tabs").css('width', firstSize + ui.value*3 + 'px');
					$("#divBomList1").css('width', firstSize2 - ui.value*3 + 'px');
					fn_insideGridresize($(window), $("#tabs"), $("#treegrid1"), 172);
					fn_insideGridresize($(window), $("#tabs"), $("#treegrid2"), 172);
					fn_insideGridresize($(window), $("#divBomList1"), $("#bomList1"), 130);
				}
			}); */
		});
		$(document)
				.ready(
						function() {
							fn_all_text_upper();
							var objectHeight = gridObjectHeight("content1", 9);
							$("#treegrid1").jqGrid(
									{
										url : '',
										treedatatype : "json",
										mtype : "",
										postData : fn_getFormData("#application_form"),
										colNames : [ 'LV', 'MOTHER CODE', 'ITEM CODE', 'BOM TYPE', 'CATALOG',
												'DESCRIPTION', 'UOM', 'QTY', 'Creator', 'ECO NO', 'ECO Creator',
												'LEAF', 'FOLD', '상태', '현황', '', '' ],
										colModel : [ {
											name : 'lev',
											index : 'lev',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'mother_code',
											index : 'mother_code',
											width : 80,
											align : "left",
											hidden : true,
											sortable : false
										}, {
											name : 'item_code',
											index : 'item_code',
											width : 400,
											align : "left",
											sortable : false
										}, {
											name : 'bom_type',
											index : 'bom_type',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'item_catalog',
											index : 'item_catalog',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'item_desc',
											index : 'item_desc',
											width : 255,
											align : "left",
											hidden : true
										}, {
											name : 'uom',
											index : 'uom',
											width : 40,
											align : "center",
											hidden : true
										}, {
											name : 'qty',
											index : 'qty',
											width : 40,
											align : "right",
											hidden : true
										}, {
											name : 'emp_no',
											index : 'emp_no',
											width : 150,
											align : "center",
											hidden : true
										}, {
											name : 'eco_no',
											index : 'eco_no',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'created_by',
											index : 'created_by',
											width : 150,
											align : "center",
											hidden : true
										}, {
											name : 'leaf',
											index : 'leaf',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'fold',
											index : 'fold',
											width : 80,
											align : "left",
											hidden : true
										},
										/* { name : 'bom10', index : 'bom10', width : 80, align : "left", hidden : true },
										{ name : 'bom11', index : 'bom11', width : 80, align : "left", hidden : true }, */
										{
											name : 'item_states_desc',
											index : 'item_states_desc',
											width : 120,
											align : "center",
											hidden : true
										}, {
											name : 'states_flag_desc',
											index : 'states_flag_desc',
											width : 40,
											align : "center",
											hidden : true
										}, {
											name : 'select_id',
											index : 'select_id',
											width : 40,
											align : "center",
											hidden : true,
											key : true
										}, {
											name : 'parent_select_id',
											index : 'parent_select_id',
											width : 40,
											align : "center",
											hidden : true
										} ],
										autowidth : true,
										cmTemplate : {
											title : false
										},
										treeGridModel : 'adjacency',
										height : objectHeight + 25,
										treeGrid : true,
										ExpandColumn : 'item_code',
										jsonReader : {
											repeatitems : false,
											id : "lev",
											page : function(obj) {
												return 1;
											},
											total : function(obj) {
												return 1;
											},
										},
										treeReader : {
											level_field : "lev",
											parent_id_field : "parent_select_id",
											leaf_field : "leaf",
											expanded_field : "fold"
										},
										gridComplete : function() {

											var rows = $("#treegrid1").getDataIDs();
											for (var i = 0; i < rows.length; i++) {
												//수정 및 결재 가능한 리스트 색상 변경
												var leaf = $("#treegrid1").getCell(rows[i], "leaf");
												if (leaf != "true" && leaf != "0") {
													$("#treegrid1").jqGrid('setCell', rows[i], 'item_code', '', {
														background : '#afc2fa'
													});
												}
											}

											//건별 정전개 펼치기/닫기
											/* var rData = $("#treegrid1").jqGrid('getGridParam','data'); 
											if (rData[0]) { 
												setTimeout(function(){ 
													for (i=0;i<rData.length;i++) { 
														//$("#treegrid1").jqGrid('expandRow',rData[i]); 
														$("#treegrid1").jqGrid('expandNode',rData[i]); 
											// 										$("#treegrid1").jqGrid('collapseRow',rData[i]);
														$("#treegrid1").jqGrid('collapseNode',rData[i]); 
													} 
												}, 0); 
											} */
										},
										onCellSelect : function(rowid, iCol, cellcontent, e) {
											var cm = $("#treegrid1").jqGrid("getGridParam", "colModel");
											var colName = cm[iCol];
											var item = $("#treegrid1").jqGrid("getRowData", rowid);
											$("#bomList1").jqGrid("clearGridData");

											/* if(item.leaf == "true"){
												alert("선택된 Item의 하위 Item이 존재하지 않습니다.");
												return;
											} */
											// ITEM CODE를 선택했을때
											if (colName['index'] == "item_code") {
												// SELECTED CODE 에 선택된 ITEM 정보를 표시
												$("#selectMotherCode").html(item.mother_code);
												$("#selectItemCode").html(item.item_code);
												$("#selectDescription").html(item.item_desc);
												// 선택된 ITEM이  Table 정보가 아닐때 (SSC,PANDING등)
												if (item.states_flag_desc != "BOM") {
													// 선택된 ITEM의 PROJECTNO
													$("#p_selectProjectNo").val(item.states_flag_desc.split("-")[0]);
													$("#selectProjectNo").html(item.states_flag_desc.split("-")[0]);
													$("#selectStatesFlag").html(item.states_flag_desc.split("-")[1]);
												} else {
													// USC인경우
													$("#selectProjectNo").html("-");
													$("#selectStatesFlag").html(item.states_flag_desc);
												}
												$("#selectBomType").html(item.bom_type);
												$("#selectCatalog").html(item.item_catalog);
												/* $("#selectStatus").html(item.item_states_desc); */
												$("#selectUom").html(item.uom);
												$("#selectQty").html(item.qty);
												$("#selectEcoNo").html(item.eco_no);
												$("#selectEcoCreater").html(item.created_by);
												$("#p_item_states_desc").val(item.item_states_desc);
												$("#nodeid").val(item.item_code);
												$("#n_level").val(item.lev);
												// 선택된 ITEM의 자식 리스트 취득								
												var sUrl = "infoBomTree.do";
												$("#bomList1").jqGrid('setGridParam', {
													url : sUrl,
													mtype : "POST",
													datatype : 'json',
													page : 1,
													postData : fn_getFormData("#application_form")
												}).trigger("reloadGrid");

												$("#p_bom10").val(item.bom10);
												$("#p_bom11").val(item.bom11);
												$("#item_catalog").val(item.item_catalog);
												$("#item_bom_type").val(item.bom_type);
												$("#p_job_type").val("");

												setButtonEDControl(item.bom_type, item.states_flag_desc);
											}
										}
									});

							$("#bomList1")
									.jqGrid(
											{
												datatype : 'json',
												mtype : '',
												url : '',
												postData : fn_getFormData("#application_form"),
												colNames : [ '현황', 'LV', 'MOTHER CODE', '+1 LV CODE', 'BOM TYPE', '상태',
														'CATALOG', '...', 'DESCRIPTION', 'UOM', 'QTY', 'DWG No', '...',
														'Creator', 'Item 속성', 'BOM 속성', 'ECO NO', 'ECO 생성자', 'History',
														'enable_flag_changed', 'crud', '', 'attr_1', 'attr_2',
														'attr_3', 'attr_4', 'attr_5', 'attr_6', 'attr_7', 'attr_8',
														'attr_9', 'attr_10', 'attr_11', 'attr_12', 'attr_13',
														'attr_14', 'attr_15', 'code_1', 'code_2', 'code_3', 'code_4',
														'code_5', 'code_6', 'code_7', 'code_8', 'code_9', 'code_10',
														'code_11', 'code_12', 'code_13', 'code_14', 'code_15', 'add_1',
														'add_2', 'add_3', 'add_4', 'add_5', 'add_6', 'add_7', 'add_8',
														'add_9', 'add_10', 'add_11', 'add_12', 'add_13', 'add_14',
														'add_15', 'bom1', 'bom2', 'bom3', 'bom4', 'bom5', 'bom6',
														'bom7', 'bom8', 'bom9', 'bom10', 'bom11', 'bom12', 'bom13',
														'bom14', 'bom15', 'states_flag', 'F-NO' ],
												colModel : [ {
													name : 'states_flag_desc',
													index : 'states_flag_desc',
													width : 110,
													align : "center"
												}, {
													name : 'lev',
													index : 'lev',
													width : 80,
													align : "left",
													hidden : true
												}, {
													name : 'mother_code',
													index : 'mother_code',
													width : 100,
													align : "left",
													hidden : true
												}, {
													name : 'item_code',
													index : 'item_code',
													width : 100,
													align : "center",
													editable : true
												}, {
													name : 'bom_type',
													index : 'bom_type',
													width : 40,
													align : "center",
													hidden : true
												}, {
													name : 'item_states_desc',
													index : 'item_states_desc',
													width : 100,
													align : "center",
													hidden : true
												}, {
													name : 'item_catalog',
													index : 'item_catalog',
													width : 80,
													align : "center"
												}, {
													name : 'job_catalog_popup',
													index : 'job_catalog_popup',
													align : 'center',
													width : 30,
													hidden : true
												}, {
													name : 'item_desc',
													index : 'item_desc',
													width : 255,
													align : "left",
													editable : true
												}, {
													name : 'uom',
													index : 'uom',
													width : 40,
													align : "center"
												}, {
													name : 'qty',
													index : 'qty',
													width : 40,
													align : "right"
												}, {
													name : 'dwg_no',
													index : 'dwg_no',
													width : 80,
													align : "center",
													editable : false,
													hidden : true
												}, {
													name : 'dwg_no_popup',
													index : 'dwg_no_popup',
													align : 'center',
													width : 30,
													hidden : true
												}, {
													name : 'emp_no',
													index : 'emp_no',
													width : 160,
													align : "center",
													hidden : true
												}, {
													name : 'item_attr',
													index : 'item_attr',
													width : 50,
													align : "center"
												}, {
													name : 'bom_attr',
													index : 'bom_attr',
													width : 50,
													align : "center"
												}, {
													name : 'eco_no',
													index : 'eco_no',
													width : 80,
													align : "center"
												}, {
													name : 'created_by',
													index : 'created_by',
													width : 180,
													align : "center"
												}, {
													name : 'history',
													index : 'history',
													width : 70,
													align : "center",
													classes : "handcursor",
													hidden : true
												}, {
													name : 'enable_flag_changed',
													index : 'enable_flag_changed',
													width : 25,
													hidden : true
												}, {
													name : 'oper',
													index : 'oper',
													width : 25,
													hidden : true
												}, {
													name : 'weight',
													index : 'weight',
													width : 25,
													hidden : true
												}, {
													name : 'attr1',
													index : 'attr1',
													width : 25,
													hidden : true
												}, {
													name : 'attr2',
													index : 'attr2',
													width : 25,
													hidden : true
												}, {
													name : 'attr3',
													index : 'attr3',
													width : 25,
													hidden : true
												}, {
													name : 'attr4',
													index : 'attr4',
													width : 25,
													hidden : true
												}, {
													name : 'attr5',
													index : 'attr5',
													width : 25,
													hidden : true
												}, {
													name : 'attr6',
													index : 'attr6',
													width : 25,
													hidden : true
												}, {
													name : 'attr7',
													index : 'attr7',
													width : 25,
													hidden : true
												}, {
													name : 'attr8',
													index : 'attr8',
													width : 25,
													hidden : true
												}, {
													name : 'attr9',
													index : 'attr9',
													width : 25,
													hidden : true
												}, {
													name : 'attr10',
													index : 'attr10',
													width : 25,
													hidden : true
												}, {
													name : 'attr11',
													index : 'attr11',
													width : 25,
													hidden : true
												}, {
													name : 'attr12',
													index : 'attr12',
													width : 25,
													hidden : true
												}, {
													name : 'attr13',
													index : 'attr13',
													width : 25,
													hidden : true
												}, {
													name : 'attr14',
													index : 'attr14',
													width : 25,
													hidden : true
												}, {
													name : 'attr15',
													index : 'attr15',
													width : 25,
													hidden : true
												}, {
													name : 'attr1_code',
													index : 'attr1_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr2_code',
													index : 'attr2_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr3_code',
													index : 'attr3_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr4_code',
													index : 'attr4_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr5_code',
													index : 'attr5_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr6_code',
													index : 'attr6_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr7_code',
													index : 'attr7_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr8_code',
													index : 'attr8_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr9_code',
													index : 'attr9_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr10_code',
													index : 'attr10_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr11_code',
													index : 'attr11_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr12_code',
													index : 'attr12_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr13_code',
													index : 'attr13_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr14_code',
													index : 'attr14_code',
													width : 25,
													hidden : true
												}, {
													name : 'attr15_code',
													index : 'attr15_code',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr1',
													index : 'add_attr1',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr2',
													index : 'add_attr2',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr3',
													index : 'add_attr3',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr4',
													index : 'add_attr4',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr5',
													index : 'add_attr5',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr6',
													index : 'add_attr6',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr7',
													index : 'add_attr7',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr8',
													index : 'add_attr8',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr9',
													index : 'add_attr9',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr10',
													index : 'add_attr10',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr11',
													index : 'add_attr11',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr12',
													index : 'add_attr12',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr13',
													index : 'add_attr13',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr14',
													index : 'add_attr14',
													width : 25,
													hidden : true
												}, {
													name : 'add_attr15',
													index : 'add_attr15',
													width : 25,
													hidden : true
												}, {
													name : 'bom1',
													index : 'bom1',
													width : 25,
													hidden : true
												}, {
													name : 'bom2',
													index : 'bom2',
													width : 25,
													hidden : true
												}, {
													name : 'bom3',
													index : 'bom3',
													width : 25,
													hidden : true
												}, {
													name : 'bom4',
													index : 'bom4',
													width : 25,
													hidden : true
												}, {
													name : 'bom5',
													index : 'bom5',
													width : 25,
													hidden : true
												}, {
													name : 'bom6',
													index : 'bom6',
													width : 25,
													hidden : true
												}, {
													name : 'bom7',
													index : 'bom7',
													width : 25,
													hidden : true
												}, {
													name : 'bom8',
													index : 'bom8',
													width : 25,
													hidden : true
												}, {
													name : 'bom9',
													index : 'bom9',
													width : 25,
													hidden : true
												}, {
													name : 'bom10',
													index : 'bom10',
													width : 25,
													hidden : true
												}, {
													name : 'bom11',
													index : 'bom11',
													width : 25,
													hidden : true
												}, {
													name : 'bom12',
													index : 'bom12',
													width : 25,
													hidden : true
												}, {
													name : 'bom13',
													index : 'bom13',
													width : 25,
													hidden : true
												}, {
													name : 'bom14',
													index : 'bom14',
													width : 25,
													hidden : true
												}, {
													name : 'bom15',
													index : 'bom15',
													width : 25,
													hidden : true
												}, {
													name : 'states_flag',
													index : 'states_flag',
													width : 25,
													hidden : true
												}, {
													name : 'findnumber',
													index : 'findnumber',
													width : 30,
													align : "right",
													hidden : true
												} ],
												gridview : true,
												cmTemplate : {
													title : false
												},
												toolbar : [ false, "bottom" ],
												viewrecords : true,
												caption : "SELECTED CODE 자품목 LIST",
												hidegrid : false,
												autowidth : true,
												height : objectHeight - 22,
												//shrinkToFit : false,
												rowNum : -1,
												rownumbers : true,
												emptyrecords : '데이터가 존재하지 않습니다.',
												pager : jQuery('#pbomList1'),
												cellEdit : true, // grid edit mode 1
												cellsubmit : 'clientArray', // grid edit mode 2
												beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
													idRow = rowid;
													idCol = iCol;
													kRow = iRow;
													kCol = iCol;
												},
												beforeSaveCell : chmResultEditEnd,
												jsonReader : {
													id : "rows>id",
													//row : "rows",
													page : "page>page",
													total : "page>total",
													records : "max",
													repeatitems : false
												//root : "page"
												},
												imgpath : 'themes/basic/images',
												onCellSelect : function(rowid, iCol, cellcontent, e) {
													var cm = $(this).jqGrid("getGridParam", "colModel");
													var colName = cm[iCol];
													var item = $(this).jqGrid("getRowData", rowid);
													if (rowid != null) {
														if (item.oper != "") {
															if (colName['index'] == "item_catalog") {
																if (item.oper == 'D') {
																	return;
																}
																fn_popup_catalog_search("OUT2", "G", rowid);
															}
														}

														if (colName['index'] == "item_code") {
															if (item.item_catalog == "") {
																alert("CATALOG를 선택 바랍니다.");
																fn_popup_catalog_search("OUT2", "G", rowid);
																return;
															}
														}
														if (colName['index'] == "item_attr") {
															if (item.item_catalog == "") {
																alert("CATALOG를 선택 바랍니다.");
																fn_popup_catalog_search("OUT2", "G", rowid);
																return;
															}
															var param = new Array();
															if (item.oper == 'I' && item.item_code == "") {
																// ITEM CODE가 신규생성이고  없는경우
																param[0] = "NEW";
															} else {
																param[0] = item.item_code;
															}

															param[1] = item.item_catalog;
															var rs = window.showModalDialog("popUpItemDetail.do?p_item_code="+item.item_code+"&p_item_catalog="+item.item_catalog, param,
																			"dialogWidth:800px; dialogHeight:810px; center:on; scroll:off; status:off");
															
															/* var sURL = "popUpItemDetail.do?p_item_code="+item.item_code+"&p_item_catalog="+item.item_catalog;
															var popOptions = "width=500, height=590, resizable=no, scrollbars=no, status=no";
															var popupWin = window.open(sURL, "popUpItemDetail", popOptions);
															setTimeout(function(){
																popupWin.focus();
															 }, 100); */
															
															
															if (rs != null) {
																var item = $('#bomList1').jqGrid('getRowData', rowid);
																$("#bomList1").setRowData(rowid, {
																	attr1 : rs["01"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr2 : rs["02"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr3 : rs["03"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr4 : rs["04"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr5 : rs["05"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr6 : rs["06"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr7 : rs["07"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr8 : rs["08"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr9 : rs["09"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr10 : rs["10"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr11 : rs["11"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr12 : rs["12"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr13 : rs["13"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr14 : rs["14"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr15 : rs["15"]
																});

																$("#bomList1").setRowData(rowid, {
																	attr1_code : rs["01_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr2_code : rs["02_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr3_code : rs["03_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr4_code : rs["04_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr5_code : rs["05_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr6_code : rs["06_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr7_code : rs["07_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr8_code : rs["08_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr9_code : rs["09_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr10_code : rs["10_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr11_code : rs["11_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr12_code : rs["12_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr13_code : rs["13_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr14_code : rs["14_code"]
																});
																$("#bomList1").setRowData(rowid, {
																	attr15_code : rs["15_code"]
																});

																$("#bomList1").setRowData(rowid, {
																	add_attr1 : rs["add_01"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr2 : rs["add_02"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr3 : rs["add_03"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr4 : rs["add_04"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr5 : rs["add_05"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr6 : rs["add_06"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr7 : rs["add_07"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr8 : rs["add_08"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr9 : rs["add_09"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr10 : rs["add_10"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr11 : rs["add_11"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr12 : rs["add_12"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr13 : rs["add_13"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr14 : rs["add_14"]
																});
																$("#bomList1").setRowData(rowid, {
																	add_attr15 : rs["add_15"]
																});
																$("#bomList1").setRowData(rowid, {
																	weight : rs["weight"]
																});

																$("#bomList1").setRowData(rowid, {
																	item_attr : '입력 완료'
																});
																$('#bomList1').jqGrid('setCell', rowid, 'item_attr',
																		'', {
																			background : '#FF7E9D'
																		});
															}
														}

														if (colName['index'] == "bom_attr") {
															if (item.oper == 'D') {
																alert("삭제된 데이타는 변경 불가능합니다.");
																return;
															}
															if (item.item_catalog == "") {
																alert("CATALOG를 선택 바랍니다.");
																fn_popup_catalog_search("OUT2", "G", rowid);
																return;
															}
															var param = new Array();
															if (item.oper == 'I') {
																param[0] = "NEW";
															} else {
																param[0] = item.item_code;
																if (item.bom_attr == "보기") {
																	param[3] = "VIEW"
																}
															}

															param[1] = item.mother_code;
															param[2] = item.item_catalog;
															param[4] = $("#p_project_no").val();
															var rs = window
																	.showModalDialog("popUpBomItemDetail.do", param,
																			"dialogWidth:500px; dialogHeight:550px; center:on; scroll:off; status:off");
															if (rs != null) {
																var item = $('#bomList1').jqGrid('getRowData', rowid);
																$("#bomList1").setRowData(rowid, {
																	bom1 : rs[0]
																});
																$("#bomList1").setRowData(rowid, {
																	bom2 : rs[1]
																});
																$("#bomList1").setRowData(rowid, {
																	bom3 : rs[2]
																});
																$("#bomList1").setRowData(rowid, {
																	bom4 : rs[3]
																});
																$("#bomList1").setRowData(rowid, {
																	bom5 : rs[4]
																});
																$("#bomList1").setRowData(rowid, {
																	bom6 : rs[5]
																});
																$("#bomList1").setRowData(rowid, {
																	bom7 : rs[6]
																});
																$("#bomList1").setRowData(rowid, {
																	bom8 : rs[7]
																});
																$("#bomList1").setRowData(rowid, {
																	bom9 : rs[8]
																});
																$("#bomList1").setRowData(rowid, {
																	bom10 : rs[9]
																});
																$("#bomList1").setRowData(rowid, {
																	bom11 : rs[10]
																});
																$("#bomList1").setRowData(rowid, {
																	bom12 : rs[11]
																});
																$("#bomList1").setRowData(rowid, {
																	bom13 : rs[12]
																});
																$("#bomList1").setRowData(rowid, {
																	bom14 : rs[13]
																});
																$("#bomList1").setRowData(rowid, {
																	bom15 : rs[14]
																});
																$("#bomList1").setRowData(rowid, {
																	qty : rs[15]
																});

																if (item.oper == 'I') {
																	$("#bomList1").setRowData(rowid, {
																		bom_attr : '입력 완료'
																	});
																} else {
																	$("#bomList1").setRowData(rowid, {
																		oper : "U"
																	});
																	$("#bomList1").setRowData(rowid, {
																		bom_attr : '편집 완료'
																	});
																	$("#bomList1").setRowData(rowid, {
																		states_flag_desc : "변경"
																	});
																	setSaveButtonEnabled();
																}
																$('#bomList1').jqGrid('setCell', rowid, 'bom_attr', '',
																		{
																			background : '#FF7E9D'
																		});
															}
														}

														if (colName['index'] == "history") {
															window
																	.showModalDialog(
																			"popUpBomItemHistory.do?project_no="
																					+ $("#p_project_no").val()
																					+ "&mother_code="
																					+ item.mother_code + "&item_code="
																					+ item.item_code, window,
																			"dialogWidth:800px; dialogHeight:600px; center:on; scroll:off; status:off");
														}
													}
												},
												gridComplete : function() {
													var rows = $("#bomList1").getDataIDs();
													for (var i = 0; i < rows.length; i++) {
														//수정 및 결재 가능한 리스트 색상 변경
														var oper = $("#bomList1").getCell(rows[i], "oper");
														if (oper == "I") {
															$("#bomList1").jqGrid('setCell', rows[i], 'item_catalog',
																	'', {
																		cursor : 'pointer',
																		background : 'pink'
																	});
															$("#bomList1").jqGrid('setCell', rows[i], 'item_code', '',
																	{
																		cursor : 'pointer',
																		background : 'pink'
																	});
														} else {
															$("#bomList1").jqGrid('setCell', rows[i], 'item_code', '',
																	'not-editable-cell');
															$("#bomList1").jqGrid('setCell', rows[i], 'item_desc', '',
																	'not-editable-cell');
														}
														$("#bomList1").jqGrid('setCell', rows[i], 'dwg_no', '', {
															cursor : 'pointer',
															background : 'pink'
														});
													}
													$("#bomList1 td:contains('보기')").css("background", "#ffff80").css(
															"cursor", "pointer");
													$("#bomList1 td:contains('편집')").css("background", "pink").css(
															"cursor", "pointer");
													$("#bomList1 td:contains('입력')").css("background", "pink").css(
															"cursor", "pointer");
													$("#bomList1 td:contains('삭제')").css("background", "#FF7E9D");
												},
												afterInsertRow : function(rowid, rowdata, rowelem) {
													jQuery("#" + rowid).css("background", "#0AC9FF");
												},
												afterSaveCell : function(id, name, val, iRow, iCol) {
													if (name == "item_code") {
														var item_code = $("#bomList1").getCell(id, "item_code");
														var item_catalog = $("#bomList1").getCell(id, "item_catalog");

														var formData = {
															item_code : item_code,
															item_catalog : item_catalog
														};

														$.post("searchItemList.do", formData, function(data) {
															if (data.records != '1') {
																alert("입력된 CATALOG에 해당하는 ITEM CODE가 존재 하지 않습니다.");
																$("#bomList1").setRowData(id, {
																	item_code : ""
																});
															}
														}, "json").error(function() {
															alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
														});
													}
												}
											});

							$("#treegrid2").jqGrid(
									{
										url : '',
										treedatatype : "json",
										mtype : "",
										postData : fn_getFormData("#application_form"),
										colNames : [ 'LV', 'RLV', 'ITEM CODE', 'MOTHER CODE', 'BOM TYPE', 'CATALOG',
												'DESCRIPTION', 'UOM', 'QTY', 'DWG No', 'Creator', 'ECO NO',
												'ECO Creator', 'Item 속성', 'BOM 속성', 'History', 'LEAF', 'FOLD', 'BOM10',
												'BOM11', "상태", '현황', 'select ID' ],
										colModel : [ {
											name : 'lev',
											index : 'lev',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'rlev',
											index : 'rlev',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'item_code',
											index : 'item_code',
											width : 400,
											align : "left",
											sortable : false
										}, {
											name : 'mother_code',
											index : 'mother_code',
											width : 100,
											align : "left",
											hidden : true,
											sortable : false
										}, {
											name : 'bom_type',
											index : 'bom_type',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'item_catalog',
											index : 'item_catalog',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'item_desc',
											index : 'item_desc',
											width : 255,
											align : "left",
											hidden : true
										}, {
											name : 'uom',
											index : 'uom',
											width : 40,
											align : "center",
											hidden : true
										}, {
											name : 'qty',
											index : 'qty',
											width : 40,
											align : "right",
											hidden : true
										}, {
											name : 'dwg_no',
											index : 'dwg_no',
											width : 80,
											align : "center",
											editable : true,
											hidden : true
										}, {
											name : 'emp_no',
											index : 'emp_no',
											width : 150,
											align : "center",
											hidden : true
										}, {
											name : 'eco_no',
											index : 'eco_no',
											width : 80,
											align : "center",
											hidden : true
										}, {
											name : 'created_by',
											index : 'created_by',
											width : 150,
											align : "center",
											hidden : true
										}, {
											name : 'item_attr',
											index : 'item_attr',
											width : 70,
											align : "center",
											classes : "handcursor",
											hidden : true
										}, {
											name : 'bom_attr',
											index : 'bom_attr',
											width : 70,
											align : "center",
											classes : "handcursor",
											hidden : true
										}, {
											name : 'history',
											index : 'history',
											width : 70,
											align : "center",
											classes : "handcursor",
											hidden : true
										}, {
											name : 'leaf',
											index : 'leaf',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'fold',
											index : 'fold',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'bom10',
											index : 'bom10',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'bom11',
											index : 'bom11',
											width : 80,
											align : "left",
											hidden : true
										}, {
											name : 'item_states_desc',
											index : 'item_states_desc',
											width : 100,
											align : "left",
											hidden : true
										}, {
											name : 'states_flag_desc',
											index : 'states_flag_desc',
											width : 40,
											align : "center",
											hidden : true
										}, {
											name : 'select_id',
											index : 'select_id',
											width : 40,
											align : "center",
											hidden : true,
											key : true
										} ],
										autowidth : true,
										cmTemplate : {
											title : false
										},
										treeGridModel : 'adjacency',
										height : objectHeight + 25,
										treeGrid : true,
										ExpandColumn : 'item_code',
										jsonReader : {
											repeatitems : false,
											id : "lev",
											page : function(obj) {
												return 1;
											},
											total : function(obj) {
												return 1;
											},
										},
										treeReader : {
											level_field : "lev",
											parent_id_field : "mother_code",
											leaf_field : "leaf",
											expanded_field : "fold"
										},
										onCellSelect : function(rowid, iCol, cellcontent, e) {
											var cm = $("#treegrid2").jqGrid("getGridParam", "colModel");
											var colName = cm[iCol];
											var item = $("#treegrid2").jqGrid("getRowData", rowid);
											if (item.states_flag_desc == "BOM"
													|| $("#selectMotherCode").html() == "PROJECT"
													|| item.bom_type == "PAINT_USC") {
												setButtonEnabled();
												setSaveButtonDisabled();
												setCreateButtonDisabled();
												fn_buttonDisabled([ "#btnAddSSC" ]);
											} else if (item.bom_type == "PAINT_JOB") {
												setButtonDisabled();
												setSaveButtonDisabled();
												setCreateButtonDisabled();
												fn_buttonEnable([ "#btnAddSSC" ]);
											} else {
												setButtonDisabled();
												setSaveButtonDisabled();
												setCreateButtonDisabled();
												fn_buttonDisabled([ "#btnAddSSC" ]);
											}
											/* if(item.states_flag_desc == "BOM" || $("#selectMotherCode").html() =="PROJECT"){
												setButtonEnabled();
												setSaveButtonDisabled();
												setCreateButtonDisabled();
											} */
											if (colName['index'] == "item_code") {
												$("#selectMotherCode").html(item.mother_code);
												$("#selectItemCode").html(item.item_code);
												$("#selectDescription").html(item.item_desc);
												$("#selectStatesFlag").html(item.states_flag_desc);

												if (item.states_flag_desc != "BOM") {
													$("#p_selectProjectNo").val(item.states_flag_desc.split("-")[0]);
													$("#selectProjectNo").html(item.states_flag_desc.split("-")[0]);
													$("#selectStatesFlag").html(item.states_flag_desc.split("-")[1]);
												} else {
													$("#selectProjectNo").html("-");
													$("#selectStatesFlag").html(item.states_flag_desc);
												}

												$("#selectBomType").html(item.bom_type);
												$("#selectCatalog").html(item.item_catalog);
												/* $("#selectStatus").html(item.item_states_desc); */
												$("#selectUom").html(item.uom);
												$("#selectQty").html(item.qty);
												$("#selectEcoNo").html(item.eco_no);
												$("#selectEcoCreater").html(item.created_by);

												var mother_code = item.mother_code;
												var item_code = item.item_code;
												var rlev = item.rlev;

												$("#p_item_states_desc").val(item.item_states_desc);
												//$("#p_item_code").val(item_code);
												$("#nodeid").val(item_code);
												$("#motherCode").val(mother_code);
												$("#n_level").val(rlev);
												$("#item_bom_type").val(item.bom_type);

												/* $( "#tabs" ).tabs( "option", "active",  0);
												
												fn_search();
												loadingBox = new ajaxLoader($('#treegrid1'), {
													classOveride : 'blue-loader',
													bgColor : '#000',
													opacity : '0.3'
												}); */
												//var sUrl = "selectBomList.do?n_level="+rlev+"&mother_code="+mother_code+"&nodeid="+item_code;
												var sUrl = "infoBomTree.do";
												$("#bomList1").jqGrid("clearGridData");
												$("#bomList1").jqGrid('setGridParam', {
													url : sUrl,
													mtype : "POST",
													datatype : 'json',
													page : 1,
													postData : fn_getFormData("#application_form")
												}).trigger("reloadGrid");

												if (item.states_flag_desc == "BOM"
														|| $("#selectMotherCode").html() == "PROJECT"
														|| item.bom_type == "PAINT_USC") {
													setButtonEnabled();
													setSaveButtonDisabled();
													setCreateButtonDisabled();
													fn_buttonDisabled([ "#btnAddSSC" ]);
												} else if (item.bom_type == "PAINT_JOB") {
													setButtonDisabled();
													setSaveButtonDisabled();
													setCreateButtonDisabled();
													fn_buttonEnable([ "#btnAddSSC" ]);
												} else {
													setButtonDisabled();
													setSaveButtonDisabled();
													setCreateButtonDisabled();
													fn_buttonDisabled([ "#btnAddSSC" ]);
												}

												$("#item_bom_type").val(item.bom_type);
												$("#item_catalog").val(item.item_catalog);
												$("#p_bom10").val(item.bom10);
												$("#p_bom11").val(item.bom11);

											}
										}
									});

							fn_grid_init();

							//정전개 펼치기
							$("#iconExpand").bind("click", function() {

								var src, stuts;
								if ($(this).attr("src") === "/images/tree/bom_plus1.png") {
									src = "/images/tree/bom_minus1.png";
									stuts = "plus";
								} else {
									src = "/images/tree/bom_plus1.png";
									stuts = "minus";
								}
								$(this).attr("src", src);

								if (stuts == "minus") {
									$(".treeclick", "#treegrid1").each(function() {
										if ($(this).hasClass("tree-minus")) {
											$(this).trigger("click");
										}
									});
								} else {
									$(".treeclick", "#treegrid1").each(function() {
										if ($(this).hasClass("tree-plus")) {
											$(this).trigger("click");
										}
									});
								}

							});

							$("#btn_project_no")
									.click(
											function() {

												var rs = window
														.showModalDialog(
																"popUpProjectNo.do?p_delegate_project_no=none", window,
																"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off");

												if (rs != null) {
													$("#p_project_no").val(rs[0]);
													$("#btnSelect").click();
												} else {
													$("#p_project_no").val('');
												}
											});

							$("#btnManageSpecificStructure")
									.click(
											function() {

												var rowid = $('#bomList1').jqGrid('getGridParam', 'selrow');
												var item = $('#bomList1').jqGrid('getRowData', rowid);

												/* if (!fn_require_chk()) {
													return;
												} */

												var rs = window
														.showModalDialog(
																"popUpManageSpecificStructure.do?sd_type=SPST_SHIP_TYPE",
																window,
																"dialogWidth:1300px; dialogHeight:680px; center:on; scroll:off; states:off");
											});

							$("#btnDelItem").click(function() {
								$('#bomList1').saveCell(kRow, kCol);

								var selrow = $('#bomList1').jqGrid('getGridParam', 'selrow');
								if (selrow != null) {
									var item = $('#bomList1').jqGrid('getRowData', selrow);

									if (item.oper == 'I') {
										$('#bomList1').jqGrid('delRowData', selrow);
									} else {
										item.oper = 'D';
										item.states_flag_desc = '삭제';

										$('#bomList1').jqGrid("setRowData", selrow, item);

										var colModel = $('#bomList1').jqGrid('getGridParam', 'colModel');
										for ( var i in colModel) {
											$('#bomList1').jqGrid('setCell', selrow, colModel[i].name, '', {
												background : '#FF7E9D'
											});
										}
										setSaveButtonEnabled();
									}
									var changedData = $.grep($("#bomList1").jqGrid('getRowData'), function(obj) {
										return obj.oper == 'D';
									});
									if (changedData.length == 0) {
										setCreateButtonDisabled();
									}
									$('#bomList1').resetSelection();
								}
							});
							//Add 버튼 
							$("#btnAddSSC")
									.click(
											function() {
												var arg = "&p_item_type_cd=PA&p_dwg_no=M2020000&p_project_no="
														+ $("#p_project_no").val() + "&p_job_cd="
														+ $("#selectItemCode").html();
												var rs = window
														.open("sscAddMain.do?menu_id=${menu_id}&up_link=bom&newWin=Y"
																+ arg, "",
																"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");
											});
							//Add 버튼 
							$("#btnAddItem").click(function() {
								$('#bomList1').saveCell(kRow, kCol);
								var item_new = {};
								var colModel = $('#bomList1').jqGrid('getGridParam', 'colModel');

								for ( var i in colModel)
									item_new[colModel[i].name] = '';

								item_new.oper = 'I';
								item_new.enable_flag = 'Y';
								item_new.mother_code = $("#selectItemCode").html();
								item_new.bom_type = $("#selectBomType").html();
								item_new.uom = $("#selectUom").html();
								item_new.qty = $("#selectQty").html();
								item_new.states_flag = 'A';
								item_new.states_flag_desc = '추가';
								item_new.item_attr = '입력';
								item_new.bom_attr = '입력';
								item_new.job_catalog_popup = '...';
								item_new.dwg_no_popup = '...';

								$('#bomList1').resetSelection();
								//$('#bomList1').jqGrid('addRowData', $.jgrid.randId(), item_new, 'after', selrow);
								$('#bomList1').jqGrid('addRowData', $.jgrid.randId(), item_new, 'first');

								setCreateButtonEnabled();
							});

							//히스토리 버튼
							$("#btnHistory")
									.click(
											function() {
												window
														.showModalDialog("popUpBomItemHistory.do?project_no="
																+ $("#p_project_no").val() + "&mother_code="
																+ $("#selectMotherCode").html() + "&item_code="
																+ $("#selectItemCode").html(), window,
																"dialogWidth:800px; dialogHeight:600px; center:on; scroll:off; status:off");
											});
							//조회 버튼
							$("#btnSelect")
									.click(
											function() {
												if (!uniqeValidation()) {
													return;
												}

												var args = "?p_project_no=" + $('#p_project_no').val()
														+ "&p_mother_code=" + $('#p_mother_code').val()
														+ "&p_item_desc=" + $('#p_item_desc').val() + "&p_item_code="
														+ $('#p_item_code').val() + "&p_item_catalog="
														+ $('#p_item_catalog').val() + "&p_emp_no="
														+ escape(encodeURIComponent($('#p_emp_no').val()))
														+ "&p_item_attr1=" + $('#p_item_attr1').val()
														+ "&p_item_attr2=" + $('#p_item_attr2').val()
														+ "&p_item_attr3=" + $('#p_item_attr3').val() + "&p_eco_no="
														+ $('#p_eco_no').val() + "&p_eco_emp_no="
														+ escape(encodeURIComponent($('#p_eco_emp_no').val()));
												//var rs = window.showModalDialog("popUpSearchItem.do"+args, "", "dialogWidth:750px; dialogHeight:700px; center:on; scroll:off; status:off");

												var sURL = "popUpSearchItem.do" + args;
												var popOptions = "width=750, height=700, resizable=yes, scrollbars=no, status=no";

												var popupWin = window.open(sURL, "popUpSearchItem", popOptions);

												setTimeout(function() {
													rs = popupWin.focus();
												}, 500);

												/* var rs = new Array();
												if(returnValue != null || returnValue != "") {
													rs = $("#returnValue").val().split(",");
												}
												
												if (rs != null) {
													$("#selectMotherCode").html(rs[0]);
													$("#selectItemCode").html(rs[1]);
													$("#selectDescription").html(rs[2]);
													
													if(rs[3] != "BOM"){
														$("#p_selectProjectNo").val(rs[3].split("-")[0]);
														$("#selectProjectNo").html(rs[3].split("-")[0]);
														$("#selectStatesFlag").html(rs[3].split("-")[1]);
													} else {
														$("#selectProjectNo").html("-");
														$("#selectStatesFlag").html(rs[3]);	
													}
													
													
													$("#selectBomType").html(rs[4]);
													//$("#selectStatus").html(rs[5]);
													$("#selectCatalog").html(rs[6]);
													$("#selectUom").html(rs[7]);
													$("#selectQty").html(rs[8]);
													$("#selectEcoNo").html(rs[9]);
													$("#selectEcoCreater").html(rs[10]);
													fn_search();
												} */

											});

							//조회 버튼
							$("#btnSelect2").click(function() {
								setButtonDisabled();
								setSaveButtonDisabled();
								setCreateButtonDisabled();
								fn_buttonDisabled([ "#btnAddSSC" ]);
								if ($("#p_item_code2").val() == "") {
									alert("ITEM CODE를 입력해 주세요.");
									$("#p_item_code2").focus();
									return;
								}

								var sUrl = "infoBomReverseTree.do";

								$("#treegrid2").jqGrid("clearGridData");
								$("#treegrid2").jqGrid('setGridParam', {
									url : sUrl,
									mtype : "POST",
									datatype : 'json',
									page : 1,
									postData : fn_getFormData("#application_form")
								}).trigger("reloadGrid");

								//$("#bomList2").jqGrid("clearGridData");
							});

							$("#btnSave").click(function() {
								fn_save();
							});

							//원인코드
							$("#btnEcoReasonCode")
									.click(
											function() {
												var rs = window
														.showModalDialog("popUpCause.do", window,
																"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off");
												if (rs != null) {
													$("#p_eco_reason_code").val(rs[0]);
													$("#p_eco_reason_desc").val(rs[0]);
												}
											});

							//ECO 검색팝업
							$("#btnEcoCode")
									.click(
											function() {
												var rs = window
														.showModalDialog(
																"popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
																window,
																"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off");

												if (rs != null) {
													$("#p_eco_no").val(rs[0]);
													/* $( "#p_eng_change_order_code" ).val( rs[1] ); */
													//$( "#eco_states_desc" ).val( rs[2] );
												}
											});

							/* //ECO 생성
							$("#btnCreateECO").click(function() {
								fn_dwg_eco_create();
							}); */

							/* fn_register(); */

							//사번 조회 팝업... 버튼
							$("#btnEmpNo")
									.click(
											function() {
												var rs = window
														.showModalDialog(
																"popUpEmpNoAndRegiter.do?register_type=RME&main_type=ECO",
																window,
																"dialogWidth:600px; dialogHeight:460px; center:on; scroll:off; status:off");

												if (rs != null) {
													$("#p_created_by").val(rs[0]);
													$("#p_created_by_name").val(rs[2]);
													$("#p_user_group_name").val(rs[4]);
												}
											});

							//채번 및 BOM 생성
							$("#btnCreateBOM").click(function() {
								if (fn_bom_create_check()) {
									fn_bom_create();
								}
							});

							setButtonDisabled();

							setSaveButtonDisabled();

							setCreateButtonDisabled();

							fn_buttonDisabled([ "#btnAddSSC" ]);

							$("#btn_popup_dwg_dept")
									.click(
											function() {
												var rs = window
														.showModalDialog("popUpDpsDept.do", window,
																"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");

												if (rs != null) {
													$("#p_dwg_dept_code").val(rs[0]);
													$("#p_dwg_dept_name").val(rs[1]);
													$("#p_job_dept_code").val(rs[2]);
												}

											});
							$("#btnShipType")
									.click(
											function() {
												var rs = window
														.showModalDialog("popUpModelShipType.do", window,
																"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off");

												if (rs != null) {
													$("#p_ship_type").val(rs[0]);
												}
											});
							//ECO 추가
							$("#btnCreateEco")
									.click(
											function() {
												var dialog = $('<p>ECO를 연결합니다.</p>')
														.dialog(
																{
																	buttons : {
																		"조회" : function() {
																			var rs = window
																					.showModalDialog(
																							"popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
																							window,
																							"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off");

																			if (rs != null) {
																				$("#p_eng_change_order_code")
																						.val(rs[0]);
																			}

																			dialog.dialog('close');
																		},
																		"생성" : function() {

																			
																			//메뉴ID를 가져오는 공통함수 
																			getMenuId("eco.do", callback_MenuId);
																			
																			var sUrl = "eco.do?popupDiv=bomAddEco&popup_type=PAINT&menu_id=" + menuId;

																			var rs = window
																					.showModalDialog(sUrl, window,
																							"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");
																			if (rs != null) {
																				$("#p_eng_change_order_code")
																						.val(rs[0]);
																			}
																			dialog.dialog('close');
																		},
																		"Cancel" : function() {
																			dialog.dialog('close');
																		}
																	}
																});
											});
							window.onload = function() {
								if ("${item_code}" != '') {
									if ("${project_no}" != '') {
										$("#btnSelect").click();
									}
								}
							}

						}); //end of ready Function 

		function changeTab(selected) {
			selectedTab = selected;
			fn_search();
		};
		function fn_require_chk() {
			var result = false;
			var message = "";

			if ($('#p_mother_code').val() != '') {
				return true;
			}
			if ($('#p_item_code').val() != '') {
				return true;
			}
			if ($('#p_item_catalog').val() != '') {
				return true;
			}
			if ($('#p_emp_no').val() != '') {
				return true;
			}
			if ($('#p_item_attr1').val() != '') {
				return true;
			}
			if ($('#p_item_attr2').val() != '') {
				return true;
			}
			if ($('#p_item_attr3').val() != '') {
				return true;
			}
			if ($('#p_eco_no').val() != '') {
				return true;
			}
			if ($('#p_eco_emp_no').val() != '') {
				return true;
			}
			if ($('#p_project_no').val() != '') {

				$("#selectMotherCode").html('PROJECT');
				$("#selectDescription").html();
				$("#selectStatesFlag").html();
				$("#selectProjectNo").html();
				$("#selectBomType").html();
				/* $("#selectStatus").html(); */
				$("#selectCatalog").html();
				$("#selectUom").html();
				$("#selectQty").html();
				$("#selectEcoNo").html();
				$("#selectEcoCreater").html();
				$("#selectItemCode").html($('#p_project_no').val());
				fn_search();
				return false;
			}

			if (!result) {
				alert("조회 조건을 최소 1개 이상 지정바랍니다.");
			}

			return result;
		}

		//필수 항목 Validation
		var uniqeValidation = function() {
			var rnt = true;
			$(".required").each(function() {
				if ($(this).val() == "") {
					$(this).focus();
					alert($(this).attr("alt") + "가 누락되었습니다.");
					rnt = false;
					return false;
				}
			});
			return rnt;
		}

		function fn_search() {

			setButtonDisabled();
			setSaveButtonDisabled();
			setCreateButtonDisabled();
			fn_buttonDisabled([ "#btnAddSSC" ]);
			$("#nodeid").val($("#selectItemCode").html());
			$("#motherCode").val($("#selectMotherCode").html());
			$("#n_level").val("");

			$("#p_selectMotherCode").val($("#selectMotherCode").html());
			$("#p_selectDescription").val($("#selectDescription").html());
			if ($("#selectStatesFlag").html() == "BOM") {
				$("#p_selectStatesFlag").val($("#selectStatesFlag").html());
			} else {
				$("#p_selectStatesFlag").val($("#selectProjectNo").html() + "-" + $("#selectStatesFlag").html());
			}

			$("#p_selectBomType").val($("#selectBomType").html());
			/* $("#p_selectStatus").val($("#selectStatus").html()); */
			$("#p_selectCatalog").val($("#selectCatalog").html());
			$("#p_selectUom").val($("#selectUom").html());
			$("#p_selectQty").val($("#selectQty").html());
			$("#p_selectEcoNo").val($("#selectEcoNo").html());
			$("#p_selectEcoCreater").val($("#selectEcoCreater").html());

			if (selectedTab == '2') {
				var sUrl = "infoBomReverseTree.do";
				$("#treegrid2").jqGrid("clearGridData");
				$("#treegrid2").jqGrid('setGridParam', {
					url : sUrl,
					mtype : "POST",
					datatype : 'json',
					page : 1,
					postData : fn_getFormData("#application_form")
				}).trigger("reloadGrid");

				$("#bomList2").jqGrid("clearGridData");

				$("#iconExpand").hide();
			} else {
				var sUrl = "infoBomTree.do";
				$("#treegrid1").jqGrid("clearGridData");
				$("#treegrid1").jqGrid('setGridParam', {
					url : sUrl,
					mtype : "POST",
					datatype : 'json',
					page : 1,
					postData : fn_getFormData("#application_form")
				}).trigger("reloadGrid");

				$("#bomList1").jqGrid("clearGridData");
				$("#iconExpand").show();
				$("#iconExpand").attr("src", "/images/tree/bom_plus1.png");
			}
		}

		function fn_search2() {
			setButtonDisabled();
			setSaveButtonDisabled();
			setCreateButtonDisabled();
			fn_buttonDisabled([ "#btnAddSSC" ]);
			var sUrl = "infoBomReverseTree.do";

			$("#treegrid2").jqGrid("clearGridData");
			$("#treegrid2").jqGrid('setGridParam', {
				url : sUrl,
				mtype : "POST",
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");

			//$("#bomList2").jqGrid("clearGridData");
		}

		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#bomList1').jqGrid('getRowData', irowId);

			if (item.oper != 'I') {
				item.oper = 'U';
				item.states_flag_desc = '변경';
				$('#bomList1').jqGrid("setRowData", irowId, item);
				$("input.editable,select.editable", this).attr("editable", "0");
				setSaveButtonEnabled();
			}
		}

		function fn_grid_init() {
			fn_insideGridresize($(window), $("#tabs"), $("#treegrid1"), 112);
			fn_insideGridresize($(window), $("#tabs"), $("#treegrid2"), 112);
			fn_insideGridresize($(window), $("#divBomList1"), $("#bomList1"), 131);

			//$("#divBomList1P").css("left", $("#divBomList1").width()+2);

		}

		//design engineer 등 가져오기
		function fn_register() {
			var url = 'infoEmpNoRegisterList.do';
			// 			var formData = fn_getFormData( '#application_form' );
			var formData = {
				states_type : "ECO",
				register_type : "RME"
			};
			$.post(url, formData, function(data) {
				$("#p_created_by").val(data[0].sub_emp_no);
				$("#p_created_by_name").val(data[0].user_nm);
				$("#p_user_group_name").val(data[0].dept_name);
			}, "json");
		}

		function fn_bom_create_check() {
			$("#bomList1").saveCell(kRow, kCol);
			var ids = $("#bomList1").jqGrid('getDataIDs');
			for (var i = 0; i < ids.length; i++) {
				var oper = $("#bomList1").jqGrid('getCell', ids[i], 'oper');
				var itemCode = $("#bomList1").jqGrid('getCell', ids[i], 'item_code');
				if (oper == 'I') {
					var val1 = $("#bomList1").jqGrid('getCell', ids[i], 'item_catalog');
					var val2 = $("#bomList1").jqGrid('getCell', ids[i], 'item_attr');
					var val3 = $("#bomList1").jqGrid('getCell', ids[i], 'bom_attr');
					if (val2.indexOf('완료') < 0 && itemCode == "") {
						alert('Item 속성을 입력 바랍니다.');
						return false;
					}
					if (val3.indexOf('완료') < 0) {
						alert('BOM 속성을 입력 바랍니다.');
						return false;
					}
					if ($.jgrid.isEmpty(val1)) {
						alert("CATALOG Field is required");
						setErrorFocus("#bomList1", ids[i], 0, 'item_catalog');
						return false;
					}
				}
			}
			return true;
		}
		function fn_bom_create() {
			if ($("#p_eng_change_order_code").val() == "") {
				alert("ECO NO를 생성바랍니다.");
				$("#p_eng_change_order_code").focus();
				return;
			}
			if ($("#p_ship_type").val() == "") {
				alert("Ship Type을 입력바랍니다.");
				$("#p_ship_type").focus();
				return;
			}
			if (confirm('채번 및 BOM생성을 실행하시겠습니까?') != 0) {
				var chmResultRows = [];
				getSelectChmResultData(function(data) {
					chmResultRows = data;
					var dataList = {
						chmResultList : JSON.stringify(chmResultRows)
					};

					$("#project_no").val($("#p_project_no").val());

					var url = 'saveBomJobItem.do';
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend({}, dataList, formData);
					loadingBox = new ajaxLoader($('#mainDiv'), {
						classOveride : 'blue-loader',
						bgColor : '#000',
						opacity : '0.3'
					});
					$.post(
							url,
							parameters,
							function(data) {
								alert(data.resultMsg);
								if (data.result == 'success') {
									$("#treeGrid1").jqGrid().trigger("reloadGrid");
									$("#bomList1").jqGrid().trigger("reloadGrid");

									if (item.states_flag_desc == "BOM" || $("#selectMotherCode").html() == "PROJECT"
											|| $("#item_bom_type").val() == "PAINT_USC") {
										setButtonEnabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonDisabled([ "#btnAddSSC" ]);
									} else if ($("#item_bom_type").val() == "PAINT_JOB") {
										setButtonDisabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonEnable([ "#btnAddSSC" ]);
									} else {
										setButtonDisabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonDisabled([ "#btnAddSSC" ]);
									}

								}

							}, "json").error(function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						loadingBox.remove();
					});
				});
			}
		}

		function getSelectChmResultData(callback) {
			var changedData = $.grep($("#bomList1").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I';
			});

			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		function setButtonDisabled() {
			fn_buttonDisabled([ "#btnAddItem", "#btnDelItem" ]);
		}

		function setButtonEnabled() {
			fn_buttonEnable([ "#btnAddItem", "#btnDelItem" ]);
		}

		function setSaveButtonDisabled() {
			fn_buttonDisabled([ "#btnSave" ]);
		}
		function setSaveButtonEnabled() {
			fn_buttonEnable([ "#btnSave" ]);
		}

		function setCreateButtonDisabled() {
			fn_buttonDisabled([ "#btnCreateBOM" ]);
		}
		function setCreateButtonEnabled() {
			fn_buttonEnable([ "#btnCreateBOM" ]);
		}

		//catalog 조회 popup
		function fn_popup_catalog_search(catalog_type, search_locate, rowid) {

			// JOB은 Phantom을 조회할 수 있도록 VPT를 카탈로그 조회 기본값으로 셋팅
			var p_catalog_code = "";
			if ($("#item_bom_type").val() == "PAINT_JOB") {
				p_catalog_code = "VPT";
			}

			var rs = window.showModalDialog("popUpCatalogSearch.do?catalog_type=" + catalog_type + "&p_catalog_code="
					+ p_catalog_code, window,
					"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off");

			if (rs != null) {

				// BOM 편집에서 JOB 하위는 Phantom만 추가 가능
				if ($("#item_bom_type").val() == "PAINT_JOB") {
					if ("VPT" != rs[0]) {
						alert("BOM 편집 메뉴에서는 JOB 하위에 Phantom(VPT)만 연계 가능합니다.");
						return;
					}
				}

				//grid에서 팝업호출
				var item = $('#bomList1').jqGrid('getRowData', rowid);

				if (catalog_type == "PD") {
					$("#bomList1").setRowData(rowid, {
						pd_catalog : rs[0]
					});
				} else if (catalog_type == "OUT1") {
					$("#bomList1").setRowData(rowid, {
						activity_catalog : rs[0]
					});
				} else if (catalog_type == "OUT2") {
					if ($("#p_job_catalog").val() == rs[0]) {
						alert("상위 CATALOG는 Job Type이 단일입니다.\n상위 CATALOG와 같은 CATALOG를 입력할 수 없습니다.\n다른 CATALOG를 선택해 주세요.");
						return;
					} else {
						$("#bomList1").setRowData(rowid, {
							item_catalog : rs[0]
						});
						$("#bomList1").setRowData(rowid, {
							item_desc : rs[1]
						});
					}
				}

				if (item.oper != 'I') {
					$("#bomList1").setRowData(rowid, {
						oper : "U"
					});
				}
			}
		}

		//저장
		function fn_save() {
			$('#bomList1').saveCell(kRow, idCol);

			var changedData = $("#bomList1").jqGrid('getRowData');
			if ($("#p_eng_change_order_code").val() == "") {
				alert("ECO NO를 생성하세요.");
				return;
			}
			if (confirm('변경된 데이터를 저장하시겠습니까?') != 0) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData(function(data) {
					lodingBox = new ajaxLoader($('#mainDiv'), {
						classOveride : 'blue-loader',
						bgColor : '#000',
						opacity : '0.3'
					});

					chmResultRows = data;
					var dataList = {
						chmResultList : JSON.stringify(chmResultRows)
					};
					var url = 'saveJobItem.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend({}, dataList, formData);

					$.post(
							url,
							parameters,
							function(data) {
								alert(data.resultMsg);
								if (data.result == 'success') {
									//fn_search();

									$("#treeGrid1").jqGrid().trigger("reloadGrid");
									$("#bomList1").jqGrid().trigger("reloadGrid");

									if (item.states_flag_desc == "BOM" || $("#selectMotherCode").html() == "PROJECT"
											|| $("#item_bom_type").val() == "PAINT_USC") {
										setButtonEnabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonDisabled([ "#btnAddSSC" ]);
									} else if ($("#item_bom_type").val() == "PAINT_JOB") {
										setButtonDisabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonEnable([ "#btnAddSSC" ]);
									} else {
										setButtonDisabled();
										setSaveButtonDisabled();
										setCreateButtonDisabled();
										fn_buttonDisabled([ "#btnAddSSC" ]);
									}

								}
							}, "json").error(function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						lodingBox.remove();
					});
				});
			}
		}

		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#bomList1").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});

			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		// Text 입력시 대문자로 변환하는 함수
		function onlyUpperCase(obj) {
			obj.value = obj.value.toUpperCase();
			$('#btn_project_no').click();
		}

		function getShipType() {
			if (!$('#p_project_no').val() == '') {
				$.post("infoProjectShipType.do", fn_getFormData("#application_form"), function(data) {
					$("#p_ship_type").val(data.ship_type);
				}, "json").error(function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				});
			}
		}
		function setButtonEDControl(bom_type, states_flag_desc) {
			if (item.states_flag_desc == "BOM" || $("#selectMotherCode").html() == "PROJECT" || bom_type == "PAINT_USC") {
				setButtonEnabled();
				setSaveButtonDisabled();
				setCreateButtonDisabled();
				fn_buttonDisabled([ "#btnAddSSC" ]);
			} else if (bom_type == "PAINT_JOB") {
				//setButtonDisabled();  JOB 구조 하위 Phantom 추가를 위해 버튼 활성화
				setButtonEnabled();
				setSaveButtonDisabled();
				setCreateButtonDisabled();
				fn_buttonEnable([ "#btnAddSSC" ]);
			} else {
				setButtonDisabled();
				setSaveButtonDisabled();
				setCreateButtonDisabled();
				fn_buttonDisabled([ "#btnAddSSC" ]);
			}
		}
		
		var callback_MenuId = function(menu_id) {
			menuId = menu_id;
		}
	</script>
</body>
</html>
