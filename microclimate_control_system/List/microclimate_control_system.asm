
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _PREV_BTN_PIN=R5
	.DEF __lcd_x=R4
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R6

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x17,0x0,0x1B
_0x4:
	.DB  0x32,0x0,0x3C
_0x5:
	.DB  0x0,0xE3,0xE3,0x0,0xF5,0xF5,0x0,0xF1
	.DB  0xF1,0x0,0x5E,0x5E,0x0
_0x2B:
	.DB  0xE4,0xE4,0x0,0xEC,0xEC,0x0,0xF0,0xF0
	.DB  0x0,0x5E,0x5E,0x0
_0x55:
	.DB  0x0,0x0,0x63,0x0,0xA,0x0,0x64,0x0
	.DB  0x0,0x0,0x64,0x0,0x2C,0x1,0xE8,0x3
	.DB  0x0,0x1,0x1,0xE,0xE,0xD,0x3C,0x3D
	.DB  0x0,0x0,0x3C,0x3D,0x0,0x0,0x4F,0x4B
	.DB  0x21,0x0
_0x79:
	.DB  LOW(_0x78+15),HIGH(_0x78+15),LOW(_0x78+19),HIGH(_0x78+19),0x0,LOW(_0x78),HIGH(_0x78),LOW(_0x78+3)
	.DB  HIGH(_0x78+3),LOW(_0x78+6),HIGH(_0x78+6),LOW(_0x78+9),HIGH(_0x78+9),LOW(_0x78+12),HIGH(_0x78+12)
_0xA8:
	.DB  0x2A,0x2A,0x20,0x4D,0x61,0x69,0x6E,0x20
	.DB  0x4D,0x65,0x6E,0x75,0x20,0x2A,0x2A,0x0
	.DB  0x6,0x0,0x6,0x0,0x4,0x0,0x2,0x0
	.DB  0x4,0x0,0x2,0x0,0x0,0x0,0x6,0x0
	.DB  LOW(_0xA7),HIGH(_0xA7),LOW(_0xA7+5),HIGH(_0xA7+5),LOW(_0xA7+10),HIGH(_0xA7+10),LOW(_0xA7+19),HIGH(_0xA7+19)
	.DB  LOW(_0xA7+31),HIGH(_0xA7+31),LOW(_0xA7+40),HIGH(_0xA7+40),LOW(_0xA7+54),HIGH(_0xA7+54),LOW(_0xA7+70),HIGH(_0xA7+70)
_0xC5:
	.DB  LOW(_0xC4),HIGH(_0xC4),LOW(_0xC4+4),HIGH(_0xC4+4),LOW(_0xC4+8),HIGH(_0xC4+8),LOW(_0xC4+12),HIGH(_0xC4+12)
	.DB  LOW(_0xC4+16),HIGH(_0xC4+16),LOW(_0xC4+20),HIGH(_0xC4+20),LOW(_0xC4+24),HIGH(_0xC4+24),0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0xD7:
	.DB  0xFF
_0x0:
	.DB  0x25,0x75,0x25,0x75,0x3A,0x25,0x75,0x25
	.DB  0x75,0x3A,0x25,0x75,0x25,0x75,0x20,0x4F
	.DB  0x4B,0x21,0x0,0x20,0x20,0x0,0x25,0x75
	.DB  0x25,0x75,0x2F,0x25,0x75,0x25,0x75,0x2F
	.DB  0x25,0x75,0x25,0x75,0x20,0x4F,0x4B,0x21
	.DB  0x0,0x54,0x6D,0x69,0x6E,0x3A,0x20,0x25
	.DB  0x75,0x25,0x63,0x43,0x20,0xA,0x54,0x6D
	.DB  0x61,0x78,0x3A,0x20,0x25,0x75,0x25,0x63
	.DB  0x43,0x20,0x0,0x48,0x6D,0x69,0x6E,0x3A
	.DB  0x20,0x25,0x75,0x25,0x25,0x20,0xA,0x48
	.DB  0x6D,0x61,0x78,0x3A,0x20,0x25,0x75,0x25
	.DB  0x25,0x20,0x0,0x53,0x6D,0x69,0x6E,0x3A
	.DB  0x20,0x25,0x75,0x25,0x25,0x20,0xA,0x53
	.DB  0x6D,0x61,0x78,0x3A,0x20,0x25,0x75,0x25
	.DB  0x25,0x20,0x0,0x49,0x6D,0x69,0x6E,0x3A
	.DB  0x20,0x25,0x75,0x20,0x6C,0x78,0x20,0xA
	.DB  0x49,0x6D,0x61,0x78,0x3A,0x20,0x25,0x75
	.DB  0x20,0x6C,0x78,0x20,0x0,0xEF,0xF0,0x0
	.DB  0xE3,0xE3,0x0,0xF5,0xF5,0x0,0x5E,0x5E
	.DB  0x0,0x4F,0x46,0x46,0x0,0x4F,0x4E,0x20
	.DB  0x0,0x23,0x25,0x75,0x20,0x25,0x75,0x25
	.DB  0x75,0x3A,0x25,0x75,0x25,0x75,0x20,0x25
	.DB  0x73,0x20,0x4F,0x4B,0x21,0x0,0x44,0x41
	.DB  0x54,0x45,0x0,0x54,0x49,0x4D,0x45,0x0
	.DB  0x57,0x41,0x54,0x45,0x52,0x49,0x4E,0x47
	.DB  0x0,0x54,0x45,0x4D,0x50,0x45,0x52,0x41
	.DB  0x54,0x55,0x52,0x45,0x0,0x48,0x55,0x4D
	.DB  0x49,0x44,0x49,0x54,0x59,0x0,0x53,0x4F
	.DB  0x49,0x4C,0x20,0x4D,0x4F,0x49,0x53,0x54
	.DB  0x55,0x52,0x45,0x0,0x4C,0x49,0x47,0x48
	.DB  0x54,0x20,0x49,0x4E,0x54,0x45,0x4E,0x53
	.DB  0x49,0x54,0x59,0x0,0x45,0x58,0x49,0x54
	.DB  0x0,0x53,0x75,0x6E,0x0,0x4D,0x6F,0x6E
	.DB  0x0,0x54,0x75,0x65,0x0,0x57,0x65,0x64
	.DB  0x0,0x54,0x68,0x72,0x0,0x46,0x72,0x69
	.DB  0x0,0x53,0x61,0x74,0x0,0xD1,0xC8,0xD1
	.DB  0xD2,0xC5,0xCC,0xC0,0x0,0xD3,0xCF,0xD0
	.DB  0xC0,0xC2,0xCB,0x49,0xCD,0xCD,0xDF,0x0
	.DB  0xCC,0x49,0xCA,0xD0,0xCE,0xCA,0xCB,0x49
	.DB  0xCC,0xC0,0xD2,0xCE,0xCC,0x0,0xC2,0x20
	.DB  0xD2,0xC5,0xCF,0xCB,0xC8,0xD6,0x49,0x0
	.DB  0x41,0x6E,0x64,0x72,0x69,0x79,0x20,0x48
	.DB  0x61,0x6C,0x61,0x6B,0x68,0x0,0x28,0x43
	.DB  0x29,0x20,0x32,0x30,0x31,0x37,0x0,0x25
	.DB  0x2B,0x33,0x2E,0x31,0x66,0x25,0x63,0x43
	.DB  0x20,0x25,0x33,0x2E,0x31,0x66,0x25,0x25
	.DB  0x20,0x52,0x48,0x20,0x0,0x25,0x2B,0x64
	.DB  0x25,0x63,0x43,0x20,0x0,0x25,0x75,0x25
	.DB  0x75,0x3A,0x25,0x75,0x25,0x75,0x20,0x25
	.DB  0x73,0x0
_0x40003:
	.DB  0xC5,0xFE,0x2,0xC0
_0x40004:
	.DB  0xBD,0x52,0x16,0x3F
_0x40005:
	.DB  0x3B,0x25,0xD6,0xB9
_0x40006:
	.DB  0xA,0xD7,0x23,0x3C
_0x40007:
	.DB  0xAC,0xC5,0xA7,0x3A
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x202005F:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040003:
	.DB  0x80,0xC0
_0x2040004:
	.DB  0xC0,0xC1,0xC2,0xC3,0xC4,0xC5,0xAA,0xC6
	.DB  0xC7,0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE
	.DB  0xCF,0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6
	.DB  0xD7,0xD8,0xD9,0xDC,0xDB,0xDA,0xDD,0xDE
	.DB  0xDF,0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE5
	.DB  0xE6,0xE7,0xE8,0xE9,0xEA,0xEB,0xEC,0xED
	.DB  0xEE,0xEF,0xF0,0xF1,0xF2,0xF3,0xF4,0xF5
	.DB  0xF6,0xF7,0xF8,0xF9,0xFC,0xFB,0xFA,0xFD
	.DB  0xFE,0xFF
_0x2040005:
	.DB  0x41,0xA0,0x42,0xA1,0xE0,0x45,0xA2,0xA3
	.DB  0xA4,0xA5,0xA6,0x4B,0xA7,0x4D,0x48,0x4F
	.DB  0xA8,0x50,0x43,0x54,0xA9,0xAA,0x58,0xE1
	.DB  0xAB,0xAC,0xE2,0x62,0xAE,0xAD,0xAF,0xB0
	.DB  0xB1,0x61,0xB2,0xB3,0xB4,0xE3,0x65,0xB5
	.DB  0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,0xBC,0xBD
	.DB  0x6F,0xBE,0x70,0x63,0xBF,0xC5,0xC6,0xC7

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  _temp
	.DW  _0x3*2

	.DW  0x03
	.DW  _hum
	.DW  _0x4*2

	.DW  0x03
	.DW  _0x78
	.DW  _0x0*2+141

	.DW  0x03
	.DW  _0x78+3
	.DW  _0x0*2+144

	.DW  0x03
	.DW  _0x78+6
	.DW  _0x0*2+147

	.DW  0x03
	.DW  _0x78+9
	.DW  _0x0*2+150

	.DW  0x03
	.DW  _0x78+12
	.DW  _0x0*2+150

	.DW  0x04
	.DW  _0x78+15
	.DW  _0x0*2+153

	.DW  0x04
	.DW  _0x78+19
	.DW  _0x0*2+157

	.DW  0x05
	.DW  _0xA7
	.DW  _0x0*2+182

	.DW  0x05
	.DW  _0xA7+5
	.DW  _0x0*2+187

	.DW  0x09
	.DW  _0xA7+10
	.DW  _0x0*2+192

	.DW  0x0C
	.DW  _0xA7+19
	.DW  _0x0*2+201

	.DW  0x09
	.DW  _0xA7+31
	.DW  _0x0*2+213

	.DW  0x0E
	.DW  _0xA7+40
	.DW  _0x0*2+222

	.DW  0x10
	.DW  _0xA7+54
	.DW  _0x0*2+236

	.DW  0x05
	.DW  _0xA7+70
	.DW  _0x0*2+252

	.DW  0x04
	.DW  _0xC4
	.DW  _0x0*2+257

	.DW  0x04
	.DW  _0xC4+4
	.DW  _0x0*2+261

	.DW  0x04
	.DW  _0xC4+8
	.DW  _0x0*2+265

	.DW  0x04
	.DW  _0xC4+12
	.DW  _0x0*2+269

	.DW  0x04
	.DW  _0xC4+16
	.DW  _0x0*2+273

	.DW  0x04
	.DW  _0xC4+20
	.DW  _0x0*2+277

	.DW  0x04
	.DW  _0xC4+24
	.DW  _0x0*2+281

	.DW  0x01
	.DW  0x05
	.DW  _0xD7*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x202005F*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x42
	.DW  _code_rus
	.DW  _0x2040004*2

	.DW  0x38
	.DW  _code_byte_lcd
	.DW  _0x2040005*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
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

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Автматизована система моніторингу та управління мікрокліматом
;		  в тепличних господарствах на мікроконтролері AVR ATmega32
;Version : Дипломна робота
;Date    : 2017
;Author  : (C) студент Галах Андрій
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
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
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <lcd.h> // функції LCD
;#include <i2c.h>           // інтерфейс i2c - Bus functions
;#include <ds1307.h>       // DS1307 Real Time Clock functions
;#include "therm_ds18b20.h"
;#include "shtxx.h"
;
;#asm
    .equ __lcd_port=0x12 // порт піключення LCD, PORTD
; 0000 0022 #endasm
;
;#asm
   .equ __i2c_port=0x15 ;PORTC   // DS1317 на порті С
   .equ __sda_bit=1              // SDA - на pin.1
   .equ __scl_bit=0              // SCL - на pin.0
; 0000 0028 #endasm
;
;#pragma rl+
;
;//buttons MENU/ENTER, SELECT+, SELECT-
;#define BTN_PORT PORTB
;#define BTN_PIN PINB
;#define BTN_DDR DDRB
;#define MENU_ENTER_BTN 0
;#define SELECT_PLUS_BTN 1
;#define SELECT_MINUS_BTN 2
;#define EXIT_BTN 3
;
;//air-conditioner
;#define REL1_PORT PORTC
;#define REL1_DDR DDRC
;#define REL1 5
;
;//water pump
;#define REL2_PORT PORTC
;#define REL2_DDR DDRC
;#define REL2 6
;
;//artificial light source
;#define REL3_PORT PORTC
;#define REL3_DDR DDRC
;#define REL3 7
;
;#define WATERING_TIME_NUMBER 8
;
;typedef struct {
;   unsigned int min, max;
;} values_range;
;
;typedef struct {
;  unsigned char hour, min, mode_on_off;
;} watering_time;
;
;values_range temp = {23, 27}, hum = {50, 60}, soil = {0, 0}, light = {0, 0};

	.DSEG
