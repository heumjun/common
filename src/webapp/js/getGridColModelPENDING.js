//Pending Main Grid
function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false, excel:true} );
	gridColModel.push({label:'MASTER', name:'master_project_no', width:55, align:'center', sortable:false, title:false, excel:true} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:55, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:80, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'STR', name:'str_flag', width:50, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'JOB CATA', name:'job_catalog', width:50, align:'center', sortable:false, title:false, excel:false, imp:true, hidden:true } );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:50, align:'center', sortable:false, title:false, excel:true, imp:true} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:120, align:'center', sortable:false, title:false, excel:true, formatter: jobCdFormatter, unformat:unFormatter} );
	gridColModel.push({label:'JOB DESC', name:'job_desc', width:200, align:'left', sortable:false, title:false, excel:true, formatter: jobCdFormatter, unformat:unFormatter} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:120, align:'center', sortable:false, title:false, excel:true, formatter: motherCodeFormatter, unformat:unFormatter } );
	gridColModel.push({label:'DEPT', name:'dept_name', width:120, align:'center', sortable:false, title:false, excel:true} );
	gridColModel.push({label:'USER', name:'user_name', width:80, align:'center', sortable:false, title:false, excel:true} );
	gridColModel.push({label:'DATE', name:'create_date', width:90, align:'center', sortable:false, title:false, excel:true} );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:90, align:'center', sortable:true, title:false, excel:true, formatter: ecoFormatter, unformat:unFormatter});
	gridColModel.push({label:'RELEASE', name:'release', width:100, align:'center', sortable:false, title:false, excel:true} );
	gridColModel.push({label:'WORK', name:'ssc_work_flag', width:40, align:'center', sortable:false, title:false, excel:true } );
	gridColModel.push({label:'JOB_NO', name:'job_no', width:100, align:'center', sortable:false, title:false, excel:true } );
	gridColModel.push({label:'JOB_ST', name:'job_start', width:80, align:'center', sortable:false, title:false, excel:true } );
	gridColModel.push({label:'JOB_END', name:'job_end', width:80, align:'center', sortable:false, title:false, excel:true } );
	gridColModel.push({label:'JOB_ST_DESC', name:'job_status_desc', width:80, align:'center', sortable:false, title:false, excel:false, hidden:true } );
	gridColModel.push({label:'해지예정일', name:'termination_date', width:90, align:'center', sortable:false, title:false, excel:false, hidden:true} );
	gridColModel.push({label:'P/T', name:'mail_flag', width:40, align:'center', sortable:false, title:false, editable : true, hidden:true, formatter : 'select', edittype : 'select', editoptions : { value : "Y:Y;N:N" }, excel:false  });
	gridColModel.push({label:'MAIL_FLAG_CHANGED', name:'mail_flag_changed', width:25, align:'center', sortable:false, title:false, hidden:true, excel:false });
	gridColModel.push({label:'SHIP_TYPE', name:'ship_type', width:0.1, align:'center', sortable:false, title:false, hidden:true, excel:false, imp:true} );
	gridColModel.push({label:'EA', name:'ea', width:40, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'ECO_STATES_CODE', name:'eco_states_code', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'ROWID', name:'pending_rowid', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'UPPERACTION', name:'upperaction', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', width:25, align:'center', sortable:false, title:false, hidden:true, excel:false} );
	gridColModel.push({label:'TEMP_MOTHER_CODE', name:'temp_mother_code', hidden:true } );
	return gridColModel;
}

//Pending ADD Left Grid
function getAddGridColModel(){
	
	var gridColModel = new Array();
	
	gridColModel.push({label:'PROJECT', name:'project_no', width:80, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'TYPE', name:'job_catalog', width:60, align:'center', sortable:true, title:false, editable:true,
		editoptions: { 
            dataEvents: [{
			type: 'change'
	         	, fn: function(e) {
	         		var row = $(e.target).closest('tr.jqgrow');
	                var rowId = row.attr('id');
	                //JOB CATA를 TYPE에다가 복사
	                setChangeCata(rowId);
	             }
	         },
	         { 	type : 'keydown'
	         	, fn : function( e) { 
	         		var row = $(e.target).closest('tr.jqgrow');
	                var rowId = row.attr('id');
	                var key = e.charCode || e.keyCode;
	         		if( key == 13 || key == 9) {
		                //JOB CATA를 TYPE에다가 복사
		                setChangeCata(rowId);
	         		}
	         	}
	         }]
		 }
	} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:80, align:'center', sortable:true, title:false, editable:true, hidden: true } );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:100, align:'center', sortable:true, title:false, editable:true, 
		edittype : "text",
		editoptions: { 
			dataInit: function(elem) {
				setTimeout(function(){ //alert(elem);
					$(elem).autocomplete({
//						source: "getDwgNoList.do?p_master_no="+$("input[name=p_project_no]").val().toUpperCase() + "&p_dept_code="+$("input[name=p_dept_code]").val(),
						source: arr_dwg_no,
//						source: function (request, response) {
//		                    $.ajax({
//		                        url: "getDwgNoList.do?p_master_no="+$("input[name=p_project_no]").val().toUpperCase() + "&p_dept_code="+$("input[name=p_dept_code]").val(),
//		                        data: "",
//		                        dataType: "json",
//		                        type: "POST",
//		                        contentType: "application/json; charset=utf-8",
//		                        success: function (data) {
//		                        	response($.map(data, function (item) {
//		                            	return item.value;
//		                        	}))
//		                        }
//		                    });
//						},    
						minLength: 1,
		    			matchContains: true, 
		    			autosearch: true,
		    			autoFocus: true,
		    			selectFirst: true
		    			/*select: function (event, ui) {
							$(elem).val(ui.item.value);
		                }*/
					});
				}, 10);
			} 
		}, 
		//editrules: { required: true} 
		/*,
		 edittype : "select",
  		 editoptions: {
		 	dataUrl: function(){
            	var item = jqGridObj.jqGrid( 'getRowData', idRow );
            	var url = "getDwgNoList.do?p_master_no=" + item.project_no.toUpperCase() + "&p_dept_code="+$("input[name=p_dept_code]").val();
				return url;
		 	},
  		 	buildSelect: function(data){
     		 	if(typeof(data)=='string'){
     		 		data = $.parseJSON(data);
     		 	}
      		 	var rtSlt = '<select id="selectDwgNo" name="selectDwgNo" >';
      		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
	       		 	rtSlt +='<option value="'+data[idx].value+'" >'+data[idx].text+'</option>';
      		 	}
	       		rtSlt +='</select>';
	       		
	       		return rtSlt;
  		 	}
	   		,dataEvents: [{
           	type: 'change'
           	, fn: function(e) {
           		var row = $(e.target).closest('tr.jqgrow');
                var rowId = row.attr('id');
           		//var attr = $(e.target).find("option:selected").attr('name');
           		//jqGridObj.jqGrid('setCell', rowId, 'usc_job_type', attr);
               }
	        }]
  		 }*/
	} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:80, align:'center', sortable:true, title:false, editable:true } );
	gridColModel.push({label:'MODE', name:'mode', width:25, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'SHIP_TYPE', name:'ship_type', width:25, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', width:25, align:'center', sortable:true, title:false, hidden:true} );
	
	return gridColModel;
}

//Pending ADD Rigth Grid
function getAddDetailGridColModel(){
	
	var gridColModel = new Array();
	
	gridColModel.push({label:'SEQ', name:'li_seq_id', width:25, align:'center', sortable:true, title:false, hidden:true, key:true} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'job_catalog', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:50, align:'center', sortable:true, title:false, hidden:true } );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'PROCESS', name:'process_flag', width:60, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'PROCESS_DESC', name:'process_msg', width:230, align:'center', sortable:true, title:false, hidden:false } );
	gridColModel.push({label:'OPER', name:'oper', width:25, align:'center', sortable:true, title:false, hidden:true} );

	return gridColModel;
}

