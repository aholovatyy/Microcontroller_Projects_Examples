
;CodeVisionAVR C Compiler V1.25.8 Standard
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.INCLUDE "microclimate_control_system.vec"
	.INCLUDE "microclimate_control_system.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

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
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V2.04.4a Advanced
;       4 Automatic Program Generator
;       5 © Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project : Автматизована система моніторингу та управління мікрокліматом
;       9 		  в тепличних господарствах на мікроконтролері AVR ATmega32
;      10 Version : Дипломна робота
;      11 Date    : 2016
;      12 Author  : (C) студент групи КНс-21 Калитовський Роман
;      13 
;      14 Chip type               : ATmega32
;      15 Program type            : Application
;      16 AVR Core Clock frequency: 8,000000 MHz
;      17 Memory model            : Small
;      18 External RAM size       : 0
;      19 Data Stack size         : 512
;      20 *****************************************************/
;      21 
;      22 #include <mega32.h>
;      23 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      24 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      25 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;      26 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;      27 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      28 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      29 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;      30 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;      31 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      32 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      33 	#endif
	#endif
;      34 #include <stdio.h>
;      35 #include <stdlib.h>
;      36 #include <delay.h>
;      37 #include <lcd.h> // функції LCD
;      38 #include <i2c.h>           // інтерфейс i2c - Bus functions
;      39 #include <ds1307.h>       // DS1307 Real Time Clock functions
;      40 #include "therm_ds18b20.h"
;      41 #include "shtxx.h"
;      42 
;      43 #asm
;      44     .equ __lcd_port=0x12 // порт піключення LCD, PORTD
    .equ __lcd_port=0x12 // порт піключення LCD, PORTD
;      45 #endasm
;      46 
;      47 #asm
;      48    .equ __i2c_port=0x15 ;PORTC   // DS1317 на порті С
   .equ __i2c_port=0x15 ;PORTC   // DS1317 на порті С
;      49    .equ __sda_bit=1              // SDA - на pin.1
   .equ __sda_bit=1              // SDA - на pin.1 
;      50    .equ __scl_bit=0              // SCL - на pin.0
   .equ __scl_bit=0              // SCL - на pin.0 
;      51 #endasm
;      52 
;      53 #pragma rl+
;      54 
;      55 //buttons MENU/ENTER, SELECT+, SELECT-
;      56 #define BTN_PORT PORTB
;      57 #define BTN_PIN PINB
;      58 #define BTN_DDR DDRB
;      59 #define MENU_ENTER_BTN 0
;      60 #define SELECT_PLUS_BTN 1
;      61 #define SELECT_MINUS_BTN 2
;      62 #define EXIT_BTN 3
;      63 
;      64 //air-conditioner
;      65 #define REL1_PORT PORTC
;      66 #define REL1_DDR DDRC
;      67 #define REL1 5
;      68 
;      69 //water pump
;      70 #define REL2_PORT PORTC
;      71 #define REL2_DDR DDRC
;      72 #define REL2 6
;      73 
;      74 //artificial light source
;      75 #define REL3_PORT PORTC
;      76 #define REL3_DDR DDRC
;      77 #define REL3 7
;      78 
;      79 #define WATERING_TIME_NUMBER 8
;      80 
;      81 typedef struct {
;      82    unsigned int min, max;
;      83 } values_range;
;      84 
;      85 typedef struct {
;      86   unsigned char hour, min, mode_on_off;
;      87 } watering_time;
;      88 
;      89 values_range temp = {23, 27}, hum = {50, 60}, soil = {0, 0}, light = {0, 0};
_temp:
_0temp:
	.BYTE 0x2
_1temp:
	.BYTE 0x2
_hum:
_0hum:
	.BYTE 0x2
_1hum:
	.BYTE 0x2
_soil:
_0soil:
	.BYTE 0x2
_1soil:
	.BYTE 0x2
_light:
_0light:
	.BYTE 0x2
_1light:
	.BYTE 0x2
;      90 watering_time w_time[WATERING_TIME_NUMBER] = {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0},
_w_time:
_0w_time:
	.BYTE 0x1
_1w_time:
	.BYTE 0x1
_2w_time:
	.BYTE 0x1
_3w_time:
	.BYTE 0x1
_4w_time:
	.BYTE 0x1
_5w_time:
	.BYTE 0x1
_6w_time:
	.BYTE 0x1
_7w_time:
	.BYTE 0x1
_8w_time:
	.BYTE 0x1
_9w_time:
	.BYTE 0x1
_Aw_time:
	.BYTE 0x1
_Bw_time:
	.BYTE 0x1
;      91             {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}};
_Cw_time:
	.BYTE 0x1
_Dw_time:
	.BYTE 0x1
_Ew_time:
	.BYTE 0x1
_Fw_time:
	.BYTE 0x1
_10w_time:
	.BYTE 0x1
_11w_time:
	.BYTE 0x1
_12w_time:
	.BYTE 0x1
_13w_time:
	.BYTE 0x1
_14w_time:
	.BYTE 0x1
_15w_time:
	.BYTE 0x1
_16w_time:
	.BYTE 0x1
_17w_time:
	.BYTE 0x1
;      92 unsigned char PREV_BTN_PIN = 0xff;
;      93 char lcd_buffer[33];
_lcd_buffer:
	.BYTE 0x21
