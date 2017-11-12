package stxship.dis.bom.ssc.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : SscDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 1. 12.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 
 *     </pre>
 */
@Repository("sscDAO")
public class SscDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	/**
	 * @메소드명 : selectMainList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC Main 리스트 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectMainList(Map<String, Object> map) {
		
		disSession.selectList("sscMainList" + map.get("p_item_type_cd") + ".sscMainList", map);
		return map;
	}

	/**
	 * @메소드명 : selectDwgNoList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	호선, 부서 별 도면번호 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscDwgNoList(Map<String, Object> map) {
		return selectList("sscCommonList.sscDwgNoList", map);
	}
	
	/**
	 * @메소드명 : sscAutoCompleteUscJobTypeList
	 * @날짜 : 2017. 03. 20.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 USC_JOB_TYPE Auto Complete 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscAutoCompleteUscJobTypeList(Map<String, Object> map) {
		return selectList("sscCommonList.sscAutoCompleteUscJobTypeList", map);
	}

	/**
	 * @메소드명 : sscSeriesList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC 시리즈 호선 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscSeriesList(Map<String, Object> map) {
		return selectList("sscCommonList.sscSeriesList", map);
	}

	/**
	 * @메소드명 : sscPaintSeriesList
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Paint 시리즈 호선 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscPaintSeriesList(Map<String, Object> map) {
		return selectList("sscCommonList.sscPaintSeriesList", map);
	}

	/**
	 * @메소드명 : sscRevText
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC REV 텍스트 박스용 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String sscRevText(Map<String, Object> map) {
		return selectOne("sscCommonList.sscRevText", map);
	}

	/**
	 * @메소드명 : sscMasterNo
	 * @날짜 : 2016. 1. 6.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PROJECT를 이용해서 MASTER를 받아옴.
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String sscMasterNo(Map<String, Object> map) {
		return selectOne("sscCommonList.sscMasterNo", map);
	}

	/**
	 * @메소드명 : sscJobList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 호선, 블럭 STR을 이용하여 JOB LIST 받아옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscJobList(Map<String, Object> map) {
		disSession.selectList("sscCommonList.sscJobList", map);
		return map;
	}

	/**
	 * @메소드명 : sscAddTempInsert
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	WORK TBALE에 입력
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscWorkInsert(Map<String, Object> map) {
		selectOne("sscCommonList.procInsertSscWork", map);
	}
	
	/**
	 * @메소드명 : sscDeleteTempInsert
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	WORK TBALE에 입력
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscWorkDelete(Map<String, Object> map) {
		selectOne("sscCommonList.procDeleteSscWork", map);
	}

	/**
	 * @메소드명 : sscAddValidation
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Validation 로직 프로시저 태움
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscAddValidation(Map<String, Object> map) {
		selectOne("sscAdd.procActionSscAddValidation" + map.get("p_item_type_cd"), map);
	}

	/**
	 * @메소드명 : sscAddValidationList
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Validation 출력 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscWorkValidationList(Map<String, Object> map) {
		disSession.selectList("sscCommonList.sscWorkValidationList", map);
		return map;
	}

	/**
	 * @메소드명 : sscAddBackList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Add Back List
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscAddBackList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddBackList", map);
	}

	/**
	 * @메소드명 : sscAddItemCreateList
	 * @날짜 : 2016. 1. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Item 채번 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscAddItemCreateList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddItemCreateList", map);
	}

	/**
	 * @메소드명 : updateSscAddWorkItemCode
	 * @날짜 : 2016. 1. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	ITEM CODE 채번
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscAddWorkItemCode(Map<String, Object> map) {
		return update("sscAdd.updateSscAddWorkItemCode", map);
	}
	
	public int updateSscBuyBuyAddWorkItemCode(Map<String, Object> map) {
		return update("sscAdd.updateSscBuyBuyAddWorkItemCode", map);
	}
	
	public int updateSscMotherBuyAddWorkItemCode(Map<String, Object> map) {
		return update("sscAdd.updateSscMotherBuyAddWorkItemCode", map);
	}

	/**
	 * @메소드명 : updateSscWorkItemCodeValidation
	 * @날짜 : 2016. 3. 3.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Item Code, Mother Code 채번 이후 Validation
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscWorkItemCodeValidation(Map<String, Object> map) {
		return update("sscAdd.updateSscWorkItemCodeValidation", map);
	}

	/**
	 * @메소드명 : sscAddMotherCreateList
	 * @날짜 : 2016. 1. 6.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	MOTHER 채번 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscAddMotherCreateList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddMotherCreateList", map);
	}

	/**
	 * @메소드명 : sscAddMotherAttrDwg
	 * @날짜 : 2017. 9. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	해당 CATALOG 속성의 DWG항목 ATTR 넘버를 찾음
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String sscAddMotherAttrDwg(Map<String, Object> map) {
		return selectOne("sscAdd.sscAddMotherAttrDwg", map);
	}
	
	/**
	 * @메소드명 : sscPaintDwgNo
	 * @날짜 : 2016. 2. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Paint 기본 도면 번호
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String sscPaintDwgNo(Map<String, Object> map) {
		return selectOne("sscCommonList.sscPaintDwgNo", map);
	}

	/**
	 * @메소드명 : sscAddPendingMotherInsert
	 * @날짜 : 2016. 1. 6.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	펜딩 마더 입력 프로시저
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscAddPendingMotherInsert(Map<String, Object> map) {
		selectOne("sscAdd.procInsertPendingMother", map);
	}

	/**
	 * @메소드명 : updateSscAddWorkMotherCode
	 * @날짜 : 2016. 1. 6.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	MOTHER CODE WORK TABLE에 업데이트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscAddWorkMotherCode(Map<String, Object> map) {
		return update("sscAdd.updateSscAddWorkMotherCode", map);
	}

	/**
	 * @메소드명 : updateSscAddValveMotherBuyCode
	 * @날짜 : 2016. 3. 3.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	VALVE MOTHER BUY 일괄 업데이트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscAddValveMotherBuyCode(Map<String, Object> map) {
		return update("sscAdd.updateSscAddValveMotherBuyCode", map);
	}

	/**
	 * @메소드명 : sscAddHeadInsert
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Head 입력
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void procInsertSscAddHead(Map<String, Object> map) {
		selectOne("sscAdd.procInsertSscAddHead", map);
	}

	/**
	 * @메소드명 : procInsertSscAddRawLevel
	 * @날짜 : 2016. 3. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 */
	public void procInsertSscAddRawLevel(Map<String, Object> map) {
		selectOne("sscAdd.procInsertSscAddRawLevel", map);
	}

	/**
	 * @메소드명 : sscAddTribonMainList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 	SSC ADD Tribon Main List
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscAddTribonMainList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddTribonMainList", map);
	}

	/**
	 * @메소드명 : sscAddTribonTransferList
	 * @날짜 : 2016. 1. 12.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC ADD Tribon Transfer List
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscAddTribonTransferList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddTribonTransferList", map);
	}

	/**
	 * @메소드명 : sscAddEmsTransferList
	 * @날짜 : 2016. 3. 8.
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
	public List<Map<String, Object>> sscAddEmsTransferList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddEmsTransferList", map);
	}

	/**
	 * @메소드명 : sscAddEmsMainList
	 * @날짜 : 2016. 3. 7.
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
	public List<Map<String, Object>> sscAddEmsMainList(Map<String, Object> map) {
		return selectList("sscAdd.sscAddEmsMainList", map);
	}

	/**
	 * @메소드명 : sscChekedMainList
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Main 체크 된 ITEM 리스트
	 *	1. Modify Main에서 사용
	 *  2. Delete Main에서 사용
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscChekedMainList(Map<String, Object> map) {
		disSession.selectList("sscCommonList.sscCheckedMainList", map);
		return map;
	}

	/**
	 * @메소드명 : sscModifyHeadInsert
	 * @날짜 : 2016. 1. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Modify Apply
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscModifyApplyAction(Map<String, Object> map) {
		selectOne("sscModify.procModifyAction", map);
	}

	/**
	 * @메소드명 : sscModifyValidation
	 * @날짜 : 2016. 1. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Modify Validation 데이터 수행 로직
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscModifyValidation(Map<String, Object> map) {
		selectOne("sscModify.procModifyValidation", map);
	}

	/**
	 * @메소드명 : sscDeleteValidation
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Delete Validation 체크
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscDeleteValidation(Map<String, Object> map) {
		selectOne("sscDelete.procDeleteValidation", map);
	}

	/**
	 * @메소드명 : sscDeleteApplyAction
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Delete Apply
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscDeleteApplyAction(Map<String, Object> map) {
		selectOne("sscDelete.procDeleteAction", map);
	}

	/**
	 * @메소드명 : updateSscHeadEcoNo
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
	public int updateSscHeadEcoNo(Map<String, Object> map) {
		return update("sscBom.updateSscHeadEcoNo", map);
	}
	
	/**
	 * @메소드명 : sscRestoreAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Main Restore Action
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscRestoreAction(Map<String, Object> map) {
		selectOne("sscRestore.procRestoreAction", map);
	}
	
	/**
	 * @메소드명 : sscCancelAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Main Cancel Action
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public void sscCancelAction(Map<String, Object> map) {
		selectOne("sscCancel.procCancelAction", map);
	}

	/**
	 * @메소드명 : sscCableTypeList
	 * @날짜 : 2016. 2. 3.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC CABLE TYPE MAIN LIST
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscCableTypeMainList(Map<String, Object> map) {
		return selectList("sscCableType.sscCableTypeMainList", map);
	}

	/**
	 * @메소드명 : sscCableTypeSaveAction
	 * @날짜 : 2016. 2. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * Cable Type Save
	 *     </pre>
	 * 
	 * @param map
	 */
	public void sscCableTypeSaveAction(Map<String, Object> map) {
		selectOne("sscCableType.procCableTypeSaveAction", map);
	}

	/**
	 * @메소드명 : sscStructureList
	 * @날짜 : 2016. 2. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Outfitting Structure List
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscStructureList(Map<String, Object> map) {
		return selectList("sscStructure.sscStructureList", map);
	}

	/**
	 * @메소드명 : sscBuyBuyMotherItemDesc
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Item Code의 Descripton과 BuyBuy 등록 여부를 리턴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscBuyBuyMotherItemDesc(Map<String, Object> map) {
		return selectOne("sscBuyBuy.sscBuyBuyMotherItemDesc", map);
	}

	/**
	 * @메소드명 : sscEcoInfo
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *  ECO 정보 받아옴(영구/자정, 상태 등등)
	 *	1. SSC BOM 이행 시 사용
	 *  2. BuyBuy BOM 이행 시 사용
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscEcoInfo(Map<String, Object> map) {
		return selectOne("sscBom.sscEcoInfo", map);
	}
	
	/**
	 * @메소드명 : sscAllBomApplyAction
	 * @날짜 : 2016. 11. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ALL BOM Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscAllBomApplyAction(Map<String, Object> map) {
		return selectOne("sscAllBom.sscAllBomApplyAction", map);
	}

	/**
	 * @메소드명 : sscAfterInfoList
	 * @날짜 : 2016. 3. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	After Info
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> sscAfterInfoList(Map<String, Object> map) {
		return selectOne("sscAfterInfo.sscAfterInfoList", map);
	}

	/**
	 * @메소드명 : procSscSubAction
	 * @날짜 : 2016. 3. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC AFTERINFO SAVE ACTION
	 *     </pre>
	 * 
	 * @param map
	 */
	public void procSscSubAction(Map<String, Object> map) {
		selectOne("sscAfterInfo.procSscSubAction", map);
	}

	/**
	 * @메소드명 : updateSscBuyBuyAction
	 * @날짜 : 2016. 3. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Update SSC BuyBuy
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscAfteriofoBuyBuyAction(Map<String, Object> map) {
		return update("sscAfterInfo.updateSscAfteriofoBuyBuyAction", map);
	}

	/**
	 * @메소드명 : updateSscMainSave
	 * @날짜 : 2016. 3. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Main Save
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateSscMainSave(Map<String, Object> map) {
		return update("sscMainSave.updateSscMainSave", map);
	}

	/**
	 * @메소드명 : selectMainTotalList
	 * @날짜 : 2016. 11. 08.
	 * @작성자 : Cho HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC Main Total
	 *  리스트 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectMainTotalList(Map<String, Object> map) {
		disSession.selectList("sscMainTotalList.sscMainTotalList", map);
		return map;
	}

	public int getPrintSeqH(Map<String, Object> map) {
		return update("sscDwgPopupView.getPrintSeqH", map);
	}

	public int getPrintSeqD(Map<String, Object> map) {
		return update("sscDwgPopupView.getPrintSeqD", map);
		
	}

	public int getPrintSeq(Map<String, Object> map) {
		return update("sscDwgPopupView.getPrintSeq", map);
		
	}

	public List<Map<String, Object>> dwgPopupViewList(Map<String, Object> map) {
		return selectList("sscDwgPopupView.dwgPopupViewList", map);
	}

	public Map<String, Object> sscItemAddStageGetMother(Map<String, Object> map) {
		return selectOne("sscItemAddStage.getJobStatus", map);
	}
	
	public Map<String, Object> getCatalogDesign(Map<String, Object> map) {
		return selectOne("sscCommonList.getCatalogDesign", map);
	}
	
	public void sscTribonInterfaceDelete(Map<String, Object> map) {
		delete("sscDelete.sscTribonInterfaceDelete", map);
	}
	
	public void sscTribonInterfaceAttrDelete(Map<String, Object> map) {
		delete("sscDelete.sscTribonInterfaceAttrDelete", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainList
	 * @날짜 : 2017. 2. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> sscBuyBuyMainList(Map<String, Object> map) {
		disSession.selectList("sscBuyBuy.sscBuyBuyMainList", map);
		return map;
	}
	
	/**
	 * @메소드명 : getSscDescription
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 desc, project 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> getSscDescription(Map<String, Object> map) {
		return selectOne("sscBuyBuy.getSscDescription", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainDelete
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 리스트 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public void sscBuyBuyMainDelete(Map<String, Object> map) {
		delete("sscBuyBuy.sscBuyBuyMainDelete", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainRestore
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Restore
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public void sscBuyBuyMainRestore(Map<String, Object> map) {
		selectOne("sscBuyBuy.sscBuyBuyMainRestore", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainCancel
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Cancel
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public void sscBuyBuyMainCancel(Map<String, Object> map) {
		selectOne("sscBuyBuy.sscBuyBuyMainCancel", map);
	}
	
	/**
	 * @메소드명 : procBuyBuySaveAction
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	buybuy save
	 *     </pre>
	 * 
	 * @param map
	 */
	public void sscBuyBuyMainSave(Map<String, Object> map) {
		selectOne("sscBuyBuy.sscBuyBuyMainSave", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddNext
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	buybuy save
	 *     </pre>
	 * 
	 * @param map
	 */
	public Map<String, Object> sscBuyBuyAddValidation(Map<String, Object> map) {
		return selectOne("sscBuyBuy.sscBuyBuyAddValidation", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddList
	 * @날짜 : 2017. 02. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	NEXT 버튼 이후 리스트 받아옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscBuyBuyAddList(Map<String, Object> map) {
		return selectList("sscBuyBuy.sscBuyBuyAddList", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddBack
	 * @날짜 : 2017. 02. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BACK 버튼 이후 리스트 받아옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> sscBuyBuyAddBack(Map<String, Object> map) {
		return selectList("sscBuyBuy.sscBuyBuyAddBack", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddApply
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	buybuy save
	 *     </pre>
	 * 
	 * @param map
	 */
	public void sscBuyBuyAddApply(Map<String, Object> map) {
		selectOne("sscBuyBuy.sscBuyBuyAddApply", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyDwgNoList
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드 DWG NO.칼럼 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscBuyBuyDwgNoList(Map<String, Object> map) {
		return selectList("sscBuyBuy.sscBuyBuyDwgNoList", map);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddGetItemDesc.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD 그리드 내 ITEM DESC 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscBuyBuyAddGetItemDesc(Map<String, Object> map) {
		return selectOne("sscBuyBuy.sscBuyBuyAddGetItemDesc", map);
	}
	
	public int searchMarkNoItemCode(Map<String, Object> map) {
		return selectOne("sscAdd.searchMarkNoItemCode", map);
	}
	
	public Map<String, Object> getMarkNoItemCode(Map<String, Object> map) {
		return selectOne("sscAdd.getMarkNoItemCode", map);
	}
	
	/**
	 * @메소드명 : getDeliverySeries.do
	 * @날짜 : 2017. 3. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	해당 호선의 시리즈 중에서 Delivery 시리즈 리스트를 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getDeliverySeries(Map<String, Object> map) {
		return selectList("sscCommonList.getDeliverySeries", map);
	}
}
