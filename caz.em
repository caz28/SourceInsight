/*��õ�ǰʱ��,xxxx/xx/xx/xx:xx*/
macro CurTime()
{
	SysTime = GetSysTime(8)
	year  = SysTime.Year
	month = SysTime.Month
	day   = SysTime.Day
	hour  = SysTime.Hour
	minute= SysTime.Minute
	
	if(strlen(month) < 2){
		month	= cat("0",month)
	}
	if(strlen(day) < 2){
		day	= cat("0",day)
	}
	if(strlen(hour) < 2){
		hour	= cat("0",hour)
	}
	if(strlen(minute) < 2){
		minute	= cat("0",minute)
	}
	tempStr	= "@year@/@month@/@day@/@hour@:@minute@"
	return tempStr
}
/*��õ�ǰʱ��,���������գ�xxxx/xx/xx*/
macro CurTime_ymd()
{
	SysTime = GetSysTime(8)
	year  = SysTime.Year
	month = SysTime.Month
	day   = SysTime.Day
	hour  = SysTime.Hour
	minute= SysTime.Minute
	
	if(strlen(month) < 2){
		month	= cat("0",month)
	}
	if(strlen(day) < 2){
		day	= cat("0",day)
	}
	tempStr	= "@year@/@month@/@day@"
	return tempStr
}
/*�õ��ο��п�ͷ�Ŀհ��ַ��������ڶ���*/
macro GetRefSpace()
{
	hbufCur	= GetCurrentBuf()
	lnCur	= GetBufLnCur(hbufCur)
	refBuf	=GetBufLine(hbufCur,lnCur)
	spaceBuf	= ""
	i = 0
	while( refBuf[i] == " " || refBuf[i] == "\t" ){
		if( refBuf[i] == " " ){
			spaceBuf = cat( spaceBuf, " " )//space
		}else{
			spaceBuf = cat( spaceBuf, "\t" )//Tab
		}
		i = i + 1
	}
	return spaceBuf
}
/*����ҵı��*/
macro AddCazMark()
{
	MyName = getenv(MYNAME)
	
	hbufCur	= GetCurrentBuf()
	lnCur	= GetBufLnCur(hbufCur)
	spaceBuf	=	GetRefSpace()
	curTimeStr	=	CurTime()
	tempBuf	= cat( spaceBuf, "//@MyName@/@curTimeStr@ " )
	InsBufLine( hbufCur, lnCur, tempBuf )	
}
/*#if defined(xxx)�����*/
macro IfdefinedSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if defined(@sz@)")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}
/*��ӿ��غ꣬�ڻ�������������*/
macro AddSwitchMacro()
{
	SM	= getenv(SI_SWITCH_MACRO)
	//IfdefSz(SM)
	IfdefinedSz(SM);
}
/*c++���ע��*/
macro Comment()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	while(ln<=lnLast){
		tempStr	=GetBufLine (hbuf, ln)
		PutBufLine (hbuf, ln, cat("//",tempStr))
		ln = ln + 1
	}
}
macro Uncomment()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	while(ln<=lnLast){
		tempStr	= GetBufLine (hbuf, ln)
		tempLen	= strlen(tempStr)
		if(tempLen >= 2){
			if(strmid (tempStr,0,2) == "//")
				PutBufLine (hbuf, ln, strmid(tempStr,2,tempLen))
		}
		ln = ln + 1
	}
}
/*��ȫ·���з����ļ���*/
macro FileName(path)
{
	sLen	=	strlen(path)
	i	=	sLen - 1
	while(i){
		ch = path[i]
		if("@ch@" == "\\")
			break
		i = i - 1
	}
	if(i == 0)i = -1;//û��ǰ���ַ�����
	return strmid(path,i+1,sLen)
}
/*�����ļ������������ļ�������飬���ߣ�����*/
macro InsertFileDeclare()
{
	hbuf = GetCurrentBuf()
	
	fn	=	FileName(GetBufName(hbuf))
	myName 	= getenv(MYNAME)
	date	=	CurTime()

	str1	= cat("/*!\t\\file\t",fn)
	str2	= " *\t\\brief\t"
	str3	= cat(" *\t\\author\t",myName)
	str4	= cat(" *\t\\date\t",date)
	str5	= " */"
	InsBufLine(hbuf, 0,str1)
	InsBufLine(hbuf, 1,str2)
	InsBufLine(hbuf, 2,str3)
	InsBufLine(hbuf, 3,str4)
	InsBufLine(hbuf, 4,str5)
}
//ͨ���ļ����õ��������õ��ַ���
macro GuardText(fn)
{
	sLen	=	strlen(fn)
	i = 0
	fn	=	toupper(fn)
	while(i<sLen){
		ch = fn[i]
		if(ch == ".")fn[i] = "_"
		i = i + 1
	}
	fn	=	cat("_",fn)
	fn	=	cat(fn,"_")
	return fn
}
//���������ꡣ
macro InsertGuardMacro()
{
	hbuf	=	GetCurrentBuf()
	fn	=	FileName(GetBufName(hbuf))
	str1	=	GuardText(fn)
	strL1	=	cat("#ifndef ",str1)
	strL2	=	cat("#define ",str1)
	strL3	=	cat("#endif //",str1)
	InsBufLine(hbuf, 0,strL1)
	InsBufLine(hbuf, 1,strL2)
	lineCount	=	GetBufLineCount (hbuf)
	InsBufLine(hbuf, lineCount,strL3)
}
//�޸�bugע�ͣ�����
macro FixedBugCommentOne()
{
	MyName = getenv(MYNAME)
	curTimeStr = CurTime_ymd()
	hbufCur	= GetCurrentBuf()
	lnCur	= GetBufLnCur(hbufCur)
	tempStr	= GetBufLine (hbufCur, lnCur)
	bug_No	= Ask("Enter No. of bug:")
	tempStr = cat(tempStr,"\t//@MyName@/@curTimeStr@,for bug #@bug_No@")
	PutBufLine (hbufCur, lnCur,tempStr)
}
//�����ҵı�ʾ,ֻ�������ա�
macro AddCazMark2()
{
	MyName = getenv(MYNAME)
	curTimeStr = CurTime_ymd()
	hbufCur	= GetCurrentBuf()
	lnCur	= GetBufLnCur(hbufCur)
	tempStr	= GetBufLine (hbufCur, lnCur)
	tempStr = cat(tempStr,"\t//@MyName@/@curTimeStr@")
	PutBufLine (hbufCur, lnCur,tempStr)	
}
//������ʾ
macro AddCazBlockMark()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	MyName = getenv(MYNAME)
	curTimeStr = CurTime_ymd()
	InsBufLine(hbuf, lnFirst, "//Start\t@MyName@ @curTimeStr@")
	InsBufLine(hbuf, lnLast+2, "//End\t@MyName@ @curTimeStr@")
}
//ע�� Perl ����make�ļ��ȡ�
macro CommentSharp()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	while(ln<=lnLast){
		tempStr	=GetBufLine (hbuf, ln)
		PutBufLine (hbuf, ln, cat("#",tempStr))
		ln = ln + 1
	}
}
//ȡ��#ע�ͣ�ֻ��ȥ����#��ͷ��ע�ͣ�ֻȥһ��#��
macro UncommentSharp()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	while(ln<=lnLast){
		tempStr	= GetBufLine (hbuf, ln)
		tempLen	= strlen(tempStr)
		if(tempLen >= 1){
			if(strmid (tempStr,0,1) == "#")
				PutBufLine (hbuf, ln, strmid(tempStr,1,tempLen))
		}
		ln = ln + 1
	}
}
//����C����
macro AddExernC()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	MyName = getenv(MYNAME)
	curTimeStr = CurTime_ymd()
	InsBufLine(hbuf, lnFirst, "#ifdef __cplusplus")
	InsBufLine(hbuf, lnFirst+1, "extern   \"C\"{")
	InsBufLine(hbuf, lnFirst+2, "#endif")
	skip = 3
	InsBufLine(hbuf, lnLast+skip+1, "#ifdef __cplusplus")
	InsBufLine(hbuf, lnLast+skip+2, "}")
	InsBufLine(hbuf, lnLast+skip+3, "#endif")
}
//ע�͵�û��ʹ�õĴ���
macro CancleNorUsed()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if 0 /* not used */")
	InsBufLine(hbuf, lnLast+2, "#endif /* not used */")
}
//������������
macro SetMyName()
{
	myName = Ask("Enter your name:")
	if (sz != "")
		PutEnv (MYNAME,myName);
}
//���ÿ��غ�
macro SetSwitchMacro()
{
	switchMacro = Ask("Enter your macro:")
	if (sz != "")
		PutEnv (SI_SWITCH_MACRO,switchMacro);
}
//�ú궨�����ѡ�в��֣�����ú�ʱѡ�в�����Ч�������else���֡�
macro AddIfdef_1(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if defined(@sz@)")
	InsBufLine(hbuf, lnLast+2, "#else /* !@sz@ */")
	InsBufLine(hbuf, lnLast+3, "#endif /* @sz@ */")
}
//�ú궨�����ѡ�в��֣�û�ж���ú�ʱѡ�в�����Ч�������else���֡�
macro AddIfdef_2(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if !defined(@sz@)")
	InsBufLine(hbuf, lnLast+2, "#else /* @sz@ */")
	InsBufLine(hbuf, lnLast+3, "#endif /* @sz@ */")
}
//�ú궨�����ѡ�в��֣�û�ж���ú�ʱѡ�в�����Ч�������#if���֡�
macro AddIfdef_3(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if defined(@sz@)")
	InsBufLine(hbuf, lnFirst+1, "#else /* !@sz@ */")
	InsBufLine(hbuf, lnLast+3, "#endif /* @sz@ */")
}

