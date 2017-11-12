package stxship.dis.dps.progressInput.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.progressInput.dao.ProgressInputDAO;

/**
 * @파일명 : ProgressInputServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ProgressInput에서 사용되는 서비스
 *     </pre>
 */
@Service("progressInputService")
public class ProgressInputServiceImpl extends DpsCommonServiceImpl implements ProgressInputService {

	@Resource(name = "progressInputDAO")
	private ProgressInputDAO progressInputDAO;

	@Override
	public List<Map<String, Object>> getPLM_DATE_CHANGE_ABLE_DWG_TYPE() throws Exception {
		return progressInputDAO.getPLM_DATE_CHANGE_ABLE_DWG_TYPE();
	}

	@Override
	public void addPLM_DATE_CHANGE_ABLE_DWG_TYPE(String dwg_kind, String dwg_type) throws Exception {
		Map param = new HashMap<String,Object>();
		param.put("dwg_kind",dwg_kind);
		param.put("dwg_type",dwg_type);
		progressInputDAO.addPLM_DATE_CHANGE_ABLE_DWG_TYPE(param);
	}

	@Override
	public void delPLM_DATE_CHANGE_ABLE_DWG_TYPE(Map<String, Object> map) throws Exception {
		progressInputDAO.delPLM_DATE_CHANGE_ABLE_DWG_TYPE(map);
	}
	/**
	 * 
	 * @메소드명	: progressProjectDateChangeMainGridSave
	 * @날짜		: 2016. 9. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 실적입력관리 메인그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> progressProjectDateChangeMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		Map<String,Object> param = new HashMap<String,Object>();
		try{
			for (Map<String, Object> rowData : saveList) {
				// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
					String project_no 	= (String)rowData.get("projectno");
	        		String basic_mode 		= (String)rowData.get("b_kind");
	        		String make_mode 		= (String)rowData.get("m_kind");
	        		String product_mode 		= (String)rowData.get("p_kind");
	        		
	        		if(basic_mode != null){
	        			param.put("project_no", project_no);
        				param.put("dwg_kind", "기본도");
	        			if(basic_mode.equals("CLOSED"))progressInputDAO.setAbleChangeDPDateProject(param);
	        			else if(basic_mode.equals("OPENED"))progressInputDAO.setDisableChangeDPDateProject(param);
	        			param.clear();
	        		}
	        		if(make_mode != null){
	        			param.put("project_no", project_no);
        				param.put("dwg_kind", "MAKER");
	        			if(make_mode.equals("CLOSED"))progressInputDAO.setAbleChangeDPDateProject(param);
	        			else if(make_mode.equals("OPENED"))progressInputDAO.setDisableChangeDPDateProject(param);
	        			param.clear();
	        		}
	        		if(product_mode != null){
	        			param.put("project_no", project_no);
        				param.put("dwg_kind", "생설도");
	        			if(product_mode.equals("CLOSED"))progressInputDAO.setAbleChangeDPDateProject(param);
	        			else if(product_mode.equals("OPENED"))progressInputDAO.setDisableChangeDPDateProject(param);
	        			param.clear();
	        		}
				}
			}
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}
	
	/**
	 * 
	 * @메소드명	: getChangableDateDPList
	 * @날짜		: 2016. 10. 7.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 변경가능일자 조회
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getChangableDateDPList(Map<String, Object> map) throws Exception {
		return progressInputDAO.getChangableDateDPList(map);
	}
	
	/**
	 * 
	 * @메소드명	: progressInputMainGridSave
	 * @날짜		: 2016. 10. 11.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> progressInputMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		try{
			for (Map<String, Object> rowData : saveList) {
				// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				
				//mybatis자동연결 형식 변경을 위한 설정 부분
				if(commandMap.containsKey("mybatisName"))rowData.put("mybatisName", commandMap.get("mybatisName"));
				if(commandMap.containsKey("mybatisId"))rowData.put("mybatisId", commandMap.get("mybatisId"));
				if(commandMap.containsKey("actionAddCode"))rowData.put("actionAddCode", commandMap.get("actionAddCode"));
				if(commandMap.containsKey("targetDate"))rowData.put("targetDate", rowData.get(commandMap.get("targetDate")));

				// UPDATE 인경우
				if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
					gridDataUpdateDps(rowData);
				}
			}
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
		
	}

	@Override
	public List<Map<String, Object>> getDpsProgressInputSearchList(CommandMap commandMap) throws Exception {
		String dateCondition = (String)commandMap.get("dateCondition");
		String drawingNo = "";
		boolean drawingNoCheck = false;
		for (int i = 0; i < 8; i++) {
			if (!"".equals(String.valueOf(commandMap.get("drawingNo"+i)))) {
				drawingNo +=  String.valueOf(commandMap.get("drawingNo"+i));
				drawingNoCheck = true;
			}
			else drawingNo +=  "_";
		}
		if(drawingNoCheck)commandMap.put("drawingNo",drawingNo);
		else commandMap.put("drawingNo","");
		
		if(dateCondition != null){
			if (dateCondition.equals("DW_S"))  commandMap.put("dateCondition","DW_PLAN_S");
			else if (dateCondition.equals("DW_F")) commandMap.put("dateCondition","DW_PLAN_F");
			else if (dateCondition.equals("OW_S")) commandMap.put("dateCondition","OW_PLAN_S");
			else if (dateCondition.equals("OW_F")) commandMap.put("dateCondition","OW_PLAN_F");
			else if (dateCondition.equals("CL_S")) commandMap.put("dateCondition","CL_PLAN_S");
			else if (dateCondition.equals("CL_F")) commandMap.put("dateCondition","CL_PLAN_F");	
			else if (dateCondition.equals("RF")) commandMap.put("dateCondition","RF.PLANSTARTDATE");
			else if (dateCondition.equals("WK")) commandMap.put("dateCondition","RF_PLAN_S");
			else commandMap.put("dateCondition","");
		}
		List<Map<String,Object>> listMap = progressInputDAO.getDpsProgressInputSearchList(commandMap);
		List<Map<String,Object>> returnMap = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> item : listMap){
			item.put("projectNo", DisStringUtil.nullString(item.get("project_no")));
			item.put("deptName", DisStringUtil.nullString(item.get("deptname")));
			item.put("deptCode", DisStringUtil.nullString(item.get("deptcode")));
			item.put("sabun", DisStringUtil.nullString(item.get("sabun")));
			item.put("sabun_name", DisStringUtil.nullString(item.get("name")));
			item.put("sub_sabun", DisStringUtil.nullString(item.get("sub_sabun")));
			item.put("sub_sabun_name", DisStringUtil.nullString(item.get("sub_name")));
			item.put("dwgCode", DisStringUtil.nullString(item.get("dwgcode")));
			item.put("dwgTitle", DisStringUtil.nullString(item.get("dwgtitle")));
			item.put("outSourcingYn", DisStringUtil.nullString(item.get("outsourcingyn")));
			item.put("outSourcing1", DisStringUtil.nullString(item.get("outsourcing1")));
			item.put("outSourcing2", DisStringUtil.nullString(item.get("outsourcing2")));
			item.put("dwgZone", DisStringUtil.nullString(item.get("dwgzone")));
			item.put("dwgTitleHint", DisStringUtil.replaceAmpAll(DisStringUtil.nullString(item.get("dwgtitle")), "'", "＇"));
			item.put("dw_plan_s", DisStringUtil.nullString(item.get("dw_plan_s")));
            item.put("dw_plan_f", DisStringUtil.nullString(item.get("dw_plan_f")));
            item.put("dw_act_s", DisStringUtil.nullString(item.get("dw_act_s")));
            item.put("dw_act_f", DisStringUtil.nullString(item.get("dw_act_f")));
            item.put("ow_plan_s", DisStringUtil.nullString(item.get("ow_plan_s")));
            item.put("ow_plan_f", DisStringUtil.nullString(item.get("ow_plan_f")));
            item.put("ow_act_s", DisStringUtil.nullString(item.get("ow_act_s")));
            item.put("ow_act_f", DisStringUtil.nullString(item.get("ow_act_f")));
            item.put("cl_plan_s", DisStringUtil.nullString(item.get("cl_plan_s")));
            item.put("cl_plan_f", DisStringUtil.nullString(item.get("cl_plan_f")));
            item.put("cl_act_s", DisStringUtil.nullString(item.get("cl_act_s")));
            item.put("cl_act_f", DisStringUtil.nullString(item.get("cl_act_f")));
            item.put("rf_plan_s", DisStringUtil.nullString(item.get("rf_plan_s")));
            item.put("rf_act_s", DisStringUtil.nullString(item.get("rf_act_s")));
            item.put("wk_plan_s", DisStringUtil.nullString(item.get("wk_plan_s")));
            item.put("wk_act_s", DisStringUtil.nullString(item.get("wk_act_s")));
            item.put("out_std", DisStringUtil.nullString(item.get("out_std")));
            item.put("out_followup", DisStringUtil.nullString(item.get("out_followup")));
            item.put("internal_std", DisStringUtil.nullString(item.get("internal_std")));
            item.put("internal_followup", DisStringUtil.nullString(item.get("internal_followup")));
            item.put("plan_std", DisStringUtil.nullString(item.get("plan_std")));
            item.put("plan_followup", DisStringUtil.nullString(item.get("plan_followup")));
            item.put("std_total", DisStringUtil.nullString(item.get("std_total")));
            item.put("followup_total", DisStringUtil.nullString(item.get("followup_total")));
            item.put("dw_plan_s_o", DisStringUtil.nullString(item.get("dw_plan_s_o")));
            item.put("dw_plan_f_o", DisStringUtil.nullString(item.get("dw_plan_f_o")));
            item.put("ow_plan_s_o", DisStringUtil.nullString(item.get("ow_plan_s_o")));
            item.put("ow_plan_f_o", DisStringUtil.nullString(item.get("ow_plan_f_o")));
            item.put("cl_plan_s_o", DisStringUtil.nullString(item.get("cl_plan_s_o")));
            item.put("cl_plan_f_o", DisStringUtil.nullString(item.get("cl_plan_f_o")));
            item.put("rf_plan_s_o", DisStringUtil.nullString(item.get("rf_plan_s_o")));
            item.put("wk_plan_s_o", DisStringUtil.nullString(item.get("wk_plan_s_o")));

            item.put("max_revision", DisStringUtil.nullString(item.get("max_revision")));
            item.put("deploy_date", DisStringUtil.nullString(item.get("deploy_date")));
            item.put("dts_result", DisStringUtil.nullString(item.get("dts_result")));
            item.put("new_activity_desc1", DisStringUtil.nullString(item.get("new_activity_desc1")));
            item.put("new_activity_desc2", DisStringUtil.nullString(item.get("new_activity_desc2")));
            item.put("old_activity_desc1", DisStringUtil.nullString(item.get("old_activity_desc1")));
            item.put("old_activity_desc2", DisStringUtil.nullString(item.get("old_activity_desc2")));
            item.put("diff_date", DisStringUtil.nullString(item.get("diff_date")));
            item.put("sum_bom_qty", DisStringUtil.nullString(item.get("sum_bom_qty")));
            
            item.put("dw_attribute4",DisStringUtil.nullString(item.get("dw_attribute4")));
            item.put("dw_attribute5",DisStringUtil.nullString(item.get("dw_attribute5")));
            item.put("ow_attribute4",DisStringUtil.nullString(item.get("ow_attribute4")));
            item.put("ow_attribute5",DisStringUtil.nullString(item.get("ow_attribute5")));
            item.put("cl_attribute4",DisStringUtil.nullString(item.get("cl_attribute4")));
            item.put("cl_attribute5",DisStringUtil.nullString(item.get("cl_attribute5")));
            item.put("rf_attribute4",DisStringUtil.nullString(item.get("rf_attribute4")));
            item.put("rf_attribute5",DisStringUtil.nullString(item.get("rf_attribute5")));
            item.put("wk_attribute4",DisStringUtil.nullString(item.get("wk_attribute4")));
            item.put("wk_attribute5",DisStringUtil.nullString(item.get("wk_attribute5")));
            
            String activityDesc =  DisStringUtil.nullString(item.get("ACTIVITY_DESC"));
            String activityDesc1 = "";
            String activityDesc2 = "";
            if (!DisStringUtil.isNullString(activityDesc)) {
                activityDesc1 = activityDesc.substring(0, activityDesc.indexOf("|"));
                activityDesc2 = activityDesc.substring(activityDesc.indexOf("|") + 1);
            }
            
            item.put("activityDesc1", activityDesc1);
            item.put("activityDesc2", activityDesc2);
            
            returnMap.add(item);
		}
		
		return returnMap;
	}


}
