
	.DEF _mode=R5
	.DEF _seconds=R4
	.DEF _tin=R7
	.DEF _tout=R6
	.DEF _PREV_PINC=R9
_3:
	.DB  0xFF
_4:
	.DB  0x1A,0x16,0x14,0x1A,0xA,0x1A,0xA,0xA
	.DB  0x25
_0x5:
	.DB  0x46,0x41
	.DB  0x4E,0x20
	.DB  0x54,0x31
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x46,0x41
	.DB  0x4E,0x20
	.DB  0x54,0x32
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x46,0x41
	.DB  0x4E,0x20
	.DB  0x54,0x33
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x53,0x48
	.DB  0x55,0x20
	.DB  0x54,0x34
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x53,0x48
	.DB  0x55,0x20
	.DB  0x54,0x35
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x43,0x4F
	.DB  0x4E,0x20
	.DB  0x54,0x36
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x43,0x4F
	.DB  0x4E,0x20
	.DB  0x54,0x37
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x43,0x4F
	.DB  0x4E,0x20
	.DB  0x54,0x38
	.DB  0x3D,0x0
	.DB  0x0,0x0
	.DB  0x41,0x4C
	.DB  0x41,0x52
	.DB  0x4D,0x20
	.DB  0x54,0x39
	.DB  0x3D,0x0
_0x15:
	.DB  0x54,0x31
	.DB  0x0,0x54
	.DB  0x32,0x0
	.DB  0x54,0x33
	.DB  0x0,0x54
	.DB  0x34,0x0
	.DB  0x54,0x35
	.DB  0x0,0x54
	.DB  0x36,0x0
	.DB  0x54,0x37
	.DB  0x0,0x54
	.DB  0x38,0x0
	.DB  0x54,0x39
	.DB  0x0
_0x4E:
	.DB  0x49,0x4E
	.DB  0x54,0x45
	.DB  0x47,0x52
	.DB  0x41,0x4C
	.DB  0x0,0x43
	.DB  0x4F,0x4F
	.DB  0x4C,0x45
	.DB  0x52,0x20
	.DB  0x53,0x59
	.DB  0x53,0x54
	.DB  0x45,0x4D
	.DB  0x0
	.DEF _therm_dq=R8
_0x99:
	.DB  0x8,0x0
	.DB  0xC,0x0
	.DB  0xE,0x0
	.DB  0xF,0x0
__fround_G3:
	.DB  0x0,0x0,0x0,0x3F,0xCD,0xCC,0x4C,0x3D
	.DB  0xA,0xD7,0xA3,0x3B,0x6F,0x12,0x3,0x3A
	.DB  0x17,0xB7,0x51,0x38,0xAC,0xC5,0xA7,0x36
	.DB  0xBD,0x37,0x6,0x35
_426:
	.DB  0x80,0xC0
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13
_435:
	.DW  0x00
_0:
	.DB  0x20,0x20,0x20,0x0,0x4D,0x41,0x49,0x4E
	.DB  0x20,0x4D,0x45,0x4E,0x55,0x0,0x54,0x69
	.DB  0x6E,0x3A,0x20,0x25,0x2B,0x2E,0x31,0x66
	.DB  0x25,0x63,0x43,0x20,0x20,0x20,0x20,0xA
	.DB  0x54,0x6F,0x75,0x74,0x3A,0x20,0x25,0x2B
	.DB  0x2E,0x31,0x66,0x25,0x63,0x43,0x20,0x20
	.DB  0x20,0x0,0x46,0x41,0x4E,0x20,0x54,0x31
	.DB  0x3D,0x25,0x64,0x20,0x54,0x32,0x3D,0x25
	.DB  0x64,0xA,0x54,0x33,0x3D,0x25,0x64,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x53,0x48,0x55,0x20,0x54,0x34,0x3D
	.DB  0x25,0x64,0x20,0x54,0x35,0x3D,0x25,0x64
	.DB  0xA,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x43
	.DB  0x4F,0x4E,0x20,0x54,0x36,0x3D,0x25,0x64
	.DB  0x20,0x54,0x37,0x3D,0x25,0x64,0xA,0x54
	.DB  0x38,0x3D,0x25,0x64,0x20,0x20,0x20,0x0
	.DB  0x41,0x4C,0x41,0x52,0x4D,0x20,0x54,0x39
	.DB  0x3D,0x25,0x64,0x20,0x20,0x20,0x20,0xA
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x54,0x69,0x6E,0x3A,0x20,0x25,0x2B
	.DB  0x2E,0x31,0x66,0x25,0x63,0x43,0x20,0x20
	.DB  0x20,0xA,0x54,0x6F,0x75,0x74,0x3A,0x20
	.DB  0x25,0x2B,0x2E,0x31,0x66,0x25,0x63,0x43
	.DB  0x20,0x20,0x20,0x0,0x41,0x43,0x0,0x49
	.DB  0x6E,0x69,0x74,0x20,0x65,0x72,0x72,0x6F
	.DB  0x72,0xA,0x69,0x6E,0x64,0x6F,0x6F,0x72
	.DB  0x20,0x73,0x65,0x6E,0x73,0x6F,0x72,0x0
	.DB  0x49,0x6E,0x69,0x74,0x20,0x65,0x72,0x72
	.DB  0x6F,0x72,0xA,0x6F,0x75,0x74,0x64,0x6F
	.DB  0x6F,0x72,0x20,0x73,0x65,0x6E,0x73,0x6F
	.DB  0x72,0x0,0x54,0x69,0x6E,0x20,0x65,0x72
	.DB  0x72,0x6F,0x72,0xA,0x54,0x6F,0x75,0x74
	.DB  0x20,0x65,0x72,0x72,0x6F,0x72,0x0,0x54
	.DB  0x69,0x6E,0x20,0x65,0x72,0x72,0x6F,0x72
	.DB  0xA,0x54,0x6F,0x75,0x74,0x3A,0x20,0x25
	.DB  0x2B,0x2E,0x31,0x66,0x25,0x63,0x43,0x0
	.DB  0x54,0x69,0x6E,0x3A,0x20,0x25,0x2B,0x2E
	.DB  0x31,0x66,0x25,0x63,0x43,0xA,0x54,0x6F
	.DB  0x75,0x74,0x20,0x65,0x72,0x72,0x6F,0x72
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x09
	.DW  _3*2

	.DW  0x09
	.DW  _temp
	.DW  _4*2

	.DW  0x02
	.DW  __base_y_G4
	.DW  _426*2

	.DW  0x02
	.DW  _p_S6A
	.DW  _435*2

	.DW  0
_0x1CB: