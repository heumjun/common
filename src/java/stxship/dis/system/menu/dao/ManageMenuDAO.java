package stxship.dis.system.menu.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("manageMenuDAO")
public class ManageMenuDAO extends CommonDAO {

	public List<Map<String, Object>> getNoticeMainList(Map<String, Object> map) {
		return selectList("noticeList.list", map);
	}

	public List<Map<String, Object>> getApproveCntList(Map<String, Object> map) {
		return selectList("Common.approveCntList", map);
	}

	public List<Map<String, Object>> getTreeMenuList(Map<String, Object> map) {
		return selectList("ManageMenu.treeMenuListByRole", map);
	}

	public String insertGridData(Map<String, Object> rowData) {
		int insertResult = insert("ManageMenu.insertManageMenu", rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String updateGridData(Map<String, Object> rowData) {
		int updateResult = update("ManageMenu.updateManageMenu", rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String deleteGridData(Map<String, Object> rowData) {
		int deleteResult = delete("ManageMenu.deleteManageMenu", rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return (Integer) selectOne("ManageMenu.duplicate", rowData);
	}

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		return selectList("ManageMenu.menuList", map);
	}

	public Object getGridListSize(Map<String, Object> map) {
		return selectOne("ManageMenu.selectTotalRecord", map);
	}
	
	public List<Map<String, Object>> getBookmarkList(Map<String, Object> map) {
		return selectList("ManageMenu.getBookmarkList", map);
	}
	
	public List<Map<String, Object>> getUserBookmarkList(Map<String, Object> map) {
		return selectList("ManageMenu.getUserBookmarkList", map);
	}
	
	public Map<String, Object> getMenuId(Map<String, Object> map) {
		return selectOne("ManageMenu.menuId", map);
	}
}
