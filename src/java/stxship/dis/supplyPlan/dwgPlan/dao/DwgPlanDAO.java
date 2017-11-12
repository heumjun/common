package stxship.dis.supplyPlan.dwgPlan.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("dwgPlanDAO")
public class DwgPlanDAO extends CommonDAO {
	
	public int insertPlanTemp(Map<String, Object> map) {
		return insert("dwgPlanList.insertPlanTemp", map);
	}
	
	public int deletePlanTemp(Map<String, Object> map) {
		return delete("dwgPlanList.deletePlanTemp", map);
	}
	
	public List<Map<String, Object>> selectPlanTemp(Map<String, Object> map) {
		return selectList("dwgPlanList.list", map);
	}
	
	public String countDwgPlan(Map<String, Object> map) {
		return selectOne("saveDwgPlanList.countDwgPlan", map);
	}
	
	public int insertDwgPlan(Map<String, Object> map) {
		return insert("saveDwgPlanList.insertDwgPlan", map);
	}
	
	public int insertDwgPlanResult(Map<String, Object> map) {
		return insert("saveDwgPlanList.insertDwgPlanResult", map);
	}
	
	public int updateDwgPlan(Map<String, Object> map) {
		return update("saveDwgPlanList.updateDwgPlan", map);
	}
	
	public int updateDwgPlanResult(Map<String, Object> map) {
		return update("saveDwgPlanList.updateDwgPlanResult", map);
	}
	
	public Map<String, Object> popUpDwgPlanReasonDetail(Map<String, Object> map) {
		return selectOne("popUpDwgPlanReason.reasonDetail", map);
	}
	
	public Map<String, Object> popUpDwgPlanReasonDetail2(Map<String, Object> map) {
		return selectOne("popUpDwgPlanReason.reasonDetail2", map);
	}
	
	public Map<String, Object> popUpDwgPlanReasonAlreadyKey(Map<String, Object> map) {
		return selectOne("popUpDwgPlanReason.reasonAlreadyKey", map);
	}
	
	public int popUpDwgPlanReasonInsert(Map<String, Object> map) {
		return insert("popUpDwgPlanReason.reasonInsert", map);
	}
	
	public int popUpDwgPlanReasonUpdate(Map<String, Object> map) {
		return update("popUpDwgPlanReason.reasonUpdate", map);
	}
	
	public int popUpDwgPlanReasonDelete(Map<String, Object> map) {
		return delete("popUpDwgPlanReason.reasonDelete", map);
	}
	
	public Map<String, Object> downloadReasonFile(Map<String, Object> map) {
		return selectOne("reasonFile.downloadReasonFile", map);
	}


}
