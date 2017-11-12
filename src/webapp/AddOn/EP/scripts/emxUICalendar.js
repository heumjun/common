/*!================================================================
 *  JavaScript Calendar Utility
 *  emxUICalendar.js
 *  Version 1.0
 *  Requires: emxUIConstants.js
 *
 *  This file contains classes and methods for the framework
 *  popup calendar picker.
 *
 *  Copyright (c) 1992-2003 MatrixOne, Inc. All Rights Reserved.
 *  This program contains proprietary and trade secret information
 *  of MatrixOne,Inc. Copyright notice is precautionary only
 *  and does not evidence any actual or intended publication of such program
 *
 *  static const char RCSID[] = $Id: emxUICalendar.js,v 1.3 2005/02/21 02:06:56 kjm Exp $
 *=================================================================
 */

var localCalendars = new Array;
var URL_GET_CALENDAR_SELECT = "../emxCalendarSetting.jsp";
var URL_GET_CALENDAR_LOAD = "../emxCalendarLoad.jsp";
//! Class emxUICalendar
//!     This class is a calendar.
function emxUICalendar(objTargetFrame) {
        this.superclass = emxUIObject;
		this.superclass();
        delete this.superclass;
        this.container = null;
        this.document = document;
        this.emxClassName = "emxUICalendar";
        this.id = localCalendars.length;
        this.today = new Date();
        this.curDate = new Date(this.today);
        this.curDate.setYear(this.curDate.getFullYear());
        this.monthMenu = new emxUICalendarMonthMenu(this);
        this.selectedDate = new Date(this.curDate);
        this.tdMonth = null;
        this.tdYear = null;
        this.tblCalendarGrid = null;
        this.yearMenu = new emxUICalendarYearMenu(this);
        if (isMoz && objTargetFrame) {
                this.yearMenu.ownerWindow = objTargetFrame;
                this.monthMenu.ownerWindow = objTargetFrame;
                this.yearMenu.displayWindow = objTargetFrame;
                this.monthMenu.displayWindow = objTargetFrame;
                this.targetFrame = objTargetFrame;
        }
}
emxUICalendar.prototype = new emxUIObject;
emxUICalendar.IMG_LEFT_ARROW = emxUIConstants.DIR_IMAGES + "utilCalendarLeftArrow.gif";
emxUICalendar.IMG_RIGHT_ARROW = emxUIConstants.DIR_IMAGES + "utilCalendarRightArrow.gif";
emxUICalendar.CSS_FILE = emxUICore.getStyleSheet("emxUICalendar");
//! Private Method emxUICalendar.draw()
//!     This method draws the HTML code for the calendar onto the display frame.
emxUICalendar.prototype.draw = function _emxUICalendar_draw(objContainer) {
        var objDoc = (isMoz && this.targetFrame != null ? this.targetFrame.document : this.document);
        this.container = objContainer;
        this.container.className = "calendar-container";
        var objBuf= new emxUIStringBuffer;
        this.drawCalendar(objBuf);
        this.container.innerHTML = objBuf;
        this.tdYear = objDoc.getElementById("tdYear");
        this.tdMonth = objDoc.getElementById("tdMonth");
        this.tblCalendarGrid = objDoc.getElementById("tblCalendarGrid");
        var objThis = this;
        this.tdYear.onmouseover = function () { objThis.fireEvent("yearmouseover"); };
        this.tdYear.onmouseout = function () { objThis.fireEvent("yearmouseout"); };
        this.tdYear.onclick = function () { objThis.fireEvent("yearclick"); };
        this.tdMonth.onmouseover = function () { objThis.fireEvent("monthmouseover"); };
        this.tdMonth.onmouseout = function () { objThis.fireEvent("monthmouseout"); };
        this.tdMonth.onclick = function () { objThis.fireEvent("monthclick"); };
        this.registerEventHandler("selectday", function (objEvent) { objThis.handleEvent("selectday", objEvent); });
        this.registerEventHandler("monthclick", function (objEvent) { objThis.handleEvent("monthclick", objEvent); });
        this.registerEventHandler("yearclick", function (objEvent) { objThis.handleEvent("yearclick", objEvent); });
        this.yearMenu.init(objDoc);
        this.monthMenu.init(objDoc);
        this.refresh();
};
//! Private Method emxUICalendar.drawCalendar()
//!     This method draws the HTML code for the calendar.
emxUICalendar.prototype.drawCalendar = function _emxUICalendar_drawCalendar(objBuf) {
        objBuf.writeln("<table border=\"0\" cellpadding=\"0\" cellspacing=\"2\" width=\"225\">");
        objBuf.write("<tr><td>");
        this.drawHeader(objBuf);
        objBuf.writeln("</td></tr>");
        objBuf.writeln("<tr><td class=\"calendarBody\">");
        objBuf.writeln("<table border=\"0\" cellpadding=\"0\" cellspacing=\"2\" width=\"225\" id=\"tblCalendarGrid\">");
        objBuf.writeln("<thead><tr>");
        for (var i=0; i < emxUIConstants.ARR_SHORT_DAY_NAMES.length; i++) {
                var intCurDay = (i + emxUIConstants.CALENDAR_START_DOW) % 7;
                objBuf.write("<th height=\"20\" width=\"32\" class=\"day-name\">");
                objBuf.write(emxUIConstants.ARR_SHORT_DAY_NAMES[intCurDay]);
                objBuf.write("</th>");
        }
        objBuf.writeln("</tr></thead><tbody>");
        for (var i=0; i < 6; i++) {
                objBuf.writeln("<tr>");
                for (var j=0; j < 7; j++) {
                        objBuf.write("<td height=\"20\" class=\"empty\">&nbsp;</td>");
                }
                objBuf.writeln("</tr>");
        }
        objBuf.writeln("</tbody></table>");
        objBuf.writeln("</td></tr>");
        objBuf.writeln("</table>");
};
//! Private Method emxUICalendar.drawHeader()
//!     This method  draws the calendar header.
emxUICalendar.prototype.drawHeader = function _emxUICalendar_drawHeader(objBuf) {
        objBuf.writeln("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"20\" class=\"calendarHead\"><tr>");
        objBuf.write("<td id=\"tdMonth\" width=\"120\">&nbsp;</td><td width=\"1\"><img src=\"");
        objBuf.write(emxUIConstants.IMG_SPACER);
        objBuf.write("\" width=\"1\" height=\"1\" /></td><td id=\"tdYear\">&nbsp;</td></tr></table>");
};
//! Private Method emxUICalendar.handleEvent()
//!     This method handles events.
emxUICalendar.prototype.handleEvent = function _emxUICalendar_handleEvent(strType, objEvent) {
        switch(strType) {
                case "selectday":
                        this.setSelectedDate(new Date(objEvent.currentTarget.dateValue));
                        this.refresh();
                        break;
                case "todayclick":
                        this.setSelectedDate(new Date);
                        this.refresh();
                        break;
                case "monthclick":
                        this.monthMenu.show(this.tdMonth, "down");
                        break;
                case "yearclick":
                        this.yearMenu.show(this.tdYear, "down");
                        break;
        }
};
//! Private Method emxUICalendar.moveMonth()
//!     This method moves the month being displayed by the calendar.
emxUICalendar.prototype.moveMonth = function _emxUICalendar_moveMonth(intIncrement) {
        this.curDate.addMonths(intIncrement);
        this.refresh();
};
//! Private Method emxUICalendar.moveYear()
//!     This method moves the year being displayed by the calendar.
emxUICalendar.prototype.moveYear = function _emxUICalendar_moveYear(intIncrement) {
        this.curDate.addYears(intIncrement);
        this.refresh();
};
//! Private Method emxUICalendar.refresh()
//!     This method refreshes the view of the calendar.
emxUICalendar.prototype.refresh = function _emxUICalendar_refresh() {
        this.disable();
        this.tdMonth.innerHTML = emxUIConstants.ARR_LONG_MONTH_NAMES[this.curDate.getMonth()];
        this.tdYear.innerHTML = this.curDate.getFullYear();
        var objTempDate = new Date(this.curDate.setDate(1));
        var intStartDay = objTempDate.getDay();
        if (intStartDay != emxUIConstants.CALENDAR_START_DOW) {
                do  {
                        objTempDate.addDays(-1);
                } while (objTempDate.getDay() != emxUIConstants.CALENDAR_START_DOW);
        }
        for (var i=0; i < 6; i++) {
                var objRow = this.tblCalendarGrid.tBodies[0].rows[i];
                for (var j=0; j < 7; j++) {
                        var objCell = objRow.cells[j];
                        var intCurDay = (j + emxUIConstants.CALENDAR_START_DOW) % 7;
                        var blnIsEmpty = (i == 0 && Date.isDayBefore(intCurDay, intStartDay)) || (objTempDate.getMonth() != this.curDate.getMonth());
                        if (blnIsEmpty){
                            objCell.className = "empty";
                        } else if (objTempDate.isDateEqual(this.selectedDate)){
                            objCell.className = "day selected";
                        } else if (objTempDate.isDateEqual(this.today)){
                            objCell.className = "today";
                        } else {
                            objCell.className = "day";
                        }
                        objCell.innerHTML = objTempDate.getDate();
                        var objThis = this;
                        objCell.dateValue = objTempDate.toString();
                        objCell.onclick = function () {
                                objThis.fireEvent("selectday", emxUICore.getEvent(objThis.parentWindow));
                        };
                        objCell.onmouseover = function () {
                                objThis.fireEvent("daymouseover", emxUICore.getEvent(objThis.parentWindow));
                        };
                        objCell.onmouseout = function () {
                                objThis.fireEvent("daymouseout", emxUICore.getEvent(objThis.parentWindow));
                        };
                        objCell.title = emxUIConstants.ARR_LONG_MONTH_NAMES[objTempDate.getMonth()] + " " + objTempDate.getDate() + ", " + objTempDate.getFullYear();
                        objTempDate.addDays(1);
                }
        }
        this.enable();
};
//! Private Method emxUICalendar.setCurrentDate()
//!     This method sets the current date of the calendar (the one
//!     being displayed).
emxUICalendar.prototype.setCurrentDate = function _emxUICalendar_setCurrentDate(objDate) {
        this.curDate = new Date(objDate);
        this.curDate.setYear(this.curDate.getFullYear());
};
//! Private Method emxUICalendar.setSelectedDate()
//!     This method sets the selected date of the calendar.
emxUICalendar.prototype.setSelectedDate = function _emxUICalendar_setSelectedDate(objDate) {
        this.selectedDate = new Date(objDate);
        this.selectedDate.setYear(this.selectedDate.getFullYear());
};
//! Private Method emxUICalendar.setMonth()
//!     This method sets the month being displayed by the calendar.
emxUICalendar.prototype.setMonth = function _emxUICalendar_setMonth(intMonth) {
        if (typeof intMonth != "number") {
                throw new Error("Required parameter intMonth is null or not a number. (emxUICalendar.js::emxUICalendar.prototype.setMonth)");
        } else if (intMonth > 11 || intMonth < 0) {
                throw new Error("Required parameter intMonth must be a value between 0 and 11. (emxUICalendar.js::emxUICalendar.prototype.setMonth)");
        }
        this.curDate.setMonth(intMonth);
        this.refresh();
};
//! Private Method emxUICalendar.setYear()
//!     This method sets the year being displayed by the calendar.
emxUICalendar.prototype.setYear = function _emxUICalendar_setYear(intYear) {
        if (typeof intYear != "number") {
                throw new Error("Required parameter intYear is null or not a number. (emxUICalendar.js::emxUICalendar.prototype.setYear)");
        }
        this.curDate.setFullYear(intYear);
        this.refresh();
};
//! Class emxUICalendarMonthMenuItem
//!     This object represents an item on a month menu.
function emxUICalendarMonthMenuItem(strText) {
        this.superclass = emxUICoreMenuLink;
        this.superclass(null, strText);
        delete this.superclass;
        this.emxClassName = "emxUICalendarMonthMenuItem";
}
emxUICalendarMonthMenuItem.prototype = new emxUICoreMenuLink;
//! Method emxUICalendarMonthMenuItem.click()
//!     This method handles the click event for this object.
emxUICalendarMonthMenuItem.prototype.click = function _emxUICalendarMonthMenuItem_click() {
        if (!this.dead) {
                this.parent.hide(true);
                this.parent.calendar.setMonth(this.index);
        }
};
//! Class emxUICalendarMonthMenu
//!     This object represents a month menu.
function emxUICalendarMonthMenu(objCalendar) {
        this.superclass = emxUICorePopupMenu;
        this.superclass();
        delete this.superclass;
        this.calendar = objCalendar;
        this.cssClass = "monthmenu";
        this.emxClassName = "emxUICalendarMonthMenu";
        this.maxHeight = -1;
        this.stylesheet = emxUICalendar.CSS_FILE;
        this.build();
}
emxUICalendarMonthMenu.prototype = new emxUICorePopupMenu;
//! Private Method emxUICalendarMonthMenu.build()
//!     This method builds the month menu.
emxUICalendarMonthMenu.prototype.build = function _emxUICalendarMonthMenu_build() {
        for (var i=0; i < emxUIConstants.ARR_LONG_MONTH_NAMES.length; i++) {
                this.addItem(new emxUICalendarMonthMenuItem(emxUIConstants.ARR_LONG_MONTH_NAMES[i]));
        }
};
//! Class emxUICalendarYearMenuItem
//!     This object represents an item on a year menu.
function emxUICalendarYearMenuItem(strText) {
        this.superclass = emxUICoreMenuLink;
        this.superclass(null, strText);
        delete this.superclass;
        this.emxClassName = "emxUICalendarYearMenuItem";
}
emxUICalendarYearMenuItem.prototype = new emxUICoreMenuLink;
//! Method emxUICalendarYearMenuItem.click()
//!     This method handles the click event for this object.
emxUICalendarYearMenuItem.prototype.click = function _emxUICalendarYearMenuItem_click() {
        if (!this.dead) {
                this.parent.hide(true);
                this.parent.calendar.setYear(parseInt(this.text));
        }
};
//! Class emxUICalendarYearMenuSeparator
//!     This object represents a separator on the year menu
function emxUICalendarYearMenuSeparator() {
        this.superclass = emxUICoreMenuSeparator;
        this.superclass();
        delete this.superclass;
        this.emxClassName = "emxUICalendarYearMenuSeparator";
}
emxUICalendarYearMenuSeparator.prototype = new emxUICoreMenuSeparator;
//! Class emxUICalendarYearMenu
//!     This object represents a month menu.
function emxUICalendarYearMenu(objCalendar) {
        this.superclass = emxUICorePopupMenu;
        this.superclass();
        delete this.superclass;
        this.calendar = objCalendar;
        this.cssClass = "yearmenu";
        this.emxClassName = "emxUICalendarYearMenu";
        this.maxHeight = -1;
        this.stylesheet = emxUICalendar.CSS_FILE;
        this.build();
}
emxUICalendarYearMenu.prototype = new emxUICorePopupMenu;
//! Private Method emxUICalendarYearMenu.build()
//!     This method builds the month menu.
emxUICalendarYearMenu.prototype.build = function _emxUICalendarYearMenu_build() {
        for (var i=0; i < emxUIConstants.CALENDAR_YEARS_BEFORE + emxUIConstants.CALENDAR_YEARS_AFTER + 1; i++) {
                this.addItem(new emxUICalendarYearMenuItem(i));
        }
        this.addItem(new emxUICalendarYearMenuSeparator());
        this.addItem(new emxUICalendarYearMenuItem((new Date).getFullYear()));
        if (emxUIConstants.CALENDAR_CUSTOM_YEARS.length > 0) {
                this.addItem(new emxUICalendarYearMenuSeparator());
                for (var i=0; i < emxUIConstants.CALENDAR_CUSTOM_YEARS.length; i++) {
                        this.addItem(new emxUICalendarYearMenuItem(emxUIConstants.CALENDAR_CUSTOM_YEARS[i]));
                }
        }
};
//! Private Method emxUICalendarYearMenu.rebuild()
//!     This method builds the month menu.
emxUICalendarYearMenu.prototype.rebuild = function _emxUICalendarYearMenu_rebuild() {
        var intStartYear = this.calendar.curDate.getFullYear() - emxUIConstants.CALENDAR_YEARS_BEFORE;
        for (var i=0; i < emxUIConstants.CALENDAR_YEARS_BEFORE + emxUIConstants.CALENDAR_YEARS_AFTER + 1; i++) {
                var objItem = this.items[i];
                objItem.text = parseInt(intStartYear);
                objItem.rowElement.cells[0].innerHTML = intStartYear++;
        }
};
//! Private Method emxUICalendarYearMenu.show()
//!     This method shows the menu.
emxUICalendarYearMenu.prototype.emxUICoreMenuShow = emxUICalendarYearMenu.prototype.show;
emxUICalendarYearMenu.prototype.show = function _emxUICalendarYearMenu_show(objRef, strDir) {
        this.rebuild();
        this.emxUICoreMenuShow(objRef, strDir);
};
//! Class emxUIPopupCalendar
//!     This class is a popup calendar.
function emxUIPopupCalendar(strInputName, objDocument, objTargetFrame) {
        this.superclass = emxUICalendar;
        this.superclass(objTargetFrame);
        delete this.superclass;
        this.emxClassName = "emxUIPopupCalendar";
        this.document = objDocument;
        this.layer = null;
        this.popup = null;
        this.form = null;
        this.hiddenField = null;
        this.inputName = strInputName;
        this.field = null;
        this.hiddenField = null;
        this.initialized = false;
        this.remember = false;

        localCalendars[strInputName] = this;
}
emxUIPopupCalendar.prototype = new emxUICalendar;
emxUIPopupCalendar.prevDate = null;
//! Public Class Method emxUIPopupCalendar.callback()
//!     This method assigns the input fields for the calendar.
//!     This includes duplicating the field if necessary.
emxUIPopupCalendar.callback = function _emxUIPopupCalendar_callback(fnCallback) {
        var arrTemp = new Array;
        var strArgs = "";
        for (var i=1; i < arguments.length; i++) {
                arrTemp[arrTemp.length] = arguments[i];
                strArgs += "arrTemp[" + (i-1) + "],";
        }
        strArgs = strArgs.substring(0, strArgs.length-1);
        return function () {
                        eval("fnCallback(" + strArgs + ")");
               }
};
//! Private Method emxUIPopupCalendar.assignInputs()
//!     This method assigns the input fields for the calendar.
//!     This includes duplicating the field if necessary.
emxUIPopupCalendar.prototype.assignInputs = function _emxUIPopupCalendar_assignInputs(objDocument, objForm) {
        this.field = objForm.elements[this.inputName];
        this.hiddenField = objForm.elements[this.inputName + "_msvalue"];
};
//! Private Method emxUIPopupCalendar.draw()
//!     This method draws the HTML code for the calendar onto the display frame.
emxUIPopupCalendar.prototype.emxUICalendarDraw = emxUIPopupCalendar.prototype.draw;
emxUIPopupCalendar.prototype.draw = function _emxUIPopupCalendar_draw(objContainer) {
        if (isMinIE55 && isWin) {
                this.popup = window.createPopup();
                var objDoc = this.document = this.popup.document;
                this.parentWindow = this.document.parentWindow;
                this.yearMenu.ownerWindow = this.parentWindow;
                this.monthMenu.ownerWindow = this.parentWindow;
                objBody = this.document.body;
                objBody.style.cssText = "margin: 0px;";
                objBody.scroll = "no";
                objDoc.createStyleSheet(emxUICore.getStyleSheet(emxUIConstants.CSS_DEFAULT));
                objDoc.createStyleSheet(emxUICalendar.CSS_FILE);
                objBody.innerHTML = "";
                objContainer = objBody;
        }
        this.emxUICalendarDraw(objContainer);
        emxUICore.addEventHandler(objContainer, "contextmenu", cancelEvent);
        emxUICore.addEventHandler(objContainer, "selectstart", cancelEvent);
        if (isMinIE55 && isWin) {
                this.layer.innerHTML = objContainer.innerHTML;
        }
};
//! Private Method emxUIPopupCalendar.handleEvent()
//!     This method handles events.
emxUIPopupCalendar.prototype.emxUICalendarHandleEvent = emxUIPopupCalendar.prototype.handleEvent;
emxUIPopupCalendar.prototype.handleEvent = function _emxUIPopupCalendar_handleEvent(strType, objEvent) {
        switch(strType) {
                case "selectday":
                        this.setSelectedDate(new Date(objEvent.currentTarget.dateValue));
                        this.selectDay(this.selectedDate);
                        this.hide();
                        this.refresh();
                        break;
                case "todayclick":
                        this.setSelectedDate(new Date());
                        this.selectDay(this.selectedDate);
                        this.hide();
                        this.refresh();
                        break;
                default:
                        this.emxUICalendarHandleEvent(strType, objEvent);
        }
};
//! Private Method emxUIPopupCalendar.hide()
//!     This method hides the popup calendar.
emxUIPopupCalendar.prototype.hide = function _emxUIPopupCalendar_hide() {
        if (isMinIE55 && isWin) {
                this.popup.hide();
        } else {
                emxUICore.hide(this.layer);
        }
        this.monthMenu.hide();
        this.yearMenu.hide();
        this.setCurrentDate(this.selectedDate);
        this.refresh();
        this.fireEvent("hide");
};
//! Private Method emxUIPopupCalendar.isCalendarElement()
//!     This method determines if a given element is contained within
//!     this calendar layer.
emxUIPopupCalendar.prototype.isCalendarElement = function _emxUIPopupCalendar_isCalendarElement(objElement) {
        var objElem = objElement;
        while(objElem && objElem != this.layer && objElem != this.yearMenu.layer && objElem != this.monthMenu.layer) {
                objElem = objElem.parentNode;
        }
        return (objElem == this.layer || objElem == this.yearMenu.layer || objElem == this.monthMenu.layer);
};
//! Private Method emxUIPopupCalendar.selectDay()
//!     This method selects a day on the calendar.
emxUIPopupCalendar.prototype.selectDay = function _emxUIPopupCalendar_selectDay(objDate) {
        this.selectedDate = new Date(objDate);
        emxUIPopupCalendar.prevDate = new Date(objDate);
        this.field.emxDateValue = this.selectedDate.getTime();
        var strURL = URL_GET_CALENDAR_SELECT;
        strURL = emxUICore.addURLParam(strURL, "day=" + objDate.getDate());
        strURL = emxUICore.addURLParam(strURL, "mon=" + (objDate.getMonth()+1));
        strURL = emxUICore.addURLParam(strURL, "year=" + objDate.getFullYear());
        var strData = emxUICore.getData(strURL);
        this.setInputValue(trim(strData));
};
//! Private Method emxUIPopupCalendar.show()
//!     This method shows the popup calendar.
emxUIPopupCalendar.prototype.show = function _emxUIPopupCalendar_show(objDocument, objForm, strInitialDate) {
        if (!this.field) {
                this.assignInputs(objDocument, objForm);
        }
        var strURL = URL_GET_CALENDAR_LOAD;
        if (this.remember && emxUIPopupCalendar.prevDate) {
                strURL = addURLParam(strURL, "date=" + (emxUIPopupCalendar.prevDate.getMonth()+1) + "/" + emxUIPopupCalendar.prevDate.getDate() + "/" + emxUIPopupCalendar.prevDate.getFullYear() + " 12:00:00 PM");
        } else  {
                strURL = addURLParam(strURL, "date=" + escape(strInitialDate));
        }
        var strData = emxUICore.getData(strURL);
        var arrData = strData.split("|");
        this.setInitialDate(parseInt(arrData[0]), parseInt(arrData[1]), parseInt(arrData[2]));
        if (!this.layer) {
                if (isMoz && this.targetFrame != null) {
                        this.layer = this.targetFrame.document.createElement("div");
                        this.layer.style.visibility = "hidden";
                        this.layer.style.position = "absolute";
                        this.layer.style.zIndex = 1;
                        this.layer.style.width = "230px";
                        this.targetFrame.document.body.insertBefore(this.layer, this.targetFrame.document.body.firstChild);
                        this.draw(this.layer);
                } else {
                        this.layer = objDocument.createElement("div");
                        this.layer.style.visibility = "hidden";
                        this.layer.style.position = "absolute";
                        this.layer.style.zIndex = 1;
                        this.layer.style.width = "230px";
                        objDocument.body.insertBefore(this.layer, objDocument.body.firstChild);
                        this.draw(this.layer);
                }

        }
        if (isMinIE55 && isWin) {
                var objThis = this;
                this.popup.show(0, this.field.offsetHeight, this.layer.offsetWidth, this.layer.offsetHeight, this.field);
                setTimeout(function () {
                        if (objThis.popup.isOpen) {
                                objThis.timeoutID = setTimeout(arguments.callee, emxUICoreMenu.WATCH_DELAY);
                        } else {
                                objThis.hide();
                        }
                }, emxUICoreMenu.WATCH_DELAY);
        } else {
                var intY = 0, intX = 0;

                if (this.targetFrame != null) {
                        intY = 0;
                        intX = emxUICore.getActualLeft(this.field) + this.targetFrame.document.body.scrollLeft;
                        if (intX + this.layer.offsetWidth > this.targetFrame.document.body.scrollLeft + emxUICore.getWindowWidth()) {
                                intX = emxUICore.getWindowWidth() - this.layer.offsetWidth  + this.targetFrame.document.body.scrollLeft;
                        }
                } else {
                        intY = emxUICore.getActualTop(this.field) + this.field.offsetHeight;
                        intX = emxUICore.getActualLeft(this.field) + document.body.scrollLeft;
                        if (intY + this.layer.offsetHeight > document.body.scrollTop + emxUICore.getWindowHeight()) {
                                intY = intY - this.field.offsetHeight - this.layer.offsetHeight;
                        }
                        if (intX + this.layer.offsetWidth > document.body.scrollLeft + emxUICore.getWindowWidth()) {
                                intX = emxUICore.getWindowWidth() - this.layer.offsetWidth  + document.body.scrollLeft;
                        }
                        //make sure it's not off the top of the page
                        if (intY < document.body.scrollTop) {
                                intY = document.body.scrollTop;
                        }
                        if ((document.body.scrollLeft + emxUICore.getWindowWidth()) - (intX + this.layer.offsetWidth) < 16) {
                        	intX -= 16;
                        }
                }


                emxUICore.moveTo(this.layer, intX, intY);
                emxUICore.show(this.layer);
                var objThis = this;
                var fnTemp = function () { objThis.hide(); };
                window.addEventListener("mousedown", function () {
                        var objEvent = emxUICore.getEvent();
                        if (objThis.isCalendarElement(objEvent.target)){
                                objEvent.stopPropagation();
                        } else {
                                objThis.hide();
                        }
                }, false);
                window.addEventListener("scroll", fnTemp, true);
        }
};
//! Private Method emxUIPopupCalendar.show2()
//!     This method shows the popup calendar without assigning inputs.
emxUIPopupCalendar.prototype.show2 = function _emxUIPopupCalendar_show2(objDocument, objForm, strInitialDate) {
        this.assignInputs(objDocument, objForm);
        var strURL = URL_GET_CALENDAR_LOAD;
        if (this.remember && emxUIPopupCalendar.prevDate) {
                strURL = addURLParam(strURL, "date=" + (emxUIPopupCalendar.prevDate.getMonth()+1) + "/" + emxUIPopupCalendar.prevDate.getDate() + "/" + emxUIPopupCalendar.prevDate.getFullYear() + " 12:00:00 PM");
        } else {
                strURL = addURLParam(strURL, "date=" + escape(strInitialDate));
        }
        var strData = emxUICore.getData(strURL);
        var arrData = strData.split("|");
        this.setInitialDate(parseInt(arrData[0]), parseInt(arrData[1]), parseInt(arrData[2]));
        if (!this.layer) {
                if (isMoz && this.targetFrame != null) {
                        this.layer = this.targetFrame.document.createElement("div");
                        this.layer.style.visibility = "hidden";
                        this.layer.style.position = "absolute";
                        this.layer.style.zIndex = 1;
                        this.layer.style.width = "230px";
                        this.targetFrame.document.body.insertBefore(this.layer, this.targetFrame.document.body.firstChild);
                        this.draw(this.layer);
                } else {
                        this.layer = objDocument.createElement("div");
                        this.layer.style.visibility = "hidden";
                        this.layer.style.position = "absolute";
                        this.layer.style.zIndex = 1;
                        this.layer.style.width = "230px";
                        objDocument.body.insertBefore(this.layer, objDocument.body.firstChild);
                        this.draw(this.layer);
                }
        }
        if (isMinIE55 && isWin) {
                var objThis = this;
                this.popup.show(0, this.field.offsetHeight, this.layer.offsetWidth, this.layer.offsetHeight, this.field);
                setTimeout(function () {
                        if (objThis.popup.isOpen) {
                                objThis.timeoutID = setTimeout(arguments.callee, emxUICoreMenu.WATCH_DELAY);
                        } else {
                                objThis.hide();
                        }
                }, emxUICoreMenu.WATCH_DELAY);
        } else {
                if (this.targetFrame != null) {
                        intY = 0;
                        intX = emxUICore.getActualLeft(this.field) + this.targetFrame.document.body.scrollLeft;
                        if (intX + this.layer.offsetWidth > this.targetFrame.document.body.scrollLeft + emxUICore.getWindowWidth()) {
                                intX = emxUICore.getWindowWidth() - this.layer.offsetWidth  + this.targetFrame.document.body.scrollLeft;
                        }
                } else {
                        intY = emxUICore.getActualTop(this.field) + this.field.offsetHeight;
                        intX = emxUICore.getActualLeft(this.field) + document.body.scrollLeft;
                        if (intY + this.layer.offsetHeight > document.body.scrollTop + emxUICore.getWindowHeight()) {
                                intY = intY - this.field.offsetHeight - this.layer.offsetHeight;
                        }
                        if (intX + this.layer.offsetWidth > document.body.scrollLeft + emxUICore.getWindowWidth()) {
                                intX = emxUICore.getWindowWidth() - this.layer.offsetWidth  + document.body.scrollLeft - 16;
                        }
                        //make sure it's not off the top of the page
                        if (intY < document.body.scrollTop) {
                                intY = document.body.scrollTop;
                        }
                        if ((document.body.scrollLeft + emxUICore.getWindowWidth()) - (intX + this.layer.offsetWidth) < 16) {
                        	intX -= 16;
                        }


                }
                emxUICore.moveTo(this.layer, intX, intY);
                emxUICore.show(this.layer);
                var objThis = this;
                var fnTemp = function () { objThis.hide(); };
                window.addEventListener("mousedown", function () {
                        var objEvent = emxUICore.getEvent();
                        if (objThis.isCalendarElement(objEvent.target)){
                                objEvent.stopPropagation();
                        } else {
                                objThis.hide();
                        }
                }, false);
                window.addEventListener("scroll", fnTemp, true);
        }
};
//! Protected Method emxUIPopupCalendar.setInitialDate()
//!     This method sets the initial date value of the calendar.
emxUIPopupCalendar.prototype.setInitialDate = function _emxUIPopupCalendar_setInitialDate(intYear, intMonth, intDay) {
        if (!this.initialized) {
                this.setSelectedDate(new Date(intYear, intMonth, intDay));
                this.setCurrentDate(new Date(intYear, intMonth, intDay));
                this.initialized = true;
        } else if (this.remember && emxUIPopupCalendar.prevDate) {
                this.setSelectedDate(new Date(emxUIPopupCalendar.prevDate));
                this.setCurrentDate(new Date(emxUIPopupCalendar.prevDate));
        }
};
//! Private Method emxUIPopupCalendar.setInputValue()
//!     This method sets the input field values.
emxUIPopupCalendar.prototype.setInputValue = function _emxUIPopupCalendar_setInputValue(strVisibleValue, strHiddenValue) {
        this.field.value = strVisibleValue;
        if (this.hiddenField) {
                this.hiddenField.value = this.selectedDate.getTime() + 12 * 60 * 60 * 1000;
        }
        this.callback();
};
//! Public Function showCalendar()
//!     This function shows the calendar picker.
function showCalendar(strFormName, strInputName, strInitialDate, blnRemember, fnCallback, objWindow, objTargetFrame) {
        objWindow = objWindow || self;
        var objForm = objWindow.document.forms[strFormName];
        var objCal = localCalendars[strInputName];

        if(!objCal) {
                objCal = new emxUIPopupCalendar(strInputName, objWindow.document, objTargetFrame);
        }

        objCal.remember = !!blnRemember;
        objCal.callback = fnCallback || new Function();

        objCal.show(objWindow.document, objForm, strInitialDate);
}
//! Public Function showCalendar2()
//!     This function shows the calendar picker without assigning input information.
function showCalendar2(strFormName, strInputName, strInitialDate, blnRemember, fnCallback, objWindow, objTargetFrame) {
        objWindow = objWindow || self;
        var objForm = objWindow.document.forms[strFormName];
        var objCal = localCalendars[strInputName];
        if(!objCal) {
                objCal = new emxUIPopupCalendar(strInputName, objWindow.document, objTargetFrame);
        }
        objCal.remember = !!blnRemember;
        objCal.callback = fnCallback || new Function();
        objCal.show2(objWindow.document, objForm, strInitialDate);
}
//! Private Function trim
//!     This method trims the leading and trailing whitespace characters
//!     from a string.
function trim(strString) {
        strString = strString.replace(/^\s*/g, "");
        return strString.replace(/\s+$/g, "");
}
