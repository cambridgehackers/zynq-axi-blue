/*****************************************************************************
* Filename:          /home/oriol/MIT/projects/ZedBoard/project_bcl/project_bcl.srcs/sources_1/edk/module_bcl/drivers/bcl_glue_v1_00_a/src/bcl_glue.c
* Version:           1.00.a
* Description:       bcl_glue Driver Source File
* Date:              Mon Oct 15 17:26:59 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "bcl_glue.h"

/************************** Function Definitions ***************************/


/**
 *
 * User logic master module to send/receive word to/from remote system memory.
 * While sending, one word is read from user logic local FIFO and written to remote system memory.
 * While receiving, one word is read from remote system memory and written to user logic local FIFO.
 *
 * @param   BaseAddress is the base address of the BCL_GLUE device.
 * @param   Src/DstAddress is the destination system memory address from/to which the data will be fetched/stored.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void BCL_GLUE_MasterSendBytes(Xuint32 BaseAddress, Xuint32 DstAddress, int Size)
{
  int LsbSize;
  int MsbSize;

  LsbSize = (Xuint16)Size;
  MsbSize = (Xuint8)(Size >> 16);
  /*
   * Set user logic master control register for write transfer.
   */
  Xil_Out8(BaseAddress+BCL_GLUE_MST_CNTL_REG_OFFSET, MST_BRWR);

  /*
   * Set user logic master address register to drive IP2Bus_Mst_Addr signal.
   */
  Xil_Out32(BaseAddress+BCL_GLUE_MST_ADDR_REG_OFFSET, DstAddress);

  /*
   * Set user logic master byte enable register to drive IP2Bus_Mst_BE signal.
   */
  Xil_Out16(BaseAddress+BCL_GLUE_MST_BE_REG_OFFSET, 0xFFFF);

  /*
   * Set user logic master length register.
  */
  Xil_Out16(BaseAddress+BCL_GLUE_LSB_MST_LEN_REG_OFFSET, LsbSize);

  Xil_Out8(BaseAddress+BCL_GLUE_MSB_MST_LEN_REG_OFFSET, MsbSize);

  /*
   * Start user logic master write transfer by writting special pattern to its go port.
   */
  Xil_Out8(BaseAddress+BCL_GLUE_MST_GO_PORT_OFFSET, MST_START);
}

void BCL_GLUE_MasterRecvBytes(Xuint32 BaseAddress, Xuint32 SrcAddress, int Size)
{
  int LsbSize;
  int MsbSize;

  LsbSize = (Xuint16)Size;
  MsbSize = (Xuint8)(Size >> 16);
  /*
   * Set user logic master control register for read transfer.
   */
  Xil_Out8(BaseAddress+BCL_GLUE_MST_CNTL_REG_OFFSET, MST_BRRD);

  /*
   * Set user logic master address register to drive IP2Bus_Mst_Addr signal.
   */
  Xil_Out32(BaseAddress+BCL_GLUE_MST_ADDR_REG_OFFSET, SrcAddress);

  /*
   * Set user logic master byte enable register to drive IP2Bus_Mst_BE signal.
   */
  Xil_Out16(BaseAddress+BCL_GLUE_MST_BE_REG_OFFSET, 0xFFFF);

  /*
   * Set user logic master length register.
  */
  Xil_Out16(BaseAddress+BCL_GLUE_LSB_MST_LEN_REG_OFFSET, LsbSize);

  Xil_Out8(BaseAddress+BCL_GLUE_MSB_MST_LEN_REG_OFFSET, MsbSize);

  /*
   * Start user logic master read transfer by writting special pattern to its go port.
   */
  Xil_Out8(BaseAddress+BCL_GLUE_MST_GO_PORT_OFFSET, MST_START);
}