;watering_time w_time[WATERING_TIME_NUMBER] = {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0},
;            {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}};
;unsigned char PREV_BTN_PIN = 0xff;
;char lcd_buffer[33];
;
;unsigned char get_key_status(unsigned char BTN_ID)
; 0000 0055 {

	.CSEG
_get_key_status:
; 0000 0056     return (!(BTN_PIN&(1<<BTN_ID)));
;	BTN_ID -> Y+0
	IN   R1,22
	LD   R30,Y
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	RJMP _0x2100017
; 0000 0057 }
;
;unsigned char get_prev_key_status(unsigned char BTN_ID)
; 0000 005A {
_get_prev_key_status:
; 0000 005B     return (!(PREV_BTN_PIN&(1<<BTN_ID)));
;	BTN_ID -> Y+0
	LD   R30,Y
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R5
_0x2100017:
	CALL __LNEGB1
	ADIW R28,1
	RET
; 0000 005C }
;
;void set_time()
; 0000 005F {
_set_time:
; 0000 0060     unsigned char i = 0, x = 3, ok = 0;
; 0000 0061     //char *str[] = {"hh","mm","ss","^^"};
; 0000 0062     char str[4][3] = {"гг","хх","сс","^^"};
; 0000 0063     unsigned char hour = 0, min = 0, sec = 0, wd = 0;
; 0000 0064     rtc_get_time(&hour,&min,&sec);//,&wd);
	SBIW R28,13
	LDI  R24,13
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x5*2)
	LDI  R31,HIGH(_0x5*2)
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
	LDI  R17,0
	LDI  R16,3
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
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
	CALL _rtc_get_time
	POP  R20
	POP  R21
	POP  R18
; 0000 0065     while(!ok)
_0x6:
	CPI  R19,0
	BREQ PC+3
	JMP _0x8
; 0000 0066     {
; 0000 0067         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x0
; 0000 0068         sprintf(lcd_buffer,"%u%u:%u%u:%u%u OK!", hour/10,hour%10, min/10,min%10, sec/10,sec%10);
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
; 0000 0069         lcd_gotoxy(3,0);
; 0000 006A         lcd_puts(lcd_buffer);
; 0000 006B         lcd_gotoxy(x,1);
	ST   -Y,R16
	CALL SUBOPT_0x2
; 0000 006C         lcd_puts(str[i]);
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x3
; 0000 006D         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0x9
; 0000 006E         {
; 0000 006F             //if (!get_prev_key_status(SELECT_PLUS_BTN))
; 0000 0070             //{
; 0000 0071             switch(i)
	CALL SUBOPT_0x4
; 0000 0072             {
; 0000 0073                 case 0:
	BRNE _0xD
; 0000 0074                   if (hour == 23) hour = 0;
	CPI  R18,23
	BRNE _0xE
	LDI  R18,LOW(0)
; 0000 0075                   else hour++;
	RJMP _0xF
_0xE:
	SUBI R18,-1
; 0000 0076                 break;
_0xF:
	RJMP _0xC
; 0000 0077                 case 1:
_0xD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x10
; 0000 0078                   if (min == 59) min = 0;
	CPI  R21,59
	BRNE _0x11
	LDI  R21,LOW(0)
; 0000 0079                   else min++;
	RJMP _0x12
_0x11:
	SUBI R21,-1
; 0000 007A                 break;
_0x12:
	RJMP _0xC
; 0000 007B                 case 2:
_0x10:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 007C                   if (sec == 59) sec = 0;
	CPI  R20,59
	BRNE _0x14
	LDI  R20,LOW(0)
; 0000 007D                   else sec++;
	RJMP _0x15
_0x14:
	SUBI R20,-1
; 0000 007E                 break;
_0x15:
	RJMP _0xC
; 0000 007F                 case 3:
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC
; 0000 0080                   ok = 1;
	LDI  R19,LOW(1)
; 0000 0081                 break;
; 0000 0082             }
_0xC:
; 0000 0083             //}
; 0000 0084             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 0085         }
; 0000 0086         if (get_key_status(SELECT_MINUS_BTN))
_0x9:
	CALL SUBOPT_0x6
	BREQ _0x17
; 0000 0087         {
; 0000 0088             //if (!get_prev_key_status(SELECT_MINUS_BTN))
; 0000 0089             //{
; 0000 008A             switch (i)
	CALL SUBOPT_0x4
; 0000 008B             {
; 0000 008C                 case 0:
	BRNE _0x1B
; 0000 008D                   if (hour == 0) hour = 23;
	CPI  R18,0
	BRNE _0x1C
	LDI  R18,LOW(23)
; 0000 008E                   else hour--;
	RJMP _0x1D
_0x1C:
	SUBI R18,1
; 0000 008F                 break;
_0x1D:
	RJMP _0x1A
; 0000 0090                 case 1:
_0x1B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
; 0000 0091                   if (min == 0) min = 59;
	CPI  R21,0
	BRNE _0x1F
	LDI  R21,LOW(59)
; 0000 0092                   else min--;
	RJMP _0x20
_0x1F:
	SUBI R21,1
; 0000 0093                 break;
_0x20:
	RJMP _0x1A
; 0000 0094                 case 2:
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x21
; 0000 0095                   if (sec == 0) sec = 59;
	CPI  R20,0
	BRNE _0x22
	LDI  R20,LOW(59)
; 0000 0096                   else sec--;
	RJMP _0x23
_0x22:
	SUBI R20,1
; 0000 0097                 break;
_0x23:
	RJMP _0x1A
; 0000 0098                 case 3:
_0x21:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1A
; 0000 0099                   ok = 1;
	LDI  R19,LOW(1)
; 0000 009A                 break;
; 0000 009B             }
_0x1A:
; 0000 009C             // }
; 0000 009D            delay_ms(300);
	CALL SUBOPT_0x5
; 0000 009E         }
; 0000 009F         if(get_key_status(MENU_ENTER_BTN))
_0x17:
	CALL SUBOPT_0x7
	BREQ _0x25
; 0000 00A0         {
; 0000 00A1             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BRNE _0x26
; 0000 00A2             {
; 0000 00A3                 lcd_gotoxy(x,1);
	ST   -Y,R16
	CALL SUBOPT_0x2
; 0000 00A4                 lcd_putsf("  ");
	CALL SUBOPT_0x9
; 0000 00A5                 if (i == 3)
	CPI  R17,3
	BRNE _0x27
; 0000 00A6                 {
; 0000 00A7                     i = 0;
	LDI  R17,LOW(0)
; 0000 00A8                     x = 3;
	LDI  R16,LOW(3)
; 0000 00A9                 }
; 0000 00AA                 else
	RJMP _0x28
_0x27:
; 0000 00AB                 {
; 0000 00AC                   x += 3;
	SUBI R16,-LOW(3)
; 0000 00AD                   i++;
	SUBI R17,-1
; 0000 00AE                 }
_0x28:
; 0000 00AF            }
; 0000 00B0        }
_0x26:
; 0000 00B1        if(get_key_status(EXIT_BTN))
_0x25:
	CALL SUBOPT_0xA
	BREQ _0x29
; 0000 00B2          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xB
	BRNE _0x2A
; 0000 00B3          {
; 0000 00B4             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 00B5             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 00B6             return;
	RJMP _0x2100016
; 0000 00B7          }
; 0000 00B8     }
_0x2A:
_0x29:
	RJMP _0x6
_0x8:
; 0000 00B9   rtc_set_time(hour, min, sec);//, wd);
	ST   -Y,R18
	ST   -Y,R21
	ST   -Y,R20
	CALL _rtc_set_time