;      94 
;      95 unsigned char get_key_status(unsigned char BTN_ID)
;      96 {

	.CSEG
_get_key_status:
;      97     return (!(BTN_PIN&(1<<BTN_ID)));
;	BTN_ID -> Y+0
	IN   R1,22
	CALL SUBOPT_0x0
	MOV  R26,R1
	CALL SUBOPT_0x1
	RJMP _0x23C
;      98 }
;      99 
;     100 unsigned char get_prev_key_status(unsigned char BTN_ID)
;     101 {
_get_prev_key_status:
;     102     return (!(PREV_BTN_PIN&(1<<BTN_ID)));
;	BTN_ID -> Y+0
	CALL SUBOPT_0x0
	MOV  R26,R5
	CALL SUBOPT_0x1
_0x23C:
	ADIW R28,1
	RET
;     103 }
;     104 
;     105 void set_time()
;     106 {
_set_time:
;     107     unsigned char i = 0, x = 3, ok = 0;
;     108     //char *str[] = {"hh","mm","ss","^^"};
;     109     char str[4][3] = {"гг","хх","сс","^^"};
;     110     unsigned char hour = 0, min = 0, sec = 0, wd = 0;
;     111     rtc_get_time(&hour,&min,&sec,&wd);
	SBIW R28,13
	LDI  R24,13
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x8*2)
	LDI  R31,HIGH(_0x8*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	i -> R17
;	x -> R16
;	ok -> R19
;	str -> Y+7
;	hour -> R18
;	min -> R21
;	sec -> R20
;	wd -> Y+6
	LDI  R16,3
	LDI  R17,0
	LDI  R18,0
	LDI  R19,0
	LDI  R20,0
	LDI  R21,0
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
	POP  R20
	POP  R21
	POP  R18
;     112     while(!ok)
_0x9:
	CPI  R19,0
	BREQ PC+3
	JMP _0xB
;     113     {
;     114         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x2
;     115         sprintf(lcd_buffer,"%u%u:%u%u:%u%u OK!", hour/10,hour%10, min/10,min%10, sec/10,sec%10);
	__POINTW1FN _0,0
	CALL SUBOPT_0x3
;     116         lcd_gotoxy(3,0);
;     117         lcd_puts(lcd_buffer);
;     118         lcd_gotoxy(x,1);
	ST   -Y,R16
	CALL SUBOPT_0x4
;     119         lcd_puts(str[i]);
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x5
;     120         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0xC
;     121         {
;     122             //if (!get_prev_key_status(SELECT_PLUS_BTN))
;     123             //{
;     124             switch(i)
	CALL SUBOPT_0x6
;     125             {
;     126                 case 0:
	BRNE _0x10
;     127                   if (hour == 23) hour = 0;
	CPI  R18,23
	BRNE _0x11
	LDI  R18,LOW(0)
;     128                   else hour++;
	RJMP _0x12
_0x11:
	SUBI R18,-1
;     129                 break;
_0x12:
	RJMP _0xF
;     130                 case 1:
_0x10:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x13
;     131                   if (min == 59) min = 0;
	CPI  R21,59
	BRNE _0x14
	LDI  R21,LOW(0)
;     132                   else min++;
	RJMP _0x15
_0x14:
	SUBI R21,-1
;     133                 break;
_0x15:
	RJMP _0xF
;     134                 case 2:
_0x13:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16
;     135                   if (sec == 59) sec = 0;
	CPI  R20,59
	BRNE _0x17
	LDI  R20,LOW(0)
;     136                   else sec++;
	RJMP _0x18
_0x17:
	SUBI R20,-1
;     137                 break;
_0x18:
	RJMP _0xF
;     138                 case 3:
_0x16:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xF
;     139                   ok = 1;
	LDI  R19,LOW(1)
;     140                 break;
;     141             }
_0xF:
;     142             //}
;     143             delay_ms(300);
	CALL SUBOPT_0x7
;     144         }
;     145         if (get_key_status(SELECT_MINUS_BTN))
_0xC:
	CALL SUBOPT_0x8
	BREQ _0x1A
;     146         {
;     147             //if (!get_prev_key_status(SELECT_MINUS_BTN))
;     148             //{
;     149             switch (i)
	CALL SUBOPT_0x6
;     150             {
;     151                 case 0:
	BRNE _0x1E
;     152                   if (hour == 0) hour = 23;
	CPI  R18,0
	BRNE _0x1F
	LDI  R18,LOW(23)
;     153                   else hour--;
	RJMP _0x20
_0x1F:
	SUBI R18,1
;     154                 break;
_0x20:
	RJMP _0x1D
;     155                 case 1:
_0x1E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x21
;     156                   if (min == 0) min = 59;
	CPI  R21,0
	BRNE _0x22
	LDI  R21,LOW(59)
;     157                   else min--;
	RJMP _0x23
_0x22:
	SUBI R21,1
;     158                 break;
_0x23:
	RJMP _0x1D
;     159                 case 2:
_0x21:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24
;     160                   if (sec == 0) sec = 59;
	CPI  R20,0
	BRNE _0x25
	LDI  R20,LOW(59)
;     161                   else sec--;
	RJMP _0x26
_0x25:
	SUBI R20,1
;     162                 break;
_0x26:
	RJMP _0x1D
;     163                 case 3:
_0x24:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1D
;     164                   ok = 1;
	LDI  R19,LOW(1)
;     165                 break;
;     166             }
_0x1D:
;     167             // }
;     168            delay_ms(300);
	CALL SUBOPT_0x7
;     169         }
;     170         if(get_key_status(MENU_ENTER_BTN))
_0x1A:
	CALL SUBOPT_0x9
	BREQ _0x28
;     171         {
;     172             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BRNE _0x29
;     173             {
;     174                 lcd_gotoxy(x,1);
	ST   -Y,R16
	CALL SUBOPT_0x4
;     175                 lcd_putsf("  ");
	CALL SUBOPT_0xB
;     176                 if (i == 3)
	CPI  R17,3
	BRNE _0x2A
;     177                 {
;     178                     i = 0;
	LDI  R17,LOW(0)
;     179                     x = 3;
	LDI  R16,LOW(3)
;     180                 }
;     181                 else
	RJMP _0x2B
_0x2A:
;     182                 {
;     183                   x += 3;
	SUBI R16,-LOW(3)
;     184                   i++;
	SUBI R17,-1
;     185                 }
_0x2B:
;     186            }
;     187        }
_0x29:
;     188        if(get_key_status(EXIT_BTN))
_0x28:
	CALL SUBOPT_0xC
	BREQ _0x2C
;     189          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xD
	BRNE _0x2D
;     190          {
;     191             delay_ms(300);
	CALL SUBOPT_0x7
;     192             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     193             return;
	RJMP _0x23B
;     194          }
;     195     }
_0x2D:
_0x2C:
	RJMP _0x9
_0xB:
;     196   rtc_set_time(hour, min, sec, wd);
	ST   -Y,R18
	ST   -Y,R21
	ST   -Y,R20
	LDD  R30,Y+9
	ST   -Y,R30
	CALL _rtc_set_time
;     197 }
_0x23B:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
;     198 
;     199 void set_date(void)
;     200 {
_set_date:
;     201     unsigned char ok = 0;
;     202     //char str[4][3]={"dd", "mm", "yy", "^^"};
;     203     char str[4][3]={"дд", "мм", "рр", "^^"};
;     204     unsigned char i = 0, x = 3;
;     205     unsigned char date, month, year;
;     206     rtc_get_date(&date,&month,&year);
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2E*2)
	LDI  R31,HIGH(_0x2E*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	ok -> R17
;	str -> Y+6
;	i -> R16
;	x -> R19
;	date -> R18
;	month -> R21
;	year -> R20
	LDI  R16,0
	LDI  R17,0
	LDI  R19,3
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL _rtc_get_date
	POP  R20
	POP  R21
	POP  R18
;     207     lcd_clear();
	CALL _lcd_clear
;     208     while(!ok)
_0x2F:
	CPI  R17,0
	BREQ PC+3
	JMP _0x31
;     209     {
;     210         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x2
;     211         sprintf(lcd_buffer, "%u%u/%u%u/%u%u OK!", date/10,date%10, month/10,month%10, year/10,year%10);
	__POINTW1FN _0,22
	CALL SUBOPT_0x3
;     212         lcd_gotoxy(3, 0);
;     213         lcd_puts(lcd_buffer);
;     214         lcd_gotoxy(x, 1);
	ST   -Y,R19
	CALL SUBOPT_0x4
;     215         lcd_puts(str[i]);
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x5
;     216         if (get_key_status(SELECT_PLUS_BTN))
	BREQ _0x32
;     217         {
;     218            if (get_key_status(SELECT_PLUS_BTN))
	CALL SUBOPT_0xE
	BREQ _0x33
;     219               if (!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(1)
	CALL SUBOPT_0xF
	BRNE _0x34
;     220               {
;     221                  switch (i)
	MOV  R30,R16
	CALL SUBOPT_0x10
;     222                  {
;     223                     case 0:
	BRNE _0x38
;     224                       if (date == 31) date = 0;
	CPI  R18,31
	BRNE _0x39
	LDI  R18,LOW(0)
;     225                       else date++;
	RJMP _0x3A
_0x39:
	SUBI R18,-1
;     226                     break;
_0x3A:
	RJMP _0x37
;     227                     case 1:
_0x38:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3B
;     228                       if (month == 12) month = 0;
	CPI  R21,12
	BRNE _0x3C
	LDI  R21,LOW(0)
;     229                       else month++;
	RJMP _0x3D
_0x3C:
	SUBI R21,-1
;     230                     break;
_0x3D:
	RJMP _0x37
;     231                     case 2:
_0x3B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3E
;     232                        if (year == 99) year = 0;
	CPI  R20,99
	BRNE _0x3F
	LDI  R20,LOW(0)
;     233                        else year++;
	RJMP _0x40
_0x3F:
	SUBI R20,-1
;     234                     break;
_0x40:
	RJMP _0x37
;     235                     case 3:
_0x3E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x37
;     236                       ok = 1;
	LDI  R17,LOW(1)
;     237                     break;
;     238                   }
_0x37:
;     239                }
;     240         }
_0x34:
_0x33:
;     241         if (get_key_status(SELECT_MINUS_BTN))
_0x32:
	CALL SUBOPT_0x8
	BREQ _0x42
;     242         {
;     243             if (get_key_status(SELECT_MINUS_BTN))
	CALL SUBOPT_0x8
	BREQ _0x43
;     244               if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(2)
	CALL SUBOPT_0xF
	BRNE _0x44
;     245               {
;     246                 switch (i)
	MOV  R30,R16
	CALL SUBOPT_0x10
;     247                 {
;     248                     case 0:
	BRNE _0x48
;     249                       if (date == 0) date = 31;
	CPI  R18,0
	BRNE _0x49
	LDI  R18,LOW(31)
;     250                       else date--;
	RJMP _0x4A
_0x49:
	SUBI R18,1
;     251                     break;
_0x4A:
	RJMP _0x47
;     252                     case 1:
_0x48:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4B
;     253                        if (month == 0) month = 12;
	CPI  R21,0
	BRNE _0x4C
	LDI  R21,LOW(12)
;     254                        else month--;
	RJMP _0x4D
_0x4C:
	SUBI R21,1
;     255                     break;
_0x4D:
	RJMP _0x47
;     256                     case 2:
_0x4B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4E
;     257                        if (year == 0) year = 99;
	CPI  R20,0
	BRNE _0x4F
	LDI  R20,LOW(99)
;     258                        else year--;
	RJMP _0x50
_0x4F:
	SUBI R20,1
;     259                     break;
_0x50:
	RJMP _0x47
;     260                     case 3:
_0x4E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x47
;     261                       ok = 1;
	LDI  R17,LOW(1)
;     262                     break;
;     263                 }
_0x47:
;     264             }
;     265         }
_0x44:
_0x43:
;     266         if (get_key_status(MENU_ENTER_BTN))
_0x42:
	CALL SUBOPT_0x9
	BREQ _0x52
;     267         {
;     268             if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BRNE _0x53
;     269             {
;     270                 lcd_gotoxy(x, 1);
	ST   -Y,R19
	CALL SUBOPT_0x4
;     271                 lcd_putsf("  ");
	CALL SUBOPT_0xB
;     272                 if (i == 3)
	CPI  R16,3
	BRNE _0x54
;     273                 {
;     274                     i = 0;
	LDI  R16,LOW(0)
;     275                     x = 3;
	LDI  R19,LOW(3)
;     276                 }
;     277                 else
	RJMP _0x55
_0x54:
;     278                 {
;     279                     i++;
	SUBI R16,-1
;     280                     x += 3;
	SUBI R19,-LOW(3)
;     281                 }
_0x55:
;     282             }
;     283        }
_0x53:
;     284        if (get_key_status(EXIT_BTN))
_0x52:
	CALL SUBOPT_0xC
	BREQ _0x56
;     285          if (!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xD
	BRNE _0x57
;     286             {
;     287                delay_ms(300);
	CALL SUBOPT_0x7
;     288                PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     289                return;
	RJMP _0x23A
;     290             }
;     291  }
_0x57:
_0x56:
	RJMP _0x2F
_0x31:
;     292  rtc_set_date(date, month, year);
	ST   -Y,R18
	ST   -Y,R21
	ST   -Y,R20
	CALL _rtc_set_date
;     293 }
_0x23A:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;     294 
;     295 void set_values(unsigned char j, values_range *p)
;     296 {
_set_values:
;     297     char str[3][4]={"<=","<=","OK!"};
;     298     unsigned char i = 0, xpos[] = {14, 14, 13}, ypos[] = {0,1,1};
;     299     unsigned char ok = 0;
;     300     values_range v[4] = {{0,99},{10,100},{0,100},{300,1000}};
;     301     values_range tmp;
;     302     tmp = *p;
	SBIW R28,38
	LDI  R24,34
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x58*2)
	LDI  R31,HIGH(_0x58*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	j -> Y+42
;	*p -> Y+40
;	str -> Y+28
;	i -> R17
;	xpos -> Y+25
;	ypos -> Y+22
;	ok -> R16
;	v -> Y+6
;	tmp -> Y+2
	LDI  R16,0
	LDI  R17,0
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	MOVW R26,R28
	ADIW R26,2
	LDI  R24,4
	CALL __COPYMML
;     303 
;     304     lcd_clear();
	CALL _lcd_clear
;     305 
;     306     while(!ok)
_0x59:
	CPI  R16,0
	BREQ PC+3
	JMP _0x5B
;     307     {
;     308         PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     309         switch (j)
	LDD  R30,Y+42
	CALL SUBOPT_0x10
;     310         {
;     311             case 0:
	BRNE _0x5F
;     312               sprintf(lcd_buffer,"Tmin: %u%cC \nTmax: %u%cC ", tmp.min, 0xdf, tmp.max, 0xdf);
	CALL SUBOPT_0x11
	__POINTW1FN _0,41
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x13
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
;     313             break;
	RJMP _0x5E
;     314             case 1:
_0x5F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60
;     315               sprintf(lcd_buffer,"Hmin: %u%% \nHmax: %u%% ", tmp.min, tmp.max);
	CALL SUBOPT_0x11
	__POINTW1FN _0,67
	RJMP _0x23D
;     316             break;
;     317             case 2:
_0x60:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x61
;     318               sprintf(lcd_buffer,"Smin: %u%% \nSmax: %u%% ", tmp.min, tmp.max);
	CALL SUBOPT_0x11
	__POINTW1FN _0,91
	RJMP _0x23D
;     319             break;
;     320             case 3:
_0x61:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5E
;     321               sprintf(lcd_buffer,"Imin: %u lx \nImax: %u lx ", tmp.min, tmp.max);
	CALL SUBOPT_0x11
	__POINTW1FN _0,115
_0x23D:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x14
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;     322             break;
;     323         }
_0x5E:
;     324         lcd_gotoxy(0,0);
	CALL SUBOPT_0x15
;     325         lcd_puts(lcd_buffer);
	CALL SUBOPT_0x16
;     326         lcd_gotoxy(xpos[i],ypos[i]);
	CALL SUBOPT_0x17
;     327         lcd_puts(str[i]);
	CALL SUBOPT_0x18
	MOVW R26,R28
	ADIW R26,28
	CALL __LSLW2
	CALL SUBOPT_0x5
;     328 
;     329         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0x63
;     330         {
;     331             //if (!get_prev_key_status(SELECT_PLUS_BTN))
;     332             {
;     333                 switch(i)
	CALL SUBOPT_0x6
;     334                 {
;     335                     case 0:
	BRNE _0x67
;     336                       if (tmp.min < tmp.max) tmp.min++;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x68
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
;     337                     break;
_0x68:
	RJMP _0x66
;     338                     case 1:
_0x67:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
;     339                       if (tmp.max < v[j].max) tmp.max++;
	CALL SUBOPT_0x19
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x1A
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x6A
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
;     340                     break;
_0x6A:
	RJMP _0x66
;     341                     case 2:
_0x69:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x66
;     342                       ok = 1;
	LDI  R16,LOW(1)
;     343                     break;
;     344                 }
_0x66:
;     345             }
;     346             delay_ms(300);
	CALL SUBOPT_0x7
;     347         }
;     348         if (get_key_status(SELECT_MINUS_BTN))
_0x63:
	CALL SUBOPT_0x8
	BREQ _0x6C
;     349         {
;     350             //if (!get_prev_key_status(SELECT_MINUS_BTN))
;     351             {
;     352                 switch (i) {
	CALL SUBOPT_0x6
;     353                    case 0:
	BRNE _0x70
;     354                      if (tmp.min > v[j].min) tmp.min--;
	CALL SUBOPT_0x19
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x1A
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x71
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
;     355                      break;
_0x71:
	RJMP _0x6F
;     356                    case 1:
_0x70:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x72
;     357                      if (tmp.max > tmp.min) tmp.max--;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x73
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
;     358                    break;
_0x73:
	RJMP _0x6F
;     359                    case 2:
_0x72:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6F
;     360                      ok = 1;
	LDI  R16,LOW(1)
;     361                    break;
;     362                 }
_0x6F:
;     363 
;     364          }
;     365          delay_ms(300);
	CALL SUBOPT_0x7
;     366      }
;     367      if(get_key_status(MENU_ENTER_BTN))
_0x6C:
	CALL SUBOPT_0x9
	BREQ _0x75
;     368      {
;     369        if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BRNE _0x76
;     370        {
;     371           lcd_gotoxy(xpos[i],ypos[i]);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x17
;     372           lcd_putsf("  ");
	CALL SUBOPT_0xB
;     373           if (i==2)
	CPI  R17,2
	BRNE _0x77
;     374           {
;     375              i=0;
	LDI  R17,LOW(0)
;     376              lcd_putsf(" ");
	__POINTW1FN _0,20
	CALL SUBOPT_0x1B
;     377           }
;     378           else
	RJMP _0x78
_0x77:
;     379             i++;
	SUBI R17,-1
;     380          }
_0x78:
;     381        }
_0x76:
;     382        if(get_key_status(EXIT_BTN))
_0x75:
	CALL SUBOPT_0xC
	BREQ _0x79
;     383          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xD
	BRNE _0x7A
;     384          {
;     385             delay_ms(300);
	CALL SUBOPT_0x7
;     386             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     387             return;
	RJMP _0x239
;     388          }
;     389     }
_0x7A:
_0x79:
	RJMP _0x59
_0x5B:
;     390     *p = tmp;
	MOVW R30,R28
	ADIW R30,2
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	LDI  R24,4
	CALL __COPYMML
;     391 }
_0x239:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,43
	RET
;     392 
;     393 void set_watering()
;     394 {
_set_watering:
;     395     unsigned char i = 0, j = 0, x = 0, ok = 0;
;     396     //char *str[] = {"pr", "hh","mm","^^", "^^"};
;     397     char *str[5] = {"пр", "гг","хх","^^", "^^"};
;     398     unsigned char hour, min, mode_on_off;
;     399     char *s_mode[] = {"OFF", "ON "};
;     400 
;     401     hour = w_time[j].hour;
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x7D*2)
	LDI  R31,HIGH(_0x7D*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	i -> R17
;	j -> R16
;	x -> R19
;	ok -> R18
;	*str -> Y+11
;	hour -> R21
;	min -> R20
;	mode_on_off -> Y+10
;	*s_mode -> Y+6
	LDI  R16,0
	LDI  R17,0
	LDI  R18,0
	LDI  R19,0
	CALL SUBOPT_0x1C
;     402     min = w_time[j].min;
;     403     mode_on_off = w_time[j].mode_on_off;
;     404 
;     405     while(!ok)
_0x7E:
	CPI  R18,0
	BREQ PC+3
	JMP _0x80
;     406     {
;     407         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x2
;     408         sprintf(lcd_buffer,"#%u %u%u:%u%u %s OK!", j+1, hour/10,hour%10, min/10,min%10, s_mode[mode_on_off]);
	__POINTW1FN _0,161
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x1D
	CALL __DIVB21U
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOV  R26,R20
	CALL SUBOPT_0x1F
	MOV  R26,R20
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1E
	LDD  R30,Y+34
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x14
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
;     409         lcd_gotoxy(0,0);
	CALL SUBOPT_0x15
;     410         lcd_puts(lcd_buffer);
	CALL _lcd_puts
;     411         lcd_gotoxy(x,1);
	ST   -Y,R19
	CALL SUBOPT_0x4
;     412         lcd_puts(str[i]);
	CALL SUBOPT_0x18
	MOVW R26,R28
	ADIW R26,11
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;     413         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0x81
;     414         {
;     415             //if (!get_prev_key_status(SELECT_PLUS_BTN))
;     416             //{
;     417             switch(i)
	CALL SUBOPT_0x6
;     418             {
;     419                 case 0:
	BRNE _0x85
;     420                   if (j < WATERING_TIME_NUMBER - 1) j++;
	CPI  R16,7
	BRSH _0x86
	SUBI R16,-1
;     421                   else j = 0;
	RJMP _0x87
_0x86:
	LDI  R16,LOW(0)
;     422                   hour = w_time[j].hour;
_0x87:
	CALL SUBOPT_0x1C
;     423                   min = w_time[j].min;
;     424                   mode_on_off = w_time[j].mode_on_off;
;     425                   break;
	RJMP _0x84
;     426                 case 1:
_0x85:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x88
;     427                   if (hour == 23) hour = 0;
	CPI  R21,23
	BRNE _0x89
	LDI  R21,LOW(0)
;     428                   else hour++;
	RJMP _0x8A
_0x89:
	SUBI R21,-1
;     429                 break;
_0x8A:
	RJMP _0x84
;     430                 case 2:
_0x88:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8B
;     431                   if (min == 59) min = 0;
	CPI  R20,59
	BRNE _0x8C
	LDI  R20,LOW(0)
;     432                   else min++;
	RJMP _0x8D
_0x8C:
	SUBI R20,-1
;     433                 break;
_0x8D:
	RJMP _0x84
;     434                 case 3:
_0x8B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8E
;     435                   if (mode_on_off) mode_on_off = 0;
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x8F
	LDI  R30,LOW(0)
	RJMP _0x23E
;     436                   else mode_on_off = 1;
_0x8F:
	LDI  R30,LOW(1)
_0x23E:
	STD  Y+10,R30
;     437                 break;
	RJMP _0x84
;     438                 case 4:
_0x8E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x84
;     439                   ok = 1;
	LDI  R18,LOW(1)
;     440                 break;
;     441             }
_0x84:
;     442             //}
;     443             delay_ms(300);
	CALL SUBOPT_0x7
;     444         }
;     445         if (get_key_status(SELECT_MINUS_BTN))
_0x81:
	CALL SUBOPT_0x8
	BREQ _0x92
;     446         {
;     447             //if (!get_prev_key_status(SELECT_MINUS_BTN))
;     448             //{
;     449             switch (i)
	CALL SUBOPT_0x6
;     450             {
;     451                 case 0:
	BRNE _0x96
;     452                   if (j > 0) j--;
	CPI  R16,1
	BRLO _0x97
	SUBI R16,1
;     453                   else j = WATERING_TIME_NUMBER;
	RJMP _0x98
_0x97:
	LDI  R16,LOW(8)
;     454                   hour = w_time[j].hour;
_0x98:
	CALL SUBOPT_0x1C
;     455                   min = w_time[j].min;
;     456                   mode_on_off = w_time[j].mode_on_off;
;     457                   break;
	RJMP _0x95
;     458                 case 1:
_0x96:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x99
;     459                   if (hour == 0) hour = 23;
	CPI  R21,0
	BRNE _0x9A
	LDI  R21,LOW(23)
;     460                   else hour--;
	RJMP _0x9B
_0x9A:
	SUBI R21,1
;     461                 break;
_0x9B:
	RJMP _0x95
;     462                 case 2:
_0x99:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x9C
;     463                   if (min == 0) min = 59;
	CPI  R20,0
	BRNE _0x9D
	LDI  R20,LOW(59)
;     464                   else min--;
	RJMP _0x9E
_0x9D:
	SUBI R20,1
;     465                 break;
_0x9E:
	RJMP _0x95
;     466                 case 3:
_0x9C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9F
;     467                   if (!mode_on_off) mode_on_off = 1;
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0xA0
	LDI  R30,LOW(1)
	RJMP _0x23F
;     468                   else mode_on_off = 0;
_0xA0:
	LDI  R30,LOW(0)
_0x23F:
	STD  Y+10,R30
;     469                 break;
	RJMP _0x95
;     470                 case 4:
_0x9F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x95
;     471                   ok = 1;
	LDI  R18,LOW(1)
;     472                 break;
;     473             }
_0x95:
;     474             // }
;     475            delay_ms(300);
	CALL SUBOPT_0x7
;     476         }
;     477         if(get_key_status(MENU_ENTER_BTN))
_0x92:
	CALL SUBOPT_0x9
	BREQ _0xA3
;     478         {
;     479             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BRNE _0xA4
;     480             {
;     481                 lcd_gotoxy(x,1);
	ST   -Y,R19
	CALL SUBOPT_0x4
;     482                 lcd_putsf("  ");
	CALL SUBOPT_0xB
;     483                 if (i == 4)
	CPI  R17,4
	BRNE _0xA5
;     484                 {
;     485                     i = 0;
	LDI  R17,LOW(0)
;     486                     x = 0;
	LDI  R19,LOW(0)
;     487                 }
;     488                 else
	RJMP _0xA6
_0xA5:
;     489                 {
;     490                   if (x == 9)
	CPI  R19,9
	BRNE _0xA7
;     491                     x += 4;
	SUBI R19,-LOW(4)
;     492                   else x += 3;
	RJMP _0xA8
_0xA7:
	SUBI R19,-LOW(3)
;     493                   i++;
_0xA8:
	SUBI R17,-1
;     494                 }
_0xA6:
;     495            }
;     496        }
_0xA4:
;     497        if(get_key_status(EXIT_BTN))
_0xA3:
	CALL SUBOPT_0xC
	BREQ _0xA9
;     498          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xD
	BRNE _0xAA
;     499          {
;     500             delay_ms(300);
	CALL SUBOPT_0x7
;     501             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     502             return;
	RJMP _0x238
;     503          }
;     504     }
_0xAA:
_0xA9:
	RJMP _0x7E
_0x80:
;     505     w_time[j].hour = hour;
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	SUBI R30,LOW(-_w_time)
	SBCI R31,HIGH(-_w_time)
	ST   Z,R21
;     506     w_time[j].min = min;
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	__ADDW1MN _w_time,1
	ST   Z,R20
;     507     w_time[j].mode_on_off = mode_on_off;
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	__ADDW1MN _w_time,2
	LDD  R26,Y+10
	STD  Z+0,R26
;     508 }
_0x238:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
;     509 
;     510 
;     511 void main_menu(void)
;     512 {
_main_menu:
;     513     /*char *menu_items[8]={"DATE", "TIME", "WATERING", "TEMPERATURE",
;     514         "HUMIDITY", "SOIL MOISTURE", "LIGHT INTENSITY","EXIT"};
;     515     int pos[] = {6, 6, 4, 2, 4, 2, 0, 6}; */
;     516     char *menu_items[8]={"ДАТА", "ЧАС", "ПОЛИВ", "ТЕМПЕРАТУРА",
;     517         "ВОЛОГIСТЬ", "ВОЛОГIСТЬ ГРУНТУ", "ОСВIТЛЕННЯ","ВИХIД"};
;     518     int pos[] = {6, 6, 5, 2, 4, 0, 3, 5};
;     519     //char title[] = "** Main Menu **";
;     520     char title[] = "* Головне Меню *";
;     521     unsigned char i = 0;
;     522 
;     523     while(1)
	SBIW R28,49
	LDI  R24,49
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xAC*2)
	LDI  R31,HIGH(_0xAC*2)
	CALL __INITLOCB
	ST   -Y,R17
;	*menu_items -> Y+34
;	pos -> Y+18
;	title -> Y+1
;	i -> R17
	LDI  R17,0
_0xAD:
;     524     {
;     525         PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
;     526         lcd_gotoxy(0,0);
	CALL SUBOPT_0x22
	CALL _lcd_gotoxy
;     527         lcd_puts(title);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
;     528         lcd_gotoxy(pos[i],1);
	MOVW R26,R28
	ADIW R26,18
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x4
;     529         lcd_puts(menu_items[i]);
	CALL SUBOPT_0x18
	MOVW R26,R28
	ADIW R26,34
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;     530         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0xB0
;     531         {
;     532             if(!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(1)
	CALL SUBOPT_0xF
	BRNE _0xB1
;     533             {
;     534                 if(i == 7) i = 0;
	CPI  R17,7
	BRNE _0xB2
	LDI  R17,LOW(0)
;     535                 else i++;
	RJMP _0xB3
_0xB2:
	SUBI R17,-1
;     536                 lcd_clear();
_0xB3:
	CALL _lcd_clear
;     537             }
;     538         }
_0xB1:
;     539         if(get_key_status(SELECT_MINUS_BTN))
_0xB0:
	CALL SUBOPT_0x8
	BREQ _0xB4
;     540         {
;     541             if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(2)
	CALL SUBOPT_0xF
	BRNE _0xB5
;     542             {
;     543                 if (i == 0) i = 7;
	CPI  R17,0
	BRNE _0xB6
	LDI  R17,LOW(7)
;     544                 else i--;
	RJMP _0xB7
_0xB6:
	SUBI R17,1
;     545                 lcd_clear();
_0xB7:
	CALL _lcd_clear
;     546             }
;     547         }
_0xB5:
;     548         if(get_key_status(MENU_ENTER_BTN))
_0xB4:
	CALL SUBOPT_0x9
	BRNE PC+3
	JMP _0xB8
;     549             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BREQ PC+3
	JMP _0xB9
;     550             {
;     551                 lcd_clear();
	CALL _lcd_clear
;     552                 switch(i)
	CALL SUBOPT_0x6
;     553                 {
;     554                     case 0: set_date(); break; // date
	BRNE _0xBD
	CALL _set_date
	RJMP _0xBC
;     555                     case 1: set_time(); break; // time
_0xBD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBE
	CALL _set_time
	RJMP _0xBC
;     556                     case 2: set_watering(); break; // watering
_0xBE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBF
	CALL _set_watering
	RJMP _0xBC
;     557                     case 3: set_values(0, &temp); break; // temperature
_0xBF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	CALL SUBOPT_0x23
	RJMP _0xBC
;     558                     case 4: set_values(1, &hum); break; // humidity
_0xC0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC1
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_hum)
	LDI  R31,HIGH(_hum)
	CALL SUBOPT_0x23
	RJMP _0xBC
;     559                     case 5: set_values(2,&soil); break; // soil moisture
_0xC1:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC2
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(_soil)
	LDI  R31,HIGH(_soil)
	CALL SUBOPT_0x23
	RJMP _0xBC
;     560                     case 6: set_values(3, &light); break;
_0xC2:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC3
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(_light)
	LDI  R31,HIGH(_light)
	CALL SUBOPT_0x23
	RJMP _0xBC
;     561                     case 7: return;
_0xC3:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xC5
	LDD  R17,Y+0
	RJMP _0x237
;     562                     default: break;
_0xC5:
;     563             }
_0xBC:
;     564             lcd_clear();
	CALL _lcd_clear
;     565       }
;     566       if (get_key_status(EXIT_BTN))
_0xB9:
_0xB8:
	CALL SUBOPT_0xC
	BREQ _0xC6
;     567         if (!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xD
	BRNE _0xC7
;     568         {
;     569            return;
	LDD  R17,Y+0
	RJMP _0x237
;     570         }
;     571 
;     572     }
_0xC7:
_0xC6:
	RJMP _0xAD
;     573 }
_0x237:
	ADIW R28,50
	RET
;     574 
;     575 void main(void)
;     576 {
_main:
;     577   /* program that shows how to use SHTXX, DS18B20 functions and to display information on LCD */
;     578 
;     579   value humi_val = {0}, temp_val = {0};
;     580   float temp_ds = 0, dew_point = 0;
;     581   unsigned int soil_val = 0, light_val = 0;
;     582   unsigned char error, checksum, value = 1;
;     583   unsigned int vin, start;
;     584   unsigned char hour, min, sec, wd;
;     585   //unsigned char date, month, year;
;     586   //char *weekdays[7]={"Sun","Mon","Tue","Wed","Thr","Fri","Sat"};
;     587   char *weekdays[7]={"Нд.","Пн.","Вт.","Ср.","Чт.","Пт.","Сб."};
;     588   //char *monthes[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
;     589   //char *monthes[]={"Сiч.","Лют.","Бер.","Квiт.","Трав.","Черв.","Лип.","Серп.","Вер.","Жовт.","Лист.","Груд."};
;     590 
;     591   //initADC();
;     592   sht_init();
	SBIW R28,39
	LDI  R24,39
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xC9*2)
	LDI  R31,HIGH(_0xC9*2)
	CALL __INITLOCB
;	humi_val -> Y+35
;	temp_val -> Y+31
;	temp_ds -> Y+27
;	dew_point -> Y+23
;	soil_val -> R16,R17
;	light_val -> R18,R19
;	error -> R21
;	checksum -> R20
;	value -> Y+22
;	vin -> Y+20
;	start -> Y+18
;	hour -> Y+17
;	min -> Y+16
;	sec -> Y+15
;	wd -> Y+14
;	*weekdays -> Y+0
	LDI  R16,0
	LDI  R17,0
	LDI  R18,0
	LDI  R19,0
	CALL _sht_init
;     593   s_connectionreset();
	CALL _s_connectionreset
;     594   therm_init(-55, 125, THERM_9BIT_RES);
	LDI  R30,LOW(201)
	ST   -Y,R30
	LDI  R30,LOW(125)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _therm_init
;     595   i2c_init();  // I2C Bus initialization
	CALL _i2c_init
;     596   // DS1307 Real Time Clock initialization
;     597   rtc_init(0,1,0);  // Square wave output on pin SQW/OUT: Off // SQW/OUT pin state: 0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _rtc_init
;     598   start = rtc_read(0)&0x80;
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _rtc_read
	ANDI R30,LOW(0x80)
	LDI  R31,0
	STD  Y+18,R30
	STD  Y+18+1,R31
;     599   if (start)
	SBIW R30,0
	BREQ _0xCA
;     600     rtc_write(0,0x00);  //start clock
	CALL SUBOPT_0x22
	CALL _rtc_write
;     601 
;     602   //LCD initialization
;     603   lcd_init(16);
_0xCA:
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;     604   lcd_clear();
	CALL _lcd_clear
;     605   /*lcd_gotoxy(2,0);
;     606   lcd_putsf("Microclimate");
;     607   lcd_gotoxy(1,1);
;     608   lcd_putsf("Control System"); */
;     609   lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
;     610   lcd_putsf("СИСТЕМА");
	__POINTW1FN _0,281
	CALL SUBOPT_0x1B
;     611   lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x4
;     612   lcd_putsf("УПРАВЛIННЯ");
	__POINTW1FN _0,289
	CALL SUBOPT_0x1B
;     613   delay_ms(2000);
	CALL SUBOPT_0x24
;     614   lcd_clear();
;     615   lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
;     616   lcd_putsf("МIКРОКЛIМАТОМ");
	__POINTW1FN _0,300
	CALL SUBOPT_0x1B
;     617   lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x4
;     618   lcd_putsf("В ТЕПЛИЦI");
	__POINTW1FN _0,314
	CALL SUBOPT_0x1B
;     619   delay_ms(2000);
	CALL SUBOPT_0x24
;     620   lcd_clear();
;     621   lcd_gotoxy(0,0);
	CALL SUBOPT_0x22
	CALL _lcd_gotoxy
;     622   //lcd_putsf("Roman Kalytovsky");
;     623   lcd_putsf("Р. Калитовський");
	__POINTW1FN _0,324
	CALL SUBOPT_0x1B
;     624   lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x4
;     625   lcd_putsf("(C) 2016");
	__POINTW1FN _0,340
	CALL SUBOPT_0x1B
;     626   delay_ms(2000);
	CALL SUBOPT_0x24
;     627   lcd_clear();
;     628  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit
;     629   s_write_statusreg(&value);
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	CALL _s_write_statusreg
;     630   s_read_statusreg(&value, &checksum);
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL _s_read_statusreg
	POP  R20
;     631 
;     632   REL1_DDR|=(1<<REL1);  // REL1 0x20
	SBI  0x14,5
;     633   REL1_PORT&=~(1<<REL1); // REL1 - off 0xdf
	CBI  0x15,5
;     634   REL2_DDR|=(1<<REL2);  // REL2 0x40
	SBI  0x14,6
;     635   REL2_PORT&=~(1<<REL2); // REL2 - off 0xbf
	CBI  0x15,6
;     636   REL3_DDR|=(1<<REL3);  // REL3 0x80
	SBI  0x14,7
;     637   REL3_PORT&=~(1<<REL3); // REL3 - off 0x7f
	CBI  0x15,7
;     638 
;     639   while(1)
_0xCB:
;     640   {
;     641     therm_read_temperature(&temp_ds); //measures temperature from DS18B20
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	CALL _therm_read_temperature
;     642     error = 0;
	LDI  R21,LOW(0)
;     643     error += s_measure((unsigned char*) &humi_val.i, &checksum,HUMI);  //measure humidity
	MOVW R30,R28
	ADIW R30,35
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _s_measure
	POP  R20
	CALL SUBOPT_0x25
;     644     error += s_measure((unsigned char*) &temp_val.i, &checksum,TEMP);  //measure temperature
	MOVW R30,R28
	ADIW R30,31
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _s_measure
	POP  R20
	CALL SUBOPT_0x25
;     645     if (error!=0)
	CPI  R21,0
	BREQ _0xCE
;     646       s_connectionreset(); //in case of an error: connection reset
	CALL _s_connectionreset
;     647     else
	RJMP _0xCF
_0xCE:
;     648     {
;     649       humi_val.f = (float)humi_val.i;  //converts integer to float
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x26
	__PUTD1S 35
;     650       temp_val.f = (float)temp_val.i;   //converts integer to float
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	CALL SUBOPT_0x26
	__PUTD1S 31
;     651       calc_sth11(&humi_val.f, &temp_val.f); //calculate humidity, temperature
	MOVW R30,R28
	ADIW R30,35
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	CALL _calc_sth11
;     652       dew_point = calc_dewpoint(humi_val.f, temp_val.f); //calculate dew point
	CALL SUBOPT_0x27
	CALL SUBOPT_0x27
	CALL _calc_dewpoint
	__PUTD1S 23
;     653 
;     654       sprintf(lcd_buffer,"%+3.1f%cC %3.1f%% RH ", temp_ds,
;     655       0xdf, humi_val.f);
	CALL SUBOPT_0x11
	__POINTW1FN _0,349
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 31
	CALL __PUTPARD1
	CALL SUBOPT_0x13
	__GETD1S 47
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
;     656       lcd_gotoxy(0,0);
	CALL SUBOPT_0x15
;     657       lcd_puts(lcd_buffer);
	CALL _lcd_puts
;     658       sprintf(lcd_buffer,"%+d%cC ",(int)temp_val.f, 0xdf);
	CALL SUBOPT_0x11
	__POINTW1FN _0,371
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 35
	CALL __CFD1
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x13
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;     659       lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x4
;     660       lcd_puts(lcd_buffer);
	CALL SUBOPT_0x11
	CALL _lcd_puts
;     661     }
_0xCF:
;     662     // check temperature value
;     663     if (temp_ds > temp.max)
	__GETW1MN _temp,2
	__GETD2S 27
	CALL SUBOPT_0x26
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD0
;     664     {
;     665        REL1_PORT|=0x20;
	SBI  0x15,5
;     666     }
;     667     else //if (temp_ds < temp.min)
	RJMP _0xD1
_0xD0:
;     668     {
;     669       REL1_PORT&=0xdf;
	CBI  0x15,5
;     670     }
_0xD1:
;     671     // check humidity value
;     672     if (humi_val.f < hum.min)
	LDS  R30,_hum
	LDS  R31,_hum+1
	__GETD2S 35
	CALL SUBOPT_0x26
	CALL __CMPF12
	BRSH _0xD2
;     673     {
;     674       REL2_PORT|=0x40;
	SBI  0x15,6
;     675     }
;     676     else //if (humi_val.f > hum.max)
	RJMP _0xD3
_0xD2:
;     677     {
;     678       REL2_PORT&=0xbf;
	CBI  0x15,6
;     679     }
_0xD3:
;     680     // check soil moisture value
;     681     /*if (soil_val < soil.min)
;     682     {
;     683         REL2_PORT|=0x40;
;     684     }
;     685     else //if (soil_val > soil.max)
;     686     {
;     687         REL2_PORT&=0xbf;
;     688     }*/
;     689     // check light intensity value
;     690     if (light_val < light.min)
	LDS  R30,_light
	LDS  R31,_light+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0xD4
;     691     {
;     692         REL3_PORT|=0x80;
	SBI  0x15,7
;     693     }
;     694     else //if (light_val > light.max)
	RJMP _0xD5
_0xD4:
;     695     {
;     696 	    REL3_PORT&=0x7f;
	CBI  0x15,7
;     697     }
_0xD5:
;     698     /*vin=readADC(5); //measure pressure ADC5 pin
;     699     pressure=press_m(vin); //calculate pressure
;     700     //print pressure from MPX4115
;     701     sprintf(lcd_buffer,"%uкПа %.1fатм ",pressure, (pressure/101.325));
;     702     lcd_goto_xy(2,3);
;     703     lcd_str(lcd_buffer);*/
;     704     rtc_get_time(&hour,&min,&sec, &wd);
	MOVW R30,R28
	ADIW R30,17
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0x28
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
;     705     //rtc_get_date(&date,&month,&year);
;     706     //print time
;     707     sprintf(lcd_buffer, "%u%u:%u%u %s", hour/10,hour%10, min/10,min%10, weekdays[wd-1]);
	CALL SUBOPT_0x11
	__POINTW1FN _0,379
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+21
	CALL SUBOPT_0x1F
	LDD  R26,Y+25
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1E
	LDD  R26,Y+28
	CALL SUBOPT_0x1F
	LDD  R26,Y+32
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1E
	LDD  R30,Y+34
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x14
	LDI  R24,20
	CALL _sprintf
	ADIW R28,24
;     708     lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL SUBOPT_0x4
;     709     lcd_puts(lcd_buffer);
	CALL SUBOPT_0x11
	CALL _lcd_puts
;     710     //print date
;     711     /*sprintf(lcd_buffer, "%u%u %s 20%u%u", date/10,date%10, monthes[month-1], year/10,year%10);
;     712     lcd_goto_xy(2,6);
;     713     lcd_str(lcd_buffer);   */
;     714     if (get_key_status(MENU_ENTER_BTN)) //enter
	CALL SUBOPT_0x9
	BREQ _0xD6
;     715     {
;     716       if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0xA
	BRNE _0xD7
;     717       {
;     718 		lcd_clear();
	CALL _lcd_clear
;     719         main_menu();
	CALL _main_menu
;     720     	lcd_clear();
	CALL _lcd_clear
;     721       }
;     722     }
_0xD7:
;     723     //delay_ms(200);
;     724     //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------
;     725     //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
;     726     //-----------------------------------------------------------------------------------
;     727   }
_0xD6:
	RJMP _0xCB
;     728 }
_0xD8:
	RJMP _0xD8
;     729 
;     730 #pragma rl-
;     731 
;     732 /*void main(void)
;     733 {
;     734 // Declare your local variables here
;     735 
;     736 // Input/Output Ports initialization
;     737 // Port A initialization
;     738 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     739 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     740 PORTA=0x00;
;     741 DDRA=0x00;
;     742 
;     743 // Port B initialization
;     744 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     745 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     746 PORTB=0x00;
;     747 DDRB=0x00;
;     748 
;     749 // Port C initialization
;     750 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     751 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     752 PORTC=0x00;
;     753 DDRC=0x00;
;     754 
;     755 // Port D initialization
;     756 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     757 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     758 PORTD=0x00;
;     759 DDRD=0x00;
;     760 
;     761 // Timer/Counter 0 initialization
;     762 // Clock source: System Clock
;     763 // Clock value: Timer 0 Stopped
;     764 // Mode: Normal top=FFh
;     765 // OC0 output: Disconnected
;     766 TCCR0=0x00;
;     767 TCNT0=0x00;
;     768 OCR0=0x00;
;     769 
;     770 // Timer/Counter 1 initialization
;     771 // Clock source: System Clock
;     772 // Clock value: Timer1 Stopped
;     773 // Mode: Normal top=FFFFh
;     774 // OC1A output: Discon.
;     775 // OC1B output: Discon.
;     776 // Noise Canceler: Off
;     777 // Input Capture on Falling Edge
;     778 // Timer1 Overflow Interrupt: Off
;     779 // Input Capture Interrupt: Off
;     780 // Compare A Match Interrupt: Off
;     781 // Compare B Match Interrupt: Off
;     782 TCCR1A=0x00;
;     783 TCCR1B=0x00;
;     784 TCNT1H=0x00;
;     785 TCNT1L=0x00;
;     786 ICR1H=0x00;
;     787 ICR1L=0x00;
;     788 OCR1AH=0x00;
;     789 OCR1AL=0x00;
;     790 OCR1BH=0x00;
;     791 OCR1BL=0x00;
;     792 
;     793 // Timer/Counter 2 initialization
;     794 // Clock source: System Clock
;     795 // Clock value: Timer2 Stopped
;     796 // Mode: Normal top=FFh
;     797 // OC2 output: Disconnected
;     798 ASSR=0x00;
;     799 TCCR2=0x00;
;     800 TCNT2=0x00;
;     801 OCR2=0x00;
;     802 
;     803 // External Interrupt(s) initialization
;     804 // INT0: Off
;     805 // INT1: Off
;     806 // INT2: Off
;     807 MCUCR=0x00;
;     808 MCUCSR=0x00;
;     809 
;     810 // Timer(s)/Counter(s) Interrupt(s) initialization
;     811 TIMSK=0x00;
;     812 
;     813 // Analog Comparator initialization
;     814 // Analog Comparator: Off
;     815 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     816 ACSR=0x80;
;     817 SFIOR=0x00;
;     818 
;     819 while (1)
;     820       {
;     821       // Place your code here
;     822 
;     823       };
;     824 } */
;     825 #include "therm_ds18b20.h"
;     826 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     827 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     828 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;     829 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;     830 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;     831 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;     832 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;     833 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;     834 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;     835 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     836 	#endif
	#endif
;     837 
;     838 struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
;     839 //uint8_t therm_dq;
;     840 
;     841 /*void therm_input_mode(void)
;     842 {
;     843 	THERM_DDR&=~(1<<THERM_DQ);
;     844 }
;     845 void therm_output_mode(void)
;     846 {
;     847 	THERM_DDR|=(1<<THERM_DQ);
;     848 }
;     849 void therm_low(void)
;     850 {
;     851 	THERM_PORT&=~(1<<THERM_DQ);
;     852 }     */
;     853 /*void therm_high(void)
;     854 {
;     855 	THERM_PORT|=(1<<THERM_DQ);
;     856 }
;     857 void therm_delay(uint16_t delay)
;     858 {
;     859 	while (delay--) #asm("nop");
;     860 }*/
;     861 
;     862 uint8_t therm_reset()
;     863 {

	.CSEG
_therm_reset:
;     864 	uint8_t i;
;     865 	//посилаємо імпульс скидання тривалістю 480 мкс
;     866 	THERM_LOW();
	ST   -Y,R17
;	i -> R17
	CBI  0x15,4
;     867 	THERM_OUTPUT_MODE();
	SBI  0x14,4
;     868 	//therm_delay(us(480));
;     869 	delay_us(480);
	__DELAY_USW 960
;     870 	//повертаємо шину і чекаємо 60 мкс на відповідь
;     871 	THERM_INPUT_MODE();
	CBI  0x14,4
;     872 	//therm_delay(us(60));
;     873 	delay_us(60);
	__DELAY_USB 160
;     874 	//зберігаємо значення на шині і чекаємо завершення 480 мкс періода
;     875 	i=(THERM_PIN & (1<<THERM_DQ));
	IN   R30,0x13
	ANDI R30,LOW(0x10)
	MOV  R17,R30
;     876 	//therm_delay(us(420));
;     877 	delay_us(420);
	__DELAY_USW 840
;     878 	if ((THERM_PIN & (1<<THERM_DQ))==i) return 1;
	IN   R30,0x13
	ANDI R30,LOW(0x10)
	MOV  R26,R30
	CALL SUBOPT_0x18
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xD9
	LDI  R30,LOW(1)
	RJMP _0x236
;     879 	//повертаємо результат виконання (presence pulse) (0=OK, 1=WRONG)
;     880 	return 0;
_0xD9:
	LDI  R30,LOW(0)
	RJMP _0x236
;     881 }
;     882 
;     883 void therm_write_bit(uint8_t _bit)
;     884 {
_therm_write_bit:
;     885 	//переводимо шину в стан лог. 0 на 1 мкс
;     886 	THERM_LOW();
;	_bit -> Y+0
	CBI  0x15,4
;     887 	THERM_OUTPUT_MODE();
	SBI  0x14,4
;     888 	//therm_delay(us(1));
;     889 	delay_us(1);
	__DELAY_USB 3
;     890 	//якщо пишемо 1, відпускаємо шину (якщо 0 тримаємо в стані лог. 0)
;     891 	if (_bit) THERM_INPUT_MODE();
	LD   R30,Y
	CPI  R30,0
	BREQ _0xDA
	CBI  0x14,4
;     892 	//чекаємо 60мкм і відпускаємо шину
;     893 	//therm_delay(us(60));
;     894 	delay_us(60);
_0xDA:
	__DELAY_USB 160
;     895 	THERM_INPUT_MODE();
	CBI  0x14,4
;     896 }
	ADIW R28,1
	RET
;     897 
;     898 uint8_t therm_read_bit(void)
;     899 {
_therm_read_bit:
;     900 	uint8_t _bit=0;
;     901 	//переводимо шину в лог. 0 на 1 мкс
;     902 	THERM_LOW();
	ST   -Y,R17
;	_bit -> R17
	LDI  R17,0
	CBI  0x15,4
;     903 	THERM_OUTPUT_MODE();
	SBI  0x14,4
;     904 	//therm_delay(us(1));
;     905 	delay_us(1);
	__DELAY_USB 3
;     906 	//відпускаємо шину і чекаємо 14 мкс
;     907 	THERM_INPUT_MODE();
	CBI  0x14,4
;     908 	//therm_delay(us(14));
;     909 	delay_us(14);
	__DELAY_USB 37
;     910 	//читаємо біт з шини
;     911 	if (THERM_PIN&(1<<THERM_DQ)) _bit=1;
	SBIC 0x13,4
	LDI  R17,LOW(1)
;     912 	//чекаємо 45 мкс до закінчення і вертаємо прочитане значення
;     913 	//therm_delay(us(45));
;     914 	delay_us(45);
	__DELAY_USB 120
;     915 	return _bit;
	MOV  R30,R17
_0x236:
	LD   R17,Y+
	RET
;     916 }
;     917 
;     918 uint8_t therm_read_byte(void)
;     919 {
_therm_read_byte:
;     920 	uint8_t i=8, n=0;
;     921 	while (i--)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	n -> R16
	LDI  R16,0
	LDI  R17,8
_0xDC:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xDE
;     922 	{
;     923 		//зсуваємо на 1 розряд вправо і зберігаємо прочитане значення
;     924 		n>>=1;
	LSR  R16
;     925 		n|=(therm_read_bit()<<7);
	CALL _therm_read_bit
	ROR  R30
	LDI  R30,0
	ROR  R30
	LDI  R31,0
	OR   R16,R30
;     926 	}
	RJMP _0xDC
_0xDE:
;     927 	return n;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
;     928 }
;     929 
;     930 void therm_write_byte(uint8_t byte)
;     931 {
_therm_write_byte:
;     932 	uint8_t i=8;
;     933 	while (i--)
	ST   -Y,R17
;	byte -> Y+1
;	i -> R17
	LDI  R17,8
_0xDF:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xE1
;     934 	{
;     935 		//пишемо молодший біт і зсуваємо на 1 розряд вправо для виводу наступного біта
;     936 		therm_write_bit(byte&1);
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	ST   -Y,R30
	CALL _therm_write_bit
;     937 		byte>>=1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
;     938 	}
	RJMP _0xDF
_0xE1:
;     939 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     940 
;     941 uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes)
;     942 {
_therm_crc8:
;     943 	uint8_t byte_ctr, cur_byte, bit_ctr, crc=0;
;     944 
;     945 	for (byte_ctr=0; byte_ctr<num_bytes; byte_ctr++)
	CALL __SAVELOCR4
;	*data -> Y+5
;	num_bytes -> Y+4
;	byte_ctr -> R17
;	cur_byte -> R16
;	bit_ctr -> R19
;	crc -> R18
	LDI  R18,0
	LDI  R17,LOW(0)
_0xE3:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0xE4
;     946 	{
;     947 		cur_byte=data[byte_ctr];
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
;     948 		for (bit_ctr=0; bit_ctr<8; cur_byte>>=1, bit_ctr++)
	LDI  R19,LOW(0)
_0xE6:
	CPI  R19,8
	BRSH _0xE7
;     949 			if ((cur_byte ^ crc) & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
	MOV  R30,R18
	LDI  R31,0
	EOR  R30,R16
	ANDI R30,LOW(0x1)
	BREQ _0xE8
	LDI  R30,LOW(24)
	EOR  R30,R18
	LSR  R30
	ORI  R30,0x80
	MOV  R18,R30
;     950 			else crc>>=1;
	RJMP _0xE9
_0xE8:
	LSR  R18
;     951 	}
_0xE9:
	LSR  R16
	SUBI R19,-1
	RJMP _0xE6
_0xE7:
	SUBI R17,-1
	RJMP _0xE3
_0xE4:
;     952 	return crc;
	MOV  R30,R18
	CALL __LOADLOCR4
	ADIW R28,7
	RET
;     953 }
;     954 
;     955 uint8_t therm_init(int8_t temp_low, int8_t temp_high, uint8_t resolution)
;     956 {
_therm_init:
;     957 	resolution=(resolution<<5)|0x1f;
;	temp_low -> Y+2
;	temp_high -> Y+1
;	resolution -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
;     958 	//ініціалізуємо давач
;     959 	if (therm_reset()) return 1;
	CALL _therm_reset
	CPI  R30,0
	BREQ _0xEA
	LDI  R30,LOW(1)
	RJMP _0x235
;     960 	therm_write_byte(THERM_CMD_SKIPROM);
_0xEA:
	CALL SUBOPT_0x29
;     961 	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	LDI  R30,LOW(78)
	ST   -Y,R30
	CALL _therm_write_byte
;     962 	therm_write_byte(temp_high);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _therm_write_byte
;     963 	therm_write_byte(temp_low);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _therm_write_byte
;     964 	therm_write_byte(resolution);
	LD   R30,Y
	ST   -Y,R30
	CALL _therm_write_byte
;     965 	therm_reset();
	CALL _therm_reset
;     966 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x29
;     967 	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	LDI  R30,LOW(72)
	ST   -Y,R30
	CALL _therm_write_byte
;     968 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     969 	return 0;
	LDI  R30,LOW(0)
_0x235:
	ADIW R28,3
	RET
;     970 }
;     971 
;     972 uint8_t therm_read_spd(void)
;     973 {
_therm_read_spd:
;     974 	uint8_t i=0, *p;
;     975 
;     976 	p = (uint8_t*) &__ds18b20_scratch_pad;
	CALL __SAVELOCR4
;	i -> R17
;	*p -> R18,R19
	LDI  R17,0
	__POINTWRM 18,19,___ds18b20_scratch_pad
;     977 	do
_0xEC:
;     978 		*(p++)=therm_read_byte();
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _therm_read_byte
	POP  R26
	POP  R27
	ST   X,R30
;     979 	while(++i<9);
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0xEC
;     980 	if (therm_crc8((uint8_t*)&__ds18b20_scratch_pad,8)!=__ds18b20_scratch_pad.crc)
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _therm_crc8
	MOV  R26,R30
	__GETB1MN ___ds18b20_scratch_pad,8
	CALL SUBOPT_0x2A
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xEE
;     981 		return 1;
	LDI  R30,LOW(1)
	RJMP _0x234
;     982 	return 0;
_0xEE:
	LDI  R30,LOW(0)
_0x234:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     983 }
;     984 
;     985 uint8_t therm_read_temperature(float *temp)
;     986 {
_therm_read_temperature:
;     987 	uint8_t digit, decimal, resolution, sign;
;     988 	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};
;     989 
;     990 	//скинути, пропустити процедуру перевірки серійного номера ROM і почати вимірювання і перетворення температури
;     991 	if (therm_reset()) return 1;
	SBIW R28,8
	LDI  R24,8
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xEF*2)
	LDI  R31,HIGH(_0xEF*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	*temp -> Y+14
;	digit -> R17
;	decimal -> R16
;	resolution -> R19
;	sign -> R18
;	meas -> R20,R21
;	bit_mask -> Y+6
	CALL _therm_reset
	CPI  R30,0
	BREQ _0xF0
	LDI  R30,LOW(1)
	RJMP _0x233
;     992 	therm_write_byte(THERM_CMD_SKIPROM);
_0xF0:
	CALL SUBOPT_0x29
;     993 	therm_write_byte(THERM_CMD_CONVERTTEMP);
	LDI  R30,LOW(68)
	ST   -Y,R30
	CALL _therm_write_byte
;     994 	//чекаємо до закінчення перетворення
;     995 	//if (!therm_read_bit()) return 1;
;     996 	while(!therm_read_bit());
_0xF1:
	CALL _therm_read_bit
	CPI  R30,0
	BREQ _0xF1
;     997 	//скидаємо, пропускаємо ROM і посилаємо команду зчитування Scratchpad
;     998 	therm_reset();
	CALL _therm_reset
;     999 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x29
;    1000 	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	LDI  R30,LOW(190)
	ST   -Y,R30
	CALL _therm_write_byte
;    1001 	if (therm_read_spd()) return 1;
	CALL _therm_read_spd
	CPI  R30,0
	BREQ _0xF4
	LDI  R30,LOW(1)
	RJMP _0x233
;    1002 	therm_reset();
_0xF4:
	CALL _therm_reset
;    1003 	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R19,R30
;    1004     //отримуємо молодший і старший байти температури
;    1005 	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	LDS  R20,___ds18b20_scratch_pad
	CLR  R21
;    1006 	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB
	__GETB1HMN ___ds18b20_scratch_pad,1
	LDI  R30,LOW(0)
	__ORWRR 20,21,30,31
;    1007 	//перевіряємо на мінусову температуру
;    1008 	if (meas & 0x8000)
	SBRS R21,7
	RJMP _0xF5
;    1009 	{
;    1010 		sign=1;  //відмічаємо мінусову температуру
	LDI  R18,LOW(1)
;    1011 		meas^=0xffff;  //перетворюємо в плюсову
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__EORWRR 20,21,30,31
;    1012 		meas++;
	__ADDWRN 20,21,1
;    1013 	}
;    1014 	else sign=0;
	RJMP _0xF6
_0xF5:
	LDI  R18,LOW(0)
;    1015 	//зберігаємо цілу і дробову частини температури
;    1016 	digit=(uint8_t)(meas >> 4); //зберігаємо цілу частину
_0xF6:
	MOVW R30,R20
	CALL __LSRW4
	MOV  R17,R30
;    1017 	decimal=(uint8_t)(meas & bit_mask[resolution]);	//отримуємо дробову частину
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x20
	AND  R30,R20
	AND  R31,R21
	MOV  R16,R30
;    1018 	*temp=digit+decimal*0.0625;
	CALL SUBOPT_0x2B
	__GETD2N 0x3D800000
	CALL __MULF12
	MOV  R26,R17
	LDI  R27,0
	CALL __CWD2
	CALL __CDF2
	CALL __ADDF12
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __PUTDP1
;    1019 	if (sign) *temp=-(*temp); //ставемо знак мінус, якщо мінусова температура
	CPI  R18,0
	BREQ _0xF7
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETD1P
	CALL __ANEGF1
	CALL __PUTDP1
;    1020 	return 0;
_0xF7:
	LDI  R30,LOW(0)
_0x233:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;    1021 }
;    1022 /***********************************************************************************
;    1023 Project:          SHTxx library
;    1024 Filename:         shtxx.c
;    1025 Processor:        AVR family
;    1026 Author:           (C) Andriy Holovatyy
;    1027 ***********************************************************************************/
;    1028 
;    1029 #include "shtxx.h"
;    1030 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;    1031 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;    1032 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;    1033 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;    1034 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;    1035 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;    1036 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;    1037 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;    1038 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;    1039 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;    1040 	#endif
	#endif
;    1041 #include <math.h>   //math library
;    1042 
;    1043 /* константи для обчислення температури і вологості */
;    1044 //const float C1=-4.0;              // for 12 Bit
;    1045 //const float C2=+0.0405;           // for 12 Bit
;    1046 //const float C3=-0.0000028;        // for 12 Bit
;    1047 
;    1048 /*const float C1=-2.0468;           // for 12 Bit
;    1049 const float C2=+0.0367;           // for 12 Bit
;    1050 const float C3=-0.0000015955;     // for 12 Bit
;    1051 
;    1052 const float T1=+0.01;             // for 14 Bit @ 5V
;    1053 const float T2=+0.00008;           // for 14 Bit @ 5V
;    1054 
;    1055 */
;    1056 
;    1057 const float C1=-2.0468;           // for 8 Bit
;    1058 const float C2=+0.5872;           // for 8 Bit
;    1059 const float C3=-0.00040845;       // for 8 Bit
;    1060 
;    1061 const float T1=+0.01;             // for 12 Bit @ 5V
;    1062 const float T2=+0.00128;          // for 12 Bit @ 5V
;    1063 
;    1064 void sht_init(void)
;    1065 {
_sht_init:
;    1066   SHT_PORT=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1067   SHT_DDR=1<<SHT_SCK;
	LDI  R30,LOW(4)
	OUT  0x14,R30
;    1068 }
	RET
;    1069 
;    1070 //----------------------------------------------------------------------------------
;    1071 char s_write_byte(unsigned char _value)
;    1072 //----------------------------------------------------------------------------------
;    1073 // writes a byte on the Sensibus and checks the acknowledge
;    1074 {
_s_write_byte:
;    1075   unsigned char i,error=0;
;    1076   SHT_OUTPUT_MODE();
	ST   -Y,R17
	ST   -Y,R16
;	_value -> Y+2
;	i -> R17
;	error -> R16
	LDI  R16,0
	SBI  0x14,3
;    1077   for (i=0x80;i>0;i/=2)             //shift bit for masking
	LDI  R17,LOW(128)
_0xF9:
	CPI  R17,1
	BRLO _0xFA
;    1078   {
;    1079     if (i & _value) SHT_DATA_HIGH(); //masking value with i , write to SENSI-BUS
	LDD  R30,Y+2
	LDI  R31,0
	MOV  R26,R17
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0xFB
	SBI  0x15,3
;    1080     else
	RJMP _0xFC
_0xFB:
;    1081      SHT_DATA_LOW();
	CBI  0x15,3
;    1082     delay_us(1);
_0xFC:
	CALL SUBOPT_0x2C
;    1083     SHT_SCK_HIGH(); //clk for SENSI-BUS
;    1084     delay_us(5);    //pulswith approx. 5 us
	__DELAY_USB 13
;    1085     SHT_SCK_LOW();
	CBI  0x15,2
;    1086   }
	LSR  R17
	RJMP _0xF9
_0xFA:
;    1087   SHT_INPUT_MODE(); //release DATA-line
	CBI  0x14,3
;    1088   delay_us(1);
	CALL SUBOPT_0x2C
;    1089   SHT_SCK_HIGH(); //clk #9 for ack
;    1090   delay_us(1);
	__DELAY_USB 3
;    1091   error=(SHT_PIN&(1<<SHT_DATA));                       //check ack (DATA will be pulled down by SHT11)
	IN   R30,0x13
	ANDI R30,LOW(0x8)
	MOV  R16,R30
;    1092   SHT_SCK_LOW();
	CALL SUBOPT_0x2D
;    1093   delay_us(1);
;    1094   return error;                     //error=1 in case of no acknowledge
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x232
;    1095 }
;    1096 
;    1097 //----------------------------------------------------------------------------------
;    1098 char s_read_byte(unsigned char ack)
;    1099 //----------------------------------------------------------------------------------
;    1100 // reads a byte form the Sensibus and gives an acknowledge in case of "ack=1"
;    1101 {
_s_read_byte:
;    1102   unsigned char i,val=0;
;    1103   SHT_INPUT_MODE(); //release DATA-line
	ST   -Y,R17
	ST   -Y,R16
;	ack -> Y+2
;	i -> R17
;	val -> R16
	LDI  R16,0
	CBI  0x14,3
;    1104   for (i=0x80;i>0;i/=2)  //shift bit for masking
	LDI  R17,LOW(128)
_0xFE:
	CPI  R17,1
	BRLO _0xFF
;    1105   {
;    1106     SHT_SCK_HIGH();    //clk for SENSI-BUS
	CALL SUBOPT_0x2E
;    1107     delay_us(1);
;    1108     if ((SHT_PIN & (1<<SHT_DATA))) val=(val | i);        //read bit
	SBIS 0x13,3
	RJMP _0x100
	CALL SUBOPT_0x18
	OR   R16,R30
;    1109     SHT_SCK_LOW();
_0x100:
	CALL SUBOPT_0x2D
;    1110     delay_us(1);
;    1111   }
	LSR  R17
	RJMP _0xFE
_0xFF:
;    1112   if (ack) //in case of "ack==1" pull down DATA-Line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x101
;    1113   {
;    1114    SHT_OUTPUT_MODE();
	SBI  0x14,3
;    1115    SHT_DATA_LOW();
	CBI  0x15,3
;    1116    delay_us(1);
	__DELAY_USB 3
;    1117   }
;    1118   SHT_SCK_HIGH();        //clk #9 for ack
_0x101:
	SBI  0x15,2
;    1119   delay_us(5);  //pulswith approx. 5 us
	__DELAY_USB 13
;    1120   SHT_SCK_LOW();
	CALL SUBOPT_0x2D
;    1121   delay_us(1);
;    1122   SHT_INPUT_MODE(); //release DATA-line
	CBI  0x14,3
;    1123   return val;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x232
;    1124 }
;    1125 
;    1126 //----------------------------------------------------------------------------------
;    1127 void s_transstart(void)
;    1128 //----------------------------------------------------------------------------------
;    1129 // generates a transmission start
;    1130 //       _____         ________
;    1131 // DATA:      |_______|
;    1132 //           ___     ___
;    1133 // SCK : ___|   |___|   |______
;    1134 {
_s_transstart:
;    1135   //Initial state
;    1136   SHT_OUTPUT_MODE();
	SBI  0x14,3
;    1137   SHT_DATA_HIGH();
	SBI  0x15,3
;    1138   SHT_SCK_LOW();
	CBI  0x15,2
;    1139   delay_us(1);
	CALL SUBOPT_0x2C
;    1140 
;    1141   SHT_SCK_HIGH();
;    1142   delay_us(1);
	__DELAY_USB 3
;    1143 
;    1144   SHT_DATA_LOW();
	CBI  0x15,3
;    1145   delay_us(1);
	__DELAY_USB 3
;    1146 
;    1147   SHT_SCK_LOW();
	CBI  0x15,2
;    1148   delay_us(5);
	__DELAY_USB 13
;    1149 
;    1150   SHT_SCK_HIGH();
	CALL SUBOPT_0x2E
;    1151   delay_us(1);
;    1152 
;    1153   SHT_DATA_HIGH();
	SBI  0x15,3
;    1154   delay_us(1);
	__DELAY_USB 3
;    1155   SHT_SCK_LOW();
	CALL SUBOPT_0x2D
;    1156   delay_us(1);
;    1157 }
	RET
;    1158 
;    1159 //----------------------------------------------------------------------------------
;    1160 void s_connectionreset(void)
;    1161 //----------------------------------------------------------------------------------
;    1162 // communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
;    1163 //       _____________________________________________________         ________
;    1164 // DATA:                                                      |_______|
;    1165 //          _    _    _    _    _    _    _    _    _        ___     ___
;    1166 // SCK : __| |__| |__| |__| |__| |__| |__| |__| |__| |______|   |___|   |______
;    1167 {
_s_connectionreset:
;    1168   unsigned char i;
;    1169   //Initial state
;    1170   SHT_OUTPUT_MODE();
	ST   -Y,R17
;	i -> R17
	SBI  0x14,3
;    1171   SHT_DATA_HIGH();
	SBI  0x15,3
;    1172   SHT_SCK_LOW();
	CALL SUBOPT_0x2D
;    1173   delay_us(1);
;    1174   for(i=0;i<9;i++)                  //9 SCK cycles
	LDI  R17,LOW(0)
_0x103:
	CPI  R17,9
	BRSH _0x104
;    1175   {
;    1176     SHT_SCK_HIGH();
	CALL SUBOPT_0x2E
;    1177     delay_us(1);
;    1178     SHT_SCK_LOW();
	CALL SUBOPT_0x2D
;    1179     delay_us(1);
;    1180   }
	SUBI R17,-1
	RJMP _0x103
_0x104:
;    1181   s_transstart();                   //transmission start
	CALL _s_transstart
;    1182 }
	LD   R17,Y+
	RET
;    1183 
;    1184 //----------------------------------------------------------------------------------
;    1185 char s_softreset(void)
;    1186 //----------------------------------------------------------------------------------
;    1187 // resets the sensor by a softreset
;    1188 {
;    1189   unsigned char error=0;
;    1190   s_connectionreset();              //reset communication
;	error -> R17
;    1191   error+=s_write_byte(RESET);       //send RESET-command to sensor
;    1192   return error;                     //error=1 in case of no response form the sensor
;    1193 }
;    1194 
;    1195 //----------------------------------------------------------------------------------
;    1196 char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum)
;    1197 //----------------------------------------------------------------------------------
;    1198 // reads the status register with checksum (8-bit)
;    1199 {
_s_read_statusreg:
;    1200   unsigned char error=0;
;    1201   s_transstart();                   //transmission start
	ST   -Y,R17
;	*p_value -> Y+3
;	*p_checksum -> Y+1
;	error -> R17
	LDI  R17,0
	CALL _s_transstart
;    1202   error=s_write_byte(STATUS_REG_R); //send command to sensor
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _s_write_byte
	MOV  R17,R30
;    1203   *p_value=s_read_byte(ACK);        //read status register (8-bit)
	CALL SUBOPT_0x2F
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ST   X,R30
;    1204   *p_checksum=s_read_byte(noACK);   //read checksum (8-bit)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _s_read_byte
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
;    1205   return error;                     //error=1 in case of no response form the sensor
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,5
	RET
;    1206 }
;    1207 
;    1208 //----------------------------------------------------------------------------------
;    1209 char s_write_statusreg(unsigned char *p_value)
;    1210 //----------------------------------------------------------------------------------
;    1211 // writes the status register with checksum (8-bit)
;    1212 {
_s_write_statusreg:
;    1213   unsigned char error=0;
;    1214   s_transstart();                   //transmission start
	ST   -Y,R17
;	*p_value -> Y+1
;	error -> R17
	LDI  R17,0
	CALL _s_transstart
;    1215   error+=s_write_byte(STATUS_REG_W);//send command to sensor
	LDI  R30,LOW(6)
	CALL SUBOPT_0x30
;    1216   error+=s_write_byte(*p_value);    //send value of status register
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CALL SUBOPT_0x30
;    1217   return error;                     //error>=1 in case of no response form the sensor
	MOV  R30,R17
	LDD  R17,Y+0
_0x232:
	ADIW R28,3
	RET
;    1218 }
;    1219 
;    1220 //----------------------------------------------------------------------------------
;    1221 char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
;    1222 //----------------------------------------------------------------------------------
;    1223 // makes a measurement (humidity/temperature) with checksum
;    1224 {
_s_measure:
;    1225   unsigned error=0;
;    1226   unsigned int i;
;    1227 
;    1228   s_transstart();                   //transmission start
	CALL __SAVELOCR4
;	*p_value -> Y+7
;	*p_checksum -> Y+5
;	mode -> Y+4
;	error -> R16,R17
;	i -> R18,R19
	LDI  R16,0
	LDI  R17,0
	CALL _s_transstart
;    1229   switch(mode){                     //send command to sensor
	LDD  R30,Y+4
	CALL SUBOPT_0x10
;    1230     case TEMP	: error+=s_write_byte(MEASURE_TEMP); break;
	BRNE _0x108
	LDI  R30,LOW(3)
	CALL SUBOPT_0x31
	RJMP _0x107
;    1231     case HUMI	: error+=s_write_byte(MEASURE_HUMI); break;
_0x108:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x10A
	LDI  R30,LOW(5)
	CALL SUBOPT_0x31
;    1232     default     : break;
_0x10A:
;    1233   }
_0x107:
;    1234   SHT_INPUT_MODE();
	CBI  0x14,3
;    1235   for (i=0;i<65535;i++)
	__GETWRN 18,19,0
_0x10C:
	__CPWRN 18,19,65535
	BRSH _0x10D
;    1236   {
;    1237    delay_us(1);
	__DELAY_USB 3
;    1238    if((SHT_PIN & (1<<SHT_DATA))==0) break; //wait until sensor has finished the measurement
	SBIS 0x13,3
	RJMP _0x10D
;    1239   }
	__ADDWRN 18,19,1
	RJMP _0x10C
_0x10D:
;    1240   if(SHT_PIN & (1<<SHT_DATA)) error+=1;                // or timeout (~2 sec.) is reached
	SBIS 0x13,3
	RJMP _0x10F
	__ADDWRN 16,17,1
;    1241   *(p_value+1)=s_read_byte(ACK);    //read the first byte (MSB)
_0x10F:
	CALL SUBOPT_0x2F
	__PUTB1SNS 7,1
;    1242   *(p_value)=s_read_byte(ACK);    //read the second byte (LSB)
	CALL SUBOPT_0x2F
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ST   X,R30
;    1243   *p_checksum =s_read_byte(noACK);  //read checksum
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _s_read_byte
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X,R30
;    1244   return error;
	MOVW R30,R16
	CALL __LOADLOCR4
	ADIW R28,9
	RET
;    1245 }
;    1246 
;    1247 //----------------------------------------------------------------------------------------
;    1248 void calc_sth11(float *p_humidity ,float *p_temperature)
;    1249 //----------------------------------------------------------------------------------------
;    1250 // calculates temperature [°C] and humidity [%RH]
;    1251 // input :  humi [Ticks] (12 bit)
;    1252 //          temp [Ticks] (14 bit)
;    1253 // output:  humi [%RH]
;    1254 //          temp [°C]
;    1255 {
_calc_sth11:
;    1256   float rh=*p_humidity;             // rh:      Humidity [Ticks] 12 Bit
;    1257   float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
;    1258   float rh_lin;                     // rh_lin:  Humidity linear
;    1259   float rh_true;                    // rh_true: Temperature compensated humidity
;    1260   float t_C;                        // t_C   :  Temperature [°C]
;    1261 
;    1262   t_C=t*0.04 - 39.8;                  //calc. temperature from ticks to [°C]  first coeff. 0.01 for 14 bit and 0.04 for 12 bit
	SBIW R28,20
;	*p_humidity -> Y+22
;	*p_temperature -> Y+20
;	rh -> Y+16
;	t -> Y+12
;	rh_lin -> Y+8
;	rh_true -> Y+4
;	t_C -> Y+0
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETD1P
	__PUTD1S 16
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __GETD1P
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	__GETD1N 0x3D23D70A
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x421F3333
	CALL SUBOPT_0x34
	__PUTD1S 0
;    1263   rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
	LDI  R30,LOW(_C3*2)
	LDI  R31,HIGH(_C3*2)
	CALL __GETD1PF
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_C2*2)
	LDI  R31,HIGH(_C2*2)
	CALL __GETD1PF
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(_C1*2)
	LDI  R31,HIGH(_C1*2)
	CALL __GETD1PF
	CALL __ADDF12
	__PUTD1S 8
