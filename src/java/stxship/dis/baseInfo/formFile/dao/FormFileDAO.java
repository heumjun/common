package stxship.dis.baseInfo.formFile.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : FormFileDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * FormFile에서 사용되는 DAO
 *     </pre>
 */
@Repository("formFileDAO")
public class FormFileDAO extends CommonDAO {
	public Map<String, Object> getUploadedFormFile(Map<String, Object> map) {
		return selectOne("FormFile.getUploadedFormFile", map);
	}
}
