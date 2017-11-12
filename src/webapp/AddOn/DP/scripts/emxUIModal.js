/*!================================================================
 *  JavaScript Modal Dialog
 *  emxUIModal.js
 *  Version 1.5
 *  Requires: emxUIConstants.js
 *  Last Updated: 28-Apr-03, Nicholas C. Zakas (NCZ)
 *
 *  This file contains the class definition of the structure tree.
 *
 *  Copyright (c) 1992-2003 MatrixOne, Inc. All Rights Reserved.
 *  This program contains proprietary and trade secret information
 *  of MatrixOne,Inc. Copyright notice is precautionary only
 *  and does not evidence any actual or intended publication of such program
 *
  *  static const char RCSID[] = $Id: emxUIModal.js,v 1.2 2005/02/15 00:40:18 kgw Exp $
 *=================================================================
 */
var strUserAgent_M = navigator.userAgent.toLowerCase();
var isIE_M = strUserAgent_M.indexOf("msie") > -1 && strUserAgent_M.indexOf("opera") == -1;
var isMinIE5_M = false,isMinIE55_M = false,isMinIE6_M = false;
if (isIE_M) {
    var reIE_M = new RegExp("msie (\\S*);");
    reIE_M.test(strUserAgent_M);
    var fVer_M = parseFloat(RegExp["$1"]);
    isMinIE5_M = fVer_M >= 5;
    isMinIE55_M = fVer_M >= 5.5;
    isMinIE6_M = fVer_M >= 6;
}
var isNS6_M = strUserAgent_M.indexOf("netscape6") > -1 && strUserAgent_M.indexOf("opera") == -1;
var isMinNS6_M = isNS6_M,isMinNS61_M = false,isMinNS62_M = false;
if (isNS6_M) {
    var reNS6_M = new RegExp("netscape6\\/(\\S*)");
    reNS6_M.test(strUserAgent_M);
    var fVer_M = parseFloat(RegExp["$1"]);
    isMinNS6_M = (fVer_M >= 6);
    isMinNS61_M = (fVer_M >= 6.1);
    isMinNS62_M = (fVer_M >= 6.2);
}
var isNS4_M = !isIE_M && !isNS6_M  && parseFloat(navigator.appVersion) < 5 && strUserAgent_M.indexOf("opera") == -1;

var isGecko_M = strUserAgent_M.indexOf("gecko") > -1;
var isMoz_M = isGecko_M || isNS6_M;
var isMac_M = navigator.platform.indexOf("Mac") > -1;

//! Class emxUIModalDialog
//!     This class represents a modal dialog window. This class
//!     should not be instantiated directly by a developer.
function emxUIModalDialog(objParent, strURL, intWidth, intHeight, blnScrollbars) {
        if (isIE_M) {
                return new emxUIIEModalDialog(objParent, strURL, intWidth, intHeight, blnScrollbars);
        } else {
                return new emxUIMozillaModalDialog(objParent, strURL, intWidth, intHeight, blnScrollbars);
        }
}

//! Public Function showModalDialog()
//!     This function opens a modal dialog window and centers it.
function showModalDialog(strURL, intWidth, intHeight, bScrollbars) {
        if (!top.modalDialog || top.modalDialog.contentWindow.closed) {
                var objModalDialog = new emxUIModalDialog(self, strURL, intWidth, intHeight, bScrollbars);
                objModalDialog.show();
        } else {
                if (top.modalDialog) {
                        top.modalDialog.show();
                }

        }
}

