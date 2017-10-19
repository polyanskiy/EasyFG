; Windows Installer for easyFG
; Author: Mikhail N Polyanskiy (polyanskiy@bnl.gov)
; Brookhaven National Laboratory, USA

!include "MUI.nsh"

;General
Name "easyFG"
OutFile "easyFG_20171018.exe"

;Default install path
InstallDir "$PROGRAMFILES\easyFG"          ;default
InstallDirRegKey HKLM "Software\easyFG" "" ;if previous installation exists (overrides default)


;-------------------------Interface Settings---------------------------

!define MUI_ABORTWARNING
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\win.bmp"
!define EASYFG_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\easyFG"
!define EASYFG_ROOT_KEY "Applications\easyfg.exe"

;Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
  
;Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;Languages
!insertmacro MUI_LANGUAGE "English"


;-------------------------Installer Sections---------------------------

Section "Section_01" Sec01

  ;Read previous installation path from registry
  ReadRegDWORD $0 HKLM "Software\easyFG" ""

  ;Remove previous installation
  SetShellVarContext all
  RMDir /r $0                                   
  RMDir /r "$SMPROGRAMS\easyFG"
  RMDir /r "$INSTDIR"

  ;Write files to installation directory
  SetOutPath "$INSTDIR"
  File "release\easyfg.exe"
  File "C:\Qt\5.9.2\mingw53_32\bin\libgcc_s_dw2-1.dll"
  File "C:\Qt\5.9.2\mingw53_32\bin\libstdc++-6.dll"
  File "C:\Qt\5.9.2\mingw53_32\bin\libwinpthread-1.dll"
  File "C:\Qt\5.9.2\mingw53_32\bin\Qt5Core.dll"
  File "C:\Qt\5.9.2\mingw53_32\bin\Qt5Gui.dll"
  File "C:\Qt\5.9.2\mingw53_32\bin\Qt5Widgets.dll"
  ;libtiff
  File "C:\Program Files (x86)\GnuWin32\bin\jpeg62.dll"
  File "C:\Program Files (x86)\GnuWin32\bin\libtiff3.dll"
  File "C:\Program Files (x86)\GnuWin32\bin\zlib1.dll"
  ;HDF5
  File "C:\Program Files (x86)\HDF_Group\HDF5\1.10.1\bin\hdf5.dll"
  File "C:\Program Files (x86)\HDF_Group\HDF5\1.10.1\bin\hdf5_hl.dll"
  File "C:\Program Files (x86)\HDF_Group\HDF5\1.10.1\bin\zlib.dll"
  File "C:\Program Files (x86)\HDF_Group\HDF5\1.10.1\bin\szip.dll"
  
  SetOutPath "$INSTDIR\platforms"
  File "C:\Qt\5.9.2\mingw53_32\plugins\platforms\qwindows.dll"  
  
  SetOutPath "$INSTDIR\imageformats"
  File "C:\Qt\5.9.2\mingw53_32\plugins\imageformats\qjpeg.dll"
  
  SetOutPath "$INSTDIR\src"
  File "easyfg.h"
  File "analysis.cpp"
  File "buttons.cpp"
  File "colormap.cpp"
  File "load.cpp"
  File "main.cpp"
  File "mainwindow.cpp"
  File "memory.cpp"
  File "reference.cpp"
  File "save.cpp"
  File "scale.cpp"
  File "scene.cpp"
  File "settings.cpp"
  File "shortcuts.cpp"
  File "update.cpp"
  File "mainwindow.ui"
  File "icon.rc"
  File "icon.qrc"
  File "easyfg.pro"
  File "installer.nsi"
  
  SetOutPath "$INSTDIR\src\icon"
  File "icon\*.*"
  SetOutPath "$INSTDIR\src\icon\valenky"
  File "icon\valenky\*.*"
  SetOutPath "$INSTDIR\examples"
  File "examples\*.*"
  
  ;Write Start menu entries
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\easyFG"
  CreateShortCut "$SMPROGRAMS\easyFG\easyFG.lnk" "$INSTDIR\easyfg.exe"
  CreateShortCut "$SMPROGRAMS\easyFG\Uninstall easyFG.lnk" "$INSTDIR\uninstall.exe" "" ""
  
  ;Create desktope shortcut
  CreateShortCut "$DESKTOP\easyfg.lnk" "$INSTDIR\easyfg.exe"

  ;Registry
  WriteRegStr HKLM "Software\easyFG" "" $INSTDIR
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".asc" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".csv" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".sif" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".tif" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".tiff" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".raw" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\SupportedTypes" ".bgdata" ""
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\shell\open" "FriendlyAppName" "easyFG"
  WriteRegStr HKCR "${EASYFG_ROOT_KEY}\shell\open\command" "" '"$INSTDIR\easyfg.exe" "%1"'
  
  ;Register extensions
  WriteRegStr HKCR ".asc\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".csv\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".sif\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".tif\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".tiff\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".raw\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR ".bgdata\OpenWithProgIds" "easyFG" ""
  WriteRegStr HKCR "easyFG\shell\open" "FriendlyAppName" "easyFG";
  WriteRegStr HKCR "easyFG\shell\open\command" "" '"$INSTDIR\easyfg.exe" "%1"'
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${EASYFG_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${EASYFG_UNINST_KEY}" "DisplayName" "easyFG"
  WriteRegStr HKLM "${EASYFG_UNINST_KEY}" "DisplayIcon" "$INSTDIR\easyfg.exe"

SectionEnd


;-------------------------Uninstaller Section---------------------------

Section "Uninstall"

  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\easyFG"
  Delete "$DESKTOP\easyfg.lnk"

  Delete "$INSTDIR\uninstall.exe"
  RMDir /r "$INSTDIR"
  
  ;clear registry
  DeleteRegKey HKLM "Software\easyFG"
  DeleteRegKey HKLM "${EASYFG_UNINST_KEY}"
  DeleteRegKey HKCR "${EASYFG_ROOT_KEY}"
  DeleteRegKey HKCR "easyFG"
  DeleteRegValue HKCR ".asc\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".csv\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".sif\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".tif\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".tiff\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".raw\OpenWithProgIds" "easyFG"
  DeleteRegValue HKCR ".bgdata\OpenWithProgIds" "easyFG"
  ;remove regestry entries not properly cleared in previous versions
  DeleteRegValue HKCR ".asc\OpenWithProgIds" "easyFG.asc"
  DeleteRegValue HKCR ".sif\OpenWithProgIds" "easyFG.sif"
  DeleteRegValue HKCR ".tif\OpenWithProgIds" "easyFG.tif"
  DeleteRegValue HKCR ".tiff\OpenWithProgIds" "easyFG.tiff"
  DeleteRegValue HKCR ".raw\OpenWithProgIds" "easyFG.raw"

SectionEnd
