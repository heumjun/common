package stxship.dis.system.notice.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface NoticeService extends CommonService {

	void updateReadCount(CommandMap commandMap);

	Map<String, Object> NoticeAddSave(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap) throws Exception;

	View noticeFileDownload(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, Object> frmNoticeAddSave(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap) throws Exception;
}
