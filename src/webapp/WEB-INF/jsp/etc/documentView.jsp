<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 리스트 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocuments.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
    <style type="text/css">
		A:link {color:black; text-decoration: none}
		A:visited {color:black; text-decoration: none}
		A:active {color:green; text-decoration: none ; font-weight : bold;}
		A:hover {color:red;text-decoration:underline; font-weight : bold;}
		.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
		.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
		.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
		.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
		.title_5			{font-family:"굴림체"; font-Size: 11pt;}
		.title_6			{font-family:"굴림체"; font-Size: 10pt;}
		.title_7			{font-family:"굴림체"; font-Size: 9pt;}
		.title_8			{font-family:"굴림체"; font-Size: 8pt;}
		.button_simple
		{
			font-size: 10pt;
			height: 26px;
			width: 70px;
		}
		.button_simple_1
		{
			font-size: 10pt;
			height: 26px;
			width: 50px;
		}
	
	</style>
    <script language="javascript" type="text/javascript">
		$(document).ready(function(){
			$(window).bind('resize', function() {
				$('#contentdiv').css('height', $(window).height()-230);
			 }).trigger('resize');	
			
			var arrAdmin = ["211055", "209452", "211524", "207026", "209495", "206285", "196146"];
			if(arrAdmin.indexOf("${loginId}") != -1){
				$(".permit").css("display","block"); 
				$(".invalid").css("display","none"); 
			}else{
				$(".permit").css("display","none"); 
				$(".invalid").css("display","block"); 
			}
			
		});
		/* function go_Add()
		{
		     //var loginID = parent.INFO_FRAME_TOP.frmInfoItemTopInclude.loginID.value;
	
		    var loginID = document.frmDocument.loginID.value;
		    var url = "popUpDocumentAdd.do?";
		    url += "loginID="+loginID;
		    
			window.open(url,"","width=520px,height=250px,top=300,left=400,resizable=no,scrollbars=auto,status=no");    
		}
	
		function go_Delete()
		{
		    var someSelected = false;
		    var frm = document.frmDocument;
	
		    for(var i = 1; i < frm.elements.length; i++)
		    {    
		        if(frm.elements[i].type == "radio" && frm.elements[i].checked == true)
		        {
		            someSelected = true;
		            frm.select_value.value = frm.elements[i].value;
		            break;
		        }
		    }
		    if(!someSelected)
		    {
		        alert("선택된 항목이 없습니다.");
		        return;
		    }
	
		    if(confirm("삭제하시겠습니까?"))
		    {
		        frm.action = "documentDelete.do";
		        frm.submit();    
		    }
	
	
		} */
	
	</script>
	
</head>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		양식지
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<!-- <span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span> -->
	</div>
	<!-- <table class="searchArea conSearch">
		<tr>
			<td>
				<div class="button endbox">
					<input type="button" class="btn_blue" name="searchMode" value="기준정보 등록요청" onclick="location.href='standardInfoTrans.do'">
					<input type="button" class="btn_blue" name="searchMode" value="부품표준서" onclick="location.href='itemStandardView.do'">
					<input type="button" class="btn_blue" name="searchMode" value="품목분류표" onclick="location.href='itemCategoryView.do'">
				</div>
			</td>
		</tr>
	</table> -->
<form id="application_form" name="application_form" method="post" >
	<!-- <div class="ct_sc conSearch" style="height:33px; margin-top:10px">
	        <div class="button endbox">
	        	<div class="permit">
		            <input class="btn_blue" type="button" value="추가" onClick="go_Add();">&nbsp;
		            <input class="btn_blue" type="button" value="삭제" onClick="go_Delete();">   
		        </div>
		        <div class="invalid">
	       		 	<input class="btn_gray" disabled type="button" value="추가">&nbsp;
	           		<input class="btn_gray" disabled type="button" value="삭제">   
	        	</div>
	        </div>
	</div> -->
	<%-- <div>
		<table class="insertArea"  style="table-layout:fixed;">
		     <tr align="center" height="28" bgcolor="#e5e5e5">
		         <th width="10%">선택</th>
		         <th width="10%">NO.</th>
		         <th width="70%">문서명</th>
		         <th width="10%">파일</th>
		      <th width="16px">&nbsp;</th>
		     </tr>
		 </table>
		<div id="contentdiv" style="overflow-y:scroll; position:relative;">
			<table class="insertArea"  style="table-layout:fixed;">
				<c:forEach var="item" items="${list}" varStatus="status"> 
					<tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
						<td width="10%" align="center"><input type="radio" name="file_id" value="${item.file_id}"></td>
						<td width="10%" align="center">${status.count}</td>
						<td width="70%">&nbsp;&nbsp;${item.file_name}</td>
						<td width="10%" align="center"><img src="./images/icon_file.gif" border="0" style="cursor:pointer;vertical-align:middle;" onclick="fileView('${item.file_id}')"></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<input type="hidden" name="select_value">
		<input type="hidden" name="loginID" value="${loginId}">
	</div> --%>
	<table class="searchArea conSearch">
	<%-- <col width="100"/>
	<col width="150"/> --%>
	<col width="100"/>
	<col width="170"/>
	<col width="100"/>
	<col width="215"/>
	<col width="*"/>
	<tr>
	
		<!-- <th>분류</th>
		<td>
			<input type="text" id="p_manual_option" name="p_manual_option" class="commonInput" style="width:80px;" value="" alt="분류" />
			<select id="p_manual_option" name="p_manual_option" style="width:120px;">
				<option value="">선택</option>
				<option value="MANUAL">MANUAL</option>
				<option value="양식지">양식지</option>
				<option value="기타 양식지">기타 양식지</option>
			</select>
		</td> -->
		
		<th>프로그램 명</th>
		<td>
		<input type="text" id="p_pgm_name" name="p_pgm_name" class="commonInput" style="width:140px;" value="" alt="프로그램 명" />
		</td>
		
		<th>DESCRIPTION</th>
		<td>
		<input type="text" id="p_description" name="p_description" class="commonInput" style="width:180px;" value="" alt="DESCRIPTION" />
		</td>
	
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				<!-- <input type="button" class="btn_blue2" value="SAVE" id="btnSave"/> -->
			</div>
		</td>
		
	</tr>
	</table>
	
	<div id="divList" class="content">
		<table id="jqGridMainList"></table>
		<div id="bottomJqGridMainList"></div>
	</div>
