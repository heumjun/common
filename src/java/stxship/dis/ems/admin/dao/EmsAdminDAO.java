package stxship.dis.ems.admin.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("emsAdminDAO")
public class EmsAdminDAO extends CommonDAO {
	
	/** 
	 * @메소드명	: emsAdminGetDeptList
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 조회조건 부서 SelectBox 리스트 불러옴
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsAdminSelectBoxDept(Map<String, Object> map) {
		return selectList("emsAdminMain.getSelectBoxDeptList", map);
	}
	
	/** 
	 * @메소드명	: emsAdminUpdateRevision
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * POS Revision 승인 완료 flag 변경
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public int emsAdminUpdateRevision(Map<String, Object> map) {
		return updateErp("emsAdminMain.emsAdminUpdateRevision", map);
	}
	
	/** 
	 * @메소드명	: emsAdminEmailList
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * Email List 가져옴
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminEmailList(Map<String, Object> map) {
		return selectList("emsAdminMain.emsAdminEmailList", map);
	}	

	/** 
	 * @메소드명	: emsAdminInsertRset1
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 PR 로직1
	 * 체크 된 아이템들을 그룹핑 하여 도면번호 및 호선으로  맵핑 (도면, 호선) 받아와. 제외대상 :  STATE= R인것만.
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminInsertRset1(Map<String, Object> map) {
		return selectListErp("emsAdminMain.emsAdminInsertRset1", map);
	}

	/** 
	 * @메소드명	: emsAdminInsertRset2
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 PR 로직2
	 * 해당 호선 도면 기준의 아이템을 받아온다. 각 INTERFACE에 들어갈 정보 받아옴.
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminInsertRset2(Map<String, Object> map) {
		return selectListErp("emsAdminMain.emsAdminInsertRset2", map);
	}
	
	/** 
	 * @메소드명	: emsAdminInsertRset3
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 PR 로직3
	 * PR TEMP INTERFACE 테이블에 입력.(ITEM 별)
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public int emsAdminInsertRset3(Map<String, Object> map) {
		return insertErp("emsAdminMain.emsAdminInsertRset3", map);
	}
	
	/** 
	 * @메소드명	: emsAdminInsertRset4
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 PR 로직4
	 * PR IMPORT 호출.
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> emsAdminInsertRset4(Map<String, Object> map) {
		return selectOneErp("emsAdminMain.emsAdminInsertRset4", map);
	}
	
	/** 
	 * @메소드명	: emsAdminInsertRset5
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 PR 로직5
	 * 승인상태('S')로 변경
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public int emsAdminInsertRset5(Map<String, Object> map) {
		return updateErp("emsAdminMain.emsAdminInsertRset5", map);
	}
	
	/** 
	 * @메소드명	: emsAdminDeleteRset1
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 삭제 PR 로직1
	 * 체크 된 아이템들을 그룹핑 하여 도면번호 및 호선으로  맵핑 (도면, 호선) 받아와. 제외대상 :  STATE= R인것만.
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminDeleteRset1(Map<String, Object> map) {
		return selectListErp("emsAdminMain.emsAdminDeleteRset1", map);
	}
	
	/** 
	 * @메소드명	: emsAdminDeleteRset3
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 삭제 PR 로직1
	 * 도면번호, 호선 기준으로 LOOP 실행. 삭제 시작.
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public int emsAdminDeleteRset3(Map<String, Object> map) {
		return updateErp("emsAdminMain.emsAdminDeleteRset3", map);
	}
	
	/** 
	 * @메소드명	: StatusChangeA
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 반려 상태값 변경('A')
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public int statusChangeA(Map<String, Object> map) {
		return update("emsAdminMain.StatusChangeA", map);
	}	
	
	/** 
	 * @메소드명	: emsAdminRefuseRset1
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 반려 로직1
	 * 반려 시 먼저 메일 보낼 사람 추출
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminRefuseRset1(Map<String, Object> map) {
		return selectList("emsAdminMain.emsAdminRefuseRset1", map);
	}

	/** 
	 * @메소드명	: emsAdminRefuseRset2
	 * @날짜		: 2016. 03. 23. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 반려 로직2
	 * 개인별 도면번호 추출
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> emsAdminRefuseRset2(Map<String, Object> map) {
		return selectList("emsAdminMain.emsAdminRefuseRset2", map);
	}
	
	/**
	 * @메소드명 : posDownloadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpAdminSpecDownloadFile(Map<String, Object> map) {
		return selectOneErp("emsAdminMain.specDownloadFile", map);
	}
}
