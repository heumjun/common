<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%
    String selectedDate = request.getParameter("selDate");
    int    selYear  = 0;
    int    selMonth = 0;
    int    selDay   = 0;
    
    if(selectedDate==null || "".equals(selectedDate))
    {
    	Calendar toDate = Calendar.getInstance();
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	String toDay = sdf.format(toDate.getTime());
    	selectedDate = 	toDay;
    }
    
    if (selectedDate.length() > 8 ){
        selYear  = Integer.parseInt(selectedDate.substring(0,4));
        selMonth = Integer.parseInt(selectedDate.substring(5,7));
        selDay   = Integer.parseInt(selectedDate.substring(8,10));
    }else if (selectedDate.length() <= 8 && selectedDate.length() > 0) {
        selYear  = Integer.parseInt(selectedDate.substring(0,4));
        selMonth = Integer.parseInt(selectedDate.substring(4,6));
        selDay   = Integer.parseInt(selectedDate.substring(6,8));
    }
    
    String strFormName = request.getParameter("strFormName");
    String strInputName = request.getParameter("strInputName");

%>
<html>
<head>
<title>DIS - Calendar</title>
<link href='stxship.css' rel='stylesheet' type='text/css'>
</head>
<!--달력입니다.-->
<script language="JavaScript">

    var title = "날짜를 선택하세요";
    var gcGray = "#d5d5d5"; //"#808080"; gray가 너무진해서... 엷게..
    var gcToggle = "#e5e5e5";
    var gcBG = "#ffffff";
    var newGcBG = "#EFEFEF";

    var giYear = new Date().getYear();
    var giMonth = new Date().getMonth() + 1;
    var giDay   = new Date().getDate();
    if ("<%=selectedDate%>".length > 0){
        giYear  = "<%=selYear%>";
        giMonth = "<%=selMonth%>";
        giDay   = "<%=selDay%>";
    }


    // 초기 Setting.
    function onstart() {
        fSetYearMon(giYear, giMonth);
    }


    // 년월일 포맷을 만들고 parent 창으로 날짜를 넘김.
    function fSetDate(iYear, iMonth, iDay){
        iMonth = gn_lpad(iMonth,0,2);
        iDay   = gn_lpad(iDay,0,2);
        //parent.window.returnValue=iYear+"-"+iMonth+"-"+iDay;
		parent.window.opener.document.<%=strFormName%>.<%=strInputName%>.value = iYear+"-"+iMonth+"-"+iDay;        
        window.close();
    }

    // 기존에 선택한 날짜 삭제.
    function fYMReset(){
        window.returnValue="";
        window.close();
    }


    function gn_lpad(Rstring,pad_str,base_len){
        var Rstring = Rstring.toString();
        var str_len = Rstring.length;

        for(var i=str_len; i<= base_len; i++){
            if (str_len != base_len)  {
                Rstring = pad_str + Rstring;
                str_len = Rstring.length;
            }
        }

        return Rstring;
    }


    // 날짜 클릭했을 경우(선택)
    function fSetSelected(aCell){
        var iOffset = 0;
        var iYear = document.all.selectedYear.value;
        var iMonth = document.all.selectedMonth.value;

        aCell.bgColor = gcBG;
        with (aCell.children["cellText"]){
            var iDay = parseInt(innerText);
            if (color==gcGray){
                return;
            }

            if (iMonth<1) {
                iYear--;
                iMonth = 12;
            }else if (iMonth>12){
                iYear++;
                iMonth = 1;
            }
      }

      fSetDate(iYear, iMonth, iDay);
    }


    //날짜 format 만들기
    function fBuildCal(iYear, iMonth) {
        var aMonth=new Array();
        for(i=1;i<7;i++)
            aMonth[i]=new Array(i);

        var dCalDate=new Date(iYear, iMonth-1, 1);
        var iDayOfFirst=dCalDate.getDay();
        var iDaysInMonth=new Date(iYear, iMonth, 0).getDate();
        var iOffsetLast=new Date(iYear, iMonth-1, 0).getDate()-iDayOfFirst+1;
        var iDate = 1;
        var iNext = 1;

        for (d = 0; d < 7; d++)
              aMonth[1][d] = (d<iDayOfFirst)?-(iOffsetLast+d):iDate++;
        for (w = 2; w < 7; w++)
                for (d = 0; d < 7; d++)
                      aMonth[w][d] = (iDate<=iDaysInMonth)?iDate++:-(iNext++);
        return aMonth;
    }


    // 달력 Drawing
    function fDrawCal(iYear, iMonth, iCellWidth, iDateTextSize) {
        var WeekDay = new Array("<img src='images/main_cal_sun.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_mon.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_tue.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_wed.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_thu.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_fri.gif' width='20' height='12'>",
                                 "<img src='images/main_cal_sat.gif' width='20' height='12'>");
        var styleTD = " bgcolor='"+gcBG+"' width='"+iCellWidth+"' bordercolor='"+gcBG+"' valign='middle' align='center' "+iDateTextSize+" Courier;";
        var style_class;
        with (document) {
           
            write("<tr height='21' align='center' class='bg_white'>");
            for(i=0; i<7; i++){
                //요일별 css 적용.
                if (i == 0){
                    write("<td width='21' height='25' class='calendar_week_sun'>" + WeekDay[i] + "</td>");
                }else if(i == 6) {
                    write("<td width='21' height='25' class='calendar_week_sat'>" + WeekDay[i] + "</td>");
                }else{
                    write("<td width='21' height='25' class='calendar_week'>" + WeekDay[i] + "</td>");
                }

            }
            write("</tr>");
            
              
            for (w = 1; w < 7; w++) {
                write("<tr height='21' align='center' class='bg_white'>");
                for (d = 0; d < 7; d++) {
                    if (i == 0){
                        style_class = "calendar_sun";
                    }else if(i==6){
                        style_class = "calendar_sat";
                    }else{
                        style_class = "calendar_num";
                    }
                    write("<td id='calCell' class='" + style_class + "' style='cursor:hand' onMouseOver=this.style.backgroundColor='#EFEFEF' onmouseout=this.style.backgroundColor='FFFFFF' onclick='fSetSelected(this)'>");
                    write("<font id=cellText> </font>");
                    write("</td>")
                }
                write("</tr>");
            }
        }
    }


    // 날짜 setting
    function fUpdateCal(iYear, iMonth) {
        var tdToday = eval("document.all.calCell");
        myMonth = fBuildCal(iYear, iMonth);
        var i = 0;
        var grayCnt = 0;
        //alert("grayCnt1:"+grayCnt);
        for (w = 0; w < 6; w++)
            for (d = 0; d < 7; d++)
                with (cellText[(7*w)+d]) {
                    Victor = i++;
                    if (myMonth[w+1][d]<0) {
                        color = gcGray;
                        
                        innerText = -myMonth[w+1][d];
                        //alert(innerText);
                        grayCnt++;
                    }else{
                        // 요일별 날짜 색 Setting(날짜 자체).
                        if (d==0){
                            color = "#A53439";
                        }else if(d==6){
                            color = "#0B4AAA";
                        }else{
                            color = "#111";
                        }
                        //color = ((d==0))?"red":"black";
                        innerText = myMonth[w+1][d];
                        //alert(color);
                        if (giYear==iYear && giMonth==iMonth && myMonth[w+1][d]==giDay){
                            //alert("grayCnt2:"+grayCnt);
                            //alert("iYear:"+iYear);
                            //alert("iMonth:"+iMonth);
                            //tdToday[myMonth[w+1][d]-1].background-color="#CBBAD4";
                            tdToday[myMonth[w+1][d]+grayCnt-1].className = "calendar_today";
                            tdToday[myMonth[w+1][d]+grayCnt-1].onmouseover=tdToday[myMonth[w+1][d]+grayCnt-1].style.backgroundColor='';
                            tdToday[myMonth[w+1][d]+grayCnt-1].onmouseout=tdToday[myMonth[w+1][d]+grayCnt-1].style.backgroundColor='';
                        }else{
                            tdToday[myMonth[w+1][d]+grayCnt-1].className = "calendar_num";
                            tdToday[myMonth[w+1][d]+grayCnt-1].onmouseover=tdToday[myMonth[w+1][d]+grayCnt-1].style.backgroundColor='';
                            tdToday[myMonth[w+1][d]+grayCnt-1].onmouseout=tdToday[myMonth[w+1][d]+grayCnt-1].style.backgroundColor='';
                        }

                    }
                }
        // 년도 Setting.
        var sYear           = eval("document.all.sYear");
        var pYear           = eval("document.all.pYear");
        var nYear           = eval("document.all.nYear");


        // 선택한 년월일을 부모창으로 넘기기 위해서..
        var selectedYear    = eval("document.all.selectedYear");
        var selectedMonth   = eval("document.all.selectedMonth");

        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);
        TrMonth.deleteCell(0);


        mon12 = TrMonth.insertCell(document.createElement('<TD>'))
        mon12.style.width = "17";
        mon12.className = "calendar_num";
        mon12.onmouseover=mon12.style.backgroundColor='#D4ECFD';
        if (iMonth==12){
            mon12.onmouseout=mon12.style.backgroundColor='#D4ECFD';
        }else{
            mon12.onmouseout=mon12.style.backgroundColor='';
        }

        mon11 = TrMonth.insertCell(document.createElement('<TD>'))
        mon11.style.width = "21";
        mon11.className = "calendar_num";
        mon11.onmouseover=mon11.style.backgroundColor='#D4ECFD';
        if (iMonth==11){
            mon11.onmouseout=mon11.style.backgroundColor='#D4ECFD';
        }else{
            mon11.onmouseout=mon11.style.backgroundColor='';
        }


        mon10 = TrMonth.insertCell(document.createElement('<TD>'))
        mon10.style.width = "21";
        mon10.className = "calendar_num";
        mon10.onmouseover=mon10.style.backgroundColor='#D4ECFD';
        if (iMonth==10){
            mon10.onmouseout=mon10.style.backgroundColor='#D4ECFD';
        }else{
            mon10.onmouseout=mon10.style.backgroundColor='';
        }

        mon9 = TrMonth.insertCell(document.createElement('<TD>'))
        mon9.style.width = "17";
        mon9.className = "calendar_num";
        mon9.onmouseover=mon9.style.backgroundColor='#D4ECFD';
        if (iMonth==9){
            mon9.onmouseout=mon9.style.backgroundColor='#D4ECFD';
        }else{
            mon9.onmouseout=mon9.style.backgroundColor='';
        }

        mon8 = TrMonth.insertCell(document.createElement('<TD>'))
        mon8.style.width = "17";
        mon8.className = "calendar_num";
        mon8.onmouseover=mon8.style.backgroundColor='#D4ECFD';
        if (iMonth==8){
            mon8.onmouseout=mon8.style.backgroundColor='#D4ECFD';
        }else{
            mon8.onmouseout=mon8.style.backgroundColor='';
        }

        mon7 = TrMonth.insertCell(document.createElement('<TD>'))
        mon7.style.width = "17";
        mon7.className = "calendar_num";
        mon7.onmouseover=mon7.style.backgroundColor='#D4ECFD';
        if (iMonth==7){
            mon7.onmouseout=mon7.style.backgroundColor='#D4ECFD';
        }else{
            mon7.onmouseout=mon7.style.backgroundColor='';
        }

        mon6 = TrMonth.insertCell(document.createElement('<TD>'))
        mon6.style.width = "17";
        mon6.className = "calendar_num";
        mon6.onmouseover=mon6.style.backgroundColor='#D4ECFD';
        if (iMonth==6){
            mon6.onmouseout=mon6.style.backgroundColor='#D4ECFD';
        }else{
            mon6.onmouseout=mon6.style.backgroundColor='';
        }

        mon5 = TrMonth.insertCell(document.createElement('<TD>'))
        mon5.style.width = "17";
        mon5.className = "calendar_num";
        mon5.onmouseover=mon5.style.backgroundColor='#D4ECFD';
        if (iMonth==5){
            mon5.onmouseout=mon5.style.backgroundColor='#D4ECFD';
        }else{
            mon5.onmouseout=mon5.style.backgroundColor='';
        }

        mon4 = TrMonth.insertCell(document.createElement('<TD>'))
        mon4.style.width = "17";
        mon4.className = "calendar_num";
        mon4.onmouseover=mon4.style.backgroundColor='#D4ECFD';
        if (iMonth==4){
            mon4.onmouseout=mon4.style.backgroundColor='#D4ECFD';
        }else{
            mon4.onmouseout=mon4.style.backgroundColor='';
        }

        mon3 = TrMonth.insertCell(document.createElement('<TD>'))
        mon3.style.width = "17";
        mon3.className = "calendar_num";
        mon3.onmouseover=mon3.style.backgroundColor='#D4ECFD';
        if (iMonth==3){
            mon3.onmouseout=mon3.style.backgroundColor='#D4ECFD';
        }else{
            mon3.onmouseout=mon3.style.backgroundColor='';
        }

        mon2 = TrMonth.insertCell(document.createElement('<TD>'))
        mon2.style.width = "17";
        mon2.className = "calendar_num";
        mon2.onmouseover=mon2.style.backgroundColor='#D4ECFD';
        if (iMonth==2){
            mon2.onmouseout=mon2.style.backgroundColor='#D4ECFD';
        }else{
            mon2.onmouseout=mon2.style.backgroundColor='';
        }


        mon1 = TrMonth.insertCell(document.createElement('<TD>'))
        mon1.style.width = "17";
        mon1.className = "calendar_num";
        mon1.onmouseover=mon1.style.backgroundColor='#D4ECFD';
        if (iMonth==1){
            mon1.onmouseout=mon1.style.backgroundColor='#D4ECFD';
        }else{
            mon1.onmouseout=mon1.style.backgroundColor='';
        }


        sYear.innerHTML     = iYear + ". " + iMonth;
        pYear.innerHTML     = "<img src='images/datepicker_last.gif'     style='cursor:hand' onclick='fUpdateCal(" + (Number(iYear)-1) + ", " + iMonth + ")' alt='" + (Number(iYear)-1) + "'>";
        nYear.innerHTML     = "<img src='images/datepicker_nextyear.gif' style='cursor:hand' onclick='fUpdateCal(" + (Number(iYear)+1) + ", " + iMonth + ")' alt='" + (Number(iYear)+1) + "'>";


        mon1.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",1);'>1</a>";
        mon2.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",2);'>2</a>";
        mon3.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",3)'>3</a>";
        mon4.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",4)'>4</a>";
        mon5.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",5)'>5</a>";
        mon6.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",6)'>6</a>";
        mon7.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",7)'>7</a>";
        mon8.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",8)'>8</a>";
        mon9.innerHTML      = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",9)'>9</a>";
        mon10.innerHTML     = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",10)'>10</a>";
        mon11.innerHTML     = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",11)'>11</a>";
        mon12.innerHTML     = "<a href='#' onclick='javascript:fUpdateCal(" + iYear + ",12)'>12</a>";


        selectedYear.value  = iYear;
        selectedMonth.value = iMonth;

    }


    // 년,월 select  setting
    function fSetYearMon(iYear, iMon){
        fUpdateCal(iYear, iMon);
    }


    with(document)
    {


        write("<body onload='onstart();' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>");        
        write("<table width='210' border='0' cellpadding='0' cellspacing='5' class='bg_light'>");
        write("  <tr>");
        write("    <td width='200' align='center' >");

        write("      <table width='200' border='0' cellpadding='1' cellspacing='1' class='calendar_bg_line'>");
        write("        <tr>");
        write("          <td align='center' class='bg_white'>");
        write("            <table width='100%' height='50' border='0' cellpadding='0' cellspacing='0'>");
        write("              <tr>");
        write("                <td height='10' colspan='7' align='center' valign='top'>");
        write("                  <table id='popTable' width='100%' height='24' border='0' cellpadding='0' cellspacing='1' class='calendar_bg_line'>");
        write("                    <tr class='calendar_title_bg'>");
        write("                      <td id='pYear' align='center' class='calendar_title'></td>");
        write("                      <td id='sYear' width='70' align='center' class='calendar_title'></td>");
        write("                      <td id='nYear' align='center' class='calendar_title'></td>");
        write("                    </tr>");
        write("                  </table>");
        write("                </td>");
        write("              </tr>");
        write("              <tr align='center' valign='top'>");
        write("                <td height='10' colspan='7' class='bg_white'>");
        write("                  <table width='200' height='21' border='0' cellpadding='0' cellspacing='1' class='calendar_bg_line'>");
        write("                    <tr id='TrMonth' align='center' class='calendar_title_bg'>");
        write("                      <td id='mon1'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon2'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon3'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon4'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon5'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon6'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon7'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon8'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon9'  width='17' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon10' width='18' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon11' width='18' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                      <td id='mon12' width='18' class='calendar_num' onmouseover=this.style.backgroundColor='#D4ECFD' onmouseout=this.style.backgroundColor=''></td>");
        write("                    </tr>");
        write("                  </table>");
        write("                </td>");
        write("              </tr>");
        write("            </table>");
        write("          </td>");
        write("        </tr>");
        write("        <tr>");
        write("          <td>");
        write("                  <DIV style='width:200;background-color:#DFE2CA;'>");
        write("                  <table width='200' border='0' cellpadding='0' cellspacing='0'>");
                                   fDrawCal(giYear, giMonth, 19, 12);
        write("                  </table>");
        write("                  </DIV>");
        write("          </td>");
        write("        </tr>");
        write("      </TABLE>");
        write("    </td>");
        write("  </tr>");
        write("</table>");

        write("<table width='200' border='0' cellspacing='0' cellpadding='0'>");
        write("  <tr height='7'>");
        write("    <td height='7'></td>");
        write("  </tr>");
        write("  <tr>");
        write("    <td align='right'>");
        write("      <table cellspacing='0' cellpadding='0'>");
        write("        <tr>");
        write("          <td> <input name='ymClear' type='button' class='button' value='Clear'  onMouseOver=this.style.color='#650000' onMouseOut=this.style.color='#202020' onclick='fYMReset()'>");
        write("          </td>");
        write("          <td width='1'></td>");
        write("        </tr>");
        write("      </table></td>");
        write("  </tr>");
        write("  <tr>");
        write("    <td height='7' align='right'>&nbsp;</td>");
        write("  </tr>");
        write("</table>");

        write("<input type='hidden' name='selectedYear'>");
        write("<input type='hidden' name='selectedMonth'>");
        write("</body>");
        write("</html>");
        
        
    }

</script>
