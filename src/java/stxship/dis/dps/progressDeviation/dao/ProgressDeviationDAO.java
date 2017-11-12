package stxship.dis.dps.progressDeviation.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.dao.DpsCommonDAO;

@Repository("progressDeviationDAO")
public class ProgressDeviationDAO extends DpsCommonDAO {
	
	
	/**
	 * 
	 * @메소드명	: getPartPersons_Dalian
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자&시수입력&공정입력 비 대상자 제외
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param) throws Exception{
		return selectListDps("progressDeviation.selectPartPersons_Dalian",param);
	}
	
	
	/**
	 * 
	 * @메소드명	: getPLMActivityDeviationDesc
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연사유 특기사항 조회 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> getPLMActivityDeviationDesc(CommandMap commandMap) {
		return selectOneDps("popUpDelayReasonDesc.selectPLMActivityDeviationDesc", commandMap.getMap());
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
	 */
	public void savePLMActivityDeviationDesc(Map<String, Object> param) {
		selectOneDps("popUpDelayReasonDesc.savePLMActivityDeviationDesc",param);
	}
	
}
