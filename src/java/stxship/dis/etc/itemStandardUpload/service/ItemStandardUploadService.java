package stxship.dis.etc.itemStandardUpload.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : ItemStandardUploadService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 12. 6.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * ItemStandardView에서 사용되는 서비스
 *     </pre>
 */
public interface ItemStandardUploadService extends CommonService {

	public String getSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> getDbDataOne(CommandMap commandMap);
	
	public Map<String, Object> insertFileUpLoad(CommandMap commandMap, HttpServletRequest request)	throws Exception;
	
	public String selectCatalogList(CommandMap commandMap);

}
