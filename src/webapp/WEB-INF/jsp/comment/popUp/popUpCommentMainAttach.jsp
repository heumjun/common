<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Excel Import</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<script src="//github.com/fyneworks/multifile/blob/master/jQuery.MultiFile.min.js" type="text/javascript" language="javascript"></script>

<style>
	.popMainDiv{margin:10px; }
	.popMainDiv .WarningArea{width:490px;  border:1px solid #ccc; padding:8px; margin-bottom:0px; }
	.popMainDiv .WarningArea .tit{font-size:12pt; margin-bottom:6px; color:red; font-weight:bold;}	
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
<input type="hidden" id="row_selected" name="row_selected" value="${row_selected}" />
<input type="hidden" id="p_comment_sub_id" name="p_comment_sub_id" value="${comment_sub_id}" />
<input type="hidden" id="view_flag" name="view_flag" value="${view_flag}" />
<input type="hidden" id="edit_enable_flag" name="edit_enable_flag" value="${edit_enable_flag}" />

<div id="mainDiv" class="mainDiv">
	<div class="content" style="float:left; width:46%; position:absolute; border:none; margin:5px 0 0 13px;">
		<table id = "jqGridList"></table>
		<div   id = "btnjqGridList"></div>
	</div>	
	<div class = "topMain" style="float:right; width:49%; border:none; margin-top:0px;">
		<table class="searchArea2 conSearch" style="width: 370px;">
			<col width="220"/>
			<col width="*"/>
			<tr>
				<td style="border-right:none;">
					<input type="file" name="fileName" id="fileName" size="51"  multiple="true" />
				</td>
				<td style="border-left:none;">
					<input type="button" value="확인" id="btnExlUp" class="btn_blue2"/>
					<input type="button" value="닫기" id="btnClose" class="btn_blue2"/>
				</td>
			</tr>
		</table>
		<br />
		<div id="some_file_queue" style="width:400px; height:300px; overflow: auto;"></div>
		<div id="aa" style="width: 500px; height: 100px;"></div>
	</div>
</div>
</form>
<script type="text/javascript" >

//File Implode Submit Form 셋팅.
$(function() {
	$("#fileName").uploadify({
		buttonText  : '첨부파일',
		//buttonClass : 'some-class',
		auto 		: false,
		method   	: 'post',              //파라미터 전송 방식
		swf     	: '/images/system/uploadify.swf',
		uploader 	: 'commentMainAttachAction.do',
		height  	: 23,
		width    	: 120,
		queueID  	: 'some_file_queue', 
		fileDataName: 'fileName',
		onSelect 	: function(file) {
            //alert('The file ' + file.name + ' was added to the queue.');
            //$("#aa").append(file.name + "<br />");
        },
        onUploadSuccess : function(file, data, response) {  
        	
        	// 업로드 성공 후 업로드한 이미지를 해당 jqGridObj에 세팅
        	var args = window.dialogArguments;
        	
        	var name = file.name;
        	var objfile = JSON.parse(data);
			var jsonGridData = new Array();
       		var rowid = $("#row_selected").val();
	    	
			args.jqGridObj.setCell(rowid, 'sub_att', "첨부");
// 			opener.jqGridObj.setCell(rowid, 'sub_att', "첨부");
			
			var decSubAttName = args.jqGridObj.getCell(rowid, 'dec_sub_att_name');
			var decSubAtt = args.jqGridObj.getCell(rowid, 'dec_sub_att');
// 			var decSubAttName = opener.jqGridObj.getCell(rowid, 'dec_sub_att_name');
// 			var decSubAtt = opener.jqGridObj.getCell(rowid, 'dec_sub_att');
			
			var gubun = '@';
			
			if(decSubAttName == '') {
				gubun = '';
			}
			
			args.jqGridObj.setCell(rowid, 'dec_sub_att_name', decSubAttName + gubun + name);
			args.jqGridObj.setCell(rowid, 'dec_sub_att', decSubAtt + gubun + objfile.rows[0].dec_sub_att);
// 			opener.jqGridObj.setCell(rowid, 'dec_sub_att_name', decSubAttName + gubun + name);
// 			opener.jqGridObj.setCell(rowid, 'dec_sub_att', decSubAtt + gubun + objfile.rows[0].dec_sub_att);
			
			if(args.jqGridObj.getCell(rowid, 'oper') == '') {
				args.jqGridObj.setCell(rowid, 'oper', 'U');	
// 				opener.jqGridObj.setCell(rowid, 'oper', 'U');	
			}
         },
         onQueueComplete : function(file) {
        	 
        	 var args = window.dialogArguments;
        	 
     		 args.$( "#btnSave" ).removeAttr( "disabled" );
     		 args.$( "#btnSave" ).removeClass( "btn_disable" );
     		 args.$( "#btnSave" ).addClass( "btn_blue2" );
     		 
        	 self.close();
         }
	});
}); //function end

var jqGridObj = $('#jqGridList');

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'DOC ID', name:'document_id', index:'document_id', width:20, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'FILE NAME', name:'document_name', index:'document_name', width:100, align:'center', sortable:false, formatter: fileFormatter});
	gridColModel.push({label:'OPTION', name:'delete_file', index:'delete_file', width:20, align:'center', sortable:false, formatter: fileDelFormatter});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	
	if( $("#edit_enable_flag").val() != "Y" ){
		fn_buttonDisabled2([ "#btnExlUp" ]);
		$("#fileName").hide();
	}
	
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'popUpCommentCommentAttachList.do',
	    postData : fn_getFormData('#application_form'),
	    colModel:gridColModel,
	    gridview: true,
	    multiselect: false,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    height: 300,
	    cellEdit : true,
        pgbuttons : false,
        pgtext : false,
        pginput : false,
        cellsubmit : 'clientArray', // grid edit mode 2
	    scrollOffset : 17,
	    shrinkToFit:true,
	    pager: $('#btnjqGridList'),
	    //rowList:[100,500,1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum:100, 
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
				
	 	},	
		onCellSelect : function( rowid, iCol, cellcontent, e ) {

		},
		 afterSaveCell : chmResultEditEnd
	}); //end of jqGrid
	
	
	//Close 버튼 클릭.
	$("#btnClose").click(function(){
		self.close();
	});
	
	$("#btnExlUp").click(function(){
		
		$('#fileName').uploadify('upload','*');
        alert("새로 업로드 한 문서는 SAVE 버튼을 눌러야만 저장됩니다.");
    });

});	//ready function end

