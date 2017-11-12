package stxship.dis.commentSend.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("CommentSendDAO")
public class CommentSendDAO extends CommonDAO {

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	public Map<String, Object> commentSendList(Map<String, Object> map) {
		disSession.selectList("commentSend.list", map);
		return map;
	}
	
	public Object commentSendGetFormName(Map<String, Object> map) {
		return selectOne("commentSend.getFormName", map);
	}
	
	public int commentSendSave(Map<String, Object> map) {
		return update("commentSend.save", map);
	}
	
	public Map<String, Object> popUpCommentSendDwgNoList(Map<String, Object> map) {
		disSession.selectList("commentSend.dwgNoList", map);
		return map;
	}
	
	public int popUpCommentSendDwgNoSave(Map<String, Object> map) {
		return update("commentSend.dwgNoSave", map);
	}
	
	public List<Map<String, Object>> popupCommentSendGridDwgNo(Map<String, Object> map) {
		return selectList("commentSend.gridDwgNo", map);
	}
	
	public List<Map<String, Object>> popupCommentSendGridDwgNoAppSubmit(Map<String, Object> map) {
		return selectListDps("commentSend.gridDwgNoAppSubmit", map);
	}
	
	public Map<String, Object> popUpCommentSendAttachList(Map<String, Object> map) {
		disSession.selectList("commentSend.attachList", map);
		return map;
	}
	
	public Map<String, Object> commentSendFileView(CommandMap commandMap) {
		return selectOne("commentSend.fileView", commandMap.getMap());
	}
	
	public int commentSendFileDelete(Map<String, Object> map) {
		return update("commentSend.fileDelete", map);
	}
	
	public void commentSendAttachSaveAction(Map<String, Object> map) {
		selectOne("commentSend.commentSendAttachSaveAction", map);
	}
	
	public void commentConfirmUserUpdateAction(Map<String, Object> map) {
		selectOne("comment.commentConfirmUserUpdateAction", map);
	}
	
	public int commentSendHeadInsert(Map<String, Object> map) {
		return update("commentSend.headInsert", map);
	}
	
	public int commentSendListInsert(Map<String, Object> map) {
		return update("commentSend.listInsert", map);
	}
	
	public int commentSendRequestMail(Map<String, Object> map) {
		return update("commentSend.requestMail", map);
	}

	public List<Map<String, Object>> commentSendGridProject(Map<String, Object> map) {
		return selectList("commentSend.gridProject", map);
	}
	
	public List<Map<String, Object>> commentSendGridOcType(Map<String, Object> map) {
		return selectList("commentSend.gridOcType", map);
	}
	
	public List<Map<String, Object>> commentSendGridReqUser(Map<String, Object> map) {
		return selectList("commentSend.gridReqUser", map);
	}
	
	public Map<String, Object> commentSendAdminList(Map<String, Object> map) {
		disSession.selectList("commentSendAdmin.list", map);
		return map;
	}

	public int commentSendApplyHeadInsert(Map<String, Object> map) {
		return update("commentSendAdmin.headInsert", map);
	}
	
	public int commentSendApplyListInsert(Map<String, Object> map) {
		return update("commentSendAdmin.listInsert", map);
	}
	
	public int commentSendApplyMail(Map<String, Object> map) {
		return update("commentSendAdmin.applyMail", map);
	}

	public List<Map<String, Object>> commentRequestDeptSelectBoxDataList(Map<String, Object> map) {
		return selectList("commentSendAdmin.commentRequestDeptSelectBoxDataList", map);
	}
}