//Pending ADD DWG Grid
function getAddDwgGridColModel(){
	
	var gridColModel = new Array();
	
	gridColModel.push( {label:'DWG NO.', name:'dwg_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push( {label:'STAGE', name:'stage_no', width:170, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push( {label:'DESCRIPTION', name:'dwg_title', width:320, align:'left', sortable:true, title:false} );
	gridColModel.push({label:'OPER', name:'oper', width:5, align:'center', sortable:true, title:false, hidden:true} );
	
	return gridColModel;
}

//Pending Main Work(Bom-SSC) Grid
function getSSCBomGridColModel(){
	var gridColModel = new Array();

	gridColModel.push({label:'유형', name:'code_text', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'상태', name:'state_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:110, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DESCRIPTION', name:'item_desc', width:360, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'KEY NO', name:'key_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO NO', name:'eco_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO RELEASE', name:'release_date', width:110, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'생성자', name:'user_name', width:80, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'생성일', name:'create_date', width:110, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'OPER', name:'oper', width:5, hidden:true } );
	
	return gridColModel;
}

function getModifyGridColModel(){
	
	var gridColModel = new Array();

	gridColModel.push({label:'ROWID', name:'pending_rowid', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'WORK_KEY', name:'work_key', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'ITEM_TYPE_CD', name:'item_type_cd', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DEPT_CODE', name:'dept_code', width:90, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB_CATA', name:'job_catalog', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MOVE JOB', name:'modify_job_cd', width:100, align:'center', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'MOVE PENDING', name:'modify_mother_code', width:100, align:'center', sortable:true, title:false, hidden: true } );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ERROR_MSG_PROJECT_NO', name:'error_msg_project_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_DWG_NO', name:'error_msg_dwg_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BLOCK_NO', name:'error_msg_block_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STAGE_NO', name:'error_msg_stage_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STR_FLAG', name:'error_msg_str_flag', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_JOB_CD', name:'error_msg_job_cd', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_MOTHER_CODE', name:'error_msg_mother_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_MODIFY_JOB_CD', name:'error_msg_modify_job_cd', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_MODIFY_MOTHER_CODE', name:'error_msg_modify_mother_code', hidden:true } );
	gridColModel.push({label:'OPER', name:'oper', width:50, hidden:true } );
	gridColModel.push({label:'MOVE_INFO', name:'move_info', hidden:true } );
	
	return gridColModel;
}


function getBomGridColModel(){
	var gridColModel = new Array();

	gridColModel.push({label:'ROWID', name:'pending_rowid', width:250, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PENDING MOTHER', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	
	return gridColModel;
}

	