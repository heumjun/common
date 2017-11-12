package stxship.dis.baseInfo.partFamilyType.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : PartFamilyTypeDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Part Family Type 메뉴 선택시 사용되는 DAO
 *     </pre>
 */
@Repository("partFamilyTypeDAO")
public class PartFamilyTypeDAO extends CommonDAO {

	public int deleteItemValueRule(Map<String, Object> itemValue) {
		return delete("savePartFamilyType.deleteItemValueRule", itemValue);
	}

	public int insertItemValueRule(Map<String, Object> itemValue) {
		return insert("savePartFamilyType.insertItemValueRule", itemValue);
	}

}