; 0000 00BA }
_0x2100016:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
;
;void set_date(void)
; 0000 00BD {
_set_date:
; 0000 00BE     unsigned char ok = 0;
; 0000 00BF     //char str[4][3]={"dd", "mm", "yy", "^^"};
; 0000 00C0     char str[4][3]={"дд", "мм", "рр", "^^"};
; 0000 00C1     unsigned char i = 0, x = 3;
; 0000 00C2     unsigned char date, month, year;
; 0000 00C3     rtc_get_date(&date,&month,&year);
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2B*2)
	LDI  R31,HIGH(_0x2B*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	ok -> R17
;	str -> Y+6
;	i -> R16
;	x -> R19
;	date -> R18
;	month -> R21
;	year -> R20
	LDI  R17,0
	LDI  R16,0
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
; 0000 00C4     lcd_clear();
	CALL _lcd_clear
; 0000 00C5     while(!ok)
_0x2C:
	CPI  R17,0
	BREQ PC+3
	JMP _0x2E
; 0000 00C6     {
; 0000 00C7         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x0
; 0000 00C8         sprintf(lcd_buffer, "%u%u/%u%u/%u%u OK!", date/10,date%10, month/10,month%10, year/10,year%10);
	__POINTW1FN _0x0,22
	CALL SUBOPT_0x1
; 0000 00C9         lcd_gotoxy(3, 0);
; 0000 00CA         lcd_puts(lcd_buffer);
; 0000 00CB         lcd_gotoxy(x, 1);
	ST   -Y,R19
	CALL SUBOPT_0x2
; 0000 00CC         lcd_puts(str[i]);
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x3
; 0000 00CD         if (get_key_status(SELECT_PLUS_BTN))
	BREQ _0x2F
; 0000 00CE         {
; 0000 00CF            if (get_key_status(SELECT_PLUS_BTN))
	CALL SUBOPT_0xC
	BREQ _0x30
; 0000 00D0               if (!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
	BRNE _0x31
; 0000 00D1               {
; 0000 00D2                  switch (i)
	MOV  R30,R16
	CALL SUBOPT_0xE
; 0000 00D3                  {
; 0000 00D4                     case 0:
	BRNE _0x35
; 0000 00D5                       if (date == 31) date = 0;
	CPI  R18,31
	BRNE _0x36
	LDI  R18,LOW(0)
; 0000 00D6                       else date++;
	RJMP _0x37
_0x36:
	SUBI R18,-1
; 0000 00D7                     break;
_0x37:
	RJMP _0x34
; 0000 00D8                     case 1:
_0x35:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x38
; 0000 00D9                       if (month == 12) month = 0;
	CPI  R21,12
	BRNE _0x39
	LDI  R21,LOW(0)
; 0000 00DA                       else month++;
	RJMP _0x3A
_0x39:
	SUBI R21,-1
; 0000 00DB                     break;
_0x3A:
	RJMP _0x34
; 0000 00DC                     case 2:
_0x38:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00DD                        if (year == 99) year = 0;
	CPI  R20,99
	BRNE _0x3C
	LDI  R20,LOW(0)
; 0000 00DE                        else year++;
	RJMP _0x3D
_0x3C:
	SUBI R20,-1
; 0000 00DF                     break;
_0x3D:
	RJMP _0x34
; 0000 00E0                     case 3:
_0x3B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x34
; 0000 00E1                       ok = 1;
	LDI  R17,LOW(1)
; 0000 00E2                     break;
; 0000 00E3                   }
_0x34:
; 0000 00E4                }
; 0000 00E5         }
_0x31:
_0x30:
; 0000 00E6         if (get_key_status(SELECT_MINUS_BTN))
_0x2F:
	CALL SUBOPT_0x6
	BREQ _0x3F
; 0000 00E7         {
; 0000 00E8             if (get_key_status(SELECT_MINUS_BTN))
	CALL SUBOPT_0x6
	BREQ _0x40
; 0000 00E9               if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
	BRNE _0x41
; 0000 00EA               {
; 0000 00EB                 switch (i)
	MOV  R30,R16
	CALL SUBOPT_0xE
; 0000 00EC                 {
; 0000 00ED                     case 0:
	BRNE _0x45
; 0000 00EE                       if (date == 0) date = 31;
	CPI  R18,0
	BRNE _0x46
	LDI  R18,LOW(31)
; 0000 00EF                       else date--;
	RJMP _0x47
_0x46:
	SUBI R18,1
; 0000 00F0                     break;
_0x47:
	RJMP _0x44
; 0000 00F1                     case 1:
_0x45:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x48
; 0000 00F2                        if (month == 0) month = 12;
	CPI  R21,0
	BRNE _0x49
	LDI  R21,LOW(12)
; 0000 00F3                        else month--;
	RJMP _0x4A
_0x49:
	SUBI R21,1
; 0000 00F4                     break;
_0x4A:
	RJMP _0x44
; 0000 00F5                     case 2:
_0x48:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4B
; 0000 00F6                        if (year == 0) year = 99;
	CPI  R20,0
	BRNE _0x4C
	LDI  R20,LOW(99)
; 0000 00F7                        else year--;
	RJMP _0x4D
_0x4C:
	SUBI R20,1
; 0000 00F8                     break;
_0x4D:
	RJMP _0x44
; 0000 00F9                     case 3:
_0x4B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x44
; 0000 00FA                       ok = 1;
	LDI  R17,LOW(1)
; 0000 00FB                     break;
; 0000 00FC                 }
_0x44:
; 0000 00FD             }
; 0000 00FE         }
_0x41:
_0x40:
; 0000 00FF         if (get_key_status(MENU_ENTER_BTN))
_0x3F:
	CALL SUBOPT_0x7
	BREQ _0x4F
; 0000 0100         {
; 0000 0101             if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BRNE _0x50
; 0000 0102             {
; 0000 0103                 lcd_gotoxy(x, 1);
	ST   -Y,R19
	CALL SUBOPT_0x2
; 0000 0104                 lcd_putsf("  ");
	CALL SUBOPT_0x9
; 0000 0105                 if (i == 3)
	CPI  R16,3
	BRNE _0x51
; 0000 0106                 {
; 0000 0107                     i = 0;
	LDI  R16,LOW(0)
; 0000 0108                     x = 3;
	LDI  R19,LOW(3)
; 0000 0109                 }
; 0000 010A                 else
	RJMP _0x52
_0x51:
; 0000 010B                 {
; 0000 010C                     i++;
	SUBI R16,-1
; 0000 010D                     x += 3;
	SUBI R19,-LOW(3)
; 0000 010E                 }
_0x52:
; 0000 010F             }
; 0000 0110        }
_0x50:
; 0000 0111        if (get_key_status(EXIT_BTN))
_0x4F:
	CALL SUBOPT_0xA
	BREQ _0x53
; 0000 0112          if (!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xB
	BRNE _0x54
; 0000 0113             {
; 0000 0114                delay_ms(300);
	CALL SUBOPT_0x5
; 0000 0115                PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 0116                return;
	RJMP _0x2100015
; 0000 0117             }
; 0000 0118  }
_0x54:
_0x53:
	RJMP _0x2C
_0x2E:
; 0000 0119  rtc_set_date(date, month, year);
	ST   -Y,R18
	ST   -Y,R21
	ST   -Y,R20
	CALL _rtc_set_date
; 0000 011A }
_0x2100015:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;
;void set_values(unsigned char j, values_range *p)
; 0000 011D {
_set_values:
; 0000 011E     char str[3][4]={"<=","<=","OK!"};
; 0000 011F     unsigned char i = 0, xpos[] = {14, 14, 13}, ypos[] = {0,1,1};
; 0000 0120     unsigned char ok = 0;
; 0000 0121     values_range v[4] = {{0,99},{10,100},{0,100},{300,1000}};
; 0000 0122     values_range tmp;
; 0000 0123     tmp = *p;
	SBIW R28,38
	LDI  R24,34
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x55*2)
	LDI  R31,HIGH(_0x55*2)
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
	LDI  R17,0
	LDI  R16,0
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	MOVW R26,R28
	ADIW R26,2
	LDI  R24,4
	CALL __COPYMML
; 0000 0124 
; 0000 0125     lcd_clear();
	CALL _lcd_clear
; 0000 0126 
; 0000 0127     while(!ok)
_0x56:
	CPI  R16,0
	BREQ PC+3
	JMP _0x58
; 0000 0128     {
; 0000 0129         PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 012A         switch (j)
	LDD  R30,Y+42
	CALL SUBOPT_0xE
; 0000 012B         {
; 0000 012C             case 0:
	BRNE _0x5C
; 0000 012D               sprintf(lcd_buffer,"Tmin: %u%cC \nTmax: %u%cC ", tmp.min, 0xdf, tmp.max, 0xdf);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 012E             break;
	RJMP _0x5B
; 0000 012F             case 1:
_0x5C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0130               sprintf(lcd_buffer,"Hmin: %u%% \nHmax: %u%% ", tmp.min, tmp.max);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,67
	RJMP _0xD4
; 0000 0131             break;
; 0000 0132             case 2:
_0x5D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5E
; 0000 0133               sprintf(lcd_buffer,"Smin: %u%% \nSmax: %u%% ", tmp.min, tmp.max);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,91
	RJMP _0xD4
; 0000 0134             break;
; 0000 0135             case 3:
_0x5E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5B
; 0000 0136               sprintf(lcd_buffer,"Imin: %u lx \nImax: %u lx ", tmp.min, tmp.max);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,115
_0xD4:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x12
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0137             break;
; 0000 0138         }
_0x5B:
; 0000 0139         lcd_gotoxy(0,0);
	CALL SUBOPT_0x13
; 0000 013A         lcd_puts(lcd_buffer);
	CALL SUBOPT_0x14
; 0000 013B         lcd_gotoxy(xpos[i],ypos[i]);
	CALL SUBOPT_0x15
; 0000 013C         lcd_puts(str[i]);
	CALL SUBOPT_0x16
	MOVW R26,R28
	ADIW R26,28
	CALL __LSLW2
	CALL SUBOPT_0x3
; 0000 013D 
; 0000 013E         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0x60
; 0000 013F         {
; 0000 0140             //if (!get_prev_key_status(SELECT_PLUS_BTN))
; 0000 0141             {
; 0000 0142                 switch(i)
	CALL SUBOPT_0x4
; 0000 0143                 {
; 0000 0144                     case 0:
	BRNE _0x64
; 0000 0145                       if (tmp.min < tmp.max) tmp.min++;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x65
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0146                     break;
_0x65:
	RJMP _0x63
; 0000 0147                     case 1:
_0x64:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x66
; 0000 0148                       if (tmp.max < v[j].max) tmp.max++;
	CALL SUBOPT_0x17
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x67
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0149                     break;
_0x67:
	RJMP _0x63
; 0000 014A                     case 2:
_0x66:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x63
; 0000 014B                       ok = 1;
	LDI  R16,LOW(1)
; 0000 014C                     break;
; 0000 014D                 }
_0x63:
; 0000 014E             }
; 0000 014F             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 0150         }
; 0000 0151         if (get_key_status(SELECT_MINUS_BTN))
_0x60:
	CALL SUBOPT_0x6
	BREQ _0x69
; 0000 0152         {
; 0000 0153             //if (!get_prev_key_status(SELECT_MINUS_BTN))
; 0000 0154             {
; 0000 0155                 switch (i) {
	CALL SUBOPT_0x4
; 0000 0156                    case 0:
	BRNE _0x6D
; 0000 0157                      if (tmp.min > v[j].min) tmp.min--;
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x6E
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0158                      break;
_0x6E:
	RJMP _0x6C
; 0000 0159                    case 1:
_0x6D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6F
; 0000 015A                      if (tmp.max > tmp.min) tmp.max--;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x70
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 015B                    break;
_0x70:
	RJMP _0x6C
; 0000 015C                    case 2:
_0x6F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6C
; 0000 015D                      ok = 1;
	LDI  R16,LOW(1)
; 0000 015E                    break;
; 0000 015F                 }
_0x6C:
; 0000 0160 
; 0000 0161          }
; 0000 0162          delay_ms(300);
	CALL SUBOPT_0x5
; 0000 0163      }
; 0000 0164      if(get_key_status(MENU_ENTER_BTN))
_0x69:
	CALL SUBOPT_0x7
	BREQ _0x72
; 0000 0165      {
; 0000 0166        if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BRNE _0x73
; 0000 0167        {
; 0000 0168           lcd_gotoxy(xpos[i],ypos[i]);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
; 0000 0169           lcd_putsf("  ");
	CALL SUBOPT_0x9
; 0000 016A           if (i==2)
	CPI  R17,2
	BRNE _0x74
; 0000 016B           {
; 0000 016C              i=0;
	LDI  R17,LOW(0)
; 0000 016D              lcd_putsf(" ");
	__POINTW1FN _0x0,20
	CALL SUBOPT_0x19
; 0000 016E           }
; 0000 016F           else
	RJMP _0x75
_0x74:
; 0000 0170             i++;
	SUBI R17,-1
; 0000 0171          }
_0x75:
; 0000 0172        }
_0x73:
; 0000 0173        if(get_key_status(EXIT_BTN))
_0x72:
	CALL SUBOPT_0xA
	BREQ _0x76
; 0000 0174          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xB
	BRNE _0x77
; 0000 0175          {
; 0000 0176             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 0177             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 0178             return;
	RJMP _0x2100014
; 0000 0179          }
; 0000 017A     }
_0x77:
_0x76:
	RJMP _0x56
_0x58:
; 0000 017B     *p = tmp;
	MOVW R30,R28
	ADIW R30,2
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	LDI  R24,4
	CALL __COPYMML
; 0000 017C }
_0x2100014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,43
	RET
;
;void set_watering()
; 0000 017F {
_set_watering:
; 0000 0180     unsigned char i = 0, j = 0, x = 0, ok = 0;
; 0000 0181     //char *str[] = {"pr", "hh","mm","^^", "^^"};
; 0000 0182     char *str[5] = {"пр", "гг","хх","^^", "^^"};
; 0000 0183     unsigned char hour, min, mode_on_off;
; 0000 0184     char *s_mode[] = {"OFF", "ON "};
; 0000 0185 
; 0000 0186     hour = w_time[j].hour;
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x79*2)
	LDI  R31,HIGH(_0x79*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	i -> R17
;	j -> R16
;	x -> R19
;	ok -> R18
;	str -> Y+11
;	hour -> R21
;	min -> R20
;	mode_on_off -> Y+10
;	s_mode -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	CALL SUBOPT_0x1A
; 0000 0187     min = w_time[j].min;
; 0000 0188     mode_on_off = w_time[j].mode_on_off;
; 0000 0189 
; 0000 018A     while(!ok)
_0x7A:
	CPI  R18,0
	BREQ PC+3
	JMP _0x7C
; 0000 018B     {
; 0000 018C         PREV_BTN_PIN = BTN_PIN;
	CALL SUBOPT_0x0
; 0000 018D         sprintf(lcd_buffer,"#%u %u%u:%u%u %s OK!", j+1, hour/10,hour%10, min/10,min%10, s_mode[mode_on_off]);
	__POINTW1FN _0x0,161
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R21
	CALL SUBOPT_0x1C
	MOV  R26,R21
	CALL SUBOPT_0x1D
	MOV  R26,R20
	CALL SUBOPT_0x1C
	MOV  R26,R20
	CALL SUBOPT_0x1D
	LDD  R30,Y+34
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x12
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
; 0000 018E         lcd_gotoxy(0,0);
	CALL SUBOPT_0x13
; 0000 018F         lcd_puts(lcd_buffer);
	CALL _lcd_puts
; 0000 0190         lcd_gotoxy(x,1);
	ST   -Y,R19
	CALL SUBOPT_0x2
; 0000 0191         lcd_puts(str[i]);
	CALL SUBOPT_0x16
	MOVW R26,R28
	ADIW R26,11
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 0192         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0x7D
; 0000 0193         {
; 0000 0194             //if (!get_prev_key_status(SELECT_PLUS_BTN))
; 0000 0195             //{
; 0000 0196             switch(i)
	CALL SUBOPT_0x4
; 0000 0197             {
; 0000 0198                 case 0:
	BRNE _0x81
; 0000 0199                   if (j < WATERING_TIME_NUMBER - 1) j++;
	CPI  R16,7
	BRSH _0x82
	SUBI R16,-1
; 0000 019A                   else j = 0;
	RJMP _0x83
_0x82:
	LDI  R16,LOW(0)
; 0000 019B                   hour = w_time[j].hour;
_0x83:
	CALL SUBOPT_0x1A
; 0000 019C                   min = w_time[j].min;
; 0000 019D                   mode_on_off = w_time[j].mode_on_off;
; 0000 019E                   break;
	RJMP _0x80
; 0000 019F                 case 1:
_0x81:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x84
; 0000 01A0                   if (hour == 23) hour = 0;
	CPI  R21,23
	BRNE _0x85
	LDI  R21,LOW(0)
; 0000 01A1                   else hour++;
	RJMP _0x86
_0x85:
	SUBI R21,-1
; 0000 01A2                 break;
_0x86:
	RJMP _0x80
; 0000 01A3                 case 2:
_0x84:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x87
; 0000 01A4                   if (min == 59) min = 0;
	CPI  R20,59
	BRNE _0x88
	LDI  R20,LOW(0)
; 0000 01A5                   else min++;
	RJMP _0x89
_0x88:
	SUBI R20,-1
; 0000 01A6                 break;
_0x89:
	RJMP _0x80
; 0000 01A7                 case 3:
_0x87:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8A
; 0000 01A8                   if (mode_on_off) mode_on_off = 0;
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x8B
	LDI  R30,LOW(0)
	RJMP _0xD5
; 0000 01A9                   else mode_on_off = 1;
_0x8B:
	LDI  R30,LOW(1)
_0xD5:
	STD  Y+10,R30
; 0000 01AA                 break;
	RJMP _0x80
; 0000 01AB                 case 4:
_0x8A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x80
; 0000 01AC                   ok = 1;
	LDI  R18,LOW(1)
; 0000 01AD                 break;
; 0000 01AE             }
_0x80:
; 0000 01AF             //}
; 0000 01B0             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 01B1         }
; 0000 01B2         if (get_key_status(SELECT_MINUS_BTN))
_0x7D:
	CALL SUBOPT_0x6
	BREQ _0x8E
; 0000 01B3         {
; 0000 01B4             //if (!get_prev_key_status(SELECT_MINUS_BTN))
; 0000 01B5             //{
; 0000 01B6             switch (i)
	CALL SUBOPT_0x4
; 0000 01B7             {
; 0000 01B8                 case 0:
	BRNE _0x92
; 0000 01B9                   if (j > 0) j--;
	CPI  R16,1
	BRLO _0x93
	SUBI R16,1
; 0000 01BA                   else j = WATERING_TIME_NUMBER;
	RJMP _0x94
_0x93:
	LDI  R16,LOW(8)
; 0000 01BB                   hour = w_time[j].hour;
_0x94:
	CALL SUBOPT_0x1A
; 0000 01BC                   min = w_time[j].min;
; 0000 01BD                   mode_on_off = w_time[j].mode_on_off;
; 0000 01BE                   break;
	RJMP _0x91
; 0000 01BF                 case 1:
_0x92:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x95
; 0000 01C0                   if (hour == 0) hour = 23;
	CPI  R21,0
	BRNE _0x96
	LDI  R21,LOW(23)
; 0000 01C1                   else hour--;
	RJMP _0x97
_0x96:
	SUBI R21,1
; 0000 01C2                 break;
_0x97:
	RJMP _0x91
; 0000 01C3                 case 2:
_0x95:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x98
; 0000 01C4                   if (min == 0) min = 59;
	CPI  R20,0
	BRNE _0x99
	LDI  R20,LOW(59)
; 0000 01C5                   else min--;
	RJMP _0x9A
_0x99:
	SUBI R20,1
; 0000 01C6                 break;
_0x9A:
	RJMP _0x91
; 0000 01C7                 case 3:
_0x98:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9B
; 0000 01C8                   if (!mode_on_off) mode_on_off = 1;
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x9C
	LDI  R30,LOW(1)
	RJMP _0xD6
; 0000 01C9                   else mode_on_off = 0;
_0x9C:
	LDI  R30,LOW(0)
_0xD6:
	STD  Y+10,R30
; 0000 01CA                 break;
	RJMP _0x91
; 0000 01CB                 case 4:
_0x9B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x91
; 0000 01CC                   ok = 1;
	LDI  R18,LOW(1)
; 0000 01CD                 break;
; 0000 01CE             }
_0x91:
; 0000 01CF             // }
; 0000 01D0            delay_ms(300);
	CALL SUBOPT_0x5
; 0000 01D1         }
; 0000 01D2         if(get_key_status(MENU_ENTER_BTN))
_0x8E:
	CALL SUBOPT_0x7
	BREQ _0x9F
; 0000 01D3         {
; 0000 01D4             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BRNE _0xA0
; 0000 01D5             {
; 0000 01D6                 lcd_gotoxy(x,1);
	ST   -Y,R19
	CALL SUBOPT_0x2
; 0000 01D7                 lcd_putsf("  ");
	CALL SUBOPT_0x9
; 0000 01D8                 if (i == 4)
	CPI  R17,4
	BRNE _0xA1
; 0000 01D9                 {
; 0000 01DA                     i = 0;
	LDI  R17,LOW(0)
; 0000 01DB                     x = 0;
	LDI  R19,LOW(0)
; 0000 01DC                 }
; 0000 01DD                 else
	RJMP _0xA2
_0xA1:
; 0000 01DE                 {
; 0000 01DF                   if (x == 9)
	CPI  R19,9
	BRNE _0xA3
; 0000 01E0                     x += 4;
	SUBI R19,-LOW(4)
; 0000 01E1                   else x += 3;
	RJMP _0xA4
_0xA3:
	SUBI R19,-LOW(3)
; 0000 01E2                   i++;
_0xA4:
	SUBI R17,-1
; 0000 01E3                 }
_0xA2:
; 0000 01E4            }
; 0000 01E5        }
_0xA0:
; 0000 01E6        if(get_key_status(EXIT_BTN))
_0x9F:
	CALL SUBOPT_0xA
	BREQ _0xA5
; 0000 01E7          if(!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xB
	BRNE _0xA6
; 0000 01E8          {
; 0000 01E9             delay_ms(300);
	CALL SUBOPT_0x5
; 0000 01EA             PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 01EB             return;
	RJMP _0x2100013
; 0000 01EC          }
; 0000 01ED     }
_0xA6:
_0xA5:
	RJMP _0x7A
_0x7C:
; 0000 01EE     w_time[j].hour = hour;
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_w_time)
	SBCI R31,HIGH(-_w_time)
	ST   Z,R21
; 0000 01EF     w_time[j].min = min;
	MUL  R16,R26
	MOVW R30,R0
	__ADDW1MN _w_time,1
	ST   Z,R20
; 0000 01F0     w_time[j].mode_on_off = mode_on_off;
	MUL  R16,R26
	MOVW R30,R0
	__ADDW1MN _w_time,2
	LDD  R26,Y+10
	STD  Z+0,R26
; 0000 01F1 }
_0x2100013:
	CALL __LOADLOCR6
	ADIW R28,21
	RET

	.DSEG
_0x78:
	.BYTE 0x17
;
;
;void main_menu(void)
; 0000 01F5 {

	.CSEG
_main_menu:
; 0000 01F6     char *menu_items[8]={"DATE", "TIME", "WATERING", "TEMPERATURE",
; 0000 01F7         "HUMIDITY", "SOIL MOISTURE", "LIGHT INTENSITY","EXIT"};
; 0000 01F8     int pos[] = {6, 6, 4, 2, 4, 2, 0, 6};
; 0000 01F9    /* char *menu_items[8]={"ДАТА", "ЧАС", "ПОЛИВ", "ТЕМПЕРАТУРА",
; 0000 01FA         "ВОЛОГIСТЬ", "ВОЛОГIСТЬ ГРУНТУ", "ОСВIТЛЕННЯ","ВИХIД"};
; 0000 01FB     int pos[] = {6, 6, 5, 2, 4, 0, 3, 5};*/
; 0000 01FC     char title[] = "** Main Menu **";
; 0000 01FD     //char title[] = "* Головне Меню *";
; 0000 01FE     unsigned char i = 0;
; 0000 01FF 
; 0000 0200     while(1)
	SBIW R28,48
	LDI  R24,48
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xA8*2)
	LDI  R31,HIGH(_0xA8*2)
	CALL __INITLOCB
	ST   -Y,R17
;	menu_items -> Y+33
;	pos -> Y+17
;	title -> Y+1
;	i -> R17
	LDI  R17,0
_0xA9:
; 0000 0201     {
; 0000 0202         PREV_BTN_PIN = BTN_PIN;
	IN   R5,22
; 0000 0203         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x20
; 0000 0204         lcd_puts(title);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
; 0000 0205         lcd_gotoxy(pos[i],1);
	MOVW R26,R28
	ADIW R26,17
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 0206         lcd_puts(menu_items[i]);
	CALL SUBOPT_0x16
	MOVW R26,R28
	ADIW R26,33
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 0207         if(get_key_status(SELECT_PLUS_BTN))
	BREQ _0xAC
; 0000 0208         {
; 0000 0209             if(!get_prev_key_status(SELECT_PLUS_BTN))
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
	BRNE _0xAD
; 0000 020A             {
; 0000 020B                 if(i == 7) i = 0;
	CPI  R17,7
	BRNE _0xAE
	LDI  R17,LOW(0)
; 0000 020C                 else i++;
	RJMP _0xAF
_0xAE:
	SUBI R17,-1
; 0000 020D                 lcd_clear();
_0xAF:
	CALL _lcd_clear
; 0000 020E             }
; 0000 020F         }
_0xAD:
; 0000 0210         if(get_key_status(SELECT_MINUS_BTN))
_0xAC:
	CALL SUBOPT_0x6
	BREQ _0xB0
; 0000 0211         {
; 0000 0212             if (!get_prev_key_status(SELECT_MINUS_BTN))
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
	BRNE _0xB1
; 0000 0213             {
; 0000 0214                 if (i == 0) i = 7;
	CPI  R17,0
	BRNE _0xB2
	LDI  R17,LOW(7)
; 0000 0215                 else i--;
	RJMP _0xB3
_0xB2:
	SUBI R17,1
; 0000 0216                 lcd_clear();
_0xB3:
	CALL _lcd_clear
; 0000 0217             }
; 0000 0218         }
_0xB1:
; 0000 0219         if(get_key_status(MENU_ENTER_BTN))
_0xB0:
	CALL SUBOPT_0x7
	BRNE PC+3
	JMP _0xB4
; 0000 021A             if(!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BREQ PC+3
	JMP _0xB5
; 0000 021B             {
; 0000 021C                 lcd_clear();
	CALL _lcd_clear
; 0000 021D                 switch(i)
	CALL SUBOPT_0x4
; 0000 021E                 {
; 0000 021F                     case 0: set_date(); break; // date
	BRNE _0xB9
	RCALL _set_date
	RJMP _0xB8
; 0000 0220                     case 1: set_time(); break; // time
_0xB9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBA
	RCALL _set_time
	RJMP _0xB8
; 0000 0221                     case 2: set_watering(); break; // watering
_0xBA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBB
	RCALL _set_watering
	RJMP _0xB8
; 0000 0222                     case 3: set_values(0, &temp); break; // temperature
_0xBB:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xBC
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	CALL SUBOPT_0x21
	RJMP _0xB8
; 0000 0223                     case 4: set_values(1, &hum); break; // humidity
_0xBC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xBD
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_hum)
	LDI  R31,HIGH(_hum)
	CALL SUBOPT_0x21
	RJMP _0xB8
; 0000 0224                     case 5: set_values(2,&soil); break; // soil moisture
_0xBD:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xBE
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(_soil)
	LDI  R31,HIGH(_soil)
	CALL SUBOPT_0x21
	RJMP _0xB8
; 0000 0225                     case 6: set_values(3, &light); break;
_0xBE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xBF
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(_light)
	LDI  R31,HIGH(_light)
	CALL SUBOPT_0x21
	RJMP _0xB8
; 0000 0226                     case 7: return;
_0xBF:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ _0x2100012
; 0000 0227                     default: break;
; 0000 0228             }
_0xB8:
; 0000 0229             lcd_clear();
	CALL _lcd_clear
; 0000 022A       }
; 0000 022B       if (get_key_status(EXIT_BTN))
_0xB5:
_0xB4:
	CALL SUBOPT_0xA
	BREQ _0xC2
; 0000 022C         if (!get_prev_key_status(EXIT_BTN))
	CALL SUBOPT_0xB
	BREQ _0x2100012
; 0000 022D         {
; 0000 022E            return;
; 0000 022F         }
; 0000 0230 
; 0000 0231     }
_0xC2:
	RJMP _0xA9
; 0000 0232 }
_0x2100012:
	LDD  R17,Y+0
	ADIW R28,49
	RET

	.DSEG
