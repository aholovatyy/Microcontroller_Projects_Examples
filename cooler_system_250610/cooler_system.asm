
;CodeVisionAVR C Compiler V1.25.8 Professional
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
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
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

	.INCLUDE "cooler_system.vec"
	.INCLUDE "cooler_system.inc"

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
;       2 Project : COOLER SYSTEM
;       3 Version : version 2.1 developed in CodeVisionAVR v1.25.8
;       4 Date    : 25.06.2010
;       5 Author  : Ihor Holovatyy
;       6 Company : INTEGRAL
;       7 Comments: this program is used for cooler system designed on the base of AVR ATmega32 microcontroller
;       8 
;       9 Chip type           : ATmega32
;      10 Program type        : Application
;      11 Clock frequency     : 8,000000 MHz
;      12 Memory model        : Small
;      13 External SRAM size  : 0
;      14 Data Stack size     : 512
;      15 *****************************************************/
;      16 
;      17 #include <mega32.h>
;      18 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      19 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      20 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;      21 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;      22 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      23 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      24 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;      25 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;      26 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      27 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      28 	#endif
	#endif
;      29 #include <stdio.h>
;      30 #include <delay.h>
;      31 #include <lcd.h> // функції LCD
;      32 #include "therm_ds18b20.h"
;      33 
;      34 /*#ifndef F_CPU
;      35 	#define F_CPU 8000000UL 	//частота тактового генератора в Гц (8 МГц тут)
;      36 #endif*/
;      37 
;      38 /*
;      39 #define T_IN_FAN_ON 22     		//внутрішня температура вмикання FAN
;      40 #define T_IN_FAN_OFF 20			//внутрішня температура вимикання FAN
;      41 #define T_OUT_FAN_OFF 26		//зовнішня температура виключення FAN
;      42 
;      43 #define T_OUT_SHU_OFF_MAX 26	//максимальна зовнішня температура закриття заслонки
;      44 #define T_OUT_SHU_OFF_MIN 10	//мінімальна зовнішня температура закриття заслонки
;      45 
;      46 #define T_IN_CON_ON_MAX 26		//максимальна внутрішня температура включення кондиціонера
;      47 #define T_IN_CON_ON_MIN 10		//мінімальна внутрішня температура включення кондиціонера
;      48 #define T_OUT_CON_ON 10			//зовнішня температура включення кондиціонера
;      49 */
;      50 
;      51 //кнопка exit/mode change
;      52 #define BTN_PORT PORTB
;      53 #define BTN_PORT_DDR DDRB
;      54 #define BTN_PIN PINB
;      55 #define BTN 1
;      56 //світлодіод на кнопку exit/mode change
;      57 #define BTN_LED_PORT PORTD
;      58 #define BTN_LED_PORT_DDR DDRD
;      59 #define BTN_LED 6
;      60 //алярмова кнопка
;      61 #define T_ALARM 37
;      62 #define ALRM_BTN_PORT PORTB
;      63 #define ALRM_BTN_PORT_DDR DDRB
;      64 #define ALRM_BTN_PIN PINB
;      65 #define ALRM_BTN 0
;      66 //вентилятор
;      67 #define FAN_PORT PORTD
;      68 #define FAN_PORT_DDR DDRD
;      69 #define FAN 3
;      70 #define LED_FAN 0
;      71 //заслонка
;      72 #define SHU_PORT PORTD
;      73 #define SHU_PORT_DDR DDRD
;      74 #define SHU 4
;      75 #define LED_SHU 1
;      76 //кондиціонер
;      77 #define CON_PORT PORTD
;      78 #define CON_PORT_DDR DDRD
;      79 #define CON 5
;      80 #define LED_CON 2
;      81 #define COND_PORT PORTC
;      82 #define COND_PORT_DDR DDRC
;      83 #define COND 6
;      84 #define NORMAL 7
;      85 //кнопки настройки MENU/ENTER, SELECT+, SELECT-
;      86 #define BTNS_PORT PORTC
;      87 #define BTNS_PORT_DDR DDRC
;      88 #define MENU_ENTER_BTN 3
;      89 #define SELECT_PLUS_BTN 4
;      90 #define SELECT_MINUS_BTN 5
;      91 
;      92 #asm
;      93     .equ __lcd_port=0x1b // порт піключення LCD, PORTA
    .equ __lcd_port=0x1b // порт піключення LCD, PORTA
;      94 #endasm
;      95 
;      96 #define CS10   0
;      97 #define CS11   1
;      98 #define CS12   2
;      99 #define OCIE1A 4 //біт дозволу переривання при досягненні значення в лічильнику рівного значенню в рег. A
;     100 
;     101 char /*lcd_buffer[5][33],*/ buffer[33];
_buffer:
	.BYTE 0x21
;     102 uint8_t mode=0, seconds=0;
;     103 bit fan=0, con=0, alarmBtnState=0, button_pressed=0;
;     104 float tinf=0.0f, toutf=0.0f;
_tinf:
	.BYTE 0x4
_toutf:
	.BYTE 0x4
;     105 char tin=0, tout=0;
;     106 
;     107 unsigned char PREV_PINC=0xff;
;     108 
;     109 char temp[]={
_temp:
;     110     26, /* T_OUT_FAN_OFF зовнішня температура виключення FAN */
;     111     22, /* T_IN_FAN_ON внутрішня температура вмикання FAN */
;     112     20, /* T_IN_FAN_OFF внутрішня температура вимикання FAN */
;     113     26, /* T_OUT_SHU_OFF_MAX максимальна зовнішня температура закриття заслонки */
;     114     10, /* T_OUT_SHU_OFF_MIN мінімальна зовнішня температура закриття заслонки */
;     115     26, /* T_IN_CON_ON_MAX максимальна внутрішня температура включення кондиціонера */
;     116     10, /* T_IN_CON_ON_MIN мінімальна внутрішня температура включення кондиціонера */
;     117     10, /* T_OUT_CON_ON зовнішня температура включення кондиціонера */
;     118     37  /* T_ALARM аварійна температура виключення вентилятора (FAN) і заслонки (SHU) */
;     119 }; // temperatures
	.BYTE 0x9
;     120 
;     121 unsigned char get_key_status(unsigned char key)
;     122 {

	.CSEG
_get_key_status:
;     123   return (!(PINC & (1<<key)));
;	key -> Y+0
	IN   R1,19
	LD   R30,Y
	CALL SUBOPT_0x0
	CALL __LNEGB1
	RJMP _0x1C1
;     124 }
;     125 
;     126 unsigned char get_prev_key_status(unsigned char key)
;     127 {
_get_prev_key_status:
;     128   return (!(PREV_PINC & (1<<key)));
;	key -> Y+0
	LD   R30,Y
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R9
	CALL __LNEGB1
_0x1C1:
	ADIW R28,1
	RET
;     129 }
;     130 
;     131 void enter_temp(int sel)
;     132 {
_enter_temp:
;     133   char items[9][10]={"FAN T1=", "FAN T2=", "FAN T3=", "SHU T4=", "SHU T5=", "CON T6=", "CON T7=", "CON T8=", "ALARM T9="};
;     134   char t=temp[sel];
;     135 
;     136   while(1)
	SBIW R28,63
	SBIW R28,27
	LDI  R24,90
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x5*2)
	LDI  R31,HIGH(_0x5*2)
	CALL __INITLOCB
	ST   -Y,R17
;	sel -> Y+91
;	items -> Y+1
;	t -> R17
	CALL SUBOPT_0x1
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	MOV  R17,R30
_0x6:
;     137   {
;     138     PREV_PINC=PINC;
	IN   R9,19
;     139 
;     140     lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
;     141     lcd_puts(items[sel]);
	CALL SUBOPT_0x1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0x3
;     142     lcd_putchar((48+t/10));
	MOV  R26,R17
	LDI  R30,LOW(10)
	CALL __DIVB21U
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
;     143     lcd_putchar((48+t%10));
	MOV  R26,R17
	LDI  R30,LOW(10)
	CALL __MODB21U
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
;     144     lcd_putsf("   ");
	__POINTW1FN _0,0
	CALL SUBOPT_0x4
;     145     delay_ms(50);
	CALL SUBOPT_0x5
;     146 
;     147     if (get_key_status(SELECT_PLUS_BTN))  //select+
	BREQ _0x9
;     148     {
;     149       if (!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
	BRNE _0xA
;     150       {
;     151         if (t<60)
	CPI  R17,60
	BRSH _0xB
;     152           t++;
	SUBI R17,-1
;     153       }
_0xB:
;     154     }
_0xA:
;     155 
;     156     if (get_key_status(SELECT_MINUS_BTN)) //select-
_0x9:
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
	BREQ _0xC
;     157     {
;     158       if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(5)
	CALL SUBOPT_0x6
	BRNE _0xD
;     159       {
;     160         if (t>10)
	CPI  R17,11
	BRLO _0xE
;     161           t--;
	SUBI R17,1
;     162       }
_0xE:
;     163     }
_0xD:
;     164 
;     165     if (get_key_status(MENU_ENTER_BTN)) //enter
_0xC:
	LDI  R30,LOW(3)
	CALL SUBOPT_0x7
	BREQ _0xF
;     166     {
;     167       if (!get_prev_key_status(MENU_ENTER_BTN))
	LDI  R30,LOW(3)
	CALL SUBOPT_0x6
	BRNE _0x10
;     168       {
;     169         if (t!=temp[sel])
	CALL SUBOPT_0x8
	LD   R30,Z
	CP   R30,R17
	BREQ _0x11
;     170           temp[sel]=t;
	CALL SUBOPT_0x8
	ST   Z,R17
;     171         if (sel==8) sel=0;
_0x11:
	__GETW2SX 91
	SBIW R26,8
	BRNE _0x12
	__CLRW1SX 91
;     172         else sel++;
	RJMP _0x13
_0x12:
	MOVW R26,R28
	SUBI R26,LOW(-(91))
	SBCI R27,HIGH(-(91))
	CALL SUBOPT_0x9
;     173         t=temp[sel];
_0x13:
	CALL SUBOPT_0x8
	LD   R17,Z
;     174       }
;     175     }
_0x10:
;     176 
;     177     if (!(BTN_PIN & (1<<BTN))) //exit
_0xF:
	SBIC 0x16,1
	RJMP _0x14
;     178       return;
	LDD  R17,Y+0
	RJMP _0x1C0
;     179 
;     180   }
_0x14:
	RJMP _0x6
;     181 }
_0x1C0:
	ADIW R28,63
	ADIW R28,30
	RET
