
;CodeVisionAVR C Compiler V1.25.8 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 3,680000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : long, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "ovf.vec"
	.INCLUDE "ovf.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

	OUT  RAMPZ,R24

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 /*****************************************************
;       2 CodeWizardAVR V1.25.8 Professional
;       3 
;       4 Project :  PWM_LED & ADC
;       5 Chip type           : ATmega128
;       6 Clock frequency     : 3,680000 MHz
;       7 *****************************************************/
;       8 
;       9 #include <mega128.h>
;      10 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      11 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      12 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;      13 	.EQU __sm_mask=0x1C
	.EQU __sm_mask=0x1C
;      14 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;      15 	.EQU __sm_powersave=0x18
	.EQU __sm_powersave=0x18
;      16 	.EQU __sm_standby=0x14
	.EQU __sm_standby=0x14
;      17 	.EQU __sm_ext_standby=0x1C
	.EQU __sm_ext_standby=0x1C
;      18 	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_adc_noise_red=0x08
;      19 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      20 	#endif
	#endif
;      21 #include <stdio.h>
;      22 #include <delay.h>
;      23 #include "mylcd.c"     // моя бібліотека для LCD
;      24 #pragma used+
;      25 
;      26  //прототипы функций
;      27  //предварительное объявление
;      28 
;      29 
;      30 #define RS PORTC.5     //  LCD
;      31 #define E  PORTC.6     //  LCD
;      32 
;      33 #define D4 PORTA.0     //  LCD  data
;      34 #define D5 PORTA.1     //  LCD  data
;      35 #define D6 PORTA.2     //  LCD  data
;      36 #define D7 PORTA.3     //  LCD  data
;      37 
;      38  void lcd_cmd (unsigned char c);
;      39  void lcd_strobe (void);
;      40  void lcd_write (unsigned char c);
;      41  void lcd_putchar (unsigned char c);
;      42  void lcd_cmd (unsigned char c);
;      43  void lcd_clear (void);
;      44  void lcd_putsf(unsigned char __flash *str);
;      45  void lcd_puts(unsigned char *str);
;      46  void lcd_gotoxy(unsigned char x, unsigned char y);
;      47  void lcd_init (void);
;      48  void cursor_on (void);
;      49  void cursor_off (void);
;      50 
;      51   //реализация функций ( определение )
;      52  //функции можно распологать и делать вызовы из других функций в любом порядке
;      53  void lcd_strobe (void) //Функция стробирования на на выводе E
;      54 {

	.CSEG
_lcd_strobe:
;      55 E=1;
	SBI  0x15,6
;      56 delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x0
;      57 E=0;
	CBI  0x15,6
;      58 }
	RET
;      59 
;      60 //Функция посылки кода на выводы D4-D7, байт делется на две части,
;      61 //сначала передается старшая тетрада, потом - младшая
;      62 void lcd_write (unsigned char c){
_lcd_write:
;      63 if(c&0x10) D4=1; else D4=0;
;	c -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x7
	SBI  0x1B,0
	RJMP _0xA
_0x7:
	CBI  0x1B,0
;      64 if(c&0x20) D5=1; else D5=0;
_0xA:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0xD
	SBI  0x1B,1
	RJMP _0x10
_0xD:
	CBI  0x1B,1
;      65 if(c&0x40) D6=1; else D6=0;
_0x10:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x13
	SBI  0x1B,2
	RJMP _0x16
_0x13:
	CBI  0x1B,2
;      66 if(c&0x80) D7=1; else D7=0;
_0x16:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x19
	SBI  0x1B,3
	RJMP _0x1C
_0x19:
	CBI  0x1B,3
;      67 lcd_strobe();
_0x1C:
	CALL SUBOPT_0x1
;      68 delay_ms(5);
;      69 if(c&0x1) D4=1; else D4=0;
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ _0x1F
	SBI  0x1B,0
	RJMP _0x22
_0x1F:
	CBI  0x1B,0
;      70 if(c&0x2) D5=1; else D5=0;
_0x22:
	LD   R30,Y
	ANDI R30,LOW(0x2)
	BREQ _0x25
	SBI  0x1B,1
	RJMP _0x28
_0x25:
	CBI  0x1B,1
;      71 if(c&0x4) D6=1; else D6=0;
_0x28:
	LD   R30,Y
	ANDI R30,LOW(0x4)
	BREQ _0x2B
	SBI  0x1B,2
	RJMP _0x2E
_0x2B:
	CBI  0x1B,2
;      72 if(c&0x8) D7=1; else D7=0;
_0x2E:
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0x31
	SBI  0x1B,3
	RJMP _0x34
_0x31:
	CBI  0x1B,3
;      73 lcd_strobe();
_0x34:
	CALL SUBOPT_0x1
;      74 delay_ms(5);
;      75 }
	RJMP _0x284
;      76 
;      77 void lcd_putchar (unsigned char c){
_lcd_putchar:
;      78 RS=1;
;	c -> Y+0
	SBI  0x15,5
;      79 lcd_write(c);
	LD   R30,Y
	ST   -Y,R30
	CALL _lcd_write
;      80 }
	RJMP _0x284
;      81 
;      82 void lcd_cmd (unsigned char c){
_lcd_cmd:
;      83 RS=0;
;	c -> Y+0
	CBI  0x15,5
;      84 lcd_write(c);
	LD   R30,Y
	ST   -Y,R30
	CALL _lcd_write
;      85 }
	RJMP _0x284
;      86 
;      87 void lcd_clear (void){
_lcd_clear:
;      88 RS=0;
	CBI  0x15,5
;      89 lcd_write(0x01);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_write
;      90 delay_ms(5);
	CALL SUBOPT_0x2
;      91 }
	RET
;      92 
;      93 //Вивід на LCD info з FLASH-памяті
;      94 void lcd_putsf(unsigned char __flash *str)
;      95 {
_lcd_putsf:
;      96 unsigned char Count=0;
;      97 
;      98 while (str[Count]!=0x00)
	ST   -Y,R17
;	*str -> Y+1
;	Count -> R17
	LDI  R17,0
_0x3D:
	CALL SUBOPT_0x3
	CPI  R30,0
	BREQ _0x3F
;      99   {
;     100   lcd_putchar(str[Count]);
	CALL SUBOPT_0x3
	ST   -Y,R30
	CALL _lcd_putchar
;     101   Count++;
	SUBI R17,-1
;     102   }
	RJMP _0x3D
_0x3F:
;     103 }
	LDD  R17,Y+0
	RJMP _0x285
;     104 
;     105 void lcd_puts(unsigned char *str)
;     106 {
_lcd_puts:
;     107 unsigned char Count=0;
;     108 
;     109 while (str[Count]!=0x00)
	ST   -Y,R17
;	*str -> Y+1
;	Count -> R17
	LDI  R17,0
_0x40:
	CALL SUBOPT_0x4
	CPI  R30,0
	BREQ _0x42
;     110   {
;     111   lcd_putchar(str[Count]);
	CALL SUBOPT_0x4
	ST   -Y,R30
	CALL _lcd_putchar
;     112   Count++;
	SUBI R17,-1
;     113   }
	RJMP _0x40
_0x42:
;     114 }
	LDD  R17,Y+0
	RJMP _0x285
;     115 
;     116 
;     117 void lcd_gotoxy(unsigned char x, unsigned char y)
;     118 {
_lcd_gotoxy:
;     119 unsigned char Temp;
;     120 
;     121    Temp=0x80;
	ST   -Y,R17
;	x -> Y+2
;	y -> Y+1
;	Temp -> R17
	LDI  R17,LOW(128)
;     122    if(y==1) Temp=0xc0;
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x43
	LDI  R17,LOW(192)
;     123    lcd_cmd (Temp+x);
_0x43:
	LDD  R30,Y+2
	ADD  R30,R17
	ST   -Y,R30
	CALL _lcd_cmd
;     124 }
	LDD  R17,Y+0
_0x285:
	ADIW R28,3
	RET
;     125 
;     126 void lcd_init (void){
_lcd_init:
;     127 //Инициализация диспелея в 4-х битовом режимею. Три раза выводим код 0010.
;     128 delay_ms(25);//Выдержуем паузу не менее 15мс
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x0
;     129 RS=0;//Передача команды
	CBI  0x15,5
;     130 D7=0;
	CALL SUBOPT_0x5
;     131 D6=0;
;     132 D5=1;
;     133 D4=0;
;     134 lcd_strobe();
;     135 delay_ms(5);
;     136 D7=0;
	CALL SUBOPT_0x5
;     137 D6=0;
;     138 D5=1;
;     139 D4=0;
;     140 lcd_strobe();
;     141 delay_ms(5);
;     142 D7=0;
	CALL SUBOPT_0x5
;     143 D6=0;
;     144 D5=1;
;     145 D4=0;
;     146 lcd_strobe();
;     147 delay_ms(5);
;     148 lcd_cmd(0x28);
	LDI  R30,LOW(40)
	ST   -Y,R30
	CALL _lcd_cmd
;     149 delay_ms(5);
	CALL SUBOPT_0x2
;     150 lcd_cmd(0x01);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_cmd
;     151 delay_ms(5);
	CALL SUBOPT_0x2
;     152 lcd_cmd(0x0C);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _lcd_cmd
;     153 }
	RET
;     154 
;     155 void   cursor_on (void)
;     156  {
;     157    RS=0;
;     158    lcd_cmd(0x0E); // курсор!
;     159  }
;     160 
;     161 void cursor_off (void)
;     162  {
;     163     RS=0;
;     164     lcd_cmd(0x0C);
;     165  }
;     166 
;     167 
;     168 
;     169  #pragma used-
;     170 
;     171 #define SYS_FREQ        3680000UL    // тактова частота 3.68 MHz
;     172 
;     173 //налаштування АЦП
;     174 #define ADC_VREF_TYPE  0x00   //  Bit 5 - ADLAR=0 - 10 біт  використовуємо ADCH і ADCL
;     175 #define REFS0   6             // selector Vref  - вибрати джерело опорної напруги
;     176 #define REFS1   7             // selector Vref
;     177 
;     178 //кнопки  MENU/ENTER, SELECT+, SELECT-, ESC/EXIT
;     179 #define BTNS_PORT              PORTF    //  for buttons on  PORTF
;     180 #define BTNS_PORT_DDR          DDRF     //  for  buttons on PORTF
;     181 #define MENU_ENTER_BTN       3          //  kn-menu
;     182 #define SELECT_PLUS_BTN      4          //  kn- MAX
;     183 #define SELECT_MINUS_BTN     1          //  kn - min
;     184 #define ESC_BTN              2          //  kn -esc
;     185 #define CNTREPEAT            300        //  утримання клавіш
;     186 
;     187 // Declare your global variables here
;     188 unsigned char k, PREV_PINF = 0xff;                         // menu 1111 1111

	.DSEG
;     189 unsigned int gSelectPlusCounter=0, gSelectMinusCounter=0;  // menu cелектор
;     190 
;     191 volatile  unsigned int  hour = 0;    // частота встановлена ціле
_hour:
	.BYTE 0x2
;     192 volatile  unsigned int start_p=0;    // встановлена частота
_start_p:
	.BYTE 0x2
;     193 
;     194 // eeprom float rom_fxx;      //  частота з ROM
;     195 eeprom float   rom_fxx;      //  частота з ROM

	.ESEG
_rom_fxx:
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
;     196 eeprom unsigned int   rom_speed;  //  delay з ROM - чим більше значення тим повільніше тестування
_rom_speed:
	.DW  0x0
;     197 
;     198 
;     199 
;     200 char  buffer[33];               // for LCD convertion

	.DSEG
_buffer:
	.BYTE 0x21
;     201 char N=1; // prescaler
;     202 volatile unsigned long int  fx=0, tx=0;  // частота і період
_fx:
	.BYTE 0x4
_tx:
	.BYTE 0x4
;     203 volatile float  fxx=22.2;  // опорна частота- можна встановити від 1... 29999 Гц
_fxx:
	.BYTE 0x4
;     204 volatile unsigned char  redpwml=0,redpwmh=0, greenpwml=0,greenpwmh=0, bluepwml=0,bluepwmh=0;  // pwm , pwm_val
_redpwml:
	.BYTE 0x1
_redpwmh:
	.BYTE 0x1
_greenpwml:
	.BYTE 0x1
_greenpwmh:
	.BYTE 0x1
_bluepwml:
	.BYTE 0x1
_bluepwmh:
	.BYTE 0x1
;     205 volatile unsigned int ICR3top=0;
_ICR3top:
	.BYTE 0x2
;     206 volatile unsigned int speed=10;   // затримка в ms - чим більше значення тим повільніше тестування
_speed:
	.BYTE 0x2
;     207 
;     208 
;     209 unsigned int ICR3, RedPwm, GreenPwm, BluePwm ;
_RedPwm:
	.BYTE 0x2
_GreenPwm:
	.BYTE 0x2
_BluePwm:
	.BYTE 0x2
;     210 unsigned int Dred, Dgreen, Dblue;  // duty = red green blue
_Dred:
	.BYTE 0x2
_Dgreen:
	.BYTE 0x2
_Dblue:
	.BYTE 0x2
;     211 
;     212 unsigned int adc_in;          // змінна для ADC - код
_adc_in:
	.BYTE 0x2
;     213 float indication=0, tinf=0;
_indication:
	.BYTE 0x4
_tinf:
	.BYTE 0x4
;     214 char ADC_INPUT = 0x05;       // порт з якого читаємо Analog signal = PF5(ADC5)
;     215 char vref=5;                 // опорна напруга
_vref:
	.BYTE 0x1
;     216 char od='m'  ;
_od:
	.BYTE 0x1
;     217 
;     218 volatile unsigned char value[5] = {0, 0, 0, 0, 0};
_value:
	.BYTE 0x5
;     219 
;     220 volatile unsigned int A0,A1,A2,A3,A4;
_A0:
	.BYTE 0x2
_A1:
	.BYTE 0x2
_A2:
	.BYTE 0x2
_A3:
	.BYTE 0x2
_A4:
	.BYTE 0x2
;     221 volatile unsigned int V0,V1,V2,V3,V4;
_V0:
	.BYTE 0x2
_V1:
	.BYTE 0x2
_V2:
	.BYTE 0x2
_V3:
	.BYTE 0x2
_V4:
	.BYTE 0x2
;     222 
;     223 
;     224 
;     225 //  key - функція  біжучий статус клавіші
;     226   unsigned char get_key_status(unsigned char key)    //  key - номер клавіші  на порту
;     227 {

	.CSEG
_get_key_status:
;     228    return (!(PINF & (1<<key)));
;	key -> Y+0
	IN   R1,0
	LD   R30,Y
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	CALL __LNEGB1
	RJMP _0x284
;     229 }
;     230 
;     231 
;     232 // функція попередній статус клавіші
;     233 unsigned char get_prev_key_status(unsigned char key)  // key - номер клавіші  на порту
;     234 {
_get_prev_key_status:
;     235   return (!(PREV_PINF & (1<<key)));
;	key -> Y+0
	LD   R30,Y
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R4
	CALL __LNEGB1
	RJMP _0x284
;     236 }
;     237 
;     238 
;     239 // Timer 2 overflow interrupt service routine  використовується для меню!!!
;     240 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;     241 {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     242     if ( get_key_status(SELECT_PLUS_BTN) )  // аналіз натискання клавіші SELECT+
	CALL SUBOPT_0x6
	BREQ _0x69
;     243       {
;     244          if (gSelectPlusCounter < CNTREPEAT)
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x6A
;     245             gSelectPlusCounter++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
;     246        }
_0x6A:
;     247     else  gSelectPlusCounter = 0;
	RJMP _0x6B
_0x69:
	CLR  R6
	CLR  R7
;     248 
;     249   if ( get_key_status(SELECT_MINUS_BTN) )  // аналіз натискання клавіші SELECT-
_0x6B:
	CALL SUBOPT_0x7
	BREQ _0x6C
;     250   {
;     251     if (gSelectMinusCounter < CNTREPEAT)
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x6D
;     252         gSelectMinusCounter++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;     253   }
_0x6D:
;     254   else gSelectMinusCounter = 0;
	RJMP _0x6E
_0x6C:
	CLR  R8
	CLR  R9
;     255 }
_0x6E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     256 
;     257 
;     258 // Timer 3 overflow interrupt service routine
;     259 interrupt [TIM3_OVF] void timer3_ovf_isr(void)
;     260 {
_timer3_ovf_isr:
	ST   -Y,R30
;     261    OCR3AH=redpwmh;  OCR3AL=redpwml;     // RED  0E 5F = for 1000 hz icr3 = top
	LDS  R30,_redpwmh
	STS  135,R30
	LDS  R30,_redpwml
	STS  134,R30
;     262    OCR3BH=greenpwmh;  OCR3BL=greenpwml;     // GREEN
	LDS  R30,_greenpwmh
	STS  133,R30
	LDS  R30,_greenpwml
	STS  132,R30
;     263    OCR3CH=bluepwmh;  OCR3CL=bluepwml;     // BLUE  72F
	LDS  R30,_bluepwmh
	STS  131,R30
	LDS  R30,_bluepwml
	STS  130,R30
;     264  }
	LD   R30,Y+
	RETI
;     265 
;     266  // Read the AD conversion result
;     267 unsigned int read_adc(unsigned char adc_input)
;     268 {
_read_adc:
;     269    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
;     270    delay_us(10);      // Delay needed for the stabilization of the ADC input voltage
	__DELAY_USB 12
;     271                       // Start the AD conversion
;     272   ADCSRA|=0x40;
	SBI  0x6,6
;     273   // Wait for the AD conversion to complete
;     274   while ((ADCSRA & 0x10)==0);
_0x6F:
	SBIS 0x6,4
	RJMP _0x6F
;     275   ADCSRA|=0x10;
	SBI  0x6,4
;     276    return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x284:
	ADIW R28,1
	RET
;     277 }
;     278 
;     279 
;     280  void zvyk(void)
;     281  {
_zvyk:
;     282   DDRB.5=1;                  // управління звуком on/off
	SBI  0x17,5
;     283   delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x0
;     284   DDRB.5=0;
	CBI  0x17,5
;     285   delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x0
;     286  }
	RET
;     287 
;     288 
;     289 
;     290 
;     291 
;     292 
;     293 
;     294 
;     295 // функція меню -   set частоту до 300 гц
;     296 unsigned int set_page(void)
;     297 {
_set_page:
;     298   unsigned char  x[4] = { 7, 8, 9, 11 }, i = 0;            // позиції символів число з 4 значень
;     299   char time_chars[4][2] = {"^", "^", "^", "^"};  // нижній курсор - стрілка чотири позиції
;     300 
;     301   lcd_gotoxy(x[0],1);
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x76*2)
	LDI  R31,HIGH(_0x76*2)
	CALL __INITLOCB
	ST   -Y,R17
;	x -> Y+9
;	i -> R17
;	time_chars -> Y+1
	LDI  R17,0
	LDD  R30,Y+9
	CALL SUBOPT_0x8
;     302   lcd_puts(time_chars[0]);
	CALL SUBOPT_0x9
;     303 
;     304   if (hour>3000) {hour=2999;};                              //  перше "^"  - курсор нижній
	CALL SUBOPT_0xA
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x77
	CALL SUBOPT_0xB
_0x77:
;     305 
;     306 
;     307    A0 = hour;        V0=A0/1000;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;     308    value[0]=(unsigned char)(A0/1000); // старший-перший символ зліва
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
;     309    A1=A0-V0*1000;   V1= (A1/100);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
;     310    value[1]=(unsigned char)(A1/100);  // другий символ зліва
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
;     311    A2=A1-V1*100;    V2=A2/10;
	LDI  R30,LOW(100)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
;     312    value[2]=(unsigned char)(A2/10);   // третій символ зліва
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
;     313    A3=A2-V2*10;     V3=A3;
	LDI  R30,LOW(10)
	CALL SUBOPT_0x19
	LDS  R30,_A3
	LDS  R31,_A3+1
	STS  _V3,R30
	STS  _V3+1,R31
;     314    value[3]=(unsigned char)(A3);    // четвертий символ зліва
	LDS  R30,_A3
	__PUTB1MN _value,3
;     315 
;     316  // value[0]= (unsigned char)hour/1000;                       // старший-перший символ зліва
;     317  // value[1]= (hour-value[0]*1000)/100;                        // другий символ зліва
;     318  // value[2]= ((hour-value[0]*1000-value[1]*100)/10);         // третій символ зліва
;     319  // value[3]= hour-value[0]*1000-value[1]*100-value[2]*10;  // четвертий символ зліва
;     320 
;     321   while (1) {
_0x78:
;     322     PREV_PINF = PINF;
	CALL SUBOPT_0x1A
;     323     sprintf(buffer, "%u%u%u.%u", value[0], value[1], value[2], value[3]); // чотири символи для виводу
	__POINTW1FN _0,0
	CALL SUBOPT_0x1B
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
;     324     lcd_gotoxy(x[0],0);
	LDD  R30,Y+9
	CALL SUBOPT_0x1C
;     325     lcd_puts(buffer);
;     326 
;     327     if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP ---set_page()-
	BRNE PC+3
	JMP _0x7B
;     328       if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
	CALL SUBOPT_0x1D
	BREQ _0x7D
	CALL SUBOPT_0x1E
	BREQ _0x7D
	RJMP _0x7C
_0x7D:
;     329       {
;     330         if (gSelectPlusCounter == CNTREPEAT)
	CALL SUBOPT_0x1E
	BRNE _0x7F
;     331           delay_ms(80);
	CALL SUBOPT_0x1F
;     332 
;     333          switch (i)
_0x7F:
	MOV  R30,R17
;     334          {
;     335          case 0:                                   //  ліва_старша=нульова позиція числа page значення=( 0..2)
	CPI  R30,0
	BRNE _0x83
;     336               if (value[0] < 2)
	LDS  R26,_value
	CPI  R26,LOW(0x2)
	BRSH _0x84
;     337                  value[0]++;
	LDS  R30,_value
	SUBI R30,-LOW(1)
	RJMP _0x286
;     338               else value[0] = 0;
_0x84:
	LDI  R30,LOW(0)
_0x286:
	STS  _value,R30
;     339          break;
	RJMP _0x82
;     340 
;     341          case 1:                                  // друга позиція зліва числа page значення =( 0..9)
_0x83:
	CPI  R30,LOW(0x1)
	BRNE _0x86
;     342                if (value[1] < 9)
	__GETB2MN _value,1
	CPI  R26,LOW(0x9)
	BRSH _0x87
;     343                    value[1]++;
	__GETB1MN _value,1
	SUBI R30,-LOW(1)
	RJMP _0x287
;     344                else value[1] = 0;
_0x87:
	LDI  R30,LOW(0)
_0x287:
	__PUTB1MN _value,1
;     345          break;
	RJMP _0x82
;     346 
;     347          case 2:                                 // третя позиція зліва числа page значення =( 0..9)
_0x86:
	CPI  R30,LOW(0x2)
	BRNE _0x89
;     348               if (value[i] < 9)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x9)
	BRSH _0x8A
;     349                  value[i]++;
	CALL SUBOPT_0x21
;     350               else value[i] = 0;
	RJMP _0x8B
_0x8A:
	CALL SUBOPT_0x20
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     351          break;
_0x8B:
	RJMP _0x82
;     352 
;     353          case 3:             // четверта позиція зліва числа page значення =( 0..9)
_0x89:
	CPI  R30,LOW(0x3)
	BRNE _0x82
;     354 
;     355               if (value[i] < 9)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x9)
	BRSH _0x8D
;     356                  value[i]++;
	CALL SUBOPT_0x21
;     357               else value[i] = 0;
	RJMP _0x8E
_0x8D:
	CALL SUBOPT_0x20
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     358          break;
_0x8E:
;     359          }
_0x82:
;     360       }
;     361  //-end select+  UP ---set_page()--
;     362 
;     363     if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN---set_page()--
_0x7C:
_0x7B:
	CALL SUBOPT_0x7
	BRNE PC+3
	JMP _0x8F
;     364       if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
	CALL SUBOPT_0x22
	BREQ _0x91
	CALL SUBOPT_0x23
	BREQ _0x91
	RJMP _0x90
_0x91:
;     365       {
;     366         if (gSelectMinusCounter == CNTREPEAT)
	CALL SUBOPT_0x23
	BRNE _0x93
;     367           delay_ms(80);
	CALL SUBOPT_0x1F
;     368         switch (i)
_0x93:
	MOV  R30,R17
;     369         {
;     370         case 0:
	CPI  R30,0
	BRNE _0x97
;     371               if (value[0] > 0)
	LDS  R26,_value
	CPI  R26,LOW(0x1)
	BRLO _0x98
;     372                   value[0]--;
	LDS  R30,_value
	SUBI R30,LOW(1)
	RJMP _0x288
;     373               else value[0] = 2;
_0x98:
	LDI  R30,LOW(2)
_0x288:
	STS  _value,R30
;     374         break;
	RJMP _0x96
;     375 
;     376         case 1:
_0x97:
	CPI  R30,LOW(0x1)
	BRNE _0x9A
;     377               if (value[1] > 0)
	__GETB2MN _value,1
	CPI  R26,LOW(0x1)
	BRLO _0x9B
;     378                 value[1]--;
	__GETB1MN _value,1
	SUBI R30,LOW(1)
	RJMP _0x289
;     379               else value[1] = 9;
_0x9B:
	LDI  R30,LOW(9)
_0x289:
	__PUTB1MN _value,1
;     380         break;
	RJMP _0x96
;     381 
;     382         case 2:
_0x9A:
	CPI  R30,LOW(0x2)
	BRNE _0x9D
;     383               if (value[i] > 0)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BRLO _0x9E
;     384                   value[i]--;
	CALL SUBOPT_0x24
;     385               else value[i] = 9;
	RJMP _0x9F
_0x9E:
	CALL SUBOPT_0x20
	LDI  R26,LOW(9)
	STD  Z+0,R26
;     386         break;
_0x9F:
	RJMP _0x96
;     387 
;     388         case 3:
_0x9D:
	CPI  R30,LOW(0x3)
	BRNE _0x96
;     389               if (value[i] > 0)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BRLO _0xA1
;     390                   value[i]--;
	CALL SUBOPT_0x24
;     391               else value[i] = 9;
	RJMP _0xA2
_0xA1:
	CALL SUBOPT_0x20
	LDI  R26,LOW(9)
	STD  Z+0,R26
;     392         break;
_0xA2:
;     393         }
_0x96:
;     394      }
;     395 //-end select-  DOWN---set_page()-
;     396 
;     397     if (get_key_status(MENU_ENTER_BTN))     // enter---set_page()-
_0x90:
_0x8F:
	CALL SUBOPT_0x25
	BREQ _0xA3
;     398       if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x26
	BRNE _0xA4
