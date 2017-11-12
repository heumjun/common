package stxship.dis.bom.unit.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("unitDAO")
public class UnitDAO extends CommonDAO {

	public List<Map<String, Object>> unitMainList(Map<String, Object> map) {
		return selectList("sscMainList" + map.get("p_item_type_cd") + ".sscMainList", map);
	}

}
