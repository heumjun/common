package stxship.dis.comment.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("CommentDAO")
public class CommentDAO extends CommonDAO {

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	public List<Map<String, Object>> commentReceiptTeamSelectBoxDataList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptTeamSelectBoxDataList", map);
	}
	
	public List<Map<String, Object>> commentReceiptDeptSelectBoxDataList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptDeptSelectBoxDataList", map);
	}
	
	public List<Map<String, Object>> commentReceiptProjectNoList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptProjectNoList", map);
	}
	
	public List<Map<String, Object>> commentReceiptDwgNoList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptDwgNoList", map);
	}
	
	public Map<String, Object> commentReceiptList(Map<String, Object> map) {
		disSession.selectList("commentReceipt.list", map);
		return map;
	}
	
	public void commentReceiptDeleteAction(Map<String, Object> map) {
		selectOne("commentReceipt.commentReceiptDelete", map);
	}
	
	public List<Map<String, Object>> popUpReceiptTeamList(Map<String, Object> map) {
		return selectList("commentReceipt.popUpReceiptTeamList", map);
	}
	
	public Map<String, Object> commentReceiptFileDownload(CommandMap commandMap) {
		return selectOne("commentReceipt.commentReceiptFileDownload",commandMap.getMap());
	}
	
	public List<Map<String, Object>> commentReceiptGridTeamList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptGridTeamList", map);
	}
	
	public void commentReceiptTeamDeleteAction(Map<String, Object> map) {
		selectOne("commentReceipt.commentReceiptTeamDelete", map);
	}

	public void commentReceiptTeamInsertAction(Map<String, Object> map) {
		selectOne("commentReceipt.commentReceiptTeamInsert", map);
	}
	
	public List<Map<String, Object>> commentReceiptUserEtcDeptSelectBoxDataList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptUserEtcDeptSelectBoxDataList", map);
	}
	
	public List<Map<String, Object>> commentReceiptGridDeptList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptGridDeptList", map);
	}
	public List<Map<String, Object>> commentReceiptGridUserList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptGridUserList", map);
	}
	public List<Map<String, Object>> commentReceiptUserList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptUserList", map);
	}
	
	public void commentReceiptUserApplyAction(Map<String, Object> map) {
		selectOne("commentReceipt.commentReceiptUserApplyAction", map);
	}
	public void receiptApplyHeadInProc(Map<String, Object> map) {
		selectOne("commentReceipt.receiptApplyHeadInProc", map);
	}
	public void receiptApplyListInProc(Map<String, Object> map) {
		selectOne("commentReceipt.receiptApplyListInProc", map);
	}
	public void receiptApplyEtcInProc(Map<String, Object> map) {
		selectOne("commentReceipt.receiptApplyEtcInProc", map);
	}
	public void mailSendProc(Map<String, Object> map) {
		selectOne("commentReceipt.mailSendProc", map);
	}
	
	
	public void commentReceiptDwgApplyAction(Map<String, Object> map) {
		selectOne("commentReceipt.commentReceiptDwgApplyAction", map);
	}
	
	public void commentReceiptAddInsert(Map<String, Object> map) {
		selectOne("commentReceiptAdd.commentReceiptAddInsert", map);
	}
	
	public void commentReceiptAddValidationCheck(Map<String, Object> map) {
		selectOne("commentReceiptAdd.commentReceiptAddValidationCheck", map);
	}
	
	public Map<String, Object> commentReceiptWorkValidationList(Map<String, Object> map) {
		disSession.selectList("commentReceiptAdd.commentReceiptWorkValidationList", map);
		return map;
	}
	
	public void commentReceiptAddApplyAction(Map<String, Object> map) {
		selectOne("commentReceiptAdd.commentReceiptAddApplyAction", map);
	}
	
	public List<Map<String, Object>> commentChartList(Map<String, Object> map) {
		return selectList("commentChartList.commentChartList", map);
	}
	
	public List<Map<String, Object>> commentChartDetailList(Map<String, Object> map) {
		return selectList("commentChartList.commentChartDetailList", map);
	}
	
	public List<Map<String, Object>> commentSelectBoxTeamList(Map<String, Object> map) {
		return selectList("commentChartList.commentSelectBoxTeamList", map);
	}
	
	public List<Map<String, Object>> commentSelectBoxPartList(Map<String, Object> map) {
		return selectList("commentChartList.commentSelectBoxPartList", map);
	}
	
	public List<Map<String, Object>> commentSelectBoxUserList(Map<String, Object> map) {
		return selectList("commentChartList.commentSelectBoxUserList", map);
	}
	
	public List<Map<String, Object>> commentAutoCompleteDwgNoList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentAutoCompleteDwgNoList", map);
	}
	
	public Map<String, Object> commentList(Map<String, Object> map) {
		disSession.selectList("comment.list", map);
		return map;
	}

	public void commentMainSaveAction(Map<String, Object> map) {
		selectOne("comment.commentMainSaveAction", map);
	}
	
	public void commentMainAttachSaveAction(Map<String, Object> map) {
		selectOne("comment.commentMainAttachSaveAction", map);
	}

	public List<Map<String, Object>> commentReceiptNoList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentReceiptNoList", map);
	}

	public List<Map<String, Object>> pcfHistoryList(Map<String, Object> map) {
		return selectList("comment.pcfHistoryList", map);
	}
	
	public List<Map<String, Object>> pcfHeaderList(Map<String, Object> map) {
		return selectList("comment.pcfHeaderList", map);
	}
	
	public List<Map<String, Object>> pcfSubList(Map<String, Object> map) {
		return selectList("comment.pcfSubList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> pcfHeader(Map<String, Object> map) {
		return (Map<String, Object>)selectOne("comment.pcfHeader", map);
	}
	
	public void commentConfirmUserUpdateAction(Map<String, Object> map) {
		selectOne("comment.commentConfirmUserUpdateAction", map);
	}

	public void commentReqeustApplyAction(Map<String, Object> map) {
		selectOne("comment.commentReqeustApplyAction", map);
	}

	public List<Map<String, Object>> commentRefNoList(Map<String, Object> map) {
		return selectList("commentReceiptCommon.commentRefNoList", map);
	}
	
	// Comment 승인
	public Map<String, Object> commentAdminMaList(Map<String, Object> map) {
		disSession.selectList("commentAdmin.commentAdminMaList", map);
		return map;
	}
	
	public Map<String, Object> commentAdminDeList(Map<String, Object> map) {
		disSession.selectList("commentAdmin.commentAdminDeList", map);
		return map;
	}

	public void commentAdminConfirmAction(Map<String, Object> map) {
		selectOne("commentAdmin.commentAdminConfirmAction", map);
	}
	
	public Map<String, Object> popUpCommentCommentAttachList(Map<String, Object> map) {
		disSession.selectList("comment.popUpCommentCommentAttachList", map);
		return map;
	}

	public Object commentExcelTeamCode(Map<String, Object> map) {
		return selectOne("commentReceiptAdd.commentExcelTeamCode", map);
	}

	public void commentImportAddProc(Map<String, Object> map) {
		selectOne("commentImport.commentImportAddProc", map);
	}

	public void commentImportValidationProc(Map<String, Object> map) {
		selectOne("commentImport.commentImportValidationProc", map);
	}
	
	public void commentReplyImportValidationProc(Map<String, Object> map) {
		selectOne("commentImport.commentReplyImportValidationProc", map);
	}

	public Map<String, Object> commentImportSelectProc(Map<String, Object> map) {
		disSession.selectList("commentImport.commentImportSelectProc", map);
		return map;
	}

	public List<Map<String, Object>> commentReceiptNoSelectBoxDataList(Map<String, Object> map) {
		return selectList("commentImport.commentReceiptNoSelectBoxDataList", map);
	}

	public void commentImportConfirmProc(Map<String, Object> map) {
		selectOne("commentImport.commentImportConfirmProc", map);
	}
	
	public void commentReplyImportConfirmProc(Map<String, Object> map) {
		selectOne("commentImport.commentReplyImportConfirmProc", map);
	}


}
