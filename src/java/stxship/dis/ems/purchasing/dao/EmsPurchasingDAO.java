package stxship.dis.ems.purchasing.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("emsPurchasingDAO")
public class EmsPurchasingDAO extends CommonDAO {

	public List<Map<String, Object>> emsPurchasingSelectBoxDept(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getSelectBoxDeptList", map);
	}
	
	public List<Map<String, Object>> emsPurchasingAddSelectBoxPjt(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getSelectBoxPjtList", map);
	}
	
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxCauseDept(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getSelectBoxCauseDeptList", map);
	}
	
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxPosType(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getSelectBoxPosTypeList", map);
	}
	
	public String posSelectProjectId(Map<String, Object> map) {
		return selectOne("emsPurchasingMain.posSelectProjectId", map);
	}
	
	public String posSelectEquipName(Map<String, Object> map) {
		return selectOne("emsPurchasingMain.posSelectEquipName", map);
	}
	
	public Map<String, Object> posGetFileId(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.posGetFileId", map);
	}

	public int posUploadFile(Map<String, Object> map) {
		return updateErp("emsPurchasingMain.posUploadFile", map);
	}
	
	public Map<String, Object> posInsertRow(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.posInsertRow", map);
	}
	
	public Map<String, Object> posInsertSelectedFile(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.posInsertSelectedFile", map);
	}

	public Map<String, Object> insertPosRevision(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.insertPosRevision", map);
	}
	
	public Map<String, Object> insertPosRevisionPurNo(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.insertPosRevisionPurNo", map);
	}
	
	public int popUpPurchasingPosApprove(Map<String, Object> map) {
		return update("emsPurchasingMain.posApprove", map);
	}
	
	public Map<String, Object> popUpPurchasingPosDownloadFile(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.posDownloadFile", map);
	}

	public int emsPurchasingDeleteA(Map<String, Object> map) {
		return delete("emsPurchasingMain.deletePurchasingA", map);
	}

	public int emsPurchasingDeleteS(Map<String, Object> map) {
		return delete("emsPurchasingMain.deletePurchasingS", map);
	}
	
	/** 
	 * @메소드명	: popUpPurchasingRequestListTeamLeader
	 * @날짜		: 2016. 03. 14. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 승인요청 버튼 팝업창 : 팀장 리스트 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */	
	public List<Map<String, Object>> popUpPurchasingRequestListTeamLeader(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getTeamLeaderList", map);
	}
	
	/** 
	 * @메소드명	: popUpPurchasingRequestListPartLeader
	 * @날짜		: 2016. 03. 14. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 승인요청 버튼 팝업창 : 파트장 리스트 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */	
	public List<Map<String, Object>> popUpPurchasingRequestListPartLeader(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getPartLeaderList", map);
	}
	
	/** 
	 * @메소드명	: requestSelectUserInfo
	 * @날짜		: 2016. 03. 14. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 승인요청 버튼 팝업창 : 유저 정보를 가져옴
	 * </pre>
	 * @param rowData
	 * @return
	 */	
	public Map<String, Object> requestSelectUserInfo(Map<String, Object> map) {
		return selectOne("emsPurchasingMain.getUserInfo", map);
	}
	
	/** 
	 * @메소드명	: requestApply
	 * @날짜		: 2016. 03. 14. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 승인요청 버튼 팝업창 : 승인요청 업데이트
	 * </pre>
	 * @param map
	 * @return
	 */	
	public int requestApply(Map<String, Object> map) {
		return update("emsPurchasingMain.requestApply", map);
	}
	
	/** 
	 * @메소드명	: requestApply
	 * @날짜		: 2016. 03. 14. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 승인요청 버튼 팝업창 : 승인요청 성공시 메일 발송
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> requestApplyEmail(Map<String, Object> map) {
		return selectOne("emsCommonMain.sendEmail", map);
	}

	/** 
	 * @메소드명	: popUpPurchasingRestore
	 * @날짜		: 2016. 03. 16. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * A복원 버튼을 실행하여 상태를 변경
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public int restoreStateA(Map<String, Object> map) {
		return update("emsPurchasingMain.restoreStateA", map);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecObtainList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 조달 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingSpecObtainList(Map<String, Object> map) {
		return selectList("emsPurchasingMain.specObtainList", map);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecPlanList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 설계 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingSpecPlanList(Map<String, Object> map) {
		return selectList("emsPurchasingMain.specPlanList", map);
	}
	
	/**
	 * @메소드명 : getSelectBoxVenderName
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 그리드 내 업체명 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> getSelectBoxVenderName(Map<String, Object> map) {
		return selectList("emsPurchasingMain.getVenderName", map);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecApply
	 * @날짜 : 2016. 04. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : SPEC 데이터를 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpPurchasingSpecApply(Map<String, Object> map) {
		return selectOne("emsPurchasingMain.getSpecApply", map);
	}
	
	/**
	 * @메소드명 : insertSpecRow
	 * @날짜 : 2016. 04. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : SPEC 사양 검토
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> insertSpecRow(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.insertSpecRow", map);
	}
	
	/**
	 * @메소드명 : insertSpecFile
	 * @날짜 : 2016. 04. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 선택한 첨부파일 목록 Insert
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> insertSpecFile(Map<String, Object> map) {
		return selectOneErp("emsPurchasingMain.insertSpecFile", map);
	}
	
	/**
	 * @메소드명 : emsPurchasingExcelExport
	 * @날짜 : 2015. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> emsPurchasingExcelExport(Map<String, Object> map) {
		return selectListErp("emsPurchasingExcelExport.list", map);
	}

	/**
	 * @메소드명 : emsPurchasingDPExcelExport
	 * @날짜 : 2015. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> emsPurchasingDPExcelExport(Map<String, Object> map) {
		return selectListErp("popUpPurchasingDpList.list", map);
	}
}
