var MenuWidth  = 184;
var MenuHeight = 185;
var menuDelay  = 50;	// delay before menu appears
var menuSpeed  = 5;		// speed which menu appears (lower=faster)
var menuOffset = 2;		// offset of menu from mouse pointer
var objTxt     = null;
var objImg     = null;
var txtName    = "";
var imgName    = "";
var PubDesc    = new init();
var ctime      = "";

// get current date
var NowDate  = new Date();
var DefYear  = NowDate.getYear();
if (DefYear < 1900) DefYear = DefYear+1900;
var DefMonth = return0(NowDate.getMonth()+1);
var DefDate  = return0(NowDate.getDate());
var dtype    = "YYYY-MM-DD";
var strLang  = "";
var month_name = new Array('01','02','03','04','05','06','07','08','09','10','11','12');
var day_name = new Array('Wk','Mo','Tu','We','Th','Fr','Sa','Su');
var isSelect = 0;
var menuPopup;

function popCal(argjTxtObj, argjImgName)
{
	this.objTxt  = argjTxtObj;
	this.txtName = argjTxtObj.name;
	this.imgName = argjImgName;

	if (!(objTxt.value == null || objTxt.value == ""))
	{
		DefYear  = eval(CDRemString(objTxt.value,"-").substring(0,4));
		DefMonth = eval(CDRemString(objTxt.value,"-").substring(4,6));
		DefDate  = eval(CDRemString(objTxt.value,"-").substring(6,8));
	}

	showCalendarPopup(DefYear, DefMonth, DefDate);
}

function showCalendarPopup(argYear, argMonth, argDate)
{
	makeCalendar(argYear, argMonth, argDate);

	/* 출하검사 oqc390 -> Div 에 쌓인 입력화면 때문에 수정. 2004/12/10
	   달력에 onClick 이벤트 걸때, 이미지 이름을 공백으로 넣으면, 이벤트 발생한 곳의 위치로
	   달력을 보여준다. */
	if(imgName == "" || imgName == null)
	{
		if(event != null)
		{
			menuXPos = event.clientX - MenuWidth - 10;
			menuYPos = event.clientY + 10;
		}
	}
	else
	{
		objImg = document.getElementById(imgName);

		menuXPos = (getX(objImg) + 10) - MenuWidth;
		menuYPos = getY(objImg) + 20;
	}
	// 수정 끝.

	menuXIncrement = MenuWidth / menuSpeed;
	menuYIncrement = MenuHeight / menuSpeed;

	menuTimer = setTimeout("openMenu(0,0)", menuDelay);
	return false;
}
function CDRemString(strjArg, strjArgRemString)
{
	var strjRtn   = "";
	var strjTemp  = "";
	for (var i=0; i<strjArg.length; i++)
	{
		strjTemp = "" + strjArg.substring(i, i+1);
		if (strjTemp.indexOf(strjArgRemString) == -1)
		{
			strjRtn += strjTemp;
		}
	}

	return strjRtn;
}
//draw calendar UI
function makeCalendar(argYear, argMonth, argDate)
{
	var curBkCol = "";
	var str      = "";
	var first    = "";
	var aMonth   = new Array();
	for (var i=0; i<7; i++)
	{
		aMonth[i] = [0,0,0,0,0,0,0,0,0];
	}
	var myDay = 1;
	var week  = 0;
	var day_num = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

	var y = parseInt(argYear, 10);
	var m = parseInt(argMonth, 10);
	var d = parseInt(argDate, 10);

	if (m == 0)
	{
		y = y-1;
		m = 12;
	}
	else if (m == 13)
	{
		y = y+1;
		m = 1;
	}

	if (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0))
	{
		day_num[1] = 29;
	}

	first = new Date(y, m-1, 1);
	firstday = (first.getDay()+1)==1?8:(first.getDay()+1);	// 해당월 첫째날의 요일(일:8, 월:2, 화:3, 수:4, 목:5, 금:6, 토:7)
	DaysInMonth = day_num[m-1];

	if ((m-2) == -1)
	{
		DaysInBefMonth = day_num[11];
	}
	else
	{
		DaysInBefMonth = day_num[m-2];
	}

	if (d > DaysInMonth)
	{
		day = DaysInMonth;
	}
	else
	{
		day = d;
	}

	//해당년의 1월1일을 검사(예:1월1일이 목요일(4)부터 시작하면 그 전년12월마지막주로 따라감)
	if (getDayInWeek(y, 1, 1) > 5)
	{
		// 1월1주가 빠지므로 모두 1을 뺌
		week = getWeekOfDayInMonth(day_num, y, m, 1) - 1;
	}
	else
	{
		week = getWeekOfDayInMonth(day_num, y, m, 1);
	}

	// 해당월의 1일이 일요일이면 전달 마지막주로 따라감 (수정여부가 남아있음)