;     182 
;     183 void show_main_menu(void)
;     184 {
_show_main_menu:
;     185   char menu_items[9][3]={"T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9"};
;     186   int selected=0;
;     187   lcd_gotoxy(3,0);
	SBIW R28,27
	LDI  R24,27
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x15*2)
	LDI  R31,HIGH(_0x15*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	menu_items -> Y+2
;	selected -> R16,R17
	LDI  R16,0
	LDI  R17,0
	LDI  R30,LOW(3)
	CALL SUBOPT_0xA
;     188   lcd_putsf("MAIN MENU");
	__POINTW1FN _0,4
	CALL SUBOPT_0x4
;     189 
;     190   while(1)
_0x16:
;     191   {
;     192     PREV_PINC=PINC;
	IN   R9,19
;     193     lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;     194     lcd_puts(menu_items[selected]);
	__MULBNWRU 16,17,3
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x3
;     195     delay_ms(50);
	CALL SUBOPT_0x5
;     196 
;     197     if (get_key_status(SELECT_PLUS_BTN))  //select+
	BREQ _0x19
;     198     {
;     199       if (!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
	BRNE _0x1A
;     200       {
;     201         if (selected!=8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x1B
;     202           selected++;
	__ADDWRN 16,17,1
;     203       }
_0x1B:
;     204     }
_0x1A:
;     205 
;     206     if (get_key_status(SELECT_MINUS_BTN)) //select-
_0x19:
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
	BREQ _0x1C
;     207     {
;     208       if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(5)
	CALL SUBOPT_0x6
	BRNE _0x1D
;     209       {
;     210         if (selected!=0)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x1E
;     211           selected--;
	__SUBWRN 16,17,1
;     212       }
_0x1E:
;     213     }
_0x1D:
;     214 
;     215     if (get_key_status(MENU_ENTER_BTN)) //enter
_0x1C:
	LDI  R30,LOW(3)
	CALL SUBOPT_0x7
	BREQ _0x1F
;     216     {
;     217       if (!get_prev_key_status(MENU_ENTER_BTN))
	LDI  R30,LOW(3)
	CALL SUBOPT_0x6
	BRNE _0x20
;     218       {
;     219         lcd_clear();
	CALL _lcd_clear
;     220         enter_temp(selected);
	ST   -Y,R17
	ST   -Y,R16
	CALL _enter_temp
;     221       }
;     222     }
_0x20:
;     223 
;     224     if (!(BTN_PIN & (1<<BTN))) //exit
_0x1F:
	SBIC 0x16,1
	RJMP _0x21
;     225     {
;     226       button_pressed=1;
	SET
	BLD  R2,3
;     227       return;
	RJMP _0x1BF
;     228     }
;     229 
;     230   }
_0x21:
	RJMP _0x16
;     231 }
_0x1BF:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,29
	RET
;     232 
;     233 //робочий алгоритм роботи COOLER SYSTEM
;     234 void working_algorithm(void)
;     235 {
_working_algorithm:
;     236 	//управління кондиціонером
;     237     if (tin >= temp[5] || tin <= temp[6] || tout <= temp[7])
	__GETB1MN _temp,5
	CP   R7,R30
	BRSH _0x23
	__GETB1MN _temp,6
	CP   R30,R7
	BRSH _0x23
	__GETB1MN _temp,7
	CP   R30,R6
	BRLO _0x22
_0x23:
;     238     {
;     239 		CON_PORT&=~(1<<CON);
	CBI  0x12,5
;     240 		CON_PORT|=1<<LED_CON; //con=1;
	SBI  0x12,2
;     241 		con=1;
	SET
	BLD  R2,1
;     242 		SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
	CALL SUBOPT_0xB
;     243 		FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
;     244 		fan=0;
	RJMP _0x1C2
;     245 	}
;     246 	else
_0x22:
;     247 	{
;     248 	    if (tin <= (temp[5]-2) || tout >= (temp[7]+2))
	__GETB1MN _temp,5
	SUBI R30,LOW(2)
	CP   R30,R7
	BRSH _0x27
	__GETB1MN _temp,7
	SUBI R30,-LOW(2)
	CP   R6,R30
	BRLO _0x26
_0x27:
;     249 	    {
;     250 	        CON_PORT|=1<<CON;
	SBI  0x12,5
;     251 	        CON_PORT&=~(1<<LED_CON); //con=0;
	CBI  0x12,2
;     252 	        con=0;
	CLT
	BLD  R2,1
;     253 	        //управління заслонкою
;     254 	        if (tout >= temp[3] || tout <= temp[4])
	__GETB1MN _temp,3
	CP   R6,R30
	BRSH _0x2A
	__GETB1MN _temp,4
	CP   R30,R6
	BRLO _0x29
_0x2A:
;     255 	        {
;     256 	            SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU); //shu=0; заслонка закрита
	CALL SUBOPT_0xB
;     257 	            FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
;     258 		        fan=0;
	RJMP _0x1C2
;     259             }
;     260 	        else
_0x29:
;     261 	        {
;     262 	            SHU_PORT|=(1<<SHU|1<<LED_SHU); //shu=1;
	IN   R30,0x12
	ORI  R30,LOW(0x12)
	OUT  0x12,R30
;     263 	            //управління FAN
;     264 	            if (tout >= temp[0] || (fan==1 && tin <= temp[2]))
	LDS  R30,_temp
	CP   R6,R30
	BRSH _0x2E
	SBRS R2,0
	RJMP _0x2F
	__GETB1MN _temp,2
	CP   R30,R7
	BRSH _0x2E
_0x2F:
	RJMP _0x2D
_0x2E:
;     265 	            {
;     266 		            FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	CALL SUBOPT_0xC
;     267 		            fan=0;
	RJMP _0x1C2
;     268 	            }
;     269 	            else if (fan==0 && tin >= temp[1])
_0x2D:
	SBRC R2,0
	RJMP _0x34
	__GETB1MN _temp,1
	CP   R7,R30
	BRSH _0x35
_0x34:
	RJMP _0x33
_0x35:
;     270 	            {
;     271 	                FAN_PORT|=1<<FAN|1<<LED_FAN;
	IN   R30,0x12
	ORI  R30,LOW(0x9)
	OUT  0x12,R30
;     272 		            fan=1;
	SET
_0x1C2:
	BLD  R2,0
;     273 	            }
;     274 	         }
_0x33:
;     275 	    }
;     276 	}
_0x26:
;     277    /* if (i==0)
;     278 	  sprintf(lcd_buffer[0], "Tin: %+.1f%cC   \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf);
;     279 	lcd_gotoxy(0,0);
;     280 	lcd_puts(lcd_buffer[i]); */
;     281 	switch (mode)
	MOV  R30,R5
;     282 	{
;     283 	  case 0: sprintf(buffer, "Tin: %+.1f%cC    \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf); break;
	CPI  R30,0
	BRNE _0x39
	CALL SUBOPT_0xD
	__POINTW1FN _0,14
	CALL SUBOPT_0xE
	RJMP _0x38
;     284 	  case 1: sprintf(buffer, "FAN T1=%d T2=%d\nT3=%d         ", temp[0], temp[1], temp[2]); break;
_0x39:
	CPI  R30,LOW(0x1)
	BRNE _0x3A
	CALL SUBOPT_0xD
	__POINTW1FN _0,50
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp
	CALL SUBOPT_0xF
	__GETB1MN _temp,1
	CALL SUBOPT_0xF
	__GETB1MN _temp,2
	CALL SUBOPT_0xF
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP _0x38
;     285 	  case 2: sprintf(buffer, "SHU T4=%d T5=%d\n             ", temp[3], temp[4]); break;
_0x3A:
	CPI  R30,LOW(0x2)
	BRNE _0x3B
	CALL SUBOPT_0xD
	__POINTW1FN _0,81
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _temp,3
	CALL SUBOPT_0xF
	__GETB1MN _temp,4
	CALL SUBOPT_0xF
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP _0x38
;     286 	  case 3: sprintf(buffer, "CON T6=%d T7=%d\nT8=%d   ", temp[5], temp[6], temp[7]); break;
_0x3B:
	CPI  R30,LOW(0x3)
	BRNE _0x3C
	CALL SUBOPT_0xD
	__POINTW1FN _0,111
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _temp,5
	CALL SUBOPT_0xF
	__GETB1MN _temp,6
	CALL SUBOPT_0xF
	__GETB1MN _temp,7
	CALL SUBOPT_0xF
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP _0x38
;     287 	  case 4: sprintf(buffer, "ALARM T9=%d    \n        ", temp[8]); break;
_0x3C:
	CPI  R30,LOW(0x4)
	BRNE _0x38
	CALL SUBOPT_0xD
	__POINTW1FN _0,136
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _temp,8
	CALL SUBOPT_0xF
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
;     288 	}
_0x38:
;     289 	lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
;     290 	lcd_puts(buffer);
	CALL SUBOPT_0xD
	CALL _lcd_puts
;     291 }
	RET
;     292 
;     293 //алярмовий алгоритм роботи COOLER SYSTEM
;     294 void alarm_algorithm(void)
;     295 {
_alarm_algorithm:
;     296 	//управління заслонкою
;     297 	if (tout >= temp[8] || tout <= temp[4])
	__GETB1MN _temp,8
	CP   R6,R30
	BRSH _0x3F
	__GETB1MN _temp,4
	CP   R30,R6
	BRLO _0x3E
_0x3F:
;     298 	{
;     299 		SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU); //shu=0; //заслонка закрита
	CALL SUBOPT_0xB
;     300 		FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
;     301 		fan=0;
	RJMP _0x1C3
;     302 	}
;     303 	else
_0x3E:
;     304 	{
;     305 	    SHU_PORT|=1<<SHU|1<<LED_SHU; //shu=1;
	IN   R30,0x12
	ORI  R30,LOW(0x12)
	OUT  0x12,R30
;     306 	    //управління FAN
;     307 	    if (tout > temp[8] || (fan==1 && tin <= temp[2]))
	__GETB1MN _temp,8
	CP   R30,R6
	BRLO _0x43
	SBRS R2,0
	RJMP _0x44
	__GETB1MN _temp,2
	CP   R30,R7
	BRSH _0x43
_0x44:
	RJMP _0x42
_0x43:
;     308 	    {
;     309 		    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	CALL SUBOPT_0xC
;     310 		    fan=0;
	RJMP _0x1C3
;     311 	    }
;     312 	    else if (fan==0 && tin >= temp[1])
_0x42:
	SBRC R2,0
	RJMP _0x49
	__GETB1MN _temp,1
	CP   R7,R30
	BRSH _0x4A
_0x49:
	RJMP _0x48
_0x4A:
;     313 	    {
;     314 	        FAN_PORT|=1<<FAN|1<<LED_FAN;
	IN   R30,0x12
	ORI  R30,LOW(0x9)
	OUT  0x12,R30
;     315 		    fan=1;
	SET
_0x1C3:
	BLD  R2,0
;     316 	    }
;     317    	}
_0x48:
;     318 	//sprintf(lcd_buffer[0], "Tin: %+.1f%cC\nTout: %+.1f%cC", tinf, 0xdf, toutf, 0xdf);
;     319 	//lcd_clear();
;     320 	sprintf(buffer, "Tin: %+.1f%cC   \nTout: %+.1f%cC   ", tinf, 0xdf, toutf, 0xdf);
	CALL SUBOPT_0xD
	__POINTW1FN _0,161
	CALL SUBOPT_0xE
;     321 	lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
;     322 	lcd_puts(buffer);
	CALL SUBOPT_0xD
	CALL _lcd_puts
;     323 }
	RET
;     324 
;     325 //функція обробки переривання від таймера
;     326 interrupt [TIM1_COMPA] void timer1_compa_isr(void) //переривання 1 раз в сек.
;     327 {
_timer1_compa_isr:
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
;     328 	/* This interrupt service routine (ISR)*/
;     329 	TCNT1H=0;
	CALL SUBOPT_0x10
;     330 	TCNT1L=0;
;     331 	if (++seconds>10)
	INC  R4
	LDI  R30,LOW(10)
	CP   R30,R4
	BRSH _0x4B
;     332 	{
;     333 		TIMSK&=~(1<<OCIE1A);
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
;     334 		mode=0;
	CLR  R5
;     335 		BTN_LED_PORT|=(1<<BTN_LED);
	SBI  0x12,6
;     336 		delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x11
;     337 		BTN_LED_PORT&=~(1<<BTN_LED);
	CBI  0x12,6
;     338 	}
;     339 }
_0x4B:
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
;     340 
;     341 void print_message_alarm220(void)
;     342 {
_print_message_alarm220:
;     343   static bit ac=0;
;     344   lcd_gotoxy(14,0);
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA
;     345   if (ac)
	SBRS R2,4
	RJMP _0x4C
;     346   {
;     347     lcd_putsf("  ");
	__POINTW1FN _0,1
	CALL SUBOPT_0x4
;     348     ac=0;
	CLT
	RJMP _0x1C4
;     349   }
;     350   else
_0x4C:
;     351   {
;     352     lcd_putsf("AC"); // AC ERROR 220V
	__POINTW1FN _0,196
	CALL SUBOPT_0x4
;     353     ac=1;
	SET
_0x1C4:
	BLD  R2,4
;     354   }
;     355 }
	RET
;     356 
;     357 //#pragma rl+
;     358 // Declare your global variables here
;     359 int main(void)
;     360 {
_main:
;     361     //char title[]="СИСТЕМА\n  ОХОЛОДЖЕННЯ";
;     362 	char title[]="COOLER SYSTEM";
;     363 	//char firm[]="IНТЕГРАЛ";
;     364 	char firm[]="INTEGRAL";
;     365     uint8_t meas_res_tin, meas_res_tout;
;     366 
;     367 	/*sprintf(lcd_buffer[1], "FAN T1=%d T2=%d\nT3=%d         ", T_OUT_FAN_OFF, T_IN_FAN_ON, T_IN_FAN_OFF);
;     368 	sprintf(lcd_buffer[2], "SHU T4=%d T5=%d\n             ", T_OUT_SHU_OFF_MAX, T_OUT_SHU_OFF_MIN);
;     369 	sprintf(lcd_buffer[3], "CON T6=%d T7=%d\nT8=%d   ", T_IN_CON_ON_MAX, T_IN_CON_ON_MIN, T_OUT_CON_ON);
;     370 	sprintf(lcd_buffer[4], "ALARM T9=%d    \n        ", T_ALARM);
;     371 	*/
;     372 
;     373 	//ініціалізація кнопок
;     374     BTN_PORT|=(1<<BTN_PIN);
	SBIW R28,23
	LDI  R24,23
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x4E*2)
	LDI  R31,HIGH(_0x4E*2)
	CALL __INITLOCB
;	title -> Y+9
;	firm -> Y+0
;	meas_res_tin -> R17
;	meas_res_tout -> R16
	CALL SUBOPT_0x12
;     375 	BTN_PORT_DDR&=~(1<<BTN_PIN);
;     376 	ALRM_BTN_PORT|=(1<<ALRM_BTN_PIN);
	CALL SUBOPT_0x12
;     377 	ALRM_BTN_PORT_DDR&=~(1<<ALRM_BTN_PIN);
;     378 	//ініціалізація управляючих пристроїв
;     379 	FAN_PORT_DDR|=(1<<FAN)|(1<<LED_FAN);
	IN   R30,0x11
	ORI  R30,LOW(0x9)
	OUT  0x11,R30
;     380 	FAN_PORT=0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     381 	SHU_PORT_DDR|=(1<<SHU)|(1<<LED_SHU);
	IN   R30,0x11
	ORI  R30,LOW(0x12)
	OUT  0x11,R30
;     382 	SHU_PORT=0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     383 	CON_PORT_DDR|=(1<<CON)|(1<<LED_CON);
	IN   R30,0x11
	ORI  R30,LOW(0x24)
	OUT  0x11,R30
;     384 	CON_PORT=1<<CON;
	LDI  R30,LOW(32)
	OUT  0x12,R30
;     385 	BTNS_PORT=(1<<MENU_ENTER_BTN)|(1<<SELECT_PLUS_BTN)|(1<<SELECT_MINUS_BTN);
	LDI  R30,LOW(56)
	OUT  0x15,R30
;     386 	BTNS_PORT_DDR&=~(1<<MENU_ENTER_BTN)&~(1<<SELECT_PLUS_BTN)&~(1<<SELECT_MINUS_BTN);
	IN   R30,0x14
	ANDI R30,LOW(0xC7)
	OUT  0x14,R30
;     387 	COND_PORT_DDR|=(1<<COND)|(1<<NORMAL);
	IN   R30,0x14
	ORI  R30,LOW(0xC0)
	OUT  0x14,R30
;     388 	COND_PORT|=(1<<COND)|(1<<NORMAL);
	IN   R30,0x15
	ORI  R30,LOW(0xC0)
	OUT  0x15,R30
;     389 	BTN_LED_PORT_DDR|=(1<<BTN_LED);
	SBI  0x11,6
;     390 	BTN_PORT=0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     391     //ініціалізація 16 бітного таймера
;     392 	TCCR1A=0x00;
	OUT  0x2F,R30
;     393 	TCCR1B=0x04; //1<<CS12|~(1<<CS11)|~(1<<CS10);  //clk/256, 8MHz/256=31250Hz, TCCR1B=0x04
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     394 	TCNT1H=0x00;
	CALL SUBOPT_0x10
;     395 	TCNT1L=0x00;
;     396 	ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
;     397 	ICR1L=0x00;
	OUT  0x26,R30
;     398 	OCR1AH=0x7A; //high byte of 31250=7A, high byte has to be written before low byte
	LDI  R30,LOW(122)
	OUT  0x2B,R30
;     399 	OCR1AL=0x12; //low byte of 31250=12
	LDI  R30,LOW(18)
	OUT  0x2A,R30
;     400 	OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;     401 	OCR1BL=0x00;
	OUT  0x28,R30
;     402 	//ініціалізація зовнішніх переривань
;     403 	//INT0: Off; INT1: Off
;     404 	GICR=0x00;
	OUT  0x3B,R30
;     405 	MCUCR=0x00;
	OUT  0x35,R30
;     406 	//маскування переривання
;     407 	TIMSK&=~(1<<OCIE1A); //TIMSK=0x10;
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
;     408 	//Analog Comparator initialization; Analog Comparator: Off; Analog Comparator Input capture by Timer/Counter 1: Off
;     409 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     410 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     411 	//дозволяємо переривання
;     412 	#asm("sei");
	sei
;     413 	//ініціалізація LCD
;     414     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;     415 	//вивід на LCD COOLER SYSTEM i INTEGRAL
;     416 	lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
;     417 	lcd_puts(title);
	MOVW R30,R28
	ADIW R30,9
	CALL SUBOPT_0x13
;     418 	delay_ms(1000);
;     419 	lcd_clear();
	CALL _lcd_clear
;     420 	lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xA
;     421 	lcd_puts(firm);
	MOVW R30,R28
	CALL SUBOPT_0x13
;     422 	delay_ms(1000);
;     423 	//ініціалізація давачів температури
;     424 	if (therm_init(0, -55, 125, THERM_9BIT_RES))
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
	BREQ _0x4F
;     425 	{
;     426 	    lcd_clear();
	CALL _lcd_clear
;     427 	    lcd_putsf("Init error\nindoor sensor");
	__POINTW1FN _0,199
	CALL SUBOPT_0x4
;     428 	    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	CALL SUBOPT_0xC
;     429 	    fan=0;
	CALL SUBOPT_0x15
;     430 	    SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
;     431 	    CON_PORT&=~(1<<CON);
;     432 	    CON_PORT|=1<<LED_CON;
;     433 	    COND_PORT&=~(1<<COND)&~(1<<NORMAL);
;     434 	    while(1);
_0x50:
	RJMP _0x50
;     435 	}
;     436 	if (therm_init(1, -55, 125, THERM_9BIT_RES))
_0x4F:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x14
	BREQ _0x53
;     437 	{
;     438 	    lcd_clear();
	CALL _lcd_clear
;     439 	    lcd_putsf("Init error\noutdoor sensor");
	__POINTW1FN _0,224
	CALL SUBOPT_0x4
;     440 	    FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	CALL SUBOPT_0xC
;     441 	    fan=0;
	CALL SUBOPT_0x15
;     442 	    SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
;     443 	    CON_PORT&=~(1<<CON);
;     444 	    CON_PORT|=1<<LED_CON;
;     445 	    COND_PORT&=~(1<<COND)&~(1<<NORMAL);
;     446 	    while(1);
_0x54:
	RJMP _0x54
;     447 	}
;     448 	// main loop starts here
;     449 	while(1)
_0x53:
_0x57:
;     450 	{
;     451 		//перевіряємо чи непропало живлення
;     452 		if ((ALRM_BTN_PIN & 1<<ALRM_BTN)==0 && alarmBtnState==0)
	SBIC 0x16,0
	RJMP _0x5B
	SBRS R2,2
	RJMP _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
;     453 		  alarmBtnState=1;
	SET
	BLD  R2,2
;     454 		if ((ALRM_BTN_PIN & 1<<ALRM_BTN) && alarmBtnState==1)
_0x5A:
	SBIS 0x16,0
	RJMP _0x5E
	SBRC R2,2
	RJMP _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
;     455 		{
;     456 		  alarmBtnState=0;
	CLT
	BLD  R2,2
;     457    	      lcd_gotoxy(14,0);
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA
;     458           lcd_putsf("  ");
	__POINTW1FN _0,1
	CALL SUBOPT_0x4
;     459 		}
;     460 		//міряємо температуру з давачів
;     461 		meas_res_tin=therm_read_temperature(0,&tinf);
_0x5D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_tinf)
	LDI  R31,HIGH(_tinf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _therm_read_temperature
	MOV  R17,R30
;     462 		meas_res_tout=therm_read_temperature(1,&toutf);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_toutf)
	LDI  R31,HIGH(_toutf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _therm_read_temperature
	MOV  R16,R30
;     463 		if (meas_res_tin || meas_res_tout)
	CPI  R17,0
	BRNE _0x61
	CPI  R16,0
	BRNE _0x61
	RJMP _0x60
_0x61:
;     464 		{
;     465 			FAN_PORT&=~(1<<FAN)&~(1<<LED_FAN);
	CALL SUBOPT_0xC
;     466 			fan=0;
	BLD  R2,0
;     467 			SHU_PORT&=~(1<<SHU)&~(1<<LED_SHU);
	IN   R30,0x12
	ANDI R30,LOW(0xED)
	OUT  0x12,R30
;     468 			CON_PORT&=~(1<<CON);
	CBI  0x12,5
;     469 			CON_PORT|=1<<LED_CON;
	SBI  0x12,2
;     470 			COND_PORT&=~(1<<NORMAL);
	CBI  0x15,7
;     471 			lcd_clear();
	CALL _lcd_clear
;     472 			if (meas_res_tin && meas_res_tout)
	CPI  R17,0
	BREQ _0x64
	CPI  R16,0
	BRNE _0x65
_0x64:
	RJMP _0x63
_0x65:
;     473 		        lcd_putsf("Tin error\nTout error");
	__POINTW1FN _0,250
	CALL SUBOPT_0x4
;     474 			else
	RJMP _0x66
_0x63:
;     475 			{
;     476 			    if (meas_res_tin)
	CPI  R17,0
	BREQ _0x67
;     477 			      sprintf(buffer, "Tin error\nTout: %+.1f%cC", toutf, 0xdf);
	CALL SUBOPT_0xD
	__POINTW1FN _0,271
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	RJMP _0x1C5
;     478 			    else if (meas_res_tout)
_0x67:
	CPI  R16,0
	BREQ _0x69
;     479 			      sprintf(buffer, "Tin: %+.1f%cC\nTout error", tinf, 0xdf);
	CALL SUBOPT_0xD
	__POINTW1FN _0,296
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x17
_0x1C5:
	CALL __PUTPARD1
	__GETD1N 0xDF
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;     480 			    lcd_puts(buffer);
_0x69:
	CALL SUBOPT_0xD
	CALL _lcd_puts
;     481 			}
_0x66:
;     482 			if (alarmBtnState)
	SBRS R2,2
	RJMP _0x6A
;     483 			  print_message_alarm220();
	CALL _print_message_alarm220
;     484 			delay_ms(200);
_0x6A:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP _0x1C6
;     485 		}
;     486 	    else
_0x60:
;     487 		{
;     488 		    if ((tinf-tin!=0.5) && (tinf-tin!=-0.5))
	MOV  R30,R7
	LDS  R26,_tinf
	LDS  R27,_tinf+1
	LDS  R24,_tinf+2
	LDS  R25,_tinf+3
	CALL SUBOPT_0x18
	BREQ _0x6D
	CALL SUBOPT_0x19
	BRNE _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
;     489 		        tin=(int)tinf;
	CALL SUBOPT_0x17
	CALL __CFD1
	MOV  R7,R30
;     490 		    if ((toutf-tout!=0.5) && (toutf-tout!=-0.5))
_0x6C:
	MOV  R30,R6
	LDS  R26,_toutf
	LDS  R27,_toutf+1
	LDS  R24,_toutf+2
	LDS  R25,_toutf+3
	CALL SUBOPT_0x18
	BREQ _0x70
	CALL SUBOPT_0x19
	BRNE _0x71
_0x70:
	RJMP _0x6F
_0x71:
;     491 		        tout=(int)toutf;
	CALL SUBOPT_0x16
	CALL __CFD1
	MOV  R6,R30
;     492 			if (!alarmBtnState)
_0x6F:
	SBRC R2,2
	RJMP _0x72
;     493 			{
;     494 			    if ((tin-temp[5] >= 2) && con==1)
	__GETB2MN _temp,5
	MOV  R30,R7
	SUB  R30,R26
	CPI  R30,LOW(0x2)
	BRLO _0x74
	SBRC R2,1
	RJMP _0x75
_0x74:
	RJMP _0x73
_0x75:
;     495 			    {
;     496 	                COND_PORT|=1<<NORMAL;
	SBI  0x15,7
;     497 	                COND_PORT&=~(1<<COND);
	CBI  0x15,6
;     498 	                //виконання алярмового алгоритму
;     499 		            alarm_algorithm();
	CALL _alarm_algorithm
;     500 	            }
;     501 	            else
	RJMP _0x76
_0x73:
;     502 			    {
;     503 			        COND_PORT|=1<<COND|1<<NORMAL;
	IN   R30,0x15
	ORI  R30,LOW(0xC0)
	OUT  0x15,R30
;     504 			        //перевіряємо чи ненатиснута кнопка виводу інфо. на дисплей
;     505 			        if ((BTN_PIN & 1<<BTN)==0 && button_pressed==0)
	SBIC 0x16,1
	RJMP _0x78
	SBRS R2,3
	RJMP _0x79
_0x78:
	RJMP _0x77
_0x79:
;     506 			        {
;     507 				        //delay_ms(1);
;     508 				        TIMSK&=~(1<<OCIE1A);
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
;     509 				        if (mode>3) mode=0;
	LDI  R30,LOW(3)
	CP   R30,R5
	BRSH _0x7A
	CLR  R5
;     510 				        else
	RJMP _0x7B
_0x7A:
;     511 				        {
;     512 					        mode++;
	INC  R5
;     513 					        TCNT1H=0;
	CALL SUBOPT_0x10
;     514 					        TCNT1L=0;
;     515 					        seconds=0;
	CLR  R4
;     516 					        TIMSK|=(1<<OCIE1A);
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
;     517 				        }
_0x7B:
;     518 				        BTN_LED_PORT|=(1<<BTN_LED);
	SBI  0x12,6
;     519 				        button_pressed=1;
	SET
	BLD  R2,3
;     520 			        }
;     521 			        //перевіряємо чи відпущена кнопка виводу інфо. на дисплей
;     522 			        if ((BTN_PIN & 1<<BTN))
_0x77:
	SBIS 0x16,1
	RJMP _0x7C
;     523 			        {
;     524 				        BTN_LED_PORT&=~(1<<BTN_LED);
	CBI  0x12,6
;     525 				        button_pressed=0;
	CLT
	BLD  R2,3
;     526 			        }
;     527 
;     528 			        if (get_key_status(MENU_ENTER_BTN)) //main menu call
_0x7C:
	LDI  R30,LOW(3)
	CALL SUBOPT_0x7
	BREQ _0x7D
;     529                     {
;     530                         if (!get_prev_key_status(MENU_ENTER_BTN))
	LDI  R30,LOW(3)
	CALL SUBOPT_0x6
	BRNE _0x7E
;     531                         {
;     532                             lcd_clear();
	CALL _lcd_clear
;     533                             show_main_menu();
	CALL _show_main_menu
;     534                         }
;     535                     }
_0x7E:
;     536 
;     537 			        //виконання робочого алгоритму
;     538 			        working_algorithm();
_0x7D:
	CALL _working_algorithm
;     539 			    }
_0x76:
;     540 			}
;     541 		    else
	RJMP _0x7F
_0x72:
;     542 		    {
;     543 		      COND_PORT&=~(1<<NORMAL);
	CBI  0x15,7
;     544 		      //виконання алярмового алгоритму
;     545 		      alarm_algorithm();
	CALL _alarm_algorithm
;     546 		      print_message_alarm220();
	CALL _print_message_alarm220
;     547               delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
_0x1C6:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     548 		    }
_0x7F:
;     549 	    }
;     550  }
	RJMP _0x57
;     551  //#pragma rl-
;     552  return 0;
_0x80:
	RJMP _0x80
;     553 }
;     554 #include "therm_ds18b20.h"
;     555 
;     556 struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
;     557 uint8_t therm_dq;
;     558 
;     559 void therm_input_mode(void)
;     560 {

	.CSEG
_therm_input_mode:
;     561 	THERM_DDR&=~(1<<therm_dq);
	IN   R1,20
	CALL SUBOPT_0x1A
	COM  R30
	AND  R30,R1
	OUT  0x14,R30
;     562 }
	RET
