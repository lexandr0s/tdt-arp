/**************************************************************
 * Copyright (C) 2010   STMicroelectronics. All Rights Reserved.
 * This file is part of the latest release of the Multicom4 project. This release 
 * is fully functional and provides all of the original MME functionality.This 
 * release  is now considered stable and ready for integration with other software 
 * components.

 * Multicom4 is a free software; you can redistribute it and/or modify it under the 
 * terms of the GNU General Public License as published by the Free Software Foundation 
 * version 2.

 * Multicom4 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License along with Multicom4; 
 * see the file COPYING.  If not, write to the Free Software Foundation, 59 Temple Place - 
 * Suite 330, Boston, MA 02111-1307, USA.

 * Written by Multicom team at STMicroelectronics in November 2010.  
 * Contact multicom.support@st.com. 
**************************************************************/

/*
 *
 */

#ifndef __STB7109REG_H
#define __STB7109REG_H

#include "sh4regtype.h"

/*----------------------------------------------------------------------------*/

/*
 * Peripheral versions
 */

#ifndef ST40_LMI_VERSION
#define ST40_LMI_VERSION 3
#endif

/*----------------------------------------------------------------------------*/

/*
 * Base addresses for control register banks.
 *
 * Define STB7109_MOVE_LMI_REGS to 0 in order to keep the LMI configuration
 * registers at their reset addresses (by default the connection scripts and
 * bootstrap memory initialisations will move these registers to their area 6
 * addresses). Note this cannot be done for pre cut 3.0 silicon.
 */

/* Area 6 on-chip peripherals base */
#ifndef STB7109_AREA6_PERIPH_BASE
#define STB7109_AREA6_PERIPH_BASE 0xb8000000
#endif

#ifndef STB7109_MOVE_LMI_REGS
#define STB7109_MOVE_LMI_REGS 1
#endif

/* Generic SH4 control registers */
#ifndef SH4_TMU_REGS_BASE
#define SH4_TMU_REGS_BASE 0xffd80000
#endif
#ifndef SH4_RTC_REGS_BASE
#define SH4_RTC_REGS_BASE 0xffc80000
#endif

/* Common ST40 control registers */
#ifndef ST40_CPG_REGS_BASE
#define ST40_CPG_REGS_BASE 0xffc00000
#endif
#ifndef ST40_INTC_REGS_BASE
#define ST40_INTC_REGS_BASE 0xffd00000
#endif
#ifndef ST40_SCIF2_REGS_BASE
#define ST40_SCIF2_REGS_BASE 0xffe80000
#endif

#ifndef ST40_ILC_REGS_BASE
#define ST40_ILC_REGS_BASE STB7109_AREA6_PERIPH_BASE
#endif
#ifndef ST40_INTC2_REGS_BASE
#define ST40_INTC2_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01001300)
#endif

/* STb7109 control registers */
#ifndef STB7109_SYSCONF_REGS_BASE
#define STB7109_SYSCONF_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01001000)
#endif

#ifndef STB7109_CLOCKGENA_REGS_BASE
#define STB7109_CLOCKGENA_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01213000)
#endif

#ifndef STB7109_STBUS_NODE01_REGS_BASE
#define STB7109_STBUS_NODE01_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01216000)
#endif
#ifndef STB7109_STBUS_NODE04_REGS_BASE
#define STB7109_STBUS_NODE04_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01216200)
#endif
#ifndef STB7109_STBUS_NODE05_REGS_BASE
#define STB7109_STBUS_NODE05_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x0120d200)
#endif
#ifndef STB7109_STBUS_NODE09_REGS_BASE
#define STB7109_STBUS_NODE09_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x0120d000)
#endif
#ifndef STB7109_STBUS_NODE11_REGS_BASE
#define STB7109_STBUS_NODE11_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01243000)
#endif

/* System Architecture Volume 2: Bus Interfaces */
#ifndef ST40_LMISYS_REGS_BASE
#if STB7109_MOVE_LMI_REGS
#define ST40_LMISYS_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x02800000)
#else
#define ST40_LMISYS_REGS_BASE 0xaf000000
#endif
#endif
#ifndef ST40_LMIVID_REGS_BASE
#if STB7109_MOVE_LMI_REGS
#define ST40_LMIVID_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x03000000)
#else
#define ST40_LMIVID_REGS_BASE 0xb7000000
#endif
#endif
#ifndef ST40_EMI_REGS_BASE
#define ST40_EMI_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x02100000)
#endif

