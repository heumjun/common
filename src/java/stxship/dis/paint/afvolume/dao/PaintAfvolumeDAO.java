package stxship.dis.paint.afvolume.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintAfvolumeDAO")
public class PaintAfvolumeDAO extends CommonDAO {

	public int insertAFVolume(Map<String, Object> map) {
		return update("savePaintAfvolume.insertAFVolume", map);
	}

}