;     399       {
;     400         if (i==3)    // кількість символів числа =4
	CPI  R17,3
	BRNE _0xA5
;     401         {
;     402 
;     403          hour = (unsigned int)(value[0])*1000 ; //+(unsigned int)(value[1])*100);
	LDS  R30,_value
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
;     404          hour = hour+(unsigned int)(value[1])*100;
	__GETB1MN _value,1
	CALL SUBOPT_0x29
;     405           hour = hour+(unsigned int)(value[2])*10;
	__GETB1MN _value,2
	LDI  R26,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0x2A
;     406           hour = hour+(unsigned int)(value[3]);
	__GETB1MN _value,3
	LDI  R31,0
	CALL SUBOPT_0x2A
;     407 
;     408        //  hour = (int)(value[0]*1000+value[1]*100+value[2]*10+value[3]);  // номер сторінки
;     409            if (hour> 2999)
	CALL SUBOPT_0xA
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRLO _0xA6
;     410              hour=2999;
	CALL SUBOPT_0xB
;     411              lcd_gotoxy(x[i],1);               // затерти курсор
_0xA6:
	CALL SUBOPT_0x2B
;     412              lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     413           return(hour);                        // сформоване значення
	CALL SUBOPT_0xC
	LDD  R17,Y+0
	RJMP _0x283
;     414         }
;     415 
;     416         lcd_gotoxy(x[i],1);
_0xA5:
	CALL SUBOPT_0x2B
;     417         lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     418         lcd_gotoxy(x[++i],1);
	SUBI R17,-LOW(1)
	CALL SUBOPT_0x2B
;     419         lcd_puts(time_chars[i]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
;     420 
;     421       }
;     422   //-end enter---set_page()-
;     423 
;     424     if (get_key_status(ESC_BTN))       // exit --set_page()-
_0xA4:
_0xA3:
	CALL SUBOPT_0x2F
	BREQ _0xA7
;     425     {
;     426       PREV_PINF = PINF;
	IN   R4,0
;     427       // exitflag=1;    // натиснута клавіша exit
;     428       return;
	LDD  R17,Y+0
	RJMP _0x283
;     429     }
;     430   }
_0xA7:
	RJMP _0x78
;     431 }
_0x283:
	ADIW R28,13
	RET
;     432 //--end exit ---set_page()-
;     433 
;     434 
;     435 
;     436 // функція меню -   set частоту більше 300 гц
;     437 unsigned int set_page2(void)
;     438 {
_set_page2:
;     439                        // символи числа сторінки
;     440   unsigned char   x[5] = { 7, 8, 9, 10, 11 }, i = 0;  // позиції символів число з 5 значень
;     441   char time_chars[5][2] = {"^", "^", "^", "^","^"};  // нижній курсор - стрілка чотири позиції
;     442 
;     443   lcd_gotoxy(x[0],1);
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xA8*2)
	LDI  R31,HIGH(_0xA8*2)
	CALL __INITLOCB
	ST   -Y,R17
;	x -> Y+11
;	i -> R17
;	time_chars -> Y+1
	LDI  R17,0
	LDD  R30,Y+11
	CALL SUBOPT_0x8
;     444   lcd_puts(time_chars[0]);       //  перше "^"  - курсор нижній
	CALL SUBOPT_0x9
;     445 
;     446    A0 = hour;        V0=A0/10000;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	CALL SUBOPT_0xF
;     447    value[0]=(unsigned char)(A0/10000); // старший-перший символ зліва
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	CALL SUBOPT_0x10
;     448    A1=A0-V0*10000;   V1= (A1/1000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL SUBOPT_0x11
	CALL SUBOPT_0xE
	CALL SUBOPT_0x13
;     449    value[1]=(unsigned char)(A1/1000);  // другий символ зліва
	CALL SUBOPT_0xE
	CALL SUBOPT_0x14
;     450    A2=A1-V1*1000;    V2=A2/100;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12U
	LDS  R26,_A1
	LDS  R27,_A1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A2,R26
	STS  _A2+1,R27
	CALL SUBOPT_0x30
	CALL SUBOPT_0x17
;     451    value[2]=(unsigned char)(A2/100);   // третій символ зліва
	CALL SUBOPT_0x30
	CALL SUBOPT_0x18
;     452    A3=A2-V2*100;     V3=A3/10;
	LDI  R30,LOW(100)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x31
	STS  _V3,R30
	STS  _V3+1,R31
;     453    value[3]=(unsigned char)(A3/10);    // четвертий символ зліва
	CALL SUBOPT_0x31
	__PUTB1MN _value,3
;     454    A4=A3-V3*10;      V4=A4;
	LDS  R26,_V3
	LDS  R27,_V3+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	LDS  R26,_A3
	LDS  R27,_A3+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A4,R26
	STS  _A4+1,R27
	LDS  R30,_A4
	LDS  R31,_A4+1
	STS  _V4,R30
	STS  _V4+1,R31
;     455    value[4]=(unsigned char)A4;         // молодший -п'ятий символ зліва
	LDS  R30,_A4
	__PUTB1MN _value,4
;     456 
;     457   while (1) {
_0xA9:
;     458     PREV_PINF = PINF;
	CALL SUBOPT_0x1A
;     459     sprintf(buffer, "%u%u%u%u%u", value[0], value[1], value[2], value[3], value[4]); // чотири символи для виводу
	__POINTW1FN _0,10
	CALL SUBOPT_0x1B
	__GETB1MN _value,4
	CALL SUBOPT_0x32
	LDI  R24,20
	CALL _sprintf
	ADIW R28,24
;     460     lcd_gotoxy(x[0],0);
	LDD  R30,Y+11
	CALL SUBOPT_0x1C
;     461     lcd_puts(buffer);
;     462 
;     463     if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP ---set_page()-
	BRNE PC+3
	JMP _0xAC
;     464       if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
	CALL SUBOPT_0x1D
	BREQ _0xAE
	CALL SUBOPT_0x1E
	BREQ _0xAE
	RJMP _0xAD
_0xAE:
;     465       {
;     466         if (gSelectPlusCounter == CNTREPEAT)
	CALL SUBOPT_0x1E
	BRNE _0xB0
;     467           delay_ms(80);
	CALL SUBOPT_0x1F
;     468 
;     469          switch (i)
_0xB0:
	MOV  R30,R17
;     470          {
;     471           case 0:                     // ліва_старша= перша позиція числа page значення=( 0..2)
	CPI  R30,0
	BRNE _0xB4
;     472               if (value[0] < 2)
	LDS  R26,_value
	CPI  R26,LOW(0x2)
	BRSH _0xB5
;     473                  value[0]++;
	LDS  R30,_value
	SUBI R30,-LOW(1)
	RJMP _0x28A
;     474               else value[0] = 0;
_0xB5:
	LDI  R30,LOW(0)
_0x28A:
	STS  _value,R30
;     475           break;
	RJMP _0xB3
;     476 
;     477           case 1:                    // друга позиція зліва числа page значення =( 0..9)
_0xB4:
	CPI  R30,LOW(0x1)
	BRNE _0xB7
;     478                if (value[1] < 9)
	__GETB2MN _value,1
	CPI  R26,LOW(0x9)
	BRSH _0xB8
;     479                    value[1]++;
	__GETB1MN _value,1
	SUBI R30,-LOW(1)
	RJMP _0x28B
;     480                else value[1] = 0;
_0xB8:
	LDI  R30,LOW(0)
_0x28B:
	__PUTB1MN _value,1
;     481           break;
	RJMP _0xB3
;     482 
;     483           case 2:                    // третя позиція зліва числа page значення =( 0..9)
_0xB7:
	CPI  R30,LOW(0x2)
	BRNE _0xBA
;     484               if (value[2] < 9)
	__GETB2MN _value,2
	CPI  R26,LOW(0x9)
	BRSH _0xBB
;     485                  value[2]++;
	__GETB1MN _value,2
	SUBI R30,-LOW(1)
	RJMP _0x28C
;     486               else value[2] = 0;
_0xBB:
	LDI  R30,LOW(0)
_0x28C:
	__PUTB1MN _value,2
;     487           break;
	RJMP _0xB3
;     488 
;     489           case 3:                    // четверта позиція зліва числа page значення =( 0..9)
_0xBA:
	CPI  R30,LOW(0x3)
	BRNE _0xBD
;     490               if (value[i] < 9)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x9)
	BRSH _0xBE
;     491                  value[i]++;
	CALL SUBOPT_0x21
;     492               else value[i] = 0;
	RJMP _0xBF
_0xBE:
	CALL SUBOPT_0x20
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     493           break;
_0xBF:
	RJMP _0xB3
;     494 
;     495           case 4:                   // п'ята позиція зліва числа page значення =( 0..9)
_0xBD:
	CPI  R30,LOW(0x4)
	BRNE _0xB3
;     496               if (value[i] < 9)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x9)
	BRSH _0xC1
;     497                  value[i]++;
	CALL SUBOPT_0x21
;     498               else value[i] = 0;
	RJMP _0xC2
_0xC1:
	CALL SUBOPT_0x20
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     499           break;
_0xC2:
;     500          }
_0xB3:
;     501       }
;     502      //-end select+  UP ---set_page()--
;     503 
;     504     if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN---set_page()--
_0xAD:
_0xAC:
	CALL SUBOPT_0x7
	BRNE PC+3
	JMP _0xC3
;     505       if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
	CALL SUBOPT_0x22
	BREQ _0xC5
	CALL SUBOPT_0x23
	BREQ _0xC5
	RJMP _0xC4
_0xC5:
;     506       {
;     507         if (gSelectMinusCounter == CNTREPEAT)
	CALL SUBOPT_0x23
	BRNE _0xC7
;     508           delay_ms(80);
	CALL SUBOPT_0x1F
;     509         switch (i)
_0xC7:
	MOV  R30,R17
;     510         {
;     511          case 0:
	CPI  R30,0
	BRNE _0xCB
;     512               if (value[0] > 0)
	LDS  R26,_value
	CPI  R26,LOW(0x1)
	BRLO _0xCC
;     513                   value[0]--;
	LDS  R30,_value
	SUBI R30,LOW(1)
	RJMP _0x28D
;     514               else value[0] = 2;
_0xCC:
	LDI  R30,LOW(2)
_0x28D:
	STS  _value,R30
;     515          break;
	RJMP _0xCA
;     516 
;     517          case 1:
_0xCB:
	CPI  R30,LOW(0x1)
	BRNE _0xCE
;     518               if (value[1] > 0)
	__GETB2MN _value,1
	CPI  R26,LOW(0x1)
	BRLO _0xCF
;     519                 value[1]--;
	__GETB1MN _value,1
	SUBI R30,LOW(1)
	RJMP _0x28E
;     520               else value[1] = 9;
_0xCF:
	LDI  R30,LOW(9)
_0x28E:
	__PUTB1MN _value,1
;     521          break;
	RJMP _0xCA
;     522 
;     523          case 2:
_0xCE:
	CPI  R30,LOW(0x2)
	BRNE _0xD1
;     524               if (value[2] > 0)
	__GETB2MN _value,2
	CPI  R26,LOW(0x1)
	BRLO _0xD2
;     525                   value[2]--;
	__GETB1MN _value,2
	SUBI R30,LOW(1)
	RJMP _0x28F
;     526               else value[2] = 9;
_0xD2:
	LDI  R30,LOW(9)
_0x28F:
	__PUTB1MN _value,2
;     527          break;
	RJMP _0xCA
;     528 
;     529          case 3:
_0xD1:
	CPI  R30,LOW(0x3)
	BRNE _0xD4
;     530               if (value[3] > 0)
	__GETB2MN _value,3
	CPI  R26,LOW(0x1)
	BRLO _0xD5
;     531                   value[3]--;
	__GETB1MN _value,3
	SUBI R30,LOW(1)
	RJMP _0x290
;     532               else value[3] = 9;
_0xD5:
	LDI  R30,LOW(9)
_0x290:
	__PUTB1MN _value,3
;     533          break;
	RJMP _0xCA
;     534 
;     535          case 4:
_0xD4:
	CPI  R30,LOW(0x4)
	BRNE _0xCA
;     536               if (value[4] > 0)
	__GETB2MN _value,4
	CPI  R26,LOW(0x1)
	BRLO _0xD8
;     537                   value[4]--;
	__GETB1MN _value,4
	SUBI R30,LOW(1)
	RJMP _0x291
;     538               else value[4] = 9;
_0xD8:
	LDI  R30,LOW(9)
_0x291:
	__PUTB1MN _value,4
;     539          break;
;     540         }
_0xCA:
;     541      }
;     542      //-end select-  DOWN---set_page()-
;     543 
;     544     if (get_key_status(MENU_ENTER_BTN))     // enter---set_page()-
_0xC4:
_0xC3:
	CALL SUBOPT_0x25
	BRNE PC+3
	JMP _0xDA
;     545       if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x26
	BREQ PC+3
	JMP _0xDB
;     546       {
;     547         if (i==4)    // кількість символів числа =5
	CPI  R17,4
	BRNE _0xDC
;     548         {
;     549           hour = (unsigned int)(value[0]*10000+value[1]*1000);
	LDS  R30,_value
	LDI  R31,0
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL __MULW12U
	MOVW R22,R30
	__GETB1MN _value,1
	CALL SUBOPT_0x27
	ADD  R30,R22
	ADC  R31,R23
	CALL SUBOPT_0x28
;     550           hour = hour+(unsigned int)(value[2])*100;
	__GETB1MN _value,2
	CALL SUBOPT_0x29
;     551           hour = hour+(unsigned int)(value[3])*10+(unsigned int)(value[4]);
	__GETB1MN _value,3
	LDI  R26,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _value,4
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x28
;     552 
;     553            if (hour>29999)
	CALL SUBOPT_0xA
	CPI  R26,LOW(0x7530)
	LDI  R30,HIGH(0x7530)
	CPC  R27,R30
	BRLO _0xDD
;     554              hour=29999;
	LDI  R30,LOW(29999)
	LDI  R31,HIGH(29999)
	CALL SUBOPT_0x28
;     555              lcd_gotoxy(x[i],1);               // затерти курсор
_0xDD:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x33
;     556              lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     557           return(hour);                        // сформоване значення
	CALL SUBOPT_0xC
	LDD  R17,Y+0
	RJMP _0x282
;     558         }
;     559 
;     560         lcd_gotoxy(x[i],1);
_0xDC:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x33
;     561         lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     562         lcd_gotoxy(x[++i],1);
	SUBI R17,-LOW(1)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x33
;     563         lcd_puts(time_chars[i]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
;     564       }
;     565       //-end enter---set_page()-
;     566 
;     567     if (get_key_status(ESC_BTN))       // exit --set_page()-
_0xDB:
_0xDA:
	CALL SUBOPT_0x2F
	BREQ _0xDE
;     568     {
;     569       PREV_PINF = PINF;
	IN   R4,0
;     570       // exitflag=1;    // натиснута клавіша exit
;     571       return;
	LDD  R17,Y+0
	RJMP _0x282
;     572     }
;     573   }
_0xDE:
	RJMP _0xA9
