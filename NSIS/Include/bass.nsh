!verbose push
!verbose 3

; Error codes returned by BASS_ErrorGetCode
!define BASS_OK				0	; all is OK
!define BASS_ERROR_MEM		1	; memory error
!define BASS_ERROR_FILEOPEN	2	; can't open the file
!define BASS_ERROR_DRIVER	3	; can't find a free/valid driver
!define BASS_ERROR_BUFLOST	4	; the sample buffer was lost
!define BASS_ERROR_HANDLE	5	; invalid handle
!define BASS_ERROR_FORMAT	6	; unsupported sample format
!define BASS_ERROR_POSITION	7	; invalid playback position
!define BASS_ERROR_INIT		8	; BASS_Init has not been successfully called
!define BASS_ERROR_START	9	; BASS_Start has not been successfully called
!define BASS_ERROR_ALREADY	14	; already initialized/paused/whatever
!define BASS_ERROR_NOPAUSE	16	; not paused
!define BASS_ERROR_NOCHAN	18	; can't get a free channel
!define BASS_ERROR_ILLTYPE	19	; an illegal type was specified
!define BASS_ERROR_ILLPARAM	20	; an illegal parameter was specified
!define BASS_ERROR_NO3D		21	; no 3D support
!define BASS_ERROR_NOEAX	22	; no EAX support
!define BASS_ERROR_DEVICE	23	; illegal device number
!define BASS_ERROR_NOPLAY	24	; not playing
!define BASS_ERROR_FREQ		25	; illegal sample rate
!define BASS_ERROR_NOTFILE	27	; the stream is not a file stream
!define BASS_ERROR_NOHW		29	; no hardware voices available
!define BASS_ERROR_EMPTY	31	; the MOD music has no sequence data
!define BASS_ERROR_NONET	32	; no internet connection could be opened
!define BASS_ERROR_CREATE	33	; couldn't create the file
!define BASS_ERROR_NOFX		34	; effects are not available
!define BASS_ERROR_PLAYING	35	; the channel is playing
!define BASS_ERROR_NOTAVAIL	37	; requested data is not available
!define BASS_ERROR_DECODE	38	; the channel is a "decoding channel"
!define BASS_ERROR_DX		39	; a sufficient DirectX version is not installed
!define BASS_ERROR_TIMEOUT	40	; connection timedout
!define BASS_ERROR_FILEFORM	41	; unsupported file format
!define BASS_ERROR_SPEAKER	42	; unavailable speaker
!define BASS_ERROR_VERSION	43	; invalid BASS version (used by add-ons)
!define BASS_ERROR_CODEC	44  ; codec is not available/supported
!define BASS_ERROR_UNKNOWN	-1	; some other mystery error

; Initialization flags
!define BASS_DEVICE_8BITS	1	; use 8 bit resolution, else 16 bit
!define BASS_DEVICE_MONO	2	; use mono, else stereo
!define BASS_DEVICE_3D		4	; enable 3D functionality

!define BASS_DEVICE_LATENCY	256	; calculate device latency (BASS_INFO struct)
!define BASS_DEVICE_SPEAKERS 2048	; force enabling of speaker assignment
!define BASS_DEVICE_NOSPEAKER 4096	; ignore speaker arrangement

; DirectSound interfaces (for use with BASS_GetDSoundObject)
!define BASS_OBJECT_DS		1	; IDirectSound
!define BASS_OBJECT_DS3DL	2	; IDirectSound3DListener

;typedef struct {
;	DWORD flags;	; device capabilities (DSCAPS_xxx flags)
;	DWORD hwsize;	; size of total device hardware memory
;	DWORD hwfree;	; size of free device hardware memory
;	DWORD freesam;	; number of free sample slots in the hardware
;	DWORD free3d;	; number of free 3D sample slots in the hardware
;	DWORD minrate;	; min sample rate supported by the hardware
;	DWORD maxrate;	; max sample rate supported by the hardware
;	BOOL eax;		; device supports EAX? (always FALSE if BASS_DEVICE_3D was not used)
;	DWORD minbuf;	; recommended minimum buffer length in ms (requires BASS_DEVICE_LATENCY)
;	DWORD dsver;	; DirectSound version
;	DWORD latency;	; delay (in ms) before start of playback (requires BASS_DEVICE_LATENCY)
;	DWORD initflags;; "flags" parameter of BASS_Init call
;	DWORD speakers; ; number of speakers available
;	const char *driver;	; driver
;	DWORD freq;		; current output rate (OSX only)
;} BASS_INFO;
!define BASS_INFO "(i,i,i,i,i,i,i,b,i,i,i,i,i,i,i) i"

; BASS_INFO flags (from DSOUND.H)
!define DSCAPS_CONTINUOUSRATE	0x00000010
; supports all sample rates between min/maxrate 
!define DSCAPS_EMULDRIVER		0x00000020
; device does NOT have hardware DirectSound support 
!define DSCAPS_CERTIFIED		0x00000040
; device driver has been certified by Microsoft 
; The following flags tell what type of samples are supported by HARDWARE
; mixing, all these formats are supported by SOFTWARE mixing 
!define DSCAPS_SECONDARYMONO	0x00000100	; mono
!define DSCAPS_SECONDARYSTEREO	0x00000200	; stereo
!define DSCAPS_SECONDARY8BIT	0x00000400	; 8 bit
!define DSCAPS_SECONDARY16BIT	0x00000800	; 16 bit

;typedef struct {
;	DWORD flags;	; device capabilities (DSCCAPS_xxx flags)
;	DWORD formats;	; supported standard formats (WAVE_FORMAT_xxx flags)
;	DWORD inputs;	; number of inputs
;	BOOL singlein;	; TRUE = only 1 input can be set at a time
;	const char *driver;	; driver
;	DWORD freq;		; current input rate (OSX only)
;} BASS_RECORDINFO;
!define BASS_RECORDINFO "(i,i,i,b,i,i) i"

; BASS_RECORDINFO flags (from DSOUND.H)
!define DSCCAPS_EMULDRIVER	DSCAPS_EMULDRIVER	; device does NOT have hardware DirectSound recording support
!define DSCCAPS_CERTIFIED	DSCAPS_CERTIFIED	; device driver has been certified by Microsoft

; defines for formats field of BASS_RECORDINFO (from MMSYSTEM.H)
!ifndef WAVE_FORMAT_1M08
!define WAVE_FORMAT_1M08       0x00000001       ; 11.025 kHz, Mono,   8-bit  
!define WAVE_FORMAT_1S08       0x00000002       ; 11.025 kHz, Stereo, 8-bit  
!define WAVE_FORMAT_1M16       0x00000004       ; 11.025 kHz, Mono,   16-bit 
!define WAVE_FORMAT_1S16       0x00000008       ; 11.025 kHz, Stereo, 16-bit 
!define WAVE_FORMAT_2M08       0x00000010       ; 22.05  kHz, Mono,   8-bit  
!define WAVE_FORMAT_2S08       0x00000020       ; 22.05  kHz, Stereo, 8-bit  
!define WAVE_FORMAT_2M16       0x00000040       ; 22.05  kHz, Mono,   16-bit 
!define WAVE_FORMAT_2S16       0x00000080       ; 22.05  kHz, Stereo, 16-bit 
!define WAVE_FORMAT_4M08       0x00000100       ; 44.1   kHz, Mono,   8-bit  
!define WAVE_FORMAT_4S08       0x00000200       ; 44.1   kHz, Stereo, 8-bit  
!define WAVE_FORMAT_4M16       0x00000400       ; 44.1   kHz, Mono,   16-bit 
!define WAVE_FORMAT_4S16       0x00000800       ; 44.1   kHz, Stereo, 16-bit 
!endif

