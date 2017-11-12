package stxship.dis.dps.dpInput.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpInput.dao.DpInputDAO;

/**
 * @파일명 : DpInputServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpInput에서 사용되는 서비스
 *     </pre>
 */
@Service("dpInputService")
public class DpInputServiceImpl extends DpsCommonServiceImpl implements DpInputService {

	@Resource(name = "dpInputDAO")
	private DpInputDAO dpInputDAO;

	@Override
	public Map<String, String> saveInputProjectSelect(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		dpInputDAO.updateDps("popUpInputProjectSelectedNInvaildItemSave.init", commandMap.getMap());
		
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put("employee_id", commandMap.get("employee_id"));
			
			dpInputDAO.updateDps("popUpInputProjectSelectedNInvaildItemSave.update", rowData);
			dpInputDAO.insertDps("popUpInputProjectSelectedNInvaildItemSave.insert", rowData);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	/**
	 * 
	 * @메소드명	: saveAsOneDayOverJobDPInputsAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수입력 사항을 DB에 저장(1 일 이상 - 기술회의 및 교육, 일반출장)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	public int saveAsOneDayOverJobDPInputsAction(CommandMap commandMap) throws Exception {
		dpInputDAO.deletePlmDesignMH(commandMap.getMap());
		
		List<Map<String,Object>> listTarget = dpInputDAO.getInsedeWorkTimeTarget(commandMap.getMap());
		
		for(Map<String,Object> map : listTarget){
			commandMap.put("dateStr", map.get("workingday"));
			commandMap.put("workTimeStr", Float.parseFloat(String.valueOf(map.get("INSIDEWORKTIME"))));
			dpInputDAO.insertPlmDesignMH(commandMap.getMap());
		}
		return listTarget.size();
	}
	/**
	 * 
	 * @메소드명	: saveAsOneDayOverJobWithProjectDPInputsAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	시수입력 사항을 DB에 저장(1 일 이상(호선선택 포함) - 사외 협의 검토)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	public int saveAsOneDayOverJobWithProjectDPInputsAction(CommandMap commandMap) throws Exception {
		dpInputDAO.deletePlmDesignMH(commandMap.getMap());
		List<Map<String,Object>> listTarget = dpInputDAO.getInsedeWorkTimeTarget(commandMap.getMap());
		for(Map<String,Object> map : listTarget){
			commandMap.put("dateStr", map.get("workingday"));
			commandMap.put("workTimeStr", Float.parseFloat(String.valueOf(map.get("INSIDEWORKTIME"))));
			dpInputDAO.insertPlmDesignMHProject(commandMap.getMap());
		}
		return listTarget.size();
	}
	/**
	 * 
	 * @메소드명	: saveSeaTrialDPInputsAction
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 사항을 DB에 저장(시운전 Only 케이스)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int saveSeaTrialDPInputsAction(CommandMap commandMap) throws Exception {
		dpInputDAO.deletePlmDesignMHTrial(commandMap.getMap());
		Map<String,Object> target = dpInputDAO.getInsedeWorkTimeTargetTrial(commandMap.getMap());
		
		String isWorkingDay = String.valueOf(target.get("isworkday"));
		String workTimeStr = String.valueOf(target.get("insideworktime"));
		
		float normalTime = 0;
		float overtime = 0;
		float specialTime = 0;
		if (isWorkingDay.equals("N")) specialTime = 8;	 // 휴일이면 특근 8 시간으로 처리
		else {
			if (workTimeStr.equals("4")) normalTime = 4; // 4H 이면 정상근무 4 시간 + 잔업 3 시간
			else normalTime = 9;                         // 나머지는 정상근무 9 시간 + 잔업 3 시간
			overtime = 3;
		}
		
		commandMap.put("overTime", overtime);
		commandMap.put("normalTime", normalTime);
		commandMap.put("specialTime", specialTime);
		
		dpInputDAO.insertPlmDesignMHProjectTrial(commandMap.getMap());
		
		return 0;
	}
	
	/**
	 * 
	 * @메소드명	: saveDPInputsAction
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 사항을 DB에 저장 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int saveDPInputsAction(CommandMap commandMap) throws Exception {
		List<Map<String,Object>> ary =  DisJsonUtil.toList(commandMap.get("param"));
		
		dpInputDAO.deletePlmDesignMHTrial(ary.get(0));
		for(Map<String,Object> temp : ary){
				temp.put("loginId", commandMap.get("loginId"));
				dpInputDAO.insertPlmDesignMHProjectInput(temp);
		}
		return 0;
	}

	@Override
	public List<Map<String, Object>> getOpCodeListGRT(Map<String, Object> map) throws Exception {
		return dpInputDAO.getOpCodeListGRT(map);
	}

	@Override
	public List<Map<String, Object>> getOpCodeListMID(Map<String, Object> map) throws Exception {
		return dpInputDAO.getOpCodeListMID(map);
	}

	@Override
	public List<Map<String, Object>> getOpCodeListSUB(Map<String, Object> map)throws Exception {
		return dpInputDAO.getOpCodeListSUB(map);
	}
	/**
	 * 
	 * @메소드명	: getDrawingListForWork
	 * @날짜		: 2016. 9. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선 + 타입에 해당하는 도면들 목록을 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getDrawingListForWork(CommandMap commandMap) throws Exception{
		Map<String,Object> param = commandMap.getMap();
		if ((String.valueOf(param.get("project_no")).startsWith("Z"))) param.put("project_no", (String.valueOf(param.get("project_no")).substring(1)));
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> listForWork1 = dpInputDAO.getDrawingListForWorkNormal(param);
		for(Map<String,Object> map : listForWork1)returnList.add(map);
		// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
		// : DPC_HEAD 테이블에서 Max CaseNo 이고 DWGDEPTCODE 가 해당 부서인 것이면서 
		// : SHIPTYPE(선종) 컬럼 값이 해당 호선의 선종을 포함하는 것이 대상 
		// : - 참고: SHIPTYPE 컬럼 값은 Bit 합으로 되어 있고 선종코드는 코드테이블(CCC_CODE)에 정의되어 있다
		if(listForWork1.size() == 0){
			List<Map<String,Object>> listForWork2 = dpInputDAO.getDrawingListForWorkNotDp1(param);
			for(Map<String,Object> map : listForWork2)returnList.add(map);
		}
		// Start :: 2015-02-04 Kang seonjung : (서광훈 과장 요청) 선체생산설계-선형기술P(480100)는 000029(선형기술P), 000051(선체생설P) 조회 가능
		// 선형기술P가 선체생설P 도면 조회 때도 DP에 없으면 WBS에서 가져옴
		if("480100".equals(String.valueOf(commandMap.get("depart_code")))){
			List<Map<String,Object>> listForWork3 = dpInputDAO.getDrawingListForWorkNotDp2(param);
			for(Map<String,Object> map : listForWork3)returnList.add(map);
			
			// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
			if(listForWork3.size() == 0){
				List<Map<String,Object>> listForWork4 = dpInputDAO.getDrawingListForWorkNotDp3(param);
				for(Map<String,Object> map : listForWork4)returnList.add(map);
			}
		}
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: dpInputMainGridSave
	 * @날짜		: 2016. 9. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 메인 그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> dpInputMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		try{
			commandMap.put("type_action", "grid");
			dpInputDAO.deletePlmDesignMHTrial(commandMap.getMap());
			
			for (Map<String, Object> rowData : saveList) {
				rowData.put("loginId", commandMap.get("loginId"));
				rowData.put("dateselected", commandMap.get("dateselected"));
				rowData.put("designerList", commandMap.get("designerList"));
				rowData.put("inputDoneYN", commandMap.get("inputDoneYN"));

				rowData.put("type_action", "grid");
				dpInputDAO.insertPlmDesignMHProjectInput(rowData);
			}
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}
	/**
	 * 
	 * @메소드명	: deleteDPInputs
	 * @날짜		: 2016. 9. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 입력시수 전체 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> deleteDPInputs(CommandMap commandMap) throws Exception {
		try{
			dpInputDAO.deletePlmDesignMHTrial(commandMap.getMap());
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}

}
