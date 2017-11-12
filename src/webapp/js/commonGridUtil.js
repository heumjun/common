function fn_gridresize(winObj, gridId, localAddHegiht , rate){
	
	winObj.bind('resize', function() {
		if(localAddHegiht == null){
			localAddHegiht = 0;
		}
		if(rate == null){
			rate = 1;
		}
		var gridWidth = winObj.width()*0.98-2;
		var gridHeight = winObj.height()*rate -220-localAddHegiht;
		gridId.setGridWidth(gridWidth);
		gridId.setGridHeight(gridHeight);
		/*var gridMinWidth = 500;
		if(gridWidth>gridMinWidth){
			gridId.setGridWidth(gridWidth);
			gridId.setGridHeight(gridHeight);
		}else{
			gridId.jqGrid('gridResize', { minWidth: 500, minHeight: 100 });
		}*/
		//gridId.setGridWidth(winObj.width()-204);
	}).trigger('resize');
}

function resizeJqGridWidth(winObj,grid_id, div_id, percent){
	var persenct_default = 0.7;
	if(percent != null && percent != undefined) persenct_default = percent;
    // window에 resize 이벤트를 바인딩 한다.
	winObj.bind('resize', function() {
        // 그리드의 width를 div 에 맞춰서 적용
		var gridWidth = "";
		if(div_id != undefined){
			gridWidth = div_id.width()-2;
			grid_id.setGridWidth(gridWidth, true); //Resized to new width as per window
		}
        grid_id.setGridHeight(winObj.height()*persenct_default, true);
        
        var grid_view_div = $("#gview_"+grid_id.attr("id"));
        var grid_view_header_table = $(grid_view_div.find(".ui-jqgrid-htable")[0]);
        var grid_view_data_table = $(grid_view_div.find(".ui-jqgrid-btable")[0]); 
        
        var grid_view_firstRow_header_tr = $(grid_view_header_table.find(".jqg-first-row-header")[0]); 
        var grid_view_firstRow_header_th_ary = $(grid_view_firstRow_header_tr.find("th"));
        var grid_view_data_init_tr = $(grid_view_data_table.find(".jqgfirstrow")[0]);
        var grid_view_data_init_td_ary = $(grid_view_data_init_tr.find("td"));
        
        for(var i=0; i<grid_view_data_init_td_ary.length; i++){
        	var tdWidth = $(grid_view_data_init_td_ary[i]).css("width");
        	$(grid_view_firstRow_header_th_ary[i]).css("width",tdWidth);
        }
        
     }).trigger('resize');
}

function fn_insideGridresize(winObj, outCompenent,gridId, localAddHegiht , rate){
	winObj.bind('resize', function() {
		if(localAddHegiht == null){
			localAddHegiht = 0;
		}
		if(rate == null){
			rate = 1;
		}
		gridId.setGridWidth(outCompenent.width()-2,true);
		var gridHeight = winObj.height()*rate -220-localAddHegiht;
		gridId.setGridHeight(gridHeight,true);
		//gridId.setGridWidth(winObj.width()-204);
	}).trigger('resize');
}

function fn_setHeight(gridID, reHeight) {
	$("#"+gridID).setGridHeight(reHeight);
}
function fn_jqGridsetHeight(divCloseFlag,gridID,screen_height){
	if(divCloseFlag=="true"){
		fn_setHeight(gridID,370);
    }else{
    	fn_setHeight(gridID,70);
    }
}
function fn_divCloseFalg(divCloseFlag,gridID){
	if(divCloseFlag){
		$( "#"+gridID ).attr("height","500");
	}else{
		$( "#"+gridID ).attr("height","200");
	}
}
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}
function fn_jqGridChangedCell(gridId, rowId, sColNm, objStyle) {
	
	if (objStyle == null) {
		objStyle = {background:'pink'};
	}
	
	$(gridId).jqGrid('setCell', rowId, sColNm, '', objStyle); 
}

//폼데이터를 Json Arry로 직렬화
function fn_getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
};

function fn_checkGridModify( gridID, message ) {
	if( typeof( message ) === 'undefined' ) message = "변경된 내용이 없습니다.";
	var result  	= true;
	var nChangedCnt = 0;
	var ids     	= $( gridID ).jqGrid('getDataIDs');
		
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( gridID ).jqGrid('getCell', ids[i], 'oper');
		if ( oper == 'I' || oper == 'U' ) {
			nChangedCnt++;
			/*var val1 = $( gridID ).jqGrid('getCell', ids[i], 'sd_type');
			if ( $.jgrid.isEmpty(val1) ) {
				result  = false;
				message = "CodeMaster Type Field is required";
				
				setErrorFocus( gridID,ids[i],0,'sd_type');
				break;
			}*/
		}
	}

	if ( nChangedCnt == 0 ) {
		result  = false;
	}
	
	if ( !result ) {
		alert( message );
	}
	
	return result;	
}