;; Sample info structure & flags
;typedef struct {
;	DWORD freq;		; default playback rate
;	DWORD volume;	; default volume (0-100)
;	int pan;		; default pan (-100=left, 0=middle, 100=right)
;	DWORD flags;	; BASS_SAMPLE_xxx flags
;	DWORD length;	; length (in bytes)
;	DWORD max;		; maximum simultaneous playbacks
;	DWORD origres;	; original resolution bits
;	DWORD chans;	; number of channels
;	DWORD mingap;	; minimum gap (ms) between creating channels
; The following are the sample's default 3D attributes (if the sample
; is 3D, BASS_SAMPLE_3D is in flags) see BASS_ChannelSet3DAttributes
;	DWORD mode3d;	; BASS_3DMODE_xxx mode
;	float mindist;	; minimum distance
;	float maxdist;	; maximum distance
;	DWORD iangle;	; angle of inside projection cone
;	DWORD oangle;	; angle of outside projection cone
;	DWORD outvol;	; delta-volume outside the projection cone
; The following are the defaults used if the sample uses the DirectX 7
;voice allocation/management features.
;	DWORD vam;		; voice allocation/management flags (BASS_VAM_xxx)
;	DWORD priority;	; priority (0=lowest, 0xffffffff=highest)
;} BASS_SAMPLE;
!define BASS_SAMPLE "(i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i) i"

!define BASS_SAMPLE_8BITS		1	; 8 bit
!define BASS_SAMPLE_FLOAT		256	; 32-bit floating-point
!define BASS_SAMPLE_MONO		2	; mono
!define BASS_SAMPLE_LOOP		4	; looped
!define BASS_SAMPLE_3D			8	; 3D functionality enabled
!define BASS_SAMPLE_SOFTWARE	16	; it's NOT using hardware mixing
!define BASS_SAMPLE_MUTEMAX		32	; muted at max distance (3D only)
!define BASS_SAMPLE_VAM			64	; uses the DX7 voice allocation & management
!define BASS_SAMPLE_FX			128	; old implementation of DX8 effects are enabled
!define BASS_SAMPLE_OVER_VOL	0x10000	; override lowest volume
!define BASS_SAMPLE_OVER_POS	0x20000	; override longest playing
!define BASS_SAMPLE_OVER_DIST	0x30000 ; override furthest from listener (3D only)

!define BASS_STREAM_PRESCAN		0x20000 ; enable pin-point seeking (MP3/MP2/MP1)
!define BASS_MP3_SETPOS			BASS_STREAM_PRESCAN
!define BASS_STREAM_AUTOFREE	0x40000	; automatically free the stream when it stop/ends
!define BASS_STREAM_RESTRATE	0x80000	; restrict the download rate of internet file streams
!define BASS_STREAM_BLOCK		0x100000 ; download/play internet file stream in small blocks
!define BASS_STREAM_DECODE		0x200000 ; don't play the stream, only decode (BASS_ChannelGetData)
!define BASS_STREAM_STATUS		0x800000 ; give server status info (HTTP/ICY tags) in DOWNLOADPROC

!define BASS_MUSIC_FLOAT		BASS_SAMPLE_FLOAT ; 32-bit floating-point
!define BASS_MUSIC_MONO			BASS_SAMPLE_MONO ; force mono mixing (less CPU usage)
!define BASS_MUSIC_LOOP			BASS_SAMPLE_LOOP ; loop music
!define BASS_MUSIC_3D			BASS_SAMPLE_3D ; enable 3D functionality
!define BASS_MUSIC_FX			BASS_SAMPLE_FX ; enable old implementation of DX8 effects
!define BASS_MUSIC_AUTOFREE		BASS_STREAM_AUTOFREE ; automatically free the music when it stop/ends
!define BASS_MUSIC_DECODE		BASS_STREAM_DECODE ; don't play the music, only decode (BASS_ChannelGetData)
!define BASS_MUSIC_PRESCAN		BASS_STREAM_PRESCAN	; calculate playback length
!define BASS_MUSIC_CALCLEN		BASS_MUSIC_PRESCAN
!define BASS_MUSIC_RAMP			0x200	; normal ramping
!define BASS_MUSIC_RAMPS		0x400	; sensitive ramping
!define BASS_MUSIC_SURROUND		0x800	; surround sound
!define BASS_MUSIC_SURROUND2	0x1000	; surround sound (mode 2)
!define BASS_MUSIC_FT2MOD		0x2000	; play .MOD as FastTracker 2 does
!define BASS_MUSIC_PT1MOD		0x4000	; play .MOD as ProTracker 1 does
!define BASS_MUSIC_NONINTER		0x10000	; non-interpolated mixing
!define BASS_MUSIC_POSRESET		0x8000	; stop all notes when moving position
!define BASS_MUSIC_POSRESETEX	0x400000 ; stop all notes and reset bmp/etc when moving position
!define BASS_MUSIC_STOPBACK		0x80000	; stop the music on a backwards jump effect
!define BASS_MUSIC_NOSAMPLE		0x100000 ; don't load the samples

; Speaker assignment flags
!define BASS_SPEAKER_FRONT	0x1000000	; front speakers
!define BASS_SPEAKER_REAR	0x2000000	; rear/side speakers
!define BASS_SPEAKER_CENLFE	0x3000000	; center & LFE speakers (5.1)
!define BASS_SPEAKER_REAR2	0x4000000	; rear center speakers (7.1)
!define BASS_SPEAKER_N(n)	((n)<<24)	; n'th pair of speakers (max 15)
!define BASS_SPEAKER_LEFT	0x10000000	; modifier: left
!define BASS_SPEAKER_RIGHT	0x20000000	; modifier: right
!define BASS_SPEAKER_FRONTLEFT	BASS_SPEAKER_FRONT|BASS_SPEAKER_LEFT
!define BASS_SPEAKER_FRONTRIGHT	BASS_SPEAKER_FRONT|BASS_SPEAKER_RIGHT
!define BASS_SPEAKER_REARLEFT	BASS_SPEAKER_REAR|BASS_SPEAKER_LEFT
!define BASS_SPEAKER_REARRIGHT	BASS_SPEAKER_REAR|BASS_SPEAKER_RIGHT
!define BASS_SPEAKER_CENTER		BASS_SPEAKER_CENLFE|BASS_SPEAKER_LEFT
!define BASS_SPEAKER_LFE		BASS_SPEAKER_CENLFE|BASS_SPEAKER_RIGHT
!define BASS_SPEAKER_REAR2LEFT	BASS_SPEAKER_REAR2|BASS_SPEAKER_LEFT
!define BASS_SPEAKER_REAR2RIGHT	BASS_SPEAKER_REAR2|BASS_SPEAKER_RIGHT

!define BASS_UNICODE			0x80000000

!define BASS_RECORD_PAUSE		0x8000	; start recording paused

!define MAKEMUSICPOS(order,row) (0x80000000|MAKELONG(order,row))

; DX7 voice allocation flags
!define BASS_VAM_HARDWARE		1
; Play the sample in hardware. If no hardware voices are available then
;the "play" call will fail
!define BASS_VAM_SOFTWARE		2
; Play the sample in software (ie. non-accelerated). No other VAM flags
; may be used together with this flag.

; DX7 voice management flags
; These flags enable hardware resource stealing... if the hardware has no
; available voices, a currently playing buffer will be stopped to make room for
; the new buffer. NOTE: only samples loaded/created with the BASS_SAMPLE_VAM
; flag are considered for termination by the DX7 voice management.
!define BASS_VAM_TERM_TIME		4
; If there are no free hardware voices, the buffer to be terminated will be
; the one with the least time left to play.
!define BASS_VAM_TERM_DIST		8
; If there are no free hardware voices, the buffer to be terminated will be
; one that was loaded/created with the BASS_SAMPLE_MUTEMAX flag and is beyond
; it's max distance. If there are no buffers that match this criteria, then the
; "play" call will fail.
!define BASS_VAM_TERM_PRIO		16
; If there are no free hardware voices, the buffer to be terminated will be
; the one with the lowest priority.

;typedef struct {
;	DWORD freq;		; default playback rate
;	DWORD chans;	; channels
;	DWORD flags;	; BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
;	DWORD ctype;	; type of channel
;	DWORD origres;	; original resolution
;	HPLUGIN plugin;	; plugin
;} BASS_CHANNELINFO;
!define BASS_CHANNELINFO "(i,i,i,i,i,i) i"

