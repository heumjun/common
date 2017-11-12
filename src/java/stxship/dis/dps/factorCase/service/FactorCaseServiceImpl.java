/**
 * 
 */
package stxship.dis.dps.factorCase.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.stx.tbc.dao.factory.FactoryDAO;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.dps.common.service.DpsCommonService;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.factorCase.dao.FactorCaseDAO;

/** 
 * @파일명	: FactorCaseServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 9. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 시수 적용율 Case 관리
 * </pre>
 */
@Service("factorCaseService")
public class FactorCaseServiceImpl extends DpsCommonServiceImpl implements FactorCaseService {
	@Resource(name = "factorCaseDAO")
	private FactorCaseDAO factorCaseDAO;
	
	/**
	 * 
	 * @메소드명	: dwgRegisterMainGridSave
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수 적용율 Case관리 메인 그리드 데이터 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> dwgRegisterMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put("case_no", commandMap.get("maxCase"));
			
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				if(
						String.valueOf(rowData.get("month_from")).equals("") &&
						String.valueOf(rowData.get("month_to")).equals("") &&
						String.valueOf(rowData.get("factor")).equals("")
				) continue;
				String result = gridDataInsertDps(rowData);
				if(commandMap.containsKey("defaultCaseCheck"))updateDefaultCase(rowData);
				if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(result);
				}
			} else if("R".equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				if(commandMap.containsKey("defaultCaseCheck"))updateDefaultCase(rowData);
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}


	@Override
	public void updateDefaultCase(Map<String, Object> param) throws Exception {
		factorCaseDAO.updateDefaultCase(param);
	}
	
}
