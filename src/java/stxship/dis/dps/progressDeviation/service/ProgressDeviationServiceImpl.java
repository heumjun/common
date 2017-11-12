package stxship.dis.dps.progressDeviation.service;

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
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.progressDeviation.dao.ProgressDeviationDAO;

import com.stx.common.util.StringUtil;


/** 
 * @파일명	: ProgressDeviationServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 7. 8. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * ProgressDeviation파일 service 구현부
 * </pre>
 */
@Service("progressDeviationService")
public class ProgressDeviationServiceImpl extends DpsCommonServiceImpl implements ProgressDeviationService {

	@Resource(name = "progressDeviationDAO")
	private ProgressDeviationDAO progressDeviationDAO;
	
	/**
	 * 
	 * @메소드명	: getPartPersons_Dalian
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *   부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자&시수입력&공정입력 비 대상자 제외
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param) throws Exception {
		if (StringUtil.isNullString(String.valueOf(param.get("dept_code")))) throw new Exception("Department Code is null");
		return progressDeviationDAO.getPartPersons_Dalian(param);
	}
	
	/**
	 * 
	 * @메소드명	: progressDeviationMainGridSave
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	필요항목 재구성 및 오버로딩
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> progressDeviationMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
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
	}
	
	
	
	/**
	 * 
	 * @메소드명	: getPLMActivityDeviationDesc
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연사유 특기사항 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getPLMActivityDeviationDesc(CommandMap commandMap) throws Exception {
		return progressDeviationDAO.getPLMActivityDeviationDesc(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: savePLMActivityDeviationDesc
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연사유 특기사항 저장
	 * </pre>
	 * @param param
	 * @throws Exception
	 */
	@Override
	public void savePLMActivityDeviationDesc(Map<String, Object> param)
			throws Exception {
		progressDeviationDAO.savePLMActivityDeviationDesc(param);
	}
	
	
}
