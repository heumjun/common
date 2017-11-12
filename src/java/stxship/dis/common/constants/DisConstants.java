package stxship.dis.common.constants;

/**
 * @파일명 : DisConstants.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DIS에서 사용되어질 공통상수 정의
 *     </pre>
 */
public class DisConstants {

	// **************************************************
	// 각 메뉴의 URL정보(다른 매뉴에서도 불리어질때 사용)
	// **************************************************
	/** 실행 JSP명 */
	public static final String JSP_NAME = "jspName";
	/** BASEINFO */
	public static final String BASEINFO = "/baseInfo";
	/** BOM */
	public static final String DWG = "/dwg";
	/** BOM */
	public static final String BOM = "/bom";
	/** DOC */
	public static final String DOC = "/doc";
	/** ECO */
	public static final String ECO = "/eco";
	/** ECR */
	public static final String ECR = "/ecr";
	/** MENU */
	public static final String MENU = "/menu";
	/** PAINT */
	public static final String PAINT = "/paint";
	/** EMS */
	public static final String EMS = "/ems";
	/** COMMENT */
	public static final String COMMENT = "/comment";
	/** SUPPLY PLAN */
	public static final String SUPPLY_PLAN = "/supplyPlan";	
	/** 로그인에서 사용되어지는 링크 : 로그인경로 */
	public static final String LOGIN_LINK = "/login/login";
	/** 팝업에서 사용되어질 링크 */
	public static final String POPUP = "/popUp";
	// **************************************************
	// 그리드변경 구분자
	// **************************************************
	/** I:신규 */
	public static final String INSERT = "I";
	/** U:수정 */
	public static final String UPDATE = "U";
	/** D:삭제 */
	public static final String DELETE = "D";

	// **************************************************
	// 뷰단에서 받을 결과값
	// **************************************************
	/** 결과 */
	public static final String RESULT_KEY = "result";
	/** 실행 결과에 사용되는 msg 명 */
	public static final String RESULT_MASAGE_KEY = "resultMsg";
	/** 실행 결과에 사용되는 obj 명 */
	public static final String RESULT_OBJECT_KEY = "resultObj";
	/** 결과 : 실패 */
	public static final String RESULT_FAIL = "fail";
	/** 결과 : 성공 */
	public static final String RESULT_SUCCESS = "success";
	/** 공통 : 리스트DB데이터를 뷰단으로 넘겨줄때의 키 */
	public static final String RESULT_LIST = "list";
	// **************************************************
	// 그리드 정보
	// **************************************************
	/** [oper] : 그리드변경 구분자로 I:신규 U:수정 D:삭제 를 취득하기위한 키 */
	public static final String FROM_GRID_OPER = "oper";
	/** [rows] : 그리드의 페이지 사이즈 */
	public static final String FROM_GRID_PAGE_SIZE = "rows";
	/** [page] : 그리드의 현재 페이지 */
	public static final String FROM_GRID_CUR_PAGE_NO = "page";
	/** [chmResultList] : 그리드의 신규,수정,삭제된 데이타 리스트 */
	public static final String FROM_GRID_DATA_LIST = "chmResultList";

	// **************************************************
	// DB에 조건문으로 입력될 그리드 정보, 유저정보 의 키값
	// **************************************************
	/** DB조건문 : 페이지 사이즈 */
	public static final String SET_DB_PAGE_SIZE = "pageSize";
	/** DB조건문 : 현재 페이지 */
	public static final String SET_DB_CUR_PAGE_NO = "curPageNo";
	/** DB조건문 : 로그인아이디 */
	public static final String SET_DB_LOGIN_ID = "loginId";

	// **************************************************
	// 그리드정보를 조회,저장시에 공통적으로 사용되는 맵핑 네임 정의
	// **************************************************
	/** 맵핑 정보를 취득할 키 */
	public static final String MAPPER_NAME = "mapperName";
	/** 맵핑 구분자 */
	public static final String MAPPER_SEPARATION = ".";
	/** 맵핑 네임 : 삭제 */
	public static final String MAPPER_DELETE = "delete";
	/** 맵핑 네임 : 업데이트 */
	public static final String MAPPER_UPDATE = "update";
	/** 맵핑 네임 : 신규 */
	public static final String MAPPER_INSERT = "insert";
	/** 맵핑 네임 : 중복 카운트 */
	public static final String MAPPER_GET_DUPLICATE_CNT = "duplicate";
	/** 맵핑 네임 : 리스트 */
	public static final String MAPPER_GET_LIST = "list";
	/** 공통 : 단일DB데이터를 뷰단으로 넘겨줄때의 키 */
	public static final String MEPPER_GET_SELECT = "select";
	/** 맵핑 네임 : 총 레코드 길이 */
	public static final String MEPPER_GET_TOTAL_RECORD = "selectTotalRecord";

