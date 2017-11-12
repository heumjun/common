package stxship.dis.testSource.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("testSourceDAO")
public class TestSourceDAO extends CommonDAO {

	public Object saveGridListAction(Map<String, Object> map) {
		return selectOne("saveTestSource.saveProject", map);
	}

}