; BASS_CHANNELINFO types
!define BASS_CTYPE_SAMPLE		1
!define BASS_CTYPE_RECORD		2
!define BASS_CTYPE_STREAM		0x10000
!define BASS_CTYPE_STREAM_OGG	0x10002
!define BASS_CTYPE_STREAM_MP1	0x10003
!define BASS_CTYPE_STREAM_MP2	0x10004
!define BASS_CTYPE_STREAM_MP3	0x10005
!define BASS_CTYPE_STREAM_AIFF	0x10006
!define BASS_CTYPE_STREAM_WAV	0x40000 ; WAVE flag, LOWORD=codec
!define BASS_CTYPE_STREAM_WAV_PCM	0x50001
!define BASS_CTYPE_STREAM_WAV_FLOAT	0x50003
!define BASS_CTYPE_STREAM_WAV_MP3	0x50055
!define BASS_CTYPE_MUSIC_MOD	0x20000
!define BASS_CTYPE_MUSIC_MTM	0x20001
!define BASS_CTYPE_MUSIC_S3M	0x20002
!define BASS_CTYPE_MUSIC_XM		0x20003
!define BASS_CTYPE_MUSIC_IT		0x20004
!define BASS_CTYPE_MUSIC_MO3	0x00100 ; MO3 flag

;typedef struct {
;	DWORD ctype;		; channel type
;	const char *name;	; format description
;	const char *exts;	; file extension filter (*.ext1;*.ext2;etc...)
;} BASS_PLUGINFORM;
!define BASS_PLUGINFORM "(i,i,i) i"

;typedef struct {
;	DWORD version;					; version (same form as BASS_GetVersion)
;	DWORD formatc;					; number of formats
;	const BASS_PLUGINFORM *formats;	; the array of formats
;} BASS_PLUGININFO;
!define BASS_PLUGININFO "(i,i,i) i"

;; 3D vector (for 3D positions/velocities/orientations)
;typedef struct BASS_3DVECTOR {
;	float x;	; +=right, -=left
;	float y;	; +=up, -=down
;	float z;	; +=front, -=behind
;} BASS_3DVECTOR;
!define BASS_3DVECTOR "(i,i,i) i"

; 3D channel modes
!define BASS_3DMODE_NORMAL		0
; normal 3D processing 
!define BASS_3DMODE_RELATIVE	1
; The channel's 3D position (position/velocity/orientation) are relative to
; the listener. When the listener's position/velocity/orientation is changed
; with BASS_Set3DPosition, the channel's position relative to the listener does
; not change.

!define BASS_3DMODE_OFF			2
; Turn off 3D processing on the channel, the sound will be played
; in the center.

; EAX environments, use with BASS_SetEAXParameters
;enum
;{
;    EAX_ENVIRONMENT_GENERIC,
;    EAX_ENVIRONMENT_PADDEDCELL,
;    EAX_ENVIRONMENT_ROOM,
;    EAX_ENVIRONMENT_BATHROOM,
;    EAX_ENVIRONMENT_LIVINGROOM,
;    EAX_ENVIRONMENT_STONEROOM,
;    EAX_ENVIRONMENT_AUDITORIUM,
;    EAX_ENVIRONMENT_CONCERTHALL,
;    EAX_ENVIRONMENT_CAVE,
;    EAX_ENVIRONMENT_ARENA,
;    EAX_ENVIRONMENT_HANGAR,
;    EAX_ENVIRONMENT_CARPETEDHALLWAY,
;    EAX_ENVIRONMENT_HALLWAY,
;    EAX_ENVIRONMENT_STONECORRIDOR,
;    EAX_ENVIRONMENT_ALLEY,
;    EAX_ENVIRONMENT_FOREST,
;    EAX_ENVIRONMENT_CITY,
;    EAX_ENVIRONMENT_MOUNTAINS,
;    EAX_ENVIRONMENT_QUARRY,
;    EAX_ENVIRONMENT_PLAIN,
;    EAX_ENVIRONMENT_PARKINGLOT,
;    EAX_ENVIRONMENT_SEWERPIPE,
;    EAX_ENVIRONMENT_UNDERWATER,
;    EAX_ENVIRONMENT_DRUGGED,
;    EAX_ENVIRONMENT_DIZZY,
;    EAX_ENVIRONMENT_PSYCHOTIC,
;
;    EAX_ENVIRONMENT_COUNT			; total number of environments
;};

!define EAX_ENVIRONMENT_GENERIC		0
!define EAX_ENVIRONMENT_PADDEDCELL	1
!define EAX_ENVIRONMENT_ROOM		2
!define EAX_ENVIRONMENT_BATHROOM	3
!define EAX_ENVIRONMENT_LIVINGROOM	4
!define EAX_ENVIRONMENT_STONEROOM	5
!define EAX_ENVIRONMENT_AUDITORIUM	6
!define EAX_ENVIRONMENT_CONCERTHALL	7
!define EAX_ENVIRONMENT_CAVE		8
!define EAX_ENVIRONMENT_ARENA		9
!define EAX_ENVIRONMENT_HANGAR		10
!define EAX_ENVIRONMENT_CARPETEDHALLWAY	11
!define EAX_ENVIRONMENT_HALLWAY		12
!define EAX_ENVIRONMENT_STONECORRIDOR	13
!define EAX_ENVIRONMENT_ALLEY		14
!define EAX_ENVIRONMENT_FOREST		15
!define EAX_ENVIRONMENT_CITY		16
!define EAX_ENVIRONMENT_MOUNTAINS	17
!define EAX_ENVIRONMENT_QUARRY		18
!define EAX_ENVIRONMENT_PLAIN		19
!define EAX_ENVIRONMENT_PARKINGLOT	20
!define EAX_ENVIRONMENT_SEWERPIPE	21
!define EAX_ENVIRONMENT_UNDERWATER	22
!define EAX_ENVIRONMENT_DRUGGED		23
!define EAX_ENVIRONMENT_DIZZY		24
!define EAX_ENVIRONMENT_PSYCHOTIC	25

!define EAX_ENVIRONMENT_COUNT		26		; total number of environments




; EAX presets, usage: BASS_SetEAXParameters(EAX_PRESET_xxx)
!define EAX_PRESET_GENERIC         EAX_ENVIRONMENT_GENERIC,0.5F,1.493F,0.5F
!define EAX_PRESET_PADDEDCELL      EAX_ENVIRONMENT_PADDEDCELL,0.25F,0.1F,0.0F
!define EAX_PRESET_ROOM            EAX_ENVIRONMENT_ROOM,0.417F,0.4F,0.666F
!define EAX_PRESET_BATHROOM        EAX_ENVIRONMENT_BATHROOM,0.653F,1.499F,0.166F
!define EAX_PRESET_LIVINGROOM      EAX_ENVIRONMENT_LIVINGROOM,0.208F,0.478F,0.0F
!define EAX_PRESET_STONEROOM       EAX_ENVIRONMENT_STONEROOM,0.5F,2.309F,0.888F
!define EAX_PRESET_AUDITORIUM      EAX_ENVIRONMENT_AUDITORIUM,0.403F,4.279F,0.5F
!define EAX_PRESET_CONCERTHALL     EAX_ENVIRONMENT_CONCERTHALL,0.5F,3.961F,0.5F
!define EAX_PRESET_CAVE            EAX_ENVIRONMENT_CAVE,0.5F,2.886F,1.304F
!define EAX_PRESET_ARENA           EAX_ENVIRONMENT_ARENA,0.361F,7.284F,0.332F
!define EAX_PRESET_HANGAR          EAX_ENVIRONMENT_HANGAR,0.5F,10.0F,0.3F
!define EAX_PRESET_CARPETEDHALLWAY EAX_ENVIRONMENT_CARPETEDHALLWAY,0.153F,0.259F,2.0F
!define EAX_PRESET_HALLWAY         EAX_ENVIRONMENT_HALLWAY,0.361F,1.493F,0.0F
!define EAX_PRESET_STONECORRIDOR   EAX_ENVIRONMENT_STONECORRIDOR,0.444F,2.697F,0.638F
!define EAX_PRESET_ALLEY           EAX_ENVIRONMENT_ALLEY,0.25F,1.752F,0.776F
!define EAX_PRESET_FOREST          EAX_ENVIRONMENT_FOREST,0.111F,3.145F,0.472F
!define EAX_PRESET_CITY            EAX_ENVIRONMENT_CITY,0.111F,2.767F,0.224F
!define EAX_PRESET_MOUNTAINS       EAX_ENVIRONMENT_MOUNTAINS,0.194F,7.841F,0.472F
!define EAX_PRESET_QUARRY          EAX_ENVIRONMENT_QUARRY,1.0F,1.499F,0.5F
!define EAX_PRESET_PLAIN           EAX_ENVIRONMENT_PLAIN,0.097F,2.767F,0.224F
!define EAX_PRESET_PARKINGLOT      EAX_ENVIRONMENT_PARKINGLOT,0.208F,1.652F,1.5F
!define EAX_PRESET_SEWERPIPE       EAX_ENVIRONMENT_SEWERPIPE,0.652F,2.886F,0.25F
!define EAX_PRESET_UNDERWATER      EAX_ENVIRONMENT_UNDERWATER,1.0F,1.499F,0.0F
!define EAX_PRESET_DRUGGED         EAX_ENVIRONMENT_DRUGGED,0.875F,8.392F,1.388F
!define EAX_PRESET_DIZZY           EAX_ENVIRONMENT_DIZZY,0.139F,17.234F,0.666F
!define EAX_PRESET_PSYCHOTIC       EAX_ENVIRONMENT_PSYCHOTIC,0.486F,7.563F,0.806F

