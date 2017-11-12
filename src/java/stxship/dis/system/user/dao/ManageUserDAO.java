package stxship.dis.system.user.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("manageUserDAO")
public class ManageUserDAO extends CommonDAO {

	public String insertGridData(Map<String, Object> rowData) {
		int insertResult = insert("ManageUser.insertManageUser", rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String updateGridData(Map<String, Object> rowData) {
		int updateResult = update("ManageUser.updateManageUser", rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String deleteGridData(Map<String, Object> rowData) {
		int deleteResult = delete("ManageUser.deleteManageUser", rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return (Integer) selectOne("ManageUser.duplicate", rowData);
	}

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		return selectList("ManageUser.list", map);
	}

	public Object getGridListSize(Map<String, Object> map) {
		return selectOne("ManageUser.selectTotalRecord", map);
	}

}
