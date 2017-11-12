package stxship.dis.modelProject.projectMgnt.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.modelProject.projectMgnt.dao.ProjectMgntDAO;

@Service("projectMgntService")
public class ProjectMgntServiceImpl extends CommonServiceImpl implements ProjectMgntService {

	@Resource(name = "projectMgntDAO")
	private ProjectMgntDAO projectMgntDAO;

	@Override
	public Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return saveGridList(commandMap);
	}

	@Override
	public String gridDataInsert(Map<String, Object> commandMap) {
		return saveGrid(commandMap);
	}

	@Override
	public String gridDataUpdate(Map<String, Object> commandMap) {
		return saveGrid(commandMap);
	}

	@Override
	public String gridDataDelete(Map<String, Object> commandMap) {
		return saveGrid(commandMap);
	}

	private String saveGrid(Map<String, Object> commandMap) {

		Map<String, Object> rowData = commandMap;
		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.put("p_action_type", rowData.get("oper"));
		pkgParam.put("p_project_no", rowData.get("project_no"));
		pkgParam.put("p_model_no", rowData.get("model_no"));
		pkgParam.put("p_marketing_text", rowData.get("marketing_text"));
		pkgParam.put("p_stxsite", rowData.get("stxsite"));

		if ((!"".equals(DisStringUtil.nullString(rowData.get("representative_pro_num")))
				&& (!"0".equals(DisStringUtil.nullString(rowData.get("representative_pro_num")))))) {
			pkgParam.put("p_representative_pro_num", rowData.get("representative_pro_num"));
		} else {
			pkgParam.put("p_representative_pro_num", "");
		}

		pkgParam.put("p_representative_pro_yn", rowData.get("representative_pro_yn"));
		pkgParam.put("p_series", rowData.get("series"));
		pkgParam.put("p_reference_pro_num", rowData.get("reference_pro_num"));
		pkgParam.put("p_flag", rowData.get("flag"));
		pkgParam.put("p_buyer", rowData.get("buyer"));
		pkgParam.put("p_enable_flag", rowData.get("enable_flag"));
		pkgParam.put("p_paint_new_rule_flag", rowData.get("paint_new_rule_flag"));
		pkgParam.put("p_supply_enable_flag", rowData.get("supply_enable_flag"));
		pkgParam.put("p_supply_close_flag", rowData.get("supply_close_flag"));
		pkgParam.put("p_dl_flag", rowData.get("dl_flag"));
		pkgParam.put("p_doc_project_no", rowData.get("doc_project_no"));
		pkgParam.put("p_doc_enable_flag", rowData.get("doc_enable_flag"));
		pkgParam.put("p_class1", rowData.get("class1"));
		pkgParam.put("p_class2", rowData.get("class2"));
		pkgParam.put("p_pis_representative_pro_num", rowData.get("pis_representative_pro_num"));
		pkgParam.put("p_user_id", commandMap.get("loginId"));

		projectMgntDAO.saveGridListAction(pkgParam);

		String sErrMsg = (String) pkgParam.get("p_error_msg");
		// String sErrCode = (String) pkgParam.get("p_error_code");

		if (sErrMsg != null) {
			return sErrMsg;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}
