function cancelEvent() {
        return false;
}
var strUserAgent = navigator.userAgent.toLowerCase();
var isIE = strUserAgent.indexOf("msie") > -1 && strUserAgent.indexOf("opera") == -1;
var isMinIE5 = false,isMinIE55 = false,isMinIE6 = false;
if (isIE) {
        var reIE = new RegExp("msie (\\S*);");
        reIE.test(strUserAgent);
        var fVer = parseFloat(RegExp["$1"]);
        isMinIE5 = fVer >= 5;
        isMinIE55 = fVer >= 5.5;
        isMinIE6 = fVer >= 6;
}
var isGecko = strUserAgent.indexOf("gecko") > -1;
var isMoz = isGecko;
var isMinMoz092 = false,isMinMoz094 = false,isMinMoz098 = false,isMinMoz1 = false;
if (isMoz) {
        if (strUserAgent.indexOf("rv:") > -1) {
                var reMoz = new RegExp("rv:(\\d\\.\\d)([\\.\\d]*)");
                reMoz.test(strUserAgent);
                var fMajorVer = RegExp["$1"];
                var fMinorVer = RegExp["$2"];
                isMinMoz092 = (fMajorVer == 0.9 && fMinorVer >= 0.2) || (fMajorVer > 0.9);
                isMinMoz094 = (fMajorVer == 0.9 && fMinorVer >= 0.4) || (fMajorVer > 0.9);
                isMinMoz098 = (fMajorVer == 0.9 && fMinorVer >= 0.8) || (fMajorVer > 0.9);
                isMinMoz1 = (fMajorVer >= 1.0);
        }
}
var isWin = navigator.platform.indexOf("Win") > -1;
var isWinNT = false,isWin95 = false,isWin98 = false,isWin2000 = false,isWinME = false,isWinXP = false;
if (isWin) {
        if (isIE) {
                isWinNT = strUserAgent.indexOf("windows nt 4.0") > -1;
                isWin95 = strUserAgent.indexOf("windows 95") > -1;
                isWin98 = strUserAgent.indexOf("windows 98") > -1;
                isWin2000 = strUserAgent.indexOf("windows nt 5.0") > -1;
                isWinME = strUserAgent.indexOf("win 9x 4.90") > -1;
                isWinXP = strUserAgent.indexOf("windows nt 5.1") > -1;
        } else if (isMoz) {
                isWinNT = strUserAgent.indexOf("winnt4.0") > -1;
                isWin95 = strUserAgent.indexOf("win95") > -1;
                isWin98 = strUserAgent.indexOf("win98") > -1;
                isWin2000 = strUserAgent.indexOf("windows nt 5.0") > -1;
                isWinME = strUserAgent.indexOf("win 9x 4.90") > -1;
                isWinXP = strUserAgent.indexOf("windows nt 5.1") > -1;
        } else if (isNS4) {
                isWinNT = strUserAgent.indexOf("winnt") > -1;
                isWin95 = strUserAgent.indexOf("win95") > -1;
                isWin98 = strUserAgent.indexOf("win98") > -1;
                isWin2000 = strUserAgent.indexOf("windows nt 5.0") > -1;
                isWinME = strUserAgent.indexOf("win 9x 4.90") > -1;
        }
}
var isMac = navigator.platform.indexOf("Mac") > -1;
var isUnix = strUserAgent.indexOf("x11") > -1;
var isHPUX = strUserAgent.indexOf("hp-ux") > -1;
var isSunOS = strUserAgent.indexOf("sunos") > -1;
var STR_CHECKBOX_NAME = "emxTableRowId";

