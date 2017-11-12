package stxship.dis.dps.dwgRegister.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.dao.DpsCommonDAO;

@Repository("dwgRegisterDAO")
public class DwgRegisterDAO  extends DpsCommonDAO{

	/**
	 * 
	 * @메소드명	: getAllProjectList
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 전체 호선 목록을 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,Object>> getAllProjectList() throws Exception{
		List<Object> projectList = selectListDps("dwgRegisterCommon.selectAllProjectList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : projectList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	
	
	
	
	
	/**
	 * 
	 * @메소드명	: getDeployReasonCodeList
	 * @날짜		: 2016. 8. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연코드 리스 목록 출력
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getDeployReasonCodeList()  throws Exception{
		List<Object> reasonCode = selectListDps("dwgRegisterCommon.selectDeployReasonCodeList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : reasonCode){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	
	/**
	 * 
	 * @메소드명	: getDeployNoPrefix
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 배포NO, 자동 채번 앞자리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getDeployNoPrefix(Map<String, Object> param) throws Exception{
		return selectOneDps("dwgRegisterCommon.selectDeployNoPrefix", param);
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingListForWork2
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선에 해당하는 도면들 목록을 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getDrawingListForWork2(HashMap<String, Object> param) throws Exception{
		return selectListDps("dwgRegisterCommon.selectDrawingListForWork2", param);
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingListForWork3
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선 + 도면에 해당하는 도면정보를 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getDrawingListForWork3(HashMap<String, Object> param) throws Exception{
		return selectOneDps("dwgRegisterCommon.selectDrawingListForWork3", param);
	}
	
	/**
	 * 
	 * @메소드명	: getDeployNoPostFix
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *배포NO, 자동 채번 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String getDeployNoPostFix(CommandMap commandMap) throws Exception{
		return selectOneDps("popUpHardCopyDwgCreateGridSave.selectDeployNoPostFix", commandMap.getMap());
	}
	
}
