package stxship.dis.system.contactUs.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("personInChargeDAO")
public class PersonInChargeDAO extends CommonDAO {
	public String insertGridData(Map<String, Object> rowData) {
		int insertResult = insert("ContactUs.insertContactUs", rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String updateGridData(Map<String, Object> rowData) {
		int updateResult = update("ContactUs.updateContactUs", rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String deleteGridData(Map<String, Object> rowData) {
		int deleteResult = delete("ContactUs.deleteContactUs", rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return (Integer) selectOne("ContactUs.duplicate", rowData);
	}

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		return selectList("ContactUs.list", map);
	}

	public Object getGridListSize(Map<String, Object> map) {
		return selectOne("ContactUs.selectTotalRecord", map);
	}
}
