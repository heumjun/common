function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'STATE', name:'state_flag', width:35, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:40, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:65, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:30, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:80, align:'center', sortable:true, title:false, formatter: jobCdFormatter, unformat:unFormatter} );
	gridColModel.push({label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false,  hidden:true} );
	gridColModel.push({label:'RAW_LEVEL_FLAG', name:'raw_level_flag', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:80, align:'center', sortable:true, title:false, formatter: motherCodeFormatter, unformat:unFormatter } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false, formatter: itemCodeFormatter, unformat:unFormatter } );
	gridColModel.push({label:'ITEM_CATALOG', name:'item_catalog', width:60, align:'center', sortable:true, title:false, hidden:true } );
	gridColModel.push({label:'VALVE NO.', name:'key_no', width:60, align:'center', sortable:true, title:false } );		
	gridColModel.push({label:'EA', name:'ea', width:30, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'DESCRIPTION', name:'item_desc', width:200, align:'left', sortable:true, title:false} );
	gridColModel.push({label:'SUPPLY', name:'supply', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DEPART', name:'dept_name', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'USER', name:'user_name', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DATE', name:'create_date', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:65, align:'center', sortable:true, title:false, formatter: ecoFormatter, unformat:unFormatter} );
	gridColModel.push({label:'RELEASE', name:'release_desc', width:65, align:'center', sortable:false, title:false} );
	gridColModel.push({label:'DWG.', name:'dwg_check', width:30, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'AFTER INF.', name:'after_info', width:60, align:'center', sortable:true, title:false, cellattr: function (){return 'style="cursor:pointer"';} } );
	gridColModel.push({label:'REMARK', name:'remark', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'LEVEL', name:'level', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'JOB STATUS', name:'job_status', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'JOB STATUS DESC', name:'job_status_desc', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'ECO STATUS CODE', name:'eco_states_code', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'UPPERACTION', name:'upperaction', width:50, align:'center', sortable:true, title:false, hidden:true} );	
	gridColModel.push({label:'dwg_file_name', name:'dwg_file_name', title:false, hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden:true} );
	
	return gridColModel;
}

function getAddGridColModel(){
	
	var gridColModel = new Array();
	//그리드 기본 셋팅 
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';},
		editoptions: { size:"10", maxlength:"10",
            dataEvents: [{
            	type: 'change'
            	, fn: function(e) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    //job code 셋팅
                    setJobCode(rowId);
                }
            },
            { 	type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
            		var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			//job code 셋팅
                        setJobCode(rowId);
            		}
            	}
            }]
		 }
	} );
	
	gridColModel.push({label:'STAGE', name:'stage_no', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';}, editoptions:{size:"10",maxlength:"10"} });
	gridColModel.push({label:'STR', name:'str_flag', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';},
		 editoptions: { size:"10", maxlength:"10",
            dataEvents: [{
            	type: 'change'
            	, fn: function(e) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    //job code 셋팅
                    setJobCode(rowId);
                }
            },
            { 	type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
            		var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			//job code 셋팅
                        setJobCode(rowId);
            		}
            	}
            }]
		 }
	} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';},
		edittype : "select",
 		 editrules : { required : false },
 		 cellattr: function (){return 'class="required_cell"';},
 		 editoptions: {
		 	dataUrl: function(){
           	var item = jqGridObj.jqGrid( 'getRowData', idRow );
           	var url = "sscGetJobCodeList.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_block_no="+item.block_no.toUpperCase()
				+"&p_str_flag="+item.str_flag.toUpperCase()+"&p_usc_job_type="+item.usc_job_type.toUpperCase()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
				return url;
		 	},
 		 	buildSelect: function(data){
    		 	if(typeof(data)=='string'){
    		 		data = $.parseJSON(data);
    		 	}
     		 	var rtSlt = '<select id="selectJobCd" name="selectJobCd" >';
     		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
     		 		rtSlt +='<option value="'+data[idx].sb_value+'" name="'+data[idx].sb_value+'" ' + data[idx].selected + '>'+data[idx].sb_name+'</option>';	
     		 	}
	       		rtSlt +='</select>';
	       		return rtSlt;
 		 	}
 		 }
	} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false, editable:false } );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'M/ITEM CODE', name:'buy_mother_item_code', width:100, align:'center', sortable:true, title:false, editable:true, hidden:true } );
	gridColModel.push({label:'M/VALVE NO.', name:'buy_mother_key_no', width:100, align:'center', sortable:true, title:false, editable:true, hidden:true } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:150, align:'center', sortable:true, title:false, editable:true, 
		cellattr: function (){return 'class="required_cell"';},
		editoptions:{
			dataEvents : [ { type : 'keyup',
			 			    fn : function( e ) {
			 			    		//필수 입력 값 조정
			 			    		cellItemCodeUniqAction(idRow, this.name, $(this).val());
			 			    		//아이템 코드 입력 시 카달로그에 따라 도사급 유무 판단
			 			    		chkSupplyValueToItem(idRow, $(this).val());
			 				   	}
			 				}
						]
		}
	} );
	gridColModel.push({label:'VALVE NO.', name:'key_no', width:100, align:'center', sortable:true, title:false, editable:true, 
		cellattr: function (){return 'class="required_cell"';},
	} );
	gridColModel.push({label:'EA', name:'bom_qty', width:40, align:'center', sortable:true, title:false, editable:true, hidden:false, cellattr: function (){return 'class="required_cell"';} } );
	gridColModel.push({label:'SUPPLY', name:'supply_type', width:40, align:'center', sortable:true, title:false, editable:true
		, cellattr: function (){return 'class="required_cell" title="Y:사급 N:도급"';}
		
	} );
	
	gridColModel.push({label:'COAT IN', name:'temp01', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'COAT OUT', name:'temp02', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'L/NAMEPLATE', name:'temp03', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'TYPE1', name:'temp04', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'TYPE2', name:'temp05', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'POSITION', name:'temp06', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'REMARK', name:'temp07', width:60, align:'center', sortable:true, title:false, editable:true,} );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );			
	gridColModel.push({label:'ERROR_MSG_PROJECT_NO', name:'error_msg_project_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_DWG_NO', name:'error_msg_dwg_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BLOCK_NO', name:'error_msg_block_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STAGE_NO', name:'error_msg_stage_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STR_FLAG', name:'error_msg_str_flag', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_JOB_CD', name:'error_msg_job_cd', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BUY_MOTHER_ITEM_CODE', name:'error_msg_buy_mother_item_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_MOTHER_CODE', name:'error_msg_mother_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_ITEM_CODE', name:'error_msg_item_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BOM_QTY', name:'error_msg_bom_qty', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_ITEM_WEIGHT', name:'error_msg_item_weight', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_KEY_NO', name:'error_msg_key_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_01', name:'error_msg_01', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_02', name:'error_msg_02', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_03', name:'error_msg_03', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_04', name:'error_msg_04', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_05', name:'error_msg_05', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_06', name:'error_msg_06', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_07', name:'error_msg_07', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_08', name:'error_msg_08', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_09', name:'error_msg_09', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_10', name:'error_msg_10', hidden:true } );
	gridColModel.push({label:'CAD_SUB_ID', name:'cad_sub_id', hidden:true } );
	gridColModel.push({label:'OPER', hidden:true, name:'oper', index:'oper' } );
	gridColModel.push({label:'item_group', hidden:true, name:'item_group', index:'item_group' } );
	
	return gridColModel;
}

function getTribonGridColModel(){
	
	//그리드 헤더 설정
	var gridColModel = new Array();

	gridColModel.push({label:'CAD_SUB_ID', name:'cad_sub_id', width:60, align:'center', sortable:true, title:false, hidden:true,} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:120, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'VALVE NO.', name:'tray_no', width:60, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'EA', name:'bom_qty', width:40, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'WEIGHT', name:'item_weight', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'TYPE', name:'attr2', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'DETAIL', name:'item_oldcode', width:100, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'PAINT', name:'paint_code1', width:50, align:'left', sortable:true, title:true, editable:true} );
	gridColModel.push({label:'L1', name:'tray_dim_l1', width:60, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'L2', name:'tray_dim_l2', width:60, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'L3', name:'tray_dim_l3', width:60, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'L4', name:'tray_dim_l4', width:60, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'L5', name:'tray_dim_l5', width:60, align:'left', sortable:true, title:true, editable:true} );	
	gridColModel.push({label:'L6', name:'tray_dim_l6', width:60, align:'left', sortable:true, title:true, editable:true} );
	gridColModel.push({label:'DEPT.', name:'dept_name', width:80, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'USER', name:'user_name', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'DATE', name:'create_date', width:60, align:'center', sortable:true, title:false, editable:true} );
	
	return gridColModel;
}