/* System Architecture Volume 4: I/O Devices */
#ifndef ST40_PIO0_REGS_BASE
#define ST40_PIO0_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00020000)
#endif
#ifndef ST40_PIO1_REGS_BASE
#define ST40_PIO1_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00021000)
#endif
#ifndef ST40_PIO2_REGS_BASE
#define ST40_PIO2_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00022000)
#endif
#ifndef ST40_PIO3_REGS_BASE
#define ST40_PIO3_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00023000)
#endif
#ifndef ST40_PIO4_REGS_BASE
#define ST40_PIO4_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00024000)
#endif
#ifndef ST40_PIO5_REGS_BASE
#define ST40_PIO5_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00025000)
#endif
#ifndef ST40_ASC0_REGS_BASE
#define ST40_ASC0_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00030000)
#endif
#ifndef ST40_ASC1_REGS_BASE
#define ST40_ASC1_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00031000)
#endif
#ifndef ST40_ASC2_REGS_BASE
#define ST40_ASC2_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00032000)
#endif
#ifndef ST40_ASC3_REGS_BASE
#define ST40_ASC3_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00033000)
#endif
#ifndef ST40_SSC0_REGS_BASE
#define ST40_SSC0_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00040000)
#endif
#ifndef ST40_SSC1_REGS_BASE
#define ST40_SSC1_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00041000)
#endif
#ifndef ST40_SSC2_REGS_BASE
#define ST40_SSC2_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x00042000)
#endif
#ifndef ST40_MAILBOX0_REGS_BASE
#define ST40_MAILBOX0_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01211000)
#endif
#ifndef ST40_MAILBOX1_REGS_BASE
#define ST40_MAILBOX1_REGS_BASE (STB7109_AREA6_PERIPH_BASE + 0x01212000)
#endif

/*----------------------------------------------------------------------------*/

#include "st40reg.h"

/*
 * STb7109 control registers
 */

/* Clock Generator control registers (STb7109 variant) */
#define STB7109_CLOCKGENA_LOCK SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x00)
#define STB7109_CLOCKGENA_MD_STATUS SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x04)
#define STB7109_CLOCKGENA_PLL0_CFG SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x08)
#define STB7109_CLOCKGENA_PLL0_STATUS SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x10)
#define STB7109_CLOCKGENA_PLL0_CLK1_CTRL SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x14)
#define STB7109_CLOCKGENA_PLL0_CLK2_CTRL SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x18)
#define STB7109_CLOCKGENA_PLL0_CLK3_CTRL SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x1c)
#define STB7109_CLOCKGENA_PLL0_CLK4_CTRL SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x20)
#define STB7109_CLOCKGENA_PLL1_CFG SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x24)
#define STB7109_CLOCKGENA_PLL1_STATUS SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x2c)
#define STB7109_CLOCKGENA_CLK_DIV SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x30)
#define STB7109_CLOCKGENA_CLOCK_ENABLE SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x34)
#define STB7109_CLOCKGENA_OUT_CTRL SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x38)
#define STB7109_CLOCKGENA_PLL1_BYPASS SH4_DWORD_REG(STB7109_CLOCKGENA_REGS_BASE + 0x3c)

/* System configuration registers (STb7109 variant) */
#define STB7109_SYSCONF_DEVICEID_0 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0000)
#define STB7109_SYSCONF_DEVICEID_1 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0004)
#define STB7109_SYSCONF_DEVICEID SH4_GWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0000)
#define STB7109_SYSCONF_SYS_STA00 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0008)
#define STB7109_SYSCONF_SYS_STA01 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x000c)
#define STB7109_SYSCONF_SYS_STA02 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0010)
#define STB7109_SYSCONF_SYS_STA03 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0014)
#define STB7109_SYSCONF_SYS_STA04 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0018)
#define STB7109_SYSCONF_SYS_STA05 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x001c)
#define STB7109_SYSCONF_SYS_STA06 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0020)
#define STB7109_SYSCONF_SYS_STA07 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0024)
#define STB7109_SYSCONF_SYS_STA08 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0028)
#define STB7109_SYSCONF_SYS_STA09 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x002c)
#define STB7109_SYSCONF_SYS_STA10 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0030)
#define STB7109_SYSCONF_SYS_STA11 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0034)
#define STB7109_SYSCONF_SYS_STA12 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0038)
#define STB7109_SYSCONF_SYS_STA13 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x003c)
#define STB7109_SYSCONF_SYS_STA14 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0040)
#define STB7109_SYSCONF_SYS_STA15 SH4_DWORD_REG(STB7100_SYSCONF_REGS_BASE + 0x0044)
#define STB7109_SYSCONF_SYS_CFG00 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0100)
#define STB7109_SYSCONF_SYS_CFG01 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0104)
#define STB7109_SYSCONF_SYS_CFG02 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0108)
#define STB7109_SYSCONF_SYS_CFG03 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x010c)
#define STB7109_SYSCONF_SYS_CFG04 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0110)
#define STB7109_SYSCONF_SYS_CFG05 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0114)
#define STB7109_SYSCONF_SYS_CFG06 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0118)
#define STB7109_SYSCONF_SYS_CFG07 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x011c)
#define STB7109_SYSCONF_SYS_CFG08 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0120)
#define STB7109_SYSCONF_SYS_CFG09 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0124)
#define STB7109_SYSCONF_SYS_CFG10 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0128)
#define STB7109_SYSCONF_SYS_CFG11 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x012c)
#define STB7109_SYSCONF_SYS_CFG12 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0130)
#define STB7109_SYSCONF_SYS_CFG13 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0134)
#define STB7109_SYSCONF_SYS_CFG14 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0138)
#define STB7109_SYSCONF_SYS_CFG15 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x013c)
#define STB7109_SYSCONF_SYS_CFG16 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0140)
#define STB7109_SYSCONF_SYS_CFG17 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0144)
#define STB7109_SYSCONF_SYS_CFG18 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0148)
#define STB7109_SYSCONF_SYS_CFG19 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x014c)
#define STB7109_SYSCONF_SYS_CFG20 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0150)
#define STB7109_SYSCONF_SYS_CFG21 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0154)
#define STB7109_SYSCONF_SYS_CFG22 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0158)
#define STB7109_SYSCONF_SYS_CFG23 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x015c)
#define STB7109_SYSCONF_SYS_CFG24 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0160)
#define STB7109_SYSCONF_SYS_CFG25 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0164)
#define STB7109_SYSCONF_SYS_CFG26 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0168)
#define STB7109_SYSCONF_SYS_CFG27 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x016c)
#define STB7109_SYSCONF_SYS_CFG28 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0170)
#define STB7109_SYSCONF_SYS_CFG29 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0174)
#define STB7109_SYSCONF_SYS_CFG30 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0178)
#define STB7109_SYSCONF_SYS_CFG31 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x017c)
#define STB7109_SYSCONF_SYS_CFG32 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0180)
#define STB7109_SYSCONF_SYS_CFG33 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0184)
#define STB7109_SYSCONF_SYS_CFG34 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0188)
#define STB7109_SYSCONF_SYS_CFG35 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x018c)
#define STB7109_SYSCONF_SYS_CFG36 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0190)
#define STB7109_SYSCONF_SYS_CFG37 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0194)
#define STB7109_SYSCONF_SYS_CFG38 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x0198)
#define STB7109_SYSCONF_SYS_CFG39 SH4_DWORD_REG(STB7109_SYSCONF_REGS_BASE + 0x019c)

