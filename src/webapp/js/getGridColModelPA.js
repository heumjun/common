function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:40, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:60, align:'center', sortable:true, title:false, hidden:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false,  hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'EA', name:'ea', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'이론물량', name:'bom14', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'WEIGHT', name:'item_weight', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DEPART', name:'dept_name', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'USER', name:'user_name', width:70, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DATE', name:'create_date', width:70, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO STATE', name:'states_code', width:100, align:'center', sortable:false, title:false} );
	gridColModel.push({label:'DWG.', name:'dwg_check', width:50, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'AFTER INF.', name:'after_info', width:50, align:'center', sortable:true, title:false, cellattr: function (){return 'style="cursor:pointer"';} } );
	gridColModel.push({label:'REMARK', name:'remark', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'JOB_CATALOG', name:'job_catalog', hidden:true} );
	gridColModel.push({label:'UPPERACTION', name:'upperaction', width:50, align:'center', sortable:true, title:false, hidden:true} );	
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
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false, editable:true, 
		cellattr: function (){return 'class="required_cell"';}
	} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false, editable:true, 
		cellattr: function (){return 'class="required_cell"';},
		editoptions:{
			dataEvents : [ { type : 'keyup',
			 			    fn : function( e ) {
			 			    		//필수 입력 값 조정
			 			    		cellItemCodeUniqAction(idRow, this.name, $(this).val());
			 				   	}
			 				}
						]
		}
	} );
	gridColModel.push({label:'EA', name:'bom_qty', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';}} );
	gridColModel.push({label:'이론물량', name:'temp01', width:50, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';}} );
	gridColModel.push({label:'REV', name:'rev_no', width:60, align:'center', sortable:true, title:false} );
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
	gridColModel.push({label:'CAD_SUB_ID', name:'cad_sub_id', hidden:true } );
	gridColModel.push({label:'OPER', hidden:true, name:'oper', index:'oper' } );

	
	return gridColModel;
}

function getTribonGridColModel(){
	
	//그리드 헤더 설정
	var gridColModel = new Array();

	gridColModel.push({label:'CAD_SUB_ID', name:'cad_sub_id', width:60, align:'center', sortable:true, title:false, hidden:true,} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:50, align:'center', sortable:true, title:false, editable:true} );
	gridColModel.push({label:'DATE', name:'create_date', width:80, align:'center', sortable:true, title:false, editable:true} );
	
	return gridColModel;
}


function getModifyGridColModel(){
	
	var gridColModel = new Array();
	 
	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'변경 EA', name:'modify_bom_qty', width:60, align:'center', sortable:true, editable:true, title:false, cellattr: function (){return 'class="required_cell"';},} );
	gridColModel.push({label:'이론물량', name:'temp06', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'변경 이론물량', name:'temp05', width:80, align:'center', sortable:true, editable:true, title:false, cellattr: function (){return 'class="required_cell"';},} );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ITEM CATALOG', name:'item_catalog', width:50, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	gridColModel.push({label:'MOVE_INFO', name:'move_info', hidden:true } );
	
	return gridColModel;
}


function getDeleteGridColModel(){
	
	var gridColModel = new Array();

	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BLOCK', name:'block_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STAGE', name:'stage_no', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'STR', name:'str_flag', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'TYPE', name:'usc_job_type', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'BUY-BUY', name:'buy_buy_flag', width:60, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', hidden:true} );
	gridColModel.push({label:'JOB_CATALOG', name:'job_catalog', hidden:true} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	
	return gridColModel;
	
}



function getBomGridColModel(){
	var gridColModel = new Array();

	gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
	gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'MASTER', name:'master_ship', width:40, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PROJECT', name:'project_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'DWG NO.', name:'dwg_no', width:90, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'JOB ITEM', name:'job_cd', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'PENDING', name:'mother_code', width:100, align:'center', sortable:true, title:false } );
	gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'ECO NO.', name:'eco_no', width:100, align:'center', sortable:true, title:false, title:false } );
	gridColModel.push({label:'EA', name:'bom_qty', width:60, align:'center', sortable:true, title:false} );
	gridColModel.push({label:'OPER', name:'oper', hidden:true } );
	
	return gridColModel;
}