;     563 void therm_output_mode(void)
;     564 {
_therm_output_mode:
;     565 	THERM_DDR|=(1<<therm_dq);
	IN   R1,20
	CALL SUBOPT_0x1A
	OR   R30,R1
	OUT  0x14,R30
;     566 }
	RET
;     567 void therm_low(void)
;     568 {
_therm_low:
;     569 	THERM_PORT&=~(1<<therm_dq);
	IN   R1,21
	CALL SUBOPT_0x1A
	COM  R30
	AND  R30,R1
	OUT  0x15,R30
;     570 }
	RET
;     571 /*void therm_high(void)
;     572 {
;     573 	THERM_PORT|=(1<<therm_dq);
;     574 }
;     575 void therm_delay(uint16_t delay)
;     576 {
;     577 	while (delay--) #asm("nop");
;     578 }*/
;     579 
;     580 uint8_t therm_reset()
;     581 {
_therm_reset:
;     582 	uint8_t i;
;     583 	//посилаємо імпульс скидання тривалістю 480 мкс
;     584 	therm_low();
	ST   -Y,R17
;	i -> R17
	CALL SUBOPT_0x1B
;     585 	therm_output_mode();
;     586 	//therm_delay(us(480));
;     587 	delay_us(480);
	__DELAY_USW 960
;     588 	//повертаємо шину і чекаємо 60 мкс на відповідь
;     589 	therm_input_mode();
	CALL _therm_input_mode
;     590 	//therm_delay(us(60));
;     591 	delay_us(60);
	__DELAY_USB 160
;     592 	//зберігаємо значення на шині і чекаємо завершення 480 мкс періода
;     593 	i=(THERM_PIN & (1<<therm_dq));
	CALL SUBOPT_0x1C
	MOV  R17,R30
;     594 	//therm_delay(us(420));
;     595 	delay_us(420);
	__DELAY_USW 840
;     596 	if ((THERM_PIN & (1<<therm_dq))==i) return 1;
	CALL SUBOPT_0x1C
	CP   R17,R30
	BRNE _0x81
	LDI  R30,LOW(1)
	RJMP _0x1BE
;     597 	//повертаємо результат виконання (presence pulse) (0=OK, 1=WRONG)
;     598 	return 0;
_0x81:
	LDI  R30,LOW(0)
	RJMP _0x1BE
;     599 }
;     600 
;     601 void therm_write_bit(uint8_t _bit)
;     602 {
_therm_write_bit:
;     603 	//переводимо шину в стан лог. 0 на 1 мкс
;     604 	therm_low();
;	_bit -> Y+0
	CALL SUBOPT_0x1B
;     605 	therm_output_mode();
;     606 	//therm_delay(us(1));
;     607 	delay_us(1);
	__DELAY_USB 3
;     608 	//якщо пишемо 1, відпускаємо шину (якщо 0 тримаємо в стані лог. 0)
;     609 	if (_bit) therm_input_mode();
	LD   R30,Y
	CPI  R30,0
	BREQ _0x82
	CALL _therm_input_mode
;     610 	//чекаємо 60мкм і відпускаємо шину
;     611 	//therm_delay(us(60));
;     612 	delay_us(60);
_0x82:
	__DELAY_USB 160
;     613 	therm_input_mode();
	CALL _therm_input_mode
;     614 }
	ADIW R28,1
	RET