; software 3D mixing algorithm modes (used with BASS_Set3DAlgorithm)
!define BASS_3DALG_DEFAULT	0
; default algorithm (currently translates to BASS_3DALG_OFF)
!define BASS_3DALG_OFF		1
; Uses normal left and right panning. The vertical axis is ignored except for
; scaling of volume due to distance. Doppler shift and volume scaling are still
; applied, but the 3D filtering is not performed. This is the most CPU efficient
; software implementation, but provides no virtual 3D audio effect. Head Related
; Transfer Function processing will not be done. Since only normal stereo panning
; is used, a channel using this algorithm may be accelerated by a 2D hardware
; voice if no free 3D hardware voices are available.
!define BASS_3DALG_FULL		2
; This algorithm gives the highest quality 3D audio effect, but uses more CPU.
; Requires Windows 98 2nd Edition or Windows 2000 that uses WDM drivers, if this
; mode is not available then BASS_3DALG_OFF will be used instead.
!define BASS_3DALG_LIGHT	3
; This algorithm gives a good 3D audio effect, and uses less CPU than the FULL
; mode. Requires Windows 98 2nd Edition or Windows 2000 that uses WDM drivers, if
; this mode is not available then BASS_3DALG_OFF will be used instead.

;typedef DWORD (CALLBACK STREAMPROC)(HSTREAM handle, void *buffer, DWORD length, DWORD user);
!define STREAMPROC "(i,v,i,i) i"
; User stream callback function. NOTE: A stream function should obviously be as quick
; as possible, other streams (and MOD musics) can't be mixed until it's finished.
; handle : The stream that needs writing
; buffer : Buffer to write the samples in
; length : Number of bytes to write
; user   : The 'user' parameter value given when calling BASS_StreamCreate
; RETURN : Number of bytes written. Set the BASS_STREAMPROC_END flag to end
;          the stream.

!define BASS_STREAMPROC_END		0x80000000	; end of user stream flag

; BASS_StreamGetFilePosition modes
!define BASS_FILEPOS_CURRENT	0
!define BASS_FILEPOS_DECODE		BASS_FILEPOS_CURRENT
!define BASS_FILEPOS_DOWNLOAD	1
!define BASS_FILEPOS_END		2
!define BASS_FILEPOS_START		3
!define BASS_FILEPOS_CONNECTED	4

; STREAMFILEPROC actions
!define BASS_FILE_CLOSE		0
!define BASS_FILE_READ		1
!define BASS_FILE_LEN		3
!define BASS_FILE_SEEK		4

;typedef DWORD (CALLBACK STREAMFILEPROC)(DWORD action, DWORD param1, DWORD param2, DWORD user);
!define STREAMFILEPROC "(i,i,i,i) i"
; User file stream callback function.
; action : The action to perform, one of BASS_FILE_xxx values.
; param1 : Depends on "action"
; param2 : Depends on "action"
; user   : The 'user' parameter value given when calling BASS_StreamCreate
; RETURN : Depends on "action"

;typedef void (CALLBACK DOWNLOADPROC)(const void *buffer, DWORD length, DWORD user);
!define DOWNLOADPROC "(v,i,i) v"
; Internet stream download callback function.
; buffer : Buffer containing the downloaded data... NULL=end of download
; length : Number of bytes in the buffer
; user   : The 'user' parameter value given when calling BASS_StreamCreateURL

; Sync types (with BASS_ChannelSetSync "param" and SYNCPROC "data"
; definitions) & flags.
!define BASS_SYNC_POS	0
; Sync when a channel reaches a position.
; param: position in bytes
; data : not used
!define BASS_SYNC_END		2
; Sync when a channel reaches the end.
; param: not used
; data : 1 = the sync is triggered by a backward jump in a MOD music, otherwise not used
!define BASS_SYNC_META		4
; Sync when metadata is received in a stream.
; param: not used
; data : pointer to the metadata 
!define BASS_SYNC_SLIDE		5
; Sync when an attribute slide is completed.
; param: not used
; data : the type of slide completed (one of the BASS_SLIDE_xxx values)
!define BASS_SYNC_STALL		6
; Sync when playback has stalled.
; param: not used
; data : 0=stalled, 1=resumed 
!define BASS_SYNC_DOWNLOAD	7
; Sync when downloading of an internet (or "buffered" user file) stream has ended.
; param: not used
; data : not used
!define BASS_SYNC_FREE	8
; Sync when a channel is freed.
; param: not used
; data : not used
!define BASS_SYNC_SETPOS	11
; Sync when a channel's position is set.
; param: not used
; data : 0 = playback buffer not flushed, 1 = playback buffer flushed
!define BASS_SYNC_MUSICPOS		10
; Sync when a MOD music reaches an order:row position.
; param: LOWORD=order (0=first, -1=all) HIWORD=row (0=first, -1=all)
; data : LOWORD=order HIWORD=row
!define BASS_SYNC_MUSICINST	1
; Sync when an instrument (sample for the non-instrument based formats)
; is played in a MOD music (not including retrigs).
; param: LOWORD=instrument (1=first) HIWORD=note (0=c0...119=b9, -1=all)
; data : LOWORD=note HIWORD=volume (0-64)
!define BASS_SYNC_MUSICFX	3
; Sync when the "sync" effect (XM/MTM/MOD: E8x/Wxx, IT/S3M: S2x) is used.
; param: 0:data=pos, 1:data="x" value
; data : param=0: LOWORD=order HIWORD=row, param=1: "x" value
!define BASS_SYNC_MESSAGE	0x20000000	; FLAG: post a Windows message (instead of callback)
; When using a window message "callback", the message to post is given in the "proc"
; parameter of BASS_ChannelSetSync, and is posted to the window specified in the BASS_Init
; call. The message parameters are: WPARAM = data, LPARAM = user.
!define BASS_SYNC_MIXTIME	0x40000000	; FLAG: sync at mixtime, else at playtime
!define BASS_SYNC_ONETIME	0x80000000	; FLAG: sync only once, else continuously

;typedef void (CALLBACK SYNCPROC)(HSYNC handle, DWORD channel, DWORD data, DWORD user);
!define SYNCPROC "(i,i,i,i) v"

; Sync callback function. NOTE: a sync callback function should be very
; quick as other syncs can't be processed until it has finished. If the sync
; is a "mixtime" sync, then other streams and MOD musics can't be mixed until
; it's finished either.
; handle : The sync that has occured
; channel: Channel that the sync occured in
; data   : Additional data associated with the sync's occurance
; user   : The 'user' parameter given when calling BASS_ChannelSetSync

;typedef void (CALLBACK DSPPROC)(HDSP handle, DWORD channel, void *buffer, DWORD length, DWORD user);
!define DSPPROC "(i,i,v,i,i) v"
; DSP callback function. NOTE: A DSP function should obviously be as quick as
; possible... other DSP functions, streams and MOD musics can not be processed
; until it's finished.
; handle : The DSP handle
; channel: Channel that the DSP is being applied to
; buffer : Buffer to apply the DSP to
; length : Number of bytes in the buffer
; user   : The 'user' parameter given when calling BASS_ChannelSetDSP

