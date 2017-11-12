package com.stx.common;

/**
 * <p>Title: STX 조선 PI 1기 프로젝트</p>
 *
 * <p>Description: 자바 페키지의 용도를 설명하는 클래스 </p>
 *
 * <p>Copyright: Copyright (c) 2004</p>
 *
 * <p>Company: 한국 후지쯔</p>
 *
 * @author 권진만
 * @version 1.0
 */
// 이 페키지는 Common - 시스템 전반에 걸쳐 필요한 공통 모듈을 두는 곳입니다.
// 하위 페키지로는 편의상 타 모듈과 동일한 형태를 유지하며, 각각의 성격도 동일합니다. 다만 시스템 전반에 걸쳐서
// 사용되므로 새로운 클래스 생성시 개발자 상호 협의가 있어야 되며, 클래스의 기능 및 메소드들에 대한 정의가 명확하게
// 유지 되어야 합니다.
//      - .util        : 시스템 전반에 걸쳐서 필요한 Util class
//                       ( String 처리, Date 처리, eMatrix 기본사항 처리등  )
//      - .ui          : 화면 UI를 생성하는데 필요한 클래스
//      - .interface   : 외부 인터페이스와 관련된 시스템 공통 사용 클래스
//      - .            : 공통 모듈( 시스템 상수 및 시스템에서 공통으로 사용되는 것 )
//
// 클래스 Naming Rule은..
//      -. util, interface, common 패키지는 해당 클래스의 성격에 따라서 일반적으로 통용될 수 있는 명칭을 사용.
//         ( ex : util.StringUtil, util.DateUtil, util.BOMUtil, interface.ECRInterface, common.JDBCConnect 등 )
//      -. ui 패키지는 시스템 공통 사용이므로 접두사와 접미사를 허용하지 않으며, 특정 모듈 사용 용도로 작성되는 클래스는 없어야 한다.
//         ( ex : MakeTableList.java, MakePopupWindow.java etc... )
//
// 메소드 Naming Rule은..
//      -. 기본적인 Java Naming Rule를 따르고, 특수한 경우 아래의 내용을 참고하여 작성한다.
//       ----------- 아래 -----------
//       : 동사 + 명사의 형식으로 작성하며 음절의 처음글자는 대문자로 함. 단, 첫 문자는 소문자로 한다.
//         ex) printDrawingList(); doPromote();
//       : Getters  :  어떤 특정의 값을 가지고 오는 경우에는 앞음절에 ’get'을 사용한다.
//         ex) getDefaultPolicy();
//       : boolean 값을 체크하는  경우는 ’is'를 사용
//         ex) isPersistent(); isAtEnd();
//       : Setters : 어떤 특정의 값을 지정하는 경우에는 앞음절에 ’set'를 사용한다.
//         ex) setFirstName(String aName), setAccountNumber(int anAccountNumber)
//       : 다음과 같은 행위를 하는 메소드는 접두사를 반드시 아래 몇칭을 사용한다.
//         ex) insert, delete, select, put, input, output ….
//
// 변수 Naming Rule는..
//       1) 시스템 전반적으로 사용하는 전역 변수 일 경우 접두사 "G_"를 붙이고 전체 대문자로 한다.
//          반드시 final static로 정의한다.
//         ex) public final static String G_SYSTEM_ID = "PI";
//       2) 해당 모듈( PDC, PEC, PGC )에서 사용하는 전역 변수 일 경우 접두사 "M_"을 붙이고 전체 대문자로 한다.
//          반드시 final static로 정의한다.
//         ex) public final static String M_PDC_ECR_INTERFACE_IP = "164.122.12.109";
//       3) 해당 클래스 내에서 사용하는 전역 변수는 접두사 "m_"를 사용하고, "변수의 형태" + "용도"의 형태로 사용한다.
//         ex) private HashMap m_hashmapBOMTree = null;
//       4) 파라미터로 넘어오는 변수명은 접두사 "p_"를 사용한다.
//         ex) public String getName( String p_sOID ) { return "xxx"; }
//       5) 로컬 변수의 경우 "형태" + "용도"의 형태를 유지하며, "형태"는 소문자, "용도"의 첫글자는 대문자로 한다.
//         ex) HashMap hashmapBOMTree = new HashMap();
//          단, 기본 타입일 경우는 첫문자만 사용한다.
//         ex) int => iXxx, String -> sStr float -> fKkk
//       6) 변수 사용 스코프가 작은 경우( 첨자 혹은 for loop내의.. ) 특별한 제약사항은 없다. 단 1~4번 Rule를 적용할 수 없다.
//
//       ※※※※※ 주의 ※※※※※
//       1번과 2번의 경우 해당 변수가 존재하는 클래스의 위치는 1번의 경우 com.stx.common 내부, 2번의 경우
//       각 패키지별 common 패키지 내부로 규정한다.
//
//
//
//
//

public class Readme {
    public Readme() {
    }
}