_0xA7:
	.BYTE 0x4B
;
;void main(void)
; 0000 0235 {

	.CSEG
_main:
; 0000 0236   /* program that shows how to use SHTXX, DS18B20 functions and to display information on LCD */
; 0000 0237 
; 0000 0238   value humi_val = {0}, temp_val = {0};
; 0000 0239   float temp_ds = 0, dew_point = 0;
; 0000 023A   unsigned int soil_val = 0, light_val = 0;
; 0000 023B   unsigned char error, checksum, value = 1;
; 0000 023C   unsigned int vin, start;
; 0000 023D   unsigned char hour, min, sec, wd;
; 0000 023E   //unsigned char date, month, year;
; 0000 023F   char *weekdays[7]={"Sun","Mon","Tue","Wed","Thr","Fri","Sat"};
; 0000 0240   //char *weekdays[7]={"Нд.","Пн.","Вт.","Ср.","Чт.","Пт.","Сб."};
; 0000 0241   //char *monthes[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
; 0000 0242   //char *monthes[]={"Сiч.","Лют.","Бер.","Квiт.","Трав.","Черв.","Лип.","Серп.","Вер.","Жовт.","Лист.","Груд."};
; 0000 0243 
; 0000 0244   //initADC();
; 0000 0245   sht_init();
	SBIW R28,39
	LDI  R24,39
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xC5*2)
	LDI  R31,HIGH(_0xC5*2)
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
;	weekdays -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	CALL _sht_init
; 0000 0246   s_connectionreset();
	CALL _s_connectionreset
; 0000 0247   therm_init(-55, 125, THERM_9BIT_RES);
	LDI  R30,LOW(201)
	ST   -Y,R30
	LDI  R30,LOW(125)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _therm_init
; 0000 0248   i2c_init();  // I2C Bus initialization
	CALL _i2c_init
; 0000 0249   // DS1307 Real Time Clock initialization
; 0000 024A   rtc_init(0,1,0);  // Square wave output on pin SQW/OUT: Off // SQW/OUT pin state: 0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _rtc_init
; 0000 024B  // start = rtc_read(0)&0x80;
; 0000 024C  // if (start)
; 0000 024D   //  rtc_write(0,0x00);  //start clock
; 0000 024E 
; 0000 024F   //LCD initialization
; 0000 0250   lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0251   lcd_clear();
	CALL _lcd_clear
; 0000 0252   //lcd_gotoxy(2,0);
; 0000 0253   //lcd_putsf("Microclimate");
; 0000 0254   //lcd_gotoxy(1,1);
; 0000 0255   //lcd_putsf("Control System");
; 0000 0256   lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x20
; 0000 0257   lcd_putsf("СИСТЕМА");
	__POINTW1FN _0x0,285
	CALL SUBOPT_0x19
; 0000 0258   lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 0259   lcd_putsf("УПРАВЛIННЯ");
	__POINTW1FN _0x0,293
	CALL SUBOPT_0x19
; 0000 025A   delay_ms(2000);
	CALL SUBOPT_0x22
; 0000 025B   lcd_clear();
; 0000 025C   lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x20
; 0000 025D   lcd_putsf("МIКРОКЛIМАТОМ");
	__POINTW1FN _0x0,304
	CALL SUBOPT_0x19
; 0000 025E   lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 025F   lcd_putsf("В ТЕПЛИЦI");
	__POINTW1FN _0x0,318
	CALL SUBOPT_0x19
; 0000 0260   delay_ms(2000);
	CALL SUBOPT_0x22
; 0000 0261   lcd_clear();
; 0000 0262   lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x20
; 0000 0263   lcd_putsf("Andriy Halakh");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x19
; 0000 0264   //lcd_putsf("А. Галах");
; 0000 0265   lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 0266   lcd_putsf("(C) 2017");
	__POINTW1FN _0x0,342
	CALL SUBOPT_0x19
; 0000 0267   delay_ms(2000);
	CALL SUBOPT_0x22
; 0000 0268   lcd_clear();
; 0000 0269  //set SHTXX sensor resolution for temperature 12 bit and for humidity 8 bit
; 0000 026A   s_write_statusreg(&value);
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	CALL _s_write_statusreg
; 0000 026B   s_read_statusreg(&value, &checksum);
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
; 0000 026C 
; 0000 026D   REL1_DDR|=(1<<REL1);  // REL1 0x20
	SBI  0x14,5