;     574 }
_0x282:
	ADIW R28,16
	RET
;     575 //--end exit ---set_page()-
;     576 
;     577 
;     578 
;     579 // функція меню -   set speed до 999 ms
;     580 unsigned int set_speed(void)
;     581 {
_set_speed:
;     582   unsigned char  x[3] = { 7, 8, 9 }, i = 0;            // позиції символів число з 3 значень
;     583   char time_chars[3][2] = {"^", "^", "^"};  // нижній курсор - стрілка чотири позиції
;     584 
;     585   lcd_gotoxy(x[0],1);
	SBIW R28,9
	LDI  R24,9
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xDF*2)
	LDI  R31,HIGH(_0xDF*2)
	CALL __INITLOCB
	ST   -Y,R17
;	x -> Y+7
;	i -> R17
;	time_chars -> Y+1
	LDI  R17,0
	LDD  R30,Y+7
	CALL SUBOPT_0x8
;     586   lcd_puts(time_chars[0]);
	CALL SUBOPT_0x9
;     587 
;     588   if (speed>=1000) {speed=999;};                 //  перше "^"  - курсор нижній
	CALL SUBOPT_0x34
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0xE0
	CALL SUBOPT_0x35
_0xE0:
;     589 
;     590 
;     591    A0 = speed;        V0=A0/100;
	CALL SUBOPT_0x36
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	CALL SUBOPT_0xF
;     592    value[0]=(unsigned char)(A0/100); // старший-перший символ зліва
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
;     593    A1=A0-V0*100;   V1= (A1/10);
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	LDS  R26,_A0
	LDS  R27,_A0+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A1,R26
	STS  _A1+1,R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	CALL SUBOPT_0x13
;     594    value[1]=(unsigned char)(A1/10);  // другий символ зліва
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	CALL SUBOPT_0x14
;     595    A2=A1-V1*10;    V2=A2;
	LDI  R30,LOW(10)
	CALL SUBOPT_0x15
	LDS  R30,_A2
	LDS  R31,_A2+1
	CALL SUBOPT_0x17
;     596    value[2]=(unsigned char)(A2);   // третій символ зліва
	LDS  R30,_A2
	__PUTB1MN _value,2
;     597 
;     598 
;     599   while (1) {
_0xE1:
;     600     PREV_PINF = PINF;
	CALL SUBOPT_0x1A
;     601     sprintf(buffer, "%u%u%u", value[0], value[1], value[2]); // три символи для виводу
	__POINTW1FN _0,14
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_value
	CALL SUBOPT_0x32
	__GETB1MN _value,1
	CALL SUBOPT_0x32
	__GETB1MN _value,2
	CALL SUBOPT_0x32
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
;     602     lcd_gotoxy(x[0],0);
	LDD  R30,Y+7
	CALL SUBOPT_0x1C
;     603     lcd_puts(buffer);
;     604 
;     605     if (get_key_status(SELECT_PLUS_BTN))             //   select+  UP --- set speed -
	BREQ _0xE4
;     606       if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
	CALL SUBOPT_0x1D
	BREQ _0xE6
	CALL SUBOPT_0x1E
	BRNE _0xE5
_0xE6:
;     607       {
;     608         if (gSelectPlusCounter == CNTREPEAT)
	CALL SUBOPT_0x1E
	BRNE _0xE8
;     609           delay_ms(80);
	CALL SUBOPT_0x1F
;     610 
;     611          switch (i)
_0xE8:
	MOV  R30,R17
;     612          {
;     613          case 0:                                   //  ліва_старша=нульова позиція числа page значення=( 0..9)
	CPI  R30,0
	BRNE _0xEC
;     614               if (value[0] < 9)
	LDS  R26,_value
	CPI  R26,LOW(0x9)
	BRSH _0xED
;     615                  value[0]++;
	LDS  R30,_value
	SUBI R30,-LOW(1)
	RJMP _0x292
;     616               else value[0] = 0;
_0xED:
	LDI  R30,LOW(0)
_0x292:
	STS  _value,R30
;     617          break;
	RJMP _0xEB
;     618 
;     619          case 1:                                  // друга позиція зліва числа page значення =( 0..9)
_0xEC:
	CPI  R30,LOW(0x1)
	BRNE _0xEF
;     620                if (value[1] < 9)
	__GETB2MN _value,1
	CPI  R26,LOW(0x9)
	BRSH _0xF0
;     621                    value[1]++;
	__GETB1MN _value,1
	SUBI R30,-LOW(1)
	RJMP _0x293
;     622                else value[1] = 0;
_0xF0:
	LDI  R30,LOW(0)
_0x293:
	__PUTB1MN _value,1
;     623          break;
	RJMP _0xEB
;     624 
;     625          case 2:                                 // третя позиція зліва числа page значення =( 0..9)
_0xEF:
	CPI  R30,LOW(0x2)
	BRNE _0xEB
;     626               if (value[i] < 9)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x9)
	BRSH _0xF3
;     627                  value[i]++;
	CALL SUBOPT_0x21
;     628               else value[i] = 0;
	RJMP _0xF4
_0xF3:
	CALL SUBOPT_0x20
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     629          break;
_0xF4:
;     630 
;     631          }
_0xEB:
;     632       }
;     633  //-end select+  UP ---set speed ()--
;     634 
;     635     if (get_key_status(SELECT_MINUS_BTN))             // select-  DOWN--- set speed --
_0xE5:
_0xE4:
	CALL SUBOPT_0x7
	BREQ _0xF5
;     636       if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
	CALL SUBOPT_0x22
	BREQ _0xF7
	CALL SUBOPT_0x23
	BRNE _0xF6
_0xF7:
;     637       {
;     638         if (gSelectMinusCounter == CNTREPEAT)
	CALL SUBOPT_0x23
	BRNE _0xF9
;     639           delay_ms(80);
	CALL SUBOPT_0x1F
;     640         switch (i)
_0xF9:
	MOV  R30,R17
;     641         {
;     642         case 0:
	CPI  R30,0
	BRNE _0xFD
;     643               if (value[0] > 0)
	LDS  R26,_value
	CPI  R26,LOW(0x1)
	BRLO _0xFE
;     644                   value[0]--;
	LDS  R30,_value
	SUBI R30,LOW(1)
	RJMP _0x294
;     645               else value[0] = 9;
_0xFE:
	LDI  R30,LOW(9)
_0x294:
	STS  _value,R30
;     646         break;
	RJMP _0xFC
;     647 
;     648         case 1:
_0xFD:
	CPI  R30,LOW(0x1)
	BRNE _0x100
;     649               if (value[1] > 0)
	__GETB2MN _value,1
	CPI  R26,LOW(0x1)
	BRLO _0x101
;     650                 value[1]--;
	__GETB1MN _value,1
	SUBI R30,LOW(1)
	RJMP _0x295
;     651               else value[1] = 9;
_0x101:
	LDI  R30,LOW(9)
_0x295:
	__PUTB1MN _value,1
;     652         break;
	RJMP _0xFC
;     653 
;     654         case 2:
_0x100:
	CPI  R30,LOW(0x2)
	BRNE _0xFC
;     655               if (value[i] > 0)
	CALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BRLO _0x104
;     656                   value[i]--;
	CALL SUBOPT_0x24
;     657               else value[i] = 9;
	RJMP _0x105
_0x104:
	CALL SUBOPT_0x20
	LDI  R26,LOW(9)
	STD  Z+0,R26
;     658         break;
_0x105:
;     659 
;     660         }
_0xFC:
;     661      }
;     662 //-end select-  DOWN--- set speed ()-
;     663 
;     664     if (get_key_status(MENU_ENTER_BTN))     // enter--- set speed ()-
_0xF6:
_0xF5:
	CALL SUBOPT_0x25
	BREQ _0x106
;     665       if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x26
	BRNE _0x107
;     666       {
;     667         if (i==2)    // кількість символів числа =3
	CPI  R17,2
	BRNE _0x108
;     668         {
;     669 
;     670          speed = (unsigned int)(value[0])*100 ;
	LDS  R30,_value
	LDI  R26,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0x37
;     671          speed = speed +(unsigned int)(value[1])*10;
	__GETB1MN _value,1
	LDI  R26,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0x38
;     672           speed = speed +(unsigned int)(value[2]);
	__GETB1MN _value,2
	LDI  R31,0
	CALL SUBOPT_0x38
;     673 
;     674            if (speed >= 1000)
	CALL SUBOPT_0x34
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x109
;     675              speed =999;
	CALL SUBOPT_0x35
;     676              lcd_gotoxy(x[i],1);               // затерти курсор
_0x109:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x39
;     677              lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     678           return(speed);                        // сформоване значення
	CALL SUBOPT_0x36
	LDD  R17,Y+0
	RJMP _0x281
;     679         }
;     680 
;     681         lcd_gotoxy(x[i],1);
_0x108:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x39
;     682         lcd_putchar(' ');
	CALL SUBOPT_0x2C
;     683         lcd_gotoxy(x[++i],1);
	SUBI R17,-LOW(1)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x39
;     684         lcd_puts(time_chars[i]);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
;     685 
;     686       }
;     687   //-end enter--- set speed
;     688 
;     689     if (get_key_status(ESC_BTN))       // exit --set_page()-
_0x107:
_0x106:
	CALL SUBOPT_0x2F
	BREQ _0x10A
;     690     {
;     691       PREV_PINF = PINF;
	IN   R4,0
;     692       return;
	LDD  R17,Y+0
	RJMP _0x281
;     693     }
;     694   }
_0x10A:
	RJMP _0xE1
;     695 }
_0x281:
	ADIW R28,10
	RET