;    1264   rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
	__GETD2S 0
	__GETD1N 0x41C80000
	CALL SUBOPT_0x34
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_T1*2)
	LDI  R31,HIGH(_T1*2)
	CALL __GETD1PF
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_T2*2)
	LDI  R31,HIGH(_T2*2)
	CALL __GETD1PF
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	__GETD2S 8
	CALL SUBOPT_0x36
;    1265   if(rh_true>100)rh_true=100;       //cut if the value is outside of
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x110
	CALL SUBOPT_0x37
;    1266   if(rh_true<0.1)rh_true=0.1;       //the physical possible range
_0x110:
	CALL SUBOPT_0x38
	__GETD1N 0x3DCCCCCD
	CALL __CMPF12
	BRSH _0x111
	CALL SUBOPT_0x37
;    1267 
;    1268   *p_temperature=t_C;               //return temperature [°C]
_0x111:
	CALL SUBOPT_0x39
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __PUTDP1
;    1269   *p_humidity=rh_true;              //return humidity[%RH]
	CALL SUBOPT_0x3A
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __PUTDP1
;    1270 }
	ADIW R28,24
	RET
;    1271 
;    1272 //--------------------------------------------------------------------
;    1273 float calc_dewpoint(float h,float t)
;    1274 //--------------------------------------------------------------------
;    1275 // calculates dew point
;    1276 // input:   humidity [%RH], temperature [°C]
;    1277 // output:  dew point [°C]
;    1278 { float logEx,dew_point;
_calc_dewpoint:
;    1279   logEx=0.66077+7.5*t/(237.3+t)+(log10(h)-2);
	SBIW R28,8
;	h -> Y+12
;	t -> Y+8
;	logEx -> Y+4
;	dew_point -> Y+0
	__GETD1S 8
	__GETD2N 0x40F00000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	__GETD2N 0x436D4CCD
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__GETD2N 0x3F292839
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	CALL __PUTPARD1
	CALL _log10
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	CALL SUBOPT_0x34
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x36
;    1280   dew_point = (logEx - 0.66077)*237.3/(0.66077+7.5-logEx);
	__GETD1N 0x3F292839
	CALL SUBOPT_0x34
	__GETD2N 0x436D4CCD
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x38
	__GETD1N 0x41029284
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1S 0
;    1281   return dew_point;
	CALL SUBOPT_0x39
	ADIW R28,16
	RET
;    1282 }
;    1283 

	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
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
__put_G4:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x11F
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x121
	__CPWRN 16,17,2
	BRLO _0x122
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x121:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x3C
	LDD  R26,Y+6
	STD  Z+0,R26
