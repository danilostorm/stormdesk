\
    ; StormDesk Inno Setup script (básico)
    #define MyAppName "StormDesk"
    #define MyAppVersion "1.0.0"
    #define MyAppPublisher "HostStorm"
    #define MyAppExeName "stormdesk.exe"
    [Setup]
    AppName={#MyAppName}
    AppVersion={#MyAppVersion}
    DefaultDirName={autopf}\{#MyAppName}
    DefaultGroupName={#MyAppName}
    OutputDir=dist\installer
    OutputBaseFilename=StormDesk-Setup
    Compression=lzma
    SolidCompression=yes
    SetupIconFile=..\..\branding\icons\stormdesk.ico
    [Files]
    Source: "..\..\dist\windows\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
    [Icons]
    Name: "{group}\StormDesk"; Filename: "{app}\{#MyAppExeName}"
    Name: "{commondesktop}\StormDesk"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
    [Tasks]
    Name: "desktopicon"; Description: "Criar atalho na área de trabalho"; GroupDescription: "Atalhos:"; Flags: unchecked
