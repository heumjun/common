<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>상세현황</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
	a:link {
		color: blue;
	}
	a:hover {
		color: blue;
	}
	a:visited {
		color: blue;
	}
</style>
<script type="text/javascript">

var menuId = '';

$(function () {
	
	getAjaxHtml($("#p_team_code"),"commentSelectBoxTeamList.do?sb_type=all&p_query=getCommentChartTeamList&p_team_code=${p_team_code}", null, null);
	
	setTimeout(function() {
		if($("#p_team_code").val() != '' && $("#p_team_code").val() != 'ALL') partChange();
		fn_search();
	}, 500);
	
});

//AutoComplete 도면리스트 받기
/* var getDwgNos = function() {
	if($("input[name=p_project_no]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		getAjaxTextPost(null, "pendingAutoCompleteDwgNoList.do?p_project_no=" + $("input[name=p_project_no]").val(), null, getdwgnoCallback);
	}
} */

//도면번호 받아온 후
/* var getdwgnoCallback = function(txt){
	var arr_txt = txt.split("|");
    $("#p_dwg_no").autocomplete({
		source: arr_txt,
		minLength:1,
		matchContains: true, 
		max: 30,
		autoFocus: true,
		selectFirst: true,
		open: function () {
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
		},
		close: function () {
		    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
	    }
	});
} */

function partChange() {
	
	var p_team_code = $("#p_team_code").val();
	if(p_team_code == null) {
		p_team_code = '';
	}
	
	getAjaxHtml($("#p_part_code"),"commentSelectBoxPartList.do?sb_type=all&p_part_code=${p_part_code}&p_team_code=" + p_team_code, null, null);
}

function userChange() {
	
	var p_part_code = $("#p_part_code").val();
	if(p_part_code == null) {
		p_part_code = '';
	}
	
	getAjaxHtml($("#p_user"),"commentSelectBoxUserList.do?sb_type=all&p_part_code=" + p_part_code, null, null);
	getAjaxHtml($("#p_dwg_no"),"commentSelectBoxDwgNoList.do?sb_type=all&p_part_code=" + p_part_code, null, null);
}

function fn_search() {
	
	var project_no = $("#p_project_no").val();
	if(project_no != '') {
		project_no = project_no.toUpperCase();
	}
	var p_dwg_no = $("#p_dwg_no").val();
	if(p_dwg_no != '') {
		p_dwg_no = p_dwg_no.toUpperCase();
	}
	var p_team_code = $("#p_team_code").val();
	if(p_team_code == null) {
		p_team_code = '';
	}
	var p_part_code = $("#p_part_code").val();
	if(p_part_code == null) {
		p_part_code = '';
	}
	var p_user = $("#p_user").val();
	if(p_user == null) {
		p_user = '';
	}
	
	$.getJSON('commentChartDetailList.do?p_project_no=' + project_no + '&p_dwg_no=' + p_dwg_no + '&p_team_code=' + p_team_code + '&p_part_code=' + p_part_code + '&p_user=' + p_user + '&p_status=' + $("#p_status").val(), function (data) {
		makeTable(data);
	});
}


$(document).ready(function () {
	
	$("#btnSearch").click(function(){
		
		fn_search();
		
	});
	
});

