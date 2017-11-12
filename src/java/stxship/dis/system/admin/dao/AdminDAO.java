package stxship.dis.system.admin.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("adminDAO")
public class AdminDAO extends CommonDAO {

	public String insertGridData(Map<String, Object> rowData) {
		int insertResult = insert("Admin.insertAdmin", rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String updateGridData(Map<String, Object> rowData) {
		int updateResult = update("Admin.updateAdmin", rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String deleteGridData(Map<String, Object> rowData) {
		int deleteResult = delete("Admin.deleteAdmin", rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return (Integer) selectOne("Admin.duplicate", rowData);
	}

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		return selectList("Admin.list", map);
	}

	public Object getGridListSize(Map<String, Object> map) {
		return selectOne("Admin.selectTotalRecord", map);
	}
}
