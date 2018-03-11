Name "Ipicture Splash.dll test"

OutFile "IpicSplash.exe"

XPStyle on

Function .onInit
        # the plugins dir is automatically deleted when the installer exits
        InitPluginsDir
        SetOutPath "$PLUGINSDIR"

        #optional
        #File "snd.wav"
        #ipicsplash::play /NOUNLOAD "$PLUGINSDIR\snd.wav"
        #Pop $0

        File "imfat.jpg"
        #MessageBox MB_OK "Fading"
        ipicsplash::show 1000 600 400 -1 "$PLUGINSDIR\imfat.jpg"
        Pop $0          ; $0 has '1' if the user closed the splash screen early,
                        ; '0' if everything closed normal, and '-1' if some error occured.

        MessageBox MB_OK "Transparency"
        File "send.gif"
        ipicsplash::show 2000 0 0 0 "$PLUGINSDIR\send.gif"
        Pop $0 

        MessageBox MB_OK "Transparency/Fading"
        File /oname=$PLUGINSDIR\splash.bmp "${NSISDIR}\Contrib\Graphics\Wizard\llama.bmp"
        ipicsplash::show 1000 600 400 0x04025C $PLUGINSDIR\splash.bmp
        Pop $0 

        Delete $PLUGINSDIR\splash.bmp
        Delete $PLUGINSDIR\send.gif
        Delete $PLUGINSDIR\imfat.jpg
FunctionEnd

Section
SectionEnd