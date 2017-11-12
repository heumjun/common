package stxship.dis.ems.adminNew.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("emsNewAdminDAO")
public class EmsNewAdminDAO extends CommonDAO {
	
	//신규 생성 2017-04 Start
	/**
	 * 
	 * @메소드명	: selectEmsAdminMainList
	 * @날짜		: 2017. 3. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * EMS MainGrid Search
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsAdminMainList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		selectListErp("emsAdminNewMain.emsAdminMainList", map);
		return map;
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
		return selectList("emsAdminNewMain.selectEmsApprovedBoxDataList", map);
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
		return selectList("emsAdminNewMain.emsDwgNoList", map);
	}
	/**
	 * 
	 * @메소드명	: popUpAdminPosDownloadFile
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 파일 정보 및 데이터 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> popUpAdminPosDownloadFile(Map<String, Object> map) {
		return selectOneErp("emsAdminNewMain.posDownloadFile", map);
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
		return selectOneErp("emsAdminNewMain.selectPosChk",map);
	}
	
	
	public Map<String, Object> popUpAdminNewSpecList(Map<String, Object> map) {
		selectListErp("popUpAdminNewSpecList.selectAdminSpecList", map);
		return map;
	}
	
	public List<Map<String, Object>> selectEmsAdminSpecDownList(Map<String, Object> map) {
		return selectListErp("popUpAdminNewSpecList.selectEmsAdminSpecDownList", map);
	}

	public int emsAdminDeleteTempProc(CommandMap commandMap) {
		return insertErp("emsAdminNewMain.emsAdminDeleteTempProc", commandMap.getMap());
	}

	public int emsAdminInsertTempProc(Map<String, Object> rowData) {
		return insertErp("emsAdminNewMain.emsAdminInsertTempProc", rowData);
	}

	public int emsAdminConfrimNReturnProc(CommandMap commandMap) {
		return insertErp("emsAdminNewMain.emsAdminConfrimNReturnProc", commandMap.getMap());
	}
}