	// **************************************************
	// 그리드에 넘겨줄 결과의 키값
	// **************************************************
	/** 그리드에서 필요한정보 : 현재페이지 */
	public static final String GRID_RESULT_CUR_PAGE = "page";
	/** 그리드에서 필요한정보 : 페이징처리의 마지막 페이지 */
	public static final String GRID_RESULT_LAST_PAGE = "total";
	/** 그리드에서 필요한정보 : 총 레코드 길이 */
	public static final String GRID_RESULT_RECORDS_CNT = "records";
	/** 그리드에서 필요한정보 : 데이터 */
	public static final String GRID_RESULT_DATA = "rows";

	// **************************************************
	// 세션에 저장될 로그인정보 키값
	// **************************************************
	/** 세션정보 : 유저의 로그인 아이디 */
	public static final String SESSION_LOGIN_ID = "user_id";
	/** 세션정보 : 유저 오브젝트 */
	public static final String SESSION_LOGIN_USER_OBJ = "loginUser";

	// **************************************************
	// 뷰에서 사용될 정보
	// **************************************************
	/** 유저의 권한정보의 키값 */
	public static final String VIEW_USER_ROLE_KEY = "userRole";
	/** 페이지 이동에 사용될 대메뉴의 URL키값 */
	public static final String VIEW_PARENT_URL = "up_link";
	/** 페이지 내의 페이지가 불러질경우 메뉴정보가 필요하므로 설정해두는 키값 */
	public static final String VIEW_MENU_ID = "menu_id";
	/** 뷰에서 불리어질 메뉴리스트의 키값 */
	public static final String VIEW_TREE_MENU_LIST = "treeMenuList";
	/** 메뉴관리에서 불리어질 상위 대매뉴의 키값 */
	public static final String MENU_UP_MENU_ID_KEY = "p_up_menu_id";
	/** 초기 메인화면에서 불러어질 APPROVECNT정보의 키값 */
	public static final String MAIN_APPROVE_CNT_LIST = "approveCntList";
	/** 초기 메인화면에서 불러어질 공지 정보의 키값 */
	public static final String MAIN_NOTICE_LIST = "noticeList";

	// **************************************************
	// 시스템 정보
	// **************************************************
	/** 시스템에 적용되어있는 서블릿 경로 */
	public static final String SERVLET_PRE_PATH = "/";
	/** 시스템에 적용되어있는 서블릿 구분어 */
	public static final String SERVLET_TAIL_PATH = "[.]do";
	/** 리졸버에서 선택된 메뉴의 링크를 입력할 키 */
	public static final String NEXT_VIEW_LINK = "nextViewLink";
	/** 메뉴에서 사용되어지는 링크 */
	public static final String MENU_URL = "menu";
	/** 메뉴에서 사용되어지는 링크 : JSP명 */
	public static final String JSP_MAINFRAME = "/mainFrame";
	/** 파일 업로드 경로 */
	public static final String EXCEL = "uploaddata/temp";
	/** PLM 관리자 메일 주소 */
	public static final String ADMIN_ADDRESS = "plmadmin@stxship.com";
	/** 페이징 정보 키 */
	public static final String IS_PAGING = "isPaging";
	/** no */
	public static final String NO = "no";
	/** yes */
	public static final String YES = "yes";
	/** Y */
	public static final String Y = "Y";
	/** mapper를 직접 넣어주는경우 */
	public static final String MAPPER = "mapper";
	/** JSP에서 에러 판단 KEY */
	public static final String IS_ERROR_KEY = "error_yn";
	/** JSP에서 에러 메세지 KEY */
	public static final String ERROR_MSG_KEY = "error_msg";
	/** Servlet path */
	public static final String SERVLET_PATH = "pgm_link";	
}