//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
	
	var item = jqGridObj.jqGrid( 'getRowData', irow );
	
	if (item.oper != 'I')
		item.oper = 'U';

	jqGridObj.jqGrid( "setRowData", irow, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
	if(val == null) val = "";
	//입력 후 대문자로 변환
	jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
}

function fileFormatter(cellvalue, options, rowObject ) {
	if(cellvalue == null) {
		return '';		
	} else {
		return "<a href=\"#none\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('"+rowObject.document_id+"');\">" + cellvalue + "</a>";					
	}
}

function fileView(document_id) {
	var attURL = "commentSendFileView.do?";
    attURL += "p_document_id="+document_id;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
    window.open(attURL,"",sProperties);

}

function fileDelFormatter(cellvalue, options, rowObject ) {
	
	var disabled = '';
	
	if($("#edit_enable_flag").val() != 'Y') {
		disabled = "disabled=\"disabled\"";
	} 
	
	return "<a href=\"#none\" style=\"cursor:pointer;vertical-align:middle;\" " + disabled + "onclick=\"fileDelete('"+rowObject.document_id+"');\">" + cellvalue + "</a>";			
}

function fileDelete(document_id) {
	var url = 'commentSendFileDelete.do?p_document_id=' + document_id;
	var formData = fn_getFormData( '#application_form' );
	var parameters = $.extend( {}, {}, formData );
	var args = window.dialogArguments;
	
	if( $("#view_flag").val() == "N" ){
		alert("삭제가 불가능한 문서 입니다. 부서권한과 VIEW FLAG를 확인해 주세요.");
		return;
	}
	
	$.post( url, parameters, function( data ) {
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
			fn_search();
			args.fn_search();
		}
	}, "json").error( function() {
		alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
	} ).always( function() {

	} );
}

function fn_search() {
	var sUrl = "popUpCommentCommentAttachList.do";
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		//rowNum : pageCnt,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
}
</script>
</body>
</html>