package stxship.dis.etc.documentView.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : DocumentViewDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 8. 31.
 * @작성자 : 정재동
 * @설명
 * 
 * 	<pre>
 * DocumentView에서 사용되는 DAO
 *     </pre>
 */
@Repository("documentViewDAO")
public class DocumentViewDAO extends CommonDAO {

	public List<Map<String, Object>> selectDocumentView(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("documentView.selectDocumentView",commandMap.getMap());
	}

	public Map<String, Object> documentFileDownload(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("documentView.documentFileDownload",commandMap.getMap());
	}

	public String getFileIdSeq(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("documentView.getFileIdSeq",commandMap.getMap());
	}

	public String getDocumenIdSeq(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("documentView.getDocumenIdSeq",commandMap.getMap());
	}

	public String getAttachedDocumenIdSeq(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("documentView.getAttachedDocumenIdSeq",commandMap.getMap());
	}

	public void insertFileInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		insertErp("documentView.insertFileInfo", commandMap.getMap());
	}

	public String getUpdatePersonId(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectOneErp("documentView.getUpdatePersonId",commandMap.getMap());
	}

	public void insertDocumentInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		insertErp("documentView.insertDocumentInfo", commandMap.getMap());
	}

	public void insertAttachedDocumentInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		insertErp("documentView.insertAttachedDocumentInfo_KO", commandMap.getMap());
		insertErp("documentView.insertAttachedDocumentInfo_US", commandMap.getMap());
	}

	public void insertAttachedDocumentLinkInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		insertErp("documentView.insertAttachedDocumentLinkInfo", commandMap.getMap());
	}

	public void insertDocumentListMgtInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		insertErp("documentView.insertDocumentListMgtInfo", commandMap.getMap());
	}

	public void updateDocumentFile(CommandMap commandMap) {
		// TODO Auto-generated method stub
		updateErp("documentView.updateDocumentFile", commandMap.getMap());
	}

	


}
