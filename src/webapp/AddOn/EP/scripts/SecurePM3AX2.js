
var SecurePM3AXCodebase = '/PlotManager3/SecurePM3AX2.cab#version=1,10,203,1';     // 제공된 버전을 정확하게 입력합니다.

function SecurePM3AXControl()
{
	var str = '';
	str += '<OBJECT id="SecurePM3AXCtl" name="SecurePM3AXCtl" classid="clsid:0F8E8AEE-DC07-4582-AAD9-83AB2998F119"'; 
	str += 'codebase="' + SecurePM3AXCodebase + '" width="0" height="0">';
	str += '<PARAM name="InstallAddress" value="http://dwgprint.stxons.com" />'; //Secure PM3 Client 모듈을 설치할 주소입니다.
	str += '</OBJECT>';

    document.write(str);
}