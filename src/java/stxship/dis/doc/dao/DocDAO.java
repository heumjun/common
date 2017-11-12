package stxship.dis.doc.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("docDAO")
public class DocDAO extends CommonDAO {

	public int saveDocFileAdd(Map<String, Object> param) {
		return insert("saveDoc.saveDocFileAdd", param);
	}

	public int deleteFileAdd(Map<String, Object> rowData) {
		return delete("saveDoc.deleteFileAdd", rowData);
	}

	public Map<String, Object> getUploadedFileForDoc(Map<String, Object> map) {
		return selectOne("downLoadDoc.getUploadedFileForDoc", map);
	}

}