function getModifyGridColModel(){
	
	var gridColModel = new Array();
	
	//그리드 기본 셋팅 
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'VALVE NO.', name:'key_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'EA', name:'bom_qty', width:30, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'변경 EA', name:'modify_bom_qty', width:60, align:'center', sortable:true, editable:true, title:false, cellattr: function (){return 'class="required_cell"';},} );
	//gridColModel.push({label:'ECO NO.', name:'eco_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'SUPPLY', name:'bom7', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'변경 SUPPLY', name:'temp06', width:60, align:'center', sortable:true, editable:true, title:false, cellattr: function (){return 'class="required_cell"';},} );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ERROR_MSG_PROJECT_NO', name:'error_msg_project_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_DWG_NO', name:'error_msg_dwg_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BLOCK_NO', name:'error_msg_block_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STAGE_NO', name:'error_msg_stage_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_STR_FLAG', name:'error_msg_str_flag', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_JOB_CD', name:'error_msg_job_cd', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_MOTHER_CODE', name:'error_msg_mother_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_ITEM_CODE', name:'error_msg_item_code', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_BOM_QTY', name:'error_msg_bom_qty', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_ITEM_WEIGHT', name:'error_msg_item_weight', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_KEY_NO', name:'error_msg_key_no', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_01', name:'error_msg_01', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_02', name:'error_msg_02', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_03', name:'error_msg_03', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_04', name:'error_msg_04', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_05', name:'error_msg_05', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_06', name:'error_msg_06', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_07', name:'error_msg_07', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_08', name:'error_msg_08', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_09', name:'error_msg_09', hidden:true } );
	gridColModel.push({label:'ERROR_MSG_10', name:'error_msg_10', hidden:true } );
	gridColModel.push({label:'ITEM CATALOG', name:'item_catalog', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	gridColModel.push({label:'MOVE_INFO', name:'move_info', hidden:true } );
	
	return gridColModel;
}


function getDeleteGridColModel(){
	
	var gridColModel = new Array();


	//그리드 기본 셋팅 
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BUY-BUY', name:'buy_buy_flag', width:60, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'VALVE NO.', name:'key_no', width:100, align:'center', sortable:true, title:false} );	
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TEMP_YN', name:'temp_yn', hidden:true} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', hidden:true} );
	gridColModel.push({label:'JOB_CATALOG', name:'job_catalog', hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	
	return gridColModel;
}

function getBomGridColModel(){
	var gridColModel = new Array();

	//그리드 기본 셋팅 
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'VALVE NO.', name:'key_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	
	return gridColModel;
}



	