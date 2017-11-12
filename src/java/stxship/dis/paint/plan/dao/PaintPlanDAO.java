package stxship.dis.paint.plan.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintPlanDAO")
public class PaintPlanDAO extends CommonDAO {
	public void savePlanRevAdd(Map<String, Object> pkgParam) {
		selectOne("paint_plan_rev_add.savePlanRevAdd", pkgParam);
	}
	
	public void savePlanProjectAdd(Map<String, Object> pkgParam) {
		selectOne("paint_plan_rev_add.savePlanProjectAdd", pkgParam);
	}
}
