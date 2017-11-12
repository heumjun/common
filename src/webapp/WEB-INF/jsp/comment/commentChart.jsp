<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>집계현황</title>
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
<script type="text/javascript" src="/amcharts/amcharts.js"></script>
<script type="text/javascript" src="/amcharts/serial.js"></script>
<script type="text/javascript">

var chart;
var graph;

$(function () {
	
	// 초기 차트 구성
	createChart();
	
	$( "#p_start_date, #p_end_date" ).datepicker({
    	dateFormat: 'yy-mm-dd',
    	prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년'				    	
  	});
	
});

// 차트 구성 함수
function createChart() {
	
	// SERIAL CHART
	chart = new AmCharts.AmSerialChart();
	//chart.dataProvider = chartData;
	chart.categoryField = "team";
	chart.plotAreaBorderAlpha = 0.6;
	chart.depth3D = 25;
    chart.angle = 30;
	
	// AXES
	// category
	var categoryAxis = chart.categoryAxis;
	categoryAxis.gridAlpha = 0.1;
	categoryAxis.axisAlpha = 0;
	categoryAxis.gridPosition = "start";

	// value
	var valueAxis = new AmCharts.ValueAxis();
	valueAxis.stackType = "regular";
	valueAxis.gridAlpha = 0.1;
	valueAxis.axisAlpha = 0;
	chart.addValueAxis(valueAxis);
	
	// GRAPHS
	// first graph
	var graph = new AmCharts.AmGraph();
	graph.title = "NO REPLY";
	graph.labelText = "[[value]]";
	graph.valueField = "no_reply_cnt";
	graph.type = "column";
	graph.lineAlpha = 0;
	graph.fillAlphas = 1;
	graph.lineColor = "#E26B0A";
	graph.fixedColumnWidth = 50;
	graph.balloonText = "<span style='color:#555555;'>[[category]]</span><br><span style='font-size:14px'>[[title]]:<b>[[value]]</b></span>";
	chart.addGraph(graph);
      
	// second graph
	var graph = new AmCharts.AmGraph();
	graph.title = "NOTICE";
	graph.labelText = "[[value]]";
	graph.valueField = "notice_cnt";
	graph.type = "column";
	graph.lineAlpha = 0;
	graph.fillAlphas = 1;
	graph.lineColor = "#F09661";
	graph.fixedColumnWidth = 50;
	graph.balloonText = "<span style='color:#555555;'>[[category]]</span><br><span style='font-size:14px'>[[title]]:<b>[[value]]</b></span>";
	chart.addGraph(graph);
      
	graph = new AmCharts.AmGraph();
	graph.title = "PROGRESS";
	graph.labelText = "[[value]]";
	graph.valueField = "progress_cnt";
	graph.type = "column";
	graph.lineAlpha = 0;
	graph.fillAlphas = 1;
	graph.lineColor = "#FCD5B5";
	graph.fixedColumnWidth = 50;
	graph.balloonText = "<span style='color:#555555;'>[[category]]</span><br><span style='font-size:14px'>[[title]]:<b>[[value]]</b></span>";
	chart.addGraph(graph);
	
	graph = new AmCharts.AmGraph();
	graph.title = "CLOSED";
	graph.labelText = "[[value]]";
	graph.valueField = "close_flag_cnt";
	graph.type = "column";
	graph.lineAlpha = 0;
	graph.fillAlphas = 1;
	graph.lineColor = "#95B3D7";
	graph.fixedColumnWidth = 50;
	graph.balloonText = "<span style='color:#555555;'>[[category]]</span><br><span style='font-size:14px'>[[title]]:<b>[[value]]</b></span>";
	graph.hidden = true;
	chart.addGraph(graph);

	// LEGEND
	var legend = new AmCharts.AmLegend();
	legend.borderAlpha = 0.2;
	legend.horizontalGap = 10;
	chart.addLegend(legend);
	    
	// SCROLLBAR
	/* var chartScrollbar = new AmCharts.ChartScrollbar();
	chartScrollbar.graph = graph;
	chartScrollbar.backgroundColor = "#DDDDDD";
	chartScrollbar.scrollbarHeight = 30;
	chartScrollbar.selectedBackgroundColor = "#FFFFFF";
	chart.addChartScrollbar(chartScrollbar); */
	
	// WRITE
	chart.write("chartdiv");
            
}