; 0000 026E   REL1_PORT&=~(1<<REL1); // REL1 - off 0xdf
	CBI  0x15,5
; 0000 026F   REL2_DDR|=(1<<REL2);  // REL2 0x40
	SBI  0x14,6
; 0000 0270   REL2_PORT|=(1<<REL2); // REL2 - off 0xbf
	SBI  0x15,6
; 0000 0271   REL3_DDR|=(1<<REL3);  // REL3 0x80
	SBI  0x14,7
; 0000 0272   REL3_PORT&=~(1<<REL3); // REL3 - off 0x7f
	CBI  0x15,7
; 0000 0273 
; 0000 0274   while(1)
_0xC6:
; 0000 0275   {
; 0000 0276     therm_read_temperature(&temp_ds); //measures temperature from DS18B20
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	RCALL _therm_read_temperature
; 0000 0277     error = 0;
	LDI  R21,LOW(0)
; 0000 0278     error += s_measure((unsigned char*) &humi_val.i, &checksum,HUMI);  //measure humidity
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
	ADD  R21,R30
; 0000 0279     error += s_measure((unsigned char*) &temp_val.i, &checksum,TEMP);  //measure temperature
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
	ADD  R21,R30
; 0000 027A     if (error!=0)
	CPI  R21,0
	BREQ _0xC9
; 0000 027B       s_connectionreset(); //in case of an error: connection reset
	CALL _s_connectionreset
; 0000 027C     else
	RJMP _0xCA
_0xC9:
; 0000 027D     {
; 0000 027E       humi_val.f = (float)humi_val.i;  //converts integer to float
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x23
	__PUTD1S 35
; 0000 027F       temp_val.f = (float)temp_val.i;   //converts integer to float
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	CALL SUBOPT_0x23
	__PUTD1S 31
; 0000 0280       calc_sth11(&humi_val.f, &temp_val.f); //calculate humidity, temperature
	MOVW R30,R28
	ADIW R30,35
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	CALL _calc_sth11
; 0000 0281       dew_point = calc_dewpoint(humi_val.f, temp_val.f); //calculate dew point
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL _calc_dewpoint
	__PUTD1S 23
; 0000 0282 
; 0000 0283       sprintf(lcd_buffer,"%+3.1f%cC %3.1f%% RH ", temp_ds,
; 0000 0284       0xdf, humi_val.f);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,351
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 31
	CALL __PUTPARD1
	CALL SUBOPT_0x11
	__GETD1S 47
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0285       lcd_gotoxy(0,0);
	CALL SUBOPT_0x13
; 0000 0286       lcd_puts(lcd_buffer);
	CALL _lcd_puts
; 0000 0287       sprintf(lcd_buffer,"%+d%cC ",(int)temp_val.f, 0xdf);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,373
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 35
	CALL __CFD1
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x11
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0288       lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 0289       lcd_puts(lcd_buffer);
	CALL SUBOPT_0xF
	CALL _lcd_puts
; 0000 028A     }
_0xCA:
; 0000 028B     // check temperature value
; 0000 028C     if (temp_ds > temp.max)
	__GETW1MN _temp,2
	__GETD2S 27
	CALL SUBOPT_0x23
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCB
; 0000 028D     {
; 0000 028E        REL1_PORT|=0x20;
	SBI  0x15,5
; 0000 028F     }
; 0000 0290     else //if (temp_ds < temp.min)
_0xCB:
; 0000 0291     {
; 0000 0292      // REL1_PORT&=0xdf;
; 0000 0293     }
; 0000 0294     // check humidity value
; 0000 0295     if (humi_val.f < hum.min)
	LDS  R30,_hum
	LDS  R31,_hum+1
	__GETD2S 35
	CALL SUBOPT_0x23
	CALL __CMPF12
	BRSH _0xCD
; 0000 0296     {
; 0000 0297       REL2_PORT|=0x40;
	SBI  0x15,6
; 0000 0298     }
; 0000 0299     else //if (humi_val.f > hum.max)
_0xCD:
; 0000 029A     {
; 0000 029B       //REL2_PORT&=0xbf;
; 0000 029C     }
; 0000 029D     // check soil moisture value
; 0000 029E     /*if (soil_val < soil.min)
; 0000 029F     {
; 0000 02A0         REL2_PORT|=0x40;
; 0000 02A1     }
; 0000 02A2     else //if (soil_val > soil.max)
; 0000 02A3     {
; 0000 02A4         REL2_PORT&=0xbf;
; 0000 02A5     }*/
; 0000 02A6     // check light intensity value
; 0000 02A7     if (light_val < light.min)
	LDS  R30,_light
	LDS  R31,_light+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0xCF
; 0000 02A8     {
; 0000 02A9         REL3_PORT|=0x80;
	SBI  0x15,7
; 0000 02AA     }
; 0000 02AB     else //if (light_val > light.max)
_0xCF:
; 0000 02AC     {
; 0000 02AD 	   // REL3_PORT&=0x7f;
; 0000 02AE     }
; 0000 02AF     REL2_PORT|=0x40;
	SBI  0x15,6
; 0000 02B0     /*vin=readADC(5); //measure pressure ADC5 pin
; 0000 02B1     pressure=press_m(vin); //calculate pressure
; 0000 02B2     //print pressure from MPX4115
; 0000 02B3     sprintf(lcd_buffer,"%uкПа %.1fатм ",pressure, (pressure/101.325));
; 0000 02B4     lcd_goto_xy(2,3);
; 0000 02B5     lcd_str(lcd_buffer);*/
; 0000 02B6     rtc_get_time(&hour,&min,&sec);//, &wd);
	MOVW R30,R28
	ADIW R30,17
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,18
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
; 0000 02B7     //rtc_get_date(&date,&month,&year);
; 0000 02B8     //print time
; 0000 02B9     sprintf(lcd_buffer, "%u%u:%u%u %s", hour/10,hour%10, min/10,min%10, weekdays[0]);//[wd-1]);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,381
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+21
	CALL SUBOPT_0x1C
	LDD  R26,Y+25
	CALL SUBOPT_0x1D
	LDD  R26,Y+28
	CALL SUBOPT_0x1C
	LDD  R26,Y+32
	CALL SUBOPT_0x1D
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	CALL SUBOPT_0x12
	LDI  R24,20
	CALL _sprintf
	ADIW R28,24
; 0000 02BA     lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL SUBOPT_0x2
; 0000 02BB     lcd_puts(lcd_buffer);
	CALL SUBOPT_0xF
	CALL _lcd_puts
; 0000 02BC     //print date
; 0000 02BD     /*sprintf(lcd_buffer, "%u%u %s 20%u%u", date/10,date%10, monthes[month-1], year/10,year%10);
; 0000 02BE     lcd_goto_xy(2,6);
; 0000 02BF     lcd_str(lcd_buffer);   */
; 0000 02C0     if (get_key_status(MENU_ENTER_BTN)) //enter
	CALL SUBOPT_0x7
	BREQ _0xD1
; 0000 02C1     {
; 0000 02C2       if (!get_prev_key_status(MENU_ENTER_BTN))
	CALL SUBOPT_0x8
	BRNE _0xD2
; 0000 02C3       {
; 0000 02C4 		lcd_clear();
	CALL _lcd_clear
; 0000 02C5         main_menu();
	RCALL _main_menu
; 0000 02C6     	lcd_clear();
	CALL _lcd_clear
; 0000 02C7       }
; 0000 02C8     }
_0xD2:
; 0000 02C9     //delay_ms(200);
; 0000 02CA     //----------wait approx. 0.8s to avoid heating up SHTxx------------------------------
; 0000 02CB     //for (i=0;i<40000;i++);     //(be sure that the compiler doesn't eliminate this line!)
; 0000 02CC     //-----------------------------------------------------------------------------------
; 0000 02CD   }
_0xD1:
	RJMP _0xC6
; 0000 02CE }
_0xD3:
	RJMP _0xD3

	.DSEG
_0xC4:
	.BYTE 0x1C
;
;#pragma rl-
;
;/*void main(void)
;{
;// Declare your local variables here
;
;// Input/Output Ports initialization
;// Port A initialization
;// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;PORTA=0x00;
;DDRA=0x00;
;
;// Port B initialization
;// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;PORTB=0x00;
;DDRB=0x00;
;
;// Port C initialization
;// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;PORTC=0x00;
;DDRC=0x00;
;
;// Port D initialization
;// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;PORTD=0x00;
;DDRD=0x00;
;
;// Timer/Counter 0 initialization
;// Clock source: System Clock
;// Clock value: Timer 0 Stopped
;// Mode: Normal top=FFh
;// OC0 output: Disconnected
;TCCR0=0x00;
;TCNT0=0x00;
;OCR0=0x00;
;
;// Timer/Counter 1 initialization
;// Clock source: System Clock
;// Clock value: Timer1 Stopped
;// Mode: Normal top=FFFFh
;// OC1A output: Discon.
;// OC1B output: Discon.
;// Noise Canceler: Off
;// Input Capture on Falling Edge
;// Timer1 Overflow Interrupt: Off
;// Input Capture Interrupt: Off
;// Compare A Match Interrupt: Off
;// Compare B Match Interrupt: Off
;TCCR1A=0x00;
;TCCR1B=0x00;
;TCNT1H=0x00;
;TCNT1L=0x00;
;ICR1H=0x00;
;ICR1L=0x00;
;OCR1AH=0x00;
;OCR1AL=0x00;
;OCR1BH=0x00;
;OCR1BL=0x00;
;
;// Timer/Counter 2 initialization
;// Clock source: System Clock
;// Clock value: Timer2 Stopped
;// Mode: Normal top=FFh
;// OC2 output: Disconnected
;ASSR=0x00;
;TCCR2=0x00;
;TCNT2=0x00;
;OCR2=0x00;
;
;// External Interrupt(s) initialization
;// INT0: Off
;// INT1: Off
;// INT2: Off
;MCUCR=0x00;
;MCUCSR=0x00;
;
;// Timer(s)/Counter(s) Interrupt(s) initialization
;TIMSK=0x00;
;
;// Analog Comparator initialization
;// Analog Comparator: Off
;// Analog Comparator Input Capture by Timer/Counter 1: Off
;ACSR=0x80;
;SFIOR=0x00;
;
;while (1)
;      {
;      // Place your code here
;
;      };
;} */
;#include "therm_ds18b20.h"
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
;
;struct __ds18b20_scratch_pad_struct __ds18b20_scratch_pad;
;//uint8_t therm_dq;
;
;/*void therm_input_mode(void)
;{
;	THERM_DDR&=~(1<<THERM_DQ);
;}
;void therm_output_mode(void)
;{
;	THERM_DDR|=(1<<THERM_DQ);
;}
;void therm_low(void)
;{
;	THERM_PORT&=~(1<<THERM_DQ);
;}     */
;/*void therm_high(void)
;{
;	THERM_PORT|=(1<<THERM_DQ);
;}
;void therm_delay(uint16_t delay)
;{
;	while (delay--) #asm("nop");
;}*/
;
;uint8_t therm_reset()
; 0001 001C {

	.CSEG
_therm_reset:
; 0001 001D 	uint8_t i;
; 0001 001E 	//посилаємо імпульс скидання тривалістю 480 мкс
; 0001 001F 	THERM_LOW();
	ST   -Y,R17
;	i -> R17
	CBI  0x15,4
; 0001 0020 	THERM_OUTPUT_MODE();
	SBI  0x14,4
; 0001 0021 	//therm_delay(us(480));
; 0001 0022 	delay_us(480);
	__DELAY_USW 960
; 0001 0023 	//повертаємо шину і чекаємо 60 мкс на відповідь
; 0001 0024 	THERM_INPUT_MODE();
	CBI  0x14,4
; 0001 0025 	//therm_delay(us(60));
; 0001 0026 	delay_us(60);
	__DELAY_USB 160
; 0001 0027 	//зберігаємо значення на шині і чекаємо завершення 480 мкс періода
; 0001 0028 	i=(THERM_PIN & (1<<THERM_DQ));
	IN   R30,0x13
	ANDI R30,LOW(0x10)
	MOV  R17,R30
; 0001 0029 	//therm_delay(us(420));
; 0001 002A 	delay_us(420);
	__DELAY_USW 840
; 0001 002B 	if ((THERM_PIN & (1<<THERM_DQ))==i) return 1;
	IN   R30,0x13
	ANDI R30,LOW(0x10)
	CP   R17,R30
	BRNE _0x20003
	LDI  R30,LOW(1)
	RJMP _0x2100010
; 0001 002C 	//повертаємо результат виконання (presence pulse) (0=OK, 1=WRONG)
; 0001 002D 	return 0;
_0x20003:
	LDI  R30,LOW(0)
	RJMP _0x2100010
; 0001 002E }
;
;void therm_write_bit(uint8_t _bit)
; 0001 0031 {
_therm_write_bit:
; 0001 0032 	//переводимо шину в стан лог. 0 на 1 мкс
; 0001 0033 	THERM_LOW();
;	_bit -> Y+0
	CBI  0x15,4
; 0001 0034 	THERM_OUTPUT_MODE();
	SBI  0x14,4
; 0001 0035 	//therm_delay(us(1));
; 0001 0036 	delay_us(1);
	__DELAY_USB 3
; 0001 0037 	//якщо пишемо 1, відпускаємо шину (якщо 0 тримаємо в стані лог. 0)
; 0001 0038 	if (_bit) THERM_INPUT_MODE();
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20004
	CBI  0x14,4
; 0001 0039 	//чекаємо 60мкм і відпускаємо шину
; 0001 003A 	//therm_delay(us(60));
; 0001 003B 	delay_us(60);
_0x20004:
	__DELAY_USB 160
; 0001 003C 	THERM_INPUT_MODE();
	CBI  0x14,4
; 0001 003D }
	ADIW R28,1
	RET