;     696 //--end exit --- set speed
;     697 
;     698 
;     699  void  Red(unsigned int  dutyr)  // функція для PWM - red
;     700 {
_Red:
;     701     RedPwm = (ICR3/100)* dutyr;
;	dutyr -> Y+0
	MOVW R26,R12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
;     702      if (RedPwm==0) RedPwm=1;
	LDS  R30,_RedPwm
	LDS  R31,_RedPwm+1
	SBIW R30,0
	BRNE _0x10B
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3B
;     703      redpwml=(char)(RedPwm);             // Dred% pwm  RED - low byte
_0x10B:
	CALL SUBOPT_0x3C
;     704      redpwmh=(char)((RedPwm)>>8);   // Dred% pwm  RED - high byte
;     705      return;
	RJMP _0x280
;     706   }
;     707 
;     708   void  Green(unsigned  int  dutyg)   // функція для PWM - Green
;     709 {
_Green:
;     710      GreenPwm = (ICR3/100)* dutyg;
;	dutyg -> Y+0
	MOVW R26,R12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3D
;     711      if (GreenPwm==0) GreenPwm=1;
	LDS  R30,_GreenPwm
	LDS  R31,_GreenPwm+1
	SBIW R30,0
	BRNE _0x10C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3D
;     712      greenpwml=(char)(GreenPwm);
_0x10C:
	CALL SUBOPT_0x3E
;     713      greenpwmh=(char)((GreenPwm)>>8);   //  Dgreen% pwm  GREEN - high byte
;     714      return;
	RJMP _0x280
;     715  }
;     716 
;     717   void  Blue (unsigned  int  dutyb)   // функція для PWM - Blue
;     718 {
_Blue:
;     719      BluePwm = (ICR3/100)* dutyb;
;	dutyb -> Y+0
	MOVW R26,R12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3F
;     720      if (BluePwm==0) BluePwm=1;
	LDS  R30,_BluePwm
	LDS  R31,_BluePwm+1
	SBIW R30,0
	BRNE _0x10D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3F
;     721      bluepwml=(char)(BluePwm);
_0x10D:
	CALL SUBOPT_0x40
;     722      bluepwmh=(char)((BluePwm)>>8);    // Dblue% pwm  BLUE - high byte
;     723      return;
_0x280:
	ADIW R28,2
	RET
;     724   }
;     725 
;     726 
;     727   void test (unsigned  int  speedx)   // тестування
;     728    {
_test:
;     729     unsigned char R=0, G=0, B=0;
;     730 
;     731     for (R=0; R<100; R++)      // red від 0 до 100 %
	CALL __SAVELOCR4
;	speedx -> Y+4
;	R -> R17
;	G -> R16
;	B -> R19
	LDI  R16,0
	LDI  R17,0
	LDI  R19,0
	LDI  R17,LOW(0)
_0x10F:
	CPI  R17,100
	BRSH _0x110
;     732          {
;     733              Red(R);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x41
;     734              delay_ms(speedx);
;     735           };
	SUBI R17,-1
	RJMP _0x10F
_0x110:
;     736 
;     737      for (R=99; R>0; R--)      // red від 100% до 1%
	LDI  R17,LOW(99)
_0x112:
	CPI  R17,1
	BRLO _0x113
;     738          {
;     739              Red(R);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x41
;     740              delay_ms(speedx);
;     741           };
	SUBI R17,1
	RJMP _0x112
_0x113:
;     742 
;     743     for (G=0; G<100; G++)      // Green від 0 до 100 %
	LDI  R16,LOW(0)
_0x115:
	CPI  R16,100
	BRSH _0x116
;     744 
;     745          {
;     746              Green(G);
	CALL SUBOPT_0x42
;     747              delay_ms(speedx);
;     748           };
	SUBI R16,-1
	RJMP _0x115
_0x116:
;     749      for (G=99; G>0; G--)      // Green від 100% до 1%
	LDI  R16,LOW(99)
_0x118:
	CPI  R16,1
	BRLO _0x119
;     750          {
;     751              Green(G);
	CALL SUBOPT_0x42
;     752              delay_ms(speedx);
;     753           };
	SUBI R16,1
	RJMP _0x118
_0x119:
;     754     for (B=0; B<100; B++)      // Blue від 0 до 100 %
	LDI  R19,LOW(0)
_0x11B:
	CPI  R19,100
	BRSH _0x11C
;     755 
;     756          {
;     757              Blue (B);
	CALL SUBOPT_0x43
;     758              delay_ms(speedx);
;     759           };
	SUBI R19,-1
	RJMP _0x11B
_0x11C:
;     760      for (B=99; B>0; B--)      // Blue від 100% до 1%
	LDI  R19,LOW(99)
_0x11E:
	CPI  R19,1
	BRLO _0x11F
;     761          {
;     762              Blue(B);
	CALL SUBOPT_0x43
;     763              delay_ms(speedx);
;     764           };
	SUBI R19,1
	RJMP _0x11E
_0x11F:
;     765 
;     766      for (B=0; B<100; B++)      // Red Green Blue від 0 до 100 %
	LDI  R19,LOW(0)
_0x121:
	CPI  R19,100
	BRSH _0x122
;     767          {
;     768              Red(B);
	CALL SUBOPT_0x44
	CALL _Red
;     769              Green(B);
	CALL SUBOPT_0x44
	CALL _Green
;     770              Blue (B);
	CALL SUBOPT_0x43
;     771              delay_ms(speedx);
;     772           };
	SUBI R19,-1
	RJMP _0x121
_0x122:
;     773      for (B=99; B>0; B--)      // Red =100% Green -Blue від 100% до 1%
	LDI  R19,LOW(99)
_0x124:
	CPI  R19,1
	BRLO _0x125
;     774          {
;     775                Green(B);
	CALL SUBOPT_0x44
	CALL _Green
;     776                 Blue(B);
	CALL SUBOPT_0x43
;     777                 delay_ms(speedx);
;     778           };
	SUBI R19,1
	RJMP _0x124
_0x125:
;     779 
;     780         for (B=0; B<100; B++)      // Blue від 0 до 100 %
	LDI  R19,LOW(0)
_0x127:
	CPI  R19,100
	BRSH _0x128
;     781 
;     782          {
;     783              Blue(B);
	CALL SUBOPT_0x43
;     784              delay_ms(speedx);
;     785           };
	SUBI R19,-1
	RJMP _0x127
_0x128:
;     786 
;     787     for (G=0; G<100; G++)      // Green від 0 до 100 %
	LDI  R16,LOW(0)
_0x12A:
	CPI  R16,100
	BRSH _0x12B
;     788          {
;     789              Green(G);
	CALL SUBOPT_0x42
;     790              delay_ms(speedx);
;     791           };
	SUBI R16,-1
	RJMP _0x12A
_0x12B:
;     792 
;     793      for (R=99; R>0; R--)      // red від 100% до 1%
	LDI  R17,LOW(99)
_0x12D:
	CPI  R17,1
	BRLO _0x12E
;     794          {
;     795              Red(R);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x41
;     796              delay_ms(speedx);
;     797           };
	SUBI R17,1
	RJMP _0x12D
_0x12E:
;     798 
;     799    for (B=99; B>49; B--)      // Red =100% Green -Blue від 100% до 1%
	LDI  R19,LOW(99)
_0x130:
	CPI  R19,50
	BRLO _0x131
;     800          {
;     801                Green(B);
	CALL SUBOPT_0x44
	CALL _Green
;     802                Blue(B);
	CALL SUBOPT_0x44
	CALL _Blue
;     803                R=R+1;
	SUBI R17,-LOW(1)
;     804                Red(R);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x41
;     805                 delay_ms(speedx);
;     806           };
	SUBI R19,1
	RJMP _0x130
_0x131:
;     807 
;     808 
;     809 
;     810      zvyk();
	CALL _zvyk
;     811 
;     812      return;
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;     813    }
;     814 
;     815 
;     816 
;     817 
;     818 void fxcalculator (void ) // функція для обчислення значень регістрів
;     819 {
_fxcalculator:
;     820  if (fxx<100)
	CALL SUBOPT_0x45
	__GETD1N 0x42C80000
	CALL __CMPF12
	BRSH _0x132
;     821    {
;     822      N=64;  // для частот 1…100гц
	LDI  R30,LOW(64)
	MOV  R11,R30
;     823      TCCR3B=0x1B;  // n=64
	LDI  R30,LOW(27)
	CALL SUBOPT_0x46
;     824      ICR3top = (3680000/(fxx*N))-1;
;     825      if (ICR3top==0) ICR3top=1;
	BRNE _0x133
	CALL SUBOPT_0x47
;     826      ICR3H =(char)(( ICR3top)>>8);    // - high b
_0x133:
	RJMP _0x296
;     827      ICR3L =(char)( ICR3top);         // - low byte
;     828      // ICR3H=0x01;  ICR3L=0x6f;      // 10000
;     829     }
;     830  else
_0x132:
;     831    {
;     832      N=1; // для частот 100…30000гц
	LDI  R30,LOW(1)
	MOV  R11,R30
;     833      TCCR3B=0x19;    // n-prescale=1
	LDI  R30,LOW(25)
	CALL SUBOPT_0x46
;     834      ICR3top= (3680000/(fxx*N))-1;
;     835      if (ICR3top==0) ICR3top=1;
	BRNE _0x135
	CALL SUBOPT_0x47
;     836      ICR3H =(char)(( ICR3top)>>8);  // - high byte
_0x135:
_0x296:
	LDS  R30,_ICR3top+1
	STS  129,R30
;     837      ICR3L =(char)( ICR3top);       // - low byte
	LDS  R30,_ICR3top
	STS  128,R30
;     838     }
;     839  }
	RET
;     840  //--end fxcalculator
;     841 
;     842 
;     843  void savesetup(void)  // функція menu save_setup
;     844   {
_savesetup:
;     845      //fxx=1.2;
;     846     rom_fxx=fxx;    // запис в ROM значення частоти
	CALL SUBOPT_0x48
	LDI  R26,LOW(_rom_fxx)
	LDI  R27,HIGH(_rom_fxx)
	CALL __EEPROMWRD
;     847      //  tp= TMAX;
;     848            zvyk();
	CALL _zvyk
;     849   }
	RET
;     850 
;     851 
;     852  void savespeed(void)  // функція menu save_setup
;     853   {
_savespeed:
;     854      //speed=10;        //ms
;     855     rom_speed=speed;    // запис в ROM значення швидкості проходження тестів
	CALL SUBOPT_0x36
	LDI  R26,LOW(_rom_speed)
	LDI  R27,HIGH(_rom_speed)
	CALL __EEPROMWRW
;     856      //  tp= TMAX;
;     857 
;     858            zvyk();
	CALL _zvyk
;     859   }
	RET