//! Public Function showDialog()
//!     This function shows a generic dialog.
//!     This function is considered public and may be used
//!     by developers.
function showDialog(strURL) {
        showModalDialog(strURL, 570, 520,true);
}
//! Public Function showListDialog()
//!     This function shows a generic list dialog.
//!     This function is considered public and may be used
//!     by developers.
function showListDialog(strURL) {
        showModalDialog(strURL, 730, 450,true);
}
//! Public Function showTreeDialog()
//!     This function shows a generic tree dialog.
function showTreeDialog(strURL) {
        showModalDialog(strURL, 400, 400,true);
}
//! Public Function showWizard()
//!     This function shows a wizard dialog.
//!     This function is considered public and may be used
//!     by developers.
function showWizard(strURL) {
        showModalDialog(strURL, 780, 500,true);
}
//! Public Function showDetailsPopup()
//!     This function shows a details tree in a popup window.
//!     This function is considered public and may be used
//!     by developers.
function showDetailsPopup(strURL) {
        showNonModalDialog(strURL, 875, 550,true);
}
//! Public Function showSearch()
//!     This function shows a search dialog.
//!     This function is considered public and may be used
//!     by developers.
function showSearch(strURL) {
        showNonModalDialog(strURL, 700, 500,true);
}
//! Public Function showChooser()
//!     This function shows a chooser dialog.
//!     This function is considered public and may be used
//!     by developers.
function showChooser(strURL,intWidth,intHeight) {
        if(intWidth == null || intWidth=="" ) {
                intWidth="700";
        }
        if(intHeight == null || intHeight=="" ) {
                intHeight="500";
        }
        showModalDialog(strURL, intWidth, intHeight,true);
}
//! Public Function showPrinterFriendlyPage()
//!     This function shows a printer-friendly page.
//!     This function is considered public and may be used
//!     by developers.
function showPrinterFriendlyPage(strURL) {
        var strFeatures = "scrollbars=yes,toolbar=yes,location=no";
        if (isNS4_M) {
                strFeatures += ",resizable=no";
        } else {
                strFeatures += ",resizable=yes";
        }
	var objWindow = window.open(strURL, "PF" + (new Date()).getTime(), strFeatures).focus();
       	registerChildWindows(objWindow, top);
}
//! Public Function showPopupListPage()
//!     This function shows a popup list page.
//!     This function is considered public and may be used
//!     by developers.
function showPopupListPage(strURL) {
	showNonModalDialog(strURL, 700, 500,true);
}
//! Public Function showModalDetailsPopup()
//!     This function is a wrapper for showModalDialog.
//!     This function is considered public and may be used
//!     by developers.
function showModalDetailsPopup(strURL) {
        showModalDialog(strURL, 760,600,true);
}
//! Public Function showNonModalDialog()
//!     This function shows a non-modal (regular) dialog.
//!     This function is considered public and may be used
//!     by developers.
 
function showNonModalDialog(strURL, intWidth, intHeight, bScrollbars) {
        var strFeatures = "width=" + intWidth + ",height=" + intHeight;
        var intLeft = parseInt((screen.width - intWidth) / 2);
        var intTop = parseInt((screen.height - intHeight) / 2);
        strURL = addSuiteDirectory(strURL);
        if (isIE_M) {
                strFeatures += ",left=" + intLeft + ",top=" + intTop;
        } else{
                strFeatures += ",screenX=" + intLeft + ",screenY=" + intTop;
        }
        if (isNS4_M) {
                strFeatures += ",resizable=no";
        } else {
                strFeatures += ",resizable=yes";
        }
        // Passing an additional parameter for scrollbars
        if (bScrollbars)
        {
             strFeatures += ",scrollbars=yes";
        } 

        var objWindow = window.open(strURL, "NonModalWindow" + (new Date()).getTime(), strFeatures);
        registerChildWindows(objWindow, top);
        objWindow.focus();
}
//! Public Function registerChildWindows()
//!     This function registers a child window with the parent
//!     window in order to keep track and close when a logout occurs.
//!     This function is considered public and may be used
//!     by developers.
function registerChildWindows(objChild, objParent) {
        if (objParent.childWindows) {
                objParent.childWindows[objParent.childWindows.length] = objChild;
        } else if (objParent.top.opener != null) {
            if(!objParent.opener.closed){
                var objParentTop = objParent.opener.top;
                registerChildWindows(objChild, objParentTop);
            }
        }
}
//! Public Function closeAllChildWindows()
//!     This function closes all registered child windows.
//!     This function is considered public and may be used
//!     by developers.
function closeAllChildWindows() {
        if (top.childWindows){
                for (var i=0; i < top.childWindows.length; i++) {
                        if (top.childWindows[i] && !top.childWindows[i].closed) {
                                top.childWindows[i].close();
                        }
                }
        }
}
//! Public Function addSuiteDirectory()
//!     This function add the URL parameter "emxSuiteDirectory"
//!     to the URL, if it is "emxTree.jsp?.."
//!     This function is considered public and may be used
//!     by developers.
function addSuiteDirectory(strURL) {
        var strNewURL = strURL;
        if (strNewURL.indexOf("emxTree.jsp?") > -1){
                var strLoc = document.location.href;
                var strParam;
                var intIndex = strLoc.lastIndexOf("/");
                strLoc = strLoc.substring(0,intIndex);
                intIndex = strLoc.lastIndexOf("/");
                strLoc = strLoc.substring(intIndex+1,strLoc.length);
                if (strLoc) {
                        strParam = "emxSuiteDirectory=" + strLoc;
        	        if (strNewURL.indexOf("emxSuiteDirectory=") == -1) {
            	                strNewURL += (strNewURL.indexOf('?') > -1 ? '&' : '?') + strParam;
                        }
                }
	}
        return strNewURL;
}

