package stxship.dis.dps.dpApproval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.dps.common.dao.DpsCommonDAO;

/**
 * @파일명 : DpApprovalDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpApproval에서 사용되는 DAO
 *     </pre>
 */
@Repository("dpApprovalDAO")
public class DpApprovalDAO extends DpsCommonDAO {
	
	/**
	 * 
	 * @메소드명	: getPartDPConfirmsList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 결제 현황
	 * </pre>
	 * @param map
	 * @return
	 */
	public List getPartDPConfirmsList(Map<String, Object> map) {
		return selectListDps("dpApprovalCommon.selectPartDPConfirmsList", map);
	}
	
	/**
	 * 
	 * @메소드명	: getPartDPInputRateList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 시수 입력률
	 * </pre>
	 * @param map
	 * @return
	 */
	public List getPartDPInputRateList(Map<String, Object> map) {
		return selectListDps("dpApprovalCommon.selectPartDPInputRateList", map);
	}
	/**
	 * 
	 * @메소드명	: getDwgDeptGubun
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 부서구분
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map getDwgDeptGubun(Map<String, Object> map) {
		return selectOneDps("dpApprovalCommon.selectDwgDeptGubun", map);
	}
	
	/**
	 * 
	 * @메소드명	: updateApprovalConfirm
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 시수 결제사항 업데이트
	 * </pre>
	 * @param rowData
	 */
	public void updateApprovalConfirm(Map<String, Object> rowData) {
		updateDps("dpApprovalMainGridSave.updateApprovalConfirm", rowData);		
	}
	
	/**
	 * 
	 * @메소드명	: getDwgMH_Overtime
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 도면 별 계획시수 대비 실적시수 초과사항 쿼리
	 * </pre>
	 * @param param
	 * @return
	 */
	public List getDwgMH_Overtime(Map param) {
		return selectListDps("dpApprovalCommon.selectDwgMH_Overtime", param);
	}
	/**
	 * 
	 * @메소드명	: getAlreadyConfirm
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * confirm yn already check
	 * </pre>
	 * @param param
	 * @return
	 */
	public Map<String,Object> getAlreadyConfirm(Map param) {
		return selectOneDps("dpApprovalMainGridSave.selectAlreadyConfirm", param);
	}
	/**
	 * 
	 * @메소드명	: getPlmDesignMhFactorUpdateTarget
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *공정시수 업데이트 대상
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPlmDesignMhFactorUpdateTarget(Map<String, Object> param) {
		return selectListDps("dpApprovalMainGridSave.selectPlmDesignMhFactorUpdateTarget", param);
	}
	
	/**
	 * 
	 * @메소드명	: getPlmDesignMhActionDateUpdateTarget
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Event1, Event2, Event3 값이 있으면 공정 Action Date를 업데이트
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPlmDesignMhActionDateUpdateTarget(Map<String, Object> param) {
		return selectListDps("dpApprovalMainGridSave.selectPlmDesignMhActionDateUpdateTarget", param);
	}
	
	/**
	 * 
	 * @메소드명	: updateApprovalConfirm
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *  수집된 업데이트 대상(: 시수결재 사항이 변경된 것) 공정시수를 업데이트
	 * </pre>
	 * @param rowData
	 */
	public void updateApprovalPlmActivity(Map<String, Object> param) {
		updateDps("dpApprovalMainGridSave.updateApprovalPlmActivity", param);		
	}
	/**
	 * 
	 * @메소드명	: updateApprovalPlmActionDate
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Event1, Event2, Event3 값이 있으면 공정 Action Date를 업데이트
	 * </pre>
	 * @param param
	 */
	public void updateApprovalPlmActionDate(Map<String, Object> param) {
		updateDps("dpApprovalMainGridSave.updateApprovalPlmActionDate", param);		
	}
	
	/**
	 * 
	 * @메소드명	: getPlmDesignDwStartAutoUpdateTarget
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 도면에 대한 설계시수 최초 입력 시(DW Actual Date가 없는 경우) 공정실적(DW Start)을 자동입력 - Maker도면 제외
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPlmDesignDwStartAutoUpdateTarget(Map<String, Object> param) {
		return selectListDps("dpApprovalMainGridSave.selectPlmDesignDwStartAutoUpdateTarget", param);
	}
	/**
	 * 
	 * @메소드명	: updateApprovalPlmDwStart
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *도면에 대한 설계시수 최초 입력 시(DW Actual Date가 없는 경우) 공정실적(DW Start)을 자동입력 - Maker도면 제외
	 * </pre>
	 * @param rowData
	 */
	public void updateApprovalPlmDwStart(Map<String, Object> rowData) {
		updateDps("dpApprovalMainGridSave.updateApprovalPlmDwStart", rowData);		
	}
	/**
	 * 
	 * @메소드명	: plmConfirmProcedure
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *  2015-03-17 : PLM 시수 결재시 일단위 마감 PROCEDURE 호출
	 * </pre>
	 * @param param
	 * @return
	 */
	public String plmConfirmProcedure(Map<String,Object> param){
		return selectOneDps("dpApprovalMainGridSave.plmConfirmProcedure",param);
	}
}