;typedef BOOL (CALLBACK RECORDPROC)(HRECORD handle, const void *buffer, DWORD length, DWORD user);
!define RECORDPROC "(i,v,i,i) b"
; Recording callback function.
; handle : The recording handle
; buffer : Buffer containing the recorded sample data
; length : Number of bytes
; user   : The 'user' parameter value given when calling BASS_RecordStart
; RETURN : TRUE = continue recording, FALSE = stop

; BASS_ChannelGetData flags
!define BASS_DATA_AVAILABLE	0			; query how much data is buffered
!define BASS_DATA_FLOAT		0x40000000	; flag: return floating-point sample data
!define BASS_DATA_FFT512	0x80000000	; 512 sample FFT
!define BASS_DATA_FFT1024	0x80000001	; 1024 FFT
!define BASS_DATA_FFT2048	0x80000002	; 2048 FFT
!define BASS_DATA_FFT4096	0x80000003	; 4096 FFT
!define BASS_DATA_FFT8192	0x80000004	; 8192 FFT
!define BASS_DATA_FFT_INDIVIDUAL 0x10	; FFT flag: FFT for each channel, else all combined
!define BASS_DATA_FFT_NOWINDOW	0x20	; FFT flag: no Hanning window

; BASS_ChannelGetTags types : what's returned
!define BASS_TAG_ID3		0	; ID3v1 tags : 128 byte block
!define BASS_TAG_ID3V2		1	; ID3v2 tags : variable length block
!define BASS_TAG_OGG		2	; OGG comments : array of null-terminated UTF-8 strings
!define BASS_TAG_HTTP		3	; HTTP headers : array of null-terminated ANSI strings
!define BASS_TAG_ICY		4	; ICY headers : array of null-terminated ANSI strings
!define BASS_TAG_META		5	; ICY metadata : ANSI string
!define BASS_TAG_VENDOR		9	; OGG encoder : UTF-8 string
!define BASS_TAG_LYRICS3	10	; Lyric3v2 tag : ASCII string
!define BASS_TAG_RIFF_INFO	0x100 ; RIFF/WAVE tags : array of null-terminated ANSI strings
!define BASS_TAG_MUSIC_NAME		0x10000	; MOD music name : ANSI string
!define BASS_TAG_MUSIC_MESSAGE	0x10001	; MOD message : ANSI string
!define BASS_TAG_MUSIC_INST		0x10100	; + instrument #, MOD instrument name : ANSI string
!define BASS_TAG_MUSIC_SAMPLE	0x10300	; + sample #, MOD sample name : ANSI string

; BASS_MusicSet/GetAttribute options
!define BASS_MUSIC_ATTRIB_AMPLIFY	0
!define BASS_MUSIC_ATTRIB_PANSEP	1
!define BASS_MUSIC_ATTRIB_PSCALER	2
!define BASS_MUSIC_ATTRIB_BPM		3
!define BASS_MUSIC_ATTRIB_SPEED		4
!define BASS_MUSIC_ATTRIB_VOL_GLOBAL 5
!define BASS_MUSIC_ATTRIB_VOL_CHAN	0x100 ; + channel #
!define BASS_MUSIC_ATTRIB_VOL_INST	0x200 ; + instrument #

; DX8 effect types, use with BASS_ChannelSetFX
;enum
;{
;	BASS_FX_CHORUS,			; GUID_DSFX_STANDARD_CHORUS
;	BASS_FX_COMPRESSOR,		; GUID_DSFX_STANDARD_COMPRESSOR
;	BASS_FX_DISTORTION,		; GUID_DSFX_STANDARD_DISTORTION
;	BASS_FX_ECHO,			; GUID_DSFX_STANDARD_ECHO
;	BASS_FX_FLANGER,		; GUID_DSFX_STANDARD_FLANGER
;	BASS_FX_GARGLE,			; GUID_DSFX_STANDARD_GARGLE
;	BASS_FX_I3DL2REVERB,	; GUID_DSFX_STANDARD_I3DL2REVERB
;	BASS_FX_PARAMEQ,		; GUID_DSFX_STANDARD_PARAMEQ
;	BASS_FX_REVERB			; GUID_DSFX_WAVES_REVERB
;};

!define BASS_FX_CHORUS		0	; GUID_DSFX_STANDARD_CHORUS
!define BASS_FX_COMPRESSOR	1		; GUID_DSFX_STANDARD_COMPRESSOR
!define BASS_FX_DISTORTION	2		; GUID_DSFX_STANDARD_DISTORTION
!define BASS_FX_ECHO		3	; GUID_DSFX_STANDARD_ECHO
!define BASS_FX_FLANGER		4	; GUID_DSFX_STANDARD_FLANGER
!define BASS_FX_GARGLE		5	; GUID_DSFX_STANDARD_GARGLE
!define BASS_FX_I3DL2REVERB	6	; GUID_DSFX_STANDARD_I3DL2REVERB
!define BASS_FX_PARAMEQ		7		; GUID_DSFX_STANDARD_PARAMEQ
!define BASS_FX_REVERB		8			; GUID_DSFX_WAVES_REVERB

;typedef struct {
;    float       fWetDryMix;
;    float       fDepth;
;    float       fFeedback;
;    float       fFrequency;
;    DWORD       lWaveform;	; 0=triangle, 1=sine
;    float       fDelay;
;    DWORD       lPhase;		; BASS_FX_PHASE_xxx
;} BASS_FXCHORUS;		; DSFXChorus
!define BASS_FXCHORUS "(i,i,i,i,i,i,i) i"

;typedef struct {
;    float   fGain;
;    float   fAttack;
;    float   fRelease;
;    float   fThreshold;
;    float   fRatio;
;    float   fPredelay;
;} BASS_FXCOMPRESSOR;	; DSFXCompressor
!define BASS_FXCOMPRESSOR "(i,i,i,i,i,i) i"

;typedef struct {
;    float   fGain;
;    float   fEdge;
;    float   fPostEQCenterFrequency;
;    float   fPostEQBandwidth;
;    float   fPreLowpassCutoff;
;} BASS_FXDISTORTION;	; DSFXDistortion
!define BASS_FXDISTORTION "(i,i,i,i,i) i"

;typedef struct {
;    float   fWetDryMix;
;    float   fFeedback;
;    float   fLeftDelay;
;    float   fRightDelay;
;    BOOL    lPanDelay;
;} BASS_FXECHO;			; DSFXEcho
!define BASS_FXECHO "(i,i,i,i,b) i"

;typedef struct {
;    float       fWetDryMix;
;    float       fDepth;
;    float       fFeedback;
;    float       fFrequency;
;    DWORD       lWaveform;	; 0=triangle, 1=sine
;    float       fDelay;
;    DWORD       lPhase;		; BASS_FX_PHASE_xxx
;} BASS_FXFLANGER;		; DSFXFlanger
!define BASS_FXFLANGER "(i,i,i,i,i,i,i) i"

;typedef struct {
;    DWORD       dwRateHz;               ; Rate of modulation in hz
;    DWORD       dwWaveShape;            ; 0=triangle, 1=square
;} BASS_FXGARGLE;		; DSFXGargle
!define BASS_FXGARGLE "(i,i) i"

;typedef struct {
;    int     lRoom;                  ; [-10000, 0]      default: -1000 mB
;    int     lRoomHF;                ; [-10000, 0]      default: 0 mB
;    float   flRoomRolloffFactor;    ; [0.0, 10.0]      default: 0.0
;    float   flDecayTime;            ; [0.1, 20.0]      default: 1.49s
;    float   flDecayHFRatio;         ; [0.1, 2.0]       default: 0.83
;    int     lReflections;           ; [-10000, 1000]   default: -2602 mB
;    float   flReflectionsDelay;     ; [0.0, 0.3]       default: 0.007 s
;    int     lReverb;                ; [-10000, 2000]   default: 200 mB
;    float   flReverbDelay;          ; [0.0, 0.1]       default: 0.011 s
;    float   flDiffusion;            ; [0.0, 100.0]     default: 100.0 %
;    float   flDensity;              ; [0.0, 100.0]     default: 100.0 %
;    float   flHFReference;          ; [20.0, 20000.0]  default: 5000.0 Hz
;} BASS_FXI3DL2REVERB;	; DSFXI3DL2Reverb
!define BASS_FXI3DL2REVERB "(i,i,i,i,i,i,i,i,i,i,i,i) i"