;     860 
;     861 
;     862 
;     863 
;     864 
;     865 void main_menu(void)   // ГОЛОВНЕ МЕНЮ і його підменю
;     866 {
_main_menu:
;     867    char *menu_items[7]=  { " SET Fx < 300Hz ", " SET Fx > 300Hz ", "SAVE SETUP", "SAVE SPEED", "SET TEST SPEED", "TEST RGB"};
;     868 
;     869    unsigned char x_pos[] = {0, 0, 3, 3, 1, 4};   // координати для items menu
;     870    int sel=0;                                    // по замовчуванню ставити 0
;     871 
;     872     while(1)
	SBIW R28,20
	LDI  R24,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x137*2)
	LDI  R31,HIGH(_0x137*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	*menu_items -> Y+8
;	x_pos -> Y+2
;	sel -> R16,R17
	LDI  R16,0
	LDI  R17,0
_0x138:
;     873     {
;     874        PREV_PINF=PINF;   // кн. на порті F
	IN   R4,0
;     875        lcd_gotoxy(0,0);
	CALL SUBOPT_0x49
;     876        lcd_putsf("***** MENU *****");
	__POINTW1FN _0,101
	CALL SUBOPT_0x4A
;     877        lcd_gotoxy(x_pos[sel],1);
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CALL SUBOPT_0x8
;     878        lcd_puts(menu_items[sel]);
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,8
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CALL SUBOPT_0x4B
;     879 
;     880 
;     881        if (get_key_status(SELECT_PLUS_BTN))  // натиснута кл. "select+" main_menu()
	CALL SUBOPT_0x6
	BREQ _0x13B
;     882         {
;     883           if (!get_prev_key_status(SELECT_PLUS_BTN) || (gSelectPlusCounter == CNTREPEAT))
	CALL SUBOPT_0x1D
	BREQ _0x13D
	CALL SUBOPT_0x1E
	BRNE _0x13C
_0x13D:
;     884            {
;     885              if (gSelectPlusCounter == CNTREPEAT)
	CALL SUBOPT_0x1E
	BRNE _0x13F
;     886                delay_ms(80);
	CALL SUBOPT_0x1F
;     887              if (sel<5)       // кількість пунктів (меню - 1)
_0x13F:
	__CPWRN 16,17,5
	BRGE _0x140
;     888                sel++;
	__ADDWRN 16,17,1
;     889              else sel = 0;
	RJMP _0x141
_0x140:
	__GETWRN 16,17,0
;     890              lcd_clear();
_0x141:
	CALL _lcd_clear
;     891           }
;     892         }
_0x13C:
;     893        // -end "select+" - main_menu()-
;     894 
;     895         if (get_key_status(SELECT_MINUS_BTN))    // натиснута кл. "select-" main_menu()
_0x13B:
	CALL SUBOPT_0x7
	BREQ _0x142
;     896          {
;     897             if (!get_prev_key_status(SELECT_MINUS_BTN) || (gSelectMinusCounter == CNTREPEAT))
	CALL SUBOPT_0x22
	BREQ _0x144
	CALL SUBOPT_0x23
	BRNE _0x143
_0x144:
;     898               {
;     899                 if (gSelectMinusCounter == CNTREPEAT)
	CALL SUBOPT_0x23
	BRNE _0x146
;     900                    delay_ms(80);
	CALL SUBOPT_0x1F
;     901                 if (sel>0)
_0x146:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x147
;     902                     sel--;
	__SUBWRN 16,17,1
;     903                 else sel = 5;   // кількість пунктів (меню - 1)
	RJMP _0x148
_0x147:
	__GETWRN 16,17,5
;     904                 lcd_clear();
_0x148:
	CALL _lcd_clear
;     905              }
;     906           }
_0x143:
;     907          // -end select(-) -main_menu()
;     908 
;     909         if (get_key_status(MENU_ENTER_BTN))      // натиснута кл. "enter"  main_menu()
_0x142:
	CALL SUBOPT_0x25
	BRNE PC+3
	JMP _0x149
;     910           {
;     911              if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x26
	BREQ PC+3
	JMP _0x14A
;     912                 {
;     913                  //  lcd_clear();
;     914                    switch(sel)
	MOVW R30,R16
;     915                      {
;     916                        case 0:
	SBIW R30,0
	BRNE _0x14E
;     917                           lcd_clear();             // модуль SET Fx< 300 Hz
	CALL SUBOPT_0x4C
;     918                           lcd_gotoxy(0,0);
;     919                           lcd_putsf(" Fpwm=");
	__POINTW1FN _0,118
	CALL SUBOPT_0x4A
;     920                           start_p=set_page();
	CALL _set_page
	CALL SUBOPT_0x4D
;     921                           fxx= (float)start_p;     // значення частоти
;     922                           fxx=fxx/10;
	CALL SUBOPT_0x45
	CALL SUBOPT_0x4E
	CALL __DIVF21
	CALL SUBOPT_0x4F
;     923 
;     924                           fxcalculator();
	CALL _fxcalculator
;     925                        break;                     // end модуль SET Fx
	RJMP _0x14D
;     926 
;     927                        case 1:
_0x14E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14F
;     928                           lcd_clear();             // модуль SET Fx >300 Hz
	CALL SUBOPT_0x4C
;     929                           lcd_gotoxy(0,0);
;     930                           lcd_putsf(" Fpwm=");
	__POINTW1FN _0,118
	CALL SUBOPT_0x4A
;     931                           start_p=set_page2();
	CALL _set_page2
	CALL SUBOPT_0x4D
;     932                           fxx= (float)start_p;   // значення частоти
;     933                           fxcalculator();
	CALL _fxcalculator
;     934                        break;
	RJMP _0x14D
;     935 
;     936                        case 2:
_0x14F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x150
;     937                          savesetup();  // записати налаштування в память
	CALL _savesetup
;     938                          lcd_clear();             // модуль SET Fx >300 Hz
	CALL _lcd_clear
;     939                          lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
;     940                          lcd_putsf("Save OK!");
	__POINTW1FN _0,125
	CALL SUBOPT_0x4A
;     941                          delay_ms(900);
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CALL SUBOPT_0x0
;     942                        break;
	RJMP _0x14D
;     943 
;     944                        case 3:
_0x150:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x151
;     945                          savespeed() ;   // записати в память значення затримки
	CALL _savespeed
;     946                          lcd_clear();             // модуль SET Fx >300 Hz
	CALL _lcd_clear
;     947                          lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
;     948                          lcd_putsf("Save speed OK!");
	__POINTW1FN _0,134
	CALL SUBOPT_0x4A
;     949                          delay_ms(900);
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CALL SUBOPT_0x0
;     950                        break;
	RJMP _0x14D
;     951 
;     952                        case 4:
_0x151:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x152
;     953                          lcd_clear();             // модуль SET Fx >300 Hz
	CALL SUBOPT_0x4C
;     954                          lcd_gotoxy(0,0);
;     955                          lcd_putsf(" DELAY=");
	__POINTW1FN _0,149
	CALL SUBOPT_0x4A
;     956                          set_speed();
	CALL _set_speed
;     957                        break;
	RJMP _0x14D
;     958 
;     959                        case 5:
_0x152:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x154
;     960                          lcd_clear();             // модуль SET Fx >300 Hz
	CALL SUBOPT_0x4C
;     961                          lcd_gotoxy(0,0);
;     962                          lcd_putsf("Testing....wait!");
	__POINTW1FN _0,157
	CALL SUBOPT_0x4A
;     963                          test (speed);
	CALL SUBOPT_0x36
	ST   -Y,R31
	ST   -Y,R30
	CALL _test
;     964                        break;     //     вставити модуль  для п. меню
;     965                        default: break;    //     вставити модуль  для п. меню
_0x154:
;     966                      }
_0x14D:
;     967                 }
;     968            }
_0x14A:
;     969            // end enter-main_menu()
;     970 
;     971 
;     972           if (get_key_status(ESC_BTN))      // натиснута кл. "exit"  main_menu()
_0x149:
	CALL SUBOPT_0x2F
	BREQ _0x155
;     973              {
;     974                if (!get_prev_key_status(ESC_BTN))
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	BRNE _0x156
;     975                   {
;     976                     TIMSK&=~(1<<6);      // disable Timer 2 overflow interrupt service routine
	IN   R30,0x37
	ANDI R30,0xBF
	OUT  0x37,R30
;     977                      return;                           // back to working mode
	RJMP _0x27F
;     978                    }
;     979               }
_0x156:
;     980              //-end exit-main_menu()-
;     981     }
_0x155:
	RJMP _0x138
;     982  }
_0x27F:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
;     983 
;     984 
;     985 void main(void)
;     986 {
_main:
;     987 // Declare your local variables here
;     988 
;     989 // Input/Output Ports initialization
;     990 PORTA=0x00;  DDRA=0x00;  // Port A initialization
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	OUT  0x1A,R30
;     991 PORTB=0x00;  DDRB=0x00;  // Port B initialization
	OUT  0x18,R30
	OUT  0x17,R30
;     992 PORTC=0x00;  DDRC=0x00;  // Port C initialization
	OUT  0x15,R30
	OUT  0x14,R30
;     993 PORTD=0x00;  DDRD=0x00;  // Port D initialization
	OUT  0x12,R30
	OUT  0x11,R30
;     994 PORTE=0x00; DDRE=0x38;   // Port- порт PE = 00111000 (pin5,6,7) {A,B,C}
	OUT  0x3,R30
	LDI  R30,LOW(56)
	OUT  0x2,R30
;     995 PORTF=0x00;  DDRF=0x00;  // Port F initialization
	LDI  R30,LOW(0)
	STS  98,R30
	STS  97,R30
;     996 PORTG=0x00;  DDRG=0x00;  // Port G initialization
	STS  101,R30
	STS  100,R30
;     997 
;     998 // Timer/Counter 0 initialization
;     999 // Clock source: System Clock   // Clock value: Timer 0 Stopped
;    1000 // Mode: Normal top=FFh    // OC0 output: Disconnected
;    1001 ASSR=0x00;  TCCR0=0x00; TCNT0=0x00; OCR0=0x00;
	OUT  0x30,R30
	OUT  0x33,R30
	OUT  0x32,R30
	OUT  0x31,R30
;    1002 
;    1003 // Timer/Counter 1 initialization
;    1004 // Clock source: System Clock   // Clock value: Timer 1 Stopped
;    1005 // Mode: Normal top=FFFFh
;    1006 // OC1A output: Discon.  // OC1B output: Discon. // OC1C output: Discon.
;    1007 // Noise Canceler: Off
;    1008 // Input Capture on Falling Edge
;    1009 // Timer 1 Overflow Interrupt: Off
;    1010 // Input Capture Interrupt: Off
;    1011 // Compare A Interrupt: Off  Compare B  Interrupt: Off  Compare C  Interrupt: Off
;    1012 TCCR1A=0x00; TCCR1B=0x00;
	OUT  0x2F,R30
	OUT  0x2E,R30
;    1013 TCNT1H=0x00; TCNT1L=0x00;
	OUT  0x2D,R30
	OUT  0x2C,R30
;    1014 ICR1H=0x00;  ICR1L=0x00;
	OUT  0x27,R30
	OUT  0x26,R30
;    1015 OCR1AH=0x00; OCR1AL=0x00;   OCR1BH=0x00; OCR1BL=0x00;  OCR1CH=0x00; OCR1CL=0x00;
	OUT  0x2B,R30
	CALL SUBOPT_0x50
	STS  121,R30
	LDI  R30,LOW(0)
	STS  120,R30
;    1016 
;    1017 
;    1018 // Timer/Counter 1 initialization
;    1019 // Clock source: System Clock
;    1020 
;    1021 // sound - частота timer1
;    1022 TCCR1A=0x82;      // fast PWM = 14
	LDI  R30,LOW(130)
	OUT  0x2F,R30
;    1023 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
;    1024 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    1025 TCNT1L=0x00;
	OUT  0x2C,R30
;    1026 ICR1H=0x07;        // частота
	LDI  R30,LOW(7)
	OUT  0x27,R30
;    1027 ICR1L=0xCF;        // частота
	LDI  R30,LOW(207)
	OUT  0x26,R30
;    1028 OCR1AH=0x03;  //  шпаруватість
	LDI  R30,LOW(3)
	OUT  0x2B,R30
;    1029 OCR1AL=0xFF;   //  шпаруватість
	LDI  R30,LOW(255)
	CALL SUBOPT_0x50
;    1030 OCR1BH=0x00;
;    1031 OCR1BL=0x00;
;    1032 
;    1033 
;    1034 
;    1035 
;    1036 
;    1037 
;    1038 
;    1039 // Timer/Counter 2 initialization
;    1040   // Clock source: System Clock
;    1041   // Clock value: 8000.000 kHz  - корегувати!!!!!
;    1042   // Mode: Normal top=FFh
;    1043   // OC2 output: Disconnected
;    1044   TCNT2=0x00;   OCR2=0x00;    TCCR2=0x03;
	OUT  0x24,R30
	LDI  R30,LOW(0)
	OUT  0x23,R30
	LDI  R30,LOW(3)
	OUT  0x25,R30
;    1045 
;    1046 // Timer/Counter 3 initialization
;    1047 // Clock source: System Clock
;    1048 // Clock value: 3680,000 kHz
;    1049 // Mode: Fast PWM top=ICR3
;    1050 // Noise Canceler: Off
;    1051 // Input Capture on Falling Edge
;    1052 // OC3A output: Non-Inv.
;    1053 // OC3B output: Non-Inv.
;    1054 // OC3C output: Non-Inv.
;    1055 // Timer 3 Overflow Interrupt: On
;    1056 // Input Capture Interrupt: Off
;    1057 // Compare A Match Interrupt: Off
;    1058 // Compare B Match Interrupt: Off
;    1059 // Compare C Match Interrupt: Off
;    1060 TCCR3A=0xAA;
	LDI  R30,LOW(170)
	STS  139,R30
;    1061 TCCR3B=0x19;    // n-prescale=1   TCCR3B=0x1A; // n=8
	LDI  R30,LOW(25)
	STS  138,R30
;    1062 
;    1063 TCNT3H=0x00;  TCNT3L=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
	STS  136,R30
;    1064 // ICR3H=0x0E; ICR3L=0x5f;  // E5F = for 1000 hz  Top= ICR3 для FAST PWM mode=14
;    1065 // ICR3H=0x47;  ICR3L=0xdf;   // частота 200 Hz output
;    1066 ICR3H=0x8F;  ICR3L=0xBF;   // частота 100 Hz output    8FBF
	LDI  R30,LOW(143)
	STS  129,R30
	LDI  R30,LOW(191)
	STS  128,R30
;    1067 // ICR3H=0x01;  ICR3L=0x6f;   // 10000
;    1068 
;    1069 OCR3AH=0x00; OCR3AL=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
	STS  134,R30
;    1070 OCR3BH=0x00; OCR3BL=0x00;
	STS  133,R30
	STS  132,R30
;    1071 OCR3CH=0x00; OCR3CL=0x00;
	STS  131,R30
	STS  130,R30
;    1072 
;    1073 // External Interrupt(s) initialization
;    1074 // INT0: Off , INT1: Off, INT2: Off, INT3: Off, INT4: Off, INT5: Off, INT6: Off, INT7: Off
;    1075 EICRA=0x00;  EICRB=0x00;  EIMSK=0x00;
	STS  106,R30
	OUT  0x3A,R30
	OUT  0x39,R30
;    1076 
;    1077 // Timer(s)/Counter(s) Interrupt(s) initialization
;    1078 TIMSK=0x00;
	OUT  0x37,R30
;    1079 ETIMSK=0x04;  // TIM3_OVF
	LDI  R30,LOW(4)
	STS  125,R30
;    1080 
;    1081 // Analog Comparator initialization
;    1082 // Analog Comparator: Off
;    1083 // Analog Comparator Input Capture by Timer/Counter 1: Off
;    1084 ACSR=0x80;     SFIOR=0x00;
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    1085 
;    1086 DDRC = 0x60;	// Port C RC5, RC6 ->output used for LCD
	LDI  R30,LOW(96)
	OUT  0x14,R30
;    1087 DDRA = 0x0F;	// D0-D3 -> output used for LCD
	LDI  R30,LOW(15)
	OUT  0x1A,R30
;    1088 DDRA.7=1;  	// LED1 -> output used for LCD
	SBI  0x1A,7
;    1089 PORTA.7=1;      // LED1=1 output used for LCD
	SBI  0x1B,7
;    1090 DDRC.7=1;       // LWR/-> output used for LCD
	SBI  0x14,7
;    1091 PORTC.7=0;      // LWR/=0  output used for LCD
	CBI  0x15,7
;    1092 DDRD.2 = 1;     // SD5/-> включити живлення +5Х LCD
	SBI  0x11,2
;    1093 PORTD.2=1;      // SD5/=1 включити живлення +5Х LCD
	SBI  0x12,2
;    1094 
;    1095 //select reference voltage for ADC
;    1096 ADMUX|=(0<<REFS1)|(0<<REFS0);    // AREF pin - опорна напруга 5в
	IN   R30,0x7
	OUT  0x7,R30
;    1097 ADMUX=ADC_VREF_TYPE & 0xff;    // Bit 5 - ADLAR=0 - 10 бітне АЦП
	LDI  R30,LOW(0)
	OUT  0x7,R30
;    1098 ADCSRA=0x85;           // Bit 7 - ADEN: ADC Enable
	LDI  R30,LOW(133)
	OUT  0x6,R30
;    1099                       // Bits 2:0 - ADPS2:0: ADC Prescaler Select Bits =101 -  K=32
;    1100                      // ADC Clock frequency: 4 MHz/32= 125,000 kHz (50kHz - 200kHz = normal )
;    1101 
;    1102 lcd_init();    // ініціалізація LCD
	CALL _lcd_init
;    1103 lcd_clear();
	CALL SUBOPT_0x4C
;    1104 lcd_gotoxy(0,0);
;    1105 lcd_putsf("RGB STRIP TESTER");
	__POINTW1FN _0,174
	CALL SUBOPT_0x4A
;    1106 delay_ms (700);
	CALL SUBOPT_0x51
;    1107 delay_ms (700);
	CALL SUBOPT_0x51
;    1108 
;    1109   fxx=rom_fxx;       // прочитати опорну частоту з  памяті в змінну  fxx
	LDI  R26,LOW(_rom_fxx)
	LDI  R27,HIGH(_rom_fxx)
	CALL __EEPROMRDD
	CALL SUBOPT_0x4F
;    1110  speed=rom_speed;  // прочитати delay  з  памяті в змінну speed
	LDI  R26,LOW(_rom_speed)
	LDI  R27,HIGH(_rom_speed)
	CALL __EEPROMRDW
	CALL SUBOPT_0x37
;    1111 
;    1112   fxcalculator(); // функція для обчислення значень регістрів TCCR3B, ICR3H,  ICR3L
	CALL _fxcalculator
;    1113 
;    1114  //ініціалізація кнопок menu на порті F
;    1115 BTNS_PORT=(1<<MENU_ENTER_BTN)|(1<<SELECT_PLUS_BTN)|(1<<SELECT_MINUS_BTN)|(1<<ESC_BTN);
	LDI  R30,LOW(30)
	STS  98,R30
;    1116 BTNS_PORT_DDR &= ~(1<<MENU_ENTER_BTN)&~(1<<SELECT_PLUS_BTN)&~(1<<SELECT_MINUS_BTN)&~(1<<ESC_BTN);
	LDS  R30,97
	ANDI R30,LOW(0xE1)
	STS  97,R30
;    1117 
;    1118 // Global enable interrupts
;    1119 #asm("sei")
	sei
;    1120 
;    1121 
;    1122 while (1)
_0x163:
;    1123    {
;    1124 // Place your code here
;    1125 
;    1126     PREV_PINF=PINF;
	IN   R4,0
;    1127     k=get_key_status(MENU_ENTER_BTN);   // - якщо натиснути клавішу ENTER то в  МЕНЮ
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_key_status
	MOV  R5,R30
;    1128 
;    1129          if (k==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x166
;    1130            {
;    1131               lcd_clear();
	CALL _lcd_clear
;    1132               TIMSK |= (1<<6);   // enable Timer 2 overflow interrupt service routine
	IN   R30,0x37
	ORI  R30,0x40
	OUT  0x37,R30
;    1133               main_menu();      // головне меню
	CALL _main_menu
;    1134               TIMSK&=~(1<<6); // disable Timer 2 overflow interrupt service routine
	IN   R30,0x37
	ANDI R30,0xBF
	OUT  0x37,R30
;    1135               lcd_clear();
	CALL _lcd_clear
;    1136            }
;    1137 
;    1138      lcd_gotoxy(0,0);
_0x166:
	CALL SUBOPT_0x49
;    1139      lcd_putsf("                ");
	__POINTW1FN _0,191
	CALL SUBOPT_0x4A
;    1140      lcd_gotoxy(0,0);
	CALL SUBOPT_0x49
;    1141     // lcd_putsf("F");
;    1142      fx=(int)ICR3L;   // частота pwm
	LDS  R30,128
	LDI  R31,0
	CALL __CWD1
	STS  _fx,R30
	STS  _fx+1,R31
	STS  _fx+2,R22
	STS  _fx+3,R23
;    1143      ICR3 = ((ICR3H & 0xffff)<<8)|ICR3L;    // fx= ICR3 = ICR3H=0x0E; ICR3L=0x5f, {3679}
	LDS  R30,129
	LDI  R31,0
	ANDI R30,LOW(0xFFFF)
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R30
	LDS  R30,128
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R12,R30
;    1144 // fx= SYS_FREQ/(ICR3+1)/8;   // n=8
;    1145 // fx= SYS_FREQ/(ICR3+1);     // n=1
;    1146 
;    1147      if (fxx>1)
	CALL SUBOPT_0x45
	CALL SUBOPT_0x52
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x167
;    1148      {
;    1149         tx=(1000000/(fxx));
	CALL SUBOPT_0x48
	__GETD2N 0x49742400
	CALL SUBOPT_0x53
;    1150         od='u';
	LDI  R30,LOW(117)
	RJMP _0x297
;    1151      }
;    1152      else
_0x167:
;    1153      {
;    1154        tx=(1000/fxx);
	CALL SUBOPT_0x48
	__GETD2N 0x447A0000
	CALL SUBOPT_0x53
;    1155        od='m';
	LDI  R30,LOW(109)
_0x297:
	STS  _od,R30
;    1156      };
;    1157 
;    1158 
;    1159      if (fxx<=300)
	CALL SUBOPT_0x45
	__GETD1N 0x43960000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x169
;    1160      {sprintf(buffer,"%.1fHz ", fxx);}
	CALL SUBOPT_0x54
	__POINTW1FN _0,208
	RJMP _0x298
;    1161      else
_0x169:
;    1162      sprintf(buffer,"%.0fHz ", fxx);
	CALL SUBOPT_0x54
	__POINTW1FN _0,216
_0x298:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x48
	CALL SUBOPT_0x55
;    1163 
;    1164      lcd_puts(buffer);
	CALL SUBOPT_0x56
;    1165      delay_ms (500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x0
;    1166 
;    1167      lcd_putsf("T");
	__POINTW1FN _0,224
	CALL SUBOPT_0x4A
;    1168 
;    1169      if (fxx==100)
	CALL SUBOPT_0x45
	__CPD2N 0x42C80000
	BRNE _0x16B
;    1170         {tx=10000;};
	__GETD1N 0x2710
	STS  _tx,R30
	STS  _tx+1,R31
	STS  _tx+2,R22
	STS  _tx+3,R23
_0x16B:
;    1171      // {tx=9999;};
;    1172      sprintf(buffer,"%ld%cS", tx,od);
	CALL SUBOPT_0x54
	__POINTW1FN _0,226
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_tx
	LDS  R31,_tx+1
	LDS  R22,_tx+2
	LDS  R23,_tx+3
	CALL __PUTPARD1
	LDS  R30,_od
	CALL SUBOPT_0x32
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;    1173      lcd_puts(buffer);
	CALL SUBOPT_0x56
;    1174 
;    1175      lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
;    1176      lcd_putsf("                ");
	__POINTW1FN _0,191
	CALL SUBOPT_0x4A
;    1177      ADC_INPUT = 0x00; // порт PF0
	CLR  R10
;    1178      adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
	CALL SUBOPT_0x57
;    1179      indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги
;    1180      tinf= indication/1000;
;    1181      Dgreen= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну
	STS  _Dgreen,R30
	STS  _Dgreen+1,R31
;    1182      lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
;    1183      sprintf(buffer," R%u%%", Dgreen);    // buffer for LCD - ADC - Dblue
	CALL SUBOPT_0x54
	__POINTW1FN _0,233
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Dgreen
	LDS  R31,_Dgreen+1
	CALL SUBOPT_0x58
;    1184      lcd_puts(buffer);
	CALL SUBOPT_0x56
;    1185 
;    1186      ADC_INPUT = 0x05; // порт PF5
	LDI  R30,LOW(5)
	MOV  R10,R30
;    1187      adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
	CALL SUBOPT_0x57
;    1188      indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги
;    1189      tinf= indication/1000;
;    1190      Dred= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну
	STS  _Dred,R30
	STS  _Dred+1,R31
;    1191      //sprintf(buffer," G=%u", Dred);    // buffer for LCD - ADC - Dblue
;    1192      sprintf(buffer," G%u%%", Dred);    // buffer for LCD - ADC - Dblue
	CALL SUBOPT_0x54
	__POINTW1FN _0,240
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Dred
	LDS  R31,_Dred+1
	CALL SUBOPT_0x58
;    1193 
;    1194      lcd_puts(buffer);
	CALL SUBOPT_0x56
;    1195 
;    1196      ADC_INPUT = 0x06; // порт PF6    blue
	LDI  R30,LOW(6)
	MOV  R10,R30
;    1197      adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
	CALL SUBOPT_0x57
;    1198      indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги
;    1199      tinf= indication/1000;
;    1200      Dblue= (unsigned int)((tinf/2/vref)*100);  // перевірити опорну
	STS  _Dblue,R30
	STS  _Dblue+1,R31
;    1201      sprintf(buffer," B%u%%", Dblue);    // buffer for LCD - ADC - Dblue
	CALL SUBOPT_0x54
	__POINTW1FN _0,247
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Dblue
	LDS  R31,_Dblue+1
	CALL SUBOPT_0x58
;    1202      lcd_puts(buffer);
	CALL SUBOPT_0x56
;    1203 
;    1204      RedPwm = (ICR3/100)*Dred;
	MOVW R26,R12
	CALL SUBOPT_0x12
	LDS  R26,_Dred
	LDS  R27,_Dred+1
	CALL __MULW12U
	CALL SUBOPT_0x3B
;    1205      if (RedPwm==0) RedPwm=1;
	LDS  R30,_RedPwm
	LDS  R31,_RedPwm+1
	SBIW R30,0
	BRNE _0x16C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3B
;    1206      redpwml=(char)(RedPwm);        // Dred% pwm  RED - low byte
_0x16C:
	CALL SUBOPT_0x3C
;    1207      redpwmh=(char)((RedPwm)>>8);  // Dred% pwm  RED - high byte
;    1208 
;    1209      GreenPwm = (ICR3/100)*Dgreen;
	MOVW R26,R12
	CALL SUBOPT_0x12
	LDS  R26,_Dgreen
	LDS  R27,_Dgreen+1
	CALL __MULW12U
	CALL SUBOPT_0x3D
;    1210      if (GreenPwm==0) GreenPwm=1;
	LDS  R30,_GreenPwm
	LDS  R31,_GreenPwm+1
	SBIW R30,0
	BRNE _0x16D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3D
;    1211      greenpwml=(char)(GreenPwm);
_0x16D:
	CALL SUBOPT_0x3E
;    1212      greenpwmh=(char)((GreenPwm)>>8);  //  Dgreen% pwm  GREEN - high byte
;    1213 
;    1214      BluePwm = (ICR3/100)*Dblue;
	MOVW R26,R12
	CALL SUBOPT_0x12
	LDS  R26,_Dblue
	LDS  R27,_Dblue+1
	CALL __MULW12U
	CALL SUBOPT_0x3F
;    1215      if (BluePwm==0) BluePwm=1;
	LDS  R30,_BluePwm
	LDS  R31,_BluePwm+1
	SBIW R30,0
	BRNE _0x16E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3F
;    1216      bluepwml=(char)(BluePwm);
_0x16E:
	CALL SUBOPT_0x40
;    1217      bluepwmh=(char)((BluePwm)>>8);   // Dblue% pwm  BLUE - high byte
;    1218 
;    1219       ADC_INPUT = 0x07; // порт PF7    // напруга живлення
	LDI  R30,LOW(7)
	MOV  R10,R30
;    1220      adc_in= read_adc(ADC_INPUT);    // міряємо і отримуємо результат перетворення
	ST   -Y,R10
	CALL _read_adc
	STS  _adc_in,R30
	STS  _adc_in+1,R31
;    1221      indication=adc_in/0.1024;          // коефіцієнт залежить від опорної напруги
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3DD1B717
	CALL __DIVF21
	STS  _indication,R30
	STS  _indication+1,R31
	STS  _indication+2,R22
	STS  _indication+3,R23
;    1222      tinf= indication/1000;
	LDS  R26,_indication
	LDS  R27,_indication+1
	LDS  R24,_indication+2
	LDS  R25,_indication+3
	__GETD1N 0x447A0000
	CALL __DIVF21
	STS  _tinf,R30
	STS  _tinf+1,R31
	STS  _tinf+2,R22
	STS  _tinf+3,R23
;    1223 
;    1224      delay_ms (700);
	CALL SUBOPT_0x51
;    1225      delay_ms (700);
	CALL SUBOPT_0x51
;    1226 
;    1227 
;    1228     };
	RJMP _0x163
;    1229 }
_0x16F:
	RJMP _0x16F

	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G2:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x17D
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x17F
	__CPWRN 16,17,2
	BRLO _0x180
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x17F:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x59
	LDD  R26,Y+6
	STD  Z+0,R26
_0x180:
	RJMP _0x181
_0x17D:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x181:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__ftoa_G2:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x182
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x182:
	LDD  R30,Y+8
	LDI  R26,LOW(__fround_G2*2)
	LDI  R27,HIGH(__fround_G2*2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	CALL SUBOPT_0x5A
	CALL __ADDF12
	CALL SUBOPT_0x5B
	LDI  R17,LOW(0)
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5C
_0x183:
	CALL SUBOPT_0x5D
	CALL __CMPF12
	BRLO _0x185
	CALL SUBOPT_0x5E
	CALL __MULF12
	CALL SUBOPT_0x5C
	SUBI R17,-LOW(1)
	RJMP _0x183
_0x185:
	CPI  R17,0
	BRNE _0x186
	CALL SUBOPT_0x5F
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x187
_0x186:
_0x188:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x18A
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x61
	__GETD2S 2
	CALL SUBOPT_0x62
	CALL __MULF12
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x63
	RJMP _0x188
_0x18A:
_0x187:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x18B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x27E
_0x18B:
	CALL SUBOPT_0x5F
	LDI  R30,LOW(46)
	ST   X,R30
_0x18C:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x18E
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x64
	CALL SUBOPT_0x5B
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x61
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x62
	CALL SUBOPT_0x63
	RJMP _0x18C
_0x18E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x27E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G2:
	SBIW R28,4
	CALL __SAVELOCR4
	CALL SUBOPT_0x52
	CALL SUBOPT_0x65
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x18F
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x18F:
	LDD  R17,Y+11
_0x190:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x192
	CALL SUBOPT_0x66
	CALL SUBOPT_0x65
	RJMP _0x190
_0x192:
	CALL SUBOPT_0x67
	CALL __CPD10
	BRNE _0x193
	LDI  R19,LOW(0)
	CALL SUBOPT_0x66
	CALL SUBOPT_0x65
	RJMP _0x194
_0x193:
	LDD  R19,Y+11
	CALL SUBOPT_0x68
	BREQ PC+2
	BRCC PC+3
	JMP  _0x195
	CALL SUBOPT_0x66
	CALL SUBOPT_0x65
_0x196:
	CALL SUBOPT_0x68
	BRLO _0x198
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	RJMP _0x196
_0x198:
	RJMP _0x199
_0x195:
_0x19A:
	CALL SUBOPT_0x68
	BRSH _0x19C
	CALL SUBOPT_0x69
	CALL SUBOPT_0x64
	CALL SUBOPT_0x6B
	SUBI R19,LOW(1)
	RJMP _0x19A
_0x19C:
	CALL SUBOPT_0x66
	CALL SUBOPT_0x65
_0x199:
	CALL SUBOPT_0x67
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x68
	BRLO _0x19D
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
_0x19D:
_0x194:
	LDI  R17,LOW(0)
_0x19E:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x1A0
	__GETD2S 4
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x65
	__GETD1S 4
	CALL SUBOPT_0x69
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x61
	CALL SUBOPT_0x62
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x69
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x6B
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x19E
	CALL SUBOPT_0x6C
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x19E
_0x1A0:
	CALL SUBOPT_0x6D
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x1A2
	CALL SUBOPT_0x6C
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x1A2:
	CPI  R19,10
	BRLT _0x1A3
	CALL SUBOPT_0x6D
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x1A3:
	CALL SUBOPT_0x6D
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G2:
	SBIW R28,63
	SBIW R28,15
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 84
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1A4:
	MOVW R26,R28
	SUBI R26,LOW(-(90))
	SBCI R27,HIGH(-(90))
	CALL SUBOPT_0x59
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x1A6
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x1AA
	CPI  R18,37
	BRNE _0x1AB
	LDI  R17,LOW(1)
	RJMP _0x1AC
_0x1AB:
	CALL SUBOPT_0x6E
_0x1AC:
	RJMP _0x1A9
_0x1AA:
	CPI  R30,LOW(0x1)
	BRNE _0x1AD
	CPI  R18,37
	BRNE _0x1AE
	CALL SUBOPT_0x6E
	RJMP _0x299
_0x1AE:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+19,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x1AF
	LDI  R16,LOW(1)
	RJMP _0x1A9
_0x1AF:
	CPI  R18,43
	BRNE _0x1B0
	LDI  R30,LOW(43)
	STD  Y+19,R30
	RJMP _0x1A9
_0x1B0:
	CPI  R18,32
	BRNE _0x1B1
	LDI  R30,LOW(32)
	STD  Y+19,R30
	RJMP _0x1A9
_0x1B1:
	RJMP _0x1B2
_0x1AD:
	CPI  R30,LOW(0x2)
	BRNE _0x1B3
_0x1B2:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x1B4
	ORI  R16,LOW(128)
	RJMP _0x1A9
_0x1B4:
	RJMP _0x1B5
_0x1B3:
	CPI  R30,LOW(0x3)
	BRNE _0x1B6
_0x1B5:
	CPI  R18,48
	BRLO _0x1B8
	CPI  R18,58
	BRLO _0x1B9
_0x1B8:
	RJMP _0x1B7
_0x1B9:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x1A9
_0x1B7:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x1BA
	LDI  R17,LOW(4)
	RJMP _0x1A9
_0x1BA:
	RJMP _0x1BB
_0x1B6:
	CPI  R30,LOW(0x4)
	BRNE _0x1BD
	CPI  R18,48
	BRLO _0x1BF
	CPI  R18,58
	BRLO _0x1C0
_0x1BF:
	RJMP _0x1BE
_0x1C0:
	ORI  R16,LOW(32)
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x1A9
_0x1BE:
_0x1BB:
	CPI  R18,108
	BRNE _0x1C1
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x1A9
_0x1C1:
	RJMP _0x1C2
_0x1BD:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x1A9
_0x1C2:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x1C7
	CALL SUBOPT_0x6F
	LDD  R30,Z+4
	CALL SUBOPT_0x70
	RJMP _0x1C8
_0x1C7:
	CPI  R30,LOW(0x45)
	BREQ _0x1CB
	CPI  R30,LOW(0x65)
	BRNE _0x1CC
_0x1CB:
	RJMP _0x1CD
_0x1CC:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x1CE
_0x1CD:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x6F
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x71
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x1CF
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x1D1
	RJMP _0x1D2
_0x1CF:
	CALL SUBOPT_0x72
	CALL __ANEGF1
	CALL SUBOPT_0x71
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x1D1:
	SBRS R16,7
	RJMP _0x1D3
	LDD  R30,Y+19
	CALL SUBOPT_0x70
	RJMP _0x1D4
_0x1D3:
	CALL SUBOPT_0x73
	LDD  R26,Y+19
	STD  Z+0,R26
_0x1D4:
_0x1D2:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x1D6
	CALL SUBOPT_0x72
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoa_G2
	RJMP _0x1D7
_0x1D6:
	CALL SUBOPT_0x72
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G2
_0x1D7:
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x74
	RJMP _0x1D8
_0x1CE:
	CPI  R30,LOW(0x73)
	BRNE _0x1DA
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x75
	CALL SUBOPT_0x74
	RJMP _0x1DB
_0x1DA:
	CPI  R30,LOW(0x70)
	BRNE _0x1DD
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x75
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x1DB:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x1DF
	CP   R20,R17
	BRLO _0x1E0
_0x1DF:
	RJMP _0x1DE
_0x1E0:
	MOV  R17,R20
_0x1DE:
_0x1D8:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R19,LOW(0)
	RJMP _0x1E1
_0x1DD:
	CPI  R30,LOW(0x64)
	BREQ _0x1E4
	CPI  R30,LOW(0x69)
	BRNE _0x1E5
_0x1E4:
	ORI  R16,LOW(4)
	RJMP _0x1E6
_0x1E5:
	CPI  R30,LOW(0x75)
	BRNE _0x1E7
_0x1E6:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x1E8
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x6B
	LDI  R17,LOW(10)
	RJMP _0x1E9
_0x1E8:
	__GETD1N 0x2710
	CALL SUBOPT_0x6B
	LDI  R17,LOW(5)
	RJMP _0x1E9
_0x1E7:
	CPI  R30,LOW(0x58)
	BRNE _0x1EB
	ORI  R16,LOW(8)
	RJMP _0x1EC
_0x1EB:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x22A
_0x1EC:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x1EE
	__GETD1N 0x10000000
	CALL SUBOPT_0x6B
	LDI  R17,LOW(8)
	RJMP _0x1E9
_0x1EE:
	__GETD1N 0x1000
	CALL SUBOPT_0x6B
	LDI  R17,LOW(4)
_0x1E9:
	CPI  R20,0
	BREQ _0x1EF
	ANDI R16,LOW(127)
	RJMP _0x1F0
_0x1EF:
	LDI  R20,LOW(1)
_0x1F0:
	SBRS R16,1
	RJMP _0x1F1
	CALL SUBOPT_0x6F
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	RJMP _0x29A
_0x1F1:
	SBRS R16,2
	RJMP _0x1F3
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x75
	CALL __CWD1
	RJMP _0x29A
_0x1F3:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x75
	CLR  R22
	CLR  R23
_0x29A:
	__PUTD1S 6
	SBRS R16,2
	RJMP _0x1F5
	CALL SUBOPT_0x76
	CALL __CPD20
	BRGE _0x1F6
	CALL SUBOPT_0x72
	CALL __ANEGD1
	CALL SUBOPT_0x71
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x1F6:
	LDD  R30,Y+19
	CPI  R30,0
	BREQ _0x1F7
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x1F8
_0x1F7:
	ANDI R16,LOW(251)
_0x1F8:
_0x1F5:
	MOV  R19,R20
_0x1E1:
	SBRC R16,0
	RJMP _0x1F9
_0x1FA:
	CP   R17,R21
	BRSH _0x1FD
	CP   R19,R21
	BRLO _0x1FE
_0x1FD:
	RJMP _0x1FC
_0x1FE:
	SBRS R16,7
	RJMP _0x1FF
	SBRS R16,2
	RJMP _0x200
	ANDI R16,LOW(251)
	LDD  R18,Y+19
	SUBI R17,LOW(1)
	RJMP _0x201
_0x200:
	LDI  R18,LOW(48)
_0x201:
	RJMP _0x202
_0x1FF:
	LDI  R18,LOW(32)
_0x202:
	CALL SUBOPT_0x6E
	SUBI R21,LOW(1)
	RJMP _0x1FA
_0x1FC:
_0x1F9:
_0x203:
	CP   R17,R20
	BRSH _0x205
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206
	CALL SUBOPT_0x77
	BREQ _0x207
	SUBI R21,LOW(1)
_0x207:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x206:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x70
	CPI  R21,0
	BREQ _0x208
	SUBI R21,LOW(1)
_0x208:
	SUBI R20,LOW(1)
	RJMP _0x203
_0x205:
	MOV  R19,R17
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x209
_0x20A:
	CPI  R19,0
	BREQ _0x20C
	SBRS R16,3
	RJMP _0x20D
	CALL SUBOPT_0x73
	LPM  R30,Z
	RJMP _0x29B
_0x20D:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x29B:
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G2
	CPI  R21,0
	BREQ _0x20F
	SUBI R21,LOW(1)
_0x20F:
	SUBI R19,LOW(1)
	RJMP _0x20A
_0x20C:
	RJMP _0x210
_0x209:
_0x212:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x76
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x214
	SBRS R16,3
	RJMP _0x215
	SUBI R18,-LOW(55)
	RJMP _0x216
_0x215:
	SUBI R18,-LOW(87)
_0x216:
	RJMP _0x217
_0x214:
	SUBI R18,-LOW(48)
_0x217:
	SBRC R16,4
	RJMP _0x219
	CPI  R18,49
	BRSH _0x21B
	CALL SUBOPT_0x69
	__CPD2N 0x1
	BRNE _0x21A
_0x21B:
	RJMP _0x21D
_0x21A:
	CP   R20,R19
	BRSH _0x29C
	CP   R21,R19
	BRLO _0x220
	SBRS R16,0
	RJMP _0x221
_0x220:
	RJMP _0x21F
_0x221:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x222
_0x29C:
	LDI  R18,LOW(48)
_0x21D:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x223
	CALL SUBOPT_0x77
	BREQ _0x224
	SUBI R21,LOW(1)
_0x224:
_0x223:
_0x222:
_0x219:
	CALL SUBOPT_0x6E
	CPI  R21,0
	BREQ _0x225
	SUBI R21,LOW(1)
_0x225:
_0x21F:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x67
	CALL SUBOPT_0x76
	CALL __MODD21U
	CALL SUBOPT_0x71
	LDD  R30,Y+18
	CALL SUBOPT_0x69
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x67
	CALL __CPD10
	BREQ _0x213
	RJMP _0x212
_0x213:
_0x210:
	SBRS R16,0
	RJMP _0x226
_0x227:
	CPI  R21,0
	BREQ _0x229
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x70
	RJMP _0x227
_0x229:
_0x226:
_0x22A:
_0x1C8:
_0x299:
	LDI  R17,LOW(0)
_0x1A9:
	RJMP _0x1A4
_0x1A6:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,29
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_p_S62:
	.BYTE 0x2

	.CSEG

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	CALL _lcd_strobe
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CBI  0x1B,3
	CBI  0x1B,2
	SBI  0x1B,1
	CBI  0x1B,0
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDS  R26,_hour
	LDS  R27,_hour+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(2999)
	LDI  R31,HIGH(2999)
	STS  _hour,R30
	STS  _hour+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R30,_hour
	LDS  R31,_hour+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	STS  _A0,R30
	STS  _A0+1,R31
	LDS  R26,_A0
	LDS  R27,_A0+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	STS  _V0,R30
	STS  _V0+1,R31
	LDS  R26,_A0
	LDS  R27,_A0+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	STS  _value,R30
	LDS  R26,_V0
	LDS  R27,_V0+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11:
	CALL __MULW12U
	LDS  R26,_A0
	LDS  R27,_A0+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A1,R26
	STS  _A1+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	STS  _V1,R30
	STS  _V1+1,R31
	LDS  R26,_A1
	LDS  R27,_A1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	__PUTB1MN _value,1
	LDS  R26,_V1
	LDS  R27,_V1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	CALL __MULB1W2U
	LDS  R26,_A1
	LDS  R27,_A1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A2,R26
	STS  _A2+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R26,_A2
	LDS  R27,_A2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	STS  _V2,R30
	STS  _V2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__PUTB1MN _value,2
	LDS  R26,_V2
	LDS  R27,_V2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	CALL __MULB1W2U
	LDS  R26,_A2
	LDS  R27,_A2+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _A3,R26
	STS  _A3+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	IN   R4,0
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_value
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _value,1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _value,2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _value,3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x20:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_value)
	SBCI R31,HIGH(-_value)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_value)
	SBCI R27,HIGH(-_value)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_value)
	SBCI R27,HIGH(-_value)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R31,0
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x28:
	STS  _hour,R30
	STS  _hour+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	RCALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2B:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,9
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2D:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	MOVW R26,R28
	ADIW R26,1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDS  R26,_A2
	LDS  R27,_A2+1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDS  R26,_A3
	LDS  R27,_A3+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	MOVW R26,R28
	ADIW R26,11
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDS  R26,_speed
	LDS  R27,_speed+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	STS  _speed,R30
	STS  _speed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	LDS  R30,_speed
	LDS  R31,_speed+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	STS  _speed,R30
	STS  _speed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x34
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x39:
	MOVW R26,R28
	ADIW R26,7
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	STS  _RedPwm,R30
	STS  _RedPwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDS  R30,_RedPwm
	STS  _redpwml,R30
	LDS  R30,_RedPwm+1
	STS  _redpwmh,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	STS  _GreenPwm,R30
	STS  _GreenPwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDS  R30,_GreenPwm
	STS  _greenpwml,R30
	LDS  R30,_GreenPwm+1
	STS  _greenpwmh,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	STS  _BluePwm,R30
	STS  _BluePwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDS  R30,_BluePwm
	STS  _bluepwml,R30
	LDS  R30,_BluePwm+1
	STS  _bluepwmh,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x41:
	ST   -Y,R31
	ST   -Y,R30
	CALL _Red
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x42:
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _Green
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x43:
	MOV  R30,R19
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _Blue
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	MOV  R30,R19
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x45:
	LDS  R26,_fxx
	LDS  R27,_fxx+1
	LDS  R24,_fxx+2
	LDS  R25,_fxx+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x46:
	STS  138,R30
	MOV  R30,R11
	RCALL SUBOPT_0x45
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	__GETD2N 0x4A609C00
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F800000
	CALL __SWAPD12
	CALL __SUBF12
	CALL __CFD1U
	STS  _ICR3top,R30
	STS  _ICR3top+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ICR3top,R30
	STS  _ICR3top+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x48:
	LDS  R30,_fxx
	LDS  R31,_fxx+1
	LDS  R22,_fxx+2
	LDS  R23,_fxx+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	CALL _lcd_clear
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4D:
	STS  _start_p,R30
	STS  _start_p+1,R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	STS  _fxx,R30
	STS  _fxx+1,R31
	STS  _fxx+2,R22
	STS  _fxx+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4E:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	STS  _fxx,R30
	STS  _fxx+1,R31
	STS  _fxx+2,R22
	STS  _fxx+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	CALL __DIVF21
	CALL __CFD1U
	STS  _tx,R30
	STS  _tx+1,R31
	STS  _tx+2,R22
	STS  _tx+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x55:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:165 WORDS
