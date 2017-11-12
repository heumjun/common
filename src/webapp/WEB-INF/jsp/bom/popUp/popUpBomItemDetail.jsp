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
	<form id="upload">

		<div id="wrap">
			<div class="ex_upload">● BOM Detail</div>
			<table id="item_detail" class="detailArea conSearch">
				<tr>
					<th width="150px">ITEM CODE</th>
					<td><span id="item_code" ></span><input style="margin-left:10px" type="button" id="item_code_copy" value="복사"></td>
				</tr>
				<tr>
					<th>MOTHER CODE</th>
					<td><span id="mother_code"></span><input style="margin-left:10px" type="button" id="mother_code_copy" value="복사"></td></td>
				</tr>
				<tr>
					<th>CATALOG</th>
					<td><span id="catalog_code"></span></td>
				</tr>
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
		$(document).ready(function() {
			var parent_value = window.dialogArguments;
			var idRow = 0;
			var idCol = 0;
			var nRow = 0;
			var kRow = 0;
			$("#itemAttList").jqGrid({
				datatype : 'json',
				mtype : '',
				url : '',
				editUrl : 'clientArray',
				colNames : [ 'Catalog 속성', 'Catalog 속성명', 'BOM 속성명', '필수', 'ATTRIBUTE_DATA_TYPE', 'Data Type', 'MIN',
								'MAX', 'Item 속성값','' ],
				colModel : [ {
					name : 'attribute_code',
					index : 'attribute_code',
					width : 80,
					sortable : false,
					hidden : true,
					editoptions : {
						size : 11
					}
				}, {
					name : 'attribute_desc',
					index : 'attribute_desc',
					width : 80,
					sortable : false,
					hidden : true,
					editoptions : {
						size : 5
					}
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
					width : 30,
					sortable : false,
					editable : false,
					align : "center",
					editoptions : {}

				}, {
					name : 'attr_data_max',
					index : 'attr_data_max',
					width : 30,
					sortable : false,
					editable : false,
					align : "center",
					editoptions : {}

				}, {
					name : 'attribute_value',
					index : 'attribute_value',
					width : 100,
					sortable : false,
					editable : true,
					align : "center",
					editoptions : {}

				}, {name:'oper',index:'oper', width:25, hidden:true} ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				caption : 'BOM 속성 LIST',
				hidegrid : false,
				height : 250,
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
					if (parent_value[0] != "NEW") {
						//$("#itemAttList").jqGrid('setCell', row_id, 'attribute_value', '', 'not-editable-cell');
					}

				},
				gridComplete : function() {
					var rows = $( "#itemAttList" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var attribute_code = $( "#itemAttList" ).getCell( rows[i], "attribute_code" );
					/*** 	
					    if( attribute_code == "10" ) {
							if (parent_value[0] == "NEW") {
								$( "#itemAttList" ).setRowData( rows[i], { attribute_value: parent_value[3] } );
							}
						}
						if( attribute_code == "11" ) {
							if (parent_value[0] == "NEW") {
								$( "#itemAttList" ).setRowData( rows[i], { attribute_value: parent_value[4] } );
							}
						} ***/
						
						if (parent_value[3] == "VIEW") {
							$("#itemAttList").jqGrid('setCell', rows[i], 'attribute_value', '','not-editable-cell');
						}
					}
				},
				beforeSaveCell : changeEditEnd, 
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				imgpath : 'themes/basic/images',
			});

			if (parent_value[0] != "NEW") {
				var url = "infoItemDetail.do?item_code=" + parent_value[0];
				$.post(url, "", function(data) {
					$("#item_code").html(parent_value[0]);
					$("#mother_code").html(parent_value[1]);
					$("#catalog_code").html(parent_value[2]);
				}, "json");
				if (parent_value[3] == "VIEW") {
					$("#btnsave").hide();
				}
				/* $("#btnsave").hide(); */
			} else {
				window.dialogHeight = (document.body.scrollHeight-70) + 'px';
				$("#item_detail").hide();
				$("#btncancle").hide();
				$("#itemAttList").jqGrid("setCaption", 'BOM 속성 LIST - ' + '신규입력');

			}

			url = "infoBomAttList.do?project_no=" + parent_value[4] + 
									 "&catalog_code=" + parent_value[2] + 
									 "&item_code=" + parent_value[0] +
									 "&mother_code=" + parent_value[1];
			$("#itemAttList").jqGrid('setGridParam', {
				url : url,
				mtype : 'POST',
				page : 1,
				datatype : "json",
			}).trigger("reloadGrid");

			$("#btncancle").click(function() {
				self.close();
			});
			$("#btnsave").click(function() {
				$( '#itemAttList' ).saveCell( kRow, idCol );
				
				var changedData = $.grep($('#itemAttList').jqGrid('getRowData'), function (obj) {
					return obj.oper == 'U';
				});
				/* if(changedData.length == 0) {
					alert("변경된 내용이 없습니다.");
					return;
				} */
				
				var returnValue = new Array();
				var rows = $( "#itemAttList" ).getDataIDs();
				for( var i = 0; i < rows.length; i++ ) {
					var attribute_code = $( "#itemAttList" ).getCell( rows[i], "attribute_code" );
					var attribute_value = $( "#itemAttList" ).getCell( rows[i], "attribute_value" );
					
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
					
					
					
					
					if(attribute_code == "01"){
						returnValue[0] = attribute_value;
					}
					if(attribute_code == "02"){
						returnValue[1] = attribute_value;
					}
					if(attribute_code == "03"){
						returnValue[2] = attribute_value;
					}
					if(attribute_code == "04"){
						returnValue[3] = attribute_value;
					}
					if(attribute_code == "05"){
						returnValue[4] = attribute_value;
					}
					if(attribute_code == "06"){
						returnValue[5] = attribute_value;
					}
					if(attribute_code == "07"){
						returnValue[6] = attribute_value;
					}
					if(attribute_code == "08"){
						returnValue[7] = attribute_value;
					}
					if(attribute_code == "09"){
						returnValue[8] = attribute_value;
					}
					if(attribute_code == "10"){
						returnValue[9] = attribute_value;
					}
					if(attribute_code == "11"){
						returnValue[10] = attribute_value;
					}
					if(attribute_code == "12"){
						returnValue[11] = attribute_value;
					}
					if(attribute_code == "13"){
						returnValue[12] = attribute_value;
					}
					if(attribute_code == "14"){
						returnValue[13] = attribute_value;
					}
					if(attribute_code == "15"){
						returnValue[14] = attribute_value;
					}
					if(attribute_code == "QTY"){
						returnValue[15] = attribute_value;
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
			var c2 = new ZeroClipboard($('#mother_code_copy'));
			c2.on( "copy", function(event) {
				c2.setText( $("#mother_code").html() );
			  } );
			c2.on( "aftercopy", function( event ) {
			    event.target.style.display = "none";
			    alert("클립보드 복사: " + event.data["text/plain"] );
			  } );
			
		});
		//그리드 cell변경된 경우 호출하는 함수
		function changeEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#itemAttList').jqGrid('getRowData', irowId);
			if (item.oper != 'I') {
				item.oper = 'U';
				$('#itemAttList').jqGrid('setCell', irowId, cellName, '', {
					'background' : '#6DFF6D'
				});
			}

			// apply the data which was entered.
			$('#itemAttList').jqGrid("setRowData", irowId, item);
			// turn off editing.
			$("input.editable,select.editable", this).attr("editable", "0");
		}
		function copy_to_clipboard(str) {

			var IE = (document.all) ? true : false;
			if (IE) {
				window.clipboardData.setData("Text", str);
			} else {
				prompt("Ctrl+C를 눌러 클립보드로 복사하세요", str);
			}
		}
	</script>
</body>
</html>