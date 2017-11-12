<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PURCHASING - ADD</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
	<body>
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="pageYn" id="pageYn" value="N" />
			<input type="hidden" name="p_userId" id="p_userId" value="<c:out value="${UserId}" />" />
			<input type="hidden" name="p_daoName"   id="p_daoName" value=/>
			<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
			<input type="hidden" name="p_process"   id="p_process" value=""/>
			<input type="hidden" name="p_filename"  id="p_filename" value=""/>
			<input type="hidden" name="list_type"   id="list_type" />
			<input type="hidden" name="list_type_desc" id="list_type_desc" />
			<input type="hidden" name="p_pos_rev" id="p_pos_rev" value="" />
			<input type='hidden' name='busi_type' id='busi_type' value='A'/>
			<input type="hidden" name="master"  id="master" value="${p_pjt}"/>
			<input type="hidden" name="dwg_no"  id="dwg_no" value="" />
			<div id="hiddenArea"></div>
			
			<div id="mainDiv" style="display:block; float:none; " id="mainDiv">
				<div class = "topMain" style="line-height:45px">
					<div class = "conSearch">
						<span class = "spanMargin">
						<span class="pop_tit" style="padding: 2px 4px 4px 4px;">선종</span>
						<select name="p_ship_kind" id="p_ship_kind" style="width:70px;" >