_0x122:
	RJMP _0x123
_0x11F:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x123:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__ftoa_G4:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x124
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x124:
	LDD  R30,Y+8
	LDI  R31,0
	LDI  R26,LOW(__fround_G4*2)
	LDI  R27,HIGH(__fround_G4*2)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	CALL SUBOPT_0x3D
	CALL __ADDF12
	CALL SUBOPT_0x3E
	LDI  R17,LOW(0)
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
_0x125:
	CALL SUBOPT_0x41
	CALL __CMPF12
	BRLO _0x127
	CALL SUBOPT_0x42
	CALL __MULF12
	CALL SUBOPT_0x40
	SUBI R17,-LOW(1)
	RJMP _0x125
_0x127:
	CPI  R17,0
	BRNE _0x128
	CALL SUBOPT_0x43
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x129
_0x128:
_0x12A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x12C
	CALL SUBOPT_0x42
	CALL SUBOPT_0x44
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
	__GETD2S 2
	CALL SUBOPT_0x46
	CALL __MULF12
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3E
	RJMP _0x12A
_0x12C:
_0x129:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x12D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x231
_0x12D:
	CALL SUBOPT_0x43
	LDI  R30,LOW(46)
	ST   X,R30
_0x12E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x130
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x47
	CALL SUBOPT_0x3E
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3E
	RJMP _0x12E