//	if (firstday == 8)
//	{
//		week = week - 1;
//	}
//alert(week);
	// 월의 첫번째주만을 따로 저장한다.
	for (var i=firstday; i<=8; i++)
	{
		aMonth[1][1] = week;
		aMonth[1][i] = myDay;
		myDay++;
	}

	week++;

	// 월의 2번째 부터 마지막 주까지 저장
	for(var i=2; i<7; i++)
	{
		aMonth[i][1] = week;

		for (var j=2; j<=8; j++)
		{
			if (myDay <= DaysInMonth)
			{
				aMonth[i][j] = myDay;
			}
			myDay++;
		}
		week++;
	}

	str += "<HTML><HEAD>\n";
	str += "<LINK REL='stylesheet' HREF='/css/calendarDate.css' TYPE='text/css'>\n";
	str += "</HEAD><BODY>\n";
	str += "<CENTER>\n";
	str += "<TABLE WIDTH='184' HEIGHT='100%' CELLSPACING='0' CELLPADDING='0' BORDER='0'>\n";
	str += "<FORM NAME='calendar'>\n";
	str += "<TR><TD ALIGN='center' VALIGN='middle'>\n";
	str += "<TABLE STYLE='width:184px; border-spacing:0px; border:0px; border-collapse:collapse;' onMouseOver='parent.hover(true, window.event.srcElement)' onMouseOut='parent.hover(false, window.event.srcElement)' onClick='parent.choose("+y+","+m+", window.event.srcElement);'>\n";
	str += "<TR style='height:30px;'><TD colspan='10' align='center' valign='middle' style='background-image:url(/images/calTitBg.png); background-repeat:no-repeat;'>\n";
	str += "<SELECT STYLE='font-size:9pt;' NAME='years' onChange='parent.showCalendarPopup(this.value, calendar.months.value,"+d+")'>\n";
	for (var i=-7; i<7; i++)
	{
		str += "<OPTION VALUE="+(y+i)+" ";
		if (y+i == y) str += "SELECTED>";
		else str += ">";

		str += (y+i)+"</OPTION>\n";
	}
	str += "</SELECT>&nbsp;\n";
	str += "<IMG SRC='/images/IconBlArLeft.png' onClick='parent.showCalendarPopup("+y+","+(m-1)+","+d+");' STYLE='CURSOR:hand'>&nbsp;\n";
//	str += "<SPAN STYLE='font-size:9px;font-family:tahoma,verdana;color:blue;text-decoration:none;cursor:hand;' onClick='parent.showCalendarPopup("+DefYear+","+DefMonth+","+DefDate+");'>[Today]</SPAN>&nbsp;\n";
	str += "<SELECT STYLE='font-size:9pt;' NAME='months' onChange='parent.showCalendarPopup(calendar.years.value, this.value,"+d+")'>\n";
	for (var i=1; i<=12; i++)
	{
		str += "<OPTION VALUE="+i+" ";
		if (i==m) str += "SELECTED>"
		else str += ">";

		str += month_name[i-1]+"</OPTION>\n";
	}
	str += "</SELECT>&nbsp;\n";
	str += "<IMG SRC='/images/IconBlArRight.png' onClick='parent.showCalendarPopup("+y+","+(m+1)+","+d+");' STYLE='cursor:hand'>\n";
	str += "</TD></TR>\n";
	
	str += "<TR>\n";
	str += "<td rowspan='7' style='width:5px; background-image:url(/images/IconBlArbgbg_left.png); background-repeat:repeat-y;'></td>\n"