//! Public Method Date.addDays()
//!     This function adds a specified number of days to the current date.
Date.prototype.addDays = function _Date_addDays(intDays) {
        this.setDate(this.getDate() + intDays);
};
//! Public Method Date.addMonths()
//!     This function adds a specified number of months to the current date.
Date.prototype.addMonths = function(intMonths) {
        this.setMonth(this.getMonth() + intMonths);
};
//! Public Method Date.addYears()
//!     This function adds a specified number of years to the current date.
Date.prototype.addYears = function(intYears) {
        this.setYear(this.getFullYear() + intYears);
};
//! Public Method Date.isDateEqual()
//!     This function determines if two dates are equal.
Date.prototype.isDateEqual = function _Date_isDateEqual(objDate) {
        if (objDate == null){
                return false;
        } else {
                return (this.getMonth() == objDate.getMonth()) && (this.getDate() == objDate.getDate()) && (this.getFullYear() == objDate.getFullYear());
        }
};
//! Public Method Date.isDayBefore()
//!     This method determines whether, given two days, the first date
//!     occurs earlier in the calendar week than the second date. This is
//!     needed when the calendar week begins on any day other than Sunday.
Date.isDayBefore = function _Date_isDayBefore(intTestDay, intStartDay) {
        var intTestDayLoc, intStartDayLoc;
        for (var i=0; i < 7; i++) {
                var iTestValue = (i + emxUIConstants.CALENDAR_START_DOW) % 7;
                if (iTestValue == intTestDay) intTestDayLoc = i;
                if (iTestValue == intStartDay) intStartDayLoc = i;
        }
        return intTestDayLoc < intStartDayLoc;
}
Array.prototype.find = function _Array_find(varItem) {
        var blnFound = false;
        for (var i=0; i  < this.length && !blnFound; i++) {
                if (this[i] == varItem) {
                        blnFound = true;
                }
        }
        return (blnFound ? i-1 : -1);
};
Array.prototype.remove = function _Array_remove(varItem) {
        var intPos = this.find(varItem);
        if (intPos > -1) {
                for (var i= intPos + 1; i < this.length; i++) {
                        this[i-1] = this[i];
                }
                this.length--;
        }
};
if (!Array.prototype.pop) {
    Array.prototype.pop = function () {
        var objItem = this[this.length-1];
        this.length--;
        return objItem;
    };
}
if (!Array.prototype.push) {
    Array.prototype.push = function (objItem) {
        this[this.length] = objItem;
    };
}
String.prototype.htmlEncode = function _String_htmlEncode() {
        var strTemp = this.toString();
        strTemp = strTemp.replace("&", "&amp;");
        strTemp = strTemp.replace(">", "&gt;");
        strTemp = strTemp.replace("<", "&lt;");
        strTemp = strTemp.replace("\"", "&quot;");
        strTemp = strTemp.replace("\'", "&#39;");
        return strTemp;
}
function emxUIStringBuffer() {
        this.strings = new Array;
}
emxUIStringBuffer.prototype.clear = function _emxUIStringBuffer_clear() {
        delete this.strings;
        this.strings = new Array;
};
emxUIStringBuffer.prototype.toString = function _emxUIStringBuffer_toString() {
        return this.strings.join("");
};
emxUIStringBuffer.prototype.write = function _emxUIStringBuffer_write(strText) {
        this.strings.push(strText);
};
emxUIStringBuffer.prototype.writeln = function _emxUIStringBuffer_writeln(strText) {
        this.strings.push(strText + "\n");
}
var emxUICore = new Object;
emxUICore.DIR_IMAGES = "../common/images/";
emxUICore.DIR_STYLES = "../common/styles/";
emxUICore.DIR_SMALL_ICONS = emxUICore.DIR_IMAGES + "icons/small/";
emxUICore.DIR_BIG_ICONS = emxUICore.DIR_IMAGES + "icons/big/";
emxUICore.DIR_UTIL = emxUICore.DIR_IMAGES + "util/";
emxUICore.DIR_BUTTONS = emxUICore.DIR_IMAGES + "buttons/";
emxUICore.DIR_TREE = emxUICore.DIR_IMAGES + "tree/";
emxUICore.DIR_NAVBAR = emxUICore.DIR_IMAGES + "navbar/";
emxUICore.DIR_SEARCHPANE = emxUICore.DIR_IMAGES + "search/";
emxUICore.DIR_DISC = emxUICore.DIR_IMAGES + "discussion/";
emxUICore.IMG_SPACER = emxUICore.DIR_IMAGES + "utilSpacer.gif";
emxUICore.IMG_LOADING = emxUICore.DIR_SMALL_ICONS + "iconStatusLoading.gif";
emxUICore.IMG_PAGE_HEAD_ARROW = emxUICore.DIR_IMAGES + "utilPageHeadArrow.gif";
emxUICore.UI_LEVEL = 5;
emxUICore.CALENDAR_START_DOW = 0;
emxUICore.addClass = function _emxUICore_addClass(objElement, strClass) {
        if (!objElement || typeof objElement != "object") {
                emxUICore.throwError("Required argument objElement is null or not an object.");
        } else if (!strClass || typeof strClass != "string") {
                emxUICore.throwError("Required argument strClass is null or not a string.");
        }
        var strOriginal = objElement.className || "";
        var arrClasses = strOriginal.split(" ");
        arrClasses.push(strClass);
        objElement.className =  arrClasses.join(" ");
};
emxUICore.addToPageHistory = function _emxUICore_addToPageHistory(strSuite,strURL,strMenu,strCommand,strTarget,strCommandTitle,strLinkType,intWidth,intHeight) {
        if(!isIE){
           strSuite=escape(strSuite);
        }
        strCommandTitle=encodeURI(strCommandTitle);
        var strFinalURL = "emxPageHistoryProcess.jsp?pageURL="+escape(strURL)+"&width="+intWidth+"&height="+intHeight+"&AppName="+strSuite+"&menuName="+strMenu+"&commandName="+strCommand+"&targetLocation="+strTarget+"&CommandTitle="+strCommandTitle+"&linkType="+strLinkType+"&suiteDir="+strSuite+"&myDeskSuiteDir="+strSuite;
        top.hiddenFrame.location.href = strFinalURL;

};
emxUICore.addURLParam = function _emxUICore_addURLParam(strURL, strParam) {
        if (!strURL || typeof strURL != "string") {
                emxUICore.throwError("Required argument strURL is null or not a string.");
        } else if (!strParam || typeof strParam != "string") {
                emxUICore.throwError("Required argument strParam is null or not a string.");
        }
        var strNewURL = strURL;
        var strName = strParam.split("=")[0];
        if (strNewURL.indexOf(strName + "=") == -1) {
    	        strNewURL += (strNewURL.indexOf('?') > -1 ? '&' : '?') + strParam;
        }
        return strNewURL;
};
emxUICore.createImageButton = function _emxUICore_createImageButton(objDocument, strImage, fnOnClick, intWidth, intHeight) {
        if (!objDocument || typeof objDocument != "object") {
                emxUICore.throwError("Required argument objDocument is null or not an object.");
        } else if (!strImage || typeof strImage != "string") {
                emxUICore.throwError("Required argument strImage is null or not a string.");
        } else if (!fnOnClick || typeof fnOnClick != "function") {
                emxUICore.throwError("Required argument fnOnClick is null or not a function.");
        }
        var objImg = objDocument.createElement("img");
        objImg.src = strImage;
        objImg.onclick = fnOnClick;
        if (intWidth) {
                objImg.width = intWidth;
        }
        if (intHeight) {
                objImg.height = intHeight;
        }
        return objImg;
};
emxUICore.findFrame = function _emxUICore_findFrame(objWindow, strName) {
        if (!objWindow || typeof objWindow != "object") {
                emxUICore.throwError("Required argument objWindow is null or not an object.");
        } else if (!strName || typeof strName != "string") {
                emxUICore.throwError("Required argument strName is null or not a string.");
        }
        switch(strName) {
                case "_top":
                        return top;
                case "_self":
                        return self;
                case "_parent":
                        return parent;
                default:
                    	var objFrame = null;
                        for (var i = 0; i < objWindow.frames.length && !objFrame; i++) {
                          	if (objWindow.frames[i].name == strName) {
                          		objFrame = objWindow.frames[i];
                          	}
                        }
    		        for (var i=0; i < objWindow.frames.length && !objFrame; i++) {
    			        objFrame = this.findFrame(objWindow.frames[i], strName);
                        }
                        return objFrame;
        }
};
//!     This function gets the height of the content inside
//!     a container (layer).
emxUICore.getContentHeight = function _emxUICore_getContentHeight(objDiv) {
        if (isIE) {
                return objDiv.clientHeight;
        } else {
                var intHeight = 0;
                for (var i=0; i < objDiv.childNodes.length; i++) {
                    if (objDiv.childNodes[i].nodeType == 1) {
                        if (objDiv.childNodes[i].offsetHeight == 0) {
                            for (var j=0; j < objDiv.childNodes[i].childNodes.length; j++) {
                                if (objDiv.childNodes[i].childNodes[j].nodeType == 1) {
                                    intHeight += objDiv.childNodes[i].childNodes[j].offsetHeight;
                                }
                            }
                        } else {
                            intHeight += objDiv.childNodes[i].offsetHeight;
                        }
                    }
                }
                return intHeight;
        }
};
//!     This function gets the width of the content inside
//!     a container (layer).
emxUICore.getContentWidth = function _emxUICore_getContentWidth(objDiv) {
        if (isIE) {
                return objDiv.clientWidth;
        } else {
                return (objDiv.childNodes.length > 0 ? objDiv.getElementsByTagName("*")[0].offsetWidth : objDiv.offsetWidth);
        }
};
emxUICore.getIcon = function _emxUICore_getIcon(strIcon) {
        if (typeof strIcon != "string") {
                emxUICore.throwError("Required argument strIcon is null or not a string.");
        }
        if ((strIcon.substring(1,8)) == "servlet" || strIcon.indexOf(emxUIConstants.DIR_SMALL_ICONS) > -1) {
                return strIcon;
        } else {
                return emxUIConstants.DIR_SMALL_ICONS + strIcon;
        }
};
emxUICore.getNextElement = function _emxUICore_getNextElement(objElement) {
        if (typeof objElement != "object") {
                emxUICore.throwError("Required argument objElement is null or not an object.");
        }
        var objTemp = objElement.nextSibling;
        while(objTemp && objTemp.nodeType != 1) {
                objTemp = objTemp.nextSibling;
        }
        return objTemp;
};
emxUICore.getPreviousElement = function _emxUICore_getPreviousElement(objElement) {
        if (typeof objElement != "object") {
                emxUICore.throwError("Required argument objElement is null or not an object.");
        }
        var objTemp = objElement.previousSibling;
        while(objTemp && objTemp.nodeType != 1) {
            objTemp = objTemp.previousSibling;
        }
        return objTemp;
};
emxUICore.getParentObject = function _emxUICore_getParentObject(strObjectName) {
        if (typeof strObjectName != "string") {
                emxUICore.throwError("Required argument strObjectName is null or not a string.");
        }
        var objParent = parent;
        var objTemp = objParent[strObjectName];
        while(objTemp == null && objParent != top) {
                objParent = objParent.parent;
                objTemp = objParent[strObjectName];
        }
        return objTemp;
};
emxUICore.getUniqueID = function _emxUICore_getUniqueID_() {
        var strTemp = "emx";
        strTemp += ((new Date()).getTime() * Math.random());
        return strTemp;
};
emxUICore.iterateFrames = function _emxUICore_iterateFrames(fnExec) {
        if (typeof fnExec != "function") {
                emxUICore.throwError("Required argument fnExec is null or not a function.");
        }
        function _emxUICore_iterateFramesEx(objWindow) {
                fnExec(objWindow);
                for (var i=0; i < objWindow.frames.length; i++) {
                        _emxUICore_iterateFramesEx(objWindow.frames[i]);
                }
        }
        _emxUICore_iterateFramesEx(top);
};
emxUICore.link = function _emxUICore_link(strURL, strTarget) {
        if (typeof strURL != "string") {
                emxUICore.throwError("Required argument strURL is null or not a string.");
        } else if (strTarget && typeof strTarget != "string") {
                emxUICore.throwError("Required argument strTarget is null or not a string.");
        }
        if (strURL.indexOf("javascript:") == 0) {
                eval(strURL);
        } else {
                if (strTarget != null) {
                        var objFrame = emxUICore.findFrame(top, strTarget);
                        if (objFrame) {
                                objFrame.location = strURL;
                        } else {
                                window.open(strURL, strTarget);
                        }
                } else {
                        document.location.href = strURL;
                }
        }
};
//! Public Method emxUICore.moveTo()
//!     This function moves an element to a specified pixel location.
emxUICore.moveTo = function _emxUICore_moveTo(objElement, intX, intY) {
        if (typeof objElement != "object") {
                emxUICore.throwError("Required argument objElement is null or not an object.");
        } else if (typeof intX != "number") {
                emxUICore.throwError("Required argument intX is null or not a number.");
        }
        objElement.style.left = intX + "px";
        if (intY != null && typeof intY == "number") {
                objElement.style.top = intY + "px";
        }
};
emxUICore.removeClass = function _emxUICore_removeClass(objElement, strClass) {
        var strOriginal = objElement.className || "";
        var arrClasses = strOriginal.split(" ");
        var arrNew = new Array;
        for (var i=0; i < arrClasses.length; i++) {
                if (arrClasses[i] != strClass) {
                        arrNew.push(arrClasses[i]);
                }
        }
        objElement.className =  arrNew.join(" ");
};
emxUICore.throwError = function _emxUICore_throwError(strMessage) {
        if ((isMinIE55 && isWin) || isMoz) {
                eval("throw new Error(\""  + strMessage + "\")");
        } else {
                alert("Error: " + strMessage);
        }
};
emxUICore.addEventHandler = function _emxUICore_addEventHandler(objElement, strType, fnHandler, blnCapture) {
        if (isIE) {
                objElement.attachEvent("on" + strType, fnHandler);
        } else {
                objElement.addEventListener(strType, fnHandler, !!blnCapture);
        }
};
//! Public Method emxUICore.addStyleSheet()
//!     This function adds a style sheet to the given document.
emxUICore.addStyleSheet = function _emxUICore_addStyleSheet(strCSSPrefix) {
        var strCSSFile = getStyleSheet(strCSSPrefix);
        document.write("<link rel=\"stylesheet\" type=\"text/css\" ");
        document.write("href=\"" + strCSSFile + "\">");
}
emxUICore.cancelUserSelect = function _emxUICore_cancelUserSelect_IE(objElement, objWin) {
        if (isIE) {
                objElement.onselectstart = function() { emxUICore.getEvent(objWin).preventDefault() };
        } else {
                objElement.style.mozUserSelect = "none";
        }
};
emxUICore.checkDOMError = function _emxUICore_checkDOMError_Moz(objXML, strFile) {
        if (isIE) {
                if (objXML.parseError != 0) {
                        emxUICore.throwError("XML file " + strFile + " could not be parsed. " + objXML.parseError.reason + "(Line: " + objXML.parseError.line + ", Char: " + objXML.parseError.linepos + ").");
                }
        } else {
                if (objXML.documentElement.tagName == "parsererror") {
                        emxUICore.throwError("XML file " + strFile + " could not be parsed. The file may either be missing or not well-formed.");
                }
        }
};
emxUICore.createXMLDOM = function _emxUICore_createXMLDOM() {
        if (isIE) {
                return new ActiveXObject("MSXML2.DOMDocument");
        } else {
                return document.implementation.createDocument("", "", null);
        }
};

