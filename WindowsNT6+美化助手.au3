#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#PRE_Icon=Tool.ico
#PRE_Outfile=WindowsNT6+美化助手.exe
#PRE_Outfile_x64=WindowsNT6+美化助手_x64.exe
#PRE_Compile_Both=y
#PRE_Res_Comment=Windows NT6+美化助手
#PRE_Res_Description=Windows NT6+美化助手
#PRE_Res_Fileversion=2.0.2.5
#PRE_Res_LegalCopyright=虫子樱桃
#PRE_Res_Language=2052
#PRE_Res_requestedExecutionLevel=highestAvailable
#PRE_Antidecompile=y
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <Misc.au3>
#include <File.au3>
#include <ButtonConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <StaticConstants.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <WinAPIEx.au3>
If $cmdline[0] <> 0 Then
	If StringInStr(FileGetAttrib($cmdline[1]), 'D') Then
		$cmdDir = $cmdline[1]
	Else
		MsgBox(16, '错误', '本工具只支持将文件夹作为传入参数！')
	EndIf
EndIf
If _Singleton(@ScriptName, 1) = 0 Then
	MsgBox(0, "额，亲", "WindowsNT6+美化助手貌似已经在运行咯哦！", 5)
	Exit
EndIf
Local $Is_sucess = False, $NeedReboot = False
Opt("GUIOnEventMode", 1)
HotKeySet("!{r}", "RebuildUI")
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
TraySetToolTip("WindowsNT6+美化助手 V" & FileGetVersion(@ScriptFullPath) & "By 虫子樱桃")
$tools = TrayCreateMenu("常用功能")
TrayCreateItem("还原备份的美化文件", $tools)
TrayItemSetOnEvent(-1, "RestoreFiles")
$tools2 = TrayCreateMenu("美化辅助工具", $tools)
TrayCreateItem("Res及dll批量提取工具", $tools2)
TrayItemSetOnEvent(-1, "BuildIco")
TrayCreateItem("SkinPack美化包制作Res包辅助工具", $tools2)
TrayItemSetOnEvent(-1, 'SinPackUI')
TrayCreateItem("Imageres.dll美化res预处理工具", $tools2)
TrayItemSetOnEvent(-1, 'AddSurport2k8')
TrayCreateItem("Imageres.dll图片大小批量调整生成", $tools2)
TrayItemSetOnEvent(-1, 'MutiResizingUI')
TrayCreateItem("文件权限快速获取辅助工具", $tools2)
TrayItemSetOnEvent(-1, "AdminRightTool")
TrayCreateItem("强制清理挂载失败的wim目录", $tools2)
TrayItemSetOnEvent(-1, "WimCleanTool")
TrayCreateItem("WindowsNT5安装版美化工具", $tools2)
TrayItemSetOnEvent(-1, 'WinNT5MHUI')
$orbfunc = TrayCreateItem("修改开始菜单图标", $tools2)
TrayItemSetOnEvent(-1, "ChangeOrb")
$changeFonts = TrayCreateItem("修改windows对话框默认字体", $tools2)
TrayItemSetOnEvent(-1, "ChangeFont")
$rebuldiconcache = TrayCreateMenu("图标缓存清理", $tools2)
TrayCreateItem("重建图标与系统MUI缓存[简易版]", $rebuldiconcache)
TrayItemSetOnEvent(-1, "cleaniconcache")
TrayCreateItem("重建图标与系统MUI缓存[强效版]", $rebuldiconcache)
TrayItemSetOnEvent(-1, "ForceRebuildIconCache")
TrayCreateItem("关机/重启", $tools)
TrayItemSetOnEvent(-1, "bootpc")
$about = TrayCreateMenu("关于")
TrayCreateItem("关于工具", $about)
TrayItemSetOnEvent(-1, "AboutDlg")
TrayCreateItem("作者博客", $about)
TrayItemSetOnEvent(-1, "authorblog")
TrayCreateItem("赞助我", $about)
TrayItemSetOnEvent(-1, "donetMe")
TrayCreateItem("更多精美图标", $about)
TrayItemSetOnEvent(-1, "DTU")
$QuitTrayMenu = TrayCreateItem("退出工具")
TrayItemSetOnEvent(-1, "QuitTool")
;GUI
If @OSVersion <> 'WIN_2008R2' And @OSVersion <> 'WIN_7' And @OSVersion <> 'WIN_2008' And @OSVersion <> 'WIN_VISTA' Then
	TrayItemDelete($orbfunc)