_0x130:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x231:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G4:
	SBIW R28,4
	CALL __SAVELOCR4
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x37
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x131
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x131:
	LDD  R17,Y+11
_0x132:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x134
	CALL SUBOPT_0x48
	CALL SUBOPT_0x37
	RJMP _0x132
_0x134:
	CALL SUBOPT_0x3B
	CALL __CPD10
	BRNE _0x135
	LDI  R19,LOW(0)
	CALL SUBOPT_0x48
	CALL SUBOPT_0x37
	RJMP _0x136
_0x135:
	LDD  R19,Y+11
	CALL SUBOPT_0x49
	BREQ PC+2
	BRCC PC+3
	JMP  _0x137
	CALL SUBOPT_0x48
	CALL SUBOPT_0x37
_0x138:
	CALL SUBOPT_0x49
	BRLO _0x13A
	CALL SUBOPT_0x4A
	RJMP _0x138
_0x13A:
	RJMP _0x13B
_0x137:
_0x13C:
	CALL SUBOPT_0x49
	BRSH _0x13E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	SUBI R19,LOW(1)
	RJMP _0x13C
_0x13E:
	CALL SUBOPT_0x48
	CALL SUBOPT_0x37
_0x13B:
	CALL SUBOPT_0x3B
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x49
	BRLO _0x13F
	CALL SUBOPT_0x4A