<!-- 							<option value="">ALL</option> -->
						</select>
						</span>
					</div>
					
					<div class = "conSearch">
						<span class = "spanMargin">
						<span class="pop_tit" style="padding: 2px 4px 4px 4px;">DWG NO.</span>
						<input type="text" class="required" id="p_dwg_no" name="p_dwg_no" style="width:70px; height:25px; ime-mode:disabled; text-transform:uppercase;" onChange="javascript:this.value=this.value.toUpperCase();"/>
						</span>
					</div>
					
					<div class = "conSearch">
						<span class = "spanMargin">
						<span class="pop_tit" style="padding: 2px 4px 4px 4px;">MIDDLE NAME</span>
						<input type="text" id="p_dwg_name" name="p_dwg_name" style="width:70px; height:25px;" />
						</span>
					</div>
					
					<div class = "conSearch">
						<span class = "spanMargin">
						<span class="pop_tit" style="padding: 2px 4px 4px 4px;">ITEM</span>
						<input type="text" id="p_item_code" name="p_item_code" style="width:70px; height:25px;" />
						</span>
					</div>
					
					<div class ="conSearch" style="width:200px">
						<span class = "spanMargin">
						<span class="pop_tit" style="padding: 2px 4px 4px 4px;">ITEM DESC.</span>
						<input type="text" id="p_item_desc" name="p_item_desc" style=";width:70px; height:25px;" />
						</span>
					</div>

					<div class="conSearch">
						<input type="button" class="btn_blue" value="조회" id="btnSearch"/>
						<input type="button" class="btn_blue" value="POS" id="btnNext"/>
						<input type="button" class="btn_blue" value="Excel양식" id="btnForm"/>
						<input type="button" class="btn_blue" value="Excel업로드" id="btnImport"/>
						<input type="button" class="btn_blue" value="닫기" id="btnClose"/>
					</div>
				</div>
					
				<div class = "topMain" style="line-height:0px">
					
					
					<div id="SeriesCheckBox" class="seriesChk"></div>
					
					<c:forEach var="item" items="${pjtList}" varStatus="count">
						<input type="checkbox" id="pjt_<c:out value="${count.count}" />" name="project" class="check1" value="<c:out value="${item.d_projectno}" />" onclick="checkBoxRow(event)" checked/><c:out value="${item.d_projectno}" />
					</c:forEach>
				</div>
				
				<div class="content">
					<table id="jqGridPuchasingAddList"></table>
					<div id="btnJqGridPuchasingAddList"></div>
				</div>
			</div>	
		</form>
		
				
		<script type="text/javascript" >
			var idRow;
			var idCol;
			var kRow;
			var kCol;
			var lastSelection;
			
			$(document).ready(function(){
				
				//Dept. 조회조건 SelectBox 리스트를 불러옴
				$.post( "emsPurchasingAddSelectBoxPjt.do?master=" + $("#master").val(), "", function( data ) {
					for(var i =0; i < data.length; i++){
						 $("#p_ship_kind").append("<option value='"+data[i].ship_info+"'>"+data[i].ship_info+"</option>");
					}
					
				}, "json" );
				
				//시리즈 호선 받기	
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_project_no="+$("#master").val()+"&p_ischeck=Y", null, getDeliverySeriesCallback);
					
			
				//slide 구현
				var contentsSlide = $('#slider').slider(
				{
					auto:false,
					opacity:true,
					effect:'slide',//slide,fade
					queue:false,
					duration:600, 
					easing: 'easeInSine',
					width: 1000,
					interval:6000
					//position:'absolute',
					
				});
				
				//key evant 
				$("input[type=text]").keypress(function(event) {
				  if (event.which == 13) {
				        event.preventDefault();
				        $('#btnSearch').click();
				    }
				});	
				
				$("#jqGridPuchasingAddList").jqGrid({ 
		            datatype: 'json', 
		            mtype: 'POST', 
		            url:'',
		            postData : getFormData('#application_form'),		             
	                colModel:[
	                 /*
	                	{label:'<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', name:'ems_no', index:'ems_no', width:20, align:'center', formatter:formatOpt1, sortable:false},
	                */
						{label:'선종', name:'ship_kind', index:'ship_kind', width:50, align:'center', sortable:false, title:false},
						{label:'DWG No.', name:'dwg_no', index:'dwg_no', width:60, align:'center', sortable:false, title:false},
						{label:'도면명', name:'dwg_name', index:'dwg_name', width:240, align:'left', sortable:false},
						{label:'ITEM CODE',name:'item_code', index:'item_code', width:85, align:'center', sortable:false, title:false},
						{label:'ITEM DESCRIPTION',name:'item_desc', index:'item_desc', width:240, align:'left', sortable:false},
						{label:'INSTALL',name:'install_pos', index:'install_pos', width:40, align:'center', sortable:false, hidden:true},
						{label:'TIME',name:'install_time', index:'install_time', width:30, align:'center', sortable:false, hidden:true},
						{label:'EA',name:'ea', index:'ea', width:30, align:'center', formatter:'integer', sortable:false, hidden:true},
						{label:'EA',name:'in_ea', index:'in_ea', width:30, align:'center', formatter:'integer', sortable:false, title:false, editable:true},
						{label:'is_ext_db_master',name:'is_ext_db_master', index:'is_ext_db_master', width:30, align:'center', sortable:false, hidden:true}
	                ],
		            gridview: true,
		            toolbar: [false, "bottom"],
		            viewrecords: true,
		            autowidth: true,
		            scrollOffset : 18,
		            height: 570,
		            pager: jQuery('#btnJqGridPuchasingAddList'),
		            rowList:[100,500,1000],
			        rowNum:100, 
			        cellEdit : true,
			        cellsubmit : 'clientArray', // grid edit mode 2
		            multiselect: true,
					beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		            	idRow=rowid;
		             	idCol=iCol;
		             	kRow = iRow;
		             	kCol = iCol;
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
						$(this).jqGrid("clearGridData");
			 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
					},	
		   			loadComplete: function (data) {
					    var $this = $(this);
					    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
					        $this.jqGrid('setGridParam', {
					            datatype: 'local',
					            data: data.rows,
					            pageServer: data.page,
					            recordsServer: data.records,
					            lastpageServer: data.total
					        });
					        this.refreshIndex();
					
					        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
					    
					}
					
		     	}); //end of jqGrid			
		     	
				//######## 조회 버튼 클릭 시 ########//
				$("#btnSearch").click(function(){
				
					if($("input[name=p_dwg_no]").val() == ""){
						alert("도면번호를 입력해 주십시오.");
						return;
					}
					
					//작업 초기화
					initSearch();
					
					$("#jqGridPuchasingAddList").jqGrid("clearGridData");
					$("#gridPosList").jqGrid("clearGridData");
	
					var sUrl = "popUpPurchasingAddList.do";
					
					jQuery("#jqGridPuchasingAddList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData: getFormData('#application_form')}).trigger("reloadGrid");
					
					
				});
				
				//Excel Form 클릭 다운로드 
				$("#btnForm").click(function(){
					$.download('fileDownload.do?fileName=EmsPurchasingFormat.xls',null,'post' );
				});
				
				//######## Next 버튼 클릭 시 ########//
				$("#btnNext").click(function(){
					var p_l_item_code = "";
					var p_l_ea = "";
					var p_l_dwg_no = "";
					var p_series = "";
					
					$("#jqGridPuchasingAddList").saveCell(kRow, idCol );		
					//SLIDE NEXT ;
  				    //contentsSlide.slider('next');
  				    
  				    //호선 체크
  				    if($("input[name=p_series]:checked").size() == 0){
						alert("시리즈를 선택하여 주십시오.");
						return false;
					}
  				    
  				    
  				    var row_id = jQuery("#jqGridPuchasingAddList").jqGrid('getGridParam', 'selarrrow');
  				    
					if(row_id == ""){
						alert("행을 선택하십시오.");
						return false;
					}
  				    var vDwgNo = ""; 
  				    
  				  	var vHtmlStr = "";
  				    //row 단위 Validation
					for(var i = 0; i < row_id.length; i++) {
						var vEa = $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).in_ea;
						var vIsExtDbMaster = $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).is_ext_db_master;
						
						vDwgNo = $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).dwg_no;
						
						if(vEa == 0 || vEa == ""){
							alert("수량을 입력해 주십시오.");
							return false;
						}
						if(vIsExtDbMaster == 'N'){
							alert("기준 정보에 없는 ITEM이 존재합니다. \n기술기획으로 문의바랍니다.");
							return false;
						}
						if (i != 0) {
							p_l_item_code += ",";
							p_l_ea += ",";
							p_l_dwg_no += ",";
						}
						p_l_item_code += $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).item_code;
						p_l_ea += $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).in_ea;
						p_l_dwg_no += $('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).dwg_no;
					}
  				    
					for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
						if (i != 0) p_series += "," 
						p_series += $("input[name=p_series]:checked").eq(i).val();
					}
  				    
					$("#hiddenArea").html(vHtmlStr);
					
					//DWG NO가 공백일 경우에는 리스트의 도면번호를 넣어준다.