EndIf
$Form1 = _GUICreate("Windows NT6+美化工具V" & FileGetVersion(@ScriptFullPath), 499, 225, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE))
GUICtrlCreateGroup("美化基础设定", 8, 8, 201, 129)
$ResDir = GUICtrlCreateInput("", 16, 48, 145, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
If IsDeclared('cmdDir') Then GUICtrlSetData(-1, $cmdDir)
$MhTarget = GUICtrlCreateInput("", 15, 103, 145, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$NonMLabl = GUICtrlCreateLabel("当前 " & StringReplace(@OSVersion, "WIN_", "Windows ") & '操作系统', 16, 103, 190, 17)
GUICtrlCreateLabel("美化资源文件位置", 16, 27, 100, 17)
GUICtrlCreateLabel("美化目标位置", 16, 80, 76, 17)
$LocateTagert = GUICtrlCreateButton("....", 168, 102, 35, 25)
GUICtrlSetOnEvent(-1, 'LocateDestDir')
$LocateRes = GUICtrlCreateButton("....", 168, 48, 35, 25)
GUICtrlSetOnEvent(-1, 'LocateResDir')
$OptLive = GUICtrlCreateRadio("当前系统", 16, 144, 81, 17)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, 'ModeSwitch')
$OptOffine = GUICtrlCreateRadio("离线系统", 112, 144, 105, 17)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetOnEvent(-1, 'ModeSwitch')
$MakeInsWhenMh = GUICtrlCreateCheckbox("美化系统的同时，生成可自动安装的美化包", 224, 16, 257, 17)
GUICtrlSetOnEvent(-1, 'MutiDiff')
$OnlyInstaller = GUICtrlCreateCheckbox("仅生成美化包安装包，不美化系统", 224, 40, 257, 17)
GUICtrlSetOnEvent(-1, 'MutiDiff')
$Processbar = GUICtrlCreateLabel('', 0, 174, 24, 12)
GUICtrlSetBkColor(-1, 0x3399FF)
GUICtrlSetColor(-1, 0xFFFFFF)
FileInstall('file\99.ico', @TempDir & '\', 1)
$czyt = GUICtrlCreateIcon(@TempDir & "\99.ico", -1, 0, 174, 24, 24)
$startMH = GUICtrlCreateButton("开始美化", 224, 136, 107, 25)
GUICtrlSetOnEvent(-1, 'MhMain')
$QuitBtn = GUICtrlCreateButton("退出工具", 336, 136, 155, 25)
GUICtrlSetOnEvent(-1, 'QuitTool')
$PatchTheme = GUICtrlCreateCheckbox("破解系统主题", 224, 64, 97, 17)
GUICtrlSetTip(-1, '勾选此项以破解系统主题', '提示', 1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState(-1, $GUI_HIDE)
$OffineOSIsWin8Plus = GUICtrlCreateCheckbox("目标系统是Windows8及后续版本系统", 224, 88, 220, 17)
GUICtrlSetTip(-1, '因Windows8及后续版本系统存在文件' & @LF & '数字校验，需要使用软件内置白名版', '提示', 1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState(-1, $GUI_HIDE)
$PatchWaterMark = GUICtrlCreateCheckbox("移除系统水印", 224, 88, 97, 17)
GUICtrlSetTip(-1, '勾选此项以移除测试模式下的水印', '提示', 1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState(-1, $GUI_HIDE)
$PatchAeroGlass = GUICtrlCreateCheckbox("允许使用AeroGlass效果", 224, 112, 185, 17)
GUICtrlSetTip(-1, '勾选此项以破解当前系统AeroGlass限制', '提示', 1)
GUICtrlSetState(-1, $GUI_HIDE)
$DealWithLoginPic = GUICtrlCreateCheckbox("处理登录界面图像", 224, 112, 185, 17)
GUICtrlSetTip(-1, '勾选此项以处理Imagere.dll中的' & @LF & '登录界面实现完美美化！', '提示', 1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState(-1, $GUI_HIDE)
$StatusBar = _GUICtrlStatusBar_Create($Form1)
ModeSwitch()
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitTool', $Form1)
While 1
	Sleep(100)
WEnd

;退出工具
Func QuitTool()
	Exit
EndFunc   ;==>QuitTool
Func DirCheck()
	If Not StringInStr(FileGetAttrib(GUICtrlRead(@GUI_DropId)), 'D') Then
		GUICtrlSetData(@GUI_DropId, '')
		MsgBox(0, '', '请拖到文件夹到该输入框！', 5)
	EndIf
EndFunc   ;==>DirCheck
;模式切换
;若返回1 ，则表示需要显示破解AeroGlas
;返回2，则表示当前为服务器版本系统，需要对Imageres进行预处理以使登录界面可以被美化
;返回0，则隐藏最后破解的选项
Func ModeSwitch()
	$PatchType = PatchDetect()
	If GUICtrlRead($OptLive) = $GUI_CHECKED Then
		GUICtrlSetData($MhTarget, @HomeDrive)
		GUICtrlSetState($MhTarget, $GUI_HIDE)
		GUICtrlSetState($LocateTagert, $GUI_HIDE)
		GUICtrlSetState($PatchTheme, $GUI_SHOW)
		GUICtrlSetState($OffineOSIsWin8Plus, $GUI_HIDE)
		GUICtrlSetState($PatchWaterMark, $GUI_SHOW)
		GUICtrlSetState($NonMLabl, $GUI_SHOW)
		If $PatchType = 1 Then
			GUICtrlSetState($DealWithLoginPic, $GUI_HIDE)
			GUICtrlSetState($PatchAeroGlass, $GUI_SHOW)
			GUICtrlSetPos($DealWithLoginPic, 224, 112)
			GUICtrlSetPos($PatchAeroGlass, 224, 112)
		EndIf
		If $PatchType = 2 Then
			GUICtrlSetState($DealWithLoginPic, $GUI_CHECKED)
			GUICtrlSetState($PatchAeroGlass, $GUI_HIDE)
			GUICtrlSetState($DealWithLoginPic, $GUI_SHOW)
			GUICtrlSetPos($DealWithLoginPic, 224, 112)
			GUICtrlSetPos($PatchAeroGlass, 224, 112)
		EndIf
		If $PatchType = 0 Then
			GUICtrlSetState($DealWithLoginPic, $GUI_SHOW)
			GUICtrlSetPos($DealWithLoginPic, 224, 112)
			GUICtrlSetPos($PatchAeroGlass, 224, 112)
		EndIf
	EndIf
	If GUICtrlRead($OptOffine) = $GUI_CHECKED Then
		GUICtrlSetPos($DealWithLoginPic, 224, 64)
		GUICtrlSetData($MhTarget, '')
		GUICtrlSetState($MhTarget, $GUI_SHOW)
		GUICtrlSetState($LocateTagert, $GUI_SHOW)
		GUICtrlSetState($PatchTheme, $GUI_HIDE)
		GUICtrlSetState($PatchWaterMark, $GUI_HIDE)
		GUICtrlSetState($OffineOSIsWin8Plus, $GUI_SHOW)
		GUICtrlSetState($NonMLabl, $GUI_HIDE)
		GUICtrlSetState($PatchAeroGlass, $GUI_HIDE)
		GUICtrlSetState($DealWithLoginPic, $GUI_SHOW)
	EndIf
	;windows8+系统，额，这些都隐藏..
	If @OSBuild > 8000 Then
		GUICtrlSetState($PatchTheme, $GUI_HIDE)
		GUICtrlSetState($PatchWaterMark, $GUI_HIDE)
		GUICtrlSetState($PatchAeroGlass, $GUI_HIDE)
		GUICtrlSetState($DealWithLoginPic, $GUI_HIDE)
	EndIf
EndFunc   ;==>ModeSwitch

;选择资源文件夹
Func LocateResDir()
	Local $ResDirStr = FileSelectFolder('请选择您要使用的美化资源文件所在路径', '', 2 + 4)
	If $ResDirStr <> '' Then
		GUICtrlSetData($ResDir, $ResDirStr)
	Else
		MsgBox(16, '错误', '请选择正确的资源文件夹！！', 5, $Form1)
	EndIf
EndFunc   ;==>LocateResDir

;选择美化目标文件夹
Func LocateDestDir()
	Local $DestDir = FileSelectFolder('请选择您要进行美化的系统目录', '', 2 + 4)
	If $DestDir <> '' Then
		GUICtrlSetData($MhTarget, $DestDir)
	Else
		MsgBox(16, '错误', '请选择正确的系统目录文件夹！！', 5, $Form1)
	EndIf
EndFunc   ;==>LocateDestDir

;复选框两个模式互斥
;$MakeInsWhenMh $OnlyInstaller
Func MutiDiff()
	If @GUI_CtrlId = $MakeInsWhenMh Or $OnlyInstaller Then
		If @GUI_CtrlId = $MakeInsWhenMh Then
			GUICtrlSetState($OnlyInstaller, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($MakeInsWhenMh, $GUI_UNCHECKED)
		EndIf
	EndIf
EndFunc   ;==>MutiDiff
Func TrayDisable()
	TrayItemSetState($tools, $TRAY_DISABLE)
	TrayItemSetState($rebuldiconcache, $TRAY_DISABLE)
	TrayItemSetState($tools2, $TRAY_DISABLE)
	TrayItemSetState($orbfunc, $TRAY_DISABLE)
	TrayItemSetState($about, $TRAY_DISABLE)
	TrayItemSetState($QuitTrayMenu, $TRAY_DISABLE)
EndFunc   ;==>TrayDisable
Func TrayEnable()
	TrayItemSetState($tools, $TRAY_ENABLE)
	TrayItemSetState($rebuldiconcache, $TRAY_ENABLE)
	TrayItemSetState($tools2, $TRAY_ENABLE)
	TrayItemSetState($orbfunc, $TRAY_ENABLE)
	TrayItemSetState($about, $TRAY_ENABLE)
	TrayItemSetState($QuitTrayMenu, $TRAY_ENABLE)
EndFunc   ;==>TrayEnable
Func DisAllCtrl()
	;控件状态设定
	GUICtrlSetState($ResDir, $GUI_DISABLE)
	GUICtrlSetState($MhTarget, $GUI_DISABLE)
	GUICtrlSetState($LocateTagert, $GUI_DISABLE)
	GUICtrlSetState($LocateRes, $GUI_DISABLE)
	GUICtrlSetState($OptLive, $GUI_DISABLE)
	GUICtrlSetState($OptOffine, $GUI_DISABLE)
	GUICtrlSetState($MakeInsWhenMh, $GUI_DISABLE)
	GUICtrlSetState($OnlyInstaller, $GUI_DISABLE)
	GUICtrlSetState($PatchTheme, $GUI_DISABLE)
	GUICtrlSetState($PatchWaterMark, $GUI_DISABLE)
	GUICtrlSetState($PatchAeroGlass, $GUI_DISABLE)
	GUICtrlSetState($DealWithLoginPic, $GUI_DISABLE)
	GUICtrlSetState($startMH, $GUI_DISABLE)
	GUICtrlSetState($QuitBtn, $GUI_DISABLE)
	;;托盘菜单状态
	TrayDisable()
EndFunc   ;==>DisAllCtrl

Func EnAllCtrl()
	;切换控件状态
	GUICtrlSetState($ResDir, $GUI_ENABLE)
	GUICtrlSetState($MhTarget, $GUI_ENABLE)
	GUICtrlSetState($LocateTagert, $GUI_ENABLE)
	GUICtrlSetState($LocateRes, $GUI_ENABLE)
	GUICtrlSetState($OptLive, $GUI_ENABLE)
	GUICtrlSetState($OptOffine, $GUI_ENABLE)
	GUICtrlSetState($MakeInsWhenMh, $GUI_ENABLE)
	GUICtrlSetState($OnlyInstaller, $GUI_ENABLE)
	GUICtrlSetState($PatchTheme, $GUI_ENABLE)
	GUICtrlSetState($PatchWaterMark, $GUI_ENABLE)
	GUICtrlSetState($PatchAeroGlass, $GUI_ENABLE)
	GUICtrlSetState($DealWithLoginPic, $GUI_ENABLE)
	GUICtrlSetState($startMH, $GUI_ENABLE)
	GUICtrlSetState($QuitBtn, $GUI_ENABLE)
	TrayEnable()
EndFunc   ;==>EnAllCtrl
;根据RES自动匹配目标目录形成res资源树
Func GenerateResTree()
	Local $ResDirStr = GUICtrlRead($ResDir)
	Local $MhTargetStr = GUICtrlRead($MhTarget)
	If $ResDirStr = '' Or Not FileExists($ResDirStr) Then
		MsgBox(16, '错误', '请选择正确的资源文件夹！', 5, $Form1)
		Return
	EndIf
	If GUICtrlRead($OptOffine) = $GUI_CHECKED Then
		If $MhTargetStr = '' Or Not FileExists($MhTargetStr) Then
			MsgBox(16, '错误', '请选择正确的美化目标文件夹！', 5, $Form1)
			Return
		EndIf
	EndIf
	DisAllCtrl()
	Local $DirArry[42] = [$MhTargetStr & "\Program Files (x86)\Common Files\microsoft shared\MSInfo", $MhTargetStr & "\Program Files (x86)\Internet Explorer", $MhTargetStr & "\Program Files (x86)\Windows Mail", $MhTargetStr & "\Program Files (x86)\Windows Photo Gallery", $MhTargetStr & "\Program Files (x86)\Windows Media Player", $MhTargetStr & "\Program Files (x86)\Windows NT\Accessories", $MhTargetStr & "\Program Files (x86)\Windows Photo Viewer", $MhTargetStr & "\Program Files (x86)\Windows Sidebar", $MhTargetStr & "\windows\SystemResources", $MhTargetStr & "\windows\Branding\Basebrd\en-us", $MhTargetStr & "\windows\Branding\ShellBrd", $MhTargetStr & "\windows\System32", $MhTargetStr & "\windows\System32\zh-CN", $MhTargetStr & "\windows\System32\en-us", $MhTargetStr & "\windows\System32\migwiz", $MhTargetStr & "\windows\System32\Speech\SpeechUX", $MhTargetStr & "\Program Files (x86)\Windows Defender", $MhTargetStr & "\Program Files (x86)\Windows Journal", $MhTargetStr & "\Program Files (x86)\DVD Maker", $MhTargetStr & "\Program Files\Common Files\microsoft shared\MSInfo", $MhTargetStr & "\Program Files\Internet Explorer", $MhTargetStr & "\Program Files\Windows Mail", $MhTargetStr & "\Program Files\Windows Photo Gallery", $MhTargetStr & "\Program Files\Windows Media Player", $MhTargetStr & "\Program Files\Windows NT\Accessories", $MhTargetStr & "\Program Files\Windows Photo Viewer", $MhTargetStr & "\Program Files\Windows Sidebar", $MhTargetStr & "\windows", $MhTargetStr & "\windows\Branding\Basebrd\zh-CN", $MhTargetStr & "\windows\Branding\Basebrd\en-us", $MhTargetStr & "\windows\Branding\Basebrd", $MhTargetStr & "\windows\Branding\ShellBrd",$MhTargetStr & "\Windows\SystemResources", $MhTargetStr & "\windows\SysWOW64", $MhTargetStr & "\windows\SysWOW64\zh-CN", $MhTargetStr & "\windows\SysWOW64\en-us", $MhTargetStr & "\windows\SysWOW64\migwiz", $MhTargetStr & "\windows\SysWOW64\Speech\SpeechUX", $MhTargetStr & "\windows\ehome", $MhTargetStr & "\Program Files\Windows Defender", $MhTargetStr & "\Program Files\Windows Journal", $MhTargetStr & "\Program Files\DVD Maker"]
	Local $aWin8Whitelist[39] = ["speechuxcpl.dll", "accessibilitycpl.dll", "ActionCenterCPL.dll", "autoplay.dll", "colorcpl.exe", "DeviceCenter.dll", "DiagCpl.dllDiagCpl.dll", "Display.dllDisplay.dll", "FirewallControlPanel.dll", "devmgr.dll", "fontext.dll","imageres.dll.mun", "imageres.dll", "imagesp1.dll", "inetcpl.cpl", "intl.cpl", "main.cpl", "mmsys.cpl", "msinfo32.exe", "netcenter.dll", "notepad.exe", "powercpl.dll", "sdcpl.dll", "SensorsCpl.dll", "srchadmin.dll", "SyncCenter.dll", "taskbarcpl.dll", "telephon.cpl", "themecpl.dll", "timedate.cpl", "TSWorkspace.dll", "usercpl.dll", "Vault.dll", "wpccpl.dll", "wucltux.dll", "shellbrd.dll", "wordpad.exe","shellbrd.dll","systemcpl.dll.mui"]
	;模式自动切换，若选择的资源文件夹存在子目录，则与用户进行交互，提示是否调用替换，若不存在子目录，则直接创建资源树进行处理
	Local $ResDirSubNum = _FileListToArray($ResDirStr, "*", 2)
	;如果没检索到文件夹
	If $ResDirSubNum = 0 Then
		DirRemove(@TempDir & '\MHTemp', 1)
		;无子文件夹
		Local $ResFileArry = _FileListToArray($ResDirStr, "*.res", 1)
		;创建文件扩展名数组
		Local $ExtendArry[5] = ['mun', 'exe', 'dll', 'MUI',""]
		;枚举目录及res文件
		Local $n = 1, $Done = 0
		For $dir In $DirArry
			For $res In $ResFileArry
				;不论是处理离线还是当前系统，都检查是否要对Imagere.dll中的图像进行处理
				If StringInStr($res, 'imageres') Then
					;处理imagreres
					If GUICtrlRead($DealWithLoginPic) = $GUI_CHECKED Then
						If $Done = 0 Then
							If Not FileExists(@TempDir & '\reshacker.exe') Then
								FileInstall('file\reshacker.exe', @TempDir & '\', 1)
							EndIf
							;开始处理jpg图片
							;解包图片
							DirRemove(@TempDir & '\FileTempDir', 1)
							DirCreate(@TempDir & '\FileTempDir')
							GUICtrlSetPos($czyt, 20)
							GUICtrlSetPos($Processbar, 0, 178, 20, 12)
							_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]解包登录界面图像...', 0, $SBT_NOBORDERS)
							For $k = 5031 To 5038
								RunWait(@TempDir & '\reshacker.exe -extract "' & $ResDirStr & '\' & $res & '",' & $k + 13 & '.jpg,IMAGE,' & $k & ',', @TempDir & '\FileTempDir', @SW_HIDE)
							Next
							_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]处理解包登录界面图像...', 0, $SBT_NOBORDERS)
							For $j = 5044 To 5051
								If FileExists(@TempDir & '\FileTempDir\' & $j & '.jpg') Then
									RunWait(@TempDir & '\reshacker.exe  -addoverwrite "' & $ResDirStr & '\' & $res & '","' & $ResDirStr & '\' & $res & '",' & $j & '.jpg,IMAGE,' & $j & ',1033', @TempDir & '\FileTempDir', @SW_HIDE)
								EndIf
							Next
							DirRemove(@TempDir & '\FileTempDir', 1)
							GUICtrlSetPos($czyt, 40)
							GUICtrlSetPos($Processbar, 0, 178, 40, 12)
							_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]完成登录界面图像预处理...', 0, $SBT_NOBORDERS)
							$Done = 1
						EndIf
					EndIf
				EndIf
				For $Ext In $ExtendArry
					Local $nFilefind = 0
					If FileExists($dir & '\' & StringRegExpReplace($res, '.{3}$', $Ext)) Then $nFilefind = 1
					If FileExists(StringRegExpReplace($res, '.{4}$', '')) Then $nFilefind = 2
					If $nFilefind <> 0 Then
						If @OSVersion = "WIN_81" Or @OSVersion = "WIN_8" Or @OSVersion = "WIN_10" Or @OSVersion = "WIN_2012R2" Or @OSVersion = "WIN_2012" Or @OSVersion = "WIN_2016" Or GUICtrlRead($OffineOSIsWin8Plus) = $GUI_CHECKED Then
							If _BNameIsInWhiteList(StringRegExpReplace($res, '.{3}$', $Ext), $aWin8Whitelist) Then
								If $nFilefind = 1 Then FileCopy($ResDirStr & '\' & $res, StringReplace($dir, $MhTargetStr, @TempDir & '\MHTemp') & '\' & StringRegExpReplace($res, '.{3}$', $Ext & 'res'), 1 + 8)
								If $nFilefind = 2 Then FileCopy($ResDirStr & '\' & $res, StringReplace($dir, $MhTargetStr, @TempDir & '\MHTemp') & '\' & $res, 1 + 8)
								_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]拷贝资源' & $res & '...(使用内置文件白名单)', 0, $SBT_NOBORDERS)
								If	$Ext="mun" And $nFilefind=1 Then
									ExitLoop
								EndIf
							EndIf
						Else
							If $nFilefind = 1 Then FileCopy($ResDirStr & '\' & $res, StringReplace($dir, $MhTargetStr, @TempDir & '\MHTemp') & '\' & StringRegExpReplace($res, '.{3}$', $Ext & 'res'), 1 + 8)
							If $nFilefind = 2 Then FileCopy($ResDirStr & '\' & $res, StringReplace($dir, $MhTargetStr, @TempDir & '\MHTemp') & '\' & $res, 1 + 8)
							_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]拷贝资源' & $res & '...', 0, $SBT_NOBORDERS)
						EndIf
						GUICtrlSetPos($czyt, 2 * ($n / $ResFileArry[0]))
						GUICtrlSetPos($Processbar, 0, 178, 2 * ($n / $ResFileArry[0]), 12)
					EndIf
				Next
				$n += 1
			Next
		Next
		_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]资源拷贝及目录树建立完成..', 0, $SBT_NOBORDERS)
	Else
		;包含子文件夹，故需要提醒不能在Res资源文件夹中放入其他的文件夹..
		Local $choice = MsgBox(4, '友情提示', '检测到您选择的资源文件夹存在子文件夹' & @LF & '是否直接调用进行美化？', 5, $Form1)
		If $choice = 6 Then
			DirRemove(@TempDir & '\MHTemp', 1)
			DirCreate(@TempDir & '\MHTemp')
			DirCopy($ResDirStr, @TempDir & '\MHTemp', 1)
		EndIf
	EndIf
	EnAllCtrl()
	$Is_sucess = True
EndFunc   ;==>GenerateResTree
Func _BNameIsInWhiteList($TestStr, $aWhitelist)
	If IsArray($aWhitelist) Then
		For $x In $aWhitelist
			If StringInStr($x, $TestStr) Then Return True
			If StringInStr($TestStr, $x) Then Return True
		Next
	EndIf
EndFunc   ;==>_BNameIsInWhiteList
Func MhInfoSetUI()
	Global $MHinfoForm = _GUICreate("美化包信息设置", 349, 127, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $Form1)
	GUICtrlCreateLabel("美化包名称：", 16, 16, 76, 17)
	Global $InsName = GUICtrlCreateInput("", 96, 16, 225, 21)
	GUICtrlCreateGroup("美化包版本", 16, 40, 305, 49)
	Global $X64 = GUICtrlCreateRadio("64位系统", 24, 64, 89, 17)
	Global $X86 = GUICtrlCreateRadio("32位系统", 112, 64, 113, 17)
	GUICtrlSetState(Eval(@OSArch), $GUI_CHECKED)
	Global $comfirmAndMake = GUICtrlCreateButton("确认并生成安装包", 16, 96, 307, 25)
	GUICtrlSetOnEvent(-1, 'ComfirmAndMake')
	GUISetState(@SW_SHOW, $MHinfoForm)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'CancelInstaller', $MHinfoForm)
EndFunc   ;==>MhInfoSetUI

Func CancelInstaller()
	GUISetState(@SW_HIDE, $MHinfoForm)
	GUIDelete($MHinfoForm)
	GUICtrlSetPos($czyt, 480)
	GUICtrlSetPos($Processbar, 0, 178, 480, 12)
	_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]用户取消了生成美化包安装包的操作...', 0, $SBT_NOBORDERS)
	EnAllCtrl()
	If $NeedReboot = True Then
		If MsgBox(4, '提示', '已经执行完所有既定操作！，是否重启？', 5) = 6 Then
			bootpc()
		EndIf
	Else
		MsgBox(0, '提示', '已经完成既定操作！', 5)
	EndIf
	Return 1
EndFunc   ;==>CancelInstaller
Func ComfirmAndMake()
	Local $UserInputInsName = GUICtrlRead($InsName)
	If $UserInputInsName = '' Then
		MsgBox(16, '', '安装包名称不可为空！', 5)
		Return
	EndIf
	If MsgBox(4, '提示', '是否使用"' & $UserInputInsName & '"作为美化包安装包名称？', 10) = 6 Then
		Global $InstallerTitleName = $UserInputInsName
		If StringInStr($InstallerTitleName,' ') Then
		   Global $InstallerProductName = StringReplace($InstallerTitleName,' ','')
	   Else
		   $InstallerProductName = $InstallerTitleName
		EndIf
		GUISetState(@SW_HIDE, $MHinfoForm)
	Else
		GUICtrlSetData($InsName, '')
		MsgBox(0, '提示', '请重新输入安装包名称，并进行确认！', 5)
		Return
	EndIf
	If IsDeclared('InstallerProductName') Then
		_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]开始生成进程,准备所需文件...', 0, $SBT_NOBORDERS)
		DirRemove(@TempDir & '\MHInsTemp', 1)
		DirCreate(@TempDir & '\MHInsTemp\MHTemp')
		If FileExists(@TempDir & '\MHTemp') Then
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]复制美化资源文件...', 0, $SBT_NOBORDERS)
			GUICtrlSetPos($czyt, 455)
			GUICtrlSetPos($Processbar, 0, 178, 455, 12)
			DirCopy(@TempDir & '\MHTemp', @TempDir & '\MHInsTemp\MHTemp', 1)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]准备RAR相关文件...', 0, $SBT_NOBORDERS)
			FileInstall('file\Rar.exe', @TempDir & '\', 1)
			FileInstall('file\rarreg.key', @TempDir & '\', 1)
			;优先使用脚本目录的自解压界面，方便用户DIY
			If FileExists(@ScriptDir & '\Default.sfx') Then
				FileCopy(@ScriptDir & '\Default.sfx', @TempDir & '\Default.sfx', 1)
			Else
				FileInstall('file\Default.sfx', @TempDir & '\', 1)
			EndIf
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]处理美化资源文件...', 0, $SBT_NOBORDERS)
			If GUICtrlRead($X64) = $GUI_CHECKED Then
				If Not FileExists(@TempDir & '\MHInsTemp\MHTemp\Windows\SysWow64') Then DirCreate(@TempDir & '\MHInsTemp\MHTemp\Windows\SysWow64')
				If Not FileExists(@TempDir & '\MHInsTemp\MHTemp\Program Files (x86)') Then DirCreate(@TempDir & '\MHInsTemp\MHTemp\Program Files (x86)')
				DirCopy(@TempDir & '\MHInsTemp\MHTemp\Windows\System32', @TempDir & '\MHTemp\MHInsTemp\Windows\SysWow64', 1)
				DirCopy(@TempDir & '\MHInsTemp\MHTemp\Program Files', @TempDir & '\MHInsTemp\MHTemp\Program Files (x86)')
				FileInstall('file\W7Patcher_x64.exe', @TempDir & '\MHInsTemp\W7Patcher.exe', 1)
				FileInstall('file\MHIns.exe', @TempDir & '\MHInsTemp\', 1)
			EndIf
			If GUICtrlRead($X86) = $GUI_CHECKED Then
				If FileExists(@TempDir & '\MHInsTemp\Windows\SysWow64') Then DirRemove(@TempDir & '\MHInsTemp\MHTemp\Windows\SysWow64', 1)
				If Not FileExists(@TempDir & '\MHInsTemp\MHTemp\Program Files (x86)') Then DirRemove(@TempDir & '\MHInsTemp\MHTemp\Program Files (x86)', 1)
				FileInstall('file\W7Patcher_x86.exe', @TempDir & '\MHInsTemp\W7Patcher.exe', 1)
				FileInstall('file\MHIns.exe', @TempDir & '\MHInsTemp\', 1)
			EndIf
			GUICtrlSetPos($czyt, 458)
			GUICtrlSetPos($Processbar, 0, 178, 458, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]生成打包配置文件...', 0, $SBT_NOBORDERS)
			Local $TEXT = ChrW(0x0000001A) & @CRLF & "Path=" & @TempDir & "\TempDir " & @CRLF & "SavePath" & @CRLF & "Setup=MHIns.exe" & @CRLF & "Overwrite=1" & @CRLF & "Title=" & $InstallerTitleName & " Icon Pack Installer"
			Local $fh = FileOpen(@TempDir & '\PackCfg.tmp', 2 + 8)
			FileWrite($fh, $TEXT)
			FileClose($fh)
			GUICtrlSetPos($czyt, 460)
			GUICtrlSetPos($Processbar, 0, 178, 460, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]打包美化包文件...', 0, $SBT_NOBORDERS)
			Local $RAR = FileGetLongName('"' & @TempDir & '\Rar.exe"')
			RunWait(@ComSpec & ' /c ' & $RAR & ' a -r -ac -k -m5 -s -t ' & $InstallerProductName & '.rar -c -z' & @TempDir & '\PackCfg.tmp', @TempDir & '\MHInsTemp', @SW_HIDE)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]生成EXE文件...', 0, $SBT_NOBORDERS)
			GUICtrlSetPos($czyt, 470)
			GUICtrlSetPos($Processbar, 0, 178, 470, 12)
			RunWait(@ComSpec & ' /c  ' & $RAR & ' s  ' & $InstallerProductName & '.rar', @TempDir & '\MHInsTemp', @SW_HIDE)
			FileMove(@TempDir & '\MHInsTemp\' & $InstallerProductName & '.exe', @DesktopDir & '\' & $InstallerProductName & '.exe')
			GUICtrlSetPos($czyt, 475)
			GUICtrlSetPos($Processbar, 0, 178, 475, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]清理无用文件...', 0, $SBT_NOBORDERS)
			FileDelete(@TempDir & '\Rar.exe')
			FileDelete(@TempDir & '\Default.sfx')
			FileDelete(@TempDir & '\rarreg.key')
			FileDelete(@TempDir & '\MHInsTemp')
			FileDelete(@TempDir & '\MHInsTemp' & $InstallerProductName & '.rar')
			GUICtrlSetPos($czyt, 480)
			GUICtrlSetPos($Processbar, 0, 178, 480, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]生成完毕...', 0, $SBT_NOBORDERS)
		Else
			_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]丢失美化资源文件，自动跳过打包操作！...', 0, $SBT_NOBORDERS)
			Return
		EndIf
		GUIDelete($MHinfoForm)
	Else
		_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]安装包名称为空，自动跳过生成操作...', 0, $SBT_NOBORDERS)
	EndIf
	GUICtrlSetPos($czyt, 490)
	GUICtrlSetPos($Processbar, 0, 178, 490, 12)
	_GUICtrlStatusBar_SetText($StatusBar, '[完成]完成所有操作...', 0, $SBT_NOBORDERS)
	EnAllCtrl()
	If $NeedReboot = True Then
		If MsgBox(4, '提示', '已经执行完所有既定操作！，是否重启？', 5) = 6 Then
			bootpc()
		EndIf
	Else
		MsgBox(0, '提示', '已经完成既定操作！', 5)
	EndIf
EndFunc   ;==>ComfirmAndMake


Func InsResFile()
	If $Is_sucess = False Then Return
	DisAllCtrl()
	_GUICtrlStatusBar_SetText($StatusBar, '[美化核心操作]释放美化所需文件..', 0, $SBT_NOBORDERS)
	If @OSArch = 'X86' Then
		FileInstall('file\W7Patcher_X86.exe', @TempDir & '\', 1)
	Else
		FileInstall('file\W7Patcher_X64.exe', @TempDir & '\', 1)
	EndIf
	;处理当前系统
	If GUICtrlRead($OnlyInstaller) = $GUI_UNCHECKED Then
		If GUICtrlRead($OptLive) = $GUI_CHECKED Then
			$NeedReboot = True
			_GUICtrlStatusBar_SetText($StatusBar, '[美化核心操作]调用程序执行美化..', 0, $SBT_NOBORDERS)
			If MsgBox(4, '友情提示', '在执行美化时，是否进行文件备份？', 5, $Form1) = 6 Then
				DirRemove(@HomeDrive & '\W7P_Backups', 1)
				GUICtrlSetPos($czyt, 460)
				GUICtrlSetPos($Processbar, 0, 178, 460, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]开始美化操作...', 0, $SBT_NOBORDERS)
				RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -P "MHTemp" -BN "MHBackUp"', @TempDir, @SW_HIDE)
				DirMove(@HomeDrive & '\W7P_Backups\MHBackUp', @DesktopDir & '\MHBackUp', 1)
				DirRemove(@HomeDrive & '\W7P_Backups', 1)
				GUICtrlSetPos($czyt, 462)
				GUICtrlSetPos($Processbar, 0, 178, 462, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]开始转移备份的系统文件...', 0, $SBT_NOBORDERS)
			Else
				GUICtrlSetPos($czyt, 465)
				GUICtrlSetPos($Processbar, 0, 178, 465, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]开始美化操作...', 0, $SBT_NOBORDERS)
				RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -P "MHTemp" -N', @TempDir, @SW_HIDE)
			EndIf
			If GUICtrlRead($PatchTheme) = $GUI_CHECKED Then
				GUICtrlSetPos($czyt, 464)
				GUICtrlSetPos($Processbar, 0, 178, 467, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]开始破解系统主题..', 0, $SBT_NOBORDERS)
				RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -PBIN1', @TempDir, @SW_HIDE)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]系统主题破解完成..', 0, $SBT_NOBORDERS)
			EndIf
			If GUICtrlRead($PatchWaterMark) = $GUI_CHECKED Then
				GUICtrlSetPos($czyt, 470)
				GUICtrlSetPos($Processbar, 0, 178, 470, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]开始尝试移除系统水印..', 0, $SBT_NOBORDERS)
				RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -PBIN5', @TempDir, @SW_HIDE)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]移除系统水印操作完成..', 0, $SBT_NOBORDERS)
			EndIf
			If GUICtrlRead($PatchAeroGlass) = $GUI_CHECKED Then
				GUICtrlSetPos($czyt, 475)
				GUICtrlSetPos($Processbar, 0, 178, 475, 12)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]开始尝试在当前系统破解AeroGlass使用限制..', 0, $SBT_NOBORDERS)
				RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -PBIN7', @TempDir, @SW_HIDE)
				_GUICtrlStatusBar_SetText($StatusBar, '[系统破解操作]破解AeroGlass操作限制操作完成..', 0, $SBT_NOBORDERS)
			EndIf
		EndIf
		;离线或挂载美化
		If GUICtrlRead($OptOffine) = $GUI_CHECKED Then
			$MhTargetStr = GUICtrlRead($MhTarget)
			GUICtrlSetPos($czyt, 362)
			GUICtrlSetPos($Processbar, 0, 178, 362, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[美化核心操作]调用程序执行美化..', 0, $SBT_NOBORDERS)
			RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -P "MHTemp" -D "' & $MhTargetStr & '" -N', @TempDir, @SW_HIDE)
			GUICtrlSetPos($czyt, 365)
			GUICtrlSetPos($Processbar, 0, 178, 365, 12)
			_GUICtrlStatusBar_SetText($StatusBar, '[美化核心操作]美化操作执行完毕..', 0, $SBT_NOBORDERS)
		EndIf
	EndIf
	If GUICtrlRead($OnlyInstaller) = $GUI_UNCHECKED Then
		GUICtrlSetPos($czyt, 450)
		GUICtrlSetPos($Processbar, 0, 178, 450, 12)
		_GUICtrlStatusBar_SetText($StatusBar, '[完成美化操作]完成美化操作,开始下一步操作..', 0, $SBT_NOBORDERS)
	Else
		GUICtrlSetPos($czyt, 450)
		GUICtrlSetPos($Processbar, 0, 178, 450, 12)
		_GUICtrlStatusBar_SetText($StatusBar, '[资源预处理]生成资源树完成，开始进行下一步操作......', 0, $SBT_NOBORDERS)
	EndIf
	If GUICtrlRead($MakeInsWhenMh) = $GUI_CHECKED Or GUICtrlRead($OnlyInstaller) = $GUI_CHECKED Then
		GUICtrlSetPos($czyt, 452)
		GUICtrlSetPos($Processbar, 0, 178, 452, 12)
		_GUICtrlStatusBar_SetText($StatusBar, '[生成美化包安装文件]请求用户输入美化包安装包名称...', 0, $SBT_NOBORDERS)
		MhInfoSetUI()
	Else
		GUICtrlSetPos($czyt, 490)
		GUICtrlSetPos($Processbar, 0, 178, 490, 12)
		_GUICtrlStatusBar_SetText($StatusBar, '[完成]完成所有操作...', 0, $SBT_NOBORDERS)
		EnAllCtrl()
		If $NeedReboot = True Then
			If MsgBox(4, '提示', '已经执行完所有既定操作！，是否重启？', 5) = 6 Then
				bootpc()
			EndIf
		Else
			MsgBox(0, '提示', '已经完成既定操作！', 5)
		EndIf
	EndIf
EndFunc   ;==>InsResFile


Func MhMain()
	GenerateResTree()
	InsResFile()
EndFunc   ;==>MhMain

Func PatchDetect()
	;若返回1 ，则表示需要显示破解AeroGlas
	;返回2，则表示当前为服务器版本系统，需要对Imageres进行预处理以使登录界面可以被美化
	;返回0，则隐藏最后破解的选项
	Local $Edition = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "EditionID")
	If @OSVersion = 'WIN_7' And (StringInStr($Edition, 'starter') Or StringInStr($Edition, 'Home')) Then
		Return 1
	EndIf
	If @OSVersion = 'WIN_2008' Or @OSVersion = 'WIN_2008R2' Then
		Return 2
	EndIf
	Return 0
EndFunc   ;==>PatchDetect

Func RebuildUI()
	GUISetState(@SW_HIDE, $Form1)
	Global $REbuiUI = _GUICreate("", 247, 90, -1, -1, BitOR($WS_POPUP, $WS_CLIPSIBLINGS))
	GUICtrlCreateGroup("选择重建图标缓存功能的版本", 8, 0, 225, 81)
	GUICtrlCreateButton("简易版", 24, 24, 83, 33)
	GUICtrlSetTip(-1, '调用软件内置功能实现')
	GUICtrlSetOnEvent(-1, 'cleaniconcache')
	GUICtrlCreateButton("强效版", 128, 24, 75, 33)
	GUICtrlSetTip(-1, '调用外部工具实现')
	GUICtrlSetOnEvent(-1, 'CallOuterTool')
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, 'ShowMain')
EndFunc   ;==>RebuildUI

Func CallOuterTool()
	If ForceRebuildIconCache() = 1 Then MsgBox(0, '提示', '请重启计算机或注销当前用户以重建当前计算机图标缓存！', 5)
EndFunc   ;==>CallOuterTool
Func ShowMain()
	GUISetState(@SW_HIDE, $REbuiUI)
	GUIDelete($REbuiUI)
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>ShowMain
;清理图标缓存函数，根据亮铁美化批处理修改
Func cleaniconcache()
	If @OSBuild < 8000 Then
		Run(@ComSpec & ' /c taskkill /im explorer.exe /f', "", @SW_HIDE)
		FileDelete(@UserProfileDir & "\appdata\local\iconcache.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_32.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_96.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_256.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_1024.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_idx.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\thumbcache_sr.db")
		FileDelete(@UserProfileDir & "\AppData\Local\Microsoft\Windows\Explorer\*.db")
		MsgBox(0, "嘻嘻", "图标缓存清理完毕！", 1)
		RunWait("mcbuilder.exe")
		MsgBox(0, "嘻嘻", "MUI缓存清理完毕！", 1)
		Run(@WindowsDir & "\explorer.exe")
	Else
		RunWait('ie4uinit.exe -ClearIconCache', @WindowsDir, @SW_HIDE)
		Local $choice = MsgBox(4, '虫子樱桃友情提示', '图标缓存清理工作完成！是否注销当前用户以生效？', 8)
		If $choice = 6 Or $choice = -1 Then
			Shutdown(4)
		Else
			MsgBox(0, '(*^__^*) 嘻嘻', '图标缓存将在注销或重启系统后重新刷新！', 5)
		EndIf
	EndIf
EndFunc   ;==>cleaniconcache

Func bootpc()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $Form2 = _GUICreate("嘻嘻，您是关机还是重启呢？", 340, 132, -1, -1, $Form1)
	GUICtrlCreateLabel("请在下面选择", 16, 16, 116, 17)
	GUICtrlCreateButton("关机吧！", 8, 48, 99, 49)
	GUICtrlSetOnEvent(-1, "downos")
	GUICtrlCreateButton("重启咯", 120, 48, 99, 49)
	GUICtrlSetOnEvent(-1, "rebos")
	GUICtrlCreateButton("啥都不做", 232, 48, 91, 49)
	GUICtrlSetOnEvent(-1, "exitthis")
	GUISetOnEvent($GUI_EVENT_CLOSE, "exitthis", $Form2)
	GUISetState(@SW_SHOW, $Form2)
EndFunc   ;==>bootpc
Func exitthis()
	GUISetState(@SW_SHOW, $Form1)
	GUIDelete($Form2)
	TrayEnable()
EndFunc   ;==>exitthis
;关机
Func downos()
	If MsgBox(4, "有爱的提示", "亲，是否立马关机，你的资料啥的保存好了么？") = 6 Then Shutdown(1 + 4)
EndFunc   ;==>downos
;重启
Func rebos()
	If MsgBox(4, "有爱的提示", "亲，是否立马重启，你的资料啥的保存好了么？") = 6 Then Shutdown(2 + 4)
EndFunc   ;==>rebos


Func authorblog()
	ShellExecute("http://czyt.blog.com")
EndFunc   ;==>authorblog

;图标功能辅助
Func BuildIco()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $IForm = _GUICreate("Res及dll批量提取工具", 564, 260, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	Global $Tab1 = GUICtrlCreateTab(0, 0, 561, 217)
	Global $TabSheet1 = GUICtrlCreateTabItem("Res批量提取")
	Global $DllPath = GUICtrlCreateInput("", 48, 82, 369, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateLabel("要提取的Dll文件所在目录", 48, 58, 176, 17)
	GUICtrlCreateButton("浏览", 424, 82, 59, 25)
	GUICtrlSetOnEvent(-1, 'SelectDllPath')
	GUICtrlCreateLabel("保存Res文件所在目录", 48, 114, 119, 17)
	Global $ResPath = GUICtrlCreateInput("", 48, 138, 369, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("浏览", 424, 138, 59, 25)
	GUICtrlSetOnEvent(-1, 'SelectResPath')
	GUICtrlCreateButton("提取", 520, 34, 43, 177)
	GUICtrlSetOnEvent(-1, 'MakeRes')
	Global $Model24 = GUICtrlCreateCheckbox("清理无用界面信息[24]", 152, 162, 137, 17)
	Global $Mui = GUICtrlCreateCheckbox("清理MUI模块[MUI]", 152, 186, 113, 17)
	Global $File = GUICtrlCreateCheckbox("FILE模块[FILE]", 296, 162, 105, 17)
	Global $UIfile = GUICtrlCreateCheckbox("UIFile模块[UIFILE]", 296, 186, 113, 17)
	Global $Xmlfile = GUICtrlCreateCheckbox("[XMLFILE]", 408, 162, 81, 17)
	Global $TabSheet2 = GUICtrlCreateTabItem("Dll资源批量提取")
	GUICtrlCreateGroup("选择目录", 8, 32, 473, 137)
	Global $DllDir = GUICtrlCreateInput("", 32, 72, 369, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("浏览", 408, 72, 43, 25)
	GUICtrlSetOnEvent(-1, 'SelectDllPath')
	Global $IcoDir = GUICtrlCreateInput("", 33, 124, 369, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("浏览", 412, 119, 43, 25)
	GUICtrlSetOnEvent(-1, 'SelectIcoPath')
	GUICtrlCreateLabel("要批量提取资源的Dll所在目录", 32, 48, 240, 17)
	GUICtrlCreateLabel("提取的资源保存目录", 32, 96, 183, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateButton("提取", 520, 32, 43, 177)
	GUICtrlSetOnEvent(-1, 'ReIcon')
	Global $ico = GUICtrlCreateCheckbox("提取图标文件", 32, 184, 89, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $cursor = GUICtrlCreateCheckbox("提取光标", 128, 184, 81, 17)
	Global $bmp = GUICtrlCreateCheckbox("提取位图", 224, 184, 73, 17)
	Global $avi = GUICtrlCreateCheckbox("提取AVI动画", 304, 184, 97, 17)
	GUICtrlCreateTabItem("")
	GUICtrlCreateLabel("WindowsNT6+美化助手 V" & FileGetVersion(@ScriptFullPath) & " By 虫子樱桃  ", 11, 231, 500, 17)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'abortTool', $IForm)
	GUISetOnEvent($GUI_EVENT_DROPPED, 'DirCheck', $IForm)
EndFunc   ;==>BuildIco

Func abortTool()
	GUISetState(@SW_HIDE, $IForm)
	GUIDelete($IForm)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>abortTool

Func SelectDllPath()
	GUICtrlSetData($DllPath, FileSelectFolder('请选择您要提取的Dll文件所在目录', ''))
EndFunc   ;==>SelectDllPath

Func SelectResPath()
	GUICtrlSetData($ResPath, FileSelectFolder('请选择您要提取的Res文件的保存目录', '', 5))
EndFunc   ;==>SelectResPath

Func SelectIcoPath()
	GUICtrlSetData($IcoDir, FileSelectFolder('请选择您要提取的资源文件的保存目录', '', 5))
EndFunc   ;==>SelectIcoPath

Func MakeRes()
	If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
	If FileExists(GUICtrlRead($DllPath)) And FileExists(GUICtrlRead($ResPath)) Then
		GUISetState(@SW_HIDE, $IForm)
		ToolTip(@LF & '正在获取文件列表...' & @LF, @DesktopWidth / 2 - 30, @DesktopHeight / 2)
		FileDelete(@AppDataCommonDir & '\MakeList.txt')
		RunWait(@ComSpec & ' /c dir /b /a-d /s | findstr ".dll$">>' & @AppDataCommonDir & '\MakeList.txt' & '& dir /b /a-d /s | findstr ".exe$" >>' & @AppDataCommonDir & '\MakeList.txt' & ' & dir /b /a-d /s | findstr ".mui$">>' & @AppDataCommonDir & '\MakeList.txt ' & '& dir /b /a-d /s | findstr ".cpl$>>"' & @AppDataCommonDir & '\MakeList.txt', GUICtrlRead($DllPath), @SW_HIDE)
		ToolTip(@LF & '正在读取文件列表...' & @LF, @DesktopWidth / 2 - 30, @DesktopHeight / 2)
		Local $lines = _FileCountLines(@AppDataCommonDir & '\MakeList.txt')
		If $lines = 0 Then
			ToolTip('')
			MsgBox(0, '', '额，您选择的是一个空文件夹，开玩笑呢..(*^__^*) 嘻嘻', 1)
		Else
			For $i = 1 To $lines
				Local $DllFile = FileReadLine(@AppDataCommonDir & '\MakeList.txt', $i)
				If Not StringInStr($DllFile, '\winsxs\') Then
					ToolTip(@LF & '共需要进行' & $lines & '次提取操作,现在正在提取第' & $i & '个文件' & $DllFile & @LF, @DesktopWidth / 2 - 120, @DesktopHeight / 2)
					If FileExists(GUICtrlRead($ResPath) & '\' & _WinAPI_PathFindFileName($DllFile) & '.res') Then
						FileDelete(GUICtrlRead($ResPath) & '\' & _WinAPI_PathFindFileName($DllFile) & '.res')
					EndIf
					RunWait(@TempDir & '\reshacker.exe -extract "' & $DllFile & '", "' & _WinAPI_PathFindFileName($DllFile) & '.res",,,', GUICtrlRead($ResPath), @SW_HIDE)
					RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', VersionInfo,,', GUICtrlRead($ResPath), @SW_HIDE)
					If GUICtrlRead($Model24) = $GUI_CHECKED Then
						RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', 24,,', GUICtrlRead($ResPath), @SW_HIDE)
					EndIf
					If GUICtrlRead($Mui) = $GUI_CHECKED Then
						RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', mui,,', GUICtrlRead($ResPath), @SW_HIDE)
					EndIf
					If GUICtrlRead($File) = $GUI_CHECKED Then
						RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', file,,', GUICtrlRead($ResPath), @SW_HIDE)
					EndIf
					If GUICtrlRead($UIfile) = $GUI_CHECKED Then
						RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', uifile,,', GUICtrlRead($ResPath), @SW_HIDE)
					EndIf
					If GUICtrlRead($Xmlfile) = $GUI_CHECKED Then
						RunWait(@TempDir & '\reshacker.exe -delete ' & _WinAPI_PathFindFileName($DllFile) & '.res, ' & _WinAPI_PathFindFileName($DllFile) & '.res' & ', xmlfile,,', GUICtrlRead($ResPath), @SW_HIDE)
					EndIf
					If FileGetSize(GUICtrlRead($ResPath) & '\' & _WinAPI_PathFindFileName($DllFile) & '.res') / 1024 < 1 Then
						FileDelete(GUICtrlRead($ResPath) & '\' & _WinAPI_PathFindFileName($DllFile) & '.res')
					EndIf
				EndIf
			Next
			ToolTip('')
			MsgBox(0, '(*^__^*) 嘻嘻', 'Res文件制作完成', 5)
		EndIf
		FileDelete(@AppDataCommonDir & '\MakeList.txt')
		GUISetState(@SW_SHOW, $IForm)
	Else
		MsgBox(0, '', 'Dll文件以及Res文件的目录必须实际存在！', 5)
	EndIf
EndFunc   ;==>MakeRes

Func ReIcon()
	If FileExists(GUICtrlRead($DllDir)) And FileExists(GUICtrlRead($IcoDir)) Then
		If Not FileExists(@TempDir & '\RE.exe') Then FileInstall('file\RE.exe', @TempDir & '\RE.exe', 1)
		GUISetState(@SW_HIDE, $IForm)
		ToolTip(@LF & '正在获取文件列表...' & @LF, @DesktopWidth / 2 - 30, @DesktopHeight / 2)
		FileDelete(@AppDataCommonDir & '\MakeList.txt')
		RunWait(@ComSpec & ' /c dir /b /a-d /s | findstr ".dll$">>' & @AppDataCommonDir & '\MakeList.txt' & '& dir /b /a-d /s | findstr ".exe$" >>' & @AppDataCommonDir & '\MakeList.txt' & ' & dir /b /a-d /s | findstr ".mui$">>' & @AppDataCommonDir & '\MakeList.txt ' & '& dir /b /a-d /s | findstr ".cpl$>>"' & @AppDataCommonDir & '\MakeList.txt', GUICtrlRead($DllDir), @SW_HIDE)

		ToolTip(@LF & '正在读取文件列表...' & @LF, @DesktopWidth / 2 - 30, @DesktopHeight / 2)
		Local $lines = _FileCountLines(@AppDataCommonDir & '\MakeList.txt')
		If $lines = 0 Then
			ToolTip('')
			MsgBox(0, '', '额，您选择的是一个空文件夹，开玩笑呢..(*^__^*) 嘻嘻', 1)
		Else
			For $i = 1 To $lines
				Local $DllFile = FileReadLine(@AppDataCommonDir & '\MakeList.txt', $i)
				If Not StringInStr($DllFile, '\winsxs\') Then
					ToolTip(@LF & '共需要进行' & $lines & '次提取操作,现在正在提取第' & $i & '个文件' & $DllFile & @LF, @DesktopWidth / 2 - 120, @DesktopHeight / 2)
					If Not FileExists(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile)) Then
						If GUICtrlRead($ico) = $GUI_CHECKED Then DirCreate(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\ico')
						If GUICtrlRead($cursor) = $GUI_CHECKED Then DirCreate(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\cursor')
						If GUICtrlRead($bmp) = $GUI_CHECKED Then DirCreate(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\bmp')
						If GUICtrlRead($avi) = $GUI_CHECKED Then DirCreate(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\avi')
					EndIf
					If GUICtrlRead($ico) = $GUI_CHECKED Then RunWait(@TempDir & '\RE.exe /Source "' & $DllFile & '"  /DestFolder "' & GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\ico" /ExtractIcons 1 /ExtractCursors 0 /ExtractBitmaps 0 /ExtractAVI 0 /FileExistMode 1 /OpenDestFolder 0', @WindowsDir, @SW_HIDE)
					If GUICtrlRead($cursor) = $GUI_CHECKED Then RunWait(@TempDir & '\RE.exe /Source "' & $DllFile & '"  /DestFolder "' & GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\cursor" /ExtractIcons 0 /ExtractCursors 1 /ExtractBitmaps 0 /ExtractAVI 0 /FileExistMode 1 /OpenDestFolder 0', @WindowsDir, @SW_HIDE)
					If GUICtrlRead($bmp) = $GUI_CHECKED Then RunWait(@TempDir & '\RE.exe /Source "' & $DllFile & '"  /DestFolder "' & GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\bmp" /ExtractIcons 0 /ExtractCursors 0 /ExtractBitmaps 1 /ExtractAVI 0 /FileExistMode 1 /OpenDestFolder 0', @WindowsDir, @SW_HIDE)
					If GUICtrlRead($avi) = $GUI_CHECKED Then RunWait(@TempDir & '\RE.exe /Source "' & $DllFile & '"  /DestFolder "' & GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\avi" /ExtractIcons 0 /ExtractCursors 0 /ExtractBitmaps 0 /ExtractAVI 1 /FileExistMode 1 /OpenDestFolder 0', @WindowsDir, @SW_HIDE)
					If DirGetSize(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\cursor') = 0 Then DirRemove(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\cursor', 1)
					If DirGetSize(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\bmp') = 0 Then DirRemove(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\bmp', 1)
					If DirGetSize(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\avi') = 0 Then DirRemove(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\avi', 1)
					If DirGetSize(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\ico') = 0 Then DirRemove(GUICtrlRead($IcoDir) & '\' & _WinAPI_PathFindFileName($DllFile) & '\ico', 1)

				EndIf
			Next
			ToolTip('')
			MsgBox(0, '(*^__^*) 嘻嘻', '提取资源文件操作完成!', 5)
		EndIf
		FileDelete(@AppDataCommonDir & '\MakeList.txt')
		GUISetState(@SW_SHOW, $IForm)
	Else
		MsgBox(0, '', 'Dll文件以及资源文件的目录必须实际存在！', 5)
	EndIf
EndFunc   ;==>ReIcon

;修改开始菜单图标
Func _SetBitmap($sDll, $sBitmap, $hwnd)
	$LoadLibraryA = DllCall("Kernel32.dll", "hwnd", "LoadLibraryA", "str", $sDll)
	If @error Then Return SetError(@error, 0, 0)
	$LoadBitmap = DllCall("User32.dll", "hwnd", "LoadBitmap", "hwnd", $LoadLibraryA[0], "str", $sBitmap)
	If @error Then Return SetError(@error, 0, -1)
	DllCall("user32.dll", "lparam", "SendMessage", "hwnd", GUICtrlGetHandle($hwnd), "int", 0x0172, "wparam", 0, "lparam", $LoadBitmap[0])
	If @error Then Return SetError(@error, @extended, "")
	DllCall("Kernel32.dll", "hwnd", "FreeLibrary", "hwnd", $LoadLibraryA[0])
	Return 1
EndFunc   ;==>_SetBitmap

Func ChangeOrb()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $ChangeOrbForm = _GUICreate("修改开始菜单图标", 393, 215, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	GUICtrlCreateGroup("当前按钮", 8, 8, 89, 201)
	Global $curOrb = GUICtrlCreatePic("", 25, 29, 54, 162)
	_SetBitmap(@WindowsDir & "\explorer.exe", "#6801", $curOrb)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("新的按钮", 129, 8, 89, 201)
	Global $newOrb = GUICtrlCreatePic("", 146, 29, 54, 162)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateButton("选择新的开始菜单按钮", 224, 8, 163, 33)
	GUICtrlSetOnEvent(-1, 'selectNewOrb')
	GUICtrlCreateButton("还原备份的开始菜单按钮", 227, 52, 163, 33)
	GUICtrlSetOnEvent(-1, 'RestoreOrb')
	Global $ReplaceOrb = GUICtrlCreateButton("开始替换", 225, 92, 163, 33)
	GUICtrlSetState($ReplaceOrb, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, 'ChangeOrbCore')
	GUICtrlCreateButton("返回主程序", 227, 129, 163, 33)
	GUICtrlSetOnEvent(-1, 'QuitOrbTool')
	Global $ForeBackup = GUICtrlCreateCheckbox("替换前做好备份", 232, 176, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUISetState(@SW_SHOW, $ChangeOrbForm)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitOrbTool')
	GUISetOnEvent($GUI_EVENT_DROPPED, 'Dropaddorb')
EndFunc   ;==>ChangeOrb

Func QuitOrbTool()
	GUISetState(@SW_HIDE, $ChangeOrbForm)
	GUIDelete($ChangeOrbForm)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitOrbTool

Func selectNewOrb()
	Global $orbbmp = FileOpenDialog('请选择您的开始菜单位图', '', '(*.bmp)windows位图图像', '', '', $ChangeOrbForm)
	If FileExists($orbbmp) Then
		GUICtrlSetState($ReplaceOrb, $GUI_ENABLE)
		GUICtrlSetImage($newOrb, '')
		GUICtrlSetImage($newOrb, $orbbmp)
	EndIf
EndFunc   ;==>selectNewOrb

Func Dropaddorb()
	If StringInStr(@GUI_DragFile, '.bmp') Then
		GUICtrlSetState($ReplaceOrb, $GUI_ENABLE)
		GUICtrlSetImage($newOrb, '')
		GUICtrlSetImage($newOrb, @GUI_DragFile)
		Global $orbbmp = @GUI_DragFile
	Else
		MsgBox(0, '错误', '本工具暂只支持bmp格式图像！', 5)
	EndIf
EndFunc   ;==>Dropaddorb

Func RestoreOrb()
	If FileExists(@WindowsDir & '\explorer_backup.exe') Then
		Run(@ComSpec & ' /c taskkill /im explorer.exe /f', @WindowsDir, @SW_HIDE)
		RunWait(@ComSpec & " /c takeown /f C:\Windows\explorer.exe && icacls C:\Windows\explorer.exe /grant administrators:F", "", @SW_HIDE)
		FileDelete(@WindowsDir & '\explorer_Temp.exe')
		FileMove(@WindowsDir & '\explorer.exe', @WindowsDir & '\explorer_Temp.exe', 1)
		FileMove(@WindowsDir & '\explorer_backup.exe', @WindowsDir & '\explorer.exe', 1)
		Run(@ComSpec & ' /c del/f/q "' & @WindowsDir & '\explorer_Temp.exe"|del/f/q "' & @WindowsDir & '\explorer_Temp.exe"|del/f/q "' & @WindowsDir & '\explorer_Temp.exe"|del/f/q "' & @WindowsDir & '\explorer_Temp.exe"', @ScriptDir, @SW_HIDE)
		Run(@WindowsDir & '\explorer.exe')
		MsgBox(0, '(*^__^*) 嘻嘻', '还原完成..', 5)
	Else
		MsgBox(0, 'Orz-ing', '不存在备份文件...', 5)
	EndIf
EndFunc   ;==>RestoreOrb

Func ChangeOrbCore()
	Local $i
	If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
	Run(@ComSpec & ' /c taskkill /im explorer.exe /f', @WindowsDir, @SW_HIDE)
	FileCopy(@WindowsDir & '\explorer.exe', @WindowsDir & '\explorer_mh.exe')
	If GUICtrlRead($ForeBackup) = $GUI_CHECKED Then
		FileCopy(@WindowsDir & '\explorer.exe', @WindowsDir & '\explorer_backup.exe', 1)
	EndIf
	For $i = 6801 To 6812 Step 1
		RunWait(@TempDir & '\reshacker.exe -addoverwrite ' & @WindowsDir & '\explorer_mh.exe,' & @WindowsDir & '\explorer_mh.exe,"' & $orbbmp & '",bitmap,' & $i & ', ', @TempDir, @SW_HIDE)
	Next
	FileMove(@WindowsDir & '\explorer_mh.exe', @WindowsDir & '\explorer.exe', 1)
	Run(@WindowsDir & '\explorer.exe')
	MsgBox(0, '', '美化完成..', 5)
EndFunc   ;==>ChangeOrbCore

Func WimCleanTool()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $WimCleanTool = _GUICreate("Wim挂载失败清理辅助工具", 353, 147, -1, -1, -1, $WS_EX_ACCEPTFILES, $Form1)
	GUICtrlCreateGroup("", 8, 16, 329, 121)
	GUICtrlSetState(-1, $GUI_ACCEPTFILES)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $DelProcess = GUICtrlCreateLabel("拖动您要强制删除的文件或者文件夹到这里来", 16, 40, 316, 33)
	GUICtrlSetColor(-1, 0x808080)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitWimCleanTool')
	GUISetOnEvent($GUI_EVENT_DROPPED, 'ForceCleanwim')
EndFunc   ;==>WimCleanTool

Func QuitWimCleanTool()
	GUISetState(@SW_HIDE, $WimCleanTool)
	GUIDelete($WimCleanTool)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitWimCleanTool
Func ForceCleanwim()
	If @OSArch = 'x86' Then FileInstall("file\xdel.exe", @TempDir & '\xdel.exe', 1)
	If @OSArch = 'x64' Then FileInstall("file\xdel64.exe", @TempDir & '\xdel.exe', 1)
	GUICtrlSetData($DelProcess, '正在进行文件强制删除操作,请稍后...')
	RunWait(@ComSpec & ' /c del/s/f/q "' & @GUI_DragFile & '" |' & @TempDir & '\xdel.exe "' & @GUI_DragFile & '"', @TempDir, @SW_HIDE)
	GUICtrlSetData($DelProcess, '文件删除完成..(*^__^*) 嘻嘻')
	Sleep(1500)
	GUICtrlSetData($DelProcess, '拖动您要强制删除的文件或者文件夹到这里来')
EndFunc   ;==>ForceCleanwim


Func AdminRightTool()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $GetAdminRight = _GUICreate("文件权限快速获取辅助工具", 387, 201, -1, -1, -1, $WS_EX_ACCEPTFILES, $Form1)
	GUICtrlCreateGroup("", 8, 0, 369, 169)
	GUICtrlSetState(-1, $GUI_ACCEPTFILES)
	Global $GetProcessTip = GUICtrlCreateLabel("请拖动您要获取权限的文件或者文件夹到此处", 56, 64, 244, 17)
	GUICtrlSetColor(-1, 0x808080)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $OnlyFile = GUICtrlCreateRadio("不处理目录", 8, 176, 81, 17)
	Global $DealSubDir = GUICtrlCreateRadio("递归处理子目录", 88, 176, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $CMDPoup = GUICtrlCreateCheckbox("开启CMD界面在其中显示详情", 200, 176, 177, 17)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitAdminRightTool')
	GUISetOnEvent($GUI_EVENT_DROPPED, 'GetAdminRight')
EndFunc   ;==>AdminRightTool

Func QuitAdminRightTool()
	GUISetState(@SW_HIDE, $GetAdminRight)
	GUIDelete($GetAdminRight)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitAdminRightTool

Func GetAdminRight()
	FileInstall("file\chown.exe", @TempDir & '\chown.exe', 1)
	GUICtrlSetData($GetProcessTip, '正在获取权限，请稍后...')
	Local $cmdarg = ''
	If GUICtrlRead($OnlyFile) = $GUI_CHECKED Then
		$cmdarg = ' -s '
	ElseIf GUICtrlRead($DealSubDir) = $GUI_CHECKED Then
		$cmdarg = ' -r '
	Else
		$cmdarg = ''
	EndIf
	If StringInStr(FileGetAttrib(@GUI_DragFile), 'D') Then
		If GUICtrlRead($CMDPoup) = $GUI_CHECKED Then
			RunWait(@ComSpec & ' /c ' & @TempDir & '\chown.exe' & $cmdarg & @UserName & ' ' & @GUI_DragFile & '\*&& pause', @WindowsDir, @SW_SHOW)
		Else
			RunWait(@ComSpec & ' /c ' & @TempDir & '\chown.exe -v ' & $cmdarg & @UserName & ' ' & @GUI_DragFile & '\*', @WindowsDir, @SW_HIDE)
		EndIf
	Else
		If GUICtrlRead($CMDPoup) = $GUI_CHECKED Then
			RunWait(@ComSpec & ' /c ' & @TempDir & '\chown.exe' & $cmdarg & @UserName & ' ' & @GUI_DragFile & '&& pause', @WindowsDir, @SW_SHOW)
		Else
			RunWait(@ComSpec & ' /c ' & @TempDir & '\chown.exe -v ' & $cmdarg & @UserName & ' ' & @GUI_DragFile, @WindowsDir, @SW_HIDE)
		EndIf
	EndIf
	GUICtrlSetData($GetProcessTip, '恭喜您，权限获取成功...')
	Sleep(1500)
	GUICtrlSetData($GetProcessTip, '请拖动您要获取权限的文件或者文件夹到此处')
EndFunc   ;==>GetAdminRight

Func ForceRebuildIconCache()
	Local $Flag = 0
	If @OSBuild < 8000 Then
		FileInstall('file\IconCacheRebuilder.exe', @TempDir & '\', 1)
		RunWait(@TempDir & '\IconCacheRebuilder.exe', @TempDir, @SW_HIDE)
		MsgBox(0, '', '已经强力重建当前系统的图标缓存', 5)
	Else
		DirCreate(@TempDir & '\tools')
		FileInstall('file\Movefile.exe', @TempDir & '\tools\', 1)
		Local $data = '@Echo off' & @CRLF & _
				'title  Windows8+图标缓存清理工具' & @CRLF & _
				'set  PATH5=%ALLUSERSPROFILE%\Microsoft\Windows\Caches' & @CRLF & _
				'set  PATH6=%LOCALAPPDATA%\Microsoft\Windows\Explorer' & @CRLF & _
				'tools\movefile.exe "%PATH5%\cversions.2.db"  "%PATH5%\cversions.2.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_16.db"  "%PATH6%\iconcache_16.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_32.db"  "%PATH6%\iconcache_32.dbbak"  >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_48.db"  "%PATH6%\iconcache_48.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_96.db"  "%PATH6%\iconcache_96.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_256.db"  "%PATH6%\iconcache_256.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_1024.db" "%PATH6%\iconcache_1024.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_exif.db"  "%PATH6%\iconcache_exif.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_idx.db"  "%PATH6%\iconcache_idx.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_sr.db"   "%PATH6%\iconcache_sr.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\iconcache_wide.db" "%PATH6%\iconcache_wide.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_16.db"  "%PATH6%\thumbcache_16.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_32.db"  "%PATH6%\thumbcache_32.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_48.db"  "%PATH6%\thumbcache_48.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_96.db"  "%PATH6%\thumbcache_96.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_256.db" "%PATH6%\thumbcache_256.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_1024.db" "%PATH6%\thumbcache_1024.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_exif.db" "%PATH6%\thumbcache_exif.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_idx.db"  "%PATH6%\thumbcache_idx.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_sr.db"  "%PATH6%\thumbcache_sr.dbbak" >nul' & @CRLF & _
				'tools\movefile.exe "%PATH6%\thumbcache_wide.db" "%PATH6%\thumbcache_wide.dbbak" >nul' & @CRLF & _
				'echo @echo off  >delfile.bat' & @CRLF & _
				'echo del /s/f/q "%PATH5%\*.dbbak" >>delfile.bat' & @CRLF & _
				'echo del /s/f/q "%PATH6%\*.dbbak" >>delfile.bat' & @CRLF & _
				'echo del/s/f/q %systemdrive%\ReplaceTemp\*.*  >>delfile.bat' & @CRLF & _
				'echo  rd/s/q %systemdrive%\ReplaceTemp  >>delfile.bat' & @CRLF & _
				'echo del %%0  >>delfile.bat' & @CRLF & _
				'move delfile.bat "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp"  >nul' & @CRLF & _
				'del /s/f/q  %windir%\Fonts\desktop.ini >nul' & @CRLF & _
				'del /s/f/q  Tools\files.txt >nul' & @CRLF & _
				'rd /s/q tools >nul' & @CRLF & _
				'del/s/f/q %0'
		Local $bathandle = FileOpen(@TempDir & '\Czyt.bat', 1 + 8)
		FileWrite($bathandle, $data)
		FileClose($bathandle)
		RunWait(@TempDir & '\Czyt.bat', @TempDir, @SW_HIDE)
		$Flag = 1
		Return $Flag
	EndIf
EndFunc   ;==>ForceRebuildIconCache

Func SinPackUI()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $SkinPackForm = _GUICreate("SkinPack美化包制作Res包辅助工具", 476, 137, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	GUICtrlCreateGroup("Skin Pack资源文件解包路径", 24, 8, 393, 65)
	Global $skinpackresource = GUICtrlCreateInput("", 32, 32, 313, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("浏览", 352, 32, 51, 25)
	GUICtrlSetOnEvent(-1, 'ChooseResDir')
	GUICtrlCreateButton("根据美化资源提取系统文件到桌面", 24, 80, 243, 25)
	GUICtrlSetOnEvent(-1, 'GetFile')
	GUICtrlCreateButton("返回主程序", 288, 80, 131, 25)
	GUICtrlSetOnEvent(-1, 'ExitSinPackUI')
	Global $Status = GUICtrlCreateLabel("工具为空闲状态...", 28, 112, 420, 20)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'ExitSinPackUI')
EndFunc   ;==>SinPackUI

Func ExitSinPackUI()
	GUISetState(@SW_HIDE, $SkinPackForm)
	GUIDelete($SkinPackForm)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>ExitSinPackUI

Func ChooseResDir()
	GUICtrlSetData($skinpackresource, FileSelectFolder("请选择SkinPack解包后的资源文件所在目录", '', 4))
EndFunc   ;==>ChooseResDir

Func GetFile()
	$SkinPackpath = GUICtrlRead($skinpackresource)
	If FileExists($SkinPackpath) And StringInStr(FileGetAttrib($SkinPackpath), 'D') Then
		Local $ResourceDirArry = _FileListToArray($SkinPackpath, '*', 2)
		Local $dir[22] = [@HomeDrive & "\Program Files\Common Files\microsoft shared\MSInfo", @HomeDrive & "\Program Files\Internet Explorer", @HomeDrive & "\Program Files\Windows Mail", @HomeDrive & "\Program Files\Windows Photo Gallery", @HomeDrive & "\Program Files\Windows Media Player", @HomeDrive & "\Program Files\Windows NT\Accessories", @HomeDrive & "\Program Files\Windows Photo Viewer", @HomeDrive & "\Program Files\Windows Sidebar", @HomeDrive & "\windows", @HomeDrive & "\windows\Branding\Basebrd\zh-CN", @HomeDrive & "\windows\Branding\Basebrd\en-us", @HomeDrive & "\windows\Branding\ShellBrd", @HomeDrive & "\windows\Branding\Basebrd", @HomeDrive & "\windows\System32", @HomeDrive & "\windows\System32\zh-CN", @HomeDrive & "\windows\System32\en-us", @HomeDrive & "\windows\System32\migwiz", @HomeDrive & "\windows\System32\Speech\SpeechUX", @HomeDrive & "\windows\ehome", @HomeDrive & "\Program Files\Windows Defender", @HomeDrive & "\Program Files\Windows Journal", @HomeDrive & "\Program Files\DVD Maker"]
		For $d In $dir
			For $f In $ResourceDirArry
				If Not IsNumber($f) Then
					If FileExists($d & '\' & $f) Then
						FileCopy($d & '\' & $f, @DesktopDir & '\Backup\' & $f, 1 + 8)
						GUICtrlSetData($Status, '正在将' & $f & '的系统原文件进行复制..')
					EndIf
				EndIf
			Next
		Next
		GUICtrlSetData($Status, '操作完成！根据资源文件提取出的原文件在桌面Backup目录！')
	Else
		GUICtrlSetData($skinpackresource, '')
		MsgBox(0, '提示', '请选择一个文件夹', 5)
	EndIf
EndFunc   ;==>GetFile


Func AddSurport2k8()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $AddWin2k8 = _GUICreate("Imageres.dll美化res预处理工具", 421, 153, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $Form1)
	GUICtrlCreateGroup("拖动文件到此控件", 8, 8, 393, 97)
	GUICtrlSetState(-1, $GUI_ACCEPTFILES)
	Global $Status = GUICtrlCreateLabel("工具为空闲状态,好无聊哦..", 8, 112, 396, 20)
	Global $To2k8 = GUICtrlCreateRadio("输出为Windows2008美化res", 8, 128, 177, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $ToWin8 = GUICtrlCreateRadio("输出为Windows8美化res", 192, 128, 153, 17)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitAddSForm')
	GUISetOnEvent($GUI_EVENT_DROPPED, 'ModifyRes')
EndFunc   ;==>AddSurport2k8

Func QuitAddSForm()
	GUISetState($AddWin2k8, @SW_HIDE)
	GUIDelete($AddWin2k8)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitAddSForm

Func ModifyRes()
	Local $Type = FileGetAttrib(@GUI_DragFile)
	Local $Orag_resFile = ''
	;预处理拖放文件
	If StringInStr($Type, 'D') Then
		GUICtrlSetData($Status, '拖放的是一个文件夹，正在匹配文件...')
		If FileExists(@GUI_DragFile & '\imageres.dll.res') Then
			$Orag_resFile = @GUI_DragFile & '\imageres.dll.res'
			GUICtrlSetData($Status, '发现文件' & @GUI_DragFile & '\imageres.res,开始预处理..')
		ElseIf FileExists(@GUI_DragFile & '\imageres.res') Then
			$Orag_resFile = @GUI_DragFile & '\imageres.res'
			GUICtrlSetData($Status, '发现文件' & @GUI_DragFile & '\imageres.res,开始预处理..')
		Else
			GUICtrlSetData($Status, '没有发现相关文件...')
		EndIf
	Else
		If FileExists(@GUI_DragFile) And StringInStr(@GUI_DragFile, 'imageres') Then
			$Orag_resFile = @GUI_DragFile
		Else
			GUICtrlSetData($Status, '请检查您拖放的文件...')
		EndIf
	EndIf
	If FileExists($Orag_resFile) And $Orag_resFile <> '' Then
		If GUICtrlRead($To2k8) = $GUI_CHECKED Then
			;reshacker检测
			If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
			;开始处理jpg图片
			;解包图片
			DirRemove(@TempDir & '\FileTempDir', 1)
			DirCreate(@TempDir & '\FileTempDir')
			For $i = 5031 To 5038
				RunWait(@TempDir & '\reshacker.exe -extract "' & $Orag_resFile & '",' & $i + 13 & '.jpg,IMAGE,' & $i & ',', @TempDir & '\FileTempDir', @SW_HIDE)
				GUICtrlSetData($Status, '正在解包编号' & $i & '的图像...')
			Next
;~ 		ShellExecute(@TempDir&'\FileTempDir')
			GUICtrlSetData($Status, '图像解包完成,开始处理res文件..')
			For $i = 5044 To 5051
				If FileExists(@TempDir & '\FileTempDir\' & $i & '.jpg') Then
					RunWait(@TempDir & '\reshacker.exe  -addoverwrite "' & $Orag_resFile & '","' & $Orag_resFile & '",' & $i & '.jpg,IMAGE,' & $i & ',1033', @TempDir & '\FileTempDir', @SW_HIDE)
					GUICtrlSetData($Status, '添加图像编号为' & $i & '的图像到res文件..')
				EndIf
			Next
			DirRemove(@TempDir & '\FileTempDir', 1)
			GUICtrlSetData($Status, '操作完成！')
			MsgBox(0, '', 'imageres文件处理完成！美化Windows2008系统试试！', 5)
		EndIf
		If GUICtrlRead($ToWin8) = $GUI_CHECKED Then
			If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
			RunWait(@TempDir & '\reshacker.exe  -delete "' & $Orag_resFile & '","' & $Orag_resFile & '",image,,', @TempDir & '\FileTempDir', @SW_HIDE)
			GUICtrlSetData($Status, '删除image图像资源..')
			MsgBox(0, '', 'imageres文件处理完成！美化Windows8系统试试！', 5)
		EndIf
	EndIf
EndFunc   ;==>ModifyRes


Func WinNT5MHUI()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $WinNT5MHForm = _GUICreate("WindowsNT5安装版美化工具", 454, 154, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	GUICtrlCreateGroup("Res文件所在文件夹", 8, 8, 441, 49)
	Global $ResPath = GUICtrlCreateInput("", 16, 24, 393, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("...", 416, 24, 27, 25)
	GUICtrlSetOnEvent(-1, 'SelectNT5Res')
	GUICtrlCreateGroup("Windows安装文件所在文件夹", 9, 62, 441, 49)
	Global $WinNT5InsFile = GUICtrlCreateInput("", 17, 78, 393, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("...", 417, 78, 27, 25)
	GUICtrlSetOnEvent(-1, 'SelectNT5Ins')
	GUICtrlCreateButton("开始美化[&S]", 8, 120, 83, 25)
	GUICtrlSetOnEvent(-1, 'WinNT5MH')
	GUICtrlCreateButton("返回主界面[&E]", 96, 120, 91, 25)
	GUICtrlSetOnEvent(-1, 'QuitNT5MH')
	Global $StatusLab = GUICtrlCreateLabel("程序设计：虫子樱桃", 208, 128, 224, 17)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitNT5MH', $WinNT5MHForm)
EndFunc   ;==>WinNT5MHUI

Func QuitNT5MH()
	GUISetState($WinNT5MHForm, @SW_HIDE)
	GUIDelete($WinNT5MHForm)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitNT5MH

Func FullExtention($Ex)
	Switch $Ex
		Case '.EX_'
			Return '.EXE'
		Case '.CP_'
			Return '.CPL'
		Case '.DL_'
			Return '.DLL'
	EndSwitch
EndFunc   ;==>FullExtention

Func SelectNT5Res()
	Local $dir = FileSelectFolder('请选择WindowsNT5美化包的目录', '')
	If Not $dir = '' Then
		GUICtrlSetData($ResPath, $dir)
	EndIf
EndFunc   ;==>SelectNT5Res

Func SelectNT5Ins()
	Local $dir = FileSelectFolder('请选择Windows安装文件的目录', '')
	If Not $dir = '' Then
		GUICtrlSetData($WinNT5InsFile, $dir)
	EndIf
EndFunc   ;==>SelectNT5Ins


Func WinNT5MH()
	GUICtrlSetState(@GUI_CtrlId, $GUI_DISABLE)
	GUICtrlSetState($ResPath, $GUI_DISABLE)
	GUICtrlSetState($WinNT5InsFile, $GUI_DISABLE)
	If Not FileExists(@TempDir & '\TempMHDir') Then DirCreate(@TempDir & '\TempMHDir')
	If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
	FileInstall('file\expand.exe', @TempDir & '\', 1)
	FileInstall('file\makecab.exe', @TempDir & '\', 1)
	If Not FileExists(@TempDir & '\PEChecksum.exe') Then FileInstall('file\PEChecksum.exe', @TempDir & '\', 1)
	Local $NT5ResDir = GUICtrlRead($ResPath)
	Local $NT5InsDir = GUICtrlRead($WinNT5InsFile)
	If Not StringInStr($NT5InsDir, 'i386') And FileExists($NT5InsDir & '\i386') = 1 Then
		$NT5InsDir &= '\i386'
		GUICtrlSetData($WinNT5InsFile, $NT5InsDir)
	EndIf
	Local $Nt5ResList = _FileListToArray($NT5ResDir, '*.res', 1)
	If Not @error Then
		For $i In $Nt5ResList
			If Not IsNumber($i) Then
				Local $TempString = StringSplit($i, '.')
				Local $Filename = $TempString[1]
				Local $i386Extention[3] = ['.EX_', '.CP_', '.DL_']
				For $Ex In $i386Extention
					If FileExists($NT5InsDir & '\' & $Filename & $Ex) Then
						GUICtrlSetData($StatusLab, '正在解包' & $Filename & '文件..')
						RunWait(@TempDir & '\expand.exe "' & $NT5InsDir & '\' & $Filename & $Ex & '" "' & @TempDir & '\TempMHDir\' & $Filename & FullExtention($Ex) & '"', @TempDir, @SW_HIDE)
						GUICtrlSetData($StatusLab, '正在美化' & $Filename & '文件..')
						RunWait(@TempDir & '\reshacker.exe -addoverwrite "' & @TempDir & '\TempMHDir\' & $Filename & FullExtention($Ex) & '" ,"' & @TempDir & '\TempMHDir\' & $Filename & FullExtention($Ex) & '" ,"' & $NT5ResDir & '\' & $i & '",,,', @TempDir, @SW_HIDE)
						GUICtrlSetData($StatusLab, '正在优化' & $Filename & '文件..')
						RunWait(@TempDir & '\PEChecksum.exe -c "' & @TempDir & '\TempMHDir\' & $Filename & FullExtention($Ex) & '"', @TempDir & '\', @SW_HIDE)
						GUICtrlSetData($StatusLab, '正在完成处理' & $Filename & '文件..')
						RunWait(@TempDir & '\makecab.exe  /D CompressionType=LZX /D CompressionMemory=21 "' & @TempDir & '\TempMHDir\' & $Filename & FullExtention($Ex) & '"  "' & $NT5InsDir & '\' & $Filename & $Ex & '"', @TempDir, @SW_HIDE)
						ExitLoop
					EndIf
				Next
			EndIf
		Next
		GUICtrlSetData($StatusLab, "程序设计：虫子樱桃")
	Else
		MsgBox(16, '提示', '当前选择资源路径存在某些错误!', 5)
	EndIf
	GUICtrlSetState(@GUI_CtrlId, $GUI_ENABLE)
	GUICtrlSetState($ResPath, $GUI_ENABLE)
	GUICtrlSetState($WinNT5InsFile, $GUI_ENABLE)
	DirRemove(@TempDir & '\TempMHDir\', 1)
EndFunc   ;==>WinNT5MH

;imagagres.dll图片批量调整生成
Func MutiResizingUI()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	Global $ResizingSourcePic = ''
	If Not FileExists(@TempDir & '\reshacker.exe') Then FileInstall('file\reshacker.exe', @TempDir & '\reshacker.exe', 1)
	RunWait(@TempDir & '\reshacker.exe -extract "' & @WindowsDir & '\System32\imageres.dll",5031.jpg,IMAGE,5031,', @TempDir & '\', @SW_HIDE)
	Global $MutiresizingForm = _GUICreate("Imageres.dll图片大小批量调整生成", 449, 349, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	Global $ImageresJpg = GUICtrlCreatePic("", 16, 16, 412, 228)
	GUICtrlSetImage(-1, @TempDir & '\5031.jpg')
	GUICtrlCreateButton("选择图片", 376, 248, 67, 41)
	GUICtrlSetOnEvent(-1, 'setMutiResizingPic')
	GUICtrlCreateGroup("输出文件夹", 16, 248, 353, 81)
	Global $OutPutDir = GUICtrlCreateInput("", 32, 280, 281, 21)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlCreateButton("...", 320, 280, 43, 21)
	GUICtrlSetOnEvent(-1, 'SetResizingOutDir')
	GUICtrlCreateButton("开始调整", 376, 296, 67, 41)
	GUICtrlSetOnEvent(-1, 'StartResizing')
	Global $resizingStatusLabel = GUICtrlCreateLabel("", 32, 304, 324, 17)
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'QuitMutiresizingUI', $MutiresizingForm)
EndFunc   ;==>MutiResizingUI

Func QuitMutiresizingUI()
	GUISetState($MutiresizingForm, @SW_HIDE)
	GUIDelete($MutiresizingForm)
	FileDelete(@TempDir & '\5031.jpg')
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>QuitMutiresizingUI

Func setMutiResizingPic()
	Local $pic = FileOpenDialog('请选择要进行处理的图像文件', @DesktopDir, '所有支持的文件类型(*.jpg;*.jpeg;*.bmp;*.png)', 1)
	If Not @error Then
		$ResizingSourcePic = $pic
		GUICtrlSetImage($ImageresJpg, $pic)
	EndIf
EndFunc   ;==>setMutiResizingPic
Func SetResizingOutDir()
	Local $dir = FileSelectFolder('请选择要批量生成的图片的输出路径', @DesktopDir, 1 + 4)
	If Not @error Then
		GUICtrlSetData($OutPutDir, $dir)
	EndIf
EndFunc   ;==>SetResizingOutDir

Func StartResizing()
	Local $outDir = GUICtrlRead($OutPutDir)
	MutiResizing($ResizingSourcePic, $outDir)
EndFunc   ;==>StartResizing

Func MutiResizing($File, $File_OutputDir)
	Local $PicInfoArry[8][3]
	For $i = 0 To 7
		$PicInfoArry[$i][0] = 5031 + $i
	Next
	;5031
	$PicInfoArry[0][1] = 1280
	$PicInfoArry[0][2] = 1024
	;5032
	$PicInfoArry[1][1] = 1280
	$PicInfoArry[1][2] = 960
	;5033
	$PicInfoArry[2][1] = 1024
	$PicInfoArry[2][2] = 768
	;5034
	$PicInfoArry[3][1] = 1600
	$PicInfoArry[3][2] = 1200
	;5035
	$PicInfoArry[4][1] = 1440
	$PicInfoArry[4][2] = 900
	;5036
	$PicInfoArry[5][1] = 1920
	$PicInfoArry[5][2] = 1200
	;5037
	$PicInfoArry[6][1] = 1280
	$PicInfoArry[6][2] = 768
	;5038
	$PicInfoArry[7][1] = 1360
	$PicInfoArry[7][2] = 768
	GUICtrlSetState($OutPutDir, $GUI_DISABLE)
	For $j = 0 To 7
		GUICtrlSetData($resizingStatusLabel, '正在生成图片' & $PicInfoArry[$j][0] & '.jpg..')
		_ImageResize($File, $File_OutputDir & '\' & $PicInfoArry[$j][0] & '.jpg', $PicInfoArry[$j][1], $PicInfoArry[$j][2])
		GUICtrlSetData($resizingStatusLabel, '生成图片' & $PicInfoArry[$j][0] & '.jpg完成！')
	Next
	GUICtrlSetData($resizingStatusLabel, '完成所有批量调整生成任务！')
	GUICtrlSetState($OutPutDir, $GUI_ENABLE)
EndFunc   ;==>MutiResizing

Func _ImageResize($sInImage, $sOutImage, $iW, $iH)
	Local $hwnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0

	;OutFile path, to use later on.
	Local $sOP = StringLeft($sOutImage, StringInStr($sOutImage, "\", 0, -1))

	;OutFile name, to use later on.
	Local $sOF = StringMid($sOutImage, StringInStr($sOutImage, "\", 0, -1) + 1)

	;OutFile extension , to use for the encoder later on.
	Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))

	; Win api to create blank bitmap at the width and height to put your resized image on.
	$hwnd = _WinAPI_GetDesktopWindow()
	$hDC = _WinAPI_GetDC($hwnd)
	$hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	_WinAPI_ReleaseDC($hwnd, $hDC)

	;Start GDIPlus
	_GDIPlus_Startup()

	;Get the handle of blank bitmap you created above as an image
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)

	;Load the image you want to resize.
	$hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)

	;Get the graphic context of the blank bitmap
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)

	;Draw the loaded image onto the blank bitmap at the size you want
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iW)

	;Get the encoder of to save the resized image in the format you want.
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)

	$sOutImage = $sOP & $sOF

	;Save the new resized image.
	_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)

	;Clean up and shutdown GDIPlus.
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()
EndFunc   ;==>_ImageResize

Func donetMe()
	MsgBox(0, '我知道您不小心点了这个..', '如果您喜欢这个工具，请赞助我！！' & @LF & '支付宝帐号:wenchongchong@gmail.com' & @LF & '感谢您对我的支持！', 5)
EndFunc   ;==>donetMe

Func RestoreFiles()
	Local $BackupFolder = FileSelectFolder('请选择您要还原的备份文件所在路径', '', 4)
	If $BackupFolder = '' Then
		MsgBox(0, '提示', '请选择正确的美化文件备份目录！！', 5)
		Return
	EndIf
	If FileExists($BackupFolder) Then
		DirRemove(@TempDir & '\source', 1)
		DirCopy($BackupFolder, @TempDir & '\source')
		If Not FileExists(@TempDir & '\ReplaceHelper.exe') Then FileInstall('file\ReplaceHelper.exe', @TempDir & '\', 1)
		Run(@TempDir & '\ReplaceHelper.exe')
		WinWait('[CLASS:ConsoleWindowClass]')
		WinActivate('[CLASS:ConsoleWindowClass]')
		WinWaitActive('[CLASS:ConsoleWindowClass]')
		Send('{1}')
		Send('{enter}')
		While 1
			Sleep(100)
			If FileExists(@TempDir & '\Installed.list') Then
				Sleep(3000)
				ExitLoop
			EndIf
		WEnd
		If ProcessExists('ReplaceHelper.exe') Then Run(@ComSpec & ' /c taskkill /im ReplaceHelper.exe /f', @WindowsDir, @SW_HIDE)
		Sleep(2000)
		If FileExists(@TempDir & '\ReplaceHelper.exe') Then FileDelete(@TempDir & '\ReplaceHelper.exe')
		If FileExists(@TempDir & '\Installed.list') Then FileDelete(@TempDir & '\Installed.list')
		If MsgBox(4, '提示', '还原备份的美化文件完成！是否重启以使还原生效？', 5) = 6 Then
			bootpc()
		EndIf
	Else
		MsgBox(0, '提示', '所选备份文件夹无效！！', 5)
	EndIf
EndFunc   ;==>RestoreFiles
Func DTU()
	ShellExecute('http://tb-8.blogbus.com/')
EndFunc   ;==>DTU
Func AboutDlg()
	TrayDisable()
	GUISetState(@SW_HIDE, $Form1)
	_GDIPlus_Startup()

	Global $SC_DRAGMOVE = 0xF012
	Global $W = -1
	Global $H = 200
	Global $hGUI = _GUICreate("关于工具", $W, $H, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
	Global $hGUI_Child = _GUICreate("", $W, $H, 0, 0, $WS_POPUP, $WS_EX_MDICHILD + $WS_EX_LAYERED, $hGUI)
	GUISetBkColor(0xABCDEF, $hGUI_Child)
	GUISwitch($hGUI_Child)
	Global $idButton = GUICtrlCreateLabel("X", 10, 10, 15, 15)
	GUICtrlSetTip(-1, '关闭对话框')
	GUICtrlSetColor(-1, 0xF25D05)
	GUICtrlSetOnEvent(-1, "_Exit")
	GUICtrlCreateLabel("最好用的Res美化安装工具！", 10, 30, 180, 100)
	GUICtrlSetColor(-1, 0xF0F0FF)
	GUICtrlSetFont(-1, 9, 400, 0, "Verdana", 3)
	Global $idLabel = GUICtrlCreateLabel("WindowsNT6美化助手", 110, 110, 180, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "Verdana", 3)
	GUICtrlSetColor(-1, 0xF0F0FF)
	GUICtrlSetBkColor(-1, -2)
	GUICtrlCreateLabel("Version " & FileGetVersion(@ScriptFullPath), 110, 130, 180, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Verdana", 3)
	GUICtrlSetColor(-1, 0xF0F0FF)
	GUICtrlSetBkColor(-1, -2)
	GUICtrlCreateLabel("虫子樱桃  作品", 110, 150, 180, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Verdana", 3)
	GUICtrlSetColor(-1, 0xF0F0FF)
	GUICtrlSetBkColor(-1, -2)
	_WinAPI_SetLayeredWindowAttributes($hGUI_Child, 0xABCDEF, 0xFF)
	GUISetState(@SW_SHOW, $hGUI_Child)
	GUISetState(@SW_SHOW, $hGUI)
	_SetGuiRoundCorners($hGUI, 40, False, True, True, False)

	Global $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
	;背景颜色
	Global $hBitmap = _CreateCustomBk($hGUI, 0x716A6C)
	;文字背景颜色
	Global $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_CreateCustomGroupPic($hContext, 100, 100, 200, 75, 0xff0000)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $W, $H)

	SetTransparentBitmap($hGUI, $hBitmap, 0xD0)

	GUISetOnEvent(-3, "_Exit")

	GUIRegisterMsg($WM_LBUTTONDOWN, "_WM_LBUTTONDOWN")
EndFunc   ;==>AboutDlg


Func _Exit()
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI_Child)
	GUIDelete($hGUI)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc   ;==>_Exit

Func _CreateCustomBk($hGUI, $hexColor, $alpha = "0xAA")
	Local $iWidth = _WinAPI_GetClientWidth($hGUI)
	Local $iHeight = _WinAPI_GetClientHeight($hGUI)
	Local $oBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($oBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)
	Local $hBrush = _GDIPlus_BrushCreateSolid($alpha & Hex($hexColor, 6))
	_GDIPlus_GraphicsFillRect($hGraphics, 0, 0, $iWidth, $iHeight, $hBrush)
	_GDIPlus_GraphicsFillRect($hGraphics, 2, 2, $iWidth - 6, $iHeight - 6, $hBrush)
	_GDIPlus_BrushSetSolidColor($hBrush, 0x22FFFFFF)
	Local $iTimes = Round($iWidth / 50)
	Local $aPoints[5][2]
	$aPoints[0][0] = 4
	$aPoints[1][1] = $iHeight
	$aPoints[2][1] = $iHeight
	$aPoints[4][1] = 0
	$aPoints[3][1] = 0
	For $i = 0 To $iTimes
		Local $Random1 = Random(0, $iWidth, 1)
		Local $Random2 = Random(30, 50, 1)
		$aPoints[1][0] = $Random1
		$aPoints[2][0] = $Random1 + $Random2
		$aPoints[4][0] = $aPoints[1][0] + 50
		$aPoints[3][0] = $aPoints[2][0] + 50
		_GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush)
		$aPoints[1][0] -= $Random2 / 10
		$aPoints[2][0] = $Random1 + $Random2 - ($Random2 / 10 * 2)
		$aPoints[3][0] = $aPoints[2][0] + 50
		$aPoints[4][0] = $aPoints[1][0] + 50
		_GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush)
	Next
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphics)
	Return $oBitmap
EndFunc   ;==>_CreateCustomBk

Func _CreateCustomGroupPic($hGraphics, $ix, $iy, $Width, $iHeight, $hexColor, $alpha = "0x55")
	_GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)
	Local $hBrush = _GDIPlus_BrushCreateSolid($alpha & Hex($hexColor, 6))
	_GDIPlus_GraphicsFillRect($hGraphics, $ix, $iy, $Width, $iHeight, $hBrush)
	_GDIPlus_GraphicsFillRect($hGraphics, 2, 2, $Width - 4, $iHeight - 4, $hBrush)
	_GDIPlus_BrushDispose($hBrush)
EndFunc   ;==>_CreateCustomGroupPic

Func _SetGuiRoundCorners($hGUI, $iEllipse, $iLeftUp = True, $iLeftDown = True, $iRightUp = True, $iRightDown = True)
	Local $hCornerRgn
	Local $aGuiSize = WinGetPos($hGUI)
	Local $hRgn = _WinAPI_CreateRoundRectRgn(0, 0, $aGuiSize[2], $aGuiSize[3], $iEllipse, $iEllipse)
	If $iLeftUp = False Then
		$hCornerRgn = _WinAPI_CreateRectRgn(0, 0, $aGuiSize[2] / 2, $aGuiSize[3] / 2)
		_WinAPI_CombineRgn($hRgn, $hRgn, $hCornerRgn, $RGN_OR)
		_WinAPI_DeleteObject($hCornerRgn)
	EndIf
	If $iLeftDown = False Then
		$hCornerRgn = _WinAPI_CreateRectRgn(0, $aGuiSize[3] / 2, $aGuiSize[2] / 2, $aGuiSize[3])
		_WinAPI_CombineRgn($hRgn, $hRgn, $hCornerRgn, $RGN_OR)
		_WinAPI_DeleteObject($hCornerRgn)
	EndIf
	If $iRightUp = False Then
		$hCornerRgn = _WinAPI_CreateRectRgn($aGuiSize[2] / 2, 0, $aGuiSize[2], $aGuiSize[3] / 2)
		_WinAPI_CombineRgn($hRgn, $hRgn, $hCornerRgn, $RGN_OR)
		_WinAPI_DeleteObject($hCornerRgn)
	EndIf
	If $iRightDown = False Then
		$hCornerRgn = _WinAPI_CreateRectRgn($aGuiSize[2] / 2, $aGuiSize[3] / 2, $aGuiSize[2] - 1, $aGuiSize[3] - 1)
		_WinAPI_CombineRgn($hRgn, $hRgn, $hCornerRgn, $RGN_OR)
		_WinAPI_DeleteObject($hCornerRgn)
	EndIf
	_WinAPI_SetWindowRgn($hGUI, $hRgn)
EndFunc   ;==>_SetGuiRoundCorners

Func SetTransparentBitmap($hGUI, $hImage, $iOpacity = 0xFF)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", 1)
	_WinAPI_UpdateLayeredWindow($hGUI, $hMemDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetTransparentBitmap


Func _WM_LBUTTONDOWN($hwnd, $iMsg, $wParam, $lParam)
	_SendMessage($hGUI, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
EndFunc   ;==>_WM_LBUTTONDOWN

Func _GUICreate($sTitle, $iWidth, $iHeight, $iLeft = -1, $iTop = -1, $style = Default, $exStyle = Default, $winP = 0)
	Local $Hwin = GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, $style, $exStyle, $winP)
	_ChangeWindowMessageFilterEx($Hwin, 0x233, 1)
	_ChangeWindowMessageFilterEx($Hwin, $WM_COPYDATA, 1)
	_ChangeWindowMessageFilterEx($Hwin, 0x0049, 1)
	Return $Hwin
EndFunc   ;==>_GUICreate
Func _ChangeWindowMessageFilterEx($hwnd, $iMsg, $iAction)
	Local $aCall = DllCall("user32.dll", "bool", "ChangeWindowMessageFilterEx", _
			"hwnd", $hwnd, _
			"dword", $iMsg, _
			"dword", $iAction, _
			"ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_ChangeWindowMessageFilterEx
Func ChangeFont()
	GUISetState(@SW_HIDE, $Form1)
;~ 	Global $ChangeOrbForm = _GUICreate("修改开始菜单图标", 393, 215, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	Global $FormChangeFont = _GUICreate("设置系统对话框默认字体", 321, 78, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE), $Form1)
	Global $FontName = GUICtrlCreateInput("FontName", 8, 8, 241, 21)
	GUICtrlCreateButton("选择", 256, 8, 59, 25)
	GUICtrlSetOnEvent(-1,'chooseFont')
	GUICtrlCreateButton("设置", 8, 40, 299, 25)
	GUICtrlSetOnEvent(-1,'SetFont')
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE,'QuitFontSt')
EndFunc
Func QuitFontSt()
	GUISetState(@SW_HIDE, $FormChangeFont)
	GUIDelete($FormChangeFont)
	TrayEnable()
	GUISetState(@SW_SHOW, $Form1)
EndFunc
Func chooseFont()
	$font = _ChooseFont("微软雅黑")
	If Not @error Then
		GUICtrlSetData($FontName,$font[2])
	EndIf
EndFunc
Func SetFont()
	RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -f '&GUICtrlRead($FontName), @TempDir, @SW_HIDE)
	RunWait(@TempDir & '\W7Patcher_' & @OSArch & '.exe -clc ', @TempDir, @SW_HIDE)
	MsgBox(0,'','修改字体成功！注销或重启生效！')
EndFunc