package stxship.dis.dps.progressInput.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;
import stxship.dis.dps.common.dao.DpsCommonDAO;

/**
 * @파일명 : ProgressInputDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ProgressInput에서 사용되는 DAO
 *     </pre>
 */
@Repository("progressInputDAO")
public class ProgressInputDAO extends DpsCommonDAO {

	public List<Map<String, Object>> getPLM_DATE_CHANGE_ABLE_DWG_TYPE() throws Exception{
		List<Object> listMap = selectListDps("progressInput.selectPLM_DATE_CHANGE_ABLE_DWG_TYPE");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object map : listMap){
			returnList.add((Map<String, Object>) map);
		}
		return returnList;
	}

	public void addPLM_DATE_CHANGE_ABLE_DWG_TYPE(Map param) throws Exception{
		insertDps("progressInput.insertPLM_DATE_CHANGE_ABLE_DWG_TYPE", param);
	}

	public void delPLM_DATE_CHANGE_ABLE_DWG_TYPE(Map<String, Object> map) throws Exception{
		deleteDps("progressInput.deletePLM_DATE_CHANGE_ABLE_DWG_TYPE", map);
	}

	public void setAbleChangeDPDateProject(Map<String, Object> param) throws Exception{
		List<Map<String,Object>> existCheck = selectListDps("progressProjectDateChange.selectExistsPlmAbleProject", param);
		
		if(existCheck.size() < 1){
			insertDps("progressProjectDateChange.insertPlmDateChangeAbleProject", param);
		}
	}

	public void setDisableChangeDPDateProject(Map<String, Object> param) throws Exception{
		deleteDps("progressProjectDateChange.deletePlmDateChangeAbleProject", param);
	}

	public List<Map<String, Object>> getChangableDateDPList(Map<String, Object> map)throws Exception {
		return selectListDps("progressInput.selectChangableDateDPList", map);
	}

	public List<Map<String, Object>> getDpsProgressInputSearchList(CommandMap commandMap) throws Exception{
		return selectListDps("progressInputMain.selectDpsProgressInputSearchList", commandMap.getMap());
	}
	
}
