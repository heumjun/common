package stxship.dis.bom.bom.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("bomDAO")
public class BomDAO extends CommonDAO {
	public List<Map<String, Object>> selectitemExcelExportList(Map<String, Object> map) {
		return selectList("bomList.list",map);
	}
}
