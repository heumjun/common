package stxship.dis.ems.dbMaster.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.ems.common.dao.EmsCommonDAO;

@Repository("emsDbMasterDAO")
public class EmsDbMasterDAO extends EmsCommonDAO {
	
	public Map<String, Object> emsDbMasterLoginGubun(Map<String, Object> map) {
		return selectOneErp("emsDbMasterList.loginGubun", map);
	}

	public List<Map<String, Object>> emsDbMasterExcelExport(Map<String, Object> map) {
		return selectListErp("emsDbMasterList.list", map);
	}

	public int popUpEmsDbMasterItemApproveModFlag(Map<String, Object> rowData) {
		return updateErp("popUpEmsDbMasterItemApprove.modFlag", rowData);
	}

	public Map<String, Object> popUpEmsDbMasterItemApproveCreateItemList(String vItemCode) {
		return selectOneErp("popUpEmsDbMasterItemApprove.createItemList", vItemCode);
	}

	public Map<String, Object> popUpEmsDbMasterItemApproveCreateItemInsert(Map<String, Object> rowData) {
		return selectOneErp("popUpEmsDbMasterItemApprove.createItemInsert", rowData);
	}

	public int popUpEmsDbMasterItemApproveDelItem(Map<String, Object> rowData) {
		return deleteErp("popUpEmsDbMasterItemApprove.delItem", rowData);
	}

	public int popUpEmsDbMasterItemApproveDelSpec(Map<String, Object> rowData) {
		return deleteErp("popUpEmsDbMasterItemApprove.delSpec", rowData);
	}

	public int popUpEmsDbMasterItemApproveDelMaster(Map<String, Object> rowData) {
		return deleteErp("popUpEmsDbMasterItemApprove.delMaster", rowData);
	}

	public int popUpEmsDbMasterItemSavePlan(Map<String, Object> map) {
		return updateErp("popUpEmsDbMasterItemSave.modPlanItem", map);
	}

	public int popUpEmsDbMasterItemSaveObtain(Map<String, Object> map) {
		return updateErp("popUpEmsDbMasterItemSave.modObtainItem", map);
	}

	public Map<String, Object> popUpEmsDbMasterAddGetCatalogName(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getCatalogName", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterAddItemLastNum(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.addItemLastCode", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterAddSpecLastNum(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.addSpecLastCode", map);
	}

	public int popUpEmsDbMasterItemInsertItem(Map<String, Object> map) {
		return insertErp("popUpEmsDbMasterAdd.insertItem", map);
	}
	
	public int popUpEmsDbMasterItemInsertSpec(Map<String, Object> map) {
		return insertErp("popUpEmsDbMasterAdd.insertSpec", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterItemGetEquipment(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getEquipment", map);
	}

	public Map<String, Object> popUpEmsDbMasterItemGetMiddle(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getMiddle", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterItemGetDwg(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getDwg", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterItemGetObtainLt(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getObtainLt", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterItemGetObtApprover(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getObtApprover", map);
	}
	
	public Map<String, Object> popUpEmsDbMasterItemGetDwgApprover(Map<String, Object> map) {
		return selectOneErp("popUpEmsDbMasterAdd.getDwgApprover", map);
	}
	
	public int popUpEmsDbMasterItemInsertMaster(Map<String, Object> map) {
		return insertErp("popUpEmsDbMasterAdd.insertMaster", map);
	}

	public int popUpEmsDbMasterShipAppSave(Map<String, Object> map) {
		return insertErp("popUpEmsDbMasterShipApp.updateShipApp", map);
	}

	public int popUpEmsDbMasterShipDpDel() {
		return deleteErp("popUpEmsDbMasterShipDp.deleteShipDp", "");
	}
	
	public int popUpEmsDbMasterShipDpSave(Map<String, Object> map) {
		return insertErp("popUpEmsDbMasterShipDp.insertShipDp", map);
	}
	
	public int insertManager(Map<String, Object> map) {
		return insertErp("saveEmsDbMaster.insertManager", map);
	}
	
	public int deleteManager(Map<String, Object> map) {
		return deleteErp("saveEmsDbMaster.deleteManager", map);
	}

}
