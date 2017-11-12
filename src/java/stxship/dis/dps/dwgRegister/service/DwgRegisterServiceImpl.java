package stxship.dis.dps.dwgRegister.service;

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
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dwgRegister.dao.DwgRegisterDAO;

@Service("dwgRegisterService")
public class DwgRegisterServiceImpl extends DpsCommonServiceImpl implements DwgRegisterService{
	
	@Resource(name = "dwgRegisterDAO")
	private DwgRegisterDAO dwgRegisterDAO;
	
	
	/**
	 * 
	 * @메소드명	: getAllProjectList
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 전체 호선 목록을 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String,Object>> getAllProjectList() throws Exception {
		return dwgRegisterDAO.getAllProjectList();
	}
	
	/**
	 * 
	 * @메소드명	: getDeployReasonCodeList
	 * @날짜		: 2016. 8. 2.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연사유 코드 리스트 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDeployReasonCodeList() throws Exception {
		return dwgRegisterDAO.getDeployReasonCodeList();
	}

	/**
	 * 
	 * @메소드명	: getDeployNoPrefix
	 * @날짜		: 2016. 8. 2.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서(팀) 별 배포번호 영문코드 관리 하드코딩(상선) 부분을 파트로 세분화 (인사부서) 하고 TABLE로 관리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getDeployNoPrefix(Map<String, Object> param) throws Exception {
		return dwgRegisterDAO.getDeployNoPrefix(param);
	}
	/**
	 * 
	 * @메소드명	: getDrawingListForWork2
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선에 해당하는 도면들 목록을 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDrawingListForWork2(HashMap<String, Object> param) throws Exception {
		return dwgRegisterDAO.getDrawingListForWork2(param);
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingForWork3
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 + 호선 + 도면에 해당하는 도면정보를 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getDrawingForWork3(HashMap<String, Object> param) throws Exception {
		return dwgRegisterDAO.getDrawingListForWork3(param);
	}
	/**
	 * 
	 * @메소드명	: popUpHardCopyDwgCreateGridSave
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Register 팝업 저장 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpHardCopyDwgCreateGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		//하나의 배포번호로 여러개 도면 번호 등록이 가능해야 하기에.. 배포번호는 미리 지정해둠.
		String deployNoPrefix = String.valueOf(commandMap.get("deployNoPrefix"));
		String deployNoPostfix = dwgRegisterDAO.getDeployNoPostFix(commandMap).trim();		
		String deployNo = deployNoPrefix + "-" + deployNoPostfix;
		
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put("deployNoPrefix", commandMap.get("deployNoPrefix"));
			rowData.put("dept_code", commandMap.get("dept_code"));
			rowData.put("requestDate", commandMap.get("requestDate"));
			rowData.put("deployDate", commandMap.get("deployDate"));
			rowData.put("inputGubun", commandMap.get("inputGubun"));
			
			rowData.put("deployNo", deployNo);
			rowData.put("deployNoPostfix",deployNoPostfix);
			
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				String result = gridDataInsertDps(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					String dwgno_query = String.valueOf(rowData.get("dwg_no"));
					
					if ("0".equals(String.valueOf(rowData.get("deploy_rev")))) 
				    {
						rowData.put("activity_code", dwgno_query+"WK");
						gridDataUpdateDps(rowData);
				    }
					else if ("A".equals(String.valueOf(rowData.get("deploy_rev"))) && dwgno_query.indexOf("V") != 0){
						rowData.put("activity_code", dwgno_query+"RF");
						gridDataUpdateDps(rowData);
					}
					
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(result);
				}
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	
}
