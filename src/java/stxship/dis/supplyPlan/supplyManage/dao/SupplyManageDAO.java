package stxship.dis.supplyPlan.supplyManage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("supplyManageDAO")
public class SupplyManageDAO extends CommonDAO {
	
	public Map<String, Object> supplyManageLoginGubun(Map<String, Object> map) {
		return selectOne("supplyManageList.loginGubun", map);
	}
	
	public String getCreateSupplyId(Map<String, Object> map) {
		return selectOne("saveSupplyList.createSupplyId", map);
	}
	
	public int insertManage(Map<String, Object> map) {
		return insert("saveSupplyList.insertManage", map);
	}
	
	public int updateManage(Map<String, Object> map) {
		return update("saveSupplyList.updateManage", map);
	}
	
	public int deleteManage(Map<String, Object> map) {
		return delete("saveSupplyList.deleteManage", map);
	}
	
	public int deleteManageDwg(Map<String, Object> map) {
		return delete("saveSupplyList.deleteManageDwg", map);
	}
	
	public int deleteManageCatalog(Map<String, Object> map) {
		return delete("saveSupplyList.deleteManageCatalog", map);
	}
	
	public int insertDwg(Map<String, Object> map) {
		return insert("saveSupplyList.insertDwg", map);
	}
	
	public int updateDwg(Map<String, Object> map) {
		return update("saveSupplyList.updateDwg", map);
	}
	
	public int deleteDwg(Map<String, Object> map) {
		return delete("saveSupplyList.deleteDwg", map);
	}
	
	public int insertCatalog(Map<String, Object> map) {
		return insert("saveSupplyList.insertCatalog", map);
	}
	
	public int updateCatalog(Map<String, Object> map) {
		return update("saveSupplyList.updateCatalog", map);
	}
	
	public int deleteCatalog(Map<String, Object> map) {
		return delete("saveSupplyList.deleteCatalog", map);
	}
	
	public List<Map<String, Object>> selectSupplyIdList(Map<String, Object> map) {
		return selectList("supplyManageExcelExport.selectSupplyIdList", map);
	}
	
	public List<Map<String, Object>> selectSupplyManage(Map<String, Object> map) {
		return selectList("supplyManageExcelExport.selectSupplyManage", map);
	}
	
	public List<Map<String, Object>> selectSupplyType(Map<String, Object> map) {
		return selectList("supplyManageExcelExport.selectSupplyType", map);
	}
	
	public List<Map<String, Object>> selectSupplyCatalog(Map<String, Object> map) {
		return selectList("supplyManageExcelExport.selectSupplyCatalog", map);
	}
}