// 					if($("input[name=s_dwg_no]").val() == ""){
						$("input[name=p_dwg_no]").val(vDwgNo);
// 					}
					
					
  				    //pos 등록 안했으면 등록 창 호출
  				    if($("#p_pos_rev").val() == ""){
						
						var mst = "";
						var dwgno = "";
						var master = "";
						var dwg_no = "'";					
						var pur_no = "";

						$("#gridPosList").jqGrid("clearGridData");
		
						var sUrl = "popUpPurchasingPos.do?p_l_item_code=" + p_l_item_code + "&p_l_ea=" + p_l_ea + "&p_l_dwg_no=" + p_l_dwg_no + "&p_project=" + p_series;
						
						var nwidth = 1020;
						var nheight = 290;
						var LeftPosition = (screen.availWidth-nwidth)/2;
						var TopPosition = (screen.availHeight-nheight)/2;
					
						var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
						
						$("input[name=dwg_no]").val($("input[name=p_dwg_no]").val());
						
						form = $('#application_form');			
						form.attr("action", sUrl);		
						
						$("input[name=p_daoName]").val("");
						$("input[name=p_queryType]").val("select");
						$("input[name=p_process]").val("");
						
						var popWin = window.open("","posPopup",sProperties);
						
						setTimeout(function(){
							popWin.focus();
						 }, 100);

						form.attr("target","posPopup");
						form.attr("method", "post");	

						form.submit();
						
						
					}else{
// 						// APPLY 진행
// 						var row_id = jQuery("#jqGridPuchasingAddList").jqGrid('getGridParam', 'selarrrow');
// 						var vHtmlStr = "";
						
// 						for(var i = 0; i < row_id.length; i++) {
							
// 							vHtmlStr += "<input type='hidden' name='p_l_item_code' value='"+$('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).item_code+"'/>";
// 							vHtmlStr += "<input type='hidden' name='p_l_ea' value='"+$('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).in_ea+"'/>";
// 							vHtmlStr += "<input type='hidden' name='p_l_dwg_no' value='"+$('#jqGridPuchasingAddList').jqGrid('getRowData', row_id[i]).dwg_no+"'/>";
// 						}												
// 						$("#hiddenArea").html(vHtmlStr);

// 						form = $('#application_form');			
						
// 						//필수 파라미터 S	
// 						$("input[name=p_daoName]").val("EMS_PURCHASING");
// 						$("input[name=p_queryType]").val("insert");
// 						$("input[name=p_process]").val("insertPurchasingAdd");
						
// 						$(".loadingBoxArea").show();
	
// 						$.post("popUpPurchasingPosApplyFile.do",form.serialize(),function(json)
// 						{	
// 							afterDBTran(json);
// 							$(".loadingBoxArea").hide();
// 							//그리드 리로드
// 						},"json");
					}

				});
				
				//########  닫기버튼 ########//
				$("#btnClose").click(function(){
					$(opener.document).find("#btnSearch").click();
					window.close();					
				});	
				
				
				//######## 조회 버튼 클릭 시 ########//
				$("#btnImport").click(function(){
				
					$("#jqGridPuchasingAddList").jqGrid("clearGridData");

					var sURL = "popUpPurchasingAddExcelImport.do?p_ship_kind="+$("select[name=p_ship_kind]").val();
// 					var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
// 					window.showModalDialog(sURL, window, popOptions);
					
					var nwidth = 450;
					var nheight = 160;
					var LeftPosition = (screen.availWidth-nwidth)/2;
					var TopPosition = (screen.availHeight-nheight)/2;
					
					var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
					window.open(sURL,"",sProperties).focus();	
				});
			
			});
			

			//######## 메시지 Call ########//
			var afterDBTran = function(json){
				var msg = json.resultMsg;			 	
			 	var result = json.result;
			 	var returnVal = json.returnVal;
				alert(msg);
				$("#btnClose").click();
			}
			
			//######## Input text 부분 숫자만 입력 ########//
			function onlyNumber(event) {
			    var key = window.event ? event.keyCode : event.which;    
			
			    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
			    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
			    || key  == 8  || key  == 46 ) // del, back space
			    ) {
			        return true;
			    }else {
			        return false;
			    }    
			};
			
			//폼데이터를 Json Arry로 직렬화
			function getFormData(form) {
			    var unindexed_array = $(form).serializeArray();
			    var indexed_array = {};
				
			    $.map(unindexed_array, function(n, i){
			        indexed_array[n['name']] = n['value'];
			    });
				
			    return indexed_array;
			}
			
			//STATE 값에 따라서 checkbox 생성
