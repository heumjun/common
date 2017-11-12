package stxship.dis.paint.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintCommonDAO")
public class PaintCommonDAO extends CommonDAO {

	public Map<String, Object> selectPaintPlanProjectNoCheck(Map<String, Object> map) {
		return selectOne("paintPlanProjectNoCheck.selectPaintPlanProjectNoCheck", map);
	}

	public List<Map<String, Object>> selectPaintCodeList(Map<String, Object> map) {
		return selectList("searchSelectBoxList.selectPaintCodeList", map);
	}

	public Map<String, Object> selectPaintNewRuleFlag(Map<String, Object> map) {
		return selectOne("selectPaintNewRuleFlag.selectPaintNewRuleFlag", map);
	}

}
