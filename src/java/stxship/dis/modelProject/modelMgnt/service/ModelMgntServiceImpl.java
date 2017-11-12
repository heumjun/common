package stxship.dis.modelProject.modelMgnt.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.modelProject.modelMgnt.dao.ModelMgntDAO;

/**
 * @파일명 : ModelMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  modelMgnt 서비스
 *     </pre>
 */
@Service("modelMgntService")
public class ModelMgntServiceImpl extends CommonServiceImpl implements ModelMgntService {

	@Resource(name = "modelMgntDAO")
	private ModelMgntDAO modelMgntDAO;

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 저장프로시져 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> commandMap) {
		return this.saveGrid(commandMap);
	}

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 저장프로시져 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public String gridDataUpdate(Map<String, Object> commandMap) {
		return this.saveGrid(commandMap);
	}

	/**
	 * @메소드명 : saveGrid
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 저장프로시져 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	private String saveGrid(Map<String, Object> commandMap) {
		Map<String, Object> rowData = commandMap;
		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.put("p_representatives_emp_no", "");
		pkgParam.put("p_class", rowData.get("class_code"));
		pkgParam.put("p_class2", rowData.get("class_code2"));
		pkgParam.put("p_action_type", rowData.get("oper"));
		pkgParam.put("p_model_name", rowData.get("model_name"));
		pkgParam.put("p_model_no", rowData.get("model_no"));
		pkgParam.put("p_model_type", rowData.get("model_type"));
		pkgParam.put("p_category", rowData.get("category"));
		pkgParam.put("p_ship_type", rowData.get("ship_type"));
		pkgParam.put("p_description", rowData.get("description"));
		pkgParam.put("p_marketing_name", rowData.get("marketing_name"));
		pkgParam.put("p_marketing_text", rowData.get("marketing_text"));
		pkgParam.put("p_representatives_emp_no", "");
		pkgParam.put("p_intended_cargo", rowData.get("intended_cargo"));
		pkgParam.put("p_bulk_head_code", rowData.get("bulk_head_code"));
		pkgParam.put("p_ice_class_code", rowData.get("ice_class_code"));
		pkgParam.put("p_cargo_pump_code", rowData.get("cargo_pump_code"));
		pkgParam.put("p_segregation_code", rowData.get("segregation_code"));
		pkgParam.put("p_cargo_hold_code", rowData.get("cargo_hold_code"));
		pkgParam.put("p_capacity", rowData.get("capacity"));
		pkgParam.put("p_gt", rowData.get("gt"));
		pkgParam.put("p_principal_particulars", rowData.get("principal_particulars"));
		pkgParam.put("p_bow_thruster_code", rowData.get("bow_thruster_code"));
		pkgParam.put("p_enable_flag", rowData.get("enable_flag"));
		pkgParam.put("p_class", rowData.get("class_code"));
		pkgParam.put("p_class2", rowData.get("class_code2"));
		pkgParam.put("p_speed", rowData.get("speed"));
		pkgParam.put("p_loginid", commandMap.get("loginId"));

		modelMgntDAO.saveGridListAction(pkgParam);

		String sErrMsg = (String) pkgParam.get("p_error_msg");
		// String sErrCode = (String) pkgParam.get("p_error_code");

		if (sErrMsg != null) {
			return sErrMsg;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}
