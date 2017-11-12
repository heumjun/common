package stxship.dis.system.notice.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("noticeDAO")
public class NoticeDAO extends CommonDAO {

	public int updateReadCount(Map<String, Object> rowData) {
		return update("saveNotice.updateReadCount", rowData);
	}

	public int getDuplicationCnt(Map<String, Object> rowData) {
		return selectOne("Notice.duplicate", rowData);
	}
	
	public void updateNoticeInfo(CommandMap commandMap) {
		update("saveNotice.insertFileInfo", commandMap.getMap());
	}

	public Map<String, Object> noticeFileDownload(CommandMap commandMap) {
		return selectOne("saveNotice.noticeFileDownload", commandMap.getMap());
	}

	public void insertNoticeInfo(CommandMap commandMap) {
		insert("saveNotice.insert" , commandMap.getMap());
		
	}
}
