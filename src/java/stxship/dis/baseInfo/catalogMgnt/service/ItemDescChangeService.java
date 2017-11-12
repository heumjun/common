package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : ItemDescChangeService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 Text Fileter가 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
public interface ItemDescChangeService extends CommonService {

	/**
	 * @메소드명 : saveCommonAttributeName
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 Item 속성 일괄반영 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveCommonAttributeName(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : saveChangeCatalogItemAttr
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Item 속성 일괄 반영을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveChangeCatalogItemAttr(CommandMap commandMap) throws Exception;

}