//------------------------------------------------------------
function emxUICoreModalDialog(strURL, intWidth, intHeight, blnScrollbars) {
        this.contentWindow = null;
        this.height = intHeight;
        this.parentWindow = null;
        this.scrollbars = !!blnScrollbars;
        this.url = strURL;
        this.width = intWidth;
}

emxUICoreModalDialog.prototype.capture = function () {

};

emxUICoreModalDialog.prototype.captureMouse = function (objWindow) {
        if (!objWindow) {
                throw new Error("No window provided for capture. (emxUICoreModalDialog.prototype.captureMouse)");
        }
        if (objWindow.frames.length > 0) {
                for (var i=0; i < objWindow.frames.length; i++) {
                        this.captureMouse(objWindow.frames[i]);
                }
        } else {
        	this.capture(objWindow);
        }
};

emxUICoreModalDialog.prototype.checkFocus = function () {

        if (this.contentWindow && !this.contentWindow.closed) {
                try {
					if (this.contentWindow.modalDialog && this.contentWindow.modalDialog.contentWindow
							&& !this.contentWindow.modalDialog.contentWindow.closed) {
							this.contentWindow.modalDialog.checkFocus();
					} else {
							this.show();
					}
                } catch (objException) {
				}
        } else {
                this.release(this.parentWindow);
                this.releaseMouse(this.parentWindow);
        }
};

emxUICoreModalDialog.prototype.getFeatureString = function () {
        return "";
};

emxUICoreModalDialog.prototype.release = function () {

};

emxUICoreModalDialog.prototype.releaseMouse = function (objWindow) {
        if (!objWindow) {
                objWindow = this.parentWindow;
        }
        if (objWindow.frames.length > 0) {
                for (var i=0; i < objWindow.frames.length; i++) {
                        this.releaseMouse(objWindow.frames[i]);
                }
        } else {
        	this.release(objWindow);
        }

};

emxUICoreModalDialog.prototype.show = function () {
        if (!this.contentWindow || this.contentWindow.closed) {
                this.parentWindow.top.modalDialog = this;
                this.contentWindow = window.open(this.url, "ModalDialog" + (new Date()).getTime(), this.getFeatureString());
                this.capture(this.parentWindow);
                this.captureMouse(this.parentWindow);
        }

        if (!this.contentWindow) {
                throw new Error("The modal dialog failed to create the new window. (emxUICoreModalDialog.prototype.show)");
        }

        this.contentWindow.focus();
};


//-----------------------------------------------------------------


function emxUIMozillaModalDialog(objParent, strURL, intWidth, intHeight, blnScrollbars) {
        emxUICoreModalDialog.call(this, strURL, intWidth, intHeight, blnScrollbars);
        this.parentWindow = objParent.top;

        var objThis = this;
        this.fnTemp = function (objEvent) {
                objThis.checkFocus()
                objEvent.stopPropagation();
                objEvent.preventDefault();
        };
}

emxUIMozillaModalDialog.prototype = new emxUICoreModalDialog;

emxUIMozillaModalDialog.prototype.getFeatureString = function () {
        var strFeatures = "width=" + this.width + ",height=" + this.height;
        strFeatures += ",resizable=yes,modal=yes";
        var intLeft = parseInt((screen.width - this.width) / 2);
        var intTop = parseInt((screen.height - this.height) / 2);
        strFeatures += ",screenX=" + intLeft + ",screenY=" + intTop;
        if (this.scrollbars) {
                strFeatures += ",scrollbars=yes";
        }
        return strFeatures;
};

