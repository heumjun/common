package stxship.dis.etc.itemStandardView.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : ItemStandardViewDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemStandardView에서 사용되는 DAO
 *     </pre>
 */
@Repository("itemStandardViewDAO")
public class ItemStandardViewDAO extends CommonDAO {

	public List<Map<String, Object>> selectItemStandardViewLevel1(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemStandardView.selectItemStandardViewLevel1",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemStandardViewLevel2(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemStandardView.selectItemStandardViewLevel2",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemStandardViewLevel3(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemStandardView.selectItemStandardViewLevel3",commandMap.getMap());
	}

	public List<Map<String, Object>> itemStandardViewSearch(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemStandardView.itemStandardViewSearch",commandMap.getMap());
	}

}