// 			function formatOpt1(cellvalue, options, rowObject){
					
// 				var rowid = options.rowId;
				
// 				var ship_kind = rowObject.ship_kind;
// 				var item_code = rowObject.item_code;
// 				var ems_no = item_code + "_" + ship_kind;
// 		   		var str ="<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value='"+ems_no+"' />";
		  	             
// 		   	 	return str;
// 			}
			
			//all checkbox action 
			function checkBoxAll(e) {
		  		e = e||event;/* get IE event ( not passed ) */
		  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
				if(($("#pjtAll").is(":checked"))){
					$(".pjtchkboxItem").prop("checked", true);
				}else{
					$("input.pjtchkboxItem").prop("checked", false);
				}
			}
			
			function checkBoxRow(e) {
				e = e||event;/* get IE event ( not passed ) */
		  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		  		var cnt = 0;
		  		
		  		for(var a = 1; a <= $(".pjtchkboxItem").length; a++) {
		  			if($("#pjt_"+a).is(":checked") == true) {
		  				cnt++;
		  			}
		  		}
		  		
		  		if(cnt == $(".pjtchkboxItem").length) {
		  			$("#pjtAll").prop("checked", true);
		  		} else {
		  			$("#pjtAll").prop("checked", false);
		  		}
			}		
			//header checkbox action 
			function checkBoxHeader(e) {
		  		e = e||event;/* get IE event ( not passed ) */
		  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
				if(($("#chkHeader").is(":checked"))){
					$(".chkboxItem").prop("checked", true);
				}else{
					$("input.chkboxItem").prop("checked", false);
				}
			}
				
			//초기화
			function initSearch(){
			    $("#p_pos_rev").val("");   			   
			}	
			
			//jqGrid Binding 이후 Validation 체크
			function validationList(){
			
				//jqGrid의 rowData를 받아옴.					
				var errData = $.grep( $("#jqGridPuchasingAddList").jqGrid( 'getRowData' ), function( obj ) {
					return true;
				});
				
				//DB Master에 없는 데이터는 색깔 표시
				for(var i=0; i < errData.length; i++){
					if(errData[i].is_ext_db_master == 'N'){
						$("#jqGridPuchasingAddList").jqGrid('setCell',i+1,"item_code","",{'background-color':'red',
	                                       					         'background-image':'none',
	                                       					         'color':'#FFFFFF'});
                    }
				}
			}
			
			function setGridExcel(uploadList){

				var aryJson = new Array();
				
		 		aryJson = JSON.parse(uploadList); 
		 		/* aryJson = uploadList.uplist; */
				
		 		//jqGrid 초기화
		 		$("#jqGridPuchasingAddList").jqGrid("clearGridData");
				
		 		//jqGrid Row 입력
		 		for(var i=0;i<=aryJson.length;i++){

		 			$("#jqGridPuchasingAddList").jqGrid('addRowData',i+1,aryJson[i]);
		 		}
		 		//List Validation
		 		validationList();

			} 
			
			// 딜리버리 호선 체크 불가
		    function getDeliverySeriesCallback(){
		    	$.post("getDeliverySeries.do?p_project_no="+$("#master").val(),"" ,function(data){
					var deliverySeries = data;
		    		for(var i=0; i<$("input[name=p_series]").length; i++){
		    			var id = $("input[name=p_series]")[i].id;
		    			for(var j=0; j<deliverySeries.length; j++){
		    				if($("input[name=p_series]")[i].id == "p_series_"+deliverySeries[j].project_no){
		    					$("#" + id).attr("disabled", true); 
		        				$("input:checkbox[id='"+id+"']").prop("checked", false);
		        				break;
		    				}
		    				else{
		    					$("#" + id).attr("disabled", false);
		        				$("input:checkbox[id='"+id+"']").prop("checked", true);
		    				}
		    			}
		    		}	
				},"json");
		    }			

		</script>
	</body>
</html>