function requiredCheck() {
	
	var project_no = $("#project_no").val();
	if(project_no != '') {
		project_no = project_no.toUpperCase();
	}
	
	var p_start_date = $("#p_start_date").val();
	if(p_start_date == null) {
		p_start_date = '';
	}
	
	var p_end_date = $("#p_end_date").val();
	if(p_end_date == null) {
		p_end_date = '';
	}
	
	if(project_no != '') {
		
		$("#p_start_date").removeClass();
		$("#p_end_date").removeClass();
		
		if(p_start_date != '' && p_start_date != '') {
			//$("#project_no").removeClass();
		} else {
			$("#project_no").addClass("required");
		}
		
	} else {
		
		$("#p_start_date").addClass("required");
		$("#p_end_date").addClass("required");
		
		if(p_start_date != '' && p_start_date != '') {
			$("#project_no").removeClass();
		} else {
			$("#project_no").addClass("required");
			$("#p_start_date").addClass("required");
			$("#p_end_date").addClass("required");
		}
	}
}

$(document).ready(function () {
	
	$("#btnSearch").click(function(){
		
		var rtn = true;
		
		var project_no = $("#project_no").val();
		if(project_no != '') {
			project_no = project_no.toUpperCase();
		}
		var p_team = $("#p_team").val();
		if(p_team == null) {
			p_team = '';
		}
		
		var p_start_date = $("#p_start_date").val();
		if(p_start_date == null) {
			p_start_date = '';
		}
		
		var p_end_date = $("#p_end_date").val();
		if(p_end_date == null) {
			p_end_date = '';
		}
		
		if(project_no == '') {
			if(p_start_date == '' && p_end_date == '') {
				alert('호선 또는 기간 중 하나는 필수 입력값 입니다.');
				rtn = false;
			} 
		} 
		
		if(!rtn) {
			return false;
		}
		
		// ajax로 데이터를 받아와서 차트에 데이터를 업데이트 합니다.
		$.getJSON('commentChartList.do?p_project_no=' + project_no + '&p_team=' + p_team + '&p_start_date=' + p_start_date + '&p_end_date=' + p_end_date, function (data) {
			
			if (document.getElementById("gubun2").checked) {
				
				var dataList = new Array() ;
				
				for(i=0; i < data.length; i++) {
					
					var myObject = new Object(); 
					
					if(data[i].gubun == "P") {
						myObject.team = data[i].team;
						myObject.total_cnt = data[i].total_cnt;
						myObject.user_cnt = data[i].user_cnt;	
						myObject.dwg_cnt = data[i].dwg_cnt;	
						myObject.not_comment_cnt = data[i].not_comment_cnt;	
						myObject.no_reply_cnt = data[i].no_reply_cnt;	
						myObject.notice_cnt = data[i].notice_cnt;	
						myObject.progress_cnt = data[i].progress_cnt;	
						myObject.open_total_cnt = data[i].open_total_cnt;	
						myObject.close_flag_cnt = data[i].close_flag_cnt;
						
						dataList.push(myObject) ;
					}
				}
				
				chart.dataProvider = dataList;
				
			} else {
				chart.dataProvider = data;   
			}
			
	    	chart.validateData();
	    	makeTable(data);
		});
		
	});
	
});