emxUICore.transformToText = function _emxUICore_transformToText(objXML, objXSLT) {

    try {
        if (isIE) {
            var strText = objXML.transformNode(objXSLT);
            return strText;
        } else {
                if (!isUnix) {
                        var objProcessor = new XSLTProcessor();
                        objProcessor.importStylesheet(objXSLT);
                        var objResult = objProcessor.transformToDocument(objXML);
                        if (objResult.documentElement.tagName == "result") {
                                var strResult = objResult.documentElement.xml;
                                return strResult.substring(strResult.indexOf(">")+1, strResult.indexOf("</transformiix:result>"));
                        } else {
                                return objResult.xml;
                        }
                } else {
                        var objBuf = new emxUIStringBuffer;
                        objBuf.write("xml=");
                        objBuf.write(escape(objXML.xml));
                        objBuf.write("&xslt=");
                        objBuf.write(escape(objXSLT.xml));
                        var strResult = emxUICore.getDataPost("../common/emxTransform.jsp", objBuf.toString());
                        return strResult;
                }
        }
    } catch (objError) {
        alert("Error occurred while trying to transform: " + objError.message);
    }
};

emxUICore.getElementsByTagName = function (objRefNode, strTagName) {
    if (isIE || strTagName.indexOf(":") == -1) {
        return objRefNode.getElementsByTagName(strTagName);
    } else {
        return objRefNode.getElementsByTagName(strTagName.substring(strTagName.indexOf(":")+1));
    }
};