;     615 
;     616 uint8_t therm_read_bit(void)
;     617 {
_therm_read_bit:
;     618 	uint8_t _bit=0;
;     619 	//переводимо шину в лог. 0 на 1 мкс
;     620 	therm_low();
	ST   -Y,R17
;	_bit -> R17
	LDI  R17,0
	CALL SUBOPT_0x1B
;     621 	therm_output_mode();
;     622 	//therm_delay(us(1));
;     623 	delay_us(1);
	__DELAY_USB 3
;     624 	//відпускаємо шину і чекаємо 14 мкс
;     625 	therm_input_mode();
	CALL _therm_input_mode
;     626 	//therm_delay(us(14));
;     627 	delay_us(14);
	__DELAY_USB 37
;     628 	//читаємо біт з шини
;     629 	if (THERM_PIN&(1<<therm_dq)) _bit=1;
	CALL SUBOPT_0x1C
	BREQ _0x83
	LDI  R17,LOW(1)
;     630 	//чекаємо 45 мкс до закінчення і вертаємо прочитане значення
;     631 	//therm_delay(us(45));
;     632 	delay_us(45);
_0x83:
	__DELAY_USB 120
;     633 	return _bit;
	MOV  R30,R17
_0x1BE:
	LD   R17,Y+
	RET
;     634 }
;     635 
;     636 uint8_t therm_read_byte(void)
;     637 {
_therm_read_byte:
;     638 	uint8_t i=8, n=0;
;     639 	while (i--)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	n -> R16
	LDI  R16,0
	LDI  R17,8
_0x84:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x86
;     640 	{
;     641 		//зсуваємо на 1 розряд вправо і зберігаємо прочитане значення
;     642 		n>>=1;
	LSR  R16
;     643 		n|=(therm_read_bit()<<7);
	CALL _therm_read_bit
	ROR  R30
	LDI  R30,0
	ROR  R30
	OR   R16,R30
;     644 	}
	RJMP _0x84
_0x86:
;     645 	return n;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
;     646 }
;     647 
;     648 void therm_write_byte(uint8_t byte)
;     649 {
_therm_write_byte:
;     650 	uint8_t i=8;
;     651 	while (i--)
	ST   -Y,R17
;	byte -> Y+1
;	i -> R17
	LDI  R17,8
_0x87:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x89
;     652 	{
;     653 		//пишемо молодший біт і зсуваємо на 1 розряд вправо для виводу наступного біта
;     654 		therm_write_bit(byte&1);
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	ST   -Y,R30
	CALL _therm_write_bit
;     655 		byte>>=1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
;     656 	}
	RJMP _0x87
_0x89:
;     657 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     658 
;     659 uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes)
;     660 {
_therm_crc8:
;     661 	uint8_t byte_ctr, cur_byte, bit_ctr, crc=0;
;     662 
;     663 	for (byte_ctr=0; byte_ctr<num_bytes; byte_ctr++)
	CALL __SAVELOCR4
;	*data -> Y+5
;	num_bytes -> Y+4
;	byte_ctr -> R17
;	cur_byte -> R16
;	bit_ctr -> R19
;	crc -> R18
	LDI  R18,0
	LDI  R17,LOW(0)
_0x8B:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x8C
;     664 	{
;     665 		cur_byte=data[byte_ctr];
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
;     666 		for (bit_ctr=0; bit_ctr<8; cur_byte>>=1, bit_ctr++)
	LDI  R19,LOW(0)
_0x8E:
	CPI  R19,8
	BRSH _0x8F
;     667 			if ((cur_byte ^ crc) & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
	MOV  R30,R18
	EOR  R30,R16
	ANDI R30,LOW(0x1)
	BREQ _0x90
	LDI  R30,LOW(24)
	EOR  R30,R18
	LSR  R30
	ORI  R30,0x80
	MOV  R18,R30
;     668 			else crc>>=1;
	RJMP _0x91
_0x90:
	LSR  R18
;     669 	}
_0x91:
	LSR  R16
	SUBI R19,-1
	RJMP _0x8E
_0x8F:
	SUBI R17,-1
	RJMP _0x8B
_0x8C:
;     670 	return crc;
	MOV  R30,R18
	CALL __LOADLOCR4
	ADIW R28,7
	RET
;     671 }
;     672 
;     673 uint8_t therm_init(uint8_t sensor_id, int8_t temp_low, int8_t temp_high, uint8_t resolution)
;     674 {
_therm_init:
;     675 	resolution=(resolution<<5)|0x1f;
;	sensor_id -> Y+3
;	temp_low -> Y+2
;	temp_high -> Y+1
;	resolution -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
;     676 	//ініціалізуємо давач sensor_id
;     677 	if (sensor_id) therm_dq=OUTDOOR_THERM;
	LDD  R30,Y+3
	CPI  R30,0
	BREQ _0x92
	CLR  R8
;     678     else therm_dq=INDOOR_THERM;
	RJMP _0x93
_0x92:
	LDI  R30,LOW(1)
	MOV  R8,R30
;     679 	if (therm_reset()) return 1;
_0x93:
	CALL _therm_reset
	CPI  R30,0
	BREQ _0x94
	LDI  R30,LOW(1)
	RJMP _0x1BD
;     680 	therm_write_byte(THERM_CMD_SKIPROM);
_0x94:
	CALL SUBOPT_0x1D
;     681 	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	LDI  R30,LOW(78)
	ST   -Y,R30
	CALL _therm_write_byte
;     682 	therm_write_byte(temp_high);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _therm_write_byte
;     683 	therm_write_byte(temp_low);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _therm_write_byte
;     684 	therm_write_byte(resolution);
	LD   R30,Y
	ST   -Y,R30
	CALL _therm_write_byte
;     685 	therm_reset();
	CALL _therm_reset
;     686 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x1D
;     687 	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	LDI  R30,LOW(72)
	ST   -Y,R30
	CALL _therm_write_byte
;     688 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x11
;     689 	return 0;
	LDI  R30,LOW(0)
_0x1BD:
	ADIW R28,4
	RET
;     690 }
;     691 
;     692 uint8_t therm_read_spd(void)
;     693 {
_therm_read_spd:
;     694 	uint8_t i=0, *p;
;     695 
;     696 	p = (uint8_t*) &__ds18b20_scratch_pad;
	CALL __SAVELOCR4
;	i -> R17
;	*p -> R18,R19
	LDI  R17,0
	__POINTWRM 18,19,___ds18b20_scratch_pad
;     697 	do
_0x96:
;     698 		*(p++)=therm_read_byte();
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _therm_read_byte
	POP  R26
	POP  R27
	ST   X,R30
;     699 	while(++i<9);
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x96
;     700 	if (therm_crc8((uint8_t*)&__ds18b20_scratch_pad,8)!=__ds18b20_scratch_pad.crc)
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _therm_crc8
	MOV  R26,R30
	__GETB1MN ___ds18b20_scratch_pad,8
	CP   R30,R26
	BREQ _0x98
;     701 		return 1;
	LDI  R30,LOW(1)
	RJMP _0x1BC
;     702 	return 0;
_0x98:
	LDI  R30,LOW(0)
_0x1BC:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     703 }
;     704 
;     705 uint8_t therm_read_temperature(uint8_t sensor_id, float *temp)
;     706 {
_therm_read_temperature:
;     707 	uint8_t digit, decimal, resolution, sign;
;     708 	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};
;     709 
;     710 	if (sensor_id) therm_dq=OUTDOOR_THERM;
	SBIW R28,8
	LDI  R24,8
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x99*2)
	LDI  R31,HIGH(_0x99*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	sensor_id -> Y+16
;	*temp -> Y+14
;	digit -> R17
;	decimal -> R16
;	resolution -> R19
;	sign -> R18
;	meas -> R20,R21
;	bit_mask -> Y+6
	LDD  R30,Y+16
	CPI  R30,0
	BREQ _0x9A
	CLR  R8
;     711     else therm_dq=INDOOR_THERM;
	RJMP _0x9B
_0x9A:
	LDI  R30,LOW(1)
	MOV  R8,R30
;     712 	//скинути, пропустити процедуру перевірки серійного номера ROM і почати вимірювання і перетворення температури
;     713 	if (therm_reset()) return 1;
_0x9B:
	CALL _therm_reset
	CPI  R30,0
	BREQ _0x9C
	LDI  R30,LOW(1)
	RJMP _0x1BB
;     714 	therm_write_byte(THERM_CMD_SKIPROM);
_0x9C:
	CALL SUBOPT_0x1D
;     715 	therm_write_byte(THERM_CMD_CONVERTTEMP);
	LDI  R30,LOW(68)
	ST   -Y,R30
	CALL _therm_write_byte
;     716 	//чекаємо до закінчення перетворення
;     717 	while(!therm_read_bit());
_0x9D:
	CALL _therm_read_bit
	CPI  R30,0
	BREQ _0x9D
;     718 	//скидаємо, пропускаємо ROM і посилаємо команду зчитування Scratchpad
;     719 	therm_reset();
	CALL _therm_reset
;     720 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x1D
;     721 	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	LDI  R30,LOW(190)
	ST   -Y,R30
	CALL _therm_write_byte
;     722 	if (therm_read_spd()) return 1;
	CALL _therm_read_spd
	CPI  R30,0
	BREQ _0xA0
	LDI  R30,LOW(1)
	RJMP _0x1BB
;     723 	therm_reset();
_0xA0:
	CALL _therm_reset
;     724 	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R19,R30
;     725     //отримуємо молодший і старший байти температури
;     726 	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	LDS  R20,___ds18b20_scratch_pad
	CLR  R21
;     727 	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB
	__GETB1HMN ___ds18b20_scratch_pad,1
	LDI  R30,LOW(0)
	__ORWRR 20,21,30,31
;     728 	//перевіряємо на мінусову температуру
;     729 	if (meas & 0x8000)
	SBRS R21,7
	RJMP _0xA1
;     730 	{
;     731 		sign=1;  //відмічаємо мінусову температуру
	LDI  R18,LOW(1)
;     732 		meas^=0xffff;  //перетворюємо в плюсову
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__EORWRR 20,21,30,31
;     733 		meas++;
	__ADDWRN 20,21,1
;     734 	}
;     735 	else sign=0;
	RJMP _0xA2
_0xA1:
	LDI  R18,LOW(0)
;     736 	//зберігаємо цілу і дробову частини температури
;     737 	digit=(uint8_t)(meas >> 4); //зберігаємо цілу частину
_0xA2:
	MOVW R30,R20
	CALL __LSRW4
	MOV  R17,R30
;     738 	decimal=(uint8_t)(meas & bit_mask[resolution]);	//отримуємо дробову частину
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	AND  R30,R20
	AND  R31,R21
	MOV  R16,R30
;     739 	*temp=digit+decimal*0.0625;
	CALL SUBOPT_0x1E
	__GETD2N 0x3D800000
	CALL __MULF12
	MOV  R26,R17
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __ADDF12
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __PUTDP1
;     740 	if (sign) *temp=-(*temp); //ставемо знак мінус, якщо мінусова температура
	CPI  R18,0
	BREQ _0xA3
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETD1P
	CALL __ANEGF1
	CALL __PUTDP1
;     741 	return 0;
_0xA3:
	LDI  R30,LOW(0)
_0x1BB:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
;     742 }

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
__put_G3:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0xB1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xB3
	__CPWRN 16,17,2
	BRLO _0xB4
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0xB3:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x9
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0xB4:
	RJMP _0xB5