SUBOPT_0x57:
	ST   -Y,R10
	CALL _read_adc
	STS  _adc_in,R30
	STS  _adc_in+1,R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3DD1B717
	CALL __DIVF21
	STS  _indication,R30
	STS  _indication+1,R31
	STS  _indication+2,R22
	STS  _indication+3,R23
	LDS  R26,_indication
	LDS  R27,_indication+1
	LDS  R24,_indication+2
	LDS  R25,_indication+3
	__GETD1N 0x447A0000
	CALL __DIVF21
	STS  _tinf,R30
	STS  _tinf+1,R31
	STS  _tinf+2,R22
	STS  _tinf+3,R23
	LDS  R26,_tinf
	LDS  R27,_tinf+1
	LDS  R24,_tinf+2
	LDS  R25,_tinf+3
	__GETD1N 0x40000000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_vref
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __DIVF21
	__GETD2N 0x42C80000
	CALL __MULF12
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5A:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD1S 2
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	__GETD2S 2
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x60:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x4E
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x65:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x66:
	__GETD2S 4
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x67:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x68:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x69:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x4E
	CALL __DIVF21
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6B:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x6E:
	ST   -Y,R18
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6F:
	MOVW R26,R28
	SUBI R26,LOW(-(88))
	SBCI R27,HIGH(-(88))
	LD   R30,X+
	LD   R31,X+
	SBIW R30,4
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x70:
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x74:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	ADIW R30,4
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x77:
	ANDI R16,LOW(251)
	LDD  R30,Y+19
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(87))
	SBCI R31,HIGH(-(87))
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G2
	CPI  R21,0
	RET


	.DSEG
_310:
	.BYTE 0x50

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x398
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOV  R23,R31
	MOV  R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOV  R0,R30
	MOV  R1,R31
	MOV  R30,R22
	MOV  R31,R23
	RCALL __EEPROMWRW
	MOV  R30,R0
	MOV  R31,R1
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