;typedef struct {
;    float   fCenter;
;    float   fBandwidth;
;    float   fGain;
;} BASS_FXPARAMEQ;		; DSFXParamEq
!define BASS_FXPARAMEQ "(i,i,i) i"

;typedef struct {
;    float   fInGain;                ; [-96.0,0.0]            default: 0.0 dB
;    float   fReverbMix;             ; [-96.0,0.0]            default: 0.0 db
;    float   fReverbTime;            ; [0.001,3000.0]         default: 1000.0 ms
;    float   fHighFreqRTRatio;       ; [0.001,0.999]          default: 0.001
;} BASS_FXREVERB;		; DSFXWavesReverb
!define BASS_FXREVERB "(i,i,i,i) i"

!define BASS_FX_PHASE_NEG_180        0
!define BASS_FX_PHASE_NEG_90         1
!define BASS_FX_PHASE_ZERO           2
!define BASS_FX_PHASE_90             3
!define BASS_FX_PHASE_180            4

; BASS_ChannelIsActive return values
!define BASS_ACTIVE_STOPPED	0
!define BASS_ACTIVE_PLAYING	1
!define BASS_ACTIVE_STALLED	2
!define BASS_ACTIVE_PAUSED	3

; BASS_ChannelIsSliding return flags
!define BASS_SLIDE_FREQ	1
!define BASS_SLIDE_VOL	2
!define BASS_SLIDE_PAN	4

; BASS_RecordSetInput flags
!define BASS_INPUT_OFF		0x10000
!define BASS_INPUT_ON		0x20000
!define BASS_INPUT_LEVEL	0x40000

!define BASS_INPUT_TYPE_MASK		0xff000000
!define BASS_INPUT_TYPE_UNDEF		0x00000000
!define BASS_INPUT_TYPE_DIGITAL		0x01000000
!define BASS_INPUT_TYPE_LINE		0x02000000
!define BASS_INPUT_TYPE_MIC			0x03000000
!define BASS_INPUT_TYPE_SYNTH		0x04000000
!define BASS_INPUT_TYPE_CD			0x05000000
!define BASS_INPUT_TYPE_PHONE		0x06000000
!define BASS_INPUT_TYPE_SPEAKER		0x07000000
!define BASS_INPUT_TYPE_WAVE		0x08000000
!define BASS_INPUT_TYPE_AUX			0x09000000
!define BASS_INPUT_TYPE_ANALOG		0x0a000000

; BASS_Set/GetConfig options
!define BASS_CONFIG_BUFFER			0
!define BASS_CONFIG_UPDATEPERIOD	1
!define BASS_CONFIG_MAXVOL			3
!define BASS_CONFIG_GVOL_SAMPLE		4
!define BASS_CONFIG_GVOL_STREAM		5
!define BASS_CONFIG_GVOL_MUSIC		6
!define BASS_CONFIG_CURVE_VOL		7
!define BASS_CONFIG_CURVE_PAN		8
!define BASS_CONFIG_FLOATDSP		9
!define BASS_CONFIG_3DALGORITHM		10
!define BASS_CONFIG_NET_TIMEOUT		11
!define BASS_CONFIG_NET_BUFFER		12
!define BASS_CONFIG_PAUSE_NOPLAY	13
!define BASS_CONFIG_NET_PREBUF		15
!define BASS_CONFIG_NET_AGENT		16
!define BASS_CONFIG_NET_PROXY		17
!define BASS_CONFIG_NET_PASSIVE		18
!define BASS_CONFIG_REC_BUFFER		19
!define BASS_CONFIG_NET_PLAYLIST	21
!define BASS_CONFIG_MUSIC_VIRTUAL	22

;DWORD BASSDEF(BASS_SetConfig)(DWORD option, DWORD value);
!define bfnSetConfig "${BASS_DLL}::BASS_SetConfig(i,i) i"
;DWORD BASSDEF(BASS_GetConfig)(DWORD option);
!define bfnGetConfig "${BASS_DLL}::BASS_GetConfig(i) i"
;DWORD BASSDEF(BASS_GetVersion)();
!define bfnGetVersion "${BASS_DLL}::BASS_GetVersion()i"
;const char *BASSDEF(BASS_GetDeviceDescription)(DWORD device);
!define bfnGetDeviceDescription "${BASS_DLL}::BASS_GetDeviceDescription(i) i"
;int BASSDEF(BASS_ErrorGetCode)();
!define bfnErrorGetCode "${BASS_DLL}::BASS_ErrorGetCode() i"
;BOOL BASSDEF(BASS_Init)(int device, DWORD freq, DWORD flags, HWND win, const GUID *dsguid);
!define bfnInit "${BASS_DLL}::BASS_Init(i,i,i,i,i,i) b"
;BOOL BASSDEF(BASS_SetDevice)(DWORD device);
!define bfnSetDevice "${BASS_DLL}::BASS_SetDevice(i) b"
;DWORD BASSDEF(BASS_GetDevice)();
!define bfnGetDevice "${BASS_DLL}::BASS_GetDevice() i"
;BOOL BASSDEF(BASS_Free)();
!define bfnFree "${BASS_DLL}::BASS_Free() b"
;void *BASSDEF(BASS_GetDSoundObject)(DWORD object);
!define bfnGetDSoundObject "${BASS_DLL}::BASS_GetDSoundObject(i) v"
;BOOL BASSDEF(BASS_GetInfo)(BASS_INFO *info);
!define bfnGetInfo "${BASS_DLL}::BASS_GetInfo(*${BASS_INFO}) b"
;BOOL BASSDEF(BASS_Update)();
!define bfnUpdate "${BASS_DLL}::BASS_Update() b"
;float BASSDEF(BASS_GetCPU)();
!define bfnGetCPU "${BASS_DLL}::BASS_GetCPU() i"
;BOOL BASSDEF(BASS_Start)();
!define bfnStart "${BASS_DLL}::BASS_Start() b"
;BOOL BASSDEF(BASS_Stop)();
!define bfnStop "${BASS_DLL}::BASS_Stop() b"
;BOOL BASSDEF(BASS_Pause)();
!define bfnPause "${BASS_DLL}::BASS_Pause() b"
;BOOL BASSDEF(BASS_SetVolume)(DWORD volume);
!define bfnSetVolume "${BASS_DLL}::BASS_SetVolume(i) b"
;DWORD BASSDEF(BASS_GetVolume)();
!define bfnGetVolume "${BASS_DLL}::BASS_GetVolume() i"

;HPLUGIN BASSDEF(BASS_PluginLoad)(const char *file, DWORD flags);
!define bfnPluginLoad "${BASS_DLL}::BASS_PluginLoad(t,i) i"
;BOOL BASSDEF(BASS_PluginFree)(HPLUGIN handle);
!define bfnPluginFree "${BASS_DLL}::BASS_PluginFree(i) b"
;const BASS_PLUGININFO *BASSDEF(BASS_PluginGetInfo)(HPLUGIN handle);
!define bfnPluginGetInfo "${BASS_DLL}::BASS_PluginGetInfo(i) i"
;BOOL BASSDEF(BASS_Set3DFactors)(float distf, float rollf, float doppf);
!define bfnSet3DFactors "${BASS_DLL}::BASS_Set3DFactors(i,i,i) b"
;BOOL BASSDEF(BASS_Get3DFactors)(float *distf, float *rollf, float *doppf);
!define bfnGet3DFactors "${BASS_DLL}::BASS_Get3DFactors(i,i,i) b"
;BOOL BASSDEF(BASS_Set3DPosition)(const BASS_3DVECTOR *pos, const BASS_3DVECTOR *vel, const BASS_3DVECTOR *front, const BASS_3DVECTOR *top);
!define bfnSet3DPosition "${BASS_DLL}::BASS_Set3DPosition(*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR}) b"
;BOOL BASSDEF(BASS_Get3DPosition)(BASS_3DVECTOR *pos, BASS_3DVECTOR *vel, BASS_3DVECTOR *front, BASS_3DVECTOR *top);
!define bfnGet3DPosition "${BASS_DLL}::BASS_Get3DPosition(*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR}) b"
;void BASSDEF(BASS_Apply3D)();
!define bfnApply3D "${BASS_DLL}::BASS_Apply3D() v"