_0x13F:
_0x136:
	LDI  R17,LOW(0)
_0x140:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x142
	CALL SUBOPT_0x38
	__GETD1N 0x41200000
	CALL SUBOPT_0x44
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x33
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x4B
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x38
	CALL __MULF12
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CALL SUBOPT_0x32
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x140
	CALL SUBOPT_0x4B
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x140
_0x142:
	CALL SUBOPT_0x4C
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x144
	CALL SUBOPT_0x4B
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x144:
	CPI  R19,10
	BRLT _0x145
	CALL SUBOPT_0x4C
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	CALL SUBOPT_0x4D
_0x145:
	CALL SUBOPT_0x4C
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	CALL SUBOPT_0x4D
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G4:
	SBIW R28,63
	SBIW R28,15
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 84
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x146:
	MOVW R26,R28
	SUBI R26,LOW(-(90))
	SBCI R27,HIGH(-(90))
	CALL SUBOPT_0x3C
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x148
	CALL SUBOPT_0x6
	BRNE _0x14C
	CPI  R18,37
	BRNE _0x14D
	LDI  R17,LOW(1)
	RJMP _0x14E
_0x14D:
	CALL SUBOPT_0x4E
	CALL __put_G4
_0x14E:
	RJMP _0x14B
_0x14C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14F
	CPI  R18,37
	BRNE _0x150
	CALL SUBOPT_0x4E
	CALL __put_G4
	RJMP _0x240