;
;uint8_t therm_read_bit(void)
; 0001 0040 {
_therm_read_bit:
; 0001 0041 	uint8_t _bit=0;
; 0001 0042 	//переводимо шину в лог. 0 на 1 мкс
; 0001 0043 	THERM_LOW();
	ST   -Y,R17
;	_bit -> R17
	LDI  R17,0
	CBI  0x15,4
; 0001 0044 	THERM_OUTPUT_MODE();
	SBI  0x14,4
; 0001 0045 	//therm_delay(us(1));
; 0001 0046 	delay_us(1);
	__DELAY_USB 3
; 0001 0047 	//відпускаємо шину і чекаємо 14 мкс
; 0001 0048 	THERM_INPUT_MODE();
	CBI  0x14,4
; 0001 0049 	//therm_delay(us(14));
; 0001 004A 	delay_us(14);
	__DELAY_USB 37
; 0001 004B 	//читаємо біт з шини
; 0001 004C 	if (THERM_PIN&(1<<THERM_DQ)) _bit=1;
	SBIC 0x13,4
	LDI  R17,LOW(1)
; 0001 004D 	//чекаємо 45 мкс до закінчення і вертаємо прочитане значення
; 0001 004E 	//therm_delay(us(45));
; 0001 004F 	delay_us(45);
	__DELAY_USB 120
; 0001 0050 	return _bit;
	MOV  R30,R17
	RJMP _0x2100010
; 0001 0051 }
;
;uint8_t therm_read_byte(void)
; 0001 0054 {
_therm_read_byte:
; 0001 0055 	uint8_t i=8, n=0;
; 0001 0056 	while (i--)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	n -> R16
	LDI  R17,8
	LDI  R16,0
_0x20006:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20008
; 0001 0057 	{
; 0001 0058 		//зсуваємо на 1 розряд вправо і зберігаємо прочитане значення
; 0001 0059 		n>>=1;
	CALL SUBOPT_0x1B
	ASR  R31
	ROR  R30
	MOV  R16,R30
; 0001 005A 		n|=(therm_read_bit()<<7);
	RCALL _therm_read_bit
	ROR  R30
	LDI  R30,0
	ROR  R30
	OR   R16,R30
; 0001 005B 	}
	RJMP _0x20006
_0x20008:
; 0001 005C 	return n;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 005D }
;
;void therm_write_byte(uint8_t byte)
; 0001 0060 {
_therm_write_byte:
; 0001 0061 	uint8_t i=8;
; 0001 0062 	while (i--)
	ST   -Y,R17
;	byte -> Y+1
;	i -> R17
	LDI  R17,8
_0x20009:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000B
; 0001 0063 	{
; 0001 0064 		//пишемо молодший біт і зсуваємо на 1 розряд вправо для виводу наступного біта
; 0001 0065 		therm_write_bit(byte&1);
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	ST   -Y,R30
	RCALL _therm_write_bit
; 0001 0066 		byte>>=1;
	LDD  R30,Y+1
	CALL SUBOPT_0x25
	STD  Y+1,R30
; 0001 0067 	}
	RJMP _0x20009
_0x2000B:
; 0001 0068 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;uint8_t therm_crc8(uint8_t *data, uint8_t num_bytes)
; 0001 006B {
_therm_crc8:
; 0001 006C 	uint8_t byte_ctr, cur_byte, bit_ctr, crc=0;
; 0001 006D 
; 0001 006E 	for (byte_ctr=0; byte_ctr<num_bytes; byte_ctr++)
	CALL __SAVELOCR4
;	*data -> Y+5
;	num_bytes -> Y+4
;	byte_ctr -> R17
;	cur_byte -> R16
;	bit_ctr -> R19
;	crc -> R18
	LDI  R18,0
	LDI  R17,LOW(0)
_0x2000D:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x2000E
; 0001 006F 	{
; 0001 0070 		cur_byte=data[byte_ctr];
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
; 0001 0071 		for (bit_ctr=0; bit_ctr<8; cur_byte>>=1, bit_ctr++)
	LDI  R19,LOW(0)
_0x20010:
	CPI  R19,8
	BRSH _0x20011
; 0001 0072 			if ((cur_byte ^ crc) & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
	MOV  R30,R18
	EOR  R30,R16
	ANDI R30,LOW(0x1)
	BREQ _0x20012
	LDI  R30,LOW(24)
	EOR  R30,R18
	CALL SUBOPT_0x25
	ORI  R30,0x80
	RJMP _0x20021
; 0001 0073 			else crc>>=1;
_0x20012:
	MOV  R30,R18
	CALL SUBOPT_0x25
_0x20021:
	MOV  R18,R30
; 0001 0074 	}
	CALL SUBOPT_0x1B
	ASR  R31
	ROR  R30
	MOV  R16,R30
	SUBI R19,-1
	RJMP _0x20010
_0x20011:
	SUBI R17,-1
	RJMP _0x2000D
_0x2000E:
; 0001 0075 	return crc;
	MOV  R30,R18
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; 0001 0076 }
;
;uint8_t therm_init(int8_t temp_low, int8_t temp_high, uint8_t resolution)
; 0001 0079 {
_therm_init:
; 0001 007A 	resolution=(resolution<<5)|0x1f;
;	temp_low -> Y+2
;	temp_high -> Y+1
;	resolution -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
; 0001 007B 	//ініціалізуємо давач
; 0001 007C 	if (therm_reset()) return 1;
	RCALL _therm_reset
	CPI  R30,0
	BREQ _0x20014
	LDI  R30,LOW(1)
	RJMP _0x210000F
; 0001 007D 	therm_write_byte(THERM_CMD_SKIPROM);
_0x20014:
	CALL SUBOPT_0x26
; 0001 007E 	therm_write_byte(THERM_CMD_WSCRATCHPAD);
	LDI  R30,LOW(78)
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 007F 	therm_write_byte(temp_high);
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 0080 	therm_write_byte(temp_low);
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 0081 	therm_write_byte(resolution);
	LD   R30,Y
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 0082 	therm_reset();
	RCALL _therm_reset
; 0001 0083 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x26
; 0001 0084 	therm_write_byte(THERM_CMD_CPYSCRATCHPAD);
	LDI  R30,LOW(72)
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 0085 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0001 0086 	return 0;
	LDI  R30,LOW(0)
	RJMP _0x210000F
; 0001 0087 }
;
;uint8_t therm_read_spd(void)
; 0001 008A {
_therm_read_spd:
; 0001 008B 	uint8_t i=0, *p;
; 0001 008C 
; 0001 008D 	p = (uint8_t*) &__ds18b20_scratch_pad;
	CALL __SAVELOCR4
;	i -> R17
;	*p -> R18,R19
	LDI  R17,0
	__POINTWRM 18,19,___ds18b20_scratch_pad
; 0001 008E 	do
_0x20016:
; 0001 008F 		*(p++)=therm_read_byte();
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _therm_read_byte
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0090 	while(++i<9);
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x20016
; 0001 0091 	if (therm_crc8((uint8_t*)&__ds18b20_scratch_pad,8)!=__ds18b20_scratch_pad.crc)
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _therm_crc8
	MOV  R26,R30
	__GETB1MN ___ds18b20_scratch_pad,8
	CP   R30,R26
	BREQ _0x20018
; 0001 0092 		return 1;
	LDI  R30,LOW(1)
	RJMP _0x2100011
; 0001 0093 	return 0;
_0x20018:
	LDI  R30,LOW(0)
_0x2100011:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0001 0094 }
;
;uint8_t therm_read_temperature(float *temp)
; 0001 0097 {
_therm_read_temperature:
; 0001 0098 	uint8_t digit, decimal, resolution, sign;
; 0001 0099 	uint16_t meas, bit_mask[4]={0x0008, 0x000c, 0x000e, 0x000f};
; 0001 009A 
; 0001 009B 	//скинути, пропустити процедуру перевірки серійного номера ROM і почати вимірювання і перетворення температури
; 0001 009C 	if (therm_reset()) return 1;
	SBIW R28,8
	LDI  R30,LOW(8)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	LDI  R30,LOW(12)
	STD  Y+2,R30
	LDI  R30,LOW(0)
	STD  Y+3,R30
	LDI  R30,LOW(14)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
	LDI  R30,LOW(15)
	STD  Y+6,R30
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CALL __SAVELOCR6
;	*temp -> Y+14
;	digit -> R17
;	decimal -> R16
;	resolution -> R19
;	sign -> R18
;	meas -> R20,R21
;	bit_mask -> Y+6
	RCALL _therm_reset
	CPI  R30,0
	BREQ _0x20019
	LDI  R30,LOW(1)
	CALL __LOADLOCR6
	JMP  _0x210000D
; 0001 009D 	therm_write_byte(THERM_CMD_SKIPROM);
_0x20019:
	CALL SUBOPT_0x26
; 0001 009E 	therm_write_byte(THERM_CMD_CONVERTTEMP);
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 009F 	//чекаємо до закінчення перетворення
; 0001 00A0 	//if (!therm_read_bit()) return 1;
; 0001 00A1 	while(!therm_read_bit());
_0x2001A:
	RCALL _therm_read_bit
	CPI  R30,0
	BREQ _0x2001A
; 0001 00A2 	//скидаємо, пропускаємо ROM і посилаємо команду зчитування Scratchpad
; 0001 00A3 	therm_reset();
	RCALL _therm_reset
; 0001 00A4 	therm_write_byte(THERM_CMD_SKIPROM);
	CALL SUBOPT_0x26
; 0001 00A5 	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _therm_write_byte
; 0001 00A6 	if (therm_read_spd()) return 1;
	RCALL _therm_read_spd
	CPI  R30,0
	BREQ _0x2001D
	LDI  R30,LOW(1)
	CALL __LOADLOCR6
	JMP  _0x210000D
; 0001 00A7 	therm_reset();
_0x2001D:
	RCALL _therm_reset
; 0001 00A8 	resolution=(__ds18b20_scratch_pad.conf_register>>5) & 3;
	__GETB2MN ___ds18b20_scratch_pad,4
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x3)
	MOV  R19,R30
; 0001 00A9     //отримуємо молодший і старший байти температури
; 0001 00AA 	meas=__ds18b20_scratch_pad.temp_lsb;  // LSB
	LDS  R20,___ds18b20_scratch_pad
	CLR  R21
; 0001 00AB 	meas|=((uint16_t)__ds18b20_scratch_pad.temp_msb) << 8; // MSB
	__GETB1HMN ___ds18b20_scratch_pad,1
	LDI  R30,LOW(0)
	__ORWRR 20,21,30,31
; 0001 00AC 	//перевіряємо на мінусову температуру
; 0001 00AD 	if (meas & 0x8000)
	SBRS R21,7
	RJMP _0x2001E
; 0001 00AE 	{
; 0001 00AF 		sign=1;  //відмічаємо мінусову температуру
	LDI  R18,LOW(1)
; 0001 00B0 		meas^=0xffff;  //перетворюємо в плюсову
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__EORWRR 20,21,30,31
; 0001 00B1 		meas++;
	__ADDWRN 20,21,1
; 0001 00B2 	}
; 0001 00B3 	else sign=0;
	RJMP _0x2001F
_0x2001E:
	LDI  R18,LOW(0)
; 0001 00B4 	//зберігаємо цілу і дробову частини температури
; 0001 00B5 	digit=(uint8_t)(meas >> 4); //зберігаємо цілу частину
_0x2001F:
	MOVW R30,R20
	CALL __LSRW4
	MOV  R17,R30
; 0001 00B6 	decimal=(uint8_t)(meas & bit_mask[resolution]);	//отримуємо дробову частину
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	AND  R30,R20
	MOV  R16,R30
; 0001 00B7 	*temp=digit+decimal*0.0625;
	CALL SUBOPT_0x16
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	__GETD2N 0x3D800000
	CALL __MULF12
	POP  R26
	POP  R27
	CALL __CWD2
	CALL __CDF2
	CALL __ADDF12
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __PUTDP1
; 0001 00B8 	if (sign) *temp=-(*temp); //ставемо знак мінус, якщо мінусова температура
	CPI  R18,0
	BREQ _0x20020
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETD1P
	CALL __ANEGF1
	CALL __PUTDP1
; 0001 00B9 	return 0;
_0x20020:
	LDI  R30,LOW(0)
	CALL __LOADLOCR6
	JMP  _0x210000D
; 0001 00BA }
;/***********************************************************************************
;Project:          SHTxx library
;Filename:         shtxx.c
;Processor:        AVR family
;Author:           (C) Andriy Holovatyy
;***********************************************************************************/
;
;#include "shtxx.h"
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
;#include <math.h>   //math library
;
;/* константи для обчислення температури і вологості */
;//const float C1=-4.0;              // for 12 Bit
;//const float C2=+0.0405;           // for 12 Bit
;//const float C3=-0.0000028;        // for 12 Bit
;
;/*const float C1=-2.0468;           // for 12 Bit
;const float C2=+0.0367;           // for 12 Bit
;const float C3=-0.0000015955;     // for 12 Bit
;
;const float T1=+0.01;             // for 14 Bit @ 5V
;const float T2=+0.00008;           // for 14 Bit @ 5V
;
;*/
;
;const float C1=-2.0468;           // for 8 Bit

	.DSEG
;const float C2=+0.5872;           // for 8 Bit
;const float C3=-0.00040845;       // for 8 Bit
;
;const float T1=+0.01;             // for 12 Bit @ 5V
;const float T2=+0.00128;          // for 12 Bit @ 5V
;
;void sht_init(void)
; 0002 0021 {

	.CSEG
_sht_init:
; 0002 0022   SHT_PORT=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0002 0023   SHT_DDR=1<<SHT_SCK;
	LDI  R30,LOW(4)
	OUT  0x14,R30
; 0002 0024 }
	RET
;
;//----------------------------------------------------------------------------------
;char s_write_byte(unsigned char _value)
; 0002 0028 //----------------------------------------------------------------------------------
; 0002 0029 // writes a byte on the Sensibus and checks the acknowledge
; 0002 002A {
_s_write_byte:
; 0002 002B   unsigned char i,error=0;
; 0002 002C   SHT_OUTPUT_MODE();
	ST   -Y,R17
	ST   -Y,R16
;	_value -> Y+2
;	i -> R17
;	error -> R16
	LDI  R16,0
	SBI  0x14,3
; 0002 002D   for (i=0x80;i>0;i/=2)             //shift bit for masking
	LDI  R17,LOW(128)
_0x40009:
	CPI  R17,1
	BRLO _0x4000A
; 0002 002E   {
; 0002 002F     if (i & _value) SHT_DATA_HIGH(); //masking value with i , write to SENSI-BUS
	LDD  R30,Y+2
	AND  R30,R17
	BREQ _0x4000B
	SBI  0x15,3
; 0002 0030     else
	RJMP _0x4000C
_0x4000B:
; 0002 0031      SHT_DATA_LOW();
	CBI  0x15,3
; 0002 0032     delay_us(1);
_0x4000C:
	CALL SUBOPT_0x28
; 0002 0033     SHT_SCK_HIGH(); //clk for SENSI-BUS
; 0002 0034     delay_us(5);    //pulswith approx. 5 us
	__DELAY_USB 13
; 0002 0035     SHT_SCK_LOW();
	CBI  0x15,2
; 0002 0036   }
	CALL SUBOPT_0x29
	RJMP _0x40009
_0x4000A:
; 0002 0037   SHT_INPUT_MODE(); //release DATA-line
	CBI  0x14,3
; 0002 0038   delay_us(1);
	CALL SUBOPT_0x28
; 0002 0039   SHT_SCK_HIGH(); //clk #9 for ack
; 0002 003A   delay_us(1);
	__DELAY_USB 3
; 0002 003B   error=(SHT_PIN&(1<<SHT_DATA));                       //check ack (DATA will be pulled down by SHT11)
	IN   R30,0x13
	ANDI R30,LOW(0x8)
	MOV  R16,R30
; 0002 003C   SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 003D   delay_us(1);
; 0002 003E   return error;                     //error=1 in case of no acknowledge
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x210000F
; 0002 003F }
;
;//----------------------------------------------------------------------------------
;char s_read_byte(unsigned char ack)
; 0002 0043 //----------------------------------------------------------------------------------
; 0002 0044 // reads a byte form the Sensibus and gives an acknowledge in case of "ack=1"
; 0002 0045 {
_s_read_byte:
; 0002 0046   unsigned char i,val=0;
; 0002 0047   SHT_INPUT_MODE(); //release DATA-line
	ST   -Y,R17
	ST   -Y,R16
;	ack -> Y+2
;	i -> R17
;	val -> R16
	LDI  R16,0
	CBI  0x14,3
; 0002 0048   for (i=0x80;i>0;i/=2)  //shift bit for masking
	LDI  R17,LOW(128)
_0x4000E:
	CPI  R17,1
	BRLO _0x4000F
; 0002 0049   {
; 0002 004A     SHT_SCK_HIGH();    //clk for SENSI-BUS
	CALL SUBOPT_0x2B
; 0002 004B     delay_us(1);
; 0002 004C     if ((SHT_PIN & (1<<SHT_DATA))) val=(val | i);        //read bit
	SBIC 0x13,3
	OR   R16,R17
; 0002 004D     SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 004E     delay_us(1);
; 0002 004F   }
	CALL SUBOPT_0x29
	RJMP _0x4000E
_0x4000F:
; 0002 0050   if (ack) //in case of "ack==1" pull down DATA-Line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x40011
; 0002 0051   {
; 0002 0052    SHT_OUTPUT_MODE();
	SBI  0x14,3
; 0002 0053    SHT_DATA_LOW();
	CBI  0x15,3
; 0002 0054    delay_us(1);
	__DELAY_USB 3
; 0002 0055   }
; 0002 0056   SHT_SCK_HIGH();        //clk #9 for ack
_0x40011:
	SBI  0x15,2
; 0002 0057   delay_us(5);  //pulswith approx. 5 us
	__DELAY_USB 13
; 0002 0058   SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 0059   delay_us(1);
; 0002 005A   SHT_INPUT_MODE(); //release DATA-line
	CBI  0x14,3
; 0002 005B   return val;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x210000F
; 0002 005C }
;
;//----------------------------------------------------------------------------------
;void s_transstart(void)
; 0002 0060 //----------------------------------------------------------------------------------
; 0002 0061 // generates a transmission start
; 0002 0062 //       _____         ________
; 0002 0063 // DATA:      |_______|
; 0002 0064 //           ___     ___
; 0002 0065 // SCK : ___|   |___|   |______
; 0002 0066 {
_s_transstart:
; 0002 0067   //Initial state
; 0002 0068   SHT_OUTPUT_MODE();
	SBI  0x14,3
; 0002 0069   SHT_DATA_HIGH();
	SBI  0x15,3
; 0002 006A   SHT_SCK_LOW();
	CBI  0x15,2
; 0002 006B   delay_us(1);
	CALL SUBOPT_0x28
; 0002 006C 
; 0002 006D   SHT_SCK_HIGH();
; 0002 006E   delay_us(1);
	__DELAY_USB 3
; 0002 006F 
; 0002 0070   SHT_DATA_LOW();
	CBI  0x15,3
; 0002 0071   delay_us(1);
	__DELAY_USB 3
; 0002 0072 
; 0002 0073   SHT_SCK_LOW();
	CBI  0x15,2
; 0002 0074   delay_us(5);
	__DELAY_USB 13
; 0002 0075 
; 0002 0076   SHT_SCK_HIGH();
	CALL SUBOPT_0x2B
; 0002 0077   delay_us(1);
; 0002 0078 
; 0002 0079   SHT_DATA_HIGH();
	SBI  0x15,3
; 0002 007A   delay_us(1);
	__DELAY_USB 3
; 0002 007B   SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 007C   delay_us(1);
; 0002 007D }
	RET
;
;//----------------------------------------------------------------------------------
;void s_connectionreset(void)
; 0002 0081 //----------------------------------------------------------------------------------
; 0002 0082 // communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
; 0002 0083 //       _____________________________________________________         ________
; 0002 0084 // DATA:                                                      |_______|
; 0002 0085 //          _    _    _    _    _    _    _    _    _        ___     ___
; 0002 0086 // SCK : __| |__| |__| |__| |__| |__| |__| |__| |__| |______|   |___|   |______
; 0002 0087 {
_s_connectionreset:
; 0002 0088   unsigned char i;
; 0002 0089   //Initial state
; 0002 008A   SHT_OUTPUT_MODE();
	ST   -Y,R17
;	i -> R17
	SBI  0x14,3
; 0002 008B   SHT_DATA_HIGH();
	SBI  0x15,3
; 0002 008C   SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 008D   delay_us(1);
; 0002 008E   for(i=0;i<9;i++)                  //9 SCK cycles
	LDI  R17,LOW(0)
_0x40013:
	CPI  R17,9
	BRSH _0x40014
; 0002 008F   {
; 0002 0090     SHT_SCK_HIGH();
	CALL SUBOPT_0x2B
; 0002 0091     delay_us(1);
; 0002 0092     SHT_SCK_LOW();
	CALL SUBOPT_0x2A
; 0002 0093     delay_us(1);
; 0002 0094   }
	SUBI R17,-1
	RJMP _0x40013
_0x40014:
; 0002 0095   s_transstart();                   //transmission start
	RCALL _s_transstart
; 0002 0096 }
_0x2100010:
	LD   R17,Y+
	RET
;
;//----------------------------------------------------------------------------------
;char s_softreset(void)
; 0002 009A //----------------------------------------------------------------------------------
; 0002 009B // resets the sensor by a softreset
; 0002 009C {
; 0002 009D   unsigned char error=0;
; 0002 009E   s_connectionreset();              //reset communication
;	error -> R17
; 0002 009F   error+=s_write_byte(RESET);       //send RESET-command to sensor
; 0002 00A0   return error;                     //error=1 in case of no response form the sensor
; 0002 00A1 }
;
;//----------------------------------------------------------------------------------
;char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum)
; 0002 00A5 //----------------------------------------------------------------------------------
; 0002 00A6 // reads the status register with checksum (8-bit)
; 0002 00A7 {
_s_read_statusreg:
; 0002 00A8   unsigned char error=0;
; 0002 00A9   s_transstart();                   //transmission start
	ST   -Y,R17
;	*p_value -> Y+3
;	*p_checksum -> Y+1
;	error -> R17
	LDI  R17,0
	RCALL _s_transstart
; 0002 00AA   error=s_write_byte(STATUS_REG_R); //send command to sensor
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _s_write_byte
	MOV  R17,R30
; 0002 00AB   *p_value=s_read_byte(ACK);        //read status register (8-bit)
	CALL SUBOPT_0x2C
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ST   X,R30
; 0002 00AC   *p_checksum=s_read_byte(noACK);   //read checksum (8-bit)
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _s_read_byte
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
; 0002 00AD   return error;                     //error=1 in case of no response form the sensor
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x210000E
; 0002 00AE }
;
;//----------------------------------------------------------------------------------
;char s_write_statusreg(unsigned char *p_value)
; 0002 00B2 //----------------------------------------------------------------------------------
; 0002 00B3 // writes the status register with checksum (8-bit)
; 0002 00B4 {
_s_write_statusreg:
; 0002 00B5   unsigned char error=0;
; 0002 00B6   s_transstart();                   //transmission start
	ST   -Y,R17
;	*p_value -> Y+1
;	error -> R17
	LDI  R17,0
	RCALL _s_transstart
; 0002 00B7   error+=s_write_byte(STATUS_REG_W);//send command to sensor
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _s_write_byte
	ADD  R17,R30
; 0002 00B8   error+=s_write_byte(*p_value);    //send value of status register
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	ST   -Y,R30
	RCALL _s_write_byte
	ADD  R17,R30
; 0002 00B9   return error;                     //error>=1 in case of no response form the sensor
	MOV  R30,R17
	LDD  R17,Y+0
_0x210000F:
	ADIW R28,3
	RET
; 0002 00BA }
;
;//----------------------------------------------------------------------------------
;char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
; 0002 00BE //----------------------------------------------------------------------------------
; 0002 00BF // makes a measurement (humidity/temperature) with checksum
; 0002 00C0 {
_s_measure:
; 0002 00C1   unsigned error=0;
; 0002 00C2   unsigned int i;
; 0002 00C3 
; 0002 00C4   s_transstart();                   //transmission start
	CALL __SAVELOCR4
;	*p_value -> Y+7
;	*p_checksum -> Y+5
;	mode -> Y+4
;	error -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,0
	RCALL _s_transstart
; 0002 00C5   switch(mode){                     //send command to sensor
	LDD  R30,Y+4
	CALL SUBOPT_0xE
; 0002 00C6     case TEMP	: error+=s_write_byte(MEASURE_TEMP); break;
	BRNE _0x40018
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2D
	RJMP _0x40017
; 0002 00C7     case HUMI	: error+=s_write_byte(MEASURE_HUMI); break;
_0x40018:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4001A
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2D
; 0002 00C8     default     : break;
_0x4001A:
; 0002 00C9   }
_0x40017:
; 0002 00CA   SHT_INPUT_MODE();
	CBI  0x14,3
; 0002 00CB   for (i=0;i<65535;i++)
	__GETWRN 18,19,0
_0x4001C:
	__CPWRN 18,19,-1
	BRSH _0x4001D
; 0002 00CC   {
; 0002 00CD    delay_us(1);
	__DELAY_USB 3
; 0002 00CE    if((SHT_PIN & (1<<SHT_DATA))==0) break; //wait until sensor has finished the measurement
	SBIS 0x13,3
	RJMP _0x4001D
; 0002 00CF   }
	__ADDWRN 18,19,1
	RJMP _0x4001C
_0x4001D:
; 0002 00D0   if(SHT_PIN & (1<<SHT_DATA)) error+=1;                // or timeout (~2 sec.) is reached
	SBIS 0x13,3
	RJMP _0x4001F
	__ADDWRN 16,17,1
; 0002 00D1   *(p_value+1)=s_read_byte(ACK);    //read the first byte (MSB)
_0x4001F:
	CALL SUBOPT_0x2C
	__PUTB1SNS 7,1
; 0002 00D2   *(p_value)=s_read_byte(ACK);    //read the second byte (LSB)
	CALL SUBOPT_0x2C
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ST   X,R30
; 0002 00D3   *p_checksum =s_read_byte(noACK);  //read checksum
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _s_read_byte
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X,R30
; 0002 00D4   return error;
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,9
	RET
; 0002 00D5 }
;
;//----------------------------------------------------------------------------------------
;void calc_sth11(float *p_humidity ,float *p_temperature)
; 0002 00D9 //----------------------------------------------------------------------------------------
; 0002 00DA // calculates temperature [°C] and humidity [%RH]
; 0002 00DB // input :  humi [Ticks] (12 bit)
; 0002 00DC //          temp [Ticks] (14 bit)
; 0002 00DD // output:  humi [%RH]
; 0002 00DE //          temp [°C]
; 0002 00DF {
_calc_sth11:
; 0002 00E0   float rh=*p_humidity;             // rh:      Humidity [Ticks] 12 Bit
; 0002 00E1   float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
; 0002 00E2   float rh_lin;                     // rh_lin:  Humidity linear
; 0002 00E3   float rh_true;                    // rh_true: Temperature compensated humidity
; 0002 00E4   float t_C;                        // t_C   :  Temperature [°C]
; 0002 00E5 
; 0002 00E6   t_C=t*0.04 - 39.8;                  //calc. temperature from ticks to [°C]  first coeff. 0.01 for 14 bit and 0.04 for 12 bit
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
	CALL SUBOPT_0x2E
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __GETD1P
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	__GETD1N 0x3D23D70A
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x421F3333
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
; 0002 00E7   rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
	CALL SUBOPT_0x33
	__GETD2N 0xB9D6253B
	CALL __MULF12
	CALL SUBOPT_0x34
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	__GETD2N 0x3F1652BD
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__GETD2N 0xC002FEC5
	CALL __ADDF12
	__PUTD1S 8
; 0002 00E8   rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
	CALL SUBOPT_0x35
	__GETD2N 0x41C80000
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	__GETD2N 0x3AA7C5AC
	CALL __MULF12
	__GETD2N 0x3C23D70A
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	__GETD2S 8
	CALL SUBOPT_0x36
; 0002 00E9   if(rh_true>100)rh_true=100;       //cut if the value is outside of
	CALL SUBOPT_0x37
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x40020
	CALL SUBOPT_0x38
; 0002 00EA   if(rh_true<0.1)rh_true=0.1;       //the physical possible range
_0x40020:
	CALL SUBOPT_0x39
	CALL __CMPF12
	BRSH _0x40021
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x38
; 0002 00EB 
; 0002 00EC   *p_temperature=t_C;               //return temperature [°C]
_0x40021:
	CALL SUBOPT_0x35
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __PUTDP1
; 0002 00ED   *p_humidity=rh_true;              //return humidity[%RH]
	CALL SUBOPT_0x3B
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __PUTDP1
; 0002 00EE }
	ADIW R28,24
	RET