emxUICore.selectNodes = function (objRefNode, strXPath) {
    if (isIE) {
        var arrNodes = objRefNode.selectNodes(strXPath);
        var arrResult = new Array;
        for (var i=0; i < arrNodes.length; i++) {
            arrResult.push(arrNodes[i]);
        }
        return arrResult;
    } else {
        var objEvaluator = new XPathEvaluator();
        var objNSResolver = objEvaluator.createNSResolver(objRefNode.ownerDocument.documentElement);
        var objNodes = objEvaluator.evaluate(strXPath, objRefNode, objNSResolver, XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
        var arrResult = new Array;
        var objNext;
        while (objNext = objNodes.iterateNext()) {
            arrResult.push(objNext);
        }
        return arrResult;
    }
};

emxUICore.selectSingleNode = function (objRefNode, strXPath) {
    if (isIE) {
        return objRefNode.selectSingleNode(strXPath);
    } else {
        var objEvaluator = new XPathEvaluator();
        var objNSResolver = objEvaluator.createNSResolver(objRefNode.ownerDocument.documentElement);
        var objNodes = objEvaluator.evaluate(strXPath, objRefNode, objNSResolver, XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
        return objNodes.iterateNext();
    }
};

emxUICore.createHttpRequest = function _emxUICore_createHttpRequest() {
        if (isIE) {
                return new ActiveXObject("Microsoft.XMLHTTP");
        } else {
                return new XMLHttpRequest;
        }
};
emxUICore.getActualLeft = function _emxUICore_getActualLeft(objElement) {
        var intLeft = objElement.offsetLeft;
        var objParent = objElement.offsetParent;
        if (isIE) {
                while(objParent != null) {
                        if (objParent.tagName == "TD") {
                                intLeft += objParent.clientLeft;
                        }
                        intLeft += objParent.offsetLeft;
                        objParent = objParent.offsetParent;
                }
        } else {
                while(objParent != null) {
                        if (objParent.tagName == "TABLE") {
                                var intBorder = parseInt(objParent.border);
                                if (isNaN(intBorder)) {
                                        if (objParent.getAttribute("frame") != null) {
                                                intLeft += 1;
                                        }
                                } else {
                                        intLeft += intBorder;
                                }
                        }
                        intLeft += objParent.offsetLeft;
                        objParent = objParent.offsetParent;
                }
        }
        return intLeft;
};
emxUICore.getActualTop = function _emxUICore_getActualTop(objElement) {
        var intTop = objElement.offsetTop;
        var objParent = objElement.offsetParent;
        if (isIE) {
                while(objParent != null) {
                        if (objParent.tagName == "TD") {
                                intTop += objParent.clientTop;
                        }
                        intTop += objParent.offsetTop;
                        objParent = objParent.offsetParent;
                }
        } else {
                while(objParent != null) {
                        if (objParent.tagName == "TABLE") {
                                var intBorder = parseInt(objParent.border);
                                if (isNaN(intBorder)) {
                                        if (objParent.getAttribute("frame") != null) {
                                                intTop += 1;
                                        }
                                } else {
                                        intTop += intBorder;
                                }
                        }
                        intTop += objParent.offsetTop;
                        objParent = objParent.offsetParent;
                }
        }
        return intTop;
}
//! Public Method emxUICore.getCurrentStyle()
//!     This function gets the current style object for the given
//!     DOM object.
emxUICore.getCurrentStyle = function _emxUICore_getCurrentStyle(objElement, objWindow) {
        if (isIE) {
                return objElement.currentStyle;
        } else {
                return document.defaultView.getComputedStyle(objElement, "");
        }
}
emxUICore.getData = function _emxUICore_getData(strURL) {
        if(typeof strURL != "string") {
                emxUICore.throwError("Required parameter strURL is null or not a string.");
        }
        var objHTTP = this.createHttpRequest();
        objHTTP.open("get", strURL, false);
        objHTTP.send(null);
        return objHTTP.responseText;
};
emxUICore.getEvent = function _emxUICore_getEvent_IE(objWin) {
        var objEvent;
        if (isIE) {
                objWin = (objWin == null ? window : objWin);
                objEvent = objWin.event;
                if (objEvent == null) {
                    emxUICore.throwError("No event object found.");
                }
                if (!objEvent.target) {
                    objEvent.target = objEvent.srcElement;
                }
                objEvent.currentTarget = objEvent.target;
                objEvent.charCode = objEvent.keyCode;
                objEvent.preventDefault = function () { this.returnValue = false; };
                objEvent.preventBubble = objEvent.stopPropagation = function () { this.cancelBubble = true; };
        } else {
                objEvent = arguments.callee.caller.arguments[0];
        }
        return objEvent;
};

//! Private Function submitList()
//!     This function handles actions on a list of items. It takes a URL
//!     and assigns it to a form, submits the form, and displays the
//!     result in a specified location.
function submitList(strURL, strTarget, strRowSelect, bPopup, iWidth, iHeight, confirmationMessage){
        var objListWindow = findFrame(parent, "listDisplay");
/*
        var confirmationMessage ="";

        if(confirmationMessage != null && confirmationMessage != "null" && confirmationMessage != "")
        {
            var arrFrames = new Array("listHead", "listFoot","formViewHeader");
            var objFrameActionBar;
            for (var z=0; z < arrFrames.length; z++) {
                 objFrameActionBar = findFrame(top, arrFrames[z]);
                 if(objFrameActionBar){
                 var strObj=objFrameActionBar.document.actionBar;
                     if(strObj){
                         if( eval("strObj['" + commandName+"']") ) {
                            confirmationMessage = eval("strObj['" + commandName + "'].value");
                            break;
                          }
                      }
                 }
            }
         }
*/

        if (!objListWindow){
			objListWindow = findFrame(top, "listDisplay");
			if (!objListWindow){
				objListWindow = parent.frames['formEditDisplay'];
			}

			if (!objListWindow){
				objListWindow = parent.frames[1];
			}
        }

        var objForm = objListWindow.document.forms[0];
        var iChecks = 0;
        var isOkToSubmit=true;
        var bResponse=false;
        var bMoreThanOneItem=false;
        if(eval("objForm." + STR_CHECKBOX_NAME )){
                if (eval("objForm." + STR_CHECKBOX_NAME + ".length") == null){
                }else{
                        bMoreThanOneItem=true;
                        for(var i = 0; i < eval("objForm." + STR_CHECKBOX_NAME + ".length"); i++) {
                                if (eval("objForm." + STR_CHECKBOX_NAME + "[i].checked")) {
                                        iChecks++;
                                }
                        }
                }
                if ((!bMoreThanOneItem) && (eval("objForm." + STR_CHECKBOX_NAME +".checked")) && (eval("objForm." + STR_CHECKBOX_NAME!=null))){
                        iChecks++;
                }
        }
        if (strRowSelect == "single" && iChecks > 1) {
                showError(emxUIConstants.ERR_SELECT_ONLY_ONE);
                return;
        } else if ((iChecks == 0) && strRowSelect != "none" ) {
                showError(emxUIConstants.ERR_NONE_SELECTED);
                return;
        }
        if(confirmationMessage!=null && confirmationMessage!="undefined" && confirmationMessage!="null" && confirmationMessage!=""){
                if (confirmationMessage.indexOf("${TABLE_SELECTED_COUNT}") > 0){
                        var selectedCount = 0;
                        if (parent.ids) {
                                var arrayItems = parent.ids.match(new RegExp("~", "g"));
                                if (arrayItems != null){
                                        selectedCount = arrayItems.length -1;
                                }
                        }
                        confirmationMessage = confirmationMessage.replace(new RegExp("\\$\\{TABLE_SELECTED_COUNT\\}","g"), selectedCount);
                }
                var bResponse=window.confirm(confirmationMessage);
                if(bResponse){
                        isOkToSubmit=true;
                } else {
                        return;
                }
        }

        if (bPopup) {
                showModalDialog("emxAEFSubmitPopupAction.jsp?url="+escape(strURL), iWidth, iHeight, "true");
                return;
        }

        if (strTarget){
                objForm.target = strTarget;
        }
        if(isOkToSubmit) {
                objForm.action = strURL;
                objForm.submit();
        }
}

//! Private Method emxUICore.getStyleSheet()
//!     This function creates the style sheet string for a given style sheet prefix.
emxUICore.getStyleSheet = function _emxUICore_getStyleSheet(strCSSPrefix) {
        var strCSSFile = emxUIConstants.DIR_STYLES + strCSSPrefix;
        if (isUnix) {
                strCSSFile += "_Unix.css";
        } else {
                strCSSFile += ".css";
        }
        return strCSSFile;
}
emxUICore.getTagNameEMX = function _emxUICore_getTagNameEMX(objElement) {
        if (isIE) {
                return (objElement.tagName.indexOf("emx:") == -1 ? "emx:" + objElement.tagName : objElement.tagName);
        } else {
                return (objElement.tagName.toLowerCase().indexOf("emx:") == -1 ? "emx:" + objElement.tagName.toLowerCase() : objElement.tagName.toLowerCase());
        }
};
emxUICore.getWindowHeight = function _emxUICore_getWindowHeight(objWin) {
        objWin = (objWin == null ? window : objWin);
        if (isIE) {
                return objWin.document.body.clientHeight;
        } else {
                return objWin.innerHeight;
        }
};
emxUICore.getWindowWidth = function _emxUICore_getWindowWidth_IE(objWin) {
        objWin = (objWin == null ? window : objWin);
        if (isIE) {
                return objWin.document.body.clientWidth;
        } else {
                return objWin.innerWidth;
        }
};
emxUICore.getXMLData = function _emxUICore_getXMLData(strURL) {
        if(typeof strURL != "string") {
                emxUICore.throwError("Required parameter strURL is null or not a string.");
        }
        var objHTTP = this.createHttpRequest();
        objHTTP.open("get", strURL, false);
        objHTTP.send(null);
        var objDOM = this.createXMLDOM();
        objDOM.loadXML(objHTTP.responseText);
        this.checkDOMError(objDOM);
        return objDOM;
};
emxUICore.getXMLDataPost = function _emxUICore_getXMLDataPost(strURL, strData) {
        if(typeof strURL != "string") {
                emxUICore.throwError("Required parameter strURL is null or not a string.");
        }
        var objHTTP = this.createHttpRequest();
        objHTTP.open("post", strURL, false);
        objHTTP.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF-8");
        objHTTP.send(strData);
        var objDOM = this.createXMLDOM();
        objDOM.loadXML(objHTTP.responseText);
        this.checkDOMError(objDOM);
        return objDOM;
};
emxUICore.getDataPost = function _emxUICore_getXMLDataPost(strURL, strData) {
        if(typeof strURL != "string") {
                emxUICore.throwError("Required parameter strURL is null or not a string.");
        }
        var objHTTP = this.createHttpRequest();
        objHTTP.open("post", strURL, false);
        objHTTP.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        objHTTP.send(strData);
        return objHTTP.responseText;
};

//! Public Method emxUICore.hide()
//!      This method hides an HTML element.
emxUICore.hide = function _emxUICore_hide(objElement) {
        objElement.style.visibility = "hidden";
};
emxUICore.removeEventHandler = function _emxUICore_removeEventHandler(objElement, strType, fnHandler, blnCapture) {
        if (typeof objElement != "object") {
                emxUICore.throwError("Required argument objElement is null or not an object.");
        } else if (typeof strType != "string") {
                emxUICore.throwError("Required argument strType is null or not a string.");
        } else if (typeof fnHandler != "function") {
        }
        if (isIE) {
                objElement.detachEvent("on" + strType, fnHandler);
        } else {
                objElement.removeEventListener(strType, fnHandler, !!blnCapture);
        }
};
//! Public Method emxUICore.show()
//!      This method shows an HTML element.
emxUICore.show = function _emxUICore_show(objElement) {
        objElement.style.visibility = "visible";
};
//! Public Method emxUICore.stopPropagation()
//!      This method stops the propagation of an event.
emxUICore.stopPropagation = function _emxUICore_stopPropagation() {
        this.getEvent().stopPropagation();
};
emxUICore.debug = new Object;
emxUICore.debug.text = new emxUIStringBuffer;
emxUICore.debug.on = false;
emxUICore.debug.window = null;
emxUICore.debug.enumObject = function _emxUICore_debug_enumObject(objObject) {
        var arrTemp = new Array;
        for (var strAttribute in objObject) {
                arrTemp.push(strAttribute);
        }
        arrTemp.sort();
        this.write("<table border=\"0\"><tr><th>Attribute/Method</th><th>Type</th><th>Value</th></tr>");
        for (var i=0; i < arrTemp.length; i++) {
                var strType = typeof objObject[arrTemp[i]];
                this.write("<tr><td>");
                this.write(arrTemp[i]);
                this.write("</td><td>");
                this.write(strType);
                this.write("</td><td>");
                if (strType == "string") {
                        this.write("\"" + objObject[arrTemp[i]] + "\"");
                } else {
                        this.write(objObject[arrTemp[i]]);
                }
                this.write("</td></tr>");
        }
        this.write("</table>");
}
emxUICore.debug.getFunctionName = function _emxUICore_debug_getFunctionName(fnFunction) {
        var reName = /function\s*(\S*)\s*\(/;
        reName.test(fnFunction.toString());
        return (RegExp.$1 == "" ? "[anonymous]" : RegExp.$1);
};
emxUICore.debug.write = function _emxUICore_debug_write(strText) {
        this.text.write(strText);
};
emxUICore.debug.writeln = function _emxUICore_debug_writeln(strText) {
        this.text.write(strText + "<br />");
};
emxUICore.debug.handleError = function _emxUICore_debug_handleError(objError, strFile) {
        if (this.on) {
                this.writeln("<p><span style=\"color:red;font-weight:bold\">A JavaScript Error occurred: </span>");
                this.writeln("<b>Message: </b>" + objError.message);
                this.writeln("<b>Line: </b>" + objError.lineNumber);
                this.write("<b>JavaScript File: </b>" +strFile + "</p>");
                if (!isMinMoz1) {
                        this.writeCallStack(arguments.callee.caller);
                } else {
                        this.writeCallStack(objError.stack);
                }
                if (this.window && !this.window.closed) {
                        this.refresh();
                } else {
                    this.open();
                }
                if (isIE) {
                        window.event.returnValue = false;
                }
        } else {
        }
        return !this.on;
};
emxUICore.debug.open = function _emxUICore_debug_open() {
        this.window = window.open("", null, "width=1000,height=500,scrollbars=yes,resizable=yes");
        emxUICore.debug.refresh();
};
emxUICore.debug.refresh = function _emxUICore_debug_refresh() {
        if (this.window && !this.window.closed) {
                with (this.window.document) {
                        open();
                        write("<html><head><title></title><style>* { background-color: black; color: white; font-family: Courier New} th { text-align: left }</style></head><body><p>=============================================================<br />JavaScript Debugger<br />=============================================================</p>");
                        write(this.text);
                        write("</body></html>");
                        close();
                }
        }
};
emxUICore.debug.writeCallStack = function _emxUICore_debug_writeCallStack(fnFunction) {
        var fnTemp = fnOriginal = fnFunction || arguments.callee.caller;
        while (fnTemp != null) {
                if (fnTemp == fnOriginal) {
                        this.writeln("<p><span style=\"color:red; font-weight: bold;\">Error caused in:</span>")
                } else {
                        this.writeln("<p>Called by function:");
                }
                var strTemp = "";
                for (var i=0; i < fnTemp.arguments.length; i++) {
                        if (i > 0) {
                                strTemp += ", ";
                        }
                        var strType = typeof fnTemp.arguments[i]
                        strTemp +=  strType + " ";
                        if (strType == "string") {
                                strTemp += "\"" + fnTemp.arguments[i] + "\"";
                        } else {
                                strTemp += fnTemp.arguments[i];
                        }
                }
                this.writeln("<b>" + this.getFunctionName(fnTemp) + "(" + strTemp + ")</b>");
                this.write("</p>");
                fnTemp = fnTemp.caller;
        }
        this.refresh();
};
function emxUIObject() {
        this.emxClassName = "emxUIObject";
        this.enabled = true;
        this.eventHandlers = new Object;
}
emxUIObject.prototype.disable = function _emxUIObject_disable() {
        this.enabled = false;
};
emxUIObject.prototype.enable = function _emxUIObject_enable() {
        this.enabled = true;
};
emxUIObject.prototype.fireEvent = function _emxUIObject_fireEvent(strType, objEvent) {
        if (typeof strType != "string") {
                emxUICore.throwError("Required argument strType is null or not a string.");
        }
        if (this.enabled) {
                if (typeof this.eventHandlers[strType] != "undefined") {
                        for (var i=0; i < this.eventHandlers[strType].length; i++) {
                                this.eventHandlers[strType][0](objEvent);
                        }
                }
                if (typeof this["on" + strType] == "function") {
                        this["on" + strType](objEvent);
                }
        }
}
emxUIObject.prototype.registerEventHandler = function _emxUIObject_registerEventHandler(strType, fnHandler) {
        if (typeof strType != "string") {
                emxUICore.throwError("Required argument strType is null or not a string.");
        } else if (typeof fnHandler != "function") {
                emxUICore.throwError("Required argument fnHandler is null or not a function.");
        }
        if (typeof this.eventHandlers[strType] == "undefined") {
                this.eventHandlers[strType] = new Array;
        }
        this.eventHandlers[strType].push(fnHandler);
}
emxUIObject.prototype.toString = function _emxUIObject_toString() {
        return "[object " + this.emxClassName + "]";
}
emxUIObject.prototype.unregisterEventHandler = function _emxUIObject_unregisterEventHandler(strType, fnHandler) {
        if (typeof strType != "string") {
                emxUICore.throwError("Required argument strType is null or not a string.");
        } else if (typeof fnHandler != "function") {
                emxUICore.throwError("Required argument fnHandler is null or not a function.");
        }
        if (typeof this.eventHandlers[strType] != "undefined") {
                this.eventHandlers[strType].remove(fnHandler);
        }
}
function emxUIImageLoader() {
        this.superclass = emxUIObject;
        this.superclass();
        delete this.superclass;
        this.emxClassName = "emxUIImageLoader";
        this.images = new Array;
        this.loaded = 0;
}
emxUIImageLoader.prototype = new emxUIObject;
emxUIImageLoader.prototype.addImage = function _emxUIImageLoader_addImage(strImage, strID) {
        if (typeof strImage != "string") {
                emxUICore.throwError("Required argument strImage is null or not a string.");
        }
        var objImg = new Image;
        var objThis = this;
        this.images[this.images.length] = objImg;
        if (strID) {
                this.images[strID] = objImg;
        }
        objImg.onload = function () {
                objThis.handleImageLoad();
        };
        objImg.onerror = function () {
                emxUICore.throwError("The image " + this.src + "could not be found.");
        };
        objImg._src = strImage;
};
emxUIImageLoader.prototype.begin = function _emxUIImageLoader_begin() {
        for (var i=0; i < this.images.length; i++) {
                this.images[i].src = this.images[i]._src;
        }
};
emxUIImageLoader.prototype.clear = function _emxUIImageLoader_clear() {
        this.images = new Array;
        this.loaded = 0;
};
emxUIImageLoader.prototype.handleImageLoad = function _emxUIImageLoader_handleImageLoad() {
        this.loaded++;
        if (this.loaded == this.images.length) {
                this.fireEvent("load");
        }
};
if (isMoz) {
    Document.prototype.loadXML = function(strXML) {
        var objDOMParser = new DOMParser();
        var objDoc = objDOMParser.parseFromString(strXML, "text/xml");
		while (this.hasChildNodes())
			this.removeChild(this.lastChild);
        for (var i=0; i < objDoc.childNodes.length; i++) {
            var objImportedNode = this.importNode(objDoc.childNodes[i], true);
            this.appendChild(objImportedNode);
        }
    }
    Element.prototype.__getElementsByTagName__ = Element.prototype.getElementsByTagName;
    Element.prototype.getElementsByTagName = function (strTagName) {
        if (strTagName.indexOf("emx:") == 0) {
            strTagName = strTagName.substring(4, strTagName.length);
        }
        return this.__getElementsByTagName__(strTagName);
    }
    Node.prototype.__defineGetter__("xml", function _Node_xml_getter () {
        var objXMLSerializer = new XMLSerializer;
        var strXML = objXMLSerializer.serializeToString(this);
        return strXML;
    });
}
