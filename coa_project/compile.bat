set projectName=project
\masm32\bin\ml /c /Zd /coff %projectName%.asm
\masm32\bin\Link /SUBSYSTEM:CONSOLE %projectName%.obj
%projectName%.exe