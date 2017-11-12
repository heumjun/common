package stxship.dis.system.manual.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("manualDAO")
public class ManualDAO extends CommonDAO {
	public String insertGridData(Map<String, Object> rowData) {
		int insertResult = insert("Manual.insertProgram", rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String updateGridData(Map<String, Object> rowData) {
		int updateResult = update("Manual.updateProgram", rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public String deleteGridData(Map<String, Object> rowData) {
		int deleteResult = delete("Manual.deleteProgram", rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return (Integer) selectOne("Manual.duplicate", rowData);
	}

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		return selectList("Manual.list", map);
	}

	public Object getGridListSize(Map<String, Object> map) {
		return selectOne("Manual.selectTotalRecord", map);
	}

	public Map<String, Object> manualFileDownload(CommandMap commandMap) {
		return selectOne("manualDetailList.manualFileDownload",commandMap.getMap());
	}

	public void insertManualInfo(CommandMap commandMap) {
		insert("saveManual.insertFileInfo", commandMap.getMap());
	}

	public String manualFileDelete(Map<String, Object> map) {
		
		int deleteResult = delete("saveManual.fileDelete", map);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}
