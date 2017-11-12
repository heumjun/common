	// trim()
	String.prototype.trim = function() { return this.replace(/(^\s*)|(\s*$)/g, ""); }
	
	// replaceAmpAll() : '&' 를 '‥'로, '%' 를 '¨' 변경
	String.prototype.encodeURI = function() 
	{ 
		return encodeURIComponent(this);
	}
	
	function fnRemoveAll(vTableId)
	{
		var doc = document;
		var oTbl = doc.getElementById(vTableId);
		for(var index =(oTbl.rows.length-1) ;0 < index  ;index--)
		{
			oTbl.deleteRow(index);
		}
		doc = null;
		oTbl = null;
	}
	
	function fnCheckedObj(vName)
	{
		var arrReturn = new Array();
		var doc = document;
		var arrChk = doc.getElementsByName(vName);
		try{
			for(var i=0;i<arrChk.length;i++)
			{
				if(arrChk[i].type == "checkbox" && arrChk[i].checked)
				{
					arrReturn[arrReturn.length] = arrChk[i];
				}
			}
			return arrReturn;
		} catch (e) {
			alert(e);
		} finally {
			doc = null;
			arrChk = null;
			arrReturn = null;
		}
	}
	
	function fnCheckedObjValue(vName)
	{
		var arrReturn = new Array();
		var doc = document;
		var arrCheckedObj = fnCheckedObj(vName);
		try{
			for(var i=0;i<arrCheckedObj.length;i++)
			{
				arrReturn[arrReturn.length] = arrCheckedObj[i].value;
			}
			return arrReturn;
		} finally {
			doc = null;
			arrCheckedObj = null;
			arrReturn = null;
		}
	}
	
	function addNewCellSimple(oCell,vInnerHTML,vClass,vWidth,vAlign,vColSpan)
	{
		try{
			oCell.innerHTML = vInnerHTML;
			if(vClass)oCell.className = vClass;
			if(vWidth)oCell.width = vWidth;
			
			if(vAlign)
			{
				oCell.align = vAlign;
			} else {
				oCell.align = "center";
			}
			
			if(vColSpan)
			{
				oCell.colSpan = vColSpan;
			}
			
			return oCell;
		} finally {
			oCell = null;
			vInnerHTML = null;
			vClass = null;
			vWidth = null;
			vAlign = null;
			vColSpan = null;
		}
	}
	
	function addNewCellwithChild(oCell,oChild,vClass,vWidth,vAlign)
	{
		try{
			if(vClass)oCell.className = vClass;
			if(vWidth)oCell.width = vWidth;
			oCell.appendChild(oChild);
			
			if(vAlign)
			{
				oCell.align = vAlign;
			} else {
				oCell.align = "center";
			}
			return oCell;
		} finally {
			oCell = null;
			oChild = null;
			vClass = null;
			vWidth = null;
			vAlign = null;
		}
	}
	
	function fnCheckBoxHtml(vName,vId,vOnclick)
	{
		var doc = document;
		var oCheckBox = doc.createElement("<input type='checkbox' name='"+vName+"' >");
		try{
			if(vId)oCheckBox.id=vId
			if(vOnclick)
			{
				oCheckBox.attachEvent("onclick",eval(vOnclick))
			}
			return oCheckBox;
		} finally {
			doc = null;
			oCheckBox = null;
			vName = null;
			vId = null;
			vOnclick = null;
		}
	}
	
	function fnSetColEditableText(oRow,indexCol,vEvent,vFunction)
	{
		if(oRow.childNodes && oRow.childNodes.length > indexCol)
		{
			var oCol = oRow.childNodes[indexCol];
			oCol.attachEvent(vEvent,eval(vFunction));
			oCol = null;
		}
	}
	
	function fnButton(vName,vId,vOnclick)
	{
		var doc = document;
		var oBtn = doc.createElement("input");
		try{
			oBtn.id=vId
			oBtn.name=vName;
			oBtn.type="button";
			oBtn.value="Save"
			oBtn.attachEvent("onclick",eval(vOnclick))
		return oBtn;
		} finally {
			doc = null;
			oBtn = null;
			vName = null;
			vId = null;
			vOnclick = null;
		}
	}
	
	function fnInputText(vName,vId,vValue,vSize,vKeyDown)
	{
		var doc = document;
		var oText = doc.createElement("<input type='text' name='"+vName+"' >");
		try{
			if(vId)oText.id=vId
			if(vValue)oText.value=vValue;
			if(vSize)oText.size = vSize;
			if(vKeyDown)
			{
				oText.attachEvent("onkeydown",eval(vKeyDown))
			}
		return oText;
		} finally {
			doc = null;
			oText = null;
			vName = null;
			vId = null;
			vValue = null;
			vSize = null;
		}
	}
	
	
	function fnGetParentNode(oNode,vNodeName)
	{
		try{
			if(oNode.parentNode.nodeName == vNodeName)
			{
				return oNode.parentNode;
			} else {
				return fnGetParentNode(oNode.parentNode,vNodeName)
			}
			return null;
		} finally {
			oNode = null;
			vNodeName = null;
		}
	}
	
	function fnAddHiddenInput(vName,vValue)
	{
		var doc = document;
		var oHidden;
		try{
			oHidden = doc.createElement("<input type='hidden' name='"+vName+"' >");
			if(vValue)oHidden.value = vValue;
			return oHidden;
		} finally {
			doc = null;
			vName = null;
			vValue = null;
			oHidden = null;
		}
	}
	
	function fnDelFormAllChild(oForm)
	{
		for(var i=(oForm.childNodes.length-1);0<=i;i--)
		{
			oForm.removeChild(oForm.childNodes[i]);
		}
		oForm = null;
	}
	
	function fnGetParamFromForm(oForm)
	{
		try{
			var vParam = "";
			var elForm;
			for(var index=0;index<oForm.elements.length;index++)
			{
				elForm = oForm.elements[index];
				vParam += elForm.name + '=' + encodeURIComponent(elForm.value) + '&'
			}
			return vParam;
		} catch (e){
			alert(e);
		} finally {
			oForm = null;
			vParam = null;
			elForm = null;
		}
	}
	
	function fnGetDocRecordValue(oNode,vName)
	{
		try{
			for(var i=(oNode.childNodes.length-1);0<=i;i--)
			{
				if(oNode.childNodes[i].nodeName && oNode.childNodes[i].nodeName == vName)
				{
					return oNode.childNodes[i].text;
				}
			}
			return "";
		} finally {
			oNode = null;
			vName = null;
		}
	}
	
	function fnGetRecordHiddenValue(oRow,vName)
	{
		try{
			for(var i=(oRow.childNodes.length-1);0<=i;i--)
			{
				if(oRow.childNodes[i].nodeName && oRow.childNodes[i].nodeName == "INPUT" && oRow.childNodes[i].name == vName)
				{
					return oRow.childNodes[i].value;
				}
			}
			return "";
		} finally {
			oRow = null;
			vName = null;
		}
	}
	
	function fnGetRecordHidden(oRow,vName)
	{
		try{
			for(var i=(oRow.childNodes.length-1);0<=i;i--)
			{
				if(oRow.childNodes[i].nodeName && oRow.childNodes[i].nodeName == "INPUT" && oRow.childNodes[i].name == vName)
				{
					return oRow.childNodes[i];
				}
			}
			return "";
		} finally {
			vUpdateValue = null;
			oRow = null;
			vName = null;
		}
	}
	
	function fnGetSelectedRow()
	{
		var doc = document;
		var arrReturn = new Array();
		var oData = doc.getElementsByName("chkDataRow");
		try{
			for(var i=0;i<oData.length;i++)
			{
				if(oData[i].checked==true)
				{
					arrReturn[arrReturn.length] = fnGetParentNode(oData[i],"TR");
				}
			}
			return arrReturn;
		} finally {
			doc = null;
			arrReturn = null;
			oData = null;
		}
	}
	
	function fnGetTableDefineInfo(vTableId)
	{
		var arrReturn = null;
		try{
			var objAjax = new stxAjax('/ematrix/stxcentral/stxDynamicTableLoadProcess.jsp?TABLE_ID='+vTableId,"",true);
			var docInfo = objAjax.executeSync(true);
			arrReturn = docInfo.getElementsByTagName("RESULTRECORD");
			objAjax = null;
			docInfo = null;
			return arrReturn;
		} catch(e) {
			alert("Error Occur!(Loading Dynamic Table Definition)"+ e);
		} finally {
			arrReturn = null;
			vTableId = null;
		}
	}
	
	
	function fnGenDataTbl(arrColDefinition,oRow,nodeColumn,isAddCheckBox)
	{
		if(isAddCheckBox)
		{
			addNewCellwithChild(oRow.insertCell(),fnCheckBoxHtml("chkDataRow","chkDataRow"),"data_fix","2%");
		}
		
		for(i=0;i<arrColDefinition.length;i++)
		{
			var vColNode 		= arrColDefinition[i];
			var vCOL_FIX 		= fnGetDocRecordValue(vColNode,"COL_FIX");
			var vCOL_SIZE 		= fnGetDocRecordValue(vColNode,"COL_SIZE");
			var vCOL_TYPE 		= fnGetDocRecordValue(vColNode,"COL_TYPE");
			var vCOL_ALIAS 		= fnGetDocRecordValue(vColNode,"COL_ALIAS");
			var vCOL_EVENT 		= fnGetDocRecordValue(vColNode,"COL_EVENT");
			var vCOL_EVENT_SCRIPT 		= fnGetDocRecordValue(vColNode,"COL_EVENT_SCRIPT");
			
			var vClass = "data";
			if(vCOL_FIX == "TRUE")
			{
				vClass = "data_fix";
			}
			
			if(vCOL_TYPE == "HIDDEN")
			{
				oRow.appendChild(fnAddHiddenInput(vCOL_ALIAS,fnGetDocRecordValue(nodeColumn,vCOL_ALIAS)));
			} else {
				addNewCellSimple(oRow.insertCell(),fnGetDocRecordValue(nodeColumn,vCOL_ALIAS),vClass,vCOL_SIZE+"%");
			}
			
			if(vCOL_EVENT != "")
			{
				fnSetColEditableText(oRow,oRow.cells.length-1,vCOL_EVENT,vCOL_EVENT_SCRIPT);
			}
			
			vColNode = null;
			vCOL_FIX = null;
			vCOL_SIZE = null;
			vCOL_TYPE = null;
			vCOL_ALIAS = null;
			vCOL_EVENT = null;
			vCOL_EVENT_SCRIPT = null;
			vClass = null;
		}
		arrColDefinition = null;
		oRow = null;
		nodeColumn = null;
		isAddCheckBox = null;
	}
	
	function fnGetOption(oSelect,vUrl,DEFAULT_CODE)
	{
		var objAjax = new stxAjax(vUrl);
		var vReturn = objAjax.executeSync(true);
		var nodeResult = vReturn.getElementsByTagName("RESULTRECORD");
		
		if(!DEFAULT_CODE || DEFAULT_CODE == null)
		{
			oSelect.options[0] = new Option("","");
			oSelect.selectedIndex = 0;
		}
		
		for(var index=0 ;index<nodeResult.length;index++)
		{
			var nodeColumn = nodeResult[index];
			var vDISPLAY = fnGetDocRecordValue(nodeColumn,"DISPLAY");
			var vVALUE = fnGetDocRecordValue(nodeColumn,"VALUE");
			
			oSelect.options[oSelect.options.length] = new Option(vDISPLAY,vVALUE);
			
			if(DEFAULT_CODE && DEFAULT_CODE == vVALUE)
			{
				oSelect.selectedIndex = oSelect.options.length - 1;
			}
			
			nodeColumn = null;
			vDISPLAY = null;
			vVALUE = null;
		}
		
		DEFAULT_CODE = null;
		oSelect = null;
		objAjax = null;
		nodeResult = null;
		vReturn = null;
		index = null;
	}
	
	function fnChangeSimpleSelect(obj,vId)
	{	
		document.getElementById(vId).value = obj.options[obj.options.selectedIndex].text;
		document.getElementById("simpleSelectDiv").style.display="none";
	}
	
	function fnAddOtpionToSelect(objSelect,vValue,vText,isSelected)
	{
		var vIndex = objSelect.options.length;
		objSelect.options[vIndex] = new Option(vText,vValue);
		if(isSelected)
		{
				objSelect.selectedIndex = vIndex;
		}
		vIndex = null;
		objSelect = null;
		vValue = null;
		vText = null;
		isSelected = null;
	}
	
	function fnRemoveAllOptionSelect(objSelect)
	{
		var vStart = objSelect.options.length - 1;
		for(i=vStart;i>=0;i--)
		{
			objSelect.remove(i);
		}
		objSelect = null;
		vStart = null;
	}
	
	function fnViewSimpleSelect(obj)
	{
		var objRect = obj.getBoundingClientRect();
		var objPersonDiv = document.getElementById("simpleSelectDiv");
		if(!objPersonDiv || objPersonDiv == null)
		{
			objPersonDiv = document.createElement("div");
			objPersonDiv.id = "simpleSelectDiv";
		}
		objPersonDiv.style.left=objRect.left;
 		objPersonDiv.style.top=objRect.top+20;
 		objPersonDiv.style.display="";
	}
	
	function fnSimpleSelectSearch(vUrl,eObj,obj)
	{
		if(eObj.keyCode==13)
		{
			var objAjax = new stxAjax(vUrl+encodeURIComponent(obj.value));
			var vReturn = objAjax.executeSync(true);
			var nodeResult = vReturn.getElementsByTagName("RESULTRECORD");
			
			objAjax = null;
			var vSimpleSelect = document.getElementById("simpleSelectSearch")
			if(!vSimpleSelect || vSimpleSelect == null)
			{
				var vSimpleSelectDiv = document.createElement("div");
				vSimpleSelectDiv.id = "simpleSelectDiv";
				vSimpleSelectDiv.style.position = "absolute";
				vSimpleSelectDiv.style.left = 0;
				vSimpleSelectDiv.style.top = 0;
				vSimpleSelectDiv.style.display = "none";
				vSimpleSelectDiv.innerHTML="<select name=\"simpleSelectSearch\" id=\"simpleSelectSearch\" style=\"width:130px;\" onchange=\"fnChangeSimpleSelect(this,'"+obj.id+"')\"></select>"
				document.listForm.appendChild(vSimpleSelectDiv);
				vSimpleSelect = document.getElementById("simpleSelectSearch")
			}
			fnRemoveAllOptionSelect(vSimpleSelect);
			fnAddOtpionToSelect(document.getElementById("simpleSelectSearch"),"","");
			for(var index=0 ;index<nodeResult.length;index++)
			{
				var nodeColumn = nodeResult[index];
				var vDISPLAY = fnGetDocRecordValue(nodeColumn,"DISPLAY");
				var vVALUE = fnGetDocRecordValue(nodeColumn,"VALUE");
				fnAddOtpionToSelect(document.getElementById("simpleSelectSearch"),vVALUE,vDISPLAY);
			}
			fnViewSimpleSelect(obj);
		}
	}
	
	function isNoValue(oInput)
	{
		if(!oInput || oInput.value == "")
		{
			oInput = null;
			return true;
		}
		oInput = null;
		return false;
	}
	
	function stxCol(seq, name, alias, type, width )
	{
		if(!seq || seq == null)seq = 0;
		if(!width || width == null)width = 0;
		
		this.name 		= name;
		this.alias		= alias;
		this.type 		= type;
		this.seq = seq;
		this.width = width;
		name = null;
		alias = null;
		type = null;
		seq = null;
	}
	
	function stxHidden( name, alias )
	{
		this.name 		= name;
		this.alias		= alias;
		name = null;
		alias = null;
	}
	
	function stxGrid(name)
	{
		this.name = name;
		this.arrCol = new Array();
		this.arrHidden = new Array();
		name = null;
	}
	
	stxGrid.prototype = {
		addCol: function (name, alias, type, width) 
		{
			this.arrCol[this.getSize()] = new stxCol(this.getSize(), name, alias, type , width);
			name = null;
			alias = null;
			type = null;
		},
		addHidden: function (name, alias) 
		{
			this.arrHidden[this.arrHidden.length] = new stxHidden(name, alias);
			name = null;
			alias = null;
		},
		addColObj: function (oCol) 
		{
			oCol.seq = this.getSize();
			this.arrCol[this.getSize()] = oCol;
		},
		getSize: function ()
		{
			return this.arrCol.length;
		},
		getSeq: function (name)
		{
			for(var i=0;i<this.getSize();i++)
			{
				if(this.arrCol[i].name == name)
				{
					name = null;
					return i;
				}
			}
			name = null;
		},
		getName: function (seq)
		{
			return this.arrCol[seq].name;
		},
		getCol: function (seq)
		{
			return this.arrCol[seq];
		},
		getOptions: function (name)
		{
			var oCol = this.getCol(this.getSeq(name));
			try{
				if(oCol.type == "select" && oCol.options )
				{
					return oCol.options;
				}
			} catch (e)
			{
				alert(e)
			} finally {
				oCol = null;
				name = null;
			}
			
		}
	}
	
	function checkData(obj)
	{
		if(obj.checked)
		{
			obj.parentNode.parentNode.className = obj.parentNode.parentNode.className.replace("_Select","");
			obj.parentNode.parentNode.className = obj.parentNode.parentNode.className + "_Select";
		} else {
			obj.parentNode.parentNode.className = obj.parentNode.parentNode.className.replace("_Select","");
		}
		obj = null;
	}
	
	function checkedAllList(isChecked)
	{
		var allChecked = document.getElementsByTagName("input");
		for(var i=0; i<allChecked.length; i++)
		{
			if(allChecked[i].type == "checkbox" && !allChecked[i].disabled)
			{
				allChecked[i].checked = isChecked;
				checkData(allChecked[i])
			}
		}
		allChecked = null;
	}
	
	function fnGetParam(oParent)
	{
		var vUrl = "";
		for(var i=0;i<oParent.children.length;i++)
		{
			if(oParent.children[i].name)
			{
				vUrl += "&" + oParent.children[i].name + "=" + oParent.children[i].value;
			}
		}
		return vUrl;
	}
	
	function fnGetRowDataUrl(oCell)
	{
		var vUrl = "";
		
		try{
			if(oCell)
			{
				while(oCell.nextSibling)
				{
					oCell = oCell.nextSibling;
					vUrl += fnGetParam(oCell);
				}
			}
			return vUrl;
		} catch (e)
		{
			alert(e)
		} finally {
			oCell = null;
			vUrl = null;
		}
	}
	
	function fnOpenWindow(url,width,height)
	{
		var LeftPosition = (screen.availWidth-width)/2;
        var TopPosition = (screen.availHeight-height)/2;
		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+width+",height="+height;
		window.open(url,"",sProperties);
	}
	
	function fnGetFormParam(objForm)
	{
		var arrInput = objForm.getElementsByTagName('input');
		var param = "";
		for(var i=0;i<arrInput.length;i++)
		{
			var value = "";
			if(!arrInput[i].name||arrInput[i].name == '')continue;
			if(arrInput[i].type=="text" || arrInput[i].type=="hidden")
			{
				value = arrInput[i].value.trim().encodeURI();
			} else if(arrInput[i].type=="checkbox")
			{
				if(arrInput[i].checked)value = arrInput[i].value.trim().encodeURI();
			} else {
				continue;
			}
			param+=param == ""?arrInput[i].name+"="+value:"&"+arrInput[i].name+"="+value;
		}
		
		var arrSelect = objForm.getElementsByTagName('select');
		for(var i=0;i<arrSelect.length;i++)
		{
			if(!arrSelect[i].name||arrSelect[i].name == '')continue;
			var value = fnGetSelectValue(arrSelect[i]);
			param+=param == ""?arrSelect[i].name+"="+value:"&"+arrSelect[i].name+"="+value;
		}
		arrInput = null;
		arrSelect = null;
		objForm = null;
		
		return param;
	}
	
	function fnGetSelectValue(objSelect)
	{
		var value = "";
		for(var i=0;i<objSelect.options.length;i++)
		{
			if(objSelect.options[i].selected)value = objSelect.options[i].value.trim().encodeURI();
		}
		objSelect = null;
		return value;
	}