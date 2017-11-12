package stxship.dis.paint.plan.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.paint.importPaint.dao.PaintImportPaintDAO;
import stxship.dis.paint.plan.dao.PaintPlanDAO;

@Service("paintPlanService")
public class PaintPlanServiceImpl extends CommonServiceImpl implements PaintPlanService {

	@Resource(name = "paintPlanDAO")
	private PaintPlanDAO paintPlanDAO;

	@Resource(name = "paintImportPaintDAO")
	private PaintImportPaintDAO paintImportPaintDAO;

	/** 
	 * @메소드명	: savePlanRevAdd
	 * @날짜		: 2016. 2. 23.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> savePlanRevAdd(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> planList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		String error_code = "";
		String error_msg = "";

		for (Map<String, Object> rowData : planList) {
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_project_no", rowData.get("project_no"));
			pkgParam.put("p_revision", rowData.get("revision"));
			pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintPlanDAO.savePlanRevAdd(pkgParam);

			error_code = (String) pkgParam.get("p_error_code");
			error_msg = (String) pkgParam.get("p_error_msg");

			if (!"S".equals(error_code)) {
				throw new DisException(error_msg);
			}
		}

		// 결과값에 따른 메시지를 담아 전송
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/** 
	 * @메소드명	: savePlanProjectAdd
	 * @날짜		: 2016. 2. 23.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> savePlanProjectAdd(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> planList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		String error_code = "";
		String error_msg = "";
		for (Map<String, Object> rowData : planList) {
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_project_no", rowData.get("project_no"));
			pkgParam.put("p_revision", rowData.get("revision"));
			pkgParam.put("p_add_project_no", commandMap.get("add_project"));
			pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintPlanDAO.savePlanProjectAdd(pkgParam);

			error_code = (String) pkgParam.get("p_error_code");
			error_msg = (String) pkgParam.get("p_error_msg");

			if (!"S".equals(error_code)) {
				throw new DisException(error_msg);
			}

			Map<String, Object> pkgParam2 = new HashMap<String, Object>();
			pkgParam2.put("p_project_no", commandMap.get("add_project"));
			pkgParam2.put("p_revision_no", "0");
			pkgParam2.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintImportPaintDAO.savePaintPlanRelease(pkgParam2);

			String sMainErrorCode = (String) pkgParam2.get("p_error_code");
			String sMainErrorMsg = (String) pkgParam2.get("p_error_msg");

			if (!"S".equals(sMainErrorCode) && !"F".equals(sMainErrorCode)) {
				throw new DisException(sMainErrorMsg);
			}

			if ("F".equals(sMainErrorCode)) {
				throw new DisException("customer.message1", sMainErrorMsg);

			}
		}
		
		// 결과값에 따른 메시지를 담아 전송
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
