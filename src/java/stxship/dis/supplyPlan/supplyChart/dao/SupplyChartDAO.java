package stxship.dis.supplyPlan.supplyChart.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import stxship.dis.common.dao.CommonDAO;

@Repository("supplyChartDAO")
public class SupplyChartDAO extends CommonDAO {

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	public void supplyChartSaveAction(Map<String, Object> map) {
		selectOne("supplyChartSaveAction.supplyChartSaveAction", map);
	}
	
	/** 
	 * @메소드명	: supplyChartList
	 * @날짜		: 2016. 10. 26.
	 * @작성자	: 조흠준
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> supplyChartList(Map<String, Object> map) {
		disSession.selectList("supplyChartList.list", map);
		return map;
	}
	
}