</form>
</div>
<script type="text/javascript">
		
		//그리드 사용 전역 변수
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var row_selected = 0;
		var resultData = [];
		var resultDetailData = [];
		var lodingBox;
		var lastsel;
		var tableId = '';
		
		var jqGridObj = $("#jqGridMainList");
		
		$(document).ready(function() {
			
			jqGridObj.jqGrid({ 
	            datatype: 'json',
	            url:'',
	            mtype : 'POST',
	            postData : fn_getFormData('#application_form'),
	            colModel: [ 
	                        { label:'프로그램ID', name:'pgm_id', width:200, align:'center', sortable:true, title:false }, 
	                        { label:'프로그램명', name:'pgm_name', width:200, align:'center', sortable:true, title:false, editable:false}, 
	                        { label:'Manual Description', name:'description', width:320, align:'left', sortable:true, title:false,  editable:false}, 
	                        { label:'첨부파일', name:'filename', width:50, align:'center', sortable:true, title:false, formatter: fileFormatter},
	                        { label :'enable_flag_changed', name : 'enable_flag_changed', width : 25, hidden : true},
	                        { label:'OPER', name:'oper', width:25, align:'center', sortable:false, title:false, hidden: true}
	            		  ],
	            gridview: true,
	            viewrecords: true,
	            autowidth: true,
	            cellEdit : true,
	            cellsubmit : 'clientArray', // grid edit mode 2
				scroll : 1,
	            multiselect: false,
	            shrinkToFit: true,
	            pager: $("#bottomJqGridMainList"),
	            rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				rownumbers : true,
		        recordtext: '내용 {0} - {1}, 전체 {2}',
	       	 	emptyrecords:'조회 내역 없음',
		       	 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		         	idRow = rowid;
		         	idCol = iCol;
		         	kRow  = iRow;
		         	kCol  = iCol;
		         },
		        afterSaveCell : chmResultEditEnd,
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
					
				}
	    	}); //end of jqGrid
	    	
	    	fn_gridresize( $(window), jqGridObj, 0 );
			
			//조회 버튼
			$("#btnSearch").click(function() {
				fn_search();
			});
			
		});
		
		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep(jqGridObj.jqGrid('getRowData'),
					function(obj) {
						return obj.oper == 'I' || obj.oper == 'U'
								|| obj.oper == 'D';
					});
			callback.apply(this, [ changedData.concat(resultData), changedDetailData.concat(resultDetailData) ]);
		}

		//조회
		function fn_search() {

			jqGridObj.jqGrid("clearGridData");
			
			var sUrl = "manualEtcList.do";
			jqGridObj.jqGrid('setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");
		}
		
		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = jqGridObj.jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';

			jqGridObj.jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}
		
		//필수입력 표시
		function setErrorFocus(gridId, rowId, colId, colName) {
			$("#" + rowId + "_" + colName).focus();
			$(gridId).jqGrid('editCell', rowId, colId, true);
		}

		function cUpper(cObj) {
			cObj.value = cObj.value.toUpperCase();
		}
		
		function fileFormatter(cellvalue, options, rowObject ) {
			
			//if(cellvalue == null) {
			//	return '';		
			//} else {
				return "<img src=\"./images/icon_file.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('" + rowObject.pgm_id + "' , '" + rowObject.revision_no + "')\">";
			//}
		}
		
		function fileView(pgm_id, revision_no) {
			if(revision_no == 'undefined' || revision_no == null) {
				alert("최초 등록 문서가 존재 하지 않습니다.");
				return false;
			}
			var attURL = "manualFileView.do?";
		    attURL += "p_pgm_id="+pgm_id;
		    attURL += "&p_revision_no="+revision_no;
	
		    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
		    //window.showModalDialog(attURL,"",sProperties);
		    window.open(attURL,"",sProperties);
		    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
		}
		
		</script>
</body>
</html>
