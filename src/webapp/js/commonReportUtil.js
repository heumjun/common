/**
 * mrdFileName : mrd 파일명
 * params : parameter( ':::' 로 parameter 구분함 )
 * */
function fn_PopupReportCall( mrdFileName, params ) {
	var dns = document.location.href;
	var arrDns = dns.split("//"); //<-- // 구분자로 짤라와서
	var str = arrDns[1].substring(0,arrDns[1].indexOf("/"));
	if(arrDns[1].indexOf(":") > 0) {
		var str = arrDns[1].substring(0,arrDns[1].indexOf(":")); //<-- 뒤에부터 다음 / 까지 가져온다 
	}
	var urlStr = "http://172.16.2.13:7777/j2ee/STXDIS/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDIS/mrd/" + mrdFileName + "&param=" + params;
	if(str == "10.10.9.83" || str == "localhost") {
		var urlStr = "http://172.16.2.13:7777/j2ee/STXDISD/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDISD/mrd/" + mrdFileName + "&param=" + params;
    }
    window.open(urlStr, "", "");
}