_0x150:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+19,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x151
	LDI  R16,LOW(1)
	RJMP _0x14B
_0x151:
	CPI  R18,43
	BRNE _0x152
	LDI  R30,LOW(43)
	STD  Y+19,R30
	RJMP _0x14B
_0x152:
	CPI  R18,32
	BRNE _0x153
	LDI  R30,LOW(32)
	STD  Y+19,R30
	RJMP _0x14B
_0x153:
	RJMP _0x154
_0x14F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x155
_0x154:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x156
	ORI  R16,LOW(128)
	RJMP _0x14B
_0x156:
	RJMP _0x157
_0x155:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x158
_0x157:
	CPI  R18,48
	BRLO _0x15A
	CPI  R18,58
	BRLO _0x15B
_0x15A:
	RJMP _0x159
_0x15B:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	CALL SUBOPT_0x25
	RJMP _0x14B
_0x159:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x15C
	LDI  R17,LOW(4)
	RJMP _0x14B
_0x15C:
	RJMP _0x15D
_0x158:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x15F
	CPI  R18,48
	BRLO _0x161
	CPI  R18,58
	BRLO _0x162
_0x161:
	RJMP _0x160
_0x162:
	ORI  R16,LOW(32)
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	LDI  R31,0
	ADD  R20,R30
	RJMP _0x14B
_0x160:
_0x15D:
	CPI  R18,108
	BRNE _0x163
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x14B
_0x163:
	RJMP _0x164
_0x15F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x14B
_0x164:
	MOV  R30,R18
	LDI  R31,0
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x169
	CALL SUBOPT_0x4F
	LDD  R30,Z+4
	CALL SUBOPT_0x50
	CALL __put_G4
	RJMP _0x16A
_0x169:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BREQ _0x16D
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x16E
_0x16D:
	RJMP _0x16F
_0x16E:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x170
_0x16F:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x4F
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x51
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x171
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x173
	RJMP _0x174
_0x171:
	CALL SUBOPT_0x52
	CALL __ANEGF1
	CALL SUBOPT_0x51
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x173:
	SBRS R16,7
	RJMP _0x175
	LDD  R30,Y+19
	CALL SUBOPT_0x50
	CALL __put_G4
	RJMP _0x176
_0x175:
	CALL SUBOPT_0x53
	LDD  R26,Y+19
	STD  Z+0,R26
_0x176:
_0x174:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x178
	CALL SUBOPT_0x52
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoa_G4
	RJMP _0x179
_0x178:
	CALL SUBOPT_0x52
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G4
_0x179:
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x54
	RJMP _0x17A
_0x170:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x17C
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	RJMP _0x17D
_0x17C:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x17F
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x17D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x181
	CP   R20,R17
	BRLO _0x182
_0x181:
	RJMP _0x180
_0x182:
	MOV  R17,R20
_0x180:
_0x17A:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R19,LOW(0)
	RJMP _0x183
_0x17F:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x186
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x187
_0x186:
	ORI  R16,LOW(4)
	RJMP _0x188
_0x187:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x189
_0x188:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x18A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x32
	LDI  R17,LOW(10)
	RJMP _0x18B
_0x18A:
	__GETD1N 0x2710
	CALL SUBOPT_0x32
	LDI  R17,LOW(5)
	RJMP _0x18B
_0x189:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x18D
	ORI  R16,LOW(8)
	RJMP _0x18E
_0x18D:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1CC
_0x18E:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x190
	__GETD1N 0x10000000
	CALL SUBOPT_0x32
	LDI  R17,LOW(8)
	RJMP _0x18B
_0x190:
	__GETD1N 0x1000
	CALL SUBOPT_0x32
	LDI  R17,LOW(4)
_0x18B:
	CPI  R20,0
	BREQ _0x191
	ANDI R16,LOW(127)
	RJMP _0x192
_0x191:
	LDI  R20,LOW(1)
_0x192:
	SBRS R16,1
	RJMP _0x193
	CALL SUBOPT_0x4F
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	RJMP _0x241
_0x193:
	SBRS R16,2
	RJMP _0x195
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
	CALL __CWD1
	RJMP _0x241
_0x195:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x55
	CLR  R22
	CLR  R23
_0x241:
	__PUTD1S 6
	SBRS R16,2
	RJMP _0x197
	CALL SUBOPT_0x56
	CALL __CPD20
	BRGE _0x198
	CALL SUBOPT_0x52
	CALL __ANEGD1
	CALL SUBOPT_0x51
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x198:
	LDD  R30,Y+19
	CPI  R30,0
	BREQ _0x199
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x19A
_0x199:
	ANDI R16,LOW(251)
_0x19A:
_0x197:
	MOV  R19,R20
_0x183:
	SBRC R16,0
	RJMP _0x19B
_0x19C:
	CP   R17,R21
	BRSH _0x19F
	CP   R19,R21
	BRLO _0x1A0
_0x19F:
	RJMP _0x19E
_0x1A0:
	SBRS R16,7
	RJMP _0x1A1
	SBRS R16,2
	RJMP _0x1A2
	ANDI R16,LOW(251)
	LDD  R18,Y+19
	SUBI R17,LOW(1)
	RJMP _0x1A3
_0x1A2:
	LDI  R18,LOW(48)
_0x1A3:
	RJMP _0x1A4
_0x1A1:
	LDI  R18,LOW(32)
_0x1A4:
	CALL SUBOPT_0x4E
	CALL __put_G4
	SUBI R21,LOW(1)
	RJMP _0x19C
_0x19E:
_0x19B:
_0x1A5:
	CP   R17,R20
	BRSH _0x1A7
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1A8
	CALL SUBOPT_0x57
	BREQ _0x1A9
	SUBI R21,LOW(1)
_0x1A9:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x1A8:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x50
	CALL __put_G4
	CPI  R21,0
	BREQ _0x1AA
	SUBI R21,LOW(1)
_0x1AA:
	SUBI R20,LOW(1)
	RJMP _0x1A5
_0x1A7:
	MOV  R19,R17
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x1AB
_0x1AC:
	CPI  R19,0
	BREQ _0x1AE
	SBRS R16,3
	RJMP _0x1AF
	CALL SUBOPT_0x53
	LPM  R30,Z
	RJMP _0x242
_0x1AF:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x242:
	ST   -Y,R30
	__GETW1SX 87
	CALL SUBOPT_0x28
	CALL __put_G4
	CPI  R21,0
	BREQ _0x1B1
	SUBI R21,LOW(1)
_0x1B1:
	SUBI R19,LOW(1)
	RJMP _0x1AC
_0x1AE:
	RJMP _0x1B2
_0x1AB:
_0x1B4:
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x56
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x1B6
	SBRS R16,3
	RJMP _0x1B7
	SUBI R18,-LOW(55)
	RJMP _0x1B8
_0x1B7:
	SUBI R18,-LOW(87)
_0x1B8:
	RJMP _0x1B9
_0x1B6:
	SUBI R18,-LOW(48)
_0x1B9:
	SBRC R16,4
	RJMP _0x1BB
	CPI  R18,49
	BRSH _0x1BD
	CALL SUBOPT_0x33
	__CPD2N 0x1
	BRNE _0x1BC
_0x1BD:
	RJMP _0x1BF
_0x1BC:
	CP   R20,R19
	BRSH _0x243
	CP   R21,R19
	BRLO _0x1C2
	SBRS R16,0
	RJMP _0x1C3
_0x1C2:
	RJMP _0x1C1
_0x1C3:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x1C4
_0x243:
	LDI  R18,LOW(48)
_0x1BF:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1C5
	CALL SUBOPT_0x57
	BREQ _0x1C6
	SUBI R21,LOW(1)
_0x1C6:
_0x1C5:
_0x1C4:
_0x1BB:
	CALL SUBOPT_0x4E
	CALL __put_G4
	CPI  R21,0
	BREQ _0x1C7
	SUBI R21,LOW(1)
_0x1C7:
_0x1C1:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x56
	CALL __MODD21U
	CALL SUBOPT_0x51
	LDD  R30,Y+18
	LDI  R31,0
	CALL SUBOPT_0x33
	CALL __CWD1
	CALL __DIVD21U
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3B
	CALL __CPD10
	BREQ _0x1B5
	RJMP _0x1B4
_0x1B5:
_0x1B2:
	SBRS R16,0
	RJMP _0x1C8
_0x1C9:
	CPI  R21,0
	BREQ _0x1CB
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x50
	CALL __put_G4
	RJMP _0x1C9
_0x1CB:
_0x1C8:
_0x1CC:
_0x16A:
_0x240:
	LDI  R17,LOW(0)
_0x14B:
	RJMP _0x146
_0x148:
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
	CALL __print_G4
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G6:
	.BYTE 0x4

	.CSEG
__lcd_delay_G6:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	CALL __lcd_delay_G6
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G6
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G6
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G6
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G6:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G6
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G6
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G6
    ld    r26,y
    swap  r26
	CALL __lcd_write_nibble_G6
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G6:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G6
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G6
    andi  r30,0xf0
	RET
_lcd_read_byte0_G6:
	CALL __lcd_delay_G6
	CALL __lcd_read_nibble_G6
    mov   r26,r30
	CALL __lcd_read_nibble_G6
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G6)
	SBCI R31,HIGH(-__base_y_G6)
	LD   R30,Z
	MOV  R26,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x2A
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R7,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R4,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R4
	CP   R6,R4
	BRSH _0x219
	__lcd_putchar1:
	INC  R7
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R7
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x219:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_puts:
	ST   -Y,R17
_0x21A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x21C
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x21A
_0x21C:
	LDD  R17,Y+0
	RJMP _0x230
_lcd_putsf:
	ST   -Y,R17
_0x21D:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x21F
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x21D
_0x21F:
	LDD  R17,Y+0
_0x230:
	ADIW R28,3
	RET
__long_delay_G6:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G6:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G6
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G6,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G6,3
	CALL SUBOPT_0x58
	CALL SUBOPT_0x58
	CALL SUBOPT_0x58
	CALL __long_delay_G6
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G6
	CALL __long_delay_G6
	LDI  R30,LOW(40)
	CALL SUBOPT_0x59
	LDI  R30,LOW(4)
	CALL SUBOPT_0x59
	LDI  R30,LOW(133)
	CALL SUBOPT_0x59
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G6
	CPI  R30,LOW(0x5)
	BREQ _0x220
	LDI  R30,LOW(0)
	RJMP _0x22F
_0x220:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x22F:
	ADIW R28,1
	RET
_rtc_read:
	ST   -Y,R17
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x22E
_rtc_write:
	CALL SUBOPT_0x5A
	LD   R30,Y
	CALL SUBOPT_0x5D
_0x22E:
	ADIW R28,2
	RET
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x221
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x221:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x222
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x222:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5D
	RJMP _0x22D
_rtc_get_time:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x60
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0x60
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x60
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x61
	ADIW R28,8
	RET
_rtc_set_time:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(0)
	CALL SUBOPT_0x62
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x63
	LDD  R30,Y+3
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
	RJMP _0x22B
_rtc_get_date:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x60
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x60
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x61
	ADIW R28,6
	RET
_rtc_set_date:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5F
	ST   -Y,R30
	CALL _bin2bcd
	CALL SUBOPT_0x62
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0x64
_0x22D:
	ADIW R28,3
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x56
	CALL __CPD02
	BRLT _0x223
	__GETD1N 0xFF7FFFFF
	RJMP _0x22C
_0x223:
	CALL SUBOPT_0x52
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x51
	CALL SUBOPT_0x56
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x224
	CALL SUBOPT_0x52
	CALL SUBOPT_0x56
	CALL __ADDF12
	CALL SUBOPT_0x51
	__SUBWRN 16,17,1
_0x224:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x34
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x52
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	CALL SUBOPT_0x56
	CALL __MULF12
	CALL SUBOPT_0x40
	__GETD1S 2
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x34
	CALL SUBOPT_0x56
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 2
	__GETD1N 0x3FD4114D
	CALL SUBOPT_0x34
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL SUBOPT_0x46
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x22C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_log10:
	__GETD2S 0
	CALL __CPD02
	BRLT _0x225
	__GETD1N 0xFF7FFFFF
	RJMP _0x22B
_0x225:
	CALL SUBOPT_0x39
	CALL __PUTPARD1
	CALL _log
	__GETD2N 0x3EDE5BD9
	CALL __MULF12
_0x22B:
	ADIW R28,4
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
_p_S88:
	.BYTE 0x2

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	CALL __LNEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	IN   R5,22
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __DIVB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __MODB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R21
	LDI  R30,LOW(10)
	CALL __DIVB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R21
	LDI  R30,LOW(10)
	CALL __MODB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R20
	LDI  R30,LOW(10)
	CALL __DIVB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R20
	LDI  R30,LOW(10)
	CALL __MODB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x6:
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	__POINTW1FN _0,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	__GETD1N 0xDF
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _lcd_puts
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,25
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,23
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDD  R30,Y+42
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	SUBI R30,LOW(-_w_time)
	SBCI R31,HIGH(-_w_time)
	LD   R21,Z
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	__ADDW1MN _w_time,1
	LD   R20,Z
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R30,R0
	__ADDW1MN _w_time,2
	LD   R30,Z
	STD  Y+10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R26,R21
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1E:
	CALL __MODB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(10)
	CALL __DIVB21U
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _set_values

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R31,0
	ADD  R21,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	__GETD1S 35
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(204)
	ST   -Y,R30
	JMP  _therm_write_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R31,0
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	__DELAY_USB 3
	SBI  0x15,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	CBI  0x15,2
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	SBI  0x15,2
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _s_read_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	CALL _s_write_byte
	LDI  R31,0
	ADD  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	ST   -Y,R30
	CALL _s_write_byte
	LDI  R31,0
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x32:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x33:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x34:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	__GETD2S 16
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	CALL __ADDF12
	__PUTD1S 4
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x37:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x38:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	__GETD1S 2
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__GETD2S 2
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x47:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x38
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x33
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x33
	__GETD1N 0x41200000
	CALL __DIVF21
	RCALL SUBOPT_0x32
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4E:
	ST   -Y,R18
	__GETW1SX 87
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4F:
	MOVW R26,R28
	SUBI R26,LOW(-(88))
	SBCI R27,HIGH(-(88))
	LD   R30,X+
	LD   R31,X+
	SBIW R30,4
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x50:
	ST   -Y,R30
	__GETW1SX 87
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x52:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x54:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	ADIW R30,4
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x56:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x57:
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
	CALL __put_G4
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	CALL __long_delay_G6
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5A:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5D:
	ST   -Y,R30
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5E:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x60:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	ST   -Y,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x62:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	LD   R30,Y
	ST   -Y,R30
	CALL _bin2bcd
	RJMP SUBOPT_0x5D


	.DSEG
_123:
	.BYTE 0x0F
_124:
	.BYTE 0x08
_171:
	.BYTE 0x47
_200:
	.BYTE 0x1C

	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
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

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
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

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LNEGW1:
	SBIW R30,0
	LDI  R30,1
	LDI  R31,0
	BREQ __LNEGW1F
	CLR  R30
__LNEGW1F:
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

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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