;BOOL BASSDEF(BASS_SetEAXParameters)(int env, float vol, float decay, float damp);
!define bfnSetEAXParameters "${BASS_DLL}::BASS_SetEAXParameters(i,i,i,i) b"
;BOOL BASSDEF(BASS_GetEAXParameters)(DWORD *env, float *vol, float *decay, float *damp);
!define bfnGetEAXParameters "${BASS_DLL}::BASS_GetEAXParameters(i,i,i,i) b"


;HMUSIC BASSDEF(BASS_MusicLoad)(BOOL mem, const void *file, DWORD offset, DWORD length, DWORD flags, DWORD freq);
!define bfnMusicLoad "${BASS_DLL}::BASS_MusicLoad(b,t,i,i,i,i) i"
;BOOL BASSDEF(BASS_MusicFree)(HMUSIC handle);
!define bfnMusicFree "${BASS_DLL}::BASS_MusicFree(i) b"
;DWORD BASSDEF(BASS_MusicSetAttribute)(HMUSIC handle, DWORD attrib, DWORD value);
!define bfnMusicSetAttribute "${BASS_DLL}::BASS_MusicSetAttribute(i,i,i) i"
;DWORD BASSDEF(BASS_MusicGetAttribute)(HMUSIC handle, DWORD attrib);
!define bfnMusicGetAttribute "${BASS_DLL}::BASS_MusicGetAttribute(i,i) i"
;DWORD BASSDEF(BASS_MusicGetOrders)(HMUSIC handle);
!define bfnMusicGetOrders "${BASS_DLL}::BASS_MusicGetOrders(i) i"
;DWORD BASSDEF(BASS_MusicGetOrderPosition)(HMUSIC handle);
!define bfnMusicGetOrderPosition "${BASS_DLL}::BASS_MusicGetOrderPosition(i) i"

;HSAMPLE BASSDEF(BASS_SampleLoad)(BOOL mem, const void *file, DWORD offset, DWORD length, DWORD max, DWORD flags);
!define bfnSampleLoad "${BASS_DLL}::BASS_SampleLoad(b,t,i,i,i,i) i"
;void* BASSDEF(BASS_SampleCreate)(DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags);
!define bfnSampleCreate "${BASS_DLL}::BASS_SampleCreate(i,i,i,i,i) v"
;HSAMPLE BASSDEF(BASS_SampleCreateDone)();
!define bfnSampleCreateDone "${BASS_DLL}::BASS_ SampleCreateDone() i"
;BOOL BASSDEF(BASS_SampleFree)(HSAMPLE handle);
!define bfnSampleFree "${BASS_DLL}::BASS_SampleFree(i) b"
;BOOL BASSDEF(BASS_SampleGetInfo)(HSAMPLE handle, BASS_SAMPLE *info);
!define bfnSampleGetInfo "${BASS_DLL}::BASS_SampleGetInfo(i,*${BASS_SAMPLE}) b"
;BOOL BASSDEF(BASS_SampleSetInfo)(HSAMPLE handle, const BASS_SAMPLE *info);
!define bfnSampleSetInfo "${BASS_DLL}::BASS_SampleSetInfo(i,*${BASS_SAMPLE}) b"
;HCHANNEL BASSDEF(BASS_SampleGetChannel)(HSAMPLE handle, BOOL onlynew);
!define bfnSampleGetChannel "${BASS_DLL}::BASS_SampleGetChannel(i,b) i"
;DWORD BASSDEF(BASS_SampleGetChannels)(HSAMPLE handle, HCHANNEL *channels);
!define bfnSampleGetChannels "${BASS_DLL}::BASS_SampleGetChannels(i,i) i"
;BOOL BASSDEF(BASS_SampleStop)(HSAMPLE handle);
!define bfnSampleStop "${BASS_DLL}::BASS_SampleStop(i) b"

;HSTREAM BASSDEF(BASS_StreamCreate)(DWORD freq, DWORD chans, DWORD flags, STREAMPROC *proc, DWORD user);
!define bfnStreamCreate "${BASS_DLL}::BASS_StreamCreate(i,i,i,*${STREAMPROC},i) i"
;HSTREAM BASSDEF(BASS_StreamCreateFile)(BOOL mem, const void *file, DWORD offset, DWORD length, DWORD flags);
!define bfnStreamCreateFile "${BASS_DLL}::BASS_StreamCreateFile(b,t,i,i,i) i"
;HSTREAM BASSDEF(BASS_StreamCreateURL)(const char *url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, DWORD user);
;!define bfnStreamCreateURL "${BASS_DLL}::BASS_StreamCreateURL(i,i,i,*${DOWNLOADPROC},i) i"
!define bfnStreamCreateURL "${BASS_DLL}::BASS_StreamCreateURL(t,i,i,n,i) i"
;HSTREAM BASSDEF(BASS_StreamCreateFileUser)(BOOL buffered, DWORD flags, STREAMFILEPROC *proc, DWORD user);
!define bfnStreamCreateFileUser "${BASS_DLL}::BASS_StreamCreateFileUser(b,i,*${STREAMFILEPROC},i) i"
;BOOL BASSDEF(BASS_StreamFree)(HSTREAM handle);
!define bfnStreamFree "${BASS_DLL}::BASS_StreamFree(i) b"
;DWORD BASSDEF(BASS_StreamGetFilePosition)(HSTREAM handle, DWORD mode);
!define bfnStreamGetFilePosition "${BASS_DLL}::BASS_StreamGetFilePosition(i,i) i"

;const char *BASSDEF(BASS_RecordGetDeviceDescription)(DWORD device);
!define bfnRecordGetDeviceDescription "${BASS_DLL}::BASS_RecordGetDeviceDescription(i) i"
;BOOL BASSDEF(BASS_RecordInit)(int device);
!define bfnRecordInit "${BASS_DLL}::BASS_RecordInit(i) b"
;BOOL BASSDEF(BASS_RecordSetDevice)(DWORD device);
!define bfnRecordSetDevice "${BASS_DLL}::BASS_RecordSetDevice(i) b"
;DWORD BASSDEF(BASS_RecordGetDevice)();
!define bfnRecordGetDevice "${BASS_DLL}::BASS_RecordGetDevice() i"
;BOOL BASSDEF(BASS_RecordFree)();
!define bfnRecordFree "${BASS_DLL}::BASS_RecordFree() b"
;BOOL BASSDEF(BASS_RecordGetInfo)(BASS_RECORDINFO *info);
!define bfnRecordGetInfo "${BASS_DLL}::BASS_RecordGetInfo(*${BASS_RECORDINFO}) b"
;const char *BASSDEF(BASS_RecordGetInputName)(int input);
!define bfnRecordGetInputName "${BASS_DLL}::BASS_RecordGetInputName(i) i"
;BOOL BASSDEF(BASS_RecordSetInput)(int input, DWORD setting);
!define bfnRecordSetInput "${BASS_DLL}::BASS_ RecordSetInput(i,i) b"
;DWORD BASSDEF(BASS_RecordGetInput)(int input);
!define bfnRecordGetInput "${BASS_DLL}::BASS_RecordGetInput(i) i"
;HRECORD BASSDEF(BASS_RecordStart)(DWORD freq, DWORD chans, DWORD flags, RECORDPROC *proc, DWORD user);
!define bfnRecordStart "${BASS_DLL}::BASS_RecordStart(i,i,i,*${RECORDPROC},i) i"

