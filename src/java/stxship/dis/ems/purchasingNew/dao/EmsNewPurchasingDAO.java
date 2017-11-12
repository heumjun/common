package stxship.dis.ems.purchasingNew.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("emsNewPurchasingDAO")
public class EmsNewPurchasingDAO extends CommonDAO {
	
	
	public List<Map<String, Object>> emsPurchasingSelectBoxDept(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.getSelectBoxDeptList", map);
	}
	
	public List<Map<String, Object>> emsPurchasingAddSelectBoxPjt(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.getSelectBoxPjtList", map);
	}
	
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxCauseDept(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.getSelectBoxCauseDeptList", map);
	}
	
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxPosType(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.getSelectBoxPosTypeList", map);
	}
	
	public String posSelectProjectId(Map<String, Object> map) {
		return selectOne("emsPurchasingNewMain.posSelectProjectId", map);
	}
	
	public String posSelectEquipName(Map<String, Object> map) {
		return selectOne("emsPurchasingNewMain.posSelectEquipName", map);
	}
	
	public Map<String, Object> posGetFileId(Map<String, Object> map) {
		return selectOneErp("emsPurchasingNewMain.posGetFileId", map);
	}

	public int posUploadFile(Map<String, Object> map) {
		return updateErp("emsPurchasingNewMain.posUploadFile", map);
	}
	
	public Map<String, Object> posInsertRow(Map<String, Object> map) {
		return selectOneErp("emsPurchasingNewMain.posInsertRow", map);
	}
	
	public Map<String, Object> posInsertSelectedFile(Map<String, Object> map) {
		return selectOneErp("emsPurchasingNewMain.posInsertSelectedFile", map);
	}

	public Map<String, Object> popUpPurchasingPosDownloadFile(Map<String, Object> map) {
		return selectOneErp("emsPurchasingNewMain.posDownloadFile", map);
	}

