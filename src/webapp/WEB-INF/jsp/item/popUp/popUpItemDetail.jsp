<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DOCUMENT</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
ul.pop_addfile {
	width: 100%;
}

ul.pop_addfile li {
	float: left;
	width: 100%;
	border-bottom: 1px solid #c7c7c7;
	padding: 10px 10px 10px 20px;
	margin-bottom: 10px;
}

.li_box {
	float: left;
	margin-right: 20px;
}
</style>
</head>
<body>
	<form id="upload" onsubmit="return false">
		<input type="hidden" id="p_item_code" name="p_item_code" value="${p_item_code }"/>
		<input type="hidden" id="p_item_catalog" name="p_item_catalog" value="${p_item_catalog }"/>
		<!-- <input type="text" id="p_item_code" name="p_item_code" value="V3TD-2000580"/>
		<input type="text" id="p_item_catalog" name="p_item_catalog" value="VPT"/> -->
		
		<div id="wrap">
			<div class="ex_upload">● Item Detail</div>
			<table id="item_detail" class="detailArea conSearch">
				<tr>
					<th>Item Code</th>
					<td colspan="3"><span id="item_code"></span>
					<span style="float: right; margin-right: 10px;"><input style="margin-left:10px;" class="btn_blue" type="button" id="item_code_clone" value="Item Clone"></span>
					</td>
				</tr>
				<tr>
					<th>Description</th>
					<td colspan="3"><span id="item_desc"></span><!-- <input style="margin-left:10px" type="button" id="item_desc_copy" value="복사"> --></td>
				</tr>
				<tr>
					<th>State</th>
					<td colspan="3"><span id="states"></span></td>
				</tr>
				<tr>
					<th>Originator</th>
					<td><span id="originator"></span></td>
					<th>Drawing</th>
					<td><span id="draw" ></span></td>
				</tr>
				<tr>
					<th style="text-align: left; width: 80px">Originated Date</th>
					<td style="text-align: left; width: 130px"><span id="originated_date"></span></td>
					<th style="text-align: left; width: 80px">Modified Date</th>
					<td style="text-align: left; width: 130px"><span id="modified_date"></span></td>
				</tr>
				<tr>
					<th>Catalog Group</th>
					<td><span id="item_catalog"></span></td>
					<th>UOM</th>
					<td><span id="uom"></span></td>
				</tr>
				<tr>
					<th>PAINT CODE</th>
					<td><span id="paint_code"></span></td>
					<th>Thinner Code</th>
					<td><span id="thinner_code"></span></td>
				</tr>
				<tr>
					<th>SVR</th>
					<td><span id="stxsvr"></span></td>
					<th>Item Category</th>
					<td><span id="item_category"></span></td>
				</tr>
				<!-- <tr>
					<th>Weight(kg)</th>
					<td><span id="item_weight"></span></td>
					<th>Can Size</th>
					<td colspan="3"><span id="can_size"></span></td>
				</tr> -->
			</table>

			<div class="content">
				<table id="itemAttList"></table>
				<div id="pItemAttList"></div>
			</div>
			<div style="float: right; margin: 10px 10px 0 0">
				<input type="button" id="btnsave" value="저장" class="btn_blue" />
				<input type="button" id="btncancle" value="닫기" class="btn_blue" />
			</div>
		</div>
	</form>

	<script type="text/javascript">
	
		var menuId = '';
		
		$(document).ready(
				function() {
					var parent_value = new Array();
					//var parent_value = window.dialogArguments;
					
					parent_value[0] = $("#p_item_code").val();
					parent_value[1] = $("#p_item_catalog").val();

					var idRow = 0;
					var idCol = 0;
					var nRow = 0;
					var kRow = 0;
					$("#itemAttList").jqGrid(
							{
								datatype : 'json',
								mtype : '',
								url : '',
								editUrl : 'clientArray',
								colNames : [ 'Catalog 속성', 'Catalog 속성명', 'Item 속성명',
										'필수', 'ATTRIBUTE_DATA_TYPE', 'Data Type', 'MIN',
										'MAX' ,'KEY', 'Item 속성값', '속성NO '],
								colModel : [ {
									name : 'attribute_code',
									index : 'attribute_code',
									width : 80,
									sortable : false,
									hidden : true
								}, {
									name : 'attribute_desc',
									index : 'attribute_desc',
									width : 80,
									sortable : false,
									hidden : true
								}, {
									name : 'attribute_name',
									index : 'attribute_name',
									width : 125,
									sortable : false,
									editoptions : {
										size : 5
									}
								}, {
									name : 'attr_req_flg',
									index : 'attr_req_flg',
									width : 30,
									sortable : false,
									editable : false,
									align : "center",
								}, {
									name : 'attr_data_type',
									index : 'attr_data_type',
									width : 30,
									sortable : false,
									editable : true,
									align : "center",
									hidden : true,
									
									editoptions : {}

								},{
									name : 'attr_data_type_desc',
									index : 'attr_data_type_desc',
									width : 80,
									sortable : false,
									editable : false,
									align : "center",
									editoptions : {}

								}, {
									name : 'attr_data_min',
									index : 'attr_data_min',
									width : 50,
									sortable : false,
									editable : false,
									align : "center",
									editoptions : {}

								}, {
									name : 'attr_data_max',
									index : 'attr_data_max',
									width : 50,
									sortable : false,
									editable : false,
									align : "center",
									editoptions : {}

								},{
									name : 'data_list_flag',
									index : 'data_list_flag',
									width : 30,
									sortable : false,
									editable : false,
									align : "center",
									editoptions : {}

								}, {
									name : 'attribute_value',
									index : 'attribute_value',
									width : 125,
									sortable : false,
									editable : true,
									align : "center",
									
									editoptions : {}

								}, {
									name : 'attribute_value_code',
									index : 'attribute_value_code',
									width : 50,
									sortable : false,
									editable : true,
									align : "center",
									hidden : true,
									editoptions : {}

								} ],
								gridview : true,
								toolbar : [ false, "bottom" ],
								viewrecords : true,
								autowidth : true,
								caption : 'ITEM 속성 LIST',
								hidegrid : false,
								height : 350,
								rowNum : 999999,
								pager : '#pItemAttList',
								pgbuttons : false,
								pgtext : false,
								pginput : false,
								cellEdit : true, // grid edit mode 1
								cellsubmit : 'clientArray', // grid edit mode 2
								jsonReader : {
									root : "rows",
									page : "page",
									total : "total",
									records : "records",
									repeatitems : false,
								},
								onCellSelect : function(row_id, colId) {
									
									var cm = $( this ).jqGrid( "getGridParam", "colModel" );
									var colName = cm[colId];
									if ( colName['index'] == "attribute_value" ) {
										var item = $( '#itemAttList' ).jqGrid( 'getRowData', row_id );
										if(item.data_list_flag =='Y') {
											if((item.attribute_name).indexOf('부가속성') < 0) {
												var args = {
													catalog_code : parent_value[1],
													type_code : item.attribute_code
												};
												var ids = $('#itemAttList').jqGrid('getDataIDs');
												for ( var i=0; i<ids.length; i++){
													var attItem = $( '#itemAttList' ).jqGrid( 'getRowData', ids[i] );
													args["attr" + attItem.attribute_code + "_desc"] = attItem.attribute_value;
													if((attItem.attribute_name).indexOf('부가속성') < 0) {
														if(ids[i] > row_id) {
															$('#itemAttList').setCell(ids[i], 'attribute_value_code', null);
															$('#itemAttList').setCell(ids[i], 'attribute_value', null);
														}
													}
												}
												var rs = window
														.showModalDialog(
																"popUpItemAttribute.do",
																args,
																"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

												if (rs != null) {
													$('#itemAttList').setCell(row_id, 'attribute_value_code', rs[0]);
													$('#itemAttList').setCell(row_id, 'attribute_value', rs[1]);
												} else {
													$('#itemAttList').setCell(row_id, 'attribute_value_code', null);
													$('#itemAttList').setCell(row_id, 'attribute_value', null);
												}
												
											} else {
												var args = {
													catalog_code : parent_value[1],
													type_code : item.attribute_code,
												};

												var rs = window
														.showModalDialog(
																"popUpItemAddAttribute.do",
																args,
																"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

												if (rs != null) {
													$('#itemAttList').setCell(row_id, 'attribute_value', rs[1]);
												} else {
													$('#itemAttList').setCell(row_id, 'attribute_value', null);
												}
											}
											
											
											/* // 종속설정을 고려하여 입력된 필드의 후행값은 삭제한다.
											for(var j= selectNo+1; j<data_attr.length; j++){
												var no = j + 1;
												var attr_desc;
												var attr_code;
												if(no < 16 ) {
													if(no < 10){
														no = '0' + no;
													}
													attr_desc = "attr"+no+"_desc";
												} else {
													no = no - 15;
													if(no < 10){
														no = '0' + no;
													}
													attr_code = "add_attr"+no+"_code";
													attr_desc = "add_attr"+no+"_desc";
												}
												$('#itemCreateGrid').setCell(searchIndex, attr_code, null);
												$('#itemCreateGrid').setCell(searchIndex, attr_desc, null);
											} */
										}
									}

								},
								loadComplete : function(data){
									var ids = $('#itemAttList').jqGrid('getDataIDs');
									for ( var i=0; i<ids.length; i++){
										var item = $( '#itemAttList' ).jqGrid( 'getRowData', ids[i] );
										if (parent_value[0] != "NEW") {
											$("#itemAttList").jqGrid('setCell', ids[i], 'attribute_value', '','not-editable-cell');
										} else {
											if(item.data_list_flag =='Y') {
												$( "#itemAttList" ).jqGrid( 'setCell', ids[i], 'attribute_value', '', { cursor : 'pointer', background : 'pink' } );
												$("#itemAttList").jqGrid('setCell', ids[i], 'attribute_value', '','not-editable-cell');
											}
										}
									}
								},
								beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
									idRow = rowid;
									idCol = iCol;
									kRow = iRow;
								},
								imgpath : 'themes/basic/images',
							});

					if (parent_value[0] != "NEW") {
						var url = "infoItemDetail.do?item_code=" + parent_value[0];
						$.post(url, "", function(data) {
							$("#item_code").html(data.item_code);
							$("#item_desc").html(data.item_desc);
							$("#states").html(data.states);
							$("#originated_date").html(data.originated_date);
							$("#modified_date").html(data.modified_date);
							$("#item_catalog").html(data.item_catalog);
							$("#uom").html(data.uom);
							$("#paint_code").html(data.paint_code);
							$("#thinner_code").html(data.thinner_code);
							$("#originator").html(data.originator);
							$("#stxsvr").html(data.stxsvr);
							$("#item_category").html(data.item_category);
							$("#draw").html(data.draw);
							/* $("#item_weight").html(data.item_weight);
							$("#can_size").html(data.can_size); */
						}, "json");
						$("#btnsave").hide();
					} else {
						$("#itemAttList").setGridHeight(250);
						window.dialogHeight = (document.body.scrollHeight - 250) + 'px';
						$("#item_detail").hide();
						$("#btncancle").hide();
						$("#itemAttList").jqGrid("setCaption", 'ITEM 속성 LIST - ' + '신규입력');

					}

					url = "infoItemAttList.do?catalog_code=" + parent_value[1] + "&item_code=" + parent_value[0]
							+ "&type=ITEM";
					$("#itemAttList").jqGrid('setGridParam', {
						url : url,
						mtype : 'POST',
						page : 1,
						datatype : "json",
					}).trigger("reloadGrid");

					$("#btncancle").click(function() {
						window.close();
					});
					
					$("#item_code_clone").click(function() {
						
						//메뉴ID를 가져오는 공통함수 
						getMenuId("itemCreate.do", callback_MenuId);
						
						var sURL = "goItemCreate.do?popupChk=Y&p_item_code="+$("#p_item_code").val()+"&p_catalog_code="+$("#p_item_catalog").val()+"&menu_id=" + menuId;
						var popOptions = "width=1500, height=810, resizable=yes, scrollbars=no, status=no";
						var popupWin = window.open(sURL, "itemCreate", popOptions);
						setTimeout(function(){
							popupWin.focus();
						 }, 100);
						window.close();
						
					});
					
					$("#btnsave").click(function() {
						$('#itemAttList').saveCell(kRow, idCol);
						var returnValue = new Array();
						var rows = $("#itemAttList").getDataIDs();
						for (var i = 0; i < rows.length; i++) {
							var attribute_code = $("#itemAttList").getCell(rows[i], "attribute_code");
							var attribute_value = $("#itemAttList").getCell(rows[i], "attribute_value");
							var attribute_value_code = $("#itemAttList").getCell(rows[i], "attribute_value_code");
							var attribute_name = $("#itemAttList").getCell(rows[i], "attribute_name");
							var attr_req_flg = $("#itemAttList").getCell(rows[i], "attr_req_flg");
							var attr_data_type = $("#itemAttList").getCell(rows[i], "attr_data_type");
							var attr_data_max = $("#itemAttList").getCell(rows[i], "attr_data_max");
							var attr_data_min = $("#itemAttList").getCell(rows[i], "attr_data_min");
							
							
							if(attr_req_flg == "Y" && attribute_value == ""){
								alert("["+attribute_name+"]는 필수 입력 입니다.");	
								return;
							}
							if(attribute_value != "") {
								if(attr_data_type =="S" || attr_data_type =="SS"){
									if(attr_data_min !=""){
										if(!eval(attr_data_min <= attribute_value.length)){
											alert("["+attribute_name+"] 는 "+attr_data_min+" 자릿수 이상 입력 제약입니다.");
											return;
										}
									}
									if(attr_data_max !=""){
										if(!eval(attr_data_max >= attribute_value.length)){
											alert("["+attribute_name+"] 는 "+attr_data_max+" 자릿수 이하 입력 제약입니다.");
											return;
										}
									}
								}
								
								if(attr_data_type =="N" || attr_data_type =="NS"){
									if(isNaN(attribute_value)){
										alert("["+attribute_name+"] 는 숫자 입력 제약입니다.");
										return;
									}
									
									if(attr_data_min !=""){
										if(!eval(attr_data_min <= parseInt(attribute_value))){
											alert("["+attribute_name+"] 는 "+attr_data_min+" 이상 숫자 입력 제약입니다.");
											return;
										}
									}
									if(attr_data_max !=""){
										if(!eval(attr_data_max >= parseInt(attribute_value))){
											alert("["+attribute_name+"] 는 "+attr_data_max+" 이하 숫자 입력 제약입니다.");
											return;
										}
									}
								}
							}
							
							if(attribute_name.indexOf('부가속성') < 0) {
								returnValue[attribute_code] =  attribute_value;
								returnValue[attribute_code+"_code"] =  attribute_value_code;
							} else {
								returnValue["add_"+attribute_code] =  attribute_value;
							}
						}
						window.returnValue = returnValue;
						self.close();
					});
					
					var c1 = new ZeroClipboard($('#item_code_copy'));
					c1.on( "copy", function(event) {
						c1.setText( $("#item_code").html() );
					  } );
					c1.on( "aftercopy", function( event ) {
					    event.target.style.display = "none";
					    alert("클립보드 복사: " + event.data["text/plain"] );
					  } );
					var c2 = new ZeroClipboard($('#item_desc_copy'));
					c2.on( "copy", function(event) {
						c2.setText( $("#item_desc").html() );
					  } );
					c2.on( "aftercopy", function( event ) {
					    event.target.style.display = "none";
					    alert("클립보드 복사: " + event.data["text/plain"] );
					  } );
				});
		
		//도면 뷰어
		var dwgView = function(file_name){	
			var sURL = "dwgPopupView.do?mode=dwgChkView&p_file_name="+file_name;
			form = $('#upload');
			form.attr("action", sURL);
			var myWindow = window.open(sURL,"listForm","height=500,width=1200,top=150,left=200,location=no");
				    
			form.attr("target","listForm");
			form.attr("method", "post");	
					
			myWindow.focus();
			form.submit();
	    }
		
		var callback_MenuId = function(menu_id) {
			menuId = menu_id;
		}
		
	</script>
</body>
</html>