//	str += "<TD class='title'>"+day_name[0]+"</TD>\n"
	str += "<TD class='title'>"+day_name[1]+"</TD>\n"
	str += "<TD class='title'>"+day_name[2]+"</TD>\n"
	str += "<TD class='title'>"+day_name[3]+"</TD>\n"
	str += "<TD class='title'>"+day_name[4]+"</TD>\n"
	str += "<TD class='title'>"+day_name[5]+"</TD>\n"
	str += "<TD class='title'>"+day_name[6]+"</TD>\n"
	str += "<TD class='title'>"+day_name[7]+"</TD>\n"
	str += "<td rowspan='7' style='width:5px; background-image:url(/images/IconBlArbgbg_right.png); background-repeat:repeat-y;'></td>\n"
	str += "</TR>\n";

	for (var i=1; i<=6; i++)
	{
		str=str+"<TR>\n";
		// 마지막 주의 배열값이 전부 0 일경우 주차 또한 0 으로 만들어 버림
		if (aMonth[6][2] == 0)
		{
			aMonth[6][1] = 0;
		}

		for (var j=1; j<=8; j++)
		{
			// Week
			if (j == 1)
			{
				// 배열값이 0 인곳은 출력시키지 않음
				if (aMonth[i][j] == 0)
				{
					//str+="<TD style='width:5px; background-image:url(IconBlArbgbg_left.png); background-repeat:repeat-y;'>&nbsp;</TD>\n";
				}
				else
				{
					//str+="<TD class='wk'>"+aMonth[i][j]+"</TD>\n";
				}
			}
			// Sunday 
			else if(j == 8)
			{
				if (aMonth[i][j] == 0)
				{
					str+="<TD class='day_none'>&nbsp;</TD>\n";
				}
				else
				{
					if (aMonth[i][j] == DefDate) {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='today' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";          
					}else {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='su' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";					
					}
				}
			}
			// sat
			else if(j == 7)
			{
				if (aMonth[i][j] == 0)
				{
					str += "<TD class='day_none'>&nbsp;</TD>\n";
				}
				else
				{
					if (aMonth[i][j] == DefDate) {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='today' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";          
					}else {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='sa' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";					
					}
				}
			}
			//Monday ~ Friday
			else
			{
				if (aMonth[i][j] != 0)
				{
					if (aMonth[i][j] == DefDate) {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='today' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";          
					}else {
					  curBkCol = (y==DefYear && m==DefMonth && aMonth[i][j]==DefDate)?"#FFDE84":"#FFFFFF";
					  str+="<TD class='titCal' TITLE='"+aMonth[i][j]+"'>"+aMonth[i][j]+"</TD>\n";					
					}
				}
				else
				{
					str += "<TD class='day_none'>&nbsp;</TD>" + "\n";
				}
			}
		}
		str+="</TR>\n";
	}

	str+="<tr height='5'><td colspan='10' style='background-image:url(/images/IconBlArBottom.png); background-repeat:no-repeat;'></td></tr>\n";
	str+="</FORM></TABLE>\n";
	str+="</TD></TR></TABLE></CENTER>\n";
	str+="</BODY></HTML>\n";
//	menuPopup.document.body.innerHTML = str;
	menuPopup = window.createPopup();
//	menuPopup.document.body.innerHTML = str;
	menuPopup.document.write(str);
}

// Added By Sawh (2003.11.04)
function getDayInWeek(argYear, argMonth, argDate)
{
	var cal = new Date(argYear, argMonth-1, argDate);
	var rtn = cal.getDay()+1;
	cal = null;

	return rtn;
}

// Added By Sawh (2003.11.04)
function getWeekOfDayInMonth(argArr, argYear, argMonth, argDate)
{
	var now = new Date(argYear, argMonth-1, argDate);
	var year = now.getFullYear();
	var month = now.getMonth();
	var date = now.getDate();
	now = null;
	var newYearDayInstance = new Date(year, 0, 1);
	var newYearDayOfWeek = newYearDayInstance.getDay();
	var daysUntilToday = newYearDayOfWeek-1;

	for (var j=0; j<=month-1; j++)
	{
		daysUntilToday += argArr[j];
	}
	daysUntilToday += date;
	return Math.ceil(daysUntilToday/7);
}

function getX(objImg)
{
	return(objImg.offsetParent == null?objImg.offsetLeft:objImg.offsetLeft+getX(objImg.offsetParent));
}

function getY(objImg)
{
	return(objImg.offsetParent == null?objImg.offsetTop:objImg.offsetTop+getY(objImg.offsetParent));
}

function init()
{
	this.put_datetype   = put_datetype;
	this.put_curDate    = put_curDate;
	this.put_month_name = put_month_name;
	this.put_day_name   = put_day_name;
	this.put_select     = put_select;
}

function hover(on, el)
{
	if (el && el.nodeName == "TD")
	{
		if (el.title == '')
		{
			return;
		}

		if (on)
		{
//			str+="<TD style='background-image:url(IconBlArbg_over.png); background-repeat:repeat-y;'>&nbsp;</TD>\n";
			el.style.backgroundImage = "url('/images/IconBlArbg_over.png')";
		}
		else
		{
			if (el.title == eval(DefDate))
			{
				el.style.backgroundImage = "";
			}
			else
			{
				el.style.backgroundImage = "";
			}
		}
	}
}

function choose(y, m, el)
{
	if (el && el.nodeName == "TD")
	{
		if (el.title == '')
		{
			return;
		}

		return_date(y, m, el.title);
	}
}

function put_datetype(str)
{
	dtype = str;
}

function put_month_name(str)
{
	month_name = str;
}

function put_day_name(str)
{
	day_name = str;
}

function put_select(str)
{
	isSelect = str;
}