	public int emsPurchasingDeleteA(Map<String, Object> map) {
		return delete("emsPurchasingNewMain.deletePurchasingA", map);
	}

	
	/**
	 * 
	 * @메소드명	: emsPurchasingExcelExport
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	메인 엑셀/Add엑셀 출력
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> emsPurchasingExcelExport(Map<String, Object> map) {
		if("ADD".equals(map.get("type")))selectListErp("popUpPurchasingAddList.emsPurchasingAddFirstList", map);
		else selectListErp("emsPurchasingNewMain.emsPurchasingMainList", map);
		return map;
	}

	//신규 생성 2017-04 Start
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingMainList
	 * @날짜		: 2017. 3. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * EMS MainGrid Search
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPurchasingMainList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		selectListErp("emsPurchasingNewMain.emsPurchasingMainList", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: emsDwgNoList
	 * @날짜		: 2017. 4. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ems 도면 자동완성
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsDwgNoList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return selectList("emsPurchasingNewMain.emsDwgNoList", map);
	}
	
	/**
	 * 
	 * @메소드명	: selectEmsApprovedBoxDataList
	 * @날짜		: 2017. 4. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ems 승인자 목록
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectEmsApprovedBoxDataList(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.selectEmsApprovedBoxDataList", map);
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingReqCrtProc
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Purcharsing Request Create 
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingReqCrtProc(Map<String,Object> map){
		return insertErp("emsPurchasingNewMain.emsPurchasingReqCrtProc", map);
	}

	/**
	 * 
	 * @메소드명	: emsPurchasingInstProc
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Purcharsing Request Insert 
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingInstProc(Map<String,Object> map){
		return insertErp("emsPurchasingNewMain.emsPurchasingInstProc", map);
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingMailProc
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Purcharsing Request Mail Send
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingMailProc(Map<String,Object> map){
		return insertErp("emsPurchasingNewMain.emsPurchasingMailProc", map);
	}
	
	/**
	 * 
	 * @메소드명	: selectPosChk
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * POS전 검색 조건에서 project 및 dwg_no 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String,Object> selectPosChk(Map<String,Object> map) {
		// TODO Auto-generated method stub
		return selectOneErp("emsPurchasingNewMain.selectPosChk",map);
	}
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingPosList
	 * @날짜		: 2017. 4. 10.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	POS 팝업 목록 호출
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPurchasingPosList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewPosList.emsPurchasingPosList", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingInstPosDetailProc
	 * @날짜		: 2017. 4. 10.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * POS팝업 호출 시 디테일 삽입
	 * </pre>
	 * @param instMap
	 * @return
	 */
	public int emsPurchasingPosChkProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewPosList.emsPurchasingPosChkProc", map);
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingPosInsertProc
	 * @날짜		: 2017. 4. 11.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	POS 저장 로직 호출
	 * </pre>
	 * @param rowData
	 * @return
	 */
	public int emsPurchasingPosInsertProc(Map<String, Object> rowData) {
		// TODO Auto-generated method stub
		return  insertErp("popUpPurchasingNewPosList.emsPurchasingPosInsertProc", rowData);
	}
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingAddFisrtList
	 * @날짜		: 2017. 4. 13.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	EMS ADD MAIN First LIST
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPurchasingAddFisrtList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewAddList.emsPurchasingAddFirstList", map);
		return map;
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingAddTempInsertProc
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	purchasing add temp data insert
	 * </pre>
	 * @param rowData
	 * @return
	 */
	public int emsPurchasingAddTempInsertProc(Map<String, Object> rowData) {
		return insertErp("popUpPurchasingNewAddList.emsPurchasingAddTempInsertProc", rowData);
	}
	
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingAddSecondList
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	EMS ADD NEXT TEMP SELECT
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPurchasingAddSecondList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewAddList.emsPurchasingAddSecondList", map);
		return map;
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingAddTempDeleteProc
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *purchasing add temp data delete
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public int emsPurchasingAddTempDeleteProc(CommandMap commandMap) {
		return insertErp("popUpPurchasingNewAddList.emsPurchasingAddTempDeleteProc", commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingPosApplyProc
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * add apply
	 * </pre>
	 * @param rowData
	 * @return
	 */
	public int emsPurchasingPosApplyProc(Map<String, Object> rowData) {
		return insertErp("popUpPurchasingNewAddList.emsPurchasingPosApplyProc", rowData);
	}
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallTime
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 설치 시점
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingAddInstallTime(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.emsPurchasingInstallTime", map);
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallPosition
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 설치 위치
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingAddInstallLocation(Map<String, Object> map) {
		return selectList("emsPurchasingNewMain.emsPurchasingInstallLocation", map);
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingDelInstTempProc
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ems delete 항목 임시 테이블 insert
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingDelInstTempProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewDeleteList.emsPurchasingDelInstTempProc",map);
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingDelChkTempProc
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems delete before check
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingDelChkTempProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewDeleteList.emsPurchasingDelChkTempProc",map);
	}
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingDeleteList
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 삭제 목록
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPurchasingDeleteList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewDeleteList.emsPurchasingDeleteList", map);
		return map;
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingDeleteApply
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ems delete apply
	 * </pre>
	 * @param map
	 * @return
	 */
	public int emsPurchasingDeleteApply(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewDeleteList.emsPurchasingDeleteApply", map);
	}

	public int emsPurchasingModifyTempInstProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewModifyList.emsPurchasingModifyTempInstProc", map);
	}

	public Map<String, Object> selectEmsPurchasingModifyFirstList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewModifyList.selectEmsPurchasingModifyFirstList", map);
		return map;
	}

	public int emsPurchasingModifyTempDeleteProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewModifyList.emsPurchasingModifyTempDeleteProc", map);
	}

	public int emsPurchasingModifySecondTempInstProc(Map<String, Object> rowData) {
		return insertErp("popUpPurchasingNewModifyList.emsPurchasingModifySecondTempInstProc", rowData);
	}

	public Map<String, Object> selectEmsPurchasingModifySecondList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewModifyList.selectEmsPurchasingModifySecondList", map);
		return map;
	}
	
	public int emsPurchasingModifySecondChkProc(Map<String, Object> map) {
		return insertErp("popUpPurchasingNewModifyList.emsPurchasingModifySecondChkProc", map);
	}

	public int emsPurchasingPosModifyApplyProc(Map<String, Object> rowData) {
		return insertErp("popUpPurchasingNewModifyList.emsPurchasingPosModifyApplyProc", rowData);
	}

	public Map<String, Object> popUpPurchasingSpecList(Map<String, Object> map) {
		selectListErp("popUpPurchasingNewSpecList.selectPurchasingSpecList", map);
		return map;
	}

	public List<Map<String, Object>> selectEmsPurchasingSpecDownList(Map<String, Object> map) {
		return selectListErp("popUpPurchasingNewSpecList.selectEmsPurchasingSpecDownList", map);
	}

	public void emsPurchasingSpecApply(Map<String,Object> row) {
		insertErp("popUpPurchasingNewSpecList.emsPurchasingSpecApply", row);
	}
	
	//신규 생성 2017-04 END

	
	
}
