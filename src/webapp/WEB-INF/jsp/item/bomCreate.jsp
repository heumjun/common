<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item Search</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" name="main_code" id="main_code" />
				<input type="hidden" name="item_code" id="item_code" />
				<input type="hidden" name="rev_no" id="rev_no" />
				<input type="hidden" name="states_desc" id="states_desc" />
				<div id="top" style="height: 35px;">
					<div class="topMain">
						<div class="conSearch">
								<select name="p_ship" id="p_ship" >
									<option value="master" >Master</option>
									<option value="project" >Project</option>
								</select>
								<input type="text" class="commonInput uniqInput" name="p_project" alt="Project"  />
							
								DWG No. <input id="p_dwgno" name="p_dwgno" class="commonInput" style="width:85px;" alt="DWG NO." onfocus="javascript:dwgOnFocus();"/>
								
							
								Block <input type="text" class="commonInput" name="p_blockno" value="" style="width:35px;"/>
							
								Stage <input type="text" class="commonInput" name="p_stageno"  value="" style="width:35px;" />
							
								STR 
								<select name="p_str" id="p_str" style="width:60px;">
									<option value=''></option>
								</select>
							
								ECO No. <input type="text" class="commonInput" name="p_econo" value=""  style="width:75px;" />
							
								Dept. 
									<select name="p_selDept" id="p_selDept" style="width:80px;" onchange="javascript:DeptOnChange(this);">
									</select>
									<input type="text" name="p_deptcode" value='440500' style="width:80px;" readonly="readonly" />
									<input type="hidden" name="p_dwgdeptcode" class="disableInput" style="width:80px;" readonly="readonly" />
								User 
									<select name="p_selUser" id="p_selUser" style="width:65px;" onchange="javascript:UserOnChange(this);">
									</select>
									<input type="hidden" name="p_userid" value="211055"  />
								
								Job Code
								<input type="text" class="commonInput"  name="p_job_code" id="p_job_code" style="width:100px;" />
							
								Pending Item
								<input type="text" class="commonInput" name="p_pending_code" id="p_pending_code" style="width:100px;" />
							
								Work
								<select name="p_work" class="commonInput">
									<option value="" selected="selected">ALL</option>
									<option value="open" >Open</option>
									<option value="release" >Release</option>
								</select>
							
								State
								<select name="p_state" class="commonInput">
									<option value="" selected="selected">ALL</option>
									<option value="A" >A</option>
									<option value="D" >D</option>
								</select>
							
								ECO
								<select name="p_iseco" class="commonInput" onchange="javascript:$('#btnSearch').click()">
									<option value="" selected="selected">ALL</option>
									<option value="Y" >Y</option>
									<option value="N" >N</option>
								</select>
							
								Release
								<select name="p_isrelease" class="commonInput">
									<option value="" selected="selected">ALL</option>
									<option value="Y" >Y</option>
									<option value="N" >N</option>
								</select>
							
								Mail
								<select name="p_ismail" class="commonInput">
									<option value="" >ALL</option>
									<option value="Y" >Y</option>
									<option value="N" >N</option>
								</select>
								<input type="button" value="Mail" id="btnMail" />
							
						</div>
						<div class="buttonArea">
							<input type="button" value="Export" id="btnExport"/>
							<input type="button" value="Save" id="btnSave"/>
							<input type="button" value="Add" id="btnAdd"/>
							<input type="button" value="Search" id="btnSearch"/>
							<input type="button" value="ALLBOM" id="btnAllBom"/>
							<input type="button" value="BOM" id="btnBom"/>	
							<input type="button" value="Delete" id="btnDelete"/>
							<input type="button" value="Close" id="btnClose"/>
						</div>
					</div>
				</div>
				<div class="content" style="margin-top: +40px;width: 90%">
					<table id="itemSearchList"></table>
					<div id="btn_itemSearchList"></div>
				</div>
				
			</form>
		</div>
		<script type="text/javascript">
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var divCloseFlag = false;

		$(document).ready( function() {
			
			fn_strsearch();
			fn_selDeptsearch();
			//User 선택할 수 있도록 수정.
			getUserList($("input[name=p_deptcode]").val());
						
			$( "#itemSearchList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : '',
				
				treeGrid: true,
				treeGridModel : 'adjacency',
				ExpandColumn : 'item_code',
				treedatatype: "json",
				
				editUrl : 'clientArray',
				colNames : [ 'State','Master','Project','DWG No.','Block','Stage','STR','Job Item','Pending Item','EA','Description','Dept.','User','Create Date','ECO No.','ECO Release','Mail'],
				colModel : [ {name:'d_state_flag',index:'d_state_flag', width:40, editable:true, align:"center", sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions: {disabled : false}},  
				             { name : 'master_no', index : 'master_no', width:85, editable:false,align:"center"  },
				             { name : 'project_no', index : 'project_no' }, 
				             { name : 'dwg_no', index : 'dwg_no' }, 
				             { name : 'block_no', index : 'block_no' }, 
				             { name : 'stage_no', index : 'stage_no' },
				             { name : 'str_flag', index : 'str_flag' }, 
				             { name : 'job_cd', index : 'job_cd' }, 
				             { name : 'mother_code', index : 'mother_code' }, 
				             { name : 'ea', index : 'ea' }, 
				             { name : 'item_desc', index : 'item_desc' },
				             { name : 'dept_name', index : 'dept_name' }, 
				             { name : 'user_name', index : 'user_name' }, 
				             { name : 'create_date', index : 'create_date' }, 
				             { name : 'eco_no', index : 'eco_no' },
				             { name : 'release_date', index : 'release_date' }, 
				             { name : 'mail_flag', index : 'mail_flag' }],
				             
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "BOM PendingManager",
				height : screen.height * 0.8,
				autowidth : true,
// 				rowList : [ 100, 500, 1000 ],
				rowNum : -1,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery( '#btn_itemSearchList' ),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				jsonReader : {
					id : "item_code",
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					//repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				treeReader : {
					level_field : "lv",
					parent_id_field : "pt",
					leaf_field : "lf",
					expanded_field : "ex"
	            },
				ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
					if ( value == 2 ) {
						var item = $( '#itemSearchList' ).jqGrid( 'getRowData', rowid );
						
						var main_code = item.main_code;
						var item_code = item.item_code;
						var rev_no = item.rev_no;
						var states_desc = item.states_desc;
						
						
						
						$( "#main_code" ).val( main_code );
						$( "#item_code" ).val( item_code );
						$( "#rev_no" ).val( rev_no );
						$( "#states_desc" ).val( states_desc );
						
						fn_tab_link( selected_tab_name );
					}
				}
			} );
			
			var afHeight = screen.height * 0.63;
			var reHeight = screen.height * 0.1;

			$( ".ui-jqgrid-titlebar-close" ).click( function() {
				var iframeId = $( selected_tab_name + " iframe" ).attr( 'id' );
				var ifra = document.getElementById( iframeId ).contentWindow;
				
				if ( divCloseFlag ) {
					$( "#tabs" ).css( { "height" : "250px" } );
					$( selected_tab_name + " iframe" ).attr( 'height','200' );
					reHeight = screen.height * 0.08;
					ifra.fn_setHeight( iframeId, reHeight );
					divCloseFlag = false;
				} else {
					$( "#tabs" ).css( { "height" : afHeight } );
					$( selected_tab_name + " iframe" ).attr( 'height', '550' );
					reHeight = screen.height * 0.44;
					ifra.fn_setHeight( iframeId, reHeight );
					divCloseFlag = true;
				}
	
				$( ".ui-jqgrid-titlebar-close", this ).click();
			} );

		} ); //end of ready Function
		
		
		
		//Item Type .. 버튼 클릭
		$( "#btnSearchCatalog" ).click( function() {
			popUpItemType();
		} );

		//조회 버튼
		$( "#btnSearch" ).click( function() {
			fn_search();
		} );
		
		function popUpItemType() {
			var rs = window.showModalDialog( "popUpBaseInfo.do?cmd=popupPartFamilyInfo", 
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

			if ( rs != null ) {
				$( "#item_type" ).val( rs[1] );
			}
		}

		function fn_search() {
		/*	var item_type = $( "#item_type" ).val();
			if ( item_type == null || item_type == "" ) {
				alert( "Item Type을 입력하세요" );
				return;
			}
		*/
			
			$( "#itemSearchList" ).jqGrid( "clearGridData" );
			var sUrl = "bomCreateList.do";
			jQuery( "#itemSearchList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		
		//btnExport 버튼 클릭 시 
		$("#btnExport").click(function(){
			if($("#listSize").val() > 0){
				$(".commonInput").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				form = $('#application_form');
				
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("TBC_PENDINGMANAGERMAINDAO");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("PendingManagerMainList");
				var now = new Date();
				
				$("input[name=p_filename]").val("Pending_List");		
				//필수 파라미터 E	
				
				form.attr("action", "/ematrix/tbcPendingExcelPrint.tbc");
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			}else{
				alert("검색결과가 없습니다.");
			}
		
		});
		
		//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			//아이템 체크 Validation
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			if(confirm("변경내용을 Save하시겠습니까?")){
				form = $('#application_form');			
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("TBC_PENDINGMANAGERMAINDAO");
				$("input[name=p_queryType]").val("update");
				$("input[name=p_process]").val("PendingManagerUpdateMail");
				//필수 파라미터 E	
				$(".loadingBoxArea").show();
				$.post("/ematrix/tbcPendingManagerMainSaveAction.tbc",form.serialize(),function(json)
				{	
					afterDBTran(json);
					$(".loadingBoxArea").hide();
				},"json");
			}
		});
		
		
		//Mail 버튼 클릭 시 
		$("#btnMail").click(function(){
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			var inputVal = $("select[name=p_ismail] option:selected").val();
			if(inputVal != ""){
				if(confirm("선택한 항목의 Mail을 '"+inputVal+"'(으)로 일괄 변경합니다.")){
					$("input[name=p_chkItem]:checkbox:checked").parent().parent().find("select[name=p_mail_flag]").val(inputVal);
				}
			}
		});

		//After Int 버튼 클릭 시 
		$("#btnAfterInf").click(function(){
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			//아이템 체크 Validation
			if(!isChecked()){
				return;
			}
			var sURL = "/ematrix/tbcAfterInf.tbc?p_project="+$("input[name=p_project]").val()+"&p_dwgno="+$("input[name=p_dwgno]").val()+"&p_master="+$("input[name=p_master]").val();
			var popOptions = "dialogWidth: 1230px; dialogHeight: 700px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
		});
		
		//Add 버튼 클릭 시 
		$("#btnAdd").click(function(){
			if(uniqeValidation()){
				$(".commonInput").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				form = $('#application_form');		
				
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("");
				$("input[name=p_queryType]").val("");
				$("input[name=p_process]").val("");	
				//필수 파라미터 E		
				form.attr("action", "/ematrix/tbcPendingManagerAddMain.tbc");
				form.attr("target", "_self");	
				form.attr("method", "post");	
				
			    var popOptions = "width=1300,height=768, scrollbars=yes resizable=yes"; 
			    var popup = window.open("", "AddPop", popOptions);
			    
				form.attr("target","AddPop");
				form.attr("method", "post");	
				form.submit();
			    popup.focus(); 
			}
		});
		
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
	/*	$("#btnSearch").click(function(){
			$("input[name=p_nowpage]").val("1");
			$("#PendingPagingArea").text("");
			//Uniqe Validation
			if(uniqeValidation()){
				form = $('#application_form');
				//모두 대문자로 변환
				$(".commonInput").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("TBC_PENDINGMANAGERMAINDAO");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("PendingManagerMainList");
				//필수 파라미터 E	
				getAjaxHtmlPost($("#PendingMainContent"),"/ematrix/tbcPendingManagerMainBody.tbc",form.serialize(),$("#loadingBar"), null, SearchCallback);				
			}
		});
	*/
		//All BOM 버튼 클릭 시 
		$("#btnAllBom").click(function(){	
			if(confirm("검색된 모든 ITEM을 일괄 BOM연계 하시겠습니까?")){
				form = $('#application_form');
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("");
				$("input[name=p_queryType]").val("");
				$("input[name=p_process]").val("");
				$("input[name=p_bomtype]").val("all");
				//필수 파라미터 E		
				
				var sURL = "/ematrix/tbcPendingManagerBomMain.tbc";
				
			    var popOptions = "width=600, height=200, scrollbars=no"; 
			    var popup = window.open("", "allbomPop", popOptions);
			    form.attr("action", sURL);
	 			form.attr("target","allbomPop");
				form.attr("method", "post");	
				
			    popup.focus(); 
				form.submit();
			}		
		});
		
		//BOM 버튼 클릭 시 
		$("#btnBom").click(function(){
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			//아이템 체크 Validation
			if(!isChecked()){
				return;
			}
			var rtn = true;
			
			//ECO 여부 체크
			$("input[name=p_chkItem]").each(function(){
				if($(this).is(":checked")){
					if($(this).parent().parent().find(".td_eco").text() != ""){
						alert("선택한 Data는 BOM 대상이 아닙니다.");
						rtn = false;
						return false;
					}
				}
			});
			if(rtn){
				if(uniqeValidation()){			
					var sURL = "/ematrix/tbcPendingManagerBomMain.tbc";
					//var popOptions = "dialogWidth: 460px; dialogHeight: 500px; center: yes; resizable: yes; status: no; scroll: yes;"; 
					
					form = $('#application_form');
					//필수 파라미터 S	
					$("input[name=p_daoName]").val("");
					$("input[name=p_queryType]").val("");
					$("input[name=p_process]").val("");
					$("input[name=p_bomtype]").val("");
					
					//필수 파라미터 E		
					form.attr("action", sURL);
					
				    //var popOptions = "dialogWidth: 460px; dialogHeight: 500px; center: yes; resizable: yes; status: no; scroll: yes;"; 
				    
				    var popOptions = "width=840, height=600, scrollbars=yes"; 
				    var popup = window.open("", "bomPop", popOptions);
				    
   					form.attr("target","bomPop");
					form.attr("method", "post");	
					
				    popup.focus(); 
					form.submit();
				}
			}
		});
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			//아이템 체크 Validation
			if(!isChecked()){
				return;
			}
			var rtn = isNotProcessState("A", "선택한 Data는 Delete 대상이 아닙니다.");
			if(rtn){
				if(confirm("Delete 하시겠습니까?")){
					$(".commonInput").each(function(){
						$(this).val($(this).val().toUpperCase());
					});
					form = $('#application_form');			
					//필수 파라미터 S	
					$("input[name=p_daoName]").val("TBC_PENDINGMANAGERDELETEDAO");
					$("input[name=p_queryType]").val("update");
					$("input[name=p_process]").val("");
					//필수 파라미터 E	
					$(".loadingBoxArea").show();
					$.post("/ematrix/tbcPendingManagerDeleteAction.tbc",form.serialize(),function(json)
					{	
						afterDBTran(json);
						$(".loadingBoxArea").hide();
					},"json");
				}
			}
		});
		
		//Close 버튼 클릭 시 
		$("#btnClose").click(function(){
			self.close();
		});
		
		//str 리스트 만들기
		function fn_strsearch()
		{
			var url = 'pendingStrList.do';
			var formData = fn_getFormData('#application_form');
	
				$.post( url, formData, function( data ) {
					for(var i = 0;data.length > i;i++){
					   $("#p_str").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					}
					
				}, "json" );
		
		}
		
		//str 리스트 만들기
		function fn_selDeptsearch()
		{
			var url = 'selDeptList.do';
			var formData = fn_getFormData('#application_form');
	
				$.post( url, formData, function( data ) {
					for(var i = 0;data.length > i;i++){
					   $("#p_selDept").append("<option value='"+data[i].sb_value+"' selected=\'"+data[i].sb_selected+"'\"'>"+data[i].sb_name+"</option>");
					}
					
				}, "json" );
		
		}
		
		//Dept Change 
		var DeptOnChange = function(){
			//기술 기획일 경우 유저 선택 기능				
			var vDeptCode = $("#p_selDept option:selected").val();
			getUserList(vDeptCode)
			$("input[name=p_deptcode]").val($("#p_selDept option:selected").val());
		}
		
		//Get User List
		var getUserList = function(vDeptCode){
			var url = 'managerUserList.do';
			var formData = fn_getFormData('#application_form');
				$.post( url, formData, function( data ) {
					for(var i = 0;data.length > i;i++){
					   $("#p_selUser").append("<option value='"+data[i].sb_value+"' selected=\'"+data[i].sb_selected+"'\"'>"+data[i].sb_name+"</option>");
					}
					
				}, "json" )
		}
			
		//User Change 
		var UserOnChange = function(){
			$("input[name=p_userid]").val($("#p_selUser option:selected").val());
		}	
		</script>
	</body>
</html>