/* STBUS control registers (STb7109 variant) */
#define STB7109_STBUS_NODE01_SH4_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x00)
#define STB7109_STBUS_NODE01_LX_DH_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x04)
#define STB7109_STBUS_NODE01_LX_AUD_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x08)
#define STB7109_STBUS_NODE01_SH4_I_LIMIT SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x24)
#define STB7109_STBUS_NODE01_LX_DH_I_LIMIT SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x28)
#define STB7109_STBUS_NODE01_LX_AUD_I_LIMIT SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x2c)
#define STB7109_STBUS_NODE01_N01_TARG_1_LMIVID_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x30)
#define STB7109_STBUS_NODE01_N01_TARG_2_LMISYS_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x34)
#define STB7109_STBUS_NODE01_N01_TARG_3_N04_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE01_REGS_BASE + 0x38)
#define STB7109_STBUS_NODE04_N01_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x00)
#define STB7109_STBUS_NODE04_N02_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x04)
#define STB7109_STBUS_NODE04_DH_I_0_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x08)
#define STB7109_STBUS_NODE04_DH_I_1_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x0c)
#define STB7109_STBUS_NODE04_N03_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x10)
#define STB7109_STBUS_NODE04_N04_TARG_1_LMIVID_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x50)
#define STB7109_STBUS_NODE04_N04_TARG_2_N11_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE04_REGS_BASE + 0x54)
#define STB7109_STBUS_NODE05_COMPO_I_GDP1LL_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x00)
#define STB7109_STBUS_NODE05_COMPO_I_GDP1DISP_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x04)
#define STB7109_STBUS_NODE05_COMPO_I_GDP2LL_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x08)
#define STB7109_STBUS_NODE05_COMPO_I_GDP2DISP_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x0c)
#define STB7109_STBUS_NODE05_COMPO_I_ALPLL_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x10)
#define STB7109_STBUS_NODE05_COMPO_I_ALPDISP_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x14)
#define STB7109_STBUS_NODE05_COMPO_I_CUR_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE05_REGS_BASE + 0x18)
#define STB7109_STBUS_NODE09_N08_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE09_REGS_BASE + 0x00)
#define STB7109_STBUS_NODE09_DIRT_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE09_REGS_BASE + 0x04)
#define STB7109_STBUS_NODE09_COMMS_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE09_REGS_BASE + 0x08)
#define STB7109_STBUS_NODE09_SATA_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE09_REGS_BASE + 0x0c)
#define STB7109_STBUS_NODE09_USB_I_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE09_REGS_BASE + 0x10)
#define STB7109_STBUS_NODE11_N05_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x00)
#define STB7109_STBUS_NODE11_N06_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x04)
#define STB7109_STBUS_NODE11_N07_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x08)
#define STB7109_STBUS_NODE11_N09_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x0c)
#define STB7109_STBUS_NODE11_N04_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x10)
#define STB7109_STBUS_NODE11_N11_TARG_1_N13_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x50)
#define STB7109_STBUS_NODE11_N11_TARG_2_N12_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x54)
#define STB7109_STBUS_NODE11_N11_TARG_3_AUDIO_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x58)
#define STB7109_STBUS_NODE11_N11_TARG_4_CFGREG_PRIORITY SH4_DWORD_REG(STB7109_STBUS_NODE11_REGS_BASE + 0x5c)

#endif /* __STB7109REG_H */