function fn_checkGridModifyNoAlt( gridID ) {
	var result  	= true;
	var nChangedCnt = 0;
	var ids     	= $( gridID ).jqGrid('getDataIDs');
		
	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( gridID ).jqGrid('getCell', ids[i], 'oper');
		if ( oper == 'I' || oper == 'U' ) {
			nChangedCnt++;
			/*var val1 = $( gridID ).jqGrid('getCell', ids[i], 'sd_type');
			if ( $.jgrid.isEmpty(val1) ) {
				result  = false;
				message = "CodeMaster Type Field is required";
				
				setErrorFocus( gridID,ids[i],0,'sd_type');
				break;
			}*/
		}
	}

	if ( nChangedCnt == 0 ) {
		result  = false;
	}
	
	return result;	
}

$.fn.setObject = function(settings) {
	var config = {
			name:'',
			value:'',
			text:'',
			data:[]
	};
	$.extend(config, settings);
	
	var object={};
	$.each(config.data, function (idx, item) {
		object[item[config.value]] = item[config.text];
	});
	
	$(this).setColProp(config.name, { editoptions: { value: object} });
};

//그리드 
var getColumnIndexByName = function(gr,columnName) {
    var cm = gr.jqGrid('getGridParam','colModel');
    for (var i=0,l=cm.length; i<l; i++) {
        if (cm[i].name===columnName) {
            return i; // return the index
        }
    }
    return -1;
};


// 그리드 숨김 표시 
var changeEditableByContain = function(gr,colName,text,doNonEditable) {
    var pos=getColumnIndexByName(gr,colName);
    // nth-child need 1-based index so we use (i+1) below
    var cells = $("tbody > tr.jqgrow > td:nth-child("+(pos+1)+")",gr[0]);
    
    for (var i=0; i<cells.length; i++) {    	
        var cell = $(cells[i]);
        //var cellText = cell.text();
//        var unformatedText = $.unformat(cell,{rowId:cell[0].id,
//                                        colModel:gr[0].p.colModel[pos]},pos);
//        if (text === unformatedText) { // one can use cell.text() instead of
                                       // unformatedText if needed
            if (doNonEditable) {
                cell.addClass('not-editable-cell');
            } else {
                cell.removeClass('not-editable-cell');
            }
//        }
    }
};


// 전체 그리드에 클래스를 추가한다. 
var syncClassByContain = function(gr,colName,text,doNonEditable, className) {
	var pos=getColumnIndexByName(gr,colName);
	// nth-child need 1-based index so we use (i+1) below
	var cells = $("tbody > tr.jqgrow > td:nth-child("+(pos+1)+")",gr[0]);
	for (var i=0; i<cells.length; i++) {
		var cell = $(cells[i]);
		//var cellText = cell.text();
		var unformatedText = $.unformat(cell,{rowId:cell[0].id,
                                     colModel:gr[0].p.colModel[pos]},pos);
		if (text === unformatedText) { // one can use cell.text() instead of
	       // unformatedText if needed
	        if (doNonEditable) {
	            cell.addClass(className);
	        } else {
	            cell.removeClass(className);
	        }
	    }
	}
};



//행별 그리드 숨김 표시 
var changeEditableByContainRow = function(gr,rowIdx,colName,text,doNonEditable) {
	var pos=getColumnIndexByName(gr,colName);
 // nth-child need 1-based index so we use (i+1) below
 	var cells = $("tbody > tr.jqgrow > td:nth-child("+(pos+1)+")",gr[0]);
 
    var cell = $(cells[rowIdx]);
    //var cellText = cell.text();
    var unformatedText = $.unformat(cell,{rowId:cell[0].id, colModel:gr[0].p.colModel[pos]},pos);
    
    if (text === unformatedText) { // one can use cell.text() instead of
                                    // unformatedText if needed
    	if (doNonEditable) {
            cell.addClass('not-editable-cell');
        } else {
            cell.removeClass('not-editable-cell');
        }
     }
};


//행별 그리드에 클래스를 추가한다. 
var syncClassByContainRow = function(gr,rowIdx,colName,text,doNonEditable, className) {

	var pos=getColumnIndexByName(gr,colName);
// nth-child need 1-based index so we use (i+1) below
	var cells = $("tbody > tr.jqgrow > td:nth-child("+(pos+1)+")",gr[0]);

	var cell = $(cells[rowIdx]);
  //var cellText = cell.text();
	var unformatedText = $.unformat(cell,{rowId:cell[0].id,colModel:gr[0].p.colModel[pos]},pos);
	if (text === unformatedText) { // one can use cell.text() instead of
                                 // unformatedText if needed
		if (doNonEditable) {
			cell.addClass(className);
		} else {
			cell.removeClass(className);
		}
	}
};


//그리드 변경된 내용 가져오는 함수
function getGridChangedData(jqGridObj, callback) {
	var changedData = $.grep(jqGridObj.jqGrid('getRowData'), function(obj) { 
		return obj.oper == 'I' || obj.oper == 'U'  || obj.oper == 'D' || obj.excel_upload_flag == 'Y'; 
	});

	callback.apply(this, [changedData]);
}