//�궨��ʱ��ѡ�в���
macro AddSwitchMacro_1()
{
	SM	= getenv(SI_SWITCH_MACRO)
	AddIfdef_1(SM)
}
//��δ����ʱ��ѡ�в��֣�#if !defined(xxx)�ڵ�һ�С� 
macro AddSwitchMacro_2()
{
	SM	= getenv(SI_SWITCH_MACRO)
	AddIfdef_2(SM)
}
//��δ����ʱ��ѡ�в��֣���#if defined(xxx)�ڵ�һ�С�
macro AddSwitchMacro_3()
{
	SM	= getenv(SI_SWITCH_MACRO)
	AddIfdef_3(SM)
}

//����#if ��#else #elif ����һ�顣
//��Ҫ�����������ӵĺ�顣
macro FindNextBlock()
{
	//Msg(GetCMacroHead("   #ifadfasdf"))
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)
	lnCur = GetBufLnCur(hbuf)
	tempStr	= GetBufLine (hbuf, lnCur)
	tempHead = GetCMacroHead(tempStr)
	flag = 0
	if(tempHead != "#if" && tempHead != "#el")
	{
		Msg("Error:selecte line!");
		return 0
	}
	else
	{
		lnCur = lnCur + 1
		while(lnCur <lnMax)
		{
			tempStr	= GetBufLine (hbuf, lnCur)
			tempHead = GetCMacroHead(tempStr)
			/*
			tempDebug = ""
			s = flag
			s2 = lnCur
			tempDebug = cat(tempDebug,tempHead)
			tempDebug = cat(tempDebug,",")
			tempDebug = cat(tempDebug,s)
			tempDebug = cat(tempDebug,",")
			tempDebug = cat(tempDebug,s2)
			
			Msg(tempDebug)
			*/
			if(flag == 0)
			{
				if(tempHead == "#el" || tempHead == "#en")
				{
					//stop
					SetBufIns (hbuf, lnCur, 0)
					Msg(lnCur)
					return
				}
			}
			else
			{
				if(tempHead == "#en")
				{
					flag = flag -1
				}
			}
			if(tempHead == "#if")
			{
				flag = flag + 1
			}
			//��һ��
			lnCur = lnCur+1
		}
	}
	
}

macro GetCMacroHead(lineBuf)
{
	headBuf	= ""
	i = 0
	while( lineBuf[i] == " " || lineBuf[i] == "\t" ){
		i = i + 1
	}
	n= strlen(lineBuf)
	if ((n - i)<3)return ""
	m = i+3;
	while(i<m){
		headBuf = cat(headBuf,lineBuf[i])
		i = i + 1;
	}
	return headBuf

}

macro myStrSearch(strbuf,pattern)
{
	m = strlen(strbuf)
	n = strlen(pattern)
	i = 0
	while(i<m){
		if(strbuf[i] == pattern[0])
		{
			j = 1;
			while(j < n){
				if(strbuf[i+j] != pattern[j])
					break;
				j = j + 1
			}
			if(j == n)
				return i;
		}
		i = i + 1
	}
	return -1;
}

macro ResPBM2PNG()
{
	//Msg(GetCMacroHead("   #ifadfasdf"))
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)
	lnCur = GetBufLnCur(hbuf)
	tempStr	= GetBufLine (hbuf, lnCur)
	sz = getenv(SI_SWITCH_MACRO)

	p = myStrSearch(tolower(tempStr),".pbm")
	if(p != -1){
		tempStr[p+1] = "p";
		tempStr[p+2] = "n";
		tempStr[p+3] = "g";
		InsBufLine(hbuf, lnCur, "#if defined(@sz@)")
		InsBufLine(hbuf, lnCur+1, tempStr)
		InsBufLine(hbuf, lnCur+2, "#else /* !@sz@ */")	
		InsBufLine(hbuf, lnCur+4, "#endif /* @sz@ */")		
	}
}

//���ѡ�в��ִ������棬#if ��#endif�Ƿ���ԡ�
macro CheckMacroIfEndif()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	tempHead = ""
	n_head = 0
	n_end = 0
	while(ln<=lnLast){
		tempStr	=GetBufLine (hbuf, ln)
		tempHead = GetCMacroHead(tempStr)
		if(tempHead == "#if")
		{
			n_head = n_head + 1
		}
		if(tempHead == "#en")
		{
			n_end = n_end + 1
		}
		ln = ln + 1
	}
	if(n_head == n_end)
	{
		Msg("OK!")
	}
	else
	{
		Msg("Not match!")
	}
}

//�滻defined(__MMI_MAINLCD_176X220__)Ϊdefined(__MMI_MAINLCD_176X220__) || defined(__MMI_MAINLCD_220X176__)
macro Replace1()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)
	lnCur = GetBufLnCur(hbuf)
	tempStr	= GetBufLine (hbuf, lnCur)
	strSrc = "defined(__MMI_MAINLCD_176X220__)"
	strReplace = "defined(__MMI_MAINLCD_176X220__) || defined(__MMI_MAINLCD_220X176__)"

	p = myStrSearch(tempStr,strSrc)
	if(p != -1)
	{
		len = strlen(strSrc)
		a = strmid(tempStr,0,p)
		b = strmid(tempStr,p+len,strlen(tempStr))
		newStr = cat(a,cat(strReplace,b))
		PutBufLine(hbuf, lnCur, newStr)
	}
}
//14, 14, 14, 0, 1, 25, 500,

macro GetMatchIndex(strbuf,pattern,index)
{
	m = strlen(strbuf)
	n = strlen(pattern)
	i = 0
	matchNum = 0;
	while(i<m){
		if(strbuf[i] == pattern[0])
		{
			j = 1;
			while(j < n){
				if(strbuf[i+j] != pattern[j])
					break;
				j = j + 1
			}
			if(j == n)
			{
				matchNum = matchNum + 1
				if(matchNum >= index)
					return i
			}
		}
		i = i + 1
	}
	return -1
}
macro HaveSevenComma(str)
{
	if((GetMatchIndex(str,",",7) != -1)&&(GetMatchIndex(str,",",8) == -1))
		return 1
	else
		return 0
}
macro Replace2()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)
	lnCur = GetBufLnCur(hbuf)
	tempStr	= GetBufLine (hbuf, lnCur)
	if(HaveSevenComma(tempStr))
	{
		p2 = GetMatchIndex(tempStr,",",2)
		newStr =strmid(tempStr,0,p2+1)
		PutBufLine(hbuf, lnCur, newStr)		
		InsBufLine(hbuf, lnCur+1, "#if defined(PLUTO_MMI)")
		p4 = GetMatchIndex(tempStr,",",4)
		newStr =strmid(tempStr,p2+1,p4+1)
		InsBufLine(hbuf, lnCur+2, newStr)		
		InsBufLine(hbuf, lnCur+3, "#endif /* PLUTO_MMI */")
		lineLen = strlen(tempStr)
		newStr =strmid(tempStr,p4+1,lineLen)
		InsBufLine(hbuf, lnCur+4, newStr)		
	}
}

//���鿴˳��������ڣ����鿴�����������档
macro ListWnd()
{
	hwnd = GetCurrentWnd()
	while(hNil != hwnd)
	{
		hbuf = GetWndBuf(hwnd)
		fn = FileName(GetBufName(hbuf))
		Msg(fn)
		hwnd = GetNextWnd (hwnd)
	}
}
//����˳��������ڣ����򿪵��������档
macro ListWnd2()
{
	cwnd = WndListCount()
	iwnd = 0
	while (iwnd < cwnd)
	{
	    hwnd = WndListItem(iwnd)
	    // �� do something with window hwnd 
	    hbuf = GetWndBuf(hwnd)
	    fn = FileName(GetBufName(hbuf))
	    Msg(fn)
	    iwnd = iwnd + 1
	}
}

//�������鿴��10���ļ������ര�ڹر�
macro RemainLast10()
{
	index = 0
	hwnd = GetCurrentWnd()
	while(hNil != hwnd)
	{
		hbuf = GetWndBuf(hwnd)
		hwnd = GetNextWnd (hwnd)
		if(hNil != hbuf && index >= 10 && (!IsBufDirty (hbuf)))
		{
			CloseBuf(hbuf)
		}
		index = index + 1
	}
}
//���Թرմ���
macro CloseWndTest()
{
	hwnd = GetCurrentWnd()
	hbuf = GetWndBuf(hwnd)
	if(IsBufDirty (hbuf))
	{
		Msg("Not save!");
	}
	else
	{
		CloseBuf(hbuf)//����Ҳ���Źر��ˡ�CloseWnd (hwnd)��˵����ر�buf��
	}
}
// �ѵ�ǰȫ·���ļ������������
macro GetFullFileName()
{
	hbuf = GetCurrentBuf()
	hbufClip = GetBufHandle("Clipboard")
	EmptyBuf(hbufClip)
	AppendBufLine(hbufClip, GetBufName(hbuf))
}

macro MyGetFuncName(myStr)
{
	flag = 0
	iStart = 0
	iEnd = 0
	len = strlen(myStr)
	while(iEnd < len)
	{
		if((myStr[iEnd] == " ")||(myStr[iEnd] == "\t"))
		{
			flag = 1
		}
		else
		{
			if((flag == 1) && (myStr[iEnd] != "("))
			{
				iStart = iEnd
			}
			else if(myStr[iEnd] == "(")
			{
				return strmid(myStr,iStart,iEnd)
			}
			else
			{
			}
			flag = 0
		}
		iEnd = iEnd + 1	
	}
	return ""
}

macro MyGetMyComment(funcName)
{
	if(funcName == "BD_ERROR_IND_CB")
		return "ER"
	else if(funcName == "BD_CLOSE_HFP_IND_CB")
		return "IA"
	else if(funcName == "BD_CREAT_HFP_IND_CB")
		return "IB"
	else if(funcName == "BD_CALL_OUTING_IND_CB")
		return "IC"
	else if(funcName == "BD_CALL_IN_IND_CB")
		return "ID"
	else if(funcName == "BD_CALL_CANCEL_IND_CB")
		return "IF"
	else if(funcName == "BD_CALL_ANSWER_IND_CB")
		return "IG"
	else if(funcName == "BD_ENTER_PAIR_IND_CB")
		return "II"
	else if(funcName == "BD_EXIT_PAIR_IND_CB")
		return "IJ"
	else if(funcName == "BD_CALL_WAIT_IND_CB")
		return "IK"
	else if(funcName == "BD_CALL_HOLD_CUR_ANSER_NEW_IND_CB")
		return "IL"
	else if(funcName == "BD_CALL_ENTER_MEETING_IND_CB")
		return "IM"
	else if(funcName == "BD_CALL_REJECT_NEW_IND_CB")
		return "IN"
	else if(funcName == "BD_CALL_IN_NAME_DISP_IND_CB")
		return "IQ"
	else if(funcName == "BD_CALL_CUR_NUM_IND_CB")
		return "IR"
	else if(funcName == "BD_MODULE_INIT_END_IND_CB")
		return "IS"
	else if(funcName == "BD_CALL_END_CUR_ANSER_NEW_IND_CB")
		return "IT"
	else if(funcName == "BD_HFP_CONNECTING_IND_CB")
		return "IV"
	else if(funcName == "BD_AV_PAUSE_OR_STOP_RSP_CB")
		return "MA"
	else if(funcName == "BD_AV_PLAY_RSP_CB")
		return "MB"
	else if(funcName == "BD_HFP_CONNECT_RSP_CB")
		return "MC"
	else if(funcName == "BD_HFP_DISCONNECT_RSP_CB")
		return "MD"
	else if(funcName == "BD_GET_MODULE_CONFIG_RSP_CB")
		return "MF"
	else if(funcName == "BD_GET_HFP_STATE_RSP_CB")
		return "MG"
	else if(funcName == "BD_GET_AVRCP_STATE_RSP_CB")
		return "ML"
	else if(funcName == "BD_GET_MODULE_DEVICE_NAME_RSP_CB")
		return "MM"
	else if(funcName == "BD_GET_MODULE_PAIR_PSW_RSP_CB")
		return "MN"
	else if(funcName == "BD_GET_A2DP_STATE_RSP_CB")
		return "MU"
	else if(funcName == "BD_GET_SW_VER_RSP_CB")
		return "MW"
	else if(funcName == "BD_GET_PAIR_LIST_RSP_CB")
		return "MX"
	else if(funcName == "BD_A2DP_DISCONNECT_RSP_CB")
		return "MY"
	else if(funcName == "BD_MULTI_LINE_END_RSP_CB")
		return "OK"
	else if(funcName == "BD_GetPBCL_RSP_CB")
		return "PA"
	else if(funcName == "BD_PBCL_INFO_IND_CB")
		return "PB"
	else if(funcName == "BD_PBCL_INFO_END_IND_CB")
		return "PC"
	else if(funcName == "BD_GET_MODULE_CL_RSP_CB")
		return "PD"
	else if(funcName == "BD_VOICE_DIAL_START_RSP_CB")
		return "PE"
	else if(funcName == "BD_VOICE_DIAL_END_RSP_CB")
		return "PF"
	else
		return ""
}

macro InsertMyComment()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	ln = lnFirst;
	while(ln <= lnLast){
		tempStr	=GetBufLine (hbuf, ln)
		if(strlen(tempStr)>6)
		{
			if(strmid(tempStr,0,5) == "LOCAL")
			{
				myComment = MyGetMyComment(MyGetFuncName(tempStr))
				if(myComment != "")
				{
					myComment = cat("/* ",myComment)
					myComment = cat(myComment," */ ")
					PutBufLine (hbuf, ln, cat(myComment,tempStr))
				}
			}
		}
		ln = ln + 1
	}
}

//�滻#ifdef #ifndef Ϊ#if defined()��#if !defined()
macro DefMacroReplace()
{
	hbuf	=	GetCurrentBuf()
	lineCount	=	GetBufLineCount (hbuf)
	ln = 0
    while(ln < lineCount){
		tempStr	=GetBufLine (hbuf, ln)
	    ReplaceOldIfLine(hbuf,ln,tempStr)
		ln = ln + 1
	}
}

//������ϵ�if�궨���У����滻�����򲻱䡣
//��ǰ���м��ע�͵Ĳ��У����ܻ����
macro ReplaceOldIfLine(hbuf,ln,lineBuf)
{
    spaceInHead = 0
    isIfdef = False
    lenIfdef = strlen("#ifdef")
    lenIfndef = strlen("#ifndef")
    macroStart = 0
    macroEnd = 0
    otherStart = 0
    i = 0

    n = strlen(lineBuf)
    if(n == 0)
        return 0
    while( lineBuf[i] == " " || lineBuf[i] == "\t" ){
    	i = i + 1
    }
    spaceInHead = i

    if(lineBuf[i] != "#")
        return 0
    if ((n - i)<lenIfndef)
        return 0
    if( strmid (lineBuf, spaceInHead, spaceInHead+lenIfdef) == "#ifdef")
    {
        isIfdef = True
        i = i + lenIfdef
    }
    else if( strmid (lineBuf, spaceInHead, spaceInHead+lenIfndef) == "#ifndef")
    {
        isIfdef = False
        i = i + lenIfndef
    }
    else
    {
        return 0
    }

    while( lineBuf[i] == " " || lineBuf[i] == "\t" ){
    	i = i + 1
    }
    if ((n - i)< 1)
        return 0

    macroStart = i
    while(isupper(lineBuf[i])||islower(lineBuf[i])||IsNumber(lineBuf[i])|| lineBuf[i] == "_" ){
    	i = i + 1
    	if(i == n)
    	    break
    }
    macroEnd = i
    if(macroStart == macroEnd)
        return 0

    if(macroEnd < n)
    {
        otherStart = macroEnd
    }

    if(spaceInHead != 0)
    {
        str1= strtrunc(lineBuf,spaceInHead)
    }
    else
    {
        str1 = ""
    }

    if(isIfdef)
        str2 = "#if defined("
    else
        str2 = "#if !defined("

    str3 = strmid (lineBuf, macroStart, macroEnd)

    if(otherStart != 0)
    {
        str4 = cat(")",strmid (lineBuf, otherStart, n))
    }
    else
    {
        str4 = ")"
    }
    PutBufLine (hbuf, ln, cat(str1,cat(str2,cat(str3,str4))))
}

//����if��������
//���������ļ���ȫû�������ĺ궨�壬�Ѿ��в��������Ĵ�����������⡣
macro DefMacroIndent()
{
	hbuf	=	GetCurrentBuf()
	lineCount	=	GetBufLineCount (hbuf)
	ln = 0
	indentNum = 0

    while(ln < lineCount){
	    indentNum = IndentMacroIfLine(hbuf,ln,indentNum)
		ln = ln + 1
	}

}

//�ڵ�ǰ�в���indentNum��������������#if�궨���������
macro IndentMacroIfLine(hbuf,ln,indentNum)
{
    tempStr	=GetBufLine (hbuf, ln)
    lineLen = strlen(tempStr)
    MacroHeadBuf = ""
    indentStr = ""

    if(lineLen == 0) return indentNum

    MacroHeadBuf = GetCMacroHead(tempStr)
    if(MacroHeadBuf == "")
    {
        indentStr = GetIndentSpace(indentNum)
        PutBufLine (hbuf, ln, cat(indentStr,tempStr))
    }
    else if(MacroHeadBuf == "#if")
    {
        indentStr = GetIndentSpace(indentNum)
        PutBufLine (hbuf, ln, cat(indentStr,tempStr))
        indentNum = indentNum + 1
    }
    else if(MacroHeadBuf == "#el")
    {
        if(indentNum>0)
        {
            indentStr = GetIndentSpace(indentNum-1)
            PutBufLine (hbuf, ln, cat(indentStr,tempStr))
        }
        else
        {
            msg("Error in #el:",ln,indentNum)
        }
    }
    else if(MacroHeadBuf == "#en")
    {
        if(indentNum>0)
        {
            indentNum = indentNum - 1
            indentStr = GetIndentSpace(indentNum)
            PutBufLine (hbuf, ln, cat(indentStr,tempStr))
        }
        else
        {
            msg("Error in #en:",ln,indentNum)
        }
    }
    else
    {
        PutBufLine (hbuf, ln, cat(GetIndentSpace(indentNum),tempStr))
    }
    return indentNum
}

//���������������������ո��ַ���
macro GetIndentSpace(indentNum)
{
    tempStr = ""
    i=0
    while(i<indentNum)
    {
        tempStr = cat(tempStr,"    ")
        i = i + 1
    }
    return tempStr
}

macro DefMacroCheck()
{
    hwbuf = NewBuf("DefMacro.h")
	hbuf	=	GetCurrentBuf()
	lineCount	=	GetBufLineCount (hbuf)
	ln = 0
    while(ln < lineCount){
		tempStr	=GetBufLine (hbuf, ln)
		MacroHeadBuf = GetCMacroHead(tempStr)
		if((MacroHeadBuf == "#if") || (MacroHeadBuf == "#el") || (MacroHeadBuf == "#en"))
		{
		    InsBufLine (hwbuf, ln, tempStr)
		}
		else
		{
		    InsBufLine (hwbuf, ln, "")
		}
		ln = ln + 1
	}
	SetCurrentBuf(hwbuf) // put search results in a window
}


/*Test */
macro Test()
{
	//msz	= "abcdef"
	//Msg(strtrunc(msz,3))	//"abc"
	//hbuf = GetCurrentBuf()
	//Msg(GetBufName(hbuf))
	//Msg(FileName(GetBufName(hbuf)))
	//Msg(CurTime())
	//InsertFileDeclare()
	//fn = "abc.h"
	//temp = GuardText(fn)
	//Msg(temp)
	//Msg(fn)
	//InsertGuardMacro()
	//FixedBugCommentOne()
	//AddCazMark2()
	//AddCazBlockMark()
	//CommentSharp();
	//CloseWndTest()
	//RemainLast10()
	//GetFullFileName()
	//InsertMyComment()
	//DefMacroReplace()
	DefMacroIndent()
	//DefMacroCheck()
}
