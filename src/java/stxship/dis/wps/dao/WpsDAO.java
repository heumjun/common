package stxship.dis.wps.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * 
 * @파일명		: WpsDAO.java 
 * @프로젝트	: DIMS
 * @날짜		: 2017. 10. 11. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Repository("WpsDAO")
public class WpsDAO extends CommonDAO {

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	@Autowired
	private SqlSessionTemplate erpSession;

	public List<Map<String, Object>> wpsCodeTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsCodeTypeSelectBoxDataList", map);
	}
	
	public List<Map<String, Object>> wpsCodeTypeSelectBoxGridList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsCodeTypeSelectBoxGridList", map);
	}

	public Map<String, Object> wpsCodeManageList(Map<String, Object> map) {
		disSession.selectList("wpsCodeManage.wpsCodeManageList", map);
		return map;
	}
	
	public void saveWpsCodeManage(Map<String, Object> map) {
		selectOne("wpsCodeManage.saveWpsCodeManage", map);
	}

	public List<Map<String, Object>> wpsPlateTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsPlateTypeSelectBoxDataList", map);
	}

	public List<Map<String, Object>> wpsProcessTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsProcessTypeSelectBoxDataList", map);
	}
	
	public List<Map<String, Object>> wpsTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsTypeSelectBoxDataList", map);
	}
	
	public Map<String, Object> wpsManageList(Map<String, Object> map) {
		disSession.selectList("wpsManage.wpsManageList", map);
		return map;
	}

	public Map<String, Object> wpsPositionCodeList(Map<String, Object> map) {
		disSession.selectList("wpsManage.wpsPositionCodeList", map);
		return map;
	}

	public Map<String, Object> wpsApprovalCodeList(Map<String, Object> map) {
		disSession.selectList("wpsManage.wpsApprovalCodeList", map);
		return map;
	}

	public Map<String, Object> wpsMetalCodeList(Map<String, Object> map) {
		disSession.selectList("wpsManage.wpsMetalCodeList", map);
		return map;
	}

	public List<Map<String, Object>> wpsProcessTypeSelectBoxGridList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsProcessTypeSelectBoxGridList", map);
	}
	
	public List<Map<String, Object>> wpsTypeSelectBoxGridList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsTypeSelectBoxGridList", map);
	}

	public List<Map<String, Object>> wpsPlateTypeSelectBoxGridList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsPlateTypeSelectBoxGridList", map);
	}

	public List<Map<String, Object>> getWpsServerInfoList() {
		return selectList("wpsCommon.selectWpsServerInfoList", null);
	}

	public void insertWpsManageMaster(Map<String, Object> map) {
		selectOne("wpsManage.insertWpsManageMaster", map);
	}

	public void wpsMasterSaveAction(Map<String, Object> map) {
		selectOne("wpsManage.wpsMasterSaveAction", map);
	}

	public void wpsPositionSaveAction(Map<String, Object> map) {
		selectOne("wpsManage.wpsPositionSaveAction", map);
	}

	public void wpsApprovalSaveAction(Map<String, Object> map) {
		selectOne("wpsManage.wpsApprovalSaveAction", map);
	}

	public void wpsMetalSaveAction(Map<String, Object> map) {
		selectOne("wpsManage.wpsMetalSaveAction", map);
	}

	public Map<String, Object> wpsConfirmList(Map<String, Object> map) {
		disSession.selectList("wpsConfirm.wpsConfirmList", map);
		return map;
	}

	public List<Map<String, Object>> wpsApprovalClassTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsApprovalClassTypeSelectBoxDataList", map);
	}

	public List<Map<String, Object>> wpsPositionTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsPositionTypeSelectBoxDataList", map);
	}

	public List<Map<String, Object>> wpsBaseMetalTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsBaseMetalTypeSelectBoxDataList", map);
	}

	public void saveWpsConfirmAction(Map<String, Object> map) {
		selectOne("wpsConfirm.saveWpsConfirmAction", map);
	}

	public Map<String, Object> wpsChangeList(Map<String, Object> map) {
		disSession.selectList("wpsChange.wpsChangeList", map);
		return map;
	}

	public List<Map<String, Object>> wpsChangeTypeSelectBoxDataList(Map<String, Object> map) {
		return selectList("wpsCommon.wpsChangeTypeSelectBoxDataList", map);
	}

}