;
;//--------------------------------------------------------------------
;float calc_dewpoint(float h,float t)
; 0002 00F2 //--------------------------------------------------------------------
; 0002 00F3 // calculates dew point
; 0002 00F4 // input:   humidity [%RH], temperature [°C]
; 0002 00F5 // output:  dew point [°C]
; 0002 00F6 { float logEx,dew_point;
_calc_dewpoint:
; 0002 00F7   logEx=0.66077+7.5*t/(237.3+t)+(log10(h)-2);
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
	CALL SUBOPT_0x3C
	CALL __PUTPARD1
	CALL _log10
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x36
; 0002 00F8   dew_point = (logEx - 0.66077)*237.3/(0.66077+7.5-logEx);
	CALL SUBOPT_0x3B
	__GETD2N 0x3F292839
	CALL __SUBF12
	__GETD2N 0x436D4CCD
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	__GETD1N 0x41029284
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x32
; 0002 00F9   return dew_point;
	CALL SUBOPT_0x35
	RJMP _0x210000D
; 0002 00FA }
;
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

	.CSEG
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x3D
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x210000E:
	ADIW R28,5
	RET
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0x3E
	RJMP _0x210000C
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0x3E
	RJMP _0x210000C
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x3F
	RJMP _0x200001C
_0x200001E:
	CALL SUBOPT_0x3C
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x3F
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x40
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x3F
_0x2000022:
	CALL SUBOPT_0x40
	BRLO _0x2000024
	CALL SUBOPT_0x41
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x40
	BRSH _0x2000028
	CALL SUBOPT_0x30
	CALL SUBOPT_0x42
	CALL SUBOPT_0x2F
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x3F
_0x2000025:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x43
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x40
	BRLO _0x2000029
	CALL SUBOPT_0x41
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	CALL SUBOPT_0x39
	CALL __MULF12
	CALL SUBOPT_0x43
	CALL __PUTPARD1
	CALL _floor
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x30
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x44
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x37
	CALL __MULF12
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x44
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x45
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	CALL SUBOPT_0x44
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x200002E:
	CPI  R19,10
	BRLT _0x200002F
	CALL SUBOPT_0x45
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x200002F:
	CALL SUBOPT_0x45
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
_0x210000C:
	CALL __LOADLOCR4