;float BASSDEF(BASS_ChannelBytes2Seconds)(DWORD handle, QWORD pos);
!define bfnChannelBytes2Seconds "${BASS_DLL}::BASS_ChannelBytes2Seconds(i,i) i"
;QWORD BASSDEF(BASS_ChannelSeconds2Bytes)(DWORD handle, float pos);
!define bfnChannelSeconds2Bytes "${BASS_DLL}::BASS_ChannelSeconds2Bytes(i,i) i"
;DWORD BASSDEF(BASS_ChannelGetDevice)(DWORD handle);
!define bfnChannelGetDevice "${BASS_DLL}::BASS_ChannelGetDevice(i) i"
;BOOL BASSDEF(BASS_ChannelSetDevice)(DWORD handle, DWORD device);
!define bfnChannelSetDevice "${BASS_DLL}::BASS_ChannelSetDevice(i,i) b"
;DWORD BASSDEF(BASS_ChannelIsActive)(DWORD handle);
!define bfnChannelIsActive "${BASS_DLL}::BASS_ChannelIsActive(i) i"
;BOOL BASSDEF(BASS_ChannelGetInfo)(DWORD handle, BASS_CHANNELINFO *info);
!define bfnChannelGetInfo "${BASS_DLL}::BASS_ChannelGetInfo(i,*${BASS_CHANNELINFO}) b"
;const char *BASSDEF(BASS_ChannelGetTags)(DWORD handle, DWORD tags);
!define bfnChannelGetTags "${BASS_DLL}::BASS_ChannelGetTags(i,i) t"
;BOOL BASSDEF(BASS_ChannelSetFlags)(DWORD handle, DWORD flags);
!define bfnChannelSetFlags "${BASS_DLL}::BASS_ChannelSetFlags(i,i) b"
;BOOL BASSDEF(BASS_ChannelPreBuf)(DWORD handle, DWORD length);
!define bfnChannelPreBuf "${BASS_DLL}::BASS_ChannelPreBuf(i,i) b"
;BOOL BASSDEF(BASS_ChannelPlay)(DWORD handle, BOOL restart);
!define bfnChannelPlay "${BASS_DLL}::BASS_ChannelPlay(i,b) b"
;BOOL BASSDEF(BASS_ChannelStop)(DWORD handle);
!define bfnChannelStop "${BASS_DLL}::BASS_ChannelStop(i) b"
;BOOL BASSDEF(BASS_ChannelPause)(DWORD handle);
!define bfnChannelPause "${BASS_DLL}::BASS_ChannelPause(i) b"
;BOOL BASSDEF(BASS_ChannelSetAttributes)(DWORD handle, int freq, int volume, int pan);
!define bfnChannelSetAttributes "${BASS_DLL}::BASS_ChannelSetAttributes(i,i,i,i) b"
;BOOL BASSDEF(BASS_ChannelGetAttributes)(DWORD handle, DWORD *freq, DWORD *volume, int *pan);
!define bfnChannelGetAttributes "${BASS_DLL}::BASS_ChannelGetAttributes(i,i,i,i) b"
;BOOL BASSDEF(BASS_ChannelSlideAttributes)(DWORD handle, int freq, int volume, int pan, DWORD time);
!define bfnChannelSlideAttributes "${BASS_DLL}::BASS_ChannelSlideAttributes(i,i,i,i,i) b"
;DWORD BASSDEF(BASS_ChannelIsSliding)(DWORD handle);
!define bfnChannelIsSliding "${BASS_DLL}::BASS_ChannelIsSliding(i) i"
;BOOL BASSDEF(BASS_ChannelSet3DAttributes)(DWORD handle, int mode, float min, float max, int iangle, int oangle, int outvol);
!define bfnChannelSet3DAttributes "${BASS_DLL}::BASS_ChannelSet3DAttributes(i,i,i,i,i,i,i) b"
;BOOL BASSDEF(BASS_ChannelGet3DAttributes)(DWORD handle, DWORD *mode, float *min, float *max, DWORD *iangle, DWORD *oangle, DWORD *outvol);
!define bfnChannelGet3DAttributes "${BASS_DLL}::BASS_ChannelGet3DAttributes(i,i,i,i,i,i,i) b"
;BOOL BASSDEF(BASS_ChannelSet3DPosition)(DWORD handle, const BASS_3DVECTOR *pos, const BASS_3DVECTOR *orient, const BASS_3DVECTOR *vel);
!define bfnChannelSet3DPosition "${BASS_DLL}::BASS_ChannelSet3DPosition(i,*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR}) b"
;BOOL BASSDEF(BASS_ChannelGet3DPosition)(DWORD handle, BASS_3DVECTOR *pos, BASS_3DVECTOR *orient, BASS_3DVECTOR *vel);
!define bfnChannelGet3DPosition "${BASS_DLL}::BASS_ChannelGet3DPosition(i,*${BASS_3DVECTOR},*${BASS_3DVECTOR},*${BASS_3DVECTOR}) b"
;QWORD BASSDEF(BASS_ChannelGetLength)(DWORD handle);
!define bfnChannelGetLength "${BASS_DLL}::BASS_ChannelGetLength(i) i"
;BOOL BASSDEF(BASS_ChannelSetPosition)(DWORD handle, QWORD pos);
!define bfnChannelSetPosition "${BASS_DLL}::BASS_ChannelSetPosition(i,i) b"
;QWORD BASSDEF(BASS_ChannelGetPosition)(DWORD handle);
!define bfnChannelGetPosition "${BASS_DLL}::BASS_ChannelGetPosition(i) i"
;DWORD BASSDEF(BASS_ChannelGetLevel)(DWORD handle);
!define bfnChannelGetLevel "${BASS_DLL}::BASS_ChannelGetLevel(i) i"
;DWORD BASSDEF(BASS_ChannelGetData)(DWORD handle, void *buffer, DWORD length);
!define bfnChannelGetData "${BASS_DLL}::BASS_ChannelGetData(i,v,i) i"
;HSYNC BASSDEF(BASS_ChannelSetSync)(DWORD handle, DWORD type, QWORD param, SYNCPROC *proc, DWORD user);
!define bfnChannelSetSync "${BASS_DLL}::BASS_ChannelSetSync(i,i,i,*${SYNCPROC},i) i"
;BOOL BASSDEF(BASS_ChannelRemoveSync)(DWORD handle, HSYNC sync);
!define bfnChannelRemoveSync) "${BASS_DLL}::BASS_ChannelRemoveSync(i,i) b"
;HDSP BASSDEF(BASS_ChannelSetDSP)(DWORD handle, DSPPROC *proc, DWORD user, int priority);
!define bfnChannelSetDSP "${BASS_DLL}::BASS_ChannelSetDSP(i,*${DSPPROC},i,i) i"
;BOOL BASSDEF(BASS_ChannelRemoveDSP)(DWORD handle, HDSP dsp);
!define bfnChannelRemoveDSP "${BASS_DLL}::BASS_ChannelRemoveDSP(i,i) b"
;BOOL BASSDEF(BASS_ChannelSetLink)(DWORD handle, DWORD chan);
!define bfnChannelSetLink "${BASS_DLL}::BASS_ChannelSetLink(i,i) b"
;BOOL BASSDEF(BASS_ChannelRemoveLink)(DWORD handle, DWORD chan);
!define bfnChannelRemoveLink "${BASS_DLL}::BASS_ChannelRemoveLink(i,i) b"

;BOOL BASSDEF(BASS_ChannelSetEAXMix)(DWORD handle, float mix);
!define bfnChannelSetEAXMix "${BASS_DLL}::BASS_ChannelSetEAXMix(i,i) b"
;BOOL BASSDEF(BASS_ChannelGetEAXMix)(DWORD handle, float *mix);
!define bfnChannelGetEAXMix "${BASS_DLL}::BASS_ChannelGetEAXMix(i,i) b"
;HFX BASSDEF(BASS_ChannelSetFX)(DWORD handle, DWORD type, DWORD priority);
!define bfnChannelSetFX "${BASS_DLL}::BASS_ChannelSetFX(i,i,i) i"
;BOOL BASSDEF(BASS_ChannelRemoveFX)(DWORD handle, HFX fx);
!define bfnChannelRemoveFX "${BASS_DLL}::BASS_ChannelRemoveFX(i,i) b"

;BOOL BASSDEF(BASS_FXSetParameters)(HFX handle, const void *par);
!define bfnFXSetParameters "${BASS_DLL}::BASS_FXSetParameters(i,v) b"
;BOOL BASSDEF(BASS_FXGetParameters)(HFX handle, void *par);
!define bfnFXGetParameters "${BASS_DLL}::BASS_FXGetParameters(i,v) b"
;BOOL BASSDEF(BASS_FXReset)(HFX handle);
!define bfnFXReset "${BASS_DLL}::BASS_FXReset(i) b"

!verbose pop