function put_curDate(str)
{
	var y=0,m=0,d=0;
	ctime = "";

	if (str.length == 0 )
	{
		y = DefYear;
		m = DefMonth;
		d = DefDate;
	}
	else
	{
		y = parseInt(str.substring(0,4),10);
		m = parseInt(str.substring(4,6),10);
		d = parseInt(str.substring(6,8),10);

		if (str.length >= 14)
		{
			ctime = str.substring(8,14);
		}
	}

	show_current(y,m,d);

	return(false);
}

function setLang(lang)
{
	if(lang != null || lang != "")
	{
		strLang = lang;
	}
	else
	{
		strLang = "E";
	}
}

function return0(str)
{
	str = ""+str;
	if (str.length == 1)
	{
		str = "0"+str;
	}
	return str;
}

function dreplace(str, old_char, new_char)
{
	if (str == null || str == "")
	{
		return;
	}
	else
	{
		var fromindex = 0;
		var temp = "";
		for (var i=0; i<str.length; i++)
		{
			fromindex = i;
			pos = str.indexOf(old_char,fromindex);
			if (pos != -1)
			{
				temp = str.substring(0,pos) + new_char + str.substring(pos+old_char.length);
				str = temp;
				i = pos+new_char.length-1;
			}
			else
			{
				break;
			}
		}
		return str;
	}
}

//open calendar
function show_current(y, m, d)
{
	DefYear=y;
	DefMonth=m;
	DefDate=d;

	makeCalendar(DefYear, DefMonth, DefDate)
}

//processing changed date
function return_date(year_item, month_item, day_item)
{
	if (year_item < 1900)
	{
		year_item = 1900 + year_item;
	}

	month_item = return0(month_item);
	day_item = return0(day_item);
	//makeCalendar(year_item,month_item,day_item);
	input_date(year_item, month_item, day_item);
}

//output selected date
function input_date(year_item, month_item, day_item)
{
	var m_name=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	var m_name2=new Array('JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER');
	if (year_item < 1900) year_item = 1900 + year_item;
	month_item = ""+month_item;
	day_item = ""+day_item;
	month_item2 = return0(month_item);
	day_item2 = return0(day_item);
	var backupidval = year_item +"-"+ month_item2 +"-"+ day_item2;

	realDate = dtype.toUpperCase();
	if(realDate.indexOf("YYYY")!=-1) realDate=dreplace(realDate,"YYYY",year_item);
	else if(realDate.indexOf("YY")!=-1) realDate=dreplace(realDate,"YY",year_item.substring(2));
	if(realDate.indexOf("DD")!=-1) realDate=dreplace(realDate,"DD",day_item2);
	else if(realDate.indexOf("D")!=-1) realDate=dreplace(realDate,"D",day_item);
	if(realDate.indexOf("MON")!=-1) realDate=dreplace(realDate,"MON",m_name[parseInt(month_item,10)-1]);
	else if(realDate.indexOf("MMMM")!=-1) realDate=dreplace(realDate,"MMMM",m_name2[parseInt(month_item,10)-1]);
	else if(realDate.indexOf("MMM")!=-1) realDate=dreplace(realDate,"MMM",m_name[parseInt(month_item,10)-1]);
	else if(realDate.indexOf("MM")!=-1) realDate=dreplace(realDate,"MM",month_item2);
	else if(realDate.indexOf("M")!=-1) realDate=dreplace(realDate,"M",month_item);
	var backupval = realDate;

  //window.external.raiseEvent(backupidval,backupval);
  /*
    if(txtName=="setEndDate")
    {
          setEndDate(backupidval);
    }
    else if(txtName=="setDate3")
    {
        setDate3(backupidval);
    }
    else
    {
        setStartDate(txtName, backupidval);
    }
    */
	
	setDate(objTxt, backupidval);

	menuPopup.hide();
}

function setDate(strjArgName, strjArgValue)
{
	strjArgName.value = strjArgValue
	strjArgName.focus();
	strjArgName.blur(); //주차받기위해 추가
	try 
	{
		evtCalendarDateOnClick(strjArgName,strjArgValue);
	}
	catch(exception)
	{
	}
}

function lostFocus()
{
	menuPopup.document.calendar.years.focus();
	menuPopup.document.calendar.years.blur();
}

function closePopup()
{
	if(menuPopup != null)
	{
		menuPopup.hide();
	}
}

function openMenu(height, width)
{
	iHeight = height;
	iWidth = width;

	if(iHeight < MenuHeight)
	{
		menuTimer = setTimeout("openMenu(iHeight + menuYIncrement, iWidth + menuXIncrement)", 1);
	}
	else
	{
		menuPopup.show(menuXPos, menuYPos, iWidth, iHeight, document.body);
		clearTimeout(menuTimer);
	}
}