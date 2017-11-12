package stxship.dis.paint.usc.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintUscDAO")
public class PaintUscDAO extends CommonDAO {

	public void insertPaintWbsReCreate(Map<String, Object> pkgParam) {
		selectOne("savePaintUsc.insertPaintWbsReCreate", pkgParam);
	}

	public void deletePaintUscJobItem(Map<String, Object> pkgParam) {
		selectOne("savePaintUsc.deletePaintUscJobItem", pkgParam);
	}

	public void insertPaintUscJobItemAdd(Map<String, Object> pkgParam1) {
		selectOne("savePaintUsc.insertPaintUscJobItemAdd", pkgParam1);
	}

	public void insertPaintUscJobMotherCheck(Map<String, Object> pkgParam2) {
		selectOne("savePaintUsc.insertPaintUscJobMotherCheck", pkgParam2);
	}

	public void savePaintUscBom(Map<String, Object> pkgParam1) {
		selectOne("savePaintUsc.savePaintUscBom", pkgParam1);
	}

	public void savePaintWbsEcoAdd(Map<String, Object> pkgParam) {
		selectOne("savePaintUsc.savePaintWbsEcoAdd", pkgParam);
	}

}
