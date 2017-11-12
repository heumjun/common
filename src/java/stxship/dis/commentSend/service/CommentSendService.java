package stxship.dis.commentSend.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface CommentSendService extends CommonService {
	
	public Map<String, Object> commentSendList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> commentSendSave(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> popUpCommentSendDwgNoList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> popUpCommentSendDwgNoSave(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> popupCommentSendGridDwgNo(CommandMap commandMap);
	
	public List<Map<String, Object>> popupCommentSendGridDwgNoAppSubmit(CommandMap commandMap);
	
	public Map<String, Object> commentSendGetFormName(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> popUpCommentSendAttachList(CommandMap commandMap) throws Exception;
	
	View commentSendFileView(CommandMap commandMap, Map<String, Object> modelMap);
	
	public Map<String, Object> commentSendFileDelete(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> commentSendRequest(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> commentSendGridProject(CommandMap commandMap);
	
	public List<Map<String, Object>> commentSendGridOcType(CommandMap commandMap);
	
	public List<Map<String, Object>> commentSendGridReqUser(CommandMap commandMap);
	
	public View commentSendExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	public Map<String, Object> commentSendAdminList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> commentSendAdminApply(CommandMap commandMap) throws Exception;
	
	// commentRequest 발신파트 SelectBoxDataList
	public String commentRequestDeptSelectBoxDataList(CommandMap commandMap) throws Exception;
}
