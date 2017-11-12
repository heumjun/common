function showCalendar(strFormName, strInputName, strInitialDate, blnRemember, fnCallback)
{
    var objForm = document.forms[strFormName];
	
    var url = "../common/calendar.jsp?";
   
    var result = window.showModalDialog(url, null, "dialogWidth:221px; dialogHeight:300px; status:no; scroll:no; help:no");

    if(result == -1 || result== null || result == 'undefined')
        return;

    document.getElementById(strInputName).value = result;
    
    if( !(fnCallback=='' || fnCallback==null ))
    {
    	fnCallback();
    }
} 