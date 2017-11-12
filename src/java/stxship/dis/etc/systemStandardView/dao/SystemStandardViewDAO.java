package stxship.dis.etc.systemStandardView.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * 
 * @파일명	: SystemStandardViewDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 9. 8. 
 * @작성자	: 정재동 
 * @설명
 * <pre>
 * 	SystemStandardView에서 사용되는 DAO
 * </pre>
 */
@Repository("systemStandardViewDAO")
public class SystemStandardViewDAO extends CommonDAO {

	public List<Map<String, Object>> systemStandardViewList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return selectListErp("systemStandardView.systemStandardViewList", map);
	}

	public List<Map<String, Object>> systemStandardViewFileList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return selectListErp("systemStandardView.systemStandardViewFileList", map);
	}

	public int saveSystemStandardView(Map<String, Object> rowData) {
		// TODO Auto-generated method stub
		return insertErp("systemStandardView.saveSystemStandardView", rowData);
	}

	public int saveSystemStandardFile(Map<String, Object> rowData) {
		// TODO Auto-generated method stub
		return deleteErp("systemStandardView.saveSystemStandardFile", rowData);
	}

	public Map<String, Object> systemStandardFileDownload(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("systemStandardView.systemStandardFileDownload",commandMap.getMap());
	}

	

}
