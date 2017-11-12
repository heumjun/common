package stxship.dis.etc.itemStandardView.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.etc.itemStandardView.dao.ItemStandardViewDAO;

/**
 * @파일명 : ItemStandardViewServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemStandardView에서 사용되는 서비스
 *     </pre>
 */
@Service("itemStandardViewService")
public class ItemStandardViewServiceImpl extends CommonServiceImpl implements ItemStandardViewService {

	@Resource(name = "itemStandardViewDAO")
	private ItemStandardViewDAO itemStandardViewDAO;

	/**
	 * 
	 * @메소드명	: selectItemStandardViewLevel1
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 부품표준서 대분류 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemStandardViewLevel1(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return itemStandardViewDAO.selectItemStandardViewLevel1(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemStandardViewLevel2
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 부품표준서 중분류 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemStandardViewLevel2(CommandMap commandMap) {
		// TODO Auto-generated method stub
		
		if( "".equals(commandMap.get("catalog_L")) || commandMap.get("catalog_L") == null){
			commandMap.put("catalog_L", "1");
		}
		return itemStandardViewDAO.selectItemStandardViewLevel2(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemStandardViewLevel3
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	부품표준서 소분류 리스트 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemStandardViewLevel3(CommandMap commandMap) {
		// TODO Auto-generated method stub
		if( "".equals(commandMap.get("catalog_L")) || commandMap.get("catalog_L") == null){
			return null;
			/*commandMap.put("catalog_L", "1");*/
		}
		if( "".equals(commandMap.get("catalog_M")) || commandMap.get("catalog_M") == null){
			return null;
			/*commandMap.put("catalog_M", "1");*/
		}
		return itemStandardViewDAO.selectItemStandardViewLevel3(commandMap);
	}

	/**
	 * 
	 * @메소드명	: itemStandardViewSearch
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 	부품표준서 Catalog 검색 보기
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> itemStandardViewSearch(CommandMap commandMap) {
		// TODO Auto-generated method stub
		if( "".equals(commandMap.get("sItemName")) || commandMap.get("sItemName") == null){
			commandMap.put("sItemName", "");
		}
		return itemStandardViewDAO.itemStandardViewSearch(commandMap);
	}

}
