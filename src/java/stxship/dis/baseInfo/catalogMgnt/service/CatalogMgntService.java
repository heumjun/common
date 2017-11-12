package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : CatalogMgntService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 사용되는 서비스
 *     </pre>
 */
public interface CatalogMgntService extends CommonService {

	/**
	 * @메소드명 : saveCatalogMgnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 저장을 선택했을때 호출되는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveCatalogMgnt(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : categoryFromPartFamily
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PartFamily가 선택되었을때 해당하는 Category를 조회하여 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	Map<String, String> categoryFromPartFamily(CommandMap commandMap);

	/**
	 * @메소드명 : additionalPurchaseInfo
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 구매정보의 계획,표준LT,구매 담당자를 조회하여 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> additionalPurchaseInfo(CommandMap commandMap);

}
