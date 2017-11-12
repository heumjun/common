package stxship.dis.paint.usc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.paint.usc.dao.PaintUscDAO;

/**
 * @파일명 : PaintUscServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 22.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * PaintUsc 서비스 로직
 *     </pre>
 */
@Service("paintUscService")
public class PaintUscServiceImpl extends CommonServiceImpl implements PaintUscService {

	@Resource(name = "paintUscDAO")
	private PaintUscDAO paintUscDAO;

	/**
	 * @메소드명 : insertPaintWbsReCreate
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * WBS 분리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> insertPaintWbsReCreate(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> wbsList = DisJsonUtil.toList(commandMap.get("chmResultList"));

		String error_code = "";
		String error_msg = "";

		for (Map<String, Object> rowData : wbsList) {
			String sLevel = DisStringUtil.nullString(rowData.get("level_no"));

			if (sLevel.equals("1")) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				pkgParam.put("p_mother_code", rowData.get("mother_code"));
				pkgParam.put("p_item_code", rowData.get("item_code"));
				pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				paintUscDAO.insertPaintWbsReCreate(pkgParam);

				error_code = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				error_msg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));

				if (!"S".equals(error_code) && !"F".equals(error_code)) {
					throw new DisException(error_msg);
				}

				if ("F".equals(error_code)) {
					throw new DisException("customer.message1", error_msg);
				}
			} else {
				throw new DisException("1 Level 만 WBS 분리가 가능합니다.");
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : deletePaintUsc
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집의 선택된 JOB의 삭제처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> deletePaintUsc(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> wbsList = DisJsonUtil.toList(commandMap.get("chmResultList"));

		for (Map<String, Object> rowData : wbsList) {

			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_bom_states", rowData.get("bom_states"));
			pkgParam.put("p_states", rowData.get("states"));
			pkgParam.put("p_mother_code", rowData.get("mother_code"));
			pkgParam.put("p_item_code", rowData.get("item_code"));
			pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintUscDAO.deletePaintUscJobItem(pkgParam);

			if (!"S".equals(DisStringUtil.nullString(pkgParam.get("p_error_code")))) {
				throw new DisException(DisStringUtil.nullString(pkgParam.get("p_error_msg")));
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : savePaintUscJobItemCreate
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 채번을 선택했을때 추가된 JOB의 채번처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintUscJobItemCreate(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> wbsSubList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		for (Map<String, Object> rowData : wbsSubList) {

			Map<String, Object> pkgParam1 = new HashMap<String, Object>();

			pkgParam1.put("p_wbs_item_code", commandMap.get("p_top_item"));
			pkgParam1.put("p_wbs_sub_item_id", rowData.get("wbs_sub_item_id"));
			pkgParam1.put("p_ship_type", commandMap.get("p_ship_type"));
			pkgParam1.put("p_level_no", rowData.get("level_no"));
			pkgParam1.put("p_mother_catalog", rowData.get("mother_catalog"));
			pkgParam1.put("p_item_catalog", rowData.get("item_catalog"));
			pkgParam1.put("p_bom_states", rowData.get("bom_states"));
			pkgParam1.put("p_states", rowData.get("states"));
			pkgParam1.put("p_mother_code", rowData.get("mother_code"));
			pkgParam1.put("p_item_code", rowData.get("item_code"));
			pkgParam1.put("p_findnumber", rowData.get("findnumber"));
			pkgParam1.put("p_bom10", rowData.get("bom10"));
			pkgParam1.put("p_bom11", rowData.get("bom11"));
			pkgParam1.put("p_wbs_sub_mother_id", rowData.get("wbs_sub_mother_id"));
			pkgParam1.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam1.put("p_item_desc", rowData.get("item_desc"));

			paintUscDAO.insertPaintUscJobItemAdd(pkgParam1);

			if (!"S".equals(DisStringUtil.nullString(pkgParam1.get("p_error_code")))) {
				throw new DisException(DisStringUtil.nullString(pkgParam1.get("p_error_msg")));
			}
		}

		Map<String, Object> pkgParam2 = new HashMap<String, Object>();

		pkgParam2.put("p_wbs_item_code", commandMap.get("p_top_item"));

		paintUscDAO.insertPaintUscJobMotherCheck(pkgParam2);

		if (!"S".equals(DisStringUtil.nullString(pkgParam2.get("p_error_code")))) {
			throw new DisException(DisStringUtil.nullString(pkgParam2.get("p_error_msg")));
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : savePaintUscBom
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 채번된 JOB의 BOM및 ECO의 연계처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintUscBom(CommandMap commandMap) throws Exception {
		Map<String, Object> pkgParam1 = new HashMap<String, Object>();

		pkgParam1.put("p_wbs_item_code", commandMap.get("p_top_item"));
		pkgParam1.put("p_eco_no", commandMap.get("eco_main_name"));
		pkgParam1.put("p_project_no", commandMap.get("p_project_no"));
		pkgParam1.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		paintUscDAO.savePaintUscBom(pkgParam1);

		String error_code = DisStringUtil.nullString(pkgParam1.get("p_error_code"));
		String error_msg = DisStringUtil.nullString(pkgParam1.get("p_error_msg"));

		if (!"S".equals(error_code) && !"F".equals(error_code)) {
			throw new DisException(error_msg);
		}

		if ("F".equals(error_code)) {
			throw new DisException("customer.message1", error_msg);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : savePaintWbsEcoAdd
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO를 추가 처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintWbsEcoAdd(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> wbsList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		String error_code = "";
		String error_msg = "";

		for (Map<String, Object> rowData : wbsList) {
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_mother_code", rowData.get("mother_code"));
			pkgParam.put("p_item_code", rowData.get("item_code"));
			pkgParam.put("p_eco_main_name", commandMap.get("eco_main_name"));
			pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintUscDAO.savePaintWbsEcoAdd(pkgParam);

			error_code = DisStringUtil.nullString(pkgParam.get("p_error_code"));
			error_msg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));

			if (!"S".equals(error_code) && !"F".equals(error_code)) {
				throw new DisException(error_msg);
			}

			if ("F".equals(error_code)) {
				throw new DisException("customer.message1", error_msg);
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

}