//this method sets chart 2D/3D
function setDepth() {
    if (document.getElementById("rb1").checked) {
        chart.depth3D = 0;
        chart.angle = 0;
    } else {
        chart.depth3D = 25;
        chart.angle = 30;
    }
    chart.validateNow();
}

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
    	/* var makeTh = $("<th rowspan=3>").appendTo(makeTr);
        makeTh.html("PROJECT");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"}); */
        var  makeTh = $("<th rowspan=3>").appendTo(makeTr);
        makeTh.html("부서명");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FFFF00"});
        /*makeTh = $("<th colspan=4>").appendTo(makeTr);
        makeTh.html("수신문서현황");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#C0C0C0"});*/
        makeTh = $("<th colspan=5>").appendTo(makeTr);
        makeTh.html("COMMENT 현황");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#D8E4BC"});
        
        makeTr = $("<tr>").appendTo(makeTable);
        /*makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("수신문서<br>총건수");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#C0C0C0"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("담당자<br>미지정");
        makeTh.css({"width": "65px", "color": "red", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#C0C0C0"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("DWG<br>미지정");
        makeTh.css({"width": "65px", "color": "red", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#C0C0C0"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("COMMENT<br>미지정");
        makeTh.css({"width": "65px", "color": "red", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#C0C0C0"});*/
        makeTh = $("<th colspan=4>").appendTo(makeTr);
        makeTh.html("OPEN");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#FDE9D9"});
        makeTh = $("<th rowspan=2>").appendTo(makeTr);
        makeTh.html("CLOSED");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px", "backgroundColor": "#B8CCE4"});
    	
    	makeTr = $("<tr>").appendTo(makeTable);
        /* makeTh = $("<th>").appendTo(makeTable);  
        makeTh.html("COMMENT미등록");
        makeTh.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px"}); */
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
	    	
	    	if(row['gubun'] == 'P' ) {
	    		makeTd.html( row['team']);
	    	} else {
		    	makeTd.html( "<a href=\"javascript:popupCommentChartDetail('" + row['team_code'] + "');\"> " + row['team'] + "</a>");
	    	}
	    	
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	
	    	//수신문서 ~ DWG
	    	/*makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['total_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['user_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['dwg_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });
	    	makeTd = $("<td>").appendTo(makeTr);
	    	makeTd.html( row['not_comment_cnt'] );
	    	makeTd.css({"width": "65px", "border-collapse": "collapse", "border": "1px #999999 solid", "text-align" : "center", "height" : "20px" });*/
	    	
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

function setGubun() {
    if (document.getElementById("gubun1").checked) {
		$("#p_team").hide();
		$('#divOutputWindow').css('width','120px');
		$("#p_team").val("");
    } else {
		$("#p_team").show();
		getAjaxHtml($("#p_team"),"commentSelectBoxTeamList.do?sb_type=N&p_query=getCommentChartTeamList&p_team_code=", null, null);
		$('#divOutputWindow').css('width','200px');
		
    }
//    chart.validateNow();
}

function popupCommentChartDetail(team_code, part_code) {

	var sURL = "commentChartDetail.do?p_project_no=" + $('#project_no').val() + "&p_team_code=" + team_code + "&p_part_code=" + part_code;
	var popOptions = "width=1500, height=800, resizable=yes, scrollbars=no, status=no";

	var popupWin = window.open(sURL, "popupCommentChartDetail", popOptions);
	setTimeout(function() {
		rs = popupWin.focus();
	}, 500);
	
}
</script>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		집계현황
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
		<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	
	<table class="searchArea conSearch">
		<tr>
			<th style="width: 80px;">호선</th>
			<td style="width: 70px;">
				<input type="text" name="project_no" id="project_no" class="required" value="" style="width:60px;" onchange="requiredCheck();" onkeyup="requiredCheck();"/>
			</td>
			<th style="width: 80px;">기간</th>
			<td style="width: 180px;">
				<input type="text" name="p_start_date" id="p_start_date" style="width:70px;" class="required" value="" onchange="requiredCheck();" onkeyup="requiredCheck();" /> ~ <input type="text" name="p_end_date" id="p_end_date" style="width:70px;" class="required" value="" onchange="requiredCheck();" onkeypress="requiredCheck();"/>
			</td>
			<th style="width: 80px;">구분</th>
			<td id="divOutputWindow"  style="width: 120px;">
				<input type="radio" checked="true" name="gubun" id="gubun1" onclick="setGubun()">팀 &nbsp;&nbsp;
        		<input type="radio" name="gubun" id="gubun2" onclick="setGubun()">파트
        		<select name="p_team" id="p_team" value="" class="required" style="width:120px; display: none; ">
        		</select>
			</td>
			<th style="width: 80px;">VIEW</th>
			<td style="width: 120px;">
				<input type="radio" name="group" id="rb1" onclick="setDepth()">2D &nbsp;&nbsp;
        		<input type="radio" checked="true" name="group" id="rb2" onclick="setDepth()">3D
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				</div>
			</td>
		</tr>
	</table>
	
	<div id="chartdiv" style="width: 100%; height: 400px;"></div>
	<br />
	<div id="underDiv" style="position:absolute; width: 95%; left:3%; height: 390px; overflow-y: auto; overflow-x: hidden;">
		<fieldset style="border:none">
		<!-- <legend style="width:99.9%; background-color:#CCC0DA; color:#333333; border:1px solid #999999; height:20px; text-align:center; font-size: 12px; font-weight: bold; padding-top: 5px;">통계</legend> -->
			<div id="itemTable"></div>
		</fieldset>
	</div>
	
</div> 
</body>
</html>