//동적 테이블 구성
function makeTable(chartData) {
	
	// id가 itemTable인 div 에 var itemTable 을 대입한다.
	var itemTable = $("#itemTable");
	
	// itemTable 하위 테이블 초기화
	$("#itemTable table").remove();
	
	if(chartData.length > 0) {
	
		//  itemTable 에 $("<table>") 를 추가
	    var makeTable = $("<table>").appendTo(itemTable); 
	    makeTable.css({"border-collapse": "collapse", "border": "1px #999999 solid", "height" : "20px"});
    
    	var makeTr = $("<tr>").appendTo(makeTable);
    	var makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("PROJECT");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("DWG NO");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("선주/선급");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("부서");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("파트");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("담당자");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        makeTh = $("<th colspan=4>").appendTo(makeTr);
        makeTh.html("OEPN");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FDE9D9"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("CLOSED");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#B8CCE4"});
        
    	
    	makeTr = $("<tr>").appendTo(makeTable);
        makeTh = $("<th>").appendTo(makeTr);  
        makeTh.html("NO_REPLY");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#E26B0A"});
        makeTh = $("<th>").appendTo(makeTr);  
        makeTh.html("NOTICE");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#F09661"});
        makeTh = $("<th>").appendTo(makeTr);  
        makeTh.html("PROGRESS");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FCD5B4"});
        makeTh = $("<th>").appendTo(makeTr);  
        makeTh.html("TOTAL");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FDE9D9"});

        //테이블 데이터 바인딩
        $.each(chartData, function (index, row) {
	    	var makeTr = $("<tr>").appendTo(makeTable);
	    	
	    	/* var makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['project_no'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" }); */
	    	var makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['project_no'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( "<a href=\"javascript:goComment('" + row['project_no'] + "','" +row['dwg_no']+ "','" +row['issuer']+ "');\"> " + row['dwg_no'] + "</a>" );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	if(row['issuer'] == 'O') {
	    		makeTd.html( "BUYER" );
	    	} else  {
		    	makeTd.html( "CLASS" );
	    	}
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['team'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['part'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['user_name'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });

	    	//NO_REPLY ~ PROGRESS
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['no_reply_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['notice_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['progress_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['open_total_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['close_flag_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	
	    });
	
    }
	
}

//Comment 버튼 클릭 시
function goComment(projectNo, dwgNo, issuer) {
	
	getMenuId("comment.do", callback_MenuId);
	
	var rs = window.open("comment.do?p_project_no=" + projectNo + "&p_dwg_no=" + dwgNo + "&p_issuer=" + issuer + "&menu_id="+menuId, "", "height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
	
}

var callback_MenuId = function(menu_id) {
	menuId = menu_id;
}

</script>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		상세현황
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
		<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	
	<table class="searchArea conSearch">
		<tr>
			<th style="width: 80px;">호선</th>
			<td style="width: 70px;">
				<input type="text" name="p_project_no" id="p_project_no" value="${p_project_no }" style="width:60px;"/>
			</td>
			<th style="width: 80px;">DWG</th>
			<td style="width: 130px;">
				<input type="text" name="p_dwg_no" id="p_dwg_no" value="" style="width:90px;"/>
			</td>
			<th style="width: 80px;">팀</th>
			<td style="width: 130px;">
				<select name="p_team_code" id="p_team_code" value="" style="width:120px;" onchange="partChange();">
        		</select>
			</td>
			<th style="width: 80px;">파트</th>
			<td style="width: 130px;">
				<select name="p_part_code" id="p_part_code" value="" style="width:120px;" onchange="userChange();">
        		</select>
			</td>
			<th style="width: 80px;">담당자</th>
			<td style="width: 100px;">
				<select name="p_user" id="p_user" value="" style="width:90px;">
        		</select>
			</td>
			<th style="width: 80px;">STATUS</th>
			<td style="width: 100px;">
				<select name="p_status" id="p_status" value="" style="width:90px;">
					<option value="">ALL</option>
					<option value="open">OPEN</option>
					<option value="reply">REPLY</option>
					<option value="notice">NOTICE</option>
					<option value="progress">PROGRESS</option>
					<option value="closed">CLOSED</option>
        		</select>
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<!-- <span class="totalEaArea" style="padding-left:5px; padding-right:5px; margin-left:10px">
						총건수(선주/선급)
					</span> -->
					<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				</div>
			</td>
		</tr>
	</table>
	
	<div id="underDiv" style="position:relative; width: 100%;  height: 715px; overflow-y: auto; overflow-x: hidden;">
		<fieldset style="border:none">
		<!-- <legend style="width:99.9%; background-color:#CCC0DA; color:#333333; border:1px solid #999999; height:20px; text-align:center; font-size: 12px; font-weight: bold; padding-top: 5px;">통계</legend> -->
			<div id="itemTable"></div>
		</fieldset>
	</div>
	
</div> 
</body>
</html>