_0xB1:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0xB5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__ftoa_G3:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0xB6
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0xB6:
	LDD  R30,Y+8
	LDI  R26,LOW(__fround_G3*2)
	LDI  R27,HIGH(__fround_G3*2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	CALL SUBOPT_0x1F
	CALL __ADDF12
	CALL SUBOPT_0x20
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x21
_0xB7:
	CALL SUBOPT_0x22
	CALL __CMPF12
	BRLO _0xB9
	CALL SUBOPT_0x23
	CALL __MULF12
	CALL SUBOPT_0x21
	SUBI R17,-LOW(1)
	RJMP _0xB7
_0xB9:
	CPI  R17,0
	BRNE _0xBA
	CALL SUBOPT_0x24
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0xBB
_0xBA:
_0xBC:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xBE
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x24
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	__GETD2S 2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x26
	RJMP _0xBC
_0xBE:
_0xBB:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0xBF
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1BA
_0xBF:
	CALL SUBOPT_0x24
	LDI  R30,LOW(46)
	ST   X,R30
_0xC0:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0xC2
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x27
	CALL SUBOPT_0x20
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x24
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CALL SUBOPT_0x1F
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x26
	RJMP _0xC0
_0xC2:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x1BA:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G3:
	SBIW R28,4
	CALL __SAVELOCR4
	__GETD1N 0x3F800000
	CALL SUBOPT_0x28
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0xC3
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0xC3:
	LDD  R17,Y+11
_0xC4:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xC6
	CALL SUBOPT_0x29
	CALL SUBOPT_0x28
	RJMP _0xC4
_0xC6:
	CALL SUBOPT_0x2A
	CALL __CPD10
	BRNE _0xC7
	LDI  R19,LOW(0)
	CALL SUBOPT_0x29
	CALL SUBOPT_0x28
	RJMP _0xC8
_0xC7:
	LDD  R19,Y+11
	CALL SUBOPT_0x2B
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC9
	CALL SUBOPT_0x29
	CALL SUBOPT_0x28
_0xCA:
	CALL SUBOPT_0x2B
	BRLO _0xCC
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	RJMP _0xCA
_0xCC:
	RJMP _0xCD
_0xC9:
_0xCE:
	CALL SUBOPT_0x2B
	BRSH _0xD0
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2E
	SUBI R19,LOW(1)
	RJMP _0xCE
_0xD0:
	CALL SUBOPT_0x29
	CALL SUBOPT_0x28
_0xCD:
	CALL SUBOPT_0x2A
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2B
	BRLO _0xD1
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
_0xD1:
_0xC8:
	LDI  R17,LOW(0)
_0xD2:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0xD4
	__GETD2S 4
	__GETD1N 0x41200000
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	__GETD1S 4
	CALL SUBOPT_0x2C
	CALL __DIVF21
	CALL __CFD1
	MOV  R16,R30
	CALL SUBOPT_0x2F
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	CALL SUBOPT_0x1E
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x2C
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x2E
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0xD2
	CALL SUBOPT_0x2F
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0xD2
_0xD4:
	CALL SUBOPT_0x30
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0xD6
	CALL SUBOPT_0x2F
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0xD6:
	CPI  R19,10
	BRLT _0xD7
	CALL SUBOPT_0x30
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0xD7:
	CALL SUBOPT_0x30
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
__print_G3:
	SBIW R28,63
	SBIW R28,15
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 84
	STD  Y+16,R30
	STD  Y+16+1,R31
_0xD8:
	MOVW R26,R28
	SUBI R26,LOW(-(90))
	SBCI R27,HIGH(-(90))
	CALL SUBOPT_0x9
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0xDA
	MOV  R30,R17
	CPI  R30,0
	BRNE _0xDE
	CPI  R18,37
	BRNE _0xDF
	LDI  R17,LOW(1)
	RJMP _0xE0
_0xDF:
	CALL SUBOPT_0x31
_0xE0:
	RJMP _0xDD
_0xDE:
	CPI  R30,LOW(0x1)
	BRNE _0xE1
	CPI  R18,37
	BRNE _0xE2
	CALL SUBOPT_0x31
	RJMP _0x1C7
_0xE2:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+19,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0xE3
	LDI  R16,LOW(1)
	RJMP _0xDD
_0xE3:
	CPI  R18,43
	BRNE _0xE4
	LDI  R30,LOW(43)
	STD  Y+19,R30
	RJMP _0xDD
_0xE4:
	CPI  R18,32
	BRNE _0xE5
	LDI  R30,LOW(32)
	STD  Y+19,R30
	RJMP _0xDD
_0xE5:
	RJMP _0xE6
_0xE1:
	CPI  R30,LOW(0x2)
	BRNE _0xE7
_0xE6:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0xE8
	ORI  R16,LOW(128)
	RJMP _0xDD
_0xE8:
	RJMP _0xE9
_0xE7:
	CPI  R30,LOW(0x3)
	BRNE _0xEA
_0xE9:
	CPI  R18,48
	BRLO _0xEC
	CPI  R18,58
	BRLO _0xED
_0xEC:
	RJMP _0xEB
_0xED:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0xDD
_0xEB:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0xEE
	LDI  R17,LOW(4)
	RJMP _0xDD
_0xEE:
	RJMP _0xEF
_0xEA:
	CPI  R30,LOW(0x4)
	BRNE _0xF1
	CPI  R18,48
	BRLO _0xF3
	CPI  R18,58
	BRLO _0xF4
_0xF3:
	RJMP _0xF2
_0xF4:
	ORI  R16,LOW(32)
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0xDD
_0xF2:
_0xEF:
	CPI  R18,108
	BRNE _0xF5
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0xDD
_0xF5:
	RJMP _0xF6
_0xF1:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0xDD
_0xF6:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0xFB
	CALL SUBOPT_0x32
	LDD  R30,Z+4
	CALL SUBOPT_0x33
	RJMP _0xFC
_0xFB:
	CPI  R30,LOW(0x45)
	BREQ _0xFF
	CPI  R30,LOW(0x65)
	BRNE _0x100
_0xFF:
	RJMP _0x101
_0x100:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x102
_0x101:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x32
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x34
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x103
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x105
	RJMP _0x106
_0x103:
	CALL SUBOPT_0x35
	CALL __ANEGF1
	CALL SUBOPT_0x34
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x105:
	SBRS R16,7
	RJMP _0x107
	LDD  R30,Y+19
	CALL SUBOPT_0x33
	RJMP _0x108
_0x107:
	CALL SUBOPT_0x36
	LDD  R26,Y+19
	STD  Z+0,R26
_0x108:
_0x106:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x10A
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoa_G3
	RJMP _0x10B
_0x10A:
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G3
_0x10B:
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x37
	RJMP _0x10C
_0x102:
	CPI  R30,LOW(0x73)
	BRNE _0x10E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	RJMP _0x10F
_0x10E:
	CPI  R30,LOW(0x70)
	BRNE _0x111
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x10F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x113
	CP   R20,R17
	BRLO _0x114
_0x113:
	RJMP _0x112
_0x114:
	MOV  R17,R20
_0x112:
_0x10C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R19,LOW(0)
	RJMP _0x115
_0x111:
	CPI  R30,LOW(0x64)
	BREQ _0x118
	CPI  R30,LOW(0x69)
	BRNE _0x119
_0x118:
	ORI  R16,LOW(4)
	RJMP _0x11A
_0x119:
	CPI  R30,LOW(0x75)
	BRNE _0x11B
_0x11A:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x11C
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x2E
	LDI  R17,LOW(10)
	RJMP _0x11D
_0x11C:
	__GETD1N 0x2710
	CALL SUBOPT_0x2E
	LDI  R17,LOW(5)
	RJMP _0x11D
_0x11B:
	CPI  R30,LOW(0x58)
	BRNE _0x11F
	ORI  R16,LOW(8)
	RJMP _0x120
_0x11F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x15E
_0x120:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x122
	__GETD1N 0x10000000
	CALL SUBOPT_0x2E
	LDI  R17,LOW(8)
	RJMP _0x11D
_0x122:
	__GETD1N 0x1000
	CALL SUBOPT_0x2E
	LDI  R17,LOW(4)
_0x11D:
	CPI  R20,0
	BREQ _0x123
	ANDI R16,LOW(127)
	RJMP _0x124
_0x123:
	LDI  R20,LOW(1)
_0x124:
	SBRS R16,1
	RJMP _0x125
	CALL SUBOPT_0x32
	ADIW R30,4
	MOVW R26,R30
	CALL __GETD1P
	RJMP _0x1C8
_0x125:
	SBRS R16,2
	RJMP _0x127
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	CALL __CWD1
	RJMP _0x1C8
_0x127:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	CLR  R22
	CLR  R23
_0x1C8:
	__PUTD1S 6
	SBRS R16,2
	RJMP _0x129
	CALL SUBOPT_0x39
	CALL __CPD20
	BRGE _0x12A
	CALL SUBOPT_0x35
	CALL __ANEGD1
	CALL SUBOPT_0x34
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x12A:
	LDD  R30,Y+19
	CPI  R30,0
	BREQ _0x12B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x12C
_0x12B:
	ANDI R16,LOW(251)
_0x12C:
_0x129:
	MOV  R19,R20
_0x115:
	SBRC R16,0
	RJMP _0x12D
_0x12E:
	CP   R17,R21
	BRSH _0x131
	CP   R19,R21
	BRLO _0x132
_0x131:
	RJMP _0x130
_0x132:
	SBRS R16,7
	RJMP _0x133
	SBRS R16,2
	RJMP _0x134
	ANDI R16,LOW(251)
	LDD  R18,Y+19
	SUBI R17,LOW(1)
	RJMP _0x135
_0x134:
	LDI  R18,LOW(48)
_0x135:
	RJMP _0x136
_0x133:
	LDI  R18,LOW(32)
_0x136:
	CALL SUBOPT_0x31
	SUBI R21,LOW(1)
	RJMP _0x12E
_0x130:
_0x12D:
_0x137:
	CP   R17,R20
	BRSH _0x139
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x13A
	CALL SUBOPT_0x3A
	BREQ _0x13B
	SUBI R21,LOW(1)
_0x13B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x13A:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x13C
	SUBI R21,LOW(1)
_0x13C:
	SUBI R20,LOW(1)
	RJMP _0x137
_0x139:
	MOV  R19,R17
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x13D
_0x13E:
	CPI  R19,0
	BREQ _0x140
	SBRS R16,3
	RJMP _0x141
	CALL SUBOPT_0x36
	LPM  R30,Z
	RJMP _0x1C9
_0x141:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x1C9:
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G3
	CPI  R21,0
	BREQ _0x143
	SUBI R21,LOW(1)
_0x143:
	SUBI R19,LOW(1)
	RJMP _0x13E
_0x140:
	RJMP _0x144
_0x13D:
_0x146:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x39
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x148
	SBRS R16,3
	RJMP _0x149
	SUBI R18,-LOW(55)
	RJMP _0x14A
_0x149:
	SUBI R18,-LOW(87)
_0x14A:
	RJMP _0x14B
_0x148:
	SUBI R18,-LOW(48)
_0x14B:
	SBRC R16,4
	RJMP _0x14D
	CPI  R18,49
	BRSH _0x14F
	CALL SUBOPT_0x2C
	__CPD2N 0x1
	BRNE _0x14E
_0x14F:
	RJMP _0x151
_0x14E:
	CP   R20,R19
	BRSH _0x1CA
	CP   R21,R19
	BRLO _0x154
	SBRS R16,0
	RJMP _0x155
_0x154:
	RJMP _0x153
_0x155:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x156
_0x1CA:
	LDI  R18,LOW(48)
_0x151:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x157
	CALL SUBOPT_0x3A
	BREQ _0x158
	SUBI R21,LOW(1)
_0x158:
_0x157:
_0x156:
_0x14D:
	CALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x159
	SUBI R21,LOW(1)
_0x159:
_0x153:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x39
	CALL __MODD21U
	CALL SUBOPT_0x34
	LDD  R30,Y+18
	CALL SUBOPT_0x2C
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2A
	CALL __CPD10
	BREQ _0x147
	RJMP _0x146
_0x147:
_0x144:
	SBRS R16,0
	RJMP _0x15A
_0x15B:
	CPI  R21,0
	BREQ _0x15D
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x33
	RJMP _0x15B
_0x15D:
_0x15A:
_0x15E:
_0xFC:
_0x1C7:
	LDI  R17,LOW(0)
_0xDD:
	RJMP _0xD8
_0xDA:
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
	CALL __print_G3
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
__base_y_G4:
	.BYTE 0x4

	.CSEG
__lcd_delay_G4:
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
	CALL __lcd_delay_G4
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G4
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G4
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G4
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G4:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G4
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G4
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G4
    ld    r26,y
    swap  r26
	CALL __lcd_write_nibble_G4
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G4:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G4
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G4
    andi  r30,0xf0
	RET
_lcd_read_byte0_G4:
	CALL __lcd_delay_G4
	CALL __lcd_read_nibble_G4
    mov   r26,r30
	CALL __lcd_read_nibble_G4
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G4)
	SBCI R31,HIGH(-__base_y_G4)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R11,Y+1
	LDD  R10,Y+0
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
	MOV  R10,R30
	MOV  R11,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R11
	CP   R13,R11
	BRSH _0x1AB
	__lcd_putchar1:
	INC  R10
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R10
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x1AB:
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
_0x1AC:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1AE
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1AC
_0x1AE:
	LDD  R17,Y+0
	RJMP _0x1B9
_lcd_putsf:
	ST   -Y,R17
_0x1AF:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1B1
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1AF
_0x1B1:
	LDD  R17,Y+0
_0x1B9:
	ADIW R28,3
	RET
__long_delay_G4:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G4:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G4
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G4,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G4,3
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3B
	CALL __long_delay_G4
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G4
	CALL __long_delay_G4
	LDI  R30,LOW(40)
	CALL SUBOPT_0x3C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x3C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x3C
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G4
	CPI  R30,LOW(0x5)
	BREQ _0x1B2
	LDI  R30,LOW(0)
	RJMP _0x1B8
_0x1B2:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x1B8:
	ADIW R28,1
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
_p_S6A:
	.BYTE 0x2

	.CSEG

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	__GETW1SX 91
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	IN   R30,0x12
	ANDI R30,LOW(0xED)
	OUT  0x12,R30
	IN   R30,0x12
	ANDI R30,LOW(0xF6)
	OUT  0x12,R30
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	IN   R30,0x12
	ANDI R30,LOW(0xF6)
	OUT  0x12,R30
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_tinf
	LDS  R31,_tinf+1
	LDS  R22,_tinf+2
	LDS  R23,_tinf+3
	CALL __PUTPARD1
	__GETD1N 0xDF
	CALL __PUTPARD1
	LDS  R30,_toutf
	LDS  R31,_toutf+1
	LDS  R22,_toutf+2
	LDS  R23,_toutf+3
	CALL __PUTPARD1
	__GETD1N 0xDF
	CALL __PUTPARD1
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xF:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x12:
	IN   R1,24
	IN   R30,0x16
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x18,R30
	IN   R1,23
	IN   R30,0x16
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	LDI  R30,LOW(201)
	ST   -Y,R30
	LDI  R30,LOW(125)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _therm_init
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	BLD  R2,0
	IN   R30,0x12
	ANDI R30,LOW(0xED)
	OUT  0x12,R30
	CBI  0x12,5
	SBI  0x12,2
	IN   R30,0x15
	ANDI R30,LOW(0x3F)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R30,_toutf
	LDS  R31,_toutf+1
	LDS  R22,_toutf+2
	LDS  R23,_toutf+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDS  R30,_tinf
	LDS  R31,_tinf+1
	LDS  R22,_tinf+2
	LDS  R23,_tinf+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	__CPD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__CPD1N 0xBF000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	MOV  R30,R8
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _therm_low
	JMP  _therm_output_mode

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	IN   R1,19
	MOV  R30,R8
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(204)
	ST   -Y,R30
	JMP  _therm_write_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__GETD1S 2
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	__GETD2S 2
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x27:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	__GETD2S 4
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	__GETD1N 0x41200000
	CALL __DIVF21
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2E:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x31:
	ST   -Y,R18
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
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
SUBOPT_0x33:
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	ADIW R30,4
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x3A:
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
	CALL __put_G3
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	CALL __long_delay_G4
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G4

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

__CBD2:
	MOV  R27,R26
	ADD  R27,R27
	SBC  R27,R27
	MOV  R24,R27
	MOV  R25,R27
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
