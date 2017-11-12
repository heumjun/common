package stxship.dis.bom.pending.dao;

import java.util.List;
import java.util.Map;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("pendingDAO")
public class PendingDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	//프로젝트에 해당하는 마스터호선 반환.
	public String pendingMasterNo(Map<String, Object> map) {
		return selectOne("pendingCommon.pendingMasterNo", map);
	}
	
	//Pending 메인 리스트 반환.
	@JsonIgnore
	public Map<String, Object> pendingMainList(Map<String, Object> map) {
		disSession.selectList("pendingList.list", map);
		return map;
	}
	
	//Pending 메인화면에서 부서에 해당하는 도면리스트 ARK(Auto Recommand Keyword) 반환.
	public List<Map<String, Object>> pendingDwgNoList(Map<String, Object> map) {
		return selectList("pendingCommon.pendingDwgNoList", map);
	}
	
	//Pending 메인 리스트에서 WORK 클릭시 SSC-Bom 내용 리스트 반환.
	public Map<String, Object> popupPendingWorkList(Map<String, Object> map) {
		disSession.selectList("pendingList.popupPendingWorkList", map);
		return map;
	}
	
	//Pending-ADD 리스트 결과.
	//pending-ADD DWG 클릭 시 Popup 화면 호출
	//popupPendingAddGetDwgno 화면에서 도면리스트 반환.
	public List<Map<String, Object>> popupPendingAddGetDwgnoList(Map<String, Object> map) {
		return selectList("pendingGetPendingDwgno.popupPendingAddGetDwgnoList", map);
	}
	
	/////////////////////////////////////////////////////////////////////START
	//Pending ADD NextButton Action 3단계 Delete -> Insert - > Select
	//Pending-ADD 화면에서 pending_work TempTable clear.
	public void pendingWorkDelete(Map<String, Object> map) {
		selectOne("pendingAddList.procDeletePendingWork", map);
	}
	
	//Pending-ADD 화면에서 pending_work TempTable에 Insert.
	public void pendingWorkInsert(Map<String, Object> map) {
		selectOne("pendingAddList.procInsertPendingWork", map);
	}
	
	//Pending-ADD 화면에서 TempTable 리스트 반환.
	public Map<String, Object> pendingNextAction(Map<String, Object> map) {
		disSession.selectList("pendingAddList.pendingNextList", map);
		return map;
	}
	/////////////////////////////////////////////////////////////////////END

	//Pending-ADD 화면에서 Apply시 Pending 생성.
	public void pendingApplyAction(Map<String, Object> map) {
		selectOne("pendingAddList.procApplyPendingWork", map);
	}
	
	//Pending-DELETE 화면에서 Apply시 Pending 삭제.
	public void pendingDelApplyAction(Map<String, Object> map) {
		selectOne("pendingDelList.procDelApplyPendingWork", map);
	}

	public Map<String, Object> pendingChekedMainList(Map<String, Object> map) {
		disSession.selectList("pendingCommon.pendingCheckedMainList", map);
		return map;
	}
	
	public void pendingModifyWorkInsert(Map<String, Object> map) {
		selectOne("pendingModify.procInsertPendingWork", map);
	}
	
	public void pendingModifyValidation(Map<String, Object> map) {
		selectOne("pendingModify.procModifyValidation", map);
	}

	public Map<String, Object> pendingWorkValidationList(Map<String, Object> map) {
		disSession.selectList("pendingModify.pendingWorkValidationList", map);
		return map;
	}

	public void pendingModifyApplyAction(Map<String, Object> map) {
		selectOne("pendingModify.procModifyAction", map);
	}

	/**
	 * @메소드명 : pendingEcoInfo
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *  ECO 정보 받아옴(영구/자정, 상태 등등)
	 *	1. PENDING BOM 이행 시 사용
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> pendingEcoInfo(Map<String, Object> map) {
		return selectOne("pendingBom.pendingEcoInfo", map);
	}

	/**
	 * @메소드명 : updatePendingHeadEcoNo
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updatePendingHeadEcoNo(Map<String, Object> map) {
		return update("pendingBom.updatePendingHeadEcoNo", map);
		
	}

	/**
	 * @메소드명 : pendingCancelAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PENDING Main Cancel Action
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void pendingCancelAction(Map<String, Object> map) {
		selectOne("pendingCancel.procCancelAction", map);
	}

	/**
	 * @메소드명 : pendingRestoreAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PENDING Main Restore Action
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void pendingRestoreAction(Map<String, Object> map) {
		selectOne("pendingRestore.procRestoreAction", map);
	}

	/**
	 * @메소드명 : pendingDeleteTemp
	 * @날짜 : 2016. 12. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ADD, DELETE 버튼 클릭 시 TEMP 테이블 비움
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public void pendingDeleteTemp(Map<String, Object> map) {
		selectOne("pendingList.pendingDeleteTemp", map);
	}

	public List<Map<String, Object>> getDwgnoList(Map<String, Object> map) {
		return selectList("pendingCommon.getDwgNoList", map);
	}
}