_0x210000D:
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x3D
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x46
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x46
	RJMP _0x200010E
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x49
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x4A
	CALL __GETD1P
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	CALL SUBOPT_0x4D
	CALL __ANEGF1
	CALL SUBOPT_0x4B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x49
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	CALL SUBOPT_0x4D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	CALL SUBOPT_0x4D
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x4E
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x4E
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4F
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x2E
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	CALL SUBOPT_0x2E
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x2E
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x2E
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200010F
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4F
	CALL __CWD1
	RJMP _0x200010F
_0x200007F:
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4F
	CLR  R22
	CLR  R23
_0x200010F:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	CALL SUBOPT_0x4D
	CALL __ANEGD1
	CALL SUBOPT_0x4B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	CALL SUBOPT_0x46
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	CALL SUBOPT_0x50
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	CALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	CALL SUBOPT_0x51
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	CALL SUBOPT_0x34
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000110
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000110:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	CALL SUBOPT_0x50
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	CALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x51
	CALL __MODD21U
	CALL SUBOPT_0x4B
	LDD  R30,Y+20
	CALL SUBOPT_0x34
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x49
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010E:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x52
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x210000B
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x52
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x210000B:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,0
	CALL SUBOPT_0x3E
	RJMP _0x210000A
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,1
	CALL SUBOPT_0x3E
	RJMP _0x210000A
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0x55
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x56
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x57
	CALL __ADDF12
	CALL SUBOPT_0x53
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x58
_0x2020014:
	CALL SUBOPT_0x57
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0x55
	CALL SUBOPT_0x42
	CALL SUBOPT_0x58
	SUBI R17,-LOW(1)
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020017
	CALL SUBOPT_0x54
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020018
_0x2020017:
_0x2020019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001B
	CALL SUBOPT_0x55
	CALL SUBOPT_0x3A
	CALL __MULF12
	CALL SUBOPT_0x43
	CALL __PUTPARD1
	CALL _floor
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x54
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x55
	CALL SUBOPT_0x27
	CALL __MULF12
	CALL SUBOPT_0x59
	CALL SUBOPT_0x31
	CALL SUBOPT_0x53
	RJMP _0x2020019
_0x202001B:
_0x2020018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100009
	CALL SUBOPT_0x54
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x202001F
	CALL SUBOPT_0x59
	CALL SUBOPT_0x42
	CALL SUBOPT_0x53
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x54
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x59
	CALL SUBOPT_0x27
	CALL SUBOPT_0x31
	CALL SUBOPT_0x53
	RJMP _0x202001D
_0x202001F:
_0x2100009:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x210000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G102:
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
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G102:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G102
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2100007
__lcd_read_nibble_G102:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
    andi  r30,0xf0
	RET
_lcd_read_byte0_G102:
	CALL __lcd_delay_G102
	RCALL __lcd_read_nibble_G102
    mov   r26,r30
	RCALL __lcd_read_nibble_G102
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R7,Y+0
	RJMP _0x2100008
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
	CP   R4,R6
	BRLO _0x2040006
	__lcd_putchar1:
	INC  R7
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R7
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2040006:
	INC  R4
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2100007
_lcd_char:
	ST   -Y,R17
	LDI  R17,0
	LDD  R26,Y+1
	CPI  R26,LOW(0x14)
	BRLO _0x2040008
	CPI  R26,LOW(0x7B)
	BRLO _0x2040009
_0x2040008:
	RJMP _0x2040007
_0x2040009:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _lcd_putchar
_0x2040007:
	LDD  R26,Y+1
	CPI  R26,LOW(0xC0)
	BRLO _0x204000B
	CPI  R26,LOW(0xE0)
	BRLO _0x204000D
_0x204000B:
	LDD  R26,Y+1
	CPI  R26,LOW(0xE0)
	BRLO _0x204000E
	LDI  R30,LOW(255)
	CP   R30,R26
	BRSH _0x204000D
_0x204000E:
	RJMP _0x204000A
_0x204000D:
_0x2040011:
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_code_rus)
	SBCI R31,HIGH(-_code_rus)
	LD   R26,Z
	LDD  R30,Y+1
	CP   R30,R26
	BREQ _0x2040013
	SUBI R17,-1
	RJMP _0x2040011
_0x2040013:
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_code_byte_lcd)
	SBCI R31,HIGH(-_code_byte_lcd)
	LD   R30,Z
	ST   -Y,R30
	RCALL _lcd_putchar
_0x204000A:
	LDD  R17,Y+0
_0x2100008:
	ADIW R28,2
	RET
_lcd_puts:
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	ST   -Y,R17
	RCALL _lcd_char
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
	JMP  _0x2100005
_lcd_putsf:
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	ST   -Y,R17
	RCALL _lcd_char
	RJMP _0x2040017
_0x2040019:
	LDD  R17,Y+0
	JMP  _0x2100005
__long_delay_G102:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G102:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2100007
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5A
	RCALL __long_delay_G102
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	LDI  R30,LOW(40)
	CALL SUBOPT_0x5B
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5B
	LDI  R30,LOW(133)
	CALL SUBOPT_0x5B
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G102
	CPI  R30,LOW(0x5)
	BREQ _0x204001A
	LDI  R30,LOW(0)
	RJMP _0x2100007
_0x204001A:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2100007:
	ADIW R28,1
	RET

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2060003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2060003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2060004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2060004:
	CALL SUBOPT_0x5C
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5D
	RJMP _0x2100004
_rtc_get_time:
	CALL SUBOPT_0x5C
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5E
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x5F
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x2100006
_rtc_set_time:
	CALL SUBOPT_0x5C
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_write
	LD   R30,Y
	CALL SUBOPT_0x60
	CALL SUBOPT_0x5D
	RJMP _0x2100003
_rtc_get_date:
	CALL SUBOPT_0x5C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x5F
	LD   R26,Y
	LDD  R27,Y+1
_0x2100006:
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
_rtc_set_date:
	CALL SUBOPT_0x5C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x60
	ST   -Y,R30
	CALL _i2c_write
	LD   R30,Y
_0x2100003:
	ST   -Y,R30
	CALL _bin2bcd
_0x2100004:
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_stop
_0x2100005:
	ADIW R28,3
	RET

	.CSEG
_ftrunc:
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
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	CALL _ftrunc
	CALL SUBOPT_0x32
    brne __floor1
__floor0:
	CALL SUBOPT_0x35
	RJMP _0x2100001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x35
	CALL SUBOPT_0x61
	RJMP _0x2100001
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x62
	CALL __CPD02
	BRLT _0x208000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2100002
_0x208000C:
	CALL SUBOPT_0x63
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
	CALL SUBOPT_0x64
	CALL SUBOPT_0x62
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x208000D
	CALL SUBOPT_0x63
	CALL SUBOPT_0x62
	CALL __ADDF12
	CALL SUBOPT_0x64
	__SUBWRN 16,17,1
_0x208000D:
	CALL SUBOPT_0x63
	CALL SUBOPT_0x61
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x63
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x64
	CALL SUBOPT_0x63
	CALL SUBOPT_0x62
	CALL SUBOPT_0x56
	__GETD1S 2
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x31
	CALL SUBOPT_0x62
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 2
	__GETD2N 0x3FD4114D
	CALL __SUBF12
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
	CALL SUBOPT_0x27
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x2100002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_log10:
	CALL __GETD2S0
	CALL __CPD02
	BRLT _0x208000E
	__GETD1N 0xFF7FFFFF
	RJMP _0x2100001
_0x208000E:
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	RCALL _log
	__GETD2N 0x3EDE5BD9
	CALL __MULF12
_0x2100001:
	ADIW R28,4
	RET

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
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

	.DSEG
_temp:
	.BYTE 0x4
_hum:
	.BYTE 0x4
_soil:
	.BYTE 0x4
_light:
	.BYTE 0x4
_w_time:
	.BYTE 0x18
_lcd_buffer:
	.BYTE 0x21
___ds18b20_scratch_pad:
	.BYTE 0x9
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
_code_rus:
	.BYTE 0x42
_code_byte_lcd:
	.BYTE 0x42

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	IN   R5,22
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R18
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R21
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R20
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL __CWD1
	CALL __PUTPARD1
	MOV  R26,R20
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL __CWD1
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
SUBOPT_0x2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	__POINTW1FN _0x0,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _get_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	CALL _get_prev_key_status
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	__GETD1N 0xDF
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _lcd_puts
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x15:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDD  R30,Y+42
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_w_time)
	SBCI R31,HIGH(-_w_time)
	LD   R21,Z
	MUL  R16,R26
	MOVW R30,R0
	__ADDW1MN _w_time,1
	LD   R20,Z
	MUL  R16,R26
	MOVW R30,R0
	__ADDW1MN _w_time,2
	LD   R30,Z
	STD  Y+10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1C:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1D:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _set_values

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD1S 35
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDI  R31,0
	ASR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(204)
	ST   -Y,R30
	JMP  _therm_write_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__DELAY_USB 3
	SBI  0x15,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	CBI  0x15,2
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	SBI  0x15,2
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _s_read_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	CALL _s_write_byte
	LDI  R31,0
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2E:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2F:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x30:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __ADDF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x37:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x38:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x37
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x37
	__GETD1N 0x41200000
	CALL __MULF12
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x30
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x3A
	CALL __MULF12
	RCALL SUBOPT_0x2F
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x46:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x47:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x48:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x49:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4A:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4C:
	RCALL SUBOPT_0x47
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4E:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x4A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x50:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x33
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x57:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5A:
	CALL __long_delay_G102
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5C:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5E:
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5F:
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	RJMP _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	__PUTD1S 6
	RET


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
	BRVS __ADDF1211
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
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
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

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