emxUIMozillaModalDialog.prototype.capture = function (objWindow) {
        if (!objWindow) {
                throw new Error("No window provided for release. (emxUIMozillaModalDialog.prototype.release)");
        }
        if (typeof objWindow.name =="string" && objWindow.name.toLowerCase().indexOf("hidden") > -1) return;
        objWindow.addEventListener("click", this.fnTemp, true);
        objWindow.addEventListener("mousedown", this.fnTemp, true);
        objWindow.addEventListener("mouseup", this.fnTemp, true);
        objWindow.addEventListener("focus", this.fnTemp, true);
};

emxUIMozillaModalDialog.prototype.release = function (objWindow) {
        if (!objWindow) {
                return;
                throw new Error("No window provided for release. (emxUIMozillaModalDialog.prototype.release)");
        }
        if (typeof objWindow.name =="string" && objWindow != objWindow.top && objWindow.name.toLowerCase().indexOf("hidden") > -1) return;
		try{
			objWindow.removeEventListener("click", this.fnTemp, true);
			objWindow.removeEventListener("mousedown", this.fnTemp, true);
			objWindow.removeEventListener("mouseup", this.fnTemp, true);
			objWindow.removeEventListener("focus", this.fnTemp, true);
		}catch (objError) {
		}
};

//-----------------------------------------------------------------

function emxUIIEModalDialog(objParent, strURL, intWidth, intHeight, blnScrollbars) {
        emxUICoreModalDialog.call(this, strURL, intWidth, intHeight, blnScrollbars);
        this.parentWindow = objParent;

        var objThis = this;
        this.fnTemp = function () {
                objThis.checkFocus();
                return false;
        };
}

emxUIIEModalDialog.prototype = new emxUICoreModalDialog;

emxUIIEModalDialog.prototype.getFeatureString = function () {
        var strFeatures = "width=" + this.width + ",height=" + this.height + ",resizable=yes";
        var intLeft = parseInt((screen.width - this.width) / 2);
        var intTop = parseInt((screen.height - this.height) / 2);
        strFeatures += ",left=" + intLeft + ",top=" + intTop;
        if (this.scrollbars) {
                strFeatures += ",scrollbars=yes";
        }
        return strFeatures;
};

emxUIIEModalDialog.prototype.capture = function (objWindow) {
        if (!objWindow) {
                throw new Error("No window provided for release. (emxUIIEModalDialog.prototype.release)");
        }
        var objCapture = objWindow.document.body;
        if (!objCapture) return;
        objCapture.setCapture();
        objCapture.onclick = this.fnTemp;
        objCapture.ondblclick = this.fnTemp;
        objCapture.onmouseover = this.fnTemp;
        objCapture.onmouseout = this.fnTemp;
        objCapture.onmousemove = this.fnTemp;
        objCapture.onmousedown = this.fnTemp;
        objCapture.onmouseup = this.fnTemp;
        objCapture.onfocus = this.fnTemp;
        objCapture.oncontextmenu = this.fnTemp;
};

emxUIIEModalDialog.prototype.release = function (objWindow) {
        if (!objWindow) {
                return;
                throw new Error("No window provided for release. (emxUIIEModalDialog.prototype.release)");
        }
        var objCapture = objWindow.document.body;
        if (!objCapture) return;
        objCapture.releaseCapture();
        objCapture.onclick = null;
        objCapture.ondblclick = null;
        objCapture.onmouseover = null;
        objCapture.onmouseout = null;
        objCapture.onmousemove = null;
        objCapture.onmousedown = null;
        objCapture.onmouseup = null;
        objCapture.onfocus = null;
        objCapture.oncontextmenu = null;
};

emxUIIEModalDialog.prototype.show = function () {
        if (!this.contentWindow || this.contentWindow.closed) {
                this.parentWindow.top.modalDialog = this;
                this.contentWindow = window.open(this.url, "ModalDialog" + (new Date()).getTime(), this.getFeatureString());
                registerChildWindows(this.contentWindow, top);
                this.capture(this.parentWindow);
                this.captureMouse(this.parentWindow);
        }
        if (!this.contentWindow) {
                throw new Error("The modal dialog failed to create the new window. (emxUICoreModalDialog.prototype.show)");
        }

        this.contentWindow